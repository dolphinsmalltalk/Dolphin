"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbLinearEquationSystem
	instanceVariableNames: 'rows solutions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLinearEquationSystem guid: (GUID fromString: '{E5500264-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLinearEquationSystem comment: ''!
!DhbLinearEquationSystem categoriesForClass!DHB Numerical! !
!DhbLinearEquationSystem methodsFor!

backSubstitutionAt: anInteger
		"Private - Perform the back-substitution step corresponding to the anInteger-th constant array.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| size answer accumulator |
	size := rows size.
	answer := Array new: size.
	size to: 1 by: -1 do:
		[ :n |
		  accumulator := (rows at: n) at: (anInteger + size).
		  ( n + 1) to: size
			do: [ :m | accumulator := accumulator - ( ( answer at: m) * ( ( rows at: n) at: m))].
		  answer at: n put: ( accumulator / ( ( rows at: n) at: n)).
		].
	solutions at: anInteger put: answer.!

initialize: anArrayOfArrays constants: anArrayOfConstantArrays
		"Private - Initialize the receiver with system's matrix in anArrayOfArrays and several constants.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "
	| n |
	n := 0.
	rows := anArrayOfArrays collect: [ :each | n := n + 1. each, ( anArrayOfConstantArrays collect: [ :c | c at: n])].
	^self!

largestPivotFrom: anInteger
		"Private - Answers the largest pivot element in column anInteger, from position anInteger upward.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| valueOfMaximum indexOfMaximum |
	valueOfMaximum := ( rows at: anInteger) at: anInteger.
	indexOfMaximum := anInteger.
	( anInteger + 2) to: rows size do:
		[ :n |
		  ( ( rows at: n) at: anInteger) > valueOfMaximum
				ifTrue: [ valueOfMaximum := ( rows at: n) at: anInteger.
							 indexOfMaximum := n.
						   ].
		].
	^indexOfMaximum!

pivotAt: anInteger
		"Private - Performs pivot operation with pivot element at anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| inversePivot rowPivotValue row pivotRow |
	pivotRow := rows at: anInteger.
	inversePivot := 1 / ( pivotRow at: anInteger).
	( anInteger + 1) to: rows size do:
		[ :n |
		  row := rows at: n.
		  rowPivotValue := ( row at: anInteger) * inversePivot.
		  anInteger to: row size do:
			[ :m |
			  row at: m put: ( ( row at: m) - (( pivotRow at: m) * rowPivotValue)).
			].
		].!

pivotStepAt: anInteger
		"Private - Performs an optimum pivot operation at anInteger.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	self swapRow: anInteger withRow: ( self largestPivotFrom: anInteger);
		   pivotAt: anInteger.!

printOn: aStream
		"Append to the argument aStream, a sequence of characters that describes the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| first delimitingString n k |
	n := rows size.
	first := true.
	rows do:
		[ :row |
		  first ifTrue: [ first := false]
				 ifFalse:[ aStream cr].
		  delimitingString := '('.
		  k := 0.
		  row do:
			[ :each |
				aStream nextPutAll: delimitingString.
				each printOn: aStream.
				k := k + 1.
				delimitingString := k < n ifTrue: [ ' '] ifFalse: [ ' : '].
			].
		  aStream nextPut: $).
		].!

solution
		"Answers the solution corresponding to the first constant array.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	^self solutionAt: 1!

solutionAt: anInteger
		"Answer the solution corresponding to the anInteger-th constant array.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	"solutions isNil
		ifTrue: [ [self solve] when: Error do: [ :signal |solutions := 0. signal return: nil.] ].
	solutions = 0
		ifTrue: [ ^nil].
	( solutions at: anInteger) isNil
		ifTrue: [ self backSubstitutionAt: anInteger].
	^solutions at: anInteger"

	solutions isNil
		ifTrue: [ [self solve] on: Error do: [ :signal |solutions := 0. signal return: nil.] ].
	solutions = 0
		ifTrue: [ ^nil].
	( solutions at: anInteger) isNil
		ifTrue: [ self backSubstitutionAt: anInteger].
	^solutions at: anInteger!

solve
		"Private - Perform LU decomposition of the system.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	1 to: rows size do: [ :n | self pivotStepAt: n].
	solutions := Array new: ( (rows at: 1) size - rows size).!

swapRow: anInteger1 withRow: anInteger2
		"Private - Swap the rows indexed by the given integers.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| swappedRow |
	anInteger1 = anInteger2
		ifFalse:[ swappedRow := rows at: anInteger1.
					  rows at: anInteger1 put: ( rows at: anInteger2).
					  rows at: anInteger2 put: swappedRow.
					].! !
!DhbLinearEquationSystem categoriesFor: #backSubstitutionAt:!public!transformation! !
!DhbLinearEquationSystem categoriesFor: #initialize:constants:!initialization!public! !
!DhbLinearEquationSystem categoriesFor: #largestPivotFrom:!information!public! !
!DhbLinearEquationSystem categoriesFor: #pivotAt:!public!transformation! !
!DhbLinearEquationSystem categoriesFor: #pivotStepAt:!public!transformation! !
!DhbLinearEquationSystem categoriesFor: #printOn:!display!public! !
!DhbLinearEquationSystem categoriesFor: #solution!information!public! !
!DhbLinearEquationSystem categoriesFor: #solutionAt:!information!public! !
!DhbLinearEquationSystem categoriesFor: #solve!public!transformation! !
!DhbLinearEquationSystem categoriesFor: #swapRow:withRow:!public!transformation! !

!DhbLinearEquationSystem class methodsFor!

equations: anArrayOfArrays constant: anArray 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^self new initialize: anArrayOfArrays constants: (Array with: anArray)!

equations: anArrayOfArrays constants: anArrayOfConstantArrays 
	"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 11/2/99 "

	^self new initialize: anArrayOfArrays constants: anArrayOfConstantArrays! !
!DhbLinearEquationSystem class categoriesFor: #equations:constant:!creation!public! !
!DhbLinearEquationSystem class categoriesFor: #equations:constants:!creation!public! !

