"Filed out from Dolphin Smalltalk 7"!

StVariable subclass: #StInstanceVariable
	instanceVariableNames: 'index name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StInstanceVariable guid: (GUID fromString: '{9e27c3fe-9793-4a23-9fcd-4f2cb4c86f2b}')!
StInstanceVariable comment: ''!
!StInstanceVariable categoriesForClass!Kernel-Objects! !
!StInstanceVariable methodsFor!

index
	^index!

isInstanceVariable
	^true!

name
	^name!

setIndex: anInteger name: aString
	index := anInteger.
	name := aString.
	self initialize! !
!StInstanceVariable categoriesFor: #index!accessing!public! !
!StInstanceVariable categoriesFor: #isInstanceVariable!public!testing! !
!StInstanceVariable categoriesFor: #name!accessing!public! !
!StInstanceVariable categoriesFor: #setIndex:name:!initializing!private! !

!StInstanceVariable class methodsFor!

index: anInteger name: aString
	^self new setIndex: anInteger name: aString! !
!StInstanceVariable class categoriesFor: #index:name:!public! !

