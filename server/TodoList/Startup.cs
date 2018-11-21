using GraphQL;
using GraphQL.Http;
using GraphQL.Server;
using GraphQL.Server.Ui.Playground;
using GraphQL.Types;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using TodoList.GraphQL;
using TodoList.GraphQL.Mutations;
using TodoList.GraphQL.Queries;
using TodoList.GraphQL.Types;

namespace TodoList
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSingleton<IDependencyResolver>(s => new FuncDependencyResolver(s.GetRequiredService));
            services.AddSingleton<IDocumentExecuter, DocumentExecuter>();
            services.AddSingleton<IDocumentWriter, DocumentWriter>();

            services.AddSingleton<ToDoTaskStore>();
            services.AddSingleton<ToDoTaskQuery>();
            services.AddSingleton<ToDoTaskMutation>();
            services.AddSingleton<ToDoTaskType>();
            services.AddSingleton<ToDoTaskInputType>();
            
            services.AddSingleton<ISchema, ToDoSchema>();

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddGraphQL(g =>
            {
                g.EnableMetrics = true;
                g.ExposeExceptions = true;
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }


            // add http for Schema at default url /graphql
            app.UseGraphQL<ISchema>("/graphql");

            // use graphql-playground at default url /ui/playground
            app.UseGraphQLPlayground(new GraphQLPlaygroundOptions
            {
                Path = "/"
            });
        }
    }
}
