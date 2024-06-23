"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.EXTLOGPEN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EXTLOGPEN_Size' -> 16r1C.
			'_OffsetOf_elpBrushStyle' -> 16r8.
			'_OffsetOf_elpColor' -> 16rC.
			'_OffsetOf_elpHatch' -> 16r10.
			'_OffsetOf_elpNumEntries' -> 16r14.
			'_OffsetOf_elpPenStyle' -> 16r0.
			'_OffsetOf_elpStyleEntry' -> 16r18.
			'_OffsetOf_elpWidth' -> 16r4
		}!

OS.EXTLOGPEN guid: (Core.GUID fromString: '{bfe902f1-81d2-4e1d-a5e3-1d0c3cef97e6}')!

OS.EXTLOGPEN comment: '<EXTLOGPEN> is an <ExternalStructure> class to wrap the struct ''Win32.EXTLOGPEN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BFE902F1-81D2-4E1D-A5E3-1D0C3CEF97E6)]
struct tagEXTLOGPEN {
	DWORD elpPenStyle;
	DWORD elpWidth;
	UINT elpBrushStyle;
	COLORREF elpColor;
	long elpHatch;
	DWORD elpNumEntries;
	DWORD* elpStyleEntry;
} EXTLOGPEN;
'!

!OS.EXTLOGPEN categoriesForClass!Win32-Structs! !

!OS.EXTLOGPEN methodsFor!

elpBrushStyle
	"Answer the <Integer> value of the receiver's 'elpBrushStyle' field."

	^bytes uint32AtOffset: _OffsetOf_elpBrushStyle!

elpBrushStyle: anInteger
	"Set the receiver's 'elpBrushStyle' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_elpBrushStyle put: anInteger!

elpColor
	"Answer the <Integer> value of the receiver's 'elpColor' field."

	^bytes uint32AtOffset: _OffsetOf_elpColor!

elpColor: anInteger
	"Set the receiver's 'elpColor' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_elpColor put: anInteger!

elpHatch
	"Answer the <Integer> value of the receiver's 'elpHatch' field."

	^bytes int32AtOffset: _OffsetOf_elpHatch!

elpHatch: anInteger
	"Set the receiver's 'elpHatch' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_elpHatch put: anInteger!

elpNumEntries
	"Answer the <Integer> value of the receiver's 'elpNumEntries' field."

	^bytes uint32AtOffset: _OffsetOf_elpNumEntries!

elpNumEntries: anInteger
	"Set the receiver's 'elpNumEntries' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_elpNumEntries put: anInteger!

elpPenStyle
	"Answer the <Integer> value of the receiver's 'elpPenStyle' field."

	^bytes uint32AtOffset: _OffsetOf_elpPenStyle!

elpPenStyle: anInteger
	"Set the receiver's 'elpPenStyle' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_elpPenStyle put: anInteger!

elpStyleEntry
	"Answer the <UInt32Array> value of the receiver's 'elpStyleEntry' field."

	^UInt32Array fromAddress: bytes yourAddress + _OffsetOf_elpStyleEntry length: self elpNumEntries!

elpStyleEntry: aUInt32Array
	"Set the receiver's 'elpStyleEntry' field to the value of the argument, aUInt32Array"

	| size |
	size := aUInt32Array byteSize.
	aUInt32Array
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elpStyleEntry + 1)
		to: _OffsetOf_elpStyleEntry + size
		startingAt: 1.
	self elpNumEntries: aUInt32Array size!

elpWidth
	"Answer the <Integer> value of the receiver's 'elpWidth' field."

	^bytes uint32AtOffset: _OffsetOf_elpWidth!

elpWidth: anInteger
	"Set the receiver's 'elpWidth' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_elpWidth put: anInteger! !

!OS.EXTLOGPEN categoriesForMethods!
elpBrushStyle!**compiled accessors**!public! !
elpBrushStyle:!**compiled accessors**!public! !
elpColor!**compiled accessors**!public! !
elpColor:!**compiled accessors**!public! !
elpHatch!**compiled accessors**!public! !
elpHatch:!**compiled accessors**!public! !
elpNumEntries!**compiled accessors**!public! !
elpNumEntries:!**compiled accessors**!public! !
elpPenStyle!**compiled accessors**!public! !
elpPenStyle:!**compiled accessors**!public! !
elpStyleEntry!**compiled accessors**!public! !
elpStyleEntry:!**compiled accessors**!public! !
elpWidth!**compiled accessors**!public! !
elpWidth:!**compiled accessors**!public! !
!

!OS.EXTLOGPEN class methodsFor!

byteSize
	^_EXTLOGPEN_Size!

defineFields
	"Define the fields of the EXTLOGPEN structure.

	EXTLOGPEN  compileDefinition

		typedef [uuid(BFE902F1-81D2-4E1D-A5E3-1D0C3CEF97E6)]
		struct tagEXTLOGPEN {
			DWORD elpPenStyle;
			DWORD elpWidth;
			UINT elpBrushStyle;
			COLORREF elpColor;
			long elpHatch;
			DWORD elpNumEntries;
			DWORD* elpStyleEntry;
		} EXTLOGPEN;
"

	self
		defineField: #elpPenStyle
			type: UInt32Field new
			offset: 0;
		defineField: #elpWidth
			type: UInt32Field new
			offset: 4;
		defineField: #elpBrushStyle
			type: UInt32Field new
			offset: 8;
		defineField: #elpColor
			type: UInt32Field new
			offset: 12;
		defineField: #elpHatch
			type: Int32Field new
			offset: 16;
		defineField: #elpNumEntries
			type: UInt32Field new
			offset: 20;
		defineField: #elpStyleEntry
			type: (ArrayField type: UInt32Array
					arrayLength: (ConformantArrayFieldLength lengthField: #elpNumEntries))
			offset: 24!

getFieldNames
	^#(#elpPenStyle #elpWidth #elpBrushStyle #elpColor #elpHatch #elpNumEntries #elpStyleEntry)! !

!OS.EXTLOGPEN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

