import type { Todo } from "../domain/todo";
import type { TodoRepository } from "../application/ports/todo-repository";

export class MemoryTodoRepository implements TodoRepository {
  private items: Todo[] = [];

  async list(): Promise<Todo[]> {
    return [...this.items];
  }

  async create(title: string): Promise<Todo> {
    const todo: Todo = {
      id: String(this.items.length + 1),
      title,
      createdAt: new Date(0).toISOString(),
    };
    this.items.push(todo);
    return todo;
  }
}
