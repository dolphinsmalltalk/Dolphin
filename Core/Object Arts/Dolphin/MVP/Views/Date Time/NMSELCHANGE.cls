"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMSELCHANGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_stSelEnd' -> 16r1C.
		'_OffsetOf_stSelStart' -> 16rC
	}!
NMSELCHANGE guid: (GUID fromString: '{7ee1558c-5390-4f86-ada9-ae1300922720}')!
NMSELCHANGE comment: ''!
!NMSELCHANGE categoriesForClass!External-Data-Structured-Win32! !
!NMSELCHANGE methodsFor!

stSelEnd
	"Answer the <SYSTEMTIME> value of the receiver's 'stSelEnd' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + _OffsetOf_stSelEnd!

stSelStart
	"Answer the <SYSTEMTIME> value of the receiver's 'stSelStart' field."

	^SYSTEMTIME fromAddress: bytes yourAddress + _OffsetOf_stSelStart! !
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
		defineField: #stSelEnd type: (StructureField type: SYSTEMTIME) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #stSelStart #stSelEnd)! !
!NMSELCHANGE class categoriesFor: #defineFields!public!template definition! !
!NMSELCHANGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

