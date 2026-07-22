export type Todo = {
  id: string;
  title: string;
  createdAt: string;
};

export function assertTodoTitle(title: string): string {
  const t = title.trim();
  if (t.length === 0) {
    throw new Error("TitleRequired");
  }
  return t;
}
