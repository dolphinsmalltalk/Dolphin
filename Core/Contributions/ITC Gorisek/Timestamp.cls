"Filed out from Dolphin Smalltalk X6.2"!

TimeStamp subclass: #Timestamp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Timestamp guid: (GUID fromString: '{31A3E526-25C5-4B34-B325-A0566ED3AFED}')!
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

