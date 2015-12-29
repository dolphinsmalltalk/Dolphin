"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #GpMetafileHeader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpMetafileHeader guid: (GUID fromString: '{83583420-DBFC-415F-AB1B-93E52A2206EF}')!
GpMetafileHeader comment: '<GpMetafileHeader> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpMetafileHeader'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(83583420-DBFC-415F-AB1B-93E52A2206EF)]
struct tagGpMetafileHeader {
	MetafileType type;
	unsigned int size;
	unsigned int Version;
	unsigned int EmfPlusFlags;
	single DpiX;
	single DpiY;
	int x;
	int y;
	int width;
	int height;
	_MIDL___MIDL_itf_Gidplus_0000_0001 __MIDL_0015;
	int EmfPlusHeaderSize;
	int LogicalDpiX;
	int LogicalDpiY;
} GpMetafileHeader;
'!
!GpMetafileHeader categoriesForClass!Unclassified! !
!GpMetafileHeader methodsFor!

DpiX
	"Answer the receiver's DpiX field as a Smalltalk object."

	^(bytes floatAtOffset: 16)!

DpiX: anObject
	"Set the receiver's DpiX field to the value of anObject."

	bytes floatAtOffset: 16 put: anObject!

DpiY
	"Answer the receiver's DpiY field as a Smalltalk object."

	^(bytes floatAtOffset: 20)!

DpiY: anObject
	"Set the receiver's DpiY field to the value of anObject."

	bytes floatAtOffset: 20 put: anObject!

EmfHeader
	"Answer the receiver's EmfHeader field as a Smalltalk object."

	^ENHMETAHEADER3 fromAddress: (bytes yourAddress + 40)!

EmfHeader: anObject
	"Set the receiver's EmfHeader field to the value of anObject."

	anObject replaceBytesOf: bytes from: 41 to: 128 startingAt: 1!

EmfPlusFlags
	"Answer the receiver's EmfPlusFlags field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

EmfPlusFlags: anObject
	"Set the receiver's EmfPlusFlags field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

EmfPlusHeaderSize
	"Answer the receiver's EmfPlusHeaderSize field as a Smalltalk object."

	^(bytes sdwordAtOffset: 128)!

EmfPlusHeaderSize: anObject
	"Set the receiver's EmfPlusHeaderSize field to the value of anObject."

	bytes sdwordAtOffset: 128 put: anObject!

height
	"Answer the receiver's height field as a Smalltalk object."

	^(bytes sdwordAtOffset: 36)!

height: anObject
	"Set the receiver's height field to the value of anObject."

	bytes sdwordAtOffset: 36 put: anObject!

LogicalDpiX
	"Answer the receiver's LogicalDpiX field as a Smalltalk object."

	^(bytes sdwordAtOffset: 132)!

LogicalDpiX: anObject
	"Set the receiver's LogicalDpiX field to the value of anObject."

	bytes sdwordAtOffset: 132 put: anObject!

LogicalDpiY
	"Answer the receiver's LogicalDpiY field as a Smalltalk object."

	^(bytes sdwordAtOffset: 136)!

LogicalDpiY: anObject
	"Set the receiver's LogicalDpiY field to the value of anObject."

	bytes sdwordAtOffset: 136 put: anObject!

size
	"Answer the receiver's size field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

size: anObject
	"Set the receiver's size field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

type
	"Answer the receiver's type field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

type: anObject
	"Set the receiver's type field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

Version
	"Answer the receiver's Version field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

Version: anObject
	"Set the receiver's Version field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

width
	"Answer the receiver's width field as a Smalltalk object."

	^(bytes sdwordAtOffset: 32)!

width: anObject
	"Set the receiver's width field to the value of anObject."

	bytes sdwordAtOffset: 32 put: anObject!

WmfHeader
	"Answer the receiver's WmfHeader field as a Smalltalk object."

	^METAHEADER fromAddress: (bytes yourAddress + 40)!

WmfHeader: anObject
	"Set the receiver's WmfHeader field to the value of anObject."

	anObject replaceBytesOf: bytes from: 41 to: 64 startingAt: 1!

x
	"Answer the receiver's x field as a Smalltalk object."

	^(bytes sdwordAtOffset: 24)!

x: anObject
	"Set the receiver's x field to the value of anObject."

	bytes sdwordAtOffset: 24 put: anObject!

y
	"Answer the receiver's y field as a Smalltalk object."

	^(bytes sdwordAtOffset: 28)!

y: anObject
	"Set the receiver's y field to the value of anObject."

	bytes sdwordAtOffset: 28 put: anObject! !
!GpMetafileHeader categoriesFor: #DpiX!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #DpiX:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #DpiY!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #DpiY:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #EmfHeader!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #EmfHeader:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #EmfPlusFlags!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #EmfPlusFlags:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #EmfPlusHeaderSize!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #EmfPlusHeaderSize:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #height!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #height:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #LogicalDpiX!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #LogicalDpiX:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #LogicalDpiY!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #LogicalDpiY:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #size!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #size:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #type!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #type:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #Version!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #Version:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #width!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #width:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #WmfHeader!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #WmfHeader:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #x!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #x:!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #y!**compiled accessors**!public! !
!GpMetafileHeader categoriesFor: #y:!**compiled accessors**!public! !

!GpMetafileHeader class methodsFor!

defineFields
	"Define the fields of the GpMetafileHeader structure.
		GpMetafileHeader compileDefinition
	
		typedef [uuid(83583420-DBFC-415F-AB1B-93E52A2206EF)]
		struct tagGpMetafileHeader {
			MetafileType type;
			unsigned int size;
			unsigned int Version;
			unsigned int EmfPlusFlags;
			single DpiX;
			single DpiY;
			int x;
			int y;
			int width;
			int height;
			union  {
				METAHEADER WmfHeader;
				ENHMETAHEADER3 EmfHeader;
			};
			int EmfPlusHeaderSize;
			int LogicalDpiX;
			int LogicalDpiY;
		} GpMetafileHeader;
"

	self
		defineField: #type
			type: SDWORDField new
			offset: 0;
		defineField: #size
			type: DWORDField new
			offset: 4;
		defineField: #Version
			type: DWORDField new
			offset: 8;
		defineField: #EmfPlusFlags
			type: DWORDField new
			offset: 12;
		defineField: #DpiX
			type: FLOATField new
			offset: 16;
		defineField: #DpiY
			type: FLOATField new
			offset: 20;
		defineField: #x
			type: SDWORDField new
			offset: 24;
		defineField: #y
			type: SDWORDField new
			offset: 28;
		defineField: #width
			type: SDWORDField new
			offset: 32;
		defineField: #height
			type: SDWORDField new
			offset: 36;
		defineField: #WmfHeader
			type: (StructureField type: METAHEADER)
			offset: 40;
		defineField: #EmfHeader
			type: (StructureField type: ENHMETAHEADER3)
			offset: 40;
		defineField: #EmfPlusHeaderSize
			type: SDWORDField new
			offset: 128;
		defineField: #LogicalDpiX
			type: SDWORDField new
			offset: 132;
		defineField: #LogicalDpiY
			type: SDWORDField new
			offset: 136.
	self byteSize: 140! !
!GpMetafileHeader class categoriesFor: #defineFields!initializing!public! !

