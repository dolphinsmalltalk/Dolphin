"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.WINDOWPLACEMENT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_flags' -> 16r4.
			'_OffsetOf_ptMaxPosition' -> 16r14.
			'_OffsetOf_ptMinPosition' -> 16rC.
			'_OffsetOf_rcNormalPosition' -> 16r1C.
			'_OffsetOf_showCmd' -> 16r8.
			'_WINDOWPLACEMENT_Size' -> 16r2C
		}!
OS.WINDOWPLACEMENT guid: (Core.GUID fromString: '{87b4c61b-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.WINDOWPLACEMENT comment: ''!
!OS.WINDOWPLACEMENT categoriesForClass!External-Data-Structured-Win32! !
!OS.WINDOWPLACEMENT methodsFor!

rcNormalPosition
	"Answer the <RECTL> value of the receiver's 'rcNormalPosition' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcNormalPosition!

rcNormalPosition: aRECTL
	"Set the receiver's 'rcNormalPosition' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcNormalPosition + 1)
		to: ##(_OffsetOf_rcNormalPosition + RECTL._RECTL_Size)
		startingAt: 1!

showCmd
	"Answer the <Integer> value of the receiver's 'showCmd' field."

	^bytes uint32AtOffset: _OffsetOf_showCmd!

showCmd: anInteger
	"Set the receiver's 'showCmd' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_showCmd put: anInteger! !
!OS.WINDOWPLACEMENT categoriesForMethods!
rcNormalPosition!**compiled accessors**!public! !
rcNormalPosition:!**compiled accessors**!public! !
showCmd!**compiled accessors**!public! !
showCmd:!**compiled accessors**!public! !
!

!OS.WINDOWPLACEMENT class methodsFor!

byteSize
	^_WINDOWPLACEMENT_Size!

defineFields
	"Define the layout of the Win32 WINDOWPLACEMENT structure. 
	Currently to avoid wasting space, the structure is defined as mostly filler 
	fields.

		WINDOWPLACEMENT compileDefinition

		typedef struct tagWINDOWPLACEMENT {
			UINT  length;
			UINT  flags;
			UINT  showCmd;
			POINTL ptMinPosition;
			POINTL ptMaxPosition;
			RECTL  rcNormalPosition;
		} WINDOWPLACEMENT;"

	super defineFields.
	self
		defineField: #flags type: UInt32Field filler;
		defineField: #showCmd type: UInt32Field new;
		defineField: #ptMinPosition type: (StructureField type: POINTL) beFiller;
		defineField: #ptMaxPosition type: (StructureField type: POINTL) beFiller;
		defineField: #rcNormalPosition type: (StructureField type: RECTL)!

getFieldNames
	^#(#dwSize #showCmd #rcNormalPosition)! !
!OS.WINDOWPLACEMENT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

