"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

SUnitAbsWrapper subclass: #SUnitTestResourceWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitTestResourceWrapper guid: (GUID fromString: '{E435E984-8D6C-44E8-8A7F-7341AFBE2EDD}')!
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

