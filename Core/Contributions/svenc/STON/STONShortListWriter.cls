"Filed out from Dolphin Smalltalk"!

STONListWriter subclass: #STONShortListWriter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONShortListWriter guid: (GUID fromString: '{ee1770c5-72c7-4882-b356-730030a4deea}')!
STONShortListWriter comment: 'STONShortArrayWriter helps in writing short array based STON representations.
'!
!STONShortListWriter categoriesForClass!STON-Core-Writer! !
!STONShortListWriter methodsFor!

add: anObject
	first ifTrue: [ first := false ] ifFalse: [ writer shortListElementSeparator ].
	writer nextPut: anObject! !
!STONShortListWriter categoriesForMethods!
add:!accessing!public! !
!

