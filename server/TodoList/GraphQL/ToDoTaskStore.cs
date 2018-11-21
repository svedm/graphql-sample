using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TodoList.Models;

namespace TodoList.GraphQL
{
    public class ToDoTaskStore
    {
        private IList<ToDoTask> ToDoList { get; }

        public ToDoTaskStore()
        {
            ToDoList = new List<ToDoTask>
            {
                new ToDoTask
                {
                    Id = 0,
                    Name = "First"
                }
            };
        }

        public Task<IList<ToDoTask>> GetListAsync()
        {
            return Task.FromResult(ToDoList);
        }

        public Task<ToDoTask> GetByIdAsync(int id)
        {
            return Task.FromResult(ToDoList.First(x => x.Id == id));
        }

        public Task<ToDoTask> AddAsync(ToDoTask toDoTask) {
            toDoTask.Id = ToDoList.Count;
            ToDoList.Add(toDoTask);
            return Task.FromResult(toDoTask);
        }

        public Task<ToDoTask> RemoveByIdAsync(int id)
        {
            var item = ToDoList.First(x => x.Id == id);
            ToDoList.Remove(item);
            return Task.FromResult(item);
        }
    }
}