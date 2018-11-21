using GraphQL.Types;
using TodoList.GraphQL.Types;
using TodoList.Models;

namespace TodoList.GraphQL.Mutations
{
    public class ToDoTaskMutation: ObjectGraphType {
        public ToDoTaskMutation(ToDoTaskStore taskStore)
        {
            Name = "Mutation";

            Field<ToDoTaskType>("add", arguments: new QueryArguments(
                new QueryArgument<NonNullGraphType<ToDoTaskInputType>> { Name = "task" }
            ), resolve: c => taskStore.AddAsync(c.GetArgument<ToDoTask>("task")));

            Field<ToDoTaskType>("remove", arguments: new QueryArguments(
                new QueryArgument<NonNullGraphType<IntGraphType>> {Name = "id", Description = "Task id"}
            ), resolve: c => taskStore.RemoveByIdAsync(c.GetArgument<int>("id")));
        }
    }
}