"Filed out from Dolphin Smalltalk"!

STONReference subclass: #DolphinSTONReference
	instanceVariableNames: 'refCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinSTONReference guid: (GUID fromString: '{546a8d71-4999-42e5-981f-a2f828b33478}')!

DolphinSTONReference comment: 'A `StonReference` that can maintain a count of how many times it is referenced in the input stream. This allows us to distinguish cases that need resolution, from the majority that do not.'!

!DolphinSTONReference categoriesForClass!STON-Core-Utilities! !

!DolphinSTONReference methodsFor!

addReference
	refCount := refCount + 1!

index: integer
	index := integer.
	refCount := 0!

refCount
	^refCount! !

!DolphinSTONReference categoriesForMethods!
addReference!public! !
index:!initializing!private! !
refCount!accessing!public! !
!

