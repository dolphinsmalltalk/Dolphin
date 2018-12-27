"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpMetafileHeader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpMetafileHeader guid: (GUID fromString: '{83583420-dbfc-415f-ab1b-93e52a2206ef}')!
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
	"Answer the <Float> value of the receiver's 'DpiX' field."

	^bytes floatAtOffset: ##(self offsetOf: #DpiX)!

DpiX: aFloat
	"Set the receiver's 'DpiX' field to the value of the argument, aFloat"

	bytes floatAtOffset: ##(self offsetOf: #DpiX) put: aFloat!

DpiY
	"Answer the <Float> value of the receiver's 'DpiY' field."

	^bytes floatAtOffset: ##(self offsetOf: #DpiY)!

DpiY: aFloat
	"Set the receiver's 'DpiY' field to the value of the argument, aFloat"

	bytes floatAtOffset: ##(self offsetOf: #DpiY) put: aFloat!

EmfHeader
	"Answer the <ENHMETAHEADER3> value of the receiver's 'EmfHeader' field."

	^ENHMETAHEADER3 fromAddress: bytes yourAddress + ##(self offsetOf: #EmfHeader)!

EmfHeader: anENHMETAHEADER3
	"Set the receiver's 'EmfHeader' field to the value of the argument, anENHMETAHEADER3"

	anENHMETAHEADER3
		replaceBytesOf: bytes
		from: ##((self offsetOf: #EmfHeader) + 1)
		to: ##((self offsetOf: #EmfHeader) + ENHMETAHEADER3 basicByteSize)
		startingAt: 1!

EmfPlusFlags
	"Answer the <Integer> value of the receiver's 'EmfPlusFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #EmfPlusFlags)!

EmfPlusFlags: anInteger
	"Set the receiver's 'EmfPlusFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #EmfPlusFlags) put: anInteger!

EmfPlusHeaderSize
	"Answer the <Integer> value of the receiver's 'EmfPlusHeaderSize' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #EmfPlusHeaderSize)!

EmfPlusHeaderSize: anInteger
	"Set the receiver's 'EmfPlusHeaderSize' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #EmfPlusHeaderSize) put: anInteger!

height
	"Answer the <Integer> value of the receiver's 'height' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #height)!

height: anInteger
	"Set the receiver's 'height' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #height) put: anInteger!

LogicalDpiX
	"Answer the <Integer> value of the receiver's 'LogicalDpiX' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #LogicalDpiX)!

LogicalDpiX: anInteger
	"Set the receiver's 'LogicalDpiX' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #LogicalDpiX) put: anInteger!

LogicalDpiY
	"Answer the <Integer> value of the receiver's 'LogicalDpiY' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #LogicalDpiY)!

LogicalDpiY: anInteger
	"Set the receiver's 'LogicalDpiY' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #LogicalDpiY) put: anInteger!

size
	"Answer the <Integer> value of the receiver's 'size' field."

	^bytes dwordAtOffset: ##(self offsetOf: #size)!

size: anInteger
	"Set the receiver's 'size' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #size) put: anInteger!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes sdwordAtOffset: 0!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

Version
	"Answer the <Integer> value of the receiver's 'Version' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Version)!

Version: anInteger
	"Set the receiver's 'Version' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Version) put: anInteger!

width
	"Answer the <Integer> value of the receiver's 'width' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #width)!

width: anInteger
	"Set the receiver's 'width' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #width) put: anInteger!

WmfHeader
	"Answer the <METAHEADER> value of the receiver's 'WmfHeader' field."

	^METAHEADER fromAddress: bytes yourAddress + ##(self offsetOf: #WmfHeader)!

WmfHeader: aMETAHEADER
	"Set the receiver's 'WmfHeader' field to the value of the argument, aMETAHEADER"

	aMETAHEADER
		replaceBytesOf: bytes
		from: ##((self offsetOf: #WmfHeader) + 1)
		to: ##((self offsetOf: #WmfHeader) + METAHEADER basicByteSize)
		startingAt: 1!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #x)!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #x) put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #y)!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #y) put: anInteger! !
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
	self byteSize: 140!

getFieldNames
	^#(#type #size #Version #EmfPlusFlags #DpiX #DpiY #x #y #width #height #EmfHeader #WmfHeader #EmfPlusHeaderSize #LogicalDpiX #LogicalDpiY)! !
!GpMetafileHeader class categoriesFor: #defineFields!initializing!public! !
!GpMetafileHeader class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

