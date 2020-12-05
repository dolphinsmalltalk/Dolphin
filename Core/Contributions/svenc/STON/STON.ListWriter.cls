"Filed out from Dolphin Smalltalk 7"!

STON.StreamWriter subclass: #'STON.ListWriter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.ListWriter guid: (Core.GUID fromString: '{7f97d53a-86b9-4db6-9949-a819d1045f49}')!
STON.ListWriter comment: 'STONArrayWriter helps in writing array based STON representations.
'!
!STON.ListWriter categoriesForClass!STON-Core-Writer! !
!STON.ListWriter methodsFor!

add: anObject
	first ifTrue: [ first := false ] ifFalse: [ writer listElementSeparator ].
	writer nextPut: anObject! !
!STON.ListWriter categoriesFor: #add:!accessing!public! !

