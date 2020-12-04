"Filed out from Dolphin Smalltalk 7"!

STON.Reference subclass: #'STON.DolphinReference'
	instanceVariableNames: 'refCount'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.DolphinReference guid: (Core.GUID fromString: '{546a8d71-4999-42e5-981f-a2f828b33478}')!
STON.DolphinReference comment: 'A `StonReference` that can maintain a count of how many times it is referenced in the input stream. This allows us to distinguish cases that need resolution, from the majority that do not.'!
!STON.DolphinReference categoriesForClass!STON-Core-Utilities! !
!STON.DolphinReference methodsFor!

addReference
	refCount := refCount + 1!

index: integer
	index := integer.
	refCount := 0!

refCount
	^refCount! !
!STON.DolphinReference categoriesFor: #addReference!public! !
!STON.DolphinReference categoriesFor: #index:!initializing!private! !
!STON.DolphinReference categoriesFor: #refCount!accessing!public! !

