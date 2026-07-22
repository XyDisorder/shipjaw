import type { Todo } from "../../domain/todo";

export interface TodoRepository {
  list(): Promise<Todo[]>;
  create(title: string): Promise<Todo>;
}
