"Filed out from Dolphin Smalltalk XP"!

DhbIterativeProcess subclass: #DhbJacobiTransformation
	instanceVariableNames: 'lowerRows transform'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbJacobiTransformation guid: (GUID fromString: '{E55002A0-7D2B-11D6-B6CC-00022D5019C8}')!
DhbJacobiTransformation comment: ''!
!DhbJacobiTransformation categoriesForClass!DHB Numerical! !
!DhbJacobiTransformation methodsFor!

evaluateIteration
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| indices |
	indices := self largestOffDiagonalIndices.
	self transformAt: ( indices at: 1) and: ( indices at: 2).
	^precision!

exchangeAt: anInteger
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| temp n |
	n := anInteger + 1.
	temp := result at: n.
	result at: n put: ( result at: anInteger).
	result at: anInteger put: temp.
	transform do:
		[ :each |
		  temp := each at: n.
		  each at: n put: ( each at: anInteger).
		  each at: anInteger put: temp.
		].!

finalizeIterations
	"Transfer the eigenValues into a vector and set this as the result.
		 eigen values and transform matrix are sorted using a bubble sort.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "

	| n |
	n := 0.
	result := lowerRows collect: 
					[:each | 
					n := n + 1.
					each at: n].
	self sortEigenValues!

initialize: aSymmetricMatrix
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| n m |
	n := aSymmetricMatrix numberOfRows.
	lowerRows := Array new: n.
	transform := Array new: n.
	1 to: n do:
		[ :k |
		  lowerRows at: k put: ( ( aSymmetricMatrix rowAt: k) copyFrom: 1 to: k).
		  transform at: k put: ( ( Array new: n) atAllPut: 0; at: k put: 1; yourself).
		].
	^self!

largestOffDiagonalIndices
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| n m abs |
	n := 2.
	m := 1.
	precision := ( ( lowerRows at: n) at: m) abs.
	1 to: lowerRows size do:
		[ :i |
		  1 to: ( i - 1) do:
			[ :j |
			  abs := ( ( lowerRows at: i) at: j) abs.
			  abs > precision
				ifTrue: [ n := i.
						  m := j.
						  precision := abs.
						]. 
			].
		].
	^Array with: m with: n!

printOn: aStream
		"Append to the argument aStream, a sequence of characters that describes the receiver.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| first |
	first := true.
	lowerRows do: 
		[ :each |
		  first ifTrue: [ first := false]
				 ifFalse:[ aStream cr].
		  each printOn: aStream.
		].!

sortEigenValues
		"Private - Use a bubble sort.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| n bound m |
	n := lowerRows size.
	bound := n.
	[ bound = 0 ]
		whileFalse: [ m := 0.
					  1 to: bound - 1 do:
						[ :j |
						  ( result at: j) abs > ( result at: j + 1) abs
							ifFalse:[ self exchangeAt: j.
									  m := j.
									].
						].
					  bound := m.
					].!

transform
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	^DhbMatrix rows: transform!

transformAt: anInteger1 and: anInteger2
		"Private -
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	| d t s c tau apq app aqq arp arq |
	apq := ( lowerRows at: anInteger2) at: anInteger1.
	apq = 0
		ifTrue: [ ^nil].
	app := ( lowerRows at: anInteger1) at: anInteger1.
	aqq := ( lowerRows at: anInteger2) at: anInteger2.
	d := aqq - app.
	arp := d * 0.5 / apq.
	t := arp > 0 ifTrue: [ 1 / ( ( arp squared + 1) sqrt + arp)]
				 ifFalse:[ 1 / ( arp - ( arp squared + 1) sqrt)].
	c := 1 / ( t squared + 1) sqrt.
	s := t * c.
	tau := s / ( 1 + c).
	1 to: ( anInteger1 - 1)
		do: [ :r |
			  arp := ( lowerRows at: anInteger1) at: r.
			  arq := ( lowerRows at: anInteger2) at: r.
			  ( lowerRows at: anInteger1) at: r put: ( arp - ( s * (tau * arp + arq))).
			  ( lowerRows at: anInteger2) at: r put: ( arq + ( s * (arp - (tau * arq)))).
			].
	( anInteger1 + 1) to: ( anInteger2 - 1)
		do: [ :r |
			  arp := ( lowerRows at: r) at: anInteger1.
			  arq := ( lowerRows at: anInteger2) at: r.
			  ( lowerRows at: r) at: anInteger1 put: ( arp - ( s * (tau * arp + arq))).
			  ( lowerRows at: anInteger2) at: r put: ( arq + ( s * (arp - (tau * arq)))).
			].
	( anInteger2 + 1) to: lowerRows size
		do: [ :r |
			  arp := ( lowerRows at: r) at: anInteger1.
			  arq := ( lowerRows at: r) at: anInteger2.
			  ( lowerRows at: r) at: anInteger1 put: ( arp - ( s * (tau * arp + arq))).
			  ( lowerRows at: r) at: anInteger2 put: ( arq + ( s * (arp - (tau * arq)))).
			].
	1 to: lowerRows size
		do: [ :r |
			  arp := ( transform at: r) at: anInteger1.
			  arq := ( transform at: r) at: anInteger2.
			  ( transform at: r) at: anInteger1 put: ( arp - ( s * (tau * arp + arq))).
			  ( transform at: r) at: anInteger2 put: ( arq + ( s * (arp - (tau * arq)))).
			].
	( lowerRows at: anInteger1) at: anInteger1 put: ( app - (t * apq)).
	( lowerRows at: anInteger2) at: anInteger2 put: ( aqq + (t * apq)).
	( lowerRows at: anInteger2) at: anInteger1 put: 0.! !
!DhbJacobiTransformation categoriesFor: #evaluateIteration!operation!public! !
!DhbJacobiTransformation categoriesFor: #exchangeAt:!public!transformation! !
!DhbJacobiTransformation categoriesFor: #finalizeIterations!operation!public! !
!DhbJacobiTransformation categoriesFor: #initialize:!initialization!public! !
!DhbJacobiTransformation categoriesFor: #largestOffDiagonalIndices!information!public! !
!DhbJacobiTransformation categoriesFor: #printOn:!display!public! !
!DhbJacobiTransformation categoriesFor: #sortEigenValues!public!transformation! !
!DhbJacobiTransformation categoriesFor: #transform!information!public! !
!DhbJacobiTransformation categoriesFor: #transformAt:and:!public!transformation! !

!DhbJacobiTransformation class methodsFor!

matrix: aSymmetricMatrix
		"
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	^super new initialize: aSymmetricMatrix!

new
		"Prevent using this message to create instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 1/6/99 "
	^self error: 'Illegal creation message for this class'! !
!DhbJacobiTransformation class categoriesFor: #matrix:!creation!public! !
!DhbJacobiTransformation class categoriesFor: #new!creation!public! !

