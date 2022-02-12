"Filed out from Dolphin Smalltalk"!

OS.NMHDR subclass: #'OS.NMLVODSTATECHANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_NMLVODSTATECHANGE_Size' -> 16r1C.
		'_OffsetOf_iFrom' -> 16rC.
		'_OffsetOf_iTo' -> 16r10.
		'_OffsetOf_uNewState' -> 16r14.
		'_OffsetOf_uOldState' -> 16r18
	}!
OS.NMLVODSTATECHANGE guid: (Core.GUID fromString: '{f44c9148-2b3f-11d3-8368-7a8b5a000000}')!
OS.NMLVODSTATECHANGE comment: ''!
!OS.NMLVODSTATECHANGE categoriesForClass!External-Data-Structured-Win32! !
!OS.NMLVODSTATECHANGE methodsFor!

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
!OS.NMLVODSTATECHANGE categoriesForMethods!
iFrom!**compiled accessors**!public! !
iTo!**compiled accessors**!public! !
uNewState!**compiled accessors**!public! !
uOldState!**compiled accessors**!public! !
!

!OS.NMLVODSTATECHANGE class methodsFor!

byteSize
	^_NMLVODSTATECHANGE_Size!

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
!OS.NMLVODSTATECHANGE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

