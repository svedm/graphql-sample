//
//  ToDoTableViewController.swift
//  ToDo-apollo
//
//  Created by Svetoslav Karasev on 21/11/2018.
//  Copyright © 2018 Svedm. All rights reserved.
//

import UIKit
import Apollo

class ToDoTableViewController: UITableViewController {
    private var data: [ToDoListQuery.Data.ToDoList] = []
    private let apollo = ApolloClient(url: URL(string: "http://localhost:5000/graphql")!)

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    private func loadData(_ completion: (() -> Void)? = nil) {
        apollo.fetch(query: ToDoListQuery()) { result in
            switch result {
                case .success(let response):
                    guard let list = response.data?.toDoList else { return print("Empty data") }

                    self.data = list
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
            }
            completion?()
        }
    }

    @IBAction func addNew(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "New task", message: "Enter task name", preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            guard let text = controller.textFields?.first?.text else { return }

            self.apollo.perform(mutation: AddTaskMutation(task: ToDoTaskInput(name: text))) { result in
                switch result {
                    case .success(let response):
                        guard let task = response.data?.add else { return }

                        self.data.append(ToDoListQuery.Data.ToDoList(id: task.id, name: task.name))
                        self.tableView.insertRows(at: [IndexPath(item: self.data.count - 1, section: 0)], with: .left)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
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
        apollo.perform(mutation: RemoveTaskMutation(id: data[indexPath.item].id)) { result in
            switch result {
                case .success(let response):
                    guard response.data?.remove != nil else { return }

                    self.data.remove(at: indexPath.item)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        loadData() {
            sender.endRefreshing()
        }
    }
}
