"Filed out from Dolphin Smalltalk XP"!

DhbIterativeProcess subclass: #DhbFunctionalIterator
	instanceVariableNames: 'functionBlock relativePrecision'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbFunctionalIterator guid: (GUID fromString: '{E550028B-7D2B-11D6-B6CC-00022D5019C8}')!
DhbFunctionalIterator comment: ''!
!DhbFunctionalIterator categoriesForClass!DHB Numerical! !
!DhbFunctionalIterator methodsFor!

computeInitialValues
	self subclassResponsibility!

initializeIterations
	"If no initial value has been defined, take 0 as the starting point (for lack of anything better).
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "

	functionBlock isNil ifTrue: [self error: 'No function supplied'].
	self computeInitialValues!

relativePrecision: aNumber
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 27/4/99 "
	^self precisionOf: aNumber relativeTo: result abs!

setFunction: aBlock
		"Defines the function for which zeroes will be found.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	( aBlock respondsTo: #value:)
		ifFalse:[ self error: 'Function block must implement the method value:'].
	functionBlock := aBlock.! !
!DhbFunctionalIterator categoriesFor: #computeInitialValues!operation!public! !
!DhbFunctionalIterator categoriesFor: #initializeIterations!operation!public! !
!DhbFunctionalIterator categoriesFor: #relativePrecision:!information!public! !
!DhbFunctionalIterator categoriesFor: #setFunction:!initialization!public! !

!DhbFunctionalIterator class methodsFor!

function: aBlock
		"Convenience method to create a instance with given function block.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 7/1/99 "
	^self new setFunction: aBlock; yourself! !
!DhbFunctionalIterator class categoriesFor: #function:!creation!public! !

