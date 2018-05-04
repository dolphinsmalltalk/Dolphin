"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMSELCHANGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMSELCHANGE guid: (GUID fromString: '{7ee1558c-5390-4f86-ada9-ae1300922720}')!
NMSELCHANGE comment: ''!
!NMSELCHANGE categoriesForClass!External-Data-Structured-Win32! !
!NMSELCHANGE methodsFor!

stSelEnd
	"Answer the receiver's stSelEnd field as a Smalltalk object."

	^SYSTEMTIME fromAddress: (bytes yourAddress + 28)!

stSelStart
	"Answer the receiver's stSelStart field as a Smalltalk object."

	^SYSTEMTIME fromAddress: (bytes yourAddress + 12)! !
!NMSELCHANGE categoriesFor: #stSelEnd!**compiled accessors**!public! !
!NMSELCHANGE categoriesFor: #stSelStart!**compiled accessors**!public! !

!NMSELCHANGE class methodsFor!

defineFields
	"Define the fields of the Win32 NMSELCHANGE structure.
		NMSELCHANGE compileDefinition
	"

	super defineFields.
	self
		defineField: #stSelStart type: (StructureField type: SYSTEMTIME) beReadOnly;
		defineField: #stSelEnd type: (StructureField type: SYSTEMTIME) beReadOnly! !
!NMSELCHANGE class categoriesFor: #defineFields!initializing!public! !

