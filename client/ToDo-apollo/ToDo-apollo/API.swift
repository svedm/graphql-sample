//  This file was automatically generated and should not be edited.

import Apollo

public struct ToDoTaskInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: String) {
    graphQLMap = ["name": name]
  }

  /// Task name
  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }
}

public final class AddTaskMutation: GraphQLMutation {
  /// mutation AddTask($task: ToDoTaskInput!) {
  ///   add(task: $task) {
  ///     __typename
  ///     id
  ///     name
  ///   }
  /// }
  public let operationDefinition =
    "mutation AddTask($task: ToDoTaskInput!) { add(task: $task) { __typename id name } }"

  public let operationName = "AddTask"

  public var task: ToDoTaskInput

  public init(task: ToDoTaskInput) {
    self.task = task
  }

  public var variables: GraphQLMap? {
    return ["task": task]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("add", arguments: ["task": GraphQLVariable("task")], type: .object(Add.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(add: Add? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "add": add.flatMap { (value: Add) -> ResultMap in value.resultMap }])
    }

    public var add: Add? {
      get {
        return (resultMap["add"] as? ResultMap).flatMap { Add(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "add")
      }
    }

    public struct Add: GraphQLSelectionSet {
      public static let possibleTypes = ["ToDoTask"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(Int.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, name: String) {
        self.init(unsafeResultMap: ["__typename": "ToDoTask", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Task identifier
      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// Task name
      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class RemoveTaskMutation: GraphQLMutation {
  /// mutation RemoveTask($id: Int!) {
  ///   remove(id: $id) {
  ///     __typename
  ///     id
  ///     name
  ///   }
  /// }
  public let operationDefinition =
    "mutation RemoveTask($id: Int!) { remove(id: $id) { __typename id name } }"

  public let operationName = "RemoveTask"

  public var id: Int

  public init(id: Int) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("remove", arguments: ["id": GraphQLVariable("id")], type: .object(Remove.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(remove: Remove? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "remove": remove.flatMap { (value: Remove) -> ResultMap in value.resultMap }])
    }

    public var remove: Remove? {
      get {
        return (resultMap["remove"] as? ResultMap).flatMap { Remove(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "remove")
      }
    }

    public struct Remove: GraphQLSelectionSet {
      public static let possibleTypes = ["ToDoTask"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(Int.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, name: String) {
        self.init(unsafeResultMap: ["__typename": "ToDoTask", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Task identifier
      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// Task name
      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}

public final class ToDoListQuery: GraphQLQuery {
  /// query ToDoList {
  ///   toDoList {
  ///     __typename
  ///     id
  ///     name
  ///   }
  /// }
  public let operationDefinition =
    "query ToDoList { toDoList { __typename id name } }"

  public let operationName = "ToDoList"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("toDoList", type: .nonNull(.list(.nonNull(.object(ToDoList.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(toDoList: [ToDoList]) {
      self.init(unsafeResultMap: ["__typename": "Query", "toDoList": toDoList.map { (value: ToDoList) -> ResultMap in value.resultMap }])
    }

    public var toDoList: [ToDoList] {
      get {
        return (resultMap["toDoList"] as! [ResultMap]).map { (value: ResultMap) -> ToDoList in ToDoList(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ToDoList) -> ResultMap in value.resultMap }, forKey: "toDoList")
      }
    }

    public struct ToDoList: GraphQLSelectionSet {
      public static let possibleTypes = ["ToDoTask"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(Int.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, name: String) {
        self.init(unsafeResultMap: ["__typename": "ToDoTask", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Task identifier
      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// Task name
      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}
