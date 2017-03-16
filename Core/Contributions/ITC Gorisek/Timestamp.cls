"Filed out from Dolphin Smalltalk 7"!

TimeStamp subclass: #Timestamp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Timestamp guid: (GUID fromString: '{31a3e526-25c5-4b34-b325-a0566ed3afed}')!
Timestamp comment: ''!
!Timestamp categoriesForClass!Unclassified! !
!Timestamp methodsFor!

totalSeconds
	^self asSeconds! !
!Timestamp categoriesFor: #totalSeconds!public! !

!Timestamp class methodsFor!

now
	^super current! !
!Timestamp class categoriesFor: #now!public! !

