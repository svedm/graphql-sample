//
//  Generated code do not edit
//
//  GraphQLConstants.swift
//  Leem
//
//  Copyright © 2018 Svedm. All rights reserved.
//

enum GraphQLConstants {
    static let removeTaskMutation = """
mutation RemoveTask($id: Int!) {
    remove(id: $id) {
        id
        name
    }
}

"""
    static let addTaskMutation = """
mutation AddTask($task: ToDoTaskInput!) {
    add(task: $task) {
        id
        name
    }
}

"""
    static let toDoListQuery = """
query ToDoList {
    toDoList {
        id
        name
    }
}

"""
}