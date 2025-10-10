## The Stack before a buffer overflow
```
 High Memory Addresses 0xfff... (Stack Bottom)
  ^
  |
+---------------------+
| Function Arguments  |
+---------------------+
| Saved EIP           | <-- The `CALL` instruction places the return address here.
| (Return Address)    |
+---------------------+
| Saved EBP           | <-- The function prologue (`push ebp`) places the old base pointer here.
+---------------------+ <-- EBP (Base Pointer register) points here as a stable reference.
|                     |
| Local Variables     | <-- The Buffer and other local variables are allocated here.
| (The Buffer)        |
|                     |
+---------------------+ <-- ESP (Stack Pointer register) points here, to the "top" of the stack.
  |
  V
  Low Memory Addresses 0x0000... (Stack Top)
```

---

## The stack after a buffer overflow (JMP ESP)
```
         THE STACK                                     A SHARED LIBRARY (e.g., libc.so)
+---------------------------+                         +---------------------------------+
|      ...                  |                         |         ...                     |
|      NOP Sled             | <----- (Step 2) ----+   |         (Executable Code)       |
|      SHELLCODE            |       Jumps here    |   |                                 |
+---------------------------+                     |   |                                 |
| Address of JMP ESP        | ---+                |   |  0xff77aabb:  JMP ESP           |
| (e.g., 0xff77aabb)        |    |                |   |  (The actual instruction lives  |
+---------------------------+    | (Step 1)       |   |   here in an executable part    |
| (Overwritten EBP)         |    | Jumps here     +-->|   of memory.)                   |
+---------------------------+    |                    |                                 |
|      Buffer filled        |    |                    |                                 |
|      with 'A's            |    |                    |                                 |
+---------------------------+    |                    |                                 |
  (Low Memory Addresses)         |                    +---------------------------------+
                                 |
                                 |
      Vulnerable function executes `RET` instruction,
      reading the address from the stack.
```

### Step 1: The RET to the Library

- When the vulnerable function executes its RET (return) instruction, it pops the address you overwrote (0xff77aabb) off the stack and into the EIP (Instruction Pointer) register.

- The CPU's execution flow is immediately redirected to that address, which is inside a shared library.

### Step 2: The JMP ESP back to the Stack

- The CPU now executes the instruction at 0xff77aabb, which is JMP ESP.

- This instruction tells the CPU to change EIP again, this time to whatever address the Stack Pointer (ESP) is holding.

- At this exact moment, ESP is pointing to the location on the stack right after the return address—the start of your NOP sled.

- Execution jumps back to your shellcode on the stack, which then runs.
