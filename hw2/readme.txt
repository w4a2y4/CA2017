CA2017 hw2 by b04902079甯芝蓶


# Implementation

1) operations:
	- Use 'beq' to perform 'if' statements.
	- Use 'add', 'sub', 'mut', 'div' to perform integer operations.
	- If input is invalid, jump to 'invalid', which write 'XXXX' to output_ascii.
	  Then jump to 'ret', which write output_ascii to the output file and quit.

2) itoa:
	- I wrote a subfunction 'loop', which is similar to the for loop in C
	- Registers:
		- $a0: the input integer
		- $a1: counter (set to 4 initially)
		- $t0: divider (set to constant 10)
		- $t1: the data to write
		- $v0: the address to write in
	- Flow:
		1. First, set $v0 to &(output_ascii)+3, which is the address of the 4th byte.
		2. Enter 'loop'.
		3. Let counter = counter - 1
		4. Let $t1 = $a0 % 10, $a0 = $a0 / 10
		   (Use $t0 as divider here)
		5. Convert $t1 to ascii ($t1 = $t1 + 48)
		6. Write byte from $t1 to the address stored in $v0
		7. Move $v0 to the next byte.
		8. Exit if counter == 0, otherwise, repeat 'loop'.


# Platform
OSX 10.11.6
