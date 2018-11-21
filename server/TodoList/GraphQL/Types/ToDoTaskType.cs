using GraphQL.Types;
using TodoList.Models;

namespace TodoList.GraphQL.Types
{
    public class ToDoTaskType : ObjectGraphType<ToDoTask>
    {
        public ToDoTaskType()
        {
            Name = "ToDoTask";
            Field(f => f.Id).Description("Task identifier");
            Field(f => f.Name).Description("Task name");
        }
    }
}