using GraphQL.Server;
using GraphQL.Server.Ui.Playground;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using GraphQL.Server.Transports.AspNetCore;
using GraphQL.Types;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;
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

            services.AddSingleton<ToDoTaskStore>();
            services.AddSingleton<ToDoTaskQuery>();
            services.AddSingleton<ToDoTaskMutation>();
            services.AddSingleton<ToDoTaskType>();
            services.AddSingleton<ToDoTaskInputType>();

            services.AddSingleton<ISchema, ToDoSchema>();
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services
                .AddGraphQL(g =>
                {
                    g.EnableMetrics = true;
                })
                .AddSystemTextJson();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }


            // add http for Schema at default url /graphql
            app.UseGraphQL<ISchema, GraphQLHttpMiddleware<ISchema>>("/graphql");

            // use graphql-playground at default url /ui/playground
            app.UseGraphQLPlayground(new GraphQLPlaygroundOptions
            {
                Path = "/"
            });
        }
    }
}
