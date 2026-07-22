export const TODO_TITLE_MAX = 120;

export const TodoListFilter = {
  All: "all",
  Active: "active",
} as const;

export type TodoListFilter =
  (typeof TodoListFilter)[keyof typeof TodoListFilter];
