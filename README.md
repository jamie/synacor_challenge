# Synacor Challenge

This repository holds a copy of the architecture specification and challenge binary from the Synacor Challenge as presented at OSCON 2012. It was [created by Eric Wastl](https://www.reddit.com/r/programming/comments/1ceou7/i_made_a_programming_challenge_for_oscon_at_work/), and while no longer available at [the Synacor website](https://challenge.synacor.com/) it was preserved by [Aneurysm9](https://github.com/Aneurysm9/vm_challenge) here for historical and educational purposes.

## Codes

Included are MD5 hashes of the eight codes produced by this instance of the challenge for use in testing implementations of the architecture.  These codes can be validated as follows, replacing the quoted string with the code to test:

```console
$ echo -n "<Code Here>" | md5sum
6fcd818224b42f563e10b91b4f2a5ae8  -
```

- `76ec2408e8fe3f1753c25db51efd8eb3`
- `0e6aa7be1f68d930926d72b3741a145c`
- `7997a3b2941eab92c1c0345d5747b420`
- `186f842951c0dcfe8838af1e7222b7d4`
- `2bf84e54b95ce97aefd9fc920451fc45`
- `e09640936b3ef532b7b8e83ce8f125f4`
- `4873cf6b76f62ac7d5a53605b2535a0c`
- `d0c54d4ed7f943280ce3e19532dbb1a6`

## Spec

---

### Synacor OSCON 2012 Challenge

In this challenge, your job is to use this architecture spec to create a virtual machine capable of running the included binary.  Along the way, you will find codes; submit these to the challenge website to track your progress.  Good luck!

### architecture

- three storage regions
  - memory with 15-bit address space storing 16-bit values
  - eight registers
  - an unbounded stack which holds individual 16-bit values
- all numbers are unsigned integers 0..32767 (15-bit)
- all math is modulo 32768; 32758 + 15 => 5

### binary format

- each number is stored as a 16-bit little-endian pair (low byte, high byte)
- numbers 0..32767 mean a literal value
- numbers 32768..32775 instead mean registers 0..7
- numbers 32776..65535 are invalid
- programs are loaded into memory starting at address 0
- address 0 is the first 16-bit value, address 1 is the second 16-bit value, etc

### execution

- After an operation is executed, the next instruction to read is immediately after the last argument of the current operation.  If a jump was performed, the next operation is instead the exact destination of the jump.
- Encountering a register as an operation argument should be taken as reading from the register or setting into the register as appropriate.

### hints

- Start with operations 0, 19, and 21.
- Here's a code for the challenge website: `LDOb7UGhTi`
- The program "9,32768,32769,4,19,32768" occupies six memory addresses and should:
  - Store into register 0 the sum of 4 and the value contained in register 1.
  - Output to the terminal the character with the ascii code contained in register 0.

### opcode listing

| Op | Code | Description |
|---|---|---|
| **halt** | `0` | stop execution and terminate the program |
| **set** | `1 a b` | set register `a` to the value of `b` |
| **push** | `2 a` | push `a` onto the stack |
| **pop** | `3 a` | remove the top element from the stack and write it into `a`; empty stack = error |
| **eq** | `4 a b c` | set `a` to 1 if `b` is equal to `c`; set it to 0 otherwise |
| **gt** | `5 a b c` | set `a` to 1 if `b` is greater than `c`; set it to 0 otherwise |
| **jmp** | `6 a` | jump to `a` |
| **jt** | `7 a b` | if `a` is nonzero, jump to `b` |
| **jf** | `8 a b` | if `a` is zero, jump to `b` |
| **add** | `9 a b c` | assign into `a` the sum of `b` and `c` (modulo 32768) |
| **mult** | `10 a b c` | store into `a` the product of `b` and `c` (modulo 32768) |
| **mod** | `11 a b c` | store into `a` the remainder of `b` divided by `c` |
| **and** | `12 a b c` | stores into `a` the bitwise and of `b` and `c` |
| **or** | `13 a b c` | stores into `a` the bitwise or of `b` and `c` |
| **not** | `14 a b` | stores 15-bit bitwise inverse of `b` in `a` |
| **rmem** | `15 a b` | read memory at address `b` and write it to `a` |
| **wmem** | `16 a b` | write the value from `b` into memory at address `a` |
| **call** | `17 a` | write the address of the next instruction to the stack and jump to `a` |
| **ret** | `18` | remove the top element from the stack and jump to it; empty stack = halt |
| **out** | `19 a` | write the character represented by ascii code `a` to the terminal |
| **in** | `20 a` | read a character from the terminal and write its ascii code to `a`; it can be assumed that once input starts, it will continue until a newline is encountered; this means that you can safely read whole lines from the keyboard instead of having to figure out how to read individual characters |
| **noop** | `21` | no operation |
