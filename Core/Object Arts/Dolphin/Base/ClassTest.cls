"Filed out from Dolphin Smalltalk"!

ClassDescriptionTest subclass: #ClassTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassTest guid: (GUID fromString: '{3c2fe318-ee64-4a1e-8b1a-8bf38c6d1803}')!
ClassTest comment: ''!
!ClassTest categoriesForClass!Unclassified! !
!ClassTest methodsFor!

allClassHierarchyInstancesDo: aMonadicValuable
	Smalltalk allClasses do: aMonadicValuable!

testAllRoots
	| roots |
	roots := Class allRoots.
	self assert: roots first identicalTo: Object.
	roots do: [:each | self assertIsNil: each superclass]!

testClassPoolsWellFormed
	"https://github.com/dolphinsmalltalk/Dolphin/issues/562"

	| badPools |
	badPools := Smalltalk allClasses reject: 
					[:each |
					each classPool class == PoolDictionary
						and: [each classPool associations allSatisfy: [:v | v class == VariableBinding]]].
	self assert: badPools asArray equals: #()!

testLessOrEqual
	self assert: ArithmeticError <= ArithmeticError description: 'Classes must be <= to themselves'.
	self assert: ArithmeticError <= ArithmeticError class description: 'Classes must be <= their Metaclass'.
	self assert: ArithmeticError <= ArithmeticValue.
	self assert: ArithmeticError <= ArithmeticValue class.
	self deny: ArithmeticValue <= ArithmeticError.
	self deny: ArithmeticValue <= ArithmeticError class.! !
!ClassTest categoriesForMethods!
allClassHierarchyInstancesDo:!helpers!private! !
testAllRoots!public!unit tests! !
testClassPoolsWellFormed!public!unit tests! !
testLessOrEqual!public!unit tests! !
!

