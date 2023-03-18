"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.PAINTSTRUCT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_fErase' -> 16r4.
		'_OffsetOf_fIncUpdate' -> 16r1C.
		'_OffsetOf_fRestore' -> 16r18.
		'_OffsetOf_hdc' -> 16r0.
		'_OffsetOf_rcPaint' -> 16r8.
		'_OffsetOf_rgbReserved' -> 16r20.
		'_PAINTSTRUCT_Size' -> 16r40
	}!
OS.PAINTSTRUCT guid: (Core.GUID fromString: '{87b4c605-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.PAINTSTRUCT comment: ''!
!OS.PAINTSTRUCT categoriesForClass!External-Data-Structured-Win32! !
!OS.PAINTSTRUCT methodsFor!

fErase
	"Answer the <Boolean> value of the receiver's 'fErase' field."

	^(bytes uint32AtOffset: _OffsetOf_fErase) asBoolean!

rcPaint
	"Answer the <RECTL> value of the receiver's 'rcPaint' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcPaint! !
!OS.PAINTSTRUCT categoriesForMethods!
fErase!**compiled accessors**!public! !
rcPaint!**compiled accessors**!public! !
!

!OS.PAINTSTRUCT class methodsFor!

byteSize
	^_PAINTSTRUCT_Size!

defineFields
	"Define the Win32 PAINTSTRUCT structure.
		PAINTSTRUCT compileDefinition
	"

	self
		defineField: #hdc type: UInt32Field readOnly beUncompiled;
		defineField: #fErase type: BOOLField readOnly;
		defineField: #rcPaint type: (StructureField type: RECTL) beReadOnly;
		defineField: #fRestore type: BOOLField filler;
		defineField: #fIncUpdate type: BOOLField filler;
		defineField: #rgbReserved type: (ArrayField type: ByteArray length: 32) beFiller
	"Help file wrongly species 16 bytes, header file says 32"!

getFieldNames
	^#(#hdc #fErase #rcPaint)! !
!OS.PAINTSTRUCT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

