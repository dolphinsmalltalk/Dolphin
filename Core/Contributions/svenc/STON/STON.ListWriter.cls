"Filed out from Dolphin Smalltalk 7"!

STONStreamWriter subclass: #STONListWriter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STONListWriter guid: (GUID fromString: '{7f97d53a-86b9-4db6-9949-a819d1045f49}')!
STONListWriter comment: 'STONArrayWriter helps in writing array based STON representations.
'!
!STONListWriter categoriesForClass!STON-Core-Writer! !
!STONListWriter methodsFor!

add: anObject
	first ifTrue: [ first := false ] ifFalse: [ writer listElementSeparator ].
	writer nextPut: anObject! !
!STONListWriter categoriesFor: #add:!accessing!public! !

