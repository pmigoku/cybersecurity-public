## Common Stack Layout
How many stack frames are designed

    Push elements onto stack -->        TOP OF STACK (Low Mem add)         <-- Pop elements off stack
                                      +-----------------+
                                      | Local variables | <---------- Stack pointer (ESP)
                                      +-----------------+
                 Current stack frame  | Saved EBP       | <---------- Frame pointer (EBP)
                                      +-----------------+
                                      | Return address  |
                                      +-----------------+
                                      | Parameters      |
                                      +-----------------+

                                      +-----------------+
                                      | Local variables |
                                      +-----------------+
                Calling stack frame  | Saved EBP       |
                                      +-----------------+
                                      | Return address  |
                                      +-----------------+
                                      | Parameters      |
                                      +-----------------+

                                      +-----------------+
                     Earlier frames   |                 |        |
                                      |                 |        | Increasing addresses
                                      |                 |        V
                                      +-----------------+
                                        (High mem add)


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
|      Shellcode            | <----- (Step 2) ----+   |         (Executable Code)       |
|      NOP Sled             |       Jumps here    |   |                                 |
+---------------------------+                     |   |                                 |
| Address of JMP ESP        | ---+                |   |  0xff77aabb:  JMP ESP           |
|      (0xff77aabb)         |    |                |   |  (The actual instruction lives  |
+---------------------------+    | (Step 1)       |   |   here in an executable part    |
| (Overwritten EBP)         |    | Jumps here     +-->|   of memory.)                   |
+---------------------------+    |                    |                                 |
|      Buffer filled        |    |                    |                                 |
|      with 'A's (upward)   |    |                    |                                 |
+---------------------------+    |                    |                                 |
  (Low Memory Addresses)         |                    +---------------------------------+
                                 |
                                 |
      Vulnerable function executes `RET` instruction,
      reading the address from the stack.
```
## The attack
1. The Overflow: The attacker sends the crafted payload to the program. The vulnerable function copies the payload into the buffer. Since the payload is larger than the buffer, it overwrites the stack all the way up to and including the return address.

2. The `RET` Instruction: The vulnerable function finishes its work and executes its `RET` (return) instruction. The CPU expects to find the original return address on the stack, but instead, it finds the attacker's address: `0xff77aabb`.

3. Jump 1 (To the Library): The `EIP` register (the Instruction Pointer) is now loaded with `0xff77aabb`. The CPU obediently jumps to this address, redirecting execution away from the program's intended path and into the shared library.

4. Jump 2 (Back to the Stack): The CPU executes the instruction at `0xff77aabb`, which is `JMP ESP`. This instruction tells the CPU to change `EIP` again, this time to the address currently held in the stack pointer (`ESP`). At this moment, `ESP` is pointing to the memory right after the return address, the start of the `NOP sled`.

5. Execution: The CPU's execution flow lands on the `NOP sled`, slides down the `\x90` instructions, and seamlessly runs into the shellcode. The attacker's code now runs with the same privileges as the vulnerable program.
