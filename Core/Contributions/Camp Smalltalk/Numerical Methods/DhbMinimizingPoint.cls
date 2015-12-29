"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbMinimizingPoint
	instanceVariableNames: 'value position'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbMinimizingPoint guid: (GUID fromString: '{E550026C-7D2B-11D6-B6CC-00022D5019C8}')!
DhbMinimizingPoint comment: ''!
!DhbMinimizingPoint categoriesForClass!DHB Numerical! !
!DhbMinimizingPoint methodsFor!

betterThan: anOptimizingPoint
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	^value < anOptimizingPoint value!

position
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "

	^position!

printOn: aStream 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 05-Jan-00 "

	position printOn: aStream.
	aStream
		nextPut: $:;
		space.
	value printOn: aStream!

value
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	^value!

value: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	value := aNumber.!

vector: aVector 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "

	position := aVector! !
!DhbMinimizingPoint categoriesFor: #betterThan:!information!public! !
!DhbMinimizingPoint categoriesFor: #position!information!public! !
!DhbMinimizingPoint categoriesFor: #printOn:!display!public! !
!DhbMinimizingPoint categoriesFor: #value!information!public! !
!DhbMinimizingPoint categoriesFor: #value:!initialization!public! !
!DhbMinimizingPoint categoriesFor: #vector:!initialization!public! !

!DhbMinimizingPoint class methodsFor!

new: aVector value: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	^self new vector: aVector; value: aNumber; yourself!

vector: aVector function: aFunction 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "

	^self new: aVector value: (aFunction value: aVector)! !
!DhbMinimizingPoint class categoriesFor: #new:value:!creation!public! !
!DhbMinimizingPoint class categoriesFor: #vector:function:!creation!public! !

