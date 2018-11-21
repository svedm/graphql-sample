using GraphQL;
using GraphQL.Types;
using TodoList.GraphQL.Mutations;
using TodoList.GraphQL.Queries;

namespace TodoList.GraphQL
{
    public class ToDoSchema : Schema
    {
        public ToDoSchema(IDependencyResolver resolver) : base(resolver)
        {
            Query = resolver.Resolve<ToDoTaskQuery>();
            Mutation = resolver.Resolve<ToDoTaskMutation>();
        }
    }
}