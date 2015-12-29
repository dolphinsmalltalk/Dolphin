"Filed out from Dolphin Smalltalk XP"!

Object subclass: #DhbProjectedOneVariableFunction
	instanceVariableNames: 'index function argument'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbProjectedOneVariableFunction guid: (GUID fromString: '{E5500265-7D2B-11D6-B6CC-00022D5019C8}')!
DhbProjectedOneVariableFunction comment: ''!
!DhbProjectedOneVariableFunction categoriesForClass!DHB Numerical! !
!DhbProjectedOneVariableFunction methodsFor!

argumentWith: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^argument at: index put: aNumber; yourself!

bumpIndex
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index isNil
		ifTrue: [ index := 1]
		ifFalse:[ index := index + 1.
				  index > argument size
					ifTrue: [ index := 1].
				].!

index
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index isNil
		ifTrue: [ index := 1].
	^index!

initialize: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	function := aFunction.
	^self!

setArgument: anArrayOrVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	argument := anArrayOrVector copy.!

setIndex: anInteger
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	index := anInteger.!

value: aNumber
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^function value: ( self argumentWith: aNumber)! !
!DhbProjectedOneVariableFunction categoriesFor: #argumentWith:!information!public! !
!DhbProjectedOneVariableFunction categoriesFor: #bumpIndex!public!transformation! !
!DhbProjectedOneVariableFunction categoriesFor: #index!information!public! !
!DhbProjectedOneVariableFunction categoriesFor: #initialize:!initialization!public! !
!DhbProjectedOneVariableFunction categoriesFor: #setArgument:!initialization!public! !
!DhbProjectedOneVariableFunction categoriesFor: #setIndex:!initialization!public! !
!DhbProjectedOneVariableFunction categoriesFor: #value:!information!public! !

!DhbProjectedOneVariableFunction class methodsFor!

function: aVectorFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new initialize: aVectorFunction! !
!DhbProjectedOneVariableFunction class categoriesFor: #function:!creation!public! !

