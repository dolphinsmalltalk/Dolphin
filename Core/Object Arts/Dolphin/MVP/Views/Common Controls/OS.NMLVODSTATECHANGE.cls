"Filed out from Dolphin Smalltalk 7"!

OS.NMHDR subclass: #'OS.NMLVODSTATECHANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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
!OS.NMLVODSTATECHANGE categoriesFor: #iFrom!**compiled accessors**!public! !
!OS.NMLVODSTATECHANGE categoriesFor: #iTo!**compiled accessors**!public! !
!OS.NMLVODSTATECHANGE categoriesFor: #uNewState!**compiled accessors**!public! !
!OS.NMLVODSTATECHANGE categoriesFor: #uOldState!**compiled accessors**!public! !

!OS.NMLVODSTATECHANGE class methodsFor!

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
!OS.NMLVODSTATECHANGE class categoriesFor: #defineFields!public!template definition! !
!OS.NMLVODSTATECHANGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

