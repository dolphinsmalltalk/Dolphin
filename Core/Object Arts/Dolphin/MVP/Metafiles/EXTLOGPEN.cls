"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #EXTLOGPEN
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_elpBrushStyle _OffsetOf_elpColor _OffsetOf_elpHatch _OffsetOf_elpNumEntries _OffsetOf_elpPenStyle _OffsetOf_elpStyleEntry _OffsetOf_elpWidth'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EXTLOGPEN guid: (GUID fromString: '{bfe902f1-81d2-4e1d-a5e3-1d0c3cef97e6}')!
EXTLOGPEN addClassConstant: '_OffsetOf_elpBrushStyle' value: 16r8!
EXTLOGPEN addClassConstant: '_OffsetOf_elpColor' value: 16rC!
EXTLOGPEN addClassConstant: '_OffsetOf_elpHatch' value: 16r10!
EXTLOGPEN addClassConstant: '_OffsetOf_elpNumEntries' value: 16r14!
EXTLOGPEN addClassConstant: '_OffsetOf_elpPenStyle' value: 16r0!
EXTLOGPEN addClassConstant: '_OffsetOf_elpStyleEntry' value: 16r18!
EXTLOGPEN addClassConstant: '_OffsetOf_elpWidth' value: 16r4!
EXTLOGPEN comment: '<EXTLOGPEN> is an <ExternalStructure> class to wrap the struct ''Win32.EXTLOGPEN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EXTLOGPEN categoriesForClass!Win32-Structs! !
!EXTLOGPEN methodsFor!

elpBrushStyle
	"Answer the <Integer> value of the receiver's 'elpBrushStyle' field."

	^bytes dwordAtOffset: _OffsetOf_elpBrushStyle!

elpBrushStyle: anInteger
	"Set the receiver's 'elpBrushStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_elpBrushStyle put: anInteger!

elpColor
	"Answer the <Integer> value of the receiver's 'elpColor' field."

	^bytes dwordAtOffset: _OffsetOf_elpColor!

elpColor: anInteger
	"Set the receiver's 'elpColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_elpColor put: anInteger!

elpHatch
	"Answer the <Integer> value of the receiver's 'elpHatch' field."

	^bytes sdwordAtOffset: _OffsetOf_elpHatch!

elpHatch: anInteger
	"Set the receiver's 'elpHatch' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_elpHatch put: anInteger!

elpNumEntries
	"Answer the <Integer> value of the receiver's 'elpNumEntries' field."

	^bytes dwordAtOffset: _OffsetOf_elpNumEntries!

elpNumEntries: anInteger
	"Set the receiver's 'elpNumEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_elpNumEntries put: anInteger!

elpPenStyle
	"Answer the <Integer> value of the receiver's 'elpPenStyle' field."

	^bytes dwordAtOffset: _OffsetOf_elpPenStyle!

elpPenStyle: anInteger
	"Set the receiver's 'elpPenStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_elpPenStyle put: anInteger!

elpStyleEntry
	"Answer the <DWORDArray> value of the receiver's 'elpStyleEntry' field."

	^DWORDArray fromAddress: bytes yourAddress + _OffsetOf_elpStyleEntry length: self elpNumEntries!

elpStyleEntry: aDWORDArray
	"Set the receiver's 'elpStyleEntry' field to the value of the argument, aDWORDArray"

	| size |
	size := aDWORDArray byteSize.
	aDWORDArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elpStyleEntry + 1)
		to: _OffsetOf_elpStyleEntry + size
		startingAt: 1.
	self elpNumEntries: aDWORDArray size!

elpWidth
	"Answer the <Integer> value of the receiver's 'elpWidth' field."

	^bytes dwordAtOffset: _OffsetOf_elpWidth!

elpWidth: anInteger
	"Set the receiver's 'elpWidth' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_elpWidth put: anInteger! !
!EXTLOGPEN categoriesForMethods!
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

!EXTLOGPEN class methodsFor!

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
			type: DWORDField new
			offset: 0;
		defineField: #elpWidth
			type: DWORDField new
			offset: 4;
		defineField: #elpBrushStyle
			type: DWORDField new
			offset: 8;
		defineField: #elpColor
			type: DWORDField new
			offset: 12;
		defineField: #elpHatch
			type: SDWORDField new
			offset: 16;
		defineField: #elpNumEntries
			type: DWORDField new
			offset: 20;
		defineField: #elpStyleEntry
			type: (ArrayField type: DWORDArray
					arrayLength: (ConformantArrayFieldLength lengthField: #elpNumEntries))
			offset: 24!

getFieldNames
	^#(#elpPenStyle #elpWidth #elpBrushStyle #elpColor #elpHatch #elpNumEntries #elpStyleEntry)! !
!EXTLOGPEN class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

