"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #WINDOWPLACEMENT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_flags _OffsetOf_ptMaxPosition _OffsetOf_ptMinPosition _OffsetOf_rcNormalPosition _OffsetOf_showCmd'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WINDOWPLACEMENT guid: (GUID fromString: '{87b4c61b-026e-11d3-9fd7-00a0cc3e4a32}')!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_dwSize' value: 16r0!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_flags' value: 16r4!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_ptMaxPosition' value: 16r14!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_ptMinPosition' value: 16rC!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_rcNormalPosition' value: 16r1C!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_showCmd' value: 16r8!
WINDOWPLACEMENT comment: ''!
!WINDOWPLACEMENT categoriesForClass!External-Data-Structured-Win32! !
!WINDOWPLACEMENT methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

rcNormalPosition
	"Answer the <RECT> value of the receiver's 'rcNormalPosition' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcNormalPosition!

rcNormalPosition: aRECT
	"Set the receiver's 'rcNormalPosition' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcNormalPosition + 1)
		to: ##(_OffsetOf_rcNormalPosition + RECT basicByteSize)
		startingAt: 1!

showCmd
	"Answer the <Integer> value of the receiver's 'showCmd' field."

	^bytes dwordAtOffset: _OffsetOf_showCmd!

showCmd: anInteger
	"Set the receiver's 'showCmd' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_showCmd put: anInteger! !
!WINDOWPLACEMENT categoriesForMethods!
dwSize:!**compiled accessors**!public! !
rcNormalPosition!**compiled accessors**!public! !
rcNormalPosition:!**compiled accessors**!public! !
showCmd!**compiled accessors**!public! !
showCmd:!**compiled accessors**!public! !
!

!WINDOWPLACEMENT class methodsFor!

defineFields
	"Define the layout of the Win32 WINDOWPLACEMENT structure. 
	Currently to avoid wasting space, the structure is defined as mostly filler 
	fields.

		WINDOWPLACEMENT compileDefinition

		typedef struct tagWINDOWPLACEMENT {
			UINT  length;
			UINT  flags;
			UINT  showCmd;
			POINT ptMinPosition;
			POINT ptMaxPosition;
			RECT  rcNormalPosition;
		} WINDOWPLACEMENT;"

	self 
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #flags type: DWORDField filler;
		defineField: #showCmd type: DWORDField new;
		defineField: #ptMinPosition type: (StructureField type: POINTL) beFiller;
		defineField: #ptMaxPosition type: (StructureField type: POINTL) beFiller;
		defineField: #rcNormalPosition type: (StructureField type: RECT)
!

getFieldNames
	^#(#dwSize #showCmd #rcNormalPosition)! !
!WINDOWPLACEMENT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

