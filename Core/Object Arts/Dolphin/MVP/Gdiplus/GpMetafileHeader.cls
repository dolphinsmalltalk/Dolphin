"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GpMetafileHeader
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_DpiX _OffsetOf_DpiY _OffsetOf_EmfHeader _OffsetOf_EmfPlusFlags _OffsetOf_EmfPlusHeaderSize _OffsetOf_height _OffsetOf_LogicalDpiX _OffsetOf_LogicalDpiY _OffsetOf_size _OffsetOf_type _OffsetOf_Version _OffsetOf_width _OffsetOf_WmfHeader _OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpMetafileHeader guid: (GUID fromString: '{83583420-dbfc-415f-ab1b-93e52a2206ef}')!

GpMetafileHeader addClassConstant: '_OffsetOf_DpiX' value: 16r10!
GpMetafileHeader addClassConstant: '_OffsetOf_DpiY' value: 16r14!
GpMetafileHeader addClassConstant: '_OffsetOf_EmfHeader' value: 16r28!
GpMetafileHeader addClassConstant: '_OffsetOf_EmfPlusFlags' value: 16rC!
GpMetafileHeader addClassConstant: '_OffsetOf_EmfPlusHeaderSize' value: 16r80!
GpMetafileHeader addClassConstant: '_OffsetOf_height' value: 16r24!
GpMetafileHeader addClassConstant: '_OffsetOf_LogicalDpiX' value: 16r84!
GpMetafileHeader addClassConstant: '_OffsetOf_LogicalDpiY' value: 16r88!
GpMetafileHeader addClassConstant: '_OffsetOf_size' value: 16r4!
GpMetafileHeader addClassConstant: '_OffsetOf_type' value: 16r0!
GpMetafileHeader addClassConstant: '_OffsetOf_Version' value: 16r8!
GpMetafileHeader addClassConstant: '_OffsetOf_width' value: 16r20!
GpMetafileHeader addClassConstant: '_OffsetOf_WmfHeader' value: 16r28!
GpMetafileHeader addClassConstant: '_OffsetOf_x' value: 16r18!
GpMetafileHeader addClassConstant: '_OffsetOf_y' value: 16r1C!

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

	^bytes floatAtOffset: _OffsetOf_DpiX!

DpiX: aFloat
	"Set the receiver's 'DpiX' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_DpiX put: aFloat!

DpiY
	"Answer the <Float> value of the receiver's 'DpiY' field."

	^bytes floatAtOffset: _OffsetOf_DpiY!

DpiY: aFloat
	"Set the receiver's 'DpiY' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_DpiY put: aFloat!

EmfHeader
	"Answer the <ENHMETAHEADER3> value of the receiver's 'EmfHeader' field."

	^ENHMETAHEADER3 fromAddress: bytes yourAddress + _OffsetOf_EmfHeader!

EmfHeader: anENHMETAHEADER3
	"Set the receiver's 'EmfHeader' field to the value of the argument, anENHMETAHEADER3"

	anENHMETAHEADER3
		replaceBytesOf: bytes
		from: ##(_OffsetOf_EmfHeader + 1)
		to: ##(_OffsetOf_EmfHeader + ENHMETAHEADER3 basicByteSize)
		startingAt: 1!

EmfPlusFlags
	"Answer the <Integer> value of the receiver's 'EmfPlusFlags' field."

	^bytes dwordAtOffset: _OffsetOf_EmfPlusFlags!

EmfPlusFlags: anInteger
	"Set the receiver's 'EmfPlusFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_EmfPlusFlags put: anInteger!

EmfPlusHeaderSize
	"Answer the <Integer> value of the receiver's 'EmfPlusHeaderSize' field."

	^bytes sdwordAtOffset: _OffsetOf_EmfPlusHeaderSize!

EmfPlusHeaderSize: anInteger
	"Set the receiver's 'EmfPlusHeaderSize' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_EmfPlusHeaderSize put: anInteger!

height
	"Answer the <Integer> value of the receiver's 'height' field."

	^bytes sdwordAtOffset: _OffsetOf_height!

height: anInteger
	"Set the receiver's 'height' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_height put: anInteger!

LogicalDpiX
	"Answer the <Integer> value of the receiver's 'LogicalDpiX' field."

	^bytes sdwordAtOffset: _OffsetOf_LogicalDpiX!

LogicalDpiX: anInteger
	"Set the receiver's 'LogicalDpiX' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_LogicalDpiX put: anInteger!

LogicalDpiY
	"Answer the <Integer> value of the receiver's 'LogicalDpiY' field."

	^bytes sdwordAtOffset: _OffsetOf_LogicalDpiY!

LogicalDpiY: anInteger
	"Set the receiver's 'LogicalDpiY' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_LogicalDpiY put: anInteger!

size
	"Answer the <Integer> value of the receiver's 'size' field."

	^bytes dwordAtOffset: _OffsetOf_size!

size: anInteger
	"Set the receiver's 'size' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_size put: anInteger!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes sdwordAtOffset: _OffsetOf_type!

type: anInteger
	"Set the receiver's 'type' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_type put: anInteger!

Version
	"Answer the <Integer> value of the receiver's 'Version' field."

	^bytes dwordAtOffset: _OffsetOf_Version!

Version: anInteger
	"Set the receiver's 'Version' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Version put: anInteger!

width
	"Answer the <Integer> value of the receiver's 'width' field."

	^bytes sdwordAtOffset: _OffsetOf_width!

width: anInteger
	"Set the receiver's 'width' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_width put: anInteger!

WmfHeader
	"Answer the <METAHEADER> value of the receiver's 'WmfHeader' field."

	^METAHEADER fromAddress: bytes yourAddress + _OffsetOf_WmfHeader!

WmfHeader: aMETAHEADER
	"Set the receiver's 'WmfHeader' field to the value of the argument, aMETAHEADER"

	aMETAHEADER
		replaceBytesOf: bytes
		from: ##(_OffsetOf_WmfHeader + 1)
		to: ##(_OffsetOf_WmfHeader + METAHEADER basicByteSize)
		startingAt: 1!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes sdwordAtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_x put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes sdwordAtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_y put: anInteger! !

!GpMetafileHeader categoriesForMethods!
DpiX!**compiled accessors**!public! !
DpiX:!**compiled accessors**!public! !
DpiY!**compiled accessors**!public! !
DpiY:!**compiled accessors**!public! !
EmfHeader!**compiled accessors**!public! !
EmfHeader:!**compiled accessors**!public! !
EmfPlusFlags!**compiled accessors**!public! !
EmfPlusFlags:!**compiled accessors**!public! !
EmfPlusHeaderSize!**compiled accessors**!public! !
EmfPlusHeaderSize:!**compiled accessors**!public! !
height!**compiled accessors**!public! !
height:!**compiled accessors**!public! !
LogicalDpiX!**compiled accessors**!public! !
LogicalDpiX:!**compiled accessors**!public! !
LogicalDpiY!**compiled accessors**!public! !
LogicalDpiY:!**compiled accessors**!public! !
size!**compiled accessors**!public! !
size:!**compiled accessors**!public! !
type!**compiled accessors**!public! !
type:!**compiled accessors**!public! !
Version!**compiled accessors**!public! !
Version:!**compiled accessors**!public! !
width!**compiled accessors**!public! !
width:!**compiled accessors**!public! !
WmfHeader!**compiled accessors**!public! !
WmfHeader:!**compiled accessors**!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

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

!GpMetafileHeader class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

