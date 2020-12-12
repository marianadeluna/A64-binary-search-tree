// <Mariana De Luna>
// CS318 Programming Assignment 3
// Spring 2018
// A64 implementation of Binary Search Tree
	.align 2
	.data
	// Assume that the BST's are full and complete
	// (every node other than the leaves has exactly two children, leaves are all
	// at the same depth).
	// Structure of the tree data:
	// First value is the number of nodes in the tree.
	// This is followed by the values stored in each node. The BST is stored as
	// an array where the childern of the node at index i are located at indexes
	// (2i+1) and (2i+2).
treeA: // height is 3
	.dword 15 // number of nodes in treeA
	.dword 57,39,72,23,50,62,87,20,27,49,53,60,63,81,95 // BST represented as an array
treeB: // height is 5
	.dword 63 // number of nodes in treeB
	// BST represented as an array
	.dword 2941,1836,3400,1418,2176,3298,4199,1128,1472,2143
    .dword 2552,3060,3310,3598,4280,1020,1150,1438,1713,2037
    .dword 2154,2219,2634,2987,3104,3305,3362,3487,3674,4242
    .dword 4733,1009,1057,1146,1223,1426,1453,1663,1755,1962
    .dword 2079,2145,2175,2189,2379,2602,2654,2974,3012,3095
    .dword 3162,3300,3307,3325,3373,3458,3511,3632,3912,4222
    .dword 4278,4673,4947
treeC: // empty tree, height procedure should return -1
	.dword 0 // number of nodes in treeC
treeD: // tree has one node, height procedure should return 0
	.dword 1 // number of nodes in treeD
	.dword 12345 // single node in the tree
	.text
	.global main
main:

	////////////////////
	// Test 1: treeA
	// Call the height procedure
	ADR X1,treeA // Put the base memory address of the tree into X1
	ADD X1,X1,#8 // before calling the procedure, put address of first array element into X1
	BL p_height

	// Call the search procedure
	MOV X1,#87 // key value to search for
	ADR X2,treeA // base memory address of the tree
	ADD X2,X2,#8 // before calling the procedure, put address of first array element into X2
	MOV X3,#0 // X3 = array index of root node
	MOV X4,#0 // X4 = offset of root node
	BL p_search

	////////////////////
	// Test 2: treeB
	// Call the height procedure
	ADR X1,treeB // Put the base memory address of the tree into X1
	ADD X1,X1,#8 // before calling the procedure, put address of first array element into X1
	BL p_height

	// Call the search procedure
	MOV X1,#2189 // key value to search for
	ADR X2,treeB // base memory address of the tree
	ADD X2,X2,#8 // before calling the procedure, put address of first array element into X2
	MOV X3,#0 // X3 = array index of root node
	MOV X4,#0 // X4 = offset of root node
	BL p_search

	////////////////////
	// Test 3: treeC
	// Call the height procedure
	ADR X1,treeC // Put the base memory address of the tree into X1
	ADD X1,X1,#8 // before calling the procedure, put address of first array element into X1
	BL p_height

	// Call the search procedure
	MOV X1,#987 // key value to search for
	ADR X2,treeC // base memory address of the tree
	ADD X2,X2,#8 // before calling the procedure, put address of first array element into X2
	MOV X3,#0 // X3 = array index of root node
	MOV X4,#0 // X4 = offset of root node
	BL p_search

	////////////////////
	// Test 4: treeD
	// Call the height procedure
	ADR X1,treeD // Put the base memory address of the tree into X1
	ADD X1,X1,#8 // before calling the procedure, put address of first array element into X1
	BL p_height

	// Call the search procedure
	MOV X1,#12345 // key value to search for
	ADR X2,treeD // base memory address of the tree
	ADD X2,X2,#8 // before calling the procedure, put address of first array element into X2
	MOV X3,#0 // X3 = array index of root node
	MOV X4,#0 // X4 = offset of root node
	BL p_search


	// End of main procedure, branch to end of program
	B program_end

p_height:
	// Height Procedure (iterative implementation)
	// X0: Returns the height of the tree (number of edges from root to deepest leaf).
	// If the tree is empty, returns -1; if the tree contains 1 node, returns 0.
	// X1: The memory base address of the binary search tree. Assumes the value before this
	// memory address is the number of nodes in the BST, followed by the values in each node
	// of the BST. Assumes the BST is full and complete (procedure will not alter)
	//
	// This procedure must use an iterative (non-recursive) algorithm. The performance
	// of the solution must be O(log n), where n is the number of nodes in the tree.
	//
	// Temporary registers used by this procedure:
	// <student must list the registers; start with X9, and use registers in number order
	// as needed up to X15>
	// Values of the temporary registers used by this procedure must be preserved.

	//******* Write your code for the height procedure here ******/

	/* if first node == empty // index i = 0
		then x0 = -1 // return this value
		//branch to p_search
		else
		if first node == a value // index i = 0
		then x0 = 0

		if second node == empty // index i = 1
		then x0 = 1 // and return this value
		//branch to p_search
		else
		if second node == a value
						// i = 1
		then x0 = x0+1
	*/

	// if the tree is empty, branch to p_search
	MOV X0, #-1 // height starts off at 0
	LDR X9,[X1, #-8] // num of nodes
	CBZ X9, done
	// else add 1 to height
	ADD X0, X0, #1
	// if there is only one node in the tree, branch to p_search
	SUBS X9, X9, #1
	CBZ X9, done
	// else calculate height of complete tree
	MOV X10, #0 // index of first node
	MOV X11, #2 // use to calculate right child
height:
	// 2i+2 then add 1 to height
	ADD X10,X10,X10
	ADD X10,X10,X11
	ADD X0, X0, #1
	SUBS X12, X10, X9
	CBZ X12, done
	B height
done:
	BR X30
	// End of height procedure

p_search:
	// Search Procedure (recursive implementation)
	// X0: Returns the array index where the key is found, or -1 if the key is not found.
	// X1: The key value to search for (procedure will not alter)
	// X2: The memory base address of the binary search tree. Assumes the value before this
	// memory address is the number of nodes in the BST, followed by the values in each node
	// of the BST. Assumes the BST is full and complete (procedure will not alter)
	// X3: The index of the current sub-tree root (procedure may alter)
	// X4: The memory offset of the current sub-tree root (procedure may alter)
	//
	// This procedure must use a recursive algorithm that has worst case
	// performance O(tree height).
	//
	// Temporary registers used by this procedure:
	// <student must list the registers; start with X9, and use registers in number order
	// as needed up to X15>
	// Values of the temporary registers used by this procedure must be preserved.

	//******* Write your code for the search procedure here ******/

	//this procedure will search the tree for a value
	// these are initialized values for later use in the procedure
	MOV X0, #-1
	MOV X11, #1
	MOV X12, #8
	MOV X13, #2
	MOV X14, #16

	// if the tree is empty, branch and return -1
	LDR X9,[X2, #-8] // num of nodes
	CBZ X9, notfound
	SUB X9,X9,#1
	//else
check:
	//check if node is equal to X1, else branch. Starts off with node, index 0
	SUBS X9,X9,X3
	CBZ X9, notfound // this checks whether we have gone through the entire list
	LDR X10,[X2,X4] // starts off at first root then changes
	SUBS X10, X1, X10
	B.EQ equal
	SUBS X10, X1, X10
	B.LO lessThan
	SUBS X10, X1, X10
	B.HI greaterThan

lessThan:
	ADD X3,X3,X3
	ADD X3,X3,X11 // X3 is now index of left child
	ADD X4,X4,X4
	ADD X4,X4,X12 // X4 is now offset of left child
	B check

greaterThan:
	ADD X3,X3,X3
	ADD X3,X3,X13 // X3 is now index of right child
	ADD X4,X4,X4
	ADD X4,X4,X14 // X4 is now offset of right child
	B check

notfound:
	MOV X0,#-1
	BR X30

equal:
	MOV X0, X3
	BR X30
	// End of search procedure

program_end:
	MOV X15,#0 // placeholder at end of program
	.end
