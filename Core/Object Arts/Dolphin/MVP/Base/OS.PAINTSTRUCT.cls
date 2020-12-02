"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #PAINTSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_fErase' -> 16r4.
		'_OffsetOf_fIncUpdate' -> 16r1C.
		'_OffsetOf_fRestore' -> 16r18.
		'_OffsetOf_hdc' -> 16r0.
		'_OffsetOf_rcPaint' -> 16r8.
		'_OffsetOf_rgbReserved' -> 16r20
	}!
PAINTSTRUCT guid: (GUID fromString: '{87b4c605-026e-11d3-9fd7-00a0cc3e4a32}')!
PAINTSTRUCT comment: ''!
!PAINTSTRUCT categoriesForClass!External-Data-Structured-Win32! !
!PAINTSTRUCT methodsFor!

fErase
	"Answer the <Boolean> value of the receiver's 'fErase' field."

	^(bytes dwordAtOffset: _OffsetOf_fErase) asBoolean!

rcPaint
	"Answer the <RECT> value of the receiver's 'rcPaint' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcPaint! !
!PAINTSTRUCT categoriesFor: #fErase!**compiled accessors**!public! !
!PAINTSTRUCT categoriesFor: #rcPaint!**compiled accessors**!public! !

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
!PAINTSTRUCT class categoriesFor: #defineFields!public!template definition! !
!PAINTSTRUCT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

