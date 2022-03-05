"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #GETTEXTEX
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cb _OffsetOf_codepage _OffsetOf_flags _OffsetOf_lpDefaultChar _OffsetOf_lpUsedDefChar'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GETTEXTEX guid: (GUID fromString: '{1ac7d35c-befe-4c13-b0b2-0c96f50feca0}')!
GETTEXTEX addClassConstant: '_OffsetOf_cb' value: 16r0!
GETTEXTEX addClassConstant: '_OffsetOf_codepage' value: 16r8!
GETTEXTEX addClassConstant: '_OffsetOf_flags' value: 16r4!
GETTEXTEX addClassConstant: '_OffsetOf_lpDefaultChar' value: 16rC!
GETTEXTEX addClassConstant: '_OffsetOf_lpUsedDefChar' value: 16r10!
GETTEXTEX comment: ''!
!GETTEXTEX categoriesForClass!External-Data-Structured-Win32! !
!GETTEXTEX methodsFor!

cb
	"Answer the <Integer> value of the receiver's 'cb' field."

	^bytes dwordAtOffset: _OffsetOf_cb!

cb: anInteger
	"Set the receiver's 'cb' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cb put: anInteger!

codepage: anInteger
	"Set the receiver's 'codepage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_codepage put: anInteger!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger! !
!GETTEXTEX categoriesForMethods!
cb!**compiled accessors**!public! !
cb:!**compiled accessors**!public! !
codepage:!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
!

!GETTEXTEX class methodsFor!

defineFields
	"Define the fields of the GETTEXTEX structure.
		self compileDefinition
	"

	self
		defineField: #cb type: DWORDField new;
		defineField: #flags type: DWORDField writeOnly;
		defineField: #codepage type: DWORDField writeOnly;
		defineField: #lpDefaultChar type: (PointerField type: String) beFiller;
		defineField: #lpUsedDefChar type: (PointerField type: BOOL) beFiller!

getFieldNames
	^#(#cb #flags #codepage)! !
!GETTEXTEX class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

