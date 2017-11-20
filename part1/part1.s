	# Code is data.
	# Specify that the following data goes in the __TEXT,__text section.
	# Also, specify that the data is regular code.
	.section	__TEXT,__text,regular,pure_instructions

	# Like the previous ".section" directive, this isn't actual code.
	# It's just a directive that tells the assembler what the minimum supported macOS environment is.
	.macosx_version_min 10, 12

	# Here's another assembler directive which declares the start of a global piece of data called "_main".
	.globl	_main

	# Align this data to a power of 2, namely 2^4 = 16. That means the address of _main is divisible by 16.
	# The assembler will inject padding bytes (equal to 0x90) to make that happen.
	# Note: 0x90 is a 1-byte encoding of a NO-OP (or NOP) instruction.
	.p2align	4, 0x90

# This is a label. Labels have names and addresses. They point to data (code) in memory.
_main:
	# This is the function prologue.

	# Push the frame pointer to the stack.
	# The frame pointer is used to find frame-local variables.
	# The 'q' suffix to 'push' means '64-bit' (or quadword). These are 64-bit registers.
	pushq	%rbp

	# Set the frame pointer equal to the stack pointer.
	# Subtracting from the stack pointer extends the size of a frame.
	movq	%rsp, %rbp

	# Push a bunch of registers to the stack to preserve them for the caller.
	# The set of registers to preserve is defined by a calling convention: this uses the System V AMD64 ABI.
	# QUESTION: What calls _main?
	#
	# These registers are popped off the stack in the function epilogue. That restores the register values for the caller.
	# QUESTION: If a register is pushed in the function prologue and popped in the epilogue, where can you use it?
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	pushq	%rax

	movq	%rsi, %rbx    # Copy the "argv" pointer from %rsi to %rbx.
	xorl	%r14d, %r14d  # Clear the "sum" variable. Note: %r14d = %r14d XOR %r14d, which is always 0.
	cmpl	$2, %edi      # Compare 2 against "argc".
	jl	LBB0_3        # If "argc" is less than 2, exit the loop.

	movl	%edi, %r15d   # Move "argc" to %r15d.
	addq	$8, %rbx      # Advance the "argv" pointer, so we're at argv[1].
	decq	%r15          # Decrement "argc".
	xorl	%r14d, %r14d  # Clear %r14d again: this is mysterious, because we cleared it earlier. Perhaps it's related to padding.

	# Insert padding bytes so the loop will start at an aligned address.
	.p2align	4, 0x90

# This is a label which points to the "core" of the loop.
LBB0_2:
	movq	(%rbx), %rdi  # Load from "argv[i]" and store the pointer into %rdi.
	callq	_atoi         # Call _atoi to convert the string pointed-to by %rdi to an integer.
	addl	%eax, %r14d   # _atoi returns an integer in %eax. Add it to the sum in %r14d.
	addq	$8, %rbx      # Advance the "argv" pointer.
	decq	%r15          # Decrement "argc".
	jne	LBB0_2        # Jump to the start of the loop if "argc" isn't 0.
LBB0_3:
	movl	%r14d, %eax   # Move the sum to %eax.

	# QUESTION: Why do we add 8 to the stack pointer here?
	# HINT: Count the number of pushes and pops!
	addq	$8, %rsp

	# QUESTION: Why is %rax pushed in the prologue, but not popped in the epilogue?
	# QUESTION: Why are registers popped in reverse order?
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp

	# Jump back to the caller (i.e "return").
	# QUESTION: Where is the return address stored?
	# HINT: See https://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64.
	retq

# This directive says that each symbol starts its own block of code. It's used for aggressive dead-stripping.
# This becomes important when programs get bigger.
.subsections_via_symbols
