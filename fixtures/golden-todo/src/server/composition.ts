import { createTodo } from "./application/create-todo";
import { MemoryTodoRepository } from "./infrastructure/memory-todo-repository";

const repo = new MemoryTodoRepository();

export const createTodoUseCase = createTodo(repo);

export async function listTodos() {
  return repo.list();
}
