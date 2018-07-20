"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ClassTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassTest guid: (GUID fromString: '{3c2fe318-ee64-4a1e-8b1a-8bf38c6d1803}')!
ClassTest comment: ''!
!ClassTest categoriesForClass!Unclassified! !
!ClassTest methodsFor!

testClassPoolsWellFormed
	"https://github.com/dolphinsmalltalk/Dolphin/issues/562"

	| badPools |
	self skip.	"Pending fix for #562"
	badPools := Smalltalk allClasses reject: 
					[:each |
					each classPool class == PoolDictionary
						and: [each classPool associations allSatisfy: [:v | v class == VariableBinding]]].
	self assert: badPools asArray equals: #()! !
!ClassTest categoriesFor: #testClassPoolsWellFormed!public! !

