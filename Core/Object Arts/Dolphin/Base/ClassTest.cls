"Filed out from Dolphin Smalltalk 7"!

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

testClassPoolsWellFormed
	"https://github.com/dolphinsmalltalk/Dolphin/issues/562"

	| badPools |
	badPools := Smalltalk allClasses reject: 
					[:each |
					each classPool class == PoolDictionary
						and: [each classPool associations allSatisfy: [:v | v class == VariableBinding]]].
	self assert: badPools asArray equals: #()! !
!ClassTest categoriesFor: #allClassHierarchyInstancesDo:!helpers!private! !
!ClassTest categoriesFor: #testClassPoolsWellFormed!public! !

