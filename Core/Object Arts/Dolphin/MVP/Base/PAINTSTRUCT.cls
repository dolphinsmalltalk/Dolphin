"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #PAINTSTRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_fErase _OffsetOf_fIncUpdate _OffsetOf_fRestore _OffsetOf_hdc _OffsetOf_rcPaint _OffsetOf_rgbReserved'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PAINTSTRUCT guid: (GUID fromString: '{87b4c605-026e-11d3-9fd7-00a0cc3e4a32}')!
PAINTSTRUCT addClassConstant: '_OffsetOf_fErase' value: 16r4!
PAINTSTRUCT addClassConstant: '_OffsetOf_fIncUpdate' value: 16r1C!
PAINTSTRUCT addClassConstant: '_OffsetOf_fRestore' value: 16r18!
PAINTSTRUCT addClassConstant: '_OffsetOf_hdc' value: 16r0!
PAINTSTRUCT addClassConstant: '_OffsetOf_rcPaint' value: 16r8!
PAINTSTRUCT addClassConstant: '_OffsetOf_rgbReserved' value: 16r20!
PAINTSTRUCT comment: ''!
!PAINTSTRUCT categoriesForClass!External-Data-Structured-Win32! !
!PAINTSTRUCT methodsFor!

fErase
	"Answer the <Boolean> value of the receiver's 'fErase' field."

	^(bytes dwordAtOffset: _OffsetOf_fErase) asBoolean!

rcPaint
	"Answer the <RECT> value of the receiver's 'rcPaint' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcPaint! !
!PAINTSTRUCT categoriesForMethods!
fErase!**compiled accessors**!public! !
rcPaint!**compiled accessors**!public! !
!

!PAINTSTRUCT class methodsFor!

defineFields
	"Define the Win32 PAINTSTRUCT structure.
		PAINTSTRUCT compileDefinition
	"

	self
		defineField: #hdc type: DWORDField readOnly beUncompiled;
		defineField: #fErase type: BOOLField readOnly;
		defineField: #rcPaint type: (StructureField type: RECT) beReadOnly;
		defineField: #fRestore type: BOOLField filler;
		defineField: #fIncUpdate type: BOOLField filler;
		"Help file wrongly species 16 bytes, header file says 32"
		defineField: #rgbReserved type: (ArrayField type: ByteArray length: 32) beFiller!

getFieldNames
	^#(#hdc #fErase #rcPaint)! !
!PAINTSTRUCT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

