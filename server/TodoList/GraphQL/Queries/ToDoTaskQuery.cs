using GraphQL.Types;
using TodoList.GraphQL.Types;

namespace TodoList.GraphQL.Queries
{
    public class ToDoTaskQuery : ObjectGraphType
    {
        public ToDoTaskQuery(ToDoTaskStore taskStore)
        {
            Name = "Query";
            Field<ToDoTaskType>("toDoTask", arguments: new QueryArguments(
                new QueryArgument<NonNullGraphType<IntGraphType>> { Name = "id", Description = "id of ToDoTask" }
            ), resolve: c => taskStore.GetByIdAsync(c.GetArgument<int>("id")));
            Field<NonNullGraphType<ListGraphType<NonNullGraphType<ToDoTaskType>>>>("toDoList",
                resolve: c => taskStore.GetListAsync());
        }
    }
}