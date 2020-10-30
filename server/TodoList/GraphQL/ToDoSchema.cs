using System;
using GraphQL.Types;
using Microsoft.Extensions.DependencyInjection;
using TodoList.GraphQL.Mutations;
using TodoList.GraphQL.Queries;

namespace TodoList.GraphQL
{
    public class ToDoSchema : Schema
    {
        public ToDoSchema(IServiceProvider provider) : base(provider)
        {
            Query = provider.GetRequiredService<ToDoTaskQuery>();
            Mutation = provider.GetRequiredService<ToDoTaskMutation>();
        }
    }
}