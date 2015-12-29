"Filed out from Dolphin Smalltalk XP"!

DhbFunctionOptimizer subclass: #DhbOneVariableFunctionOptimizer
	instanceVariableNames: ''
	classVariableNames: 'GoldenSection'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbOneVariableFunctionOptimizer guid: (GUID fromString: '{E550028F-7D2B-11D6-B6CC-00022D5019C8}')!
DhbOneVariableFunctionOptimizer comment: ''!
!DhbOneVariableFunctionOptimizer categoriesForClass!DHB Numerical! !
!DhbOneVariableFunctionOptimizer methodsFor!

computeInitialValues
	"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	[ bestPoints size  > 3] whileTrue: [ bestPoints removeLast].
	bestPoints size = 3
		ifTrue: [ self hasBracketingPoints
					ifFalse:[ bestPoints removeLast].
				].
	bestPoints size < 3
		ifTrue: [ ( DhbOptimizingBracketFinder forOptimizer: self) evaluate].!

computePrecision
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	^self precisionOf: ( ( bestPoints at: 2) position - ( bestPoints at: 3) position) abs
		   relativeTo: ( bestPoints at: 1) position abs!

evaluateIteration
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	self addPointAt: self nextXValue.
	bestPoints removeAtIndex: self indexOfOuterPoint.
	^self computePrecision!

hasBracketingPoints
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| x1 |
	x1 := ( bestPoints at: 1) position.
	^( ( bestPoints at: 2) position - x1) * (( bestPoints at: 3) position - x1) < 0!

indexOfOuterPoint
		"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| inferior superior x |
	inferior := false.
	superior := false.
	x := bestPoints first position.
	2 to: 4 do:
		[ :n |
		  ( bestPoints at: n) position < x
				ifTrue: [ inferior
							ifTrue: [ ^n].
						  inferior := true.
						]
				ifFalse:[ superior
							ifTrue: [ ^n].
						  superior := true.
						].
		].!

nextXValue
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	| d3 d2 x1 |
	x1 := ( bestPoints at: 1) position.
	d2 := ( bestPoints at: 2) position - x1.
	d3 := ( bestPoints at: 3) position - x1.
	^( d3 abs > d2 abs ifTrue: [ d3]
					   ifFalse:[ d2]) * self class goldenSection + x1!

reset
		"(c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "
	[ bestPoints isEmpty] whileFalse: [ bestPoints removeLast].! !
!DhbOneVariableFunctionOptimizer categoriesFor: #computeInitialValues!operation!public! !
!DhbOneVariableFunctionOptimizer categoriesFor: #computePrecision!information!public! !
!DhbOneVariableFunctionOptimizer categoriesFor: #evaluateIteration!operation!public! !
!DhbOneVariableFunctionOptimizer categoriesFor: #hasBracketingPoints!information!public! !
!DhbOneVariableFunctionOptimizer categoriesFor: #indexOfOuterPoint!information!public! !
!DhbOneVariableFunctionOptimizer categoriesFor: #nextXValue!information!public! !
!DhbOneVariableFunctionOptimizer categoriesFor: #reset!public!transformation! !

!DhbOneVariableFunctionOptimizer class methodsFor!

defaultPrecision
		"Private - Answers the default precision for newly created instances.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 6/1/99 "
	^DhbFloatingPointMachine new defaultNumericalPrecision * 10!

goldenSection
	"Private -
		 (c) Copyrights Didier BESSET, 2000, all rights reserved.
		 Initial code: 2/22/00 "

	GoldenSection isNil ifTrue: [GoldenSection := (3 - 5 sqrt) / 2].
	^GoldenSection! !
!DhbOneVariableFunctionOptimizer class categoriesFor: #defaultPrecision!information!public! !
!DhbOneVariableFunctionOptimizer class categoriesFor: #goldenSection!information!public! !

