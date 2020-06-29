"Filed out from Dolphin Smalltalk 7"!

SUnitAbsWrapper subclass: #SUnitTestResourceWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SUnitTestResourceWrapper guid: (GUID fromString: '{e435e984-8d6c-44e8-8a7f-7341afbe2edd}')!
SUnitTestResourceWrapper comment: ''!
!SUnitTestResourceWrapper categoriesForClass!Unclassified! !
!SUnitTestResourceWrapper methodsFor!

name

	^self model useDisplayNames
		ifTrue: [self testResource displayName]
		ifFalse: [self testResource name]!

status

	^self testResource isAvailable
		ifTrue: ['Available']
		ifFalse: ['Unavailable']!

testResource

	^self subject!

testResource: aTestResource

	self subject: aTestResource! !
!SUnitTestResourceWrapper categoriesFor: #name!accessing!constants!public! !
!SUnitTestResourceWrapper categoriesFor: #status!accessing!public! !
!SUnitTestResourceWrapper categoriesFor: #testResource!accessing!constants!private! !
!SUnitTestResourceWrapper categoriesFor: #testResource:!accessing!constants!private! !

!SUnitTestResourceWrapper class methodsFor!

newOn: aTestResource model: anSUnitResourceBrowserModel

	^(self newOn: anSUnitResourceBrowserModel)
		testResource: aTestResource;
		yourself! !
!SUnitTestResourceWrapper class categoriesFor: #newOn:model:!instantiating!public! !

