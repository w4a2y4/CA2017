CA2017 hw3 by b04902079甯芝蓶


# Implementation

1) recurse function
	- structure:
		- Function T: deal with base case (determine whether n<=2)
		- Function recurse: main body of recursion
	- flow:
		1. alloc sp; store $ra and $a0(n)
		2. n = n/2
		3. jump to function T
		4. retrieve $ra and $a0; restore sp
		5. do the calculate


2) Other parts, including
	- input, output
	- itoa, atoi
	- result, return, exit
are copied from hw2


# Platform
OSX 10.11.6
