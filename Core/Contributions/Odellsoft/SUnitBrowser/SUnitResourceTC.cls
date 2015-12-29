"Filed out from Dolphin Smalltalk X6.1"!

TestCase subclass: #SUnitResourceTC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitResourceTC guid: (GUID fromString: '{1F4F134F-77F5-48B5-A722-8B6B1A7862EB}')!
SUnitResourceTC comment: ''!
!SUnitResourceTC categoriesForClass!Unclassified! !
!SUnitResourceTC methodsFor!

testIsResourceAvailable

	self assert: ExampleTestResource isAvailable! !
!SUnitResourceTC categoriesFor: #testIsResourceAvailable!public!Testing! !

!SUnitResourceTC class methodsFor!

resources
	^Array with: ExampleTestResource! !
!SUnitResourceTC class categoriesFor: #resources!Accessing!public! !

