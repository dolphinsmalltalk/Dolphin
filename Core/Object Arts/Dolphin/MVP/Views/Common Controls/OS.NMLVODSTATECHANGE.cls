"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMLVODSTATECHANGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iFrom' -> 16rC.
		'_OffsetOf_iTo' -> 16r10.
		'_OffsetOf_uNewState' -> 16r14.
		'_OffsetOf_uOldState' -> 16r18
	}!
NMLVODSTATECHANGE guid: (GUID fromString: '{f44c9148-2b3f-11d3-8368-7a8b5a000000}')!
NMLVODSTATECHANGE comment: ''!
!NMLVODSTATECHANGE categoriesForClass!External-Data-Structured-Win32! !
!NMLVODSTATECHANGE methodsFor!

iFrom
	"Answer the <Integer> value of the receiver's 'iFrom' field."

	^bytes sdwordAtOffset: _OffsetOf_iFrom!

iTo
	"Answer the <Integer> value of the receiver's 'iTo' field."

	^bytes sdwordAtOffset: _OffsetOf_iTo!

uNewState
	"Answer the <Integer> value of the receiver's 'uNewState' field."

	^bytes dwordAtOffset: _OffsetOf_uNewState!

uOldState
	"Answer the <Integer> value of the receiver's 'uOldState' field."

	^bytes dwordAtOffset: _OffsetOf_uOldState! !
!NMLVODSTATECHANGE categoriesFor: #iFrom!**compiled accessors**!public! !
!NMLVODSTATECHANGE categoriesFor: #iTo!**compiled accessors**!public! !
!NMLVODSTATECHANGE categoriesFor: #uNewState!**compiled accessors**!public! !
!NMLVODSTATECHANGE categoriesFor: #uOldState!**compiled accessors**!public! !

!NMLVODSTATECHANGE class methodsFor!

defineFields
	"Define the structure template for Win32 NMLVODSTATECHANGE structure.
		NMLVODSTATECHANGE compileDefinition
	"

	super defineFields.
	self 
		defineField: #iFrom type: SDWORDField readOnly;
		defineField: #iTo type: SDWORDField readOnly;
		defineField: #uNewState type: DWORDField readOnly;
		defineField: #uOldState type: DWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iFrom #iTo #uNewState #uOldState)! !
!NMLVODSTATECHANGE class categoriesFor: #defineFields!public!template definition! !
!NMLVODSTATECHANGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

