"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #EXTLOGPEN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EXTLOGPEN guid: (GUID fromString: '{bfe902f1-81d2-4e1d-a5e3-1d0c3cef97e6}')!
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

	^bytes dwordAtOffset: ##(self offsetOf: #elpBrushStyle)!

elpBrushStyle: anInteger
	"Set the receiver's 'elpBrushStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #elpBrushStyle) put: anInteger!

elpColor
	"Answer the <Integer> value of the receiver's 'elpColor' field."

	^bytes dwordAtOffset: ##(self offsetOf: #elpColor)!

elpColor: anInteger
	"Set the receiver's 'elpColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #elpColor) put: anInteger!

elpHatch
	"Answer the <Integer> value of the receiver's 'elpHatch' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #elpHatch)!

elpHatch: anInteger
	"Set the receiver's 'elpHatch' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #elpHatch) put: anInteger!

elpNumEntries
	"Answer the <Integer> value of the receiver's 'elpNumEntries' field."

	^bytes dwordAtOffset: ##(self offsetOf: #elpNumEntries)!

elpNumEntries: anInteger
	"Set the receiver's 'elpNumEntries' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #elpNumEntries) put: anInteger!

elpPenStyle
	"Answer the <Integer> value of the receiver's 'elpPenStyle' field."

	^bytes dwordAtOffset: 0!

elpPenStyle: anInteger
	"Set the receiver's 'elpPenStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

elpStyleEntry
	"Answer the <DWORDArray> value of the receiver's 'elpStyleEntry' field."

	^DWORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #elpStyleEntry)
		length: self elpNumEntries!

elpStyleEntry: aDWORDArray
	"Set the receiver's 'elpStyleEntry' field to the value of the argument, aDWORDArray"

	| size |
	size := aDWORDArray byteSize.
	aDWORDArray
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elpStyleEntry) + 1)
		to: ##(self offsetOf: #elpStyleEntry) + size
		startingAt: 1.
	self elpNumEntries: aDWORDArray size!

elpWidth
	"Answer the <Integer> value of the receiver's 'elpWidth' field."

	^bytes dwordAtOffset: ##(self offsetOf: #elpWidth)!

elpWidth: anInteger
	"Set the receiver's 'elpWidth' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #elpWidth) put: anInteger! !
!EXTLOGPEN categoriesFor: #elpBrushStyle!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpBrushStyle:!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpColor!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpColor:!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpHatch!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpHatch:!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpNumEntries!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpNumEntries:!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpPenStyle!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpPenStyle:!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpStyleEntry!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpStyleEntry:!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpWidth!**compiled accessors**!public! !
!EXTLOGPEN categoriesFor: #elpWidth:!**compiled accessors**!public! !

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
!EXTLOGPEN class categoriesFor: #defineFields!initializing!public! !
!EXTLOGPEN class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

