using GraphQL.Types;
using TodoList.Models;

namespace TodoList.GraphQL.Types
{
    public class ToDoTaskInputType: InputObjectGraphType<ToDoTask> {
        public ToDoTaskInputType()
        {
            Name = "ToDoTaskInput";
            Field(f => f.Name).Description("Task name");
        }
    }
}