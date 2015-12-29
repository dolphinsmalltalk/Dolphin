"Filed out from Dolphin Smalltalk XP"!

DhbFunctionalIterator subclass: #DhbFunctionOptimizer
	instanceVariableNames: 'optimizingPointClass bestPoints'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbFunctionOptimizer guid: (GUID fromString: '{E550028E-7D2B-11D6-B6CC-00022D5019C8}')!
DhbFunctionOptimizer comment: ''!
!DhbFunctionOptimizer categoriesForClass!DHB Numerical! !
!DhbFunctionOptimizer methodsFor!

addPointAt: aNumber 
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	bestPoints 
		add: (optimizingPointClass vector: aNumber function: functionBlock)!

bestPoints
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^bestPoints!

finalizeIterations
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	result := bestPoints first position.!

functionBlock
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^functionBlock!

initialize
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	bestPoints := SortedCollection sortBlock: [ :a :b | a betterThan: b].
	^super initialize!

initializeAsMaximizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	optimizingPointClass := DhbMaximizingPoint.
	^self initialize!

initializeAsMinimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	optimizingPointClass := DhbMinimizingPoint.
	^self!

initializeForOptimizer: aFunctionOptimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	optimizingPointClass := aFunctionOptimizer pointClass.
	functionBlock := aFunctionOptimizer functionBlock.
	^self initialize!

initialValue: aVector
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 04-Jan-00 "
	result := aVector copy.!

pointClass
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^optimizingPointClass!

printOn: aStream
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	super printOn: aStream.
	bestPoints do: [ :each | aStream cr. each printOn: aStream].! !
!DhbFunctionOptimizer categoriesFor: #addPointAt:!public!transformation! !
!DhbFunctionOptimizer categoriesFor: #bestPoints!information!public! !
!DhbFunctionOptimizer categoriesFor: #finalizeIterations!operation!public! !
!DhbFunctionOptimizer categoriesFor: #functionBlock!information!public! !
!DhbFunctionOptimizer categoriesFor: #initialize!initialization!public! !
!DhbFunctionOptimizer categoriesFor: #initializeAsMaximizer!initialization!public! !
!DhbFunctionOptimizer categoriesFor: #initializeAsMinimizer!initialization!public! !
!DhbFunctionOptimizer categoriesFor: #initializeForOptimizer:!initialization!public! !
!DhbFunctionOptimizer categoriesFor: #initialValue:!initialization!public! !
!DhbFunctionOptimizer categoriesFor: #pointClass!information!public! !
!DhbFunctionOptimizer categoriesFor: #printOn:!display!public! !

!DhbFunctionOptimizer class methodsFor!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^super defaultPrecision * 100!

forOptimizer: aFunctionOptimizer
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^self new initializeForOptimizer: aFunctionOptimizer!

maximizingFunction: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new initializeAsMaximizer; setFunction: aFunction!

minimizingFunction: aFunction
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^super new initializeAsMinimizer; setFunction: aFunction! !
!DhbFunctionOptimizer class categoriesFor: #defaultPrecision!information!public! !
!DhbFunctionOptimizer class categoriesFor: #forOptimizer:!creation!public! !
!DhbFunctionOptimizer class categoriesFor: #maximizingFunction:!creation!public! !
!DhbFunctionOptimizer class categoriesFor: #minimizingFunction:!creation!public! !

