# intro-to-asm

(WIP)

This project is designed to teach the basics of reading and writing x86_64
assembly. This is a fundamental skill which is used to figure out what programs
actually do. This comes in handy when debugging or analyzing security issues.

Prerequisites: Some CS background and familiarity with C. The examples may be
specific to macOS+x86_64/clang, but they should carry over to other platforms.

## Part 1

Read through part1.c. It's a program that converts its command line arguments
to integers and sums them up. The goal is to write a similar program in x86_64
assembly.

Compile part1.c:

$ clang -o part1 part1.c

Run it with some test inputs, like this:

  $ ./part1
  $ echo $?
  0
  $ ./part1 1
  $ echo $?
  1
  $ ./part1 1 2 3
  $ echo $?
  6

Now, use the compiler to show you the assembly for the program:

$ clang -O1 -fno-unwind-tables -S -o part1.s part1.c

The "-S" compiler flag means "emit human-readable assembly" (as opposed to an
object file). Typically the ".s" file extension is used for assembly.

Don't worry about what "-O1" or "-fno-unwind-tables" means. Briefly, these are
compiler flags which control the optimization level and disable stack unwinding
support. We're only using them to make the assembly easier to read.

Now, open up part1.s and skim through it:

$ cat part1.s

This is x86_64 assembly code. There is an annotated version of this file in
this repo in part1/part1.s.

The compiler is happy to assemble and link this code, turning it into an
executable. Try this:

$ clang -o part1-from-asm part1.s

The "part1-from-asm" binary should work exactly the same as the "part1" binary.
Make sure that it does!

### Exercises

1. Read through part1/part1.s and answer the questions marked "QUESTION".

2. Change the assembly so that it performs a running multiply instead of a
running sum. Then, compile it ("clang -o part1-mul part1-mul.s"), and test it.

3. You'll notice that the compiler got rid of the variable "i". Why is that?

# Suggested Resources

* Stack frame layout on x86_64
https://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64

* OSDev wiki page on calling conventions
http://wiki.osdev.org/Calling_Conventions
