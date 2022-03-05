"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMLVODSTATECHANGE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iFrom _OffsetOf_iTo _OffsetOf_uNewState _OffsetOf_uOldState'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVODSTATECHANGE guid: (GUID fromString: '{f44c9148-2b3f-11d3-8368-7a8b5a000000}')!
NMLVODSTATECHANGE addClassConstant: '_OffsetOf_iFrom' value: 16rC!
NMLVODSTATECHANGE addClassConstant: '_OffsetOf_iTo' value: 16r10!
NMLVODSTATECHANGE addClassConstant: '_OffsetOf_uNewState' value: 16r14!
NMLVODSTATECHANGE addClassConstant: '_OffsetOf_uOldState' value: 16r18!
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
!NMLVODSTATECHANGE categoriesForMethods!
iFrom!**compiled accessors**!public! !
iTo!**compiled accessors**!public! !
uNewState!**compiled accessors**!public! !
uOldState!**compiled accessors**!public! !
!

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
!NMLVODSTATECHANGE class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

