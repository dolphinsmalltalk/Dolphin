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
	"Answer the receiver's elpBrushStyle field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elpBrushStyle)!

elpBrushStyle: anObject 
	"Set the receiver's elpBrushStyle field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elpBrushStyle) put: anObject!

elpColor
	"Answer the receiver's elpColor field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elpColor)!

elpColor: anObject 
	"Set the receiver's elpColor field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elpColor) put: anObject!

elpHatch
	"Answer the receiver's elpHatch field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #elpHatch)!

elpHatch: anObject 
	"Set the receiver's elpHatch field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #elpHatch) put: anObject!

elpNumEntries
	"Answer the receiver's elpNumEntries field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elpNumEntries)!

elpNumEntries: anObject 
	"Set the receiver's elpNumEntries field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elpNumEntries) put: anObject!

elpPenStyle
	"Answer the receiver's elpPenStyle field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

elpPenStyle: anObject 
	"Set the receiver's elpPenStyle field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

elpStyleEntry
	"Answer the receiver's elpStyleEntry field as a Smalltalk object."

	^DWORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #elpStyleEntry)
		length: self elpNumEntries!

elpStyleEntry: anObject 
	"Set the receiver's elpStyleEntry field to the value of anObject."

	| size |
	size := anObject byteSize min: self elpNumEntries * ##(DWORDArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elpStyleEntry) + 1)
		to: ##(self offsetOf: #elpStyleEntry) + size
		startingAt: 1!

elpWidth
	"Answer the receiver's elpWidth field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elpWidth)!

elpWidth: anObject 
	"Set the receiver's elpWidth field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elpWidth) put: anObject! !
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
			type: (ConformantArrayField type: DWORDArray length: #elpNumEntries)
			offset: 24! !
!EXTLOGPEN class categoriesFor: #defineFields!initializing!public! !

