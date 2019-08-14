//
//  ViewController.swift
//  ToDo-legacy
//
//  Created by Svetoslav Karasev on 21/11/2018.
//  Copyright © 2018 Svedm. All rights reserved.
//

import UIKit
import Legacy

struct GraphQL {
    struct Request: Encodable {
        var query: String
        var variables: [String: AnyEncodable]
    }

    struct Response<Model: Decodable>: Decodable {
        var data: Model
    }

    struct ServerError: Decodable {
        var errors: [Error]
    }

    struct Error: Swift.Error, Decodable {
        var message: String
    }
}

struct AnyEncodable: Encodable {
    let value: Encodable

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

enum ToDoNetworkError: Error {
    case network(NetworkError)
    case generic([GraphQL.Error])
}

protocol GraphQLClient {
    @discardableResult
    func request<T: Decodable>(
        query: String,
        variables: [String: AnyEncodable],
        completion: @escaping (Result<T, ToDoNetworkError>) -> Void
    ) -> NetworkTask
}

class GraphQLNetworkClient: GraphQLClient {
    private let defaultHeaders: [String: String]
    private let networkClient: CodableNetworkClient
    private let logger: TaggedLogger

    init(networkClient: CodableNetworkClient, logger: TaggedLogger, userAgent: String?) {
        self.networkClient = networkClient
        self.logger = logger
        if let userAgent = userAgent {
            defaultHeaders = [ "User-Agent": userAgent ]
        } else {
            defaultHeaders = [:]
        }
    }

    func request<T: Decodable>(
        query: String,
        variables: [String: AnyEncodable],
        completion: @escaping (Result<T, ToDoNetworkError>) -> Void
        ) -> NetworkTask {
        let request = GraphQL.Request(query: query, variables: variables)
        return networkClient.request(
            method: .post,
            path: "",
            parameters: [:],
            object: request,
            headers: defaultHeaders
        ) { (result: Result<GraphQL.Response<T>, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                switch error {
                case .badUrl, .auth:
                    completion(.failure(.network(error)))
                case .http(_, _, _, let data), .error(_, _, let data):
                    guard let data = data else { return completion(.failure(.network(error))) }

                    let decoder = JSONDecoder()
                    if let serverError = try? decoder.decode(GraphQL.ServerError.self, from: data) {
                        completion(.failure(.generic(serverError.errors)))
                    } else {
                        completion(.failure(.network(error)))
                    }
                }
            }
        }
    }
}

struct ToDoTask: Codable {
    var id: Int
    var name: String
}

struct ToDoTaskInput: Codable {
    var name: String
}

struct AddTaskResponse: Codable {
    var add: ToDoTask
}

struct RemoveTaskResponse: Codable {
    var remove: ToDoTask
}

struct ToDoList: Codable {
    var toDoList: [ToDoTask]
}

class ToDoTableViewController: UITableViewController {
    private var client: GraphQLClient!
    private let endpointURL = URL(string: "http://localhost:5000/graphql")!
    private let timeout: TimeInterval = 60
    private var data: [ToDoTask] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        loadData()
    }

    private func setup() {
        let logger = PrintLogger()
        client = networkClient(logger: logger)
    }

    private func networkClient(logger: Logger) -> GraphQLClient {
        let baseClient = BaseNetworkClient(
            http: apiHttp(logger: logger),
            baseURL: endpointURL,
            workQueue: .global(qos: .default),
            completionQueue: .main
        )
        let tag = String(describing: GraphQLNetworkClient.self)
        let taggedLogger = SimpleTaggedLogger(logger: logger, for: tag)
        return GraphQLNetworkClient(networkClient: baseClient, logger: taggedLogger, userAgent: nil)
    }

    private func apiHttp(logger: Logger) -> Http {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout * 2
        configuration.urlCache = nil

        let queue = DispatchQueue.global(qos: .default)
        let http = UrlSessionHttp(configuration: configuration, responseQueue: queue, logger: logger)
        return http
    }

    private func loadData(_ completion: (() -> Void)? = nil) {
        client.request(
            query: GraphQLConstants.toDoListQuery,
            variables: [:]
        ) { (result: Result<ToDoList, ToDoNetworkError>) in
            switch result {
                case .success(let data):
                    self.data = data.toDoList
                    self.tableView.reloadData()
                case .failure(let error):
                    switch error {
                        case .generic(let graphQLErrors):
                            graphQLErrors.forEach { print($0.message) }
                        case .network(let networkError):
                            print(networkError.localizedDescription)
                    }
            }
            completion?()
        }
    }

    @IBAction private func addNew(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "New task", message: "Enter task name", preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            guard let text = controller.textFields?.first?.text else { return }

            let params: [String: AnyEncodable] = [
                "task": AnyEncodable(value: ToDoTaskInput(name: text))
            ]

            self.client.request(
                query: GraphQLConstants.addTaskMutation,
                variables: params,
                completion: { (result: Result<AddTaskResponse, ToDoNetworkError>) in
                    switch result {
                        case .success(let data):
                            self.data.append(data.add)
                            self.tableView.insertRows(at: [IndexPath(item: self.data.count - 1, section: 0)], with: .left)
                        case .failure:
                            print("error")
                    }
                }
            )
        }))
        present(controller, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = data[indexPath.item].name

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let params: [String: AnyEncodable] = [
            "id": AnyEncodable(value: data[indexPath.item].id)
        ]

        self.client.request(
            query: GraphQLConstants.removeTaskMutation,
            variables: params,
            completion: { (result: Result<RemoveTaskResponse, ToDoNetworkError>) in
                switch result {
                case .success:
                    self.data.remove(at: indexPath.item)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure:
                    print("error")
                }
            }
        )
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        loadData() {
            sender.endRefreshing()
        }
    }

}
