"use server";

import { createTodoUseCase, listTodos } from "@/server/composition";
import { ValidationError } from "@/server/domain/errors";

export type ActionResult =
  | { ok: true }
  | { ok: false; message: string };

/** Thin adapter: validate surface → use-case → map errors. No SQL here. */
export async function createTodoAction(title: string): Promise<ActionResult> {
  try {
    await createTodoUseCase(title);
    return { ok: true };
  } catch (e) {
    if (e instanceof ValidationError) {
      return { ok: false, message: e.message };
    }
    return { ok: false, message: "Something went wrong" };
  }
}

export async function listTodosAction() {
  return listTodos();
}
