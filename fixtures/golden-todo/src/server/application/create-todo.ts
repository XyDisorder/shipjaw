import { assertTodoTitle } from "../domain/todo";
import { ValidationError } from "../domain/errors";
import type { TodoRepository } from "./ports/todo-repository";

export function createTodo(repo: TodoRepository) {
  return async (rawTitle: string) => {
    try {
      const title = assertTodoTitle(rawTitle);
      return await repo.create(title);
    } catch {
      throw new ValidationError("Title is required");
    }
  };
}
