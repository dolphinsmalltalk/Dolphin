"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.EMRTEXT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRTEXT_Size' -> 16r28.
			'_OffsetOf_fOptions' -> 16r10.
			'_OffsetOf_nChars' -> 16r8.
			'_OffsetOf_offDx' -> 16r24.
			'_OffsetOf_offString' -> 16rC.
			'_OffsetOf_ptlReference' -> 16r0.
			'_OffsetOf_rcl' -> 16r14
		}!

OS.EMRTEXT guid: (Core.GUID fromString: '{b8857668-f891-426b-8df0-ccc12b909e4d}')!

OS.EMRTEXT comment: '<EMRTEXT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRTEXT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(B8857668-F891-426B-8DF0-CCC12B909E4D)]
struct tagEMRTEXT {
	POINTL ptlReference;
	DWORD nChars;
	[helpstring("Offset to the string")] DWORD offString;
	DWORD fOptions;
	RECTL rcl;
	[helpstring("Offset to the inter-character spacing array. This is always given.")] DWORD offDx;
} EMRTEXT;
'!

!OS.EMRTEXT categoriesForClass!Win32-Structs! !

!OS.EMRTEXT methodsFor!

fOptions
	"Answer the <Integer> value of the receiver's 'fOptions' field."

	^bytes uint32AtOffset: _OffsetOf_fOptions!

fOptions: anInteger
	"Set the receiver's 'fOptions' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fOptions put: anInteger!

nChars
	"Answer the <Integer> value of the receiver's 'nChars' field."

	^bytes uint32AtOffset: _OffsetOf_nChars!

nChars: anInteger
	"Set the receiver's 'nChars' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nChars put: anInteger!

offDx
	"Answer the <Integer> value of the receiver's 'offDx' field."

	^bytes uint32AtOffset: _OffsetOf_offDx!

offDx: anInteger
	"Set the receiver's 'offDx' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offDx put: anInteger!

offString
	"Answer the <Integer> value of the receiver's 'offString' field."

	^bytes uint32AtOffset: _OffsetOf_offString!

offString: anInteger
	"Set the receiver's 'offString' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_offString put: anInteger!

ptlReference
	"Answer the <POINTL> value of the receiver's 'ptlReference' field."

	^POINTL fromAddress: bytes yourAddress!

ptlReference: aPOINTL
	"Set the receiver's 'ptlReference' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptlReference + 1)
		to: ##(_OffsetOf_ptlReference + POINTL._POINTL_Size)
		startingAt: 1!

rcl
	"Answer the <RECTL> value of the receiver's 'rcl' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcl!

rcl: aRECTL
	"Set the receiver's 'rcl' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcl + 1)
		to: ##(_OffsetOf_rcl + RECTL._RECTL_Size)
		startingAt: 1! !

!OS.EMRTEXT categoriesForMethods!
fOptions!**compiled accessors**!public! !
fOptions:!**compiled accessors**!public! !
nChars!**compiled accessors**!public! !
nChars:!**compiled accessors**!public! !
offDx!**compiled accessors**!public! !
offDx:!**compiled accessors**!public! !
offString!**compiled accessors**!public! !
offString:!**compiled accessors**!public! !
ptlReference!**compiled accessors**!public! !
ptlReference:!**compiled accessors**!public! !
rcl!**compiled accessors**!public! !
rcl:!**compiled accessors**!public! !
!

!OS.EMRTEXT class methodsFor!

byteSize
	^_EMRTEXT_Size!

defineFields
	"Define the fields of the EMRTEXT structure.

	EMRTEXT  compileDefinition

		typedef [uuid(B8857668-F891-426B-8DF0-CCC12B909E4D)]
		struct tagEMRTEXT {
			POINTL ptlReference;
			DWORD nChars;
			[helpstring('Offset to the string')] DWORD offString;
			DWORD fOptions;
			RECTL rcl;
			[helpstring('Offset to the inter-character spacing array. This is always given.')] DWORD offDx;
		} EMRTEXT;
"

	self
		defineField: #ptlReference
			type: (StructureField type: POINTL)
			offset: 0;
		defineField: #nChars
			type: UInt32Field new
			offset: 8;
		defineField: #offString
			type: UInt32Field new
			offset: 12;
		defineField: #fOptions
			type: UInt32Field new
			offset: 16;
		defineField: #rcl
			type: (StructureField type: RECTL)
			offset: 20;
		defineField: #offDx
			type: UInt32Field new
			offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#ptlReference #nChars #offString #fOptions #rcl #offDx)! !

!OS.EMRTEXT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

