"Filed out from Dolphin Smalltalk 7"!

TestCaseProtocol subclass: #MainTestCase
	instanceVariableNames: 'messages helpers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MainTestCase guid: (GUID fromString: '{9d4aa044-4c93-4a47-9e3f-c74f8b18381e}')!
MainTestCase isAbstract: true!
MainTestCase comment: ''!
!MainTestCase categoriesForClass!Unclassified! !
!MainTestCase methodsFor!

performTest
	(self receiverFor: testSelector) perform: testSelector!

receiverFor: aSelector 
	(self respondsTo: aSelector) ifTrue: [^self].
	helpers do: [:each | (each respondsTo: aSelector) ifTrue: [^each]].
	self error: 'not a legal test selector'!

setUp
	| helper1 |
	helpers := Array new.
	self class helperClassesDo: [:each | 
		helper1 := each new.
		helper1 attachTo: self.
		helper1 object: self canonicalObject.
		helpers := helpers copyWith: helper1]! !
!MainTestCase categoriesFor: #performTest!public! !
!MainTestCase categoriesFor: #receiverFor:!public! !
!MainTestCase categoriesFor: #setUp!public! !

!MainTestCase class methodsFor!

allTestSelectors
	| selectors |
	selectors := super allTestSelectors.
	self helperClassesDo: [:eachClass | selectors addAll: eachClass testSelectors].
	^selectors!

deleteEmptyMethodsImplementedByHelpers
	"Warning - only works for Squeak"
	self testMethods do: [:each | self deleteIfUnnecessary: each]!

deleteIfUnnecessary: aSelector
	"Warning - only works for Squeak"
	(self hasEmptyMethodFor: aSelector) ifFalse: [^self].
	(self helpersImplement: aSelector) ifTrue: [self removeSelector: aSelector]

"(BagANSITest deleteIfUnnecessary: #testXaddX)"!

hasEmptyMethodFor: aSelector
	"Warning - only works for Squeak"
	^(self compiledMethodAt: aSelector) size = 9!

helperClassesDo: aBlock
	aBlock value: 
(SUnitNameResolver classNamed: #'ObjectHelper').!

helpersImplement: aSelector
"(BagANSITest helpersImplement: #testXasSet)"
	self helperClassesDo: [:each | (each selectors includes: aSelector) ifTrue: [^true]].
	^false!

removeAllCodeThatShouldBeInHelpers
	"Warning - only works for Squeak"
	"MainTestCase removeAllCodeThatShouldBeInHelpers"
	self allSubclasses do: [:each | each deleteEmptyMethodsImplementedByHelpers]! !
!MainTestCase class categoriesFor: #allTestSelectors!public! !
!MainTestCase class categoriesFor: #deleteEmptyMethodsImplementedByHelpers!public! !
!MainTestCase class categoriesFor: #deleteIfUnnecessary:!public! !
!MainTestCase class categoriesFor: #hasEmptyMethodFor:!public! !
!MainTestCase class categoriesFor: #helperClassesDo:!public! !
!MainTestCase class categoriesFor: #helpersImplement:!public! !
!MainTestCase class categoriesFor: #removeAllCodeThatShouldBeInHelpers!public! !

