# Regenerate: vhs assets/demo.tape   (run from repo root)
Output assets/demo.gif

Set Shell "zsh"
Set FontSize 18
Set Width 1200
Set Height 680
Set Theme "Dracula"
Set Padding 24
Set TypingSpeed 40ms

Type "echo 'fixtures/golden-todo — kept in sync with what shipjaw-build actually produces'"
Enter
Sleep 1.5s

Type "tree fixtures/golden-todo -L 2"
Enter
Sleep 3s

Type "cat fixtures/golden-todo/documentation/INDEX.md"
Enter
Sleep 4s

Type "./scripts/smoke-fixture.sh | tail -14"
Enter
Sleep 4s
