"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbLUPDecomposition
	instanceVariableNames: 'rows permutation parity'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbLUPDecomposition guid: (GUID fromString: '{E550027C-7D2B-11D6-B6CC-00022D5019C8}')!
DhbLUPDecomposition comment: ''!
!DhbLUPDecomposition categoriesForClass!DHB Numerical! !
!DhbLUPDecomposition methodsFor!

backwardSubstitution: anArray
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n sum answer|
	n := rows size.
	answer := DhbVector new: n.
	n to: 1 by: -1 do:
		[ :i |
		  sum := anArray at: i.
		  ( i + 1) to: n do: [ :j | sum := sum - ( ( ( rows at: i) at: j) * ( answer at: j))].
		  answer at: i put: sum / ( ( rows at: i) at: i).
		].
	^answer!

decompose
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n |
	n := rows size.
	permutation := (1 to: n) asArray.
	1 to: ( n - 1) do:
		[ :k |
		  self swapRow: k withRow: ( self largestPivotFrom: k);
			   pivotAt: k.
		].!

determinant
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/5/99 "
	| n |
	permutation isNil
		ifTrue: [ self protectedDecomposition].
	permutation = 0
		ifTrue: [ ^0].	"Singular matrix has 0 determinant"
	n := 0.
	^rows inject: parity
		  into: [ :det :each | n := n + 1. ( each at: n) * det]!

forwardSubstitution: anArray
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n sum answer|
	answer := permutation collect: [ :each | anArray at: each].
	n := rows size.
	2 to: n do:
		[ :i |
		  sum := answer at: i.
		  1 to: ( i - 1) do: [ :j | sum := sum - ( ( ( rows at: i) at: j) * ( answer at: j))].
		  answer at: i put: sum.
		].
	^answer!

initialize: anArrayOfArrays
		"Private - A copy of the original array is made.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	rows := anArrayOfArrays.
	parity := 1.
	^self!

inverseMatrixComponents
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| n inverseRows column |
	permutation isNil
		ifTrue: [ self protectedDecomposition].
	permutation = 0
		ifTrue: [ ^nil].	"Singular matrix has no inverse"
	n := rows size.
	inverseRows :=( 1 to: n) asVector collect: [ :j | DhbVector new: n].
	1 to: n do:
		[ :j |
		  column := self solve: ( ( Array new: rows size) atAllPut: 0; at: j put: 1; yourself).
		  1 to: n do: [ :i | ( inverseRows at: i) at: j put: ( column at: i)].
		].
	^inverseRows!

largestPivotFrom: anInteger
		"Private - Answers the largest pivot element in column anInteger, from position anInteger upward.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	| valueOfMaximum indexOfMaximum value |
	valueOfMaximum := ( ( rows at: anInteger) at: anInteger) abs.
	indexOfMaximum := anInteger.
	( anInteger + 1) to: rows size do:
		[ :n |
		  value := ( ( rows at: n) at: anInteger) abs.
		  value > valueOfMaximum
				ifTrue: [ valueOfMaximum := value.
						  indexOfMaximum := n.
						].
		].
	^indexOfMaximum!

pivotAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| inversePivot size k |
	inversePivot := 1 / ( ( rows at: anInteger) at: anInteger).
	size := rows size.
	k := anInteger + 1.
	k to: size
		do: [ :i |
			  ( rows at: i) at: anInteger put: (( rows at: i) at: anInteger) * inversePivot.
			  k to: size
				do: [ :j |
					  ( rows at: i) at: j put: ( ( rows at: i) at: j) - ( (( rows at: i) at: anInteger) * (( rows at: anInteger) at: j)).
					]
			].!

printOn: aStream
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	| first delimitingString n k |
	n := rows size.
	first := true.
	rows do:
		[ :row |
		  first ifTrue: [ first := false]
				 ifFalse:[ aStream cr].
		  delimitingString := '('.
		  row do:
			[ :each |
				aStream nextPutAll: delimitingString.
				each printOn: aStream.
				delimitingString := ' '.
			].
		  aStream nextPut: $).
		].!

protectedDecomposition
		"Private - If decomposition fails, set permutation to 0.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	[ self decompose] on: Error do: [ :signal | permutation := 0. signal return: nil].!

solve: anArrayOrVector
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	permutation isNil
		ifTrue: [ self protectedDecomposition].
	^permutation = 0
		ifTrue: [ nil]
		ifFalse:[ self backwardSubstitution: ( self forwardSubstitution: anArrayOrVector)]!

swapRow: anInteger1 withRow: anInteger2
		"Private - Swap the rows indexed by the given integers.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 12/2/99 "
	anInteger1 = anInteger2
		ifFalse:[ | swappedRow |
				  swappedRow := rows at: anInteger1.
				  rows at: anInteger1 put: ( rows at: anInteger2).
				  rows at: anInteger2 put: swappedRow.
				  swappedRow := permutation at: anInteger1.
				  permutation at: anInteger1 put: ( permutation at: anInteger2).
				  permutation at: anInteger2 put: swappedRow.
				  parity := parity negated.
				].! !
!DhbLUPDecomposition categoriesFor: #backwardSubstitution:!public!transformation! !
!DhbLUPDecomposition categoriesFor: #decompose!public!transformation! !
!DhbLUPDecomposition categoriesFor: #determinant!information!public! !
!DhbLUPDecomposition categoriesFor: #forwardSubstitution:!public!transformation! !
!DhbLUPDecomposition categoriesFor: #initialize:!initialization!public! !
!DhbLUPDecomposition categoriesFor: #inverseMatrixComponents!information!public! !
!DhbLUPDecomposition categoriesFor: #largestPivotFrom:!information!public! !
!DhbLUPDecomposition categoriesFor: #pivotAt:!public!transformation! !
!DhbLUPDecomposition categoriesFor: #printOn:!display!public! !
!DhbLUPDecomposition categoriesFor: #protectedDecomposition!public!transformation! !
!DhbLUPDecomposition categoriesFor: #solve:!public!transformation! !
!DhbLUPDecomposition categoriesFor: #swapRow:withRow:!public!transformation! !

!DhbLUPDecomposition class methodsFor!

direct: anArrayOfArrays
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
	^self new initialize: anArrayOfArrays.!

equations: anArrayOfArrays
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 30/3/99 "
		^self new initialize: ( anArrayOfArrays collect: [ :each | each copy]).! !
!DhbLUPDecomposition class categoriesFor: #direct:!creation!public! !
!DhbLUPDecomposition class categoriesFor: #equations:!creation!public! !

