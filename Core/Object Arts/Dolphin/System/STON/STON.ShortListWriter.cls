"Filed out from Dolphin Smalltalk 7"!

STON.ListWriter subclass: #'STON.ShortListWriter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.ShortListWriter guid: (Core.GUID fromString: '{ee1770c5-72c7-4882-b356-730030a4deea}')!
STON.ShortListWriter comment: 'STONShortArrayWriter helps in writing short array based STON representations.
'!
!STON.ShortListWriter categoriesForClass!STON-Core-Writer! !
!STON.ShortListWriter methodsFor!

add: anObject
	first ifTrue: [ first := false ] ifFalse: [ writer shortListElementSeparator ].
	writer nextPut: anObject! !
!STON.ShortListWriter categoriesFor: #add:!accessing!public! !

