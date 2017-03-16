"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #ENHMETAHEADER3
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ENHMETAHEADER3 guid: (GUID fromString: '{1b5c3dcf-8ea0-47df-b752-442dd272a353}')!
ENHMETAHEADER3 comment: '<ENHMETAHEADER3> is an <ExternalStructure> class to wrap the struct ''Gdiplus.ENHMETAHEADER3'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1B5C3DCF-8EA0-47DF-B752-442DD272A353)]
struct tagENHMETAHEADER3 {
	unsigned long iType;
	unsigned long nSize;
	RECTL rclBounds;
	RECTL rclFrame;
	unsigned long dSignature;
	unsigned long nVersion;
	unsigned long nBytes;
	unsigned long nRecords;
	unsigned short nHandles;
	unsigned short sReserved;
	unsigned long nDescription;
	unsigned long offDescription;
	unsigned long nPalEntries;
	SIZEL szlDevice;
	SIZEL szlMillimeters;
} ENHMETAHEADER3;
'!
!ENHMETAHEADER3 categoriesForClass!Unclassified! !
!ENHMETAHEADER3 methodsFor!

dSignature
	"Answer the receiver's dSignature field as a Smalltalk object."

	^(bytes dwordAtOffset: 40)!

dSignature: anObject
	"Set the receiver's dSignature field to the value of anObject."

	bytes dwordAtOffset: 40 put: anObject!

iType
	"Answer the receiver's iType field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

iType: anObject
	"Set the receiver's iType field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

nBytes
	"Answer the receiver's nBytes field as a Smalltalk object."

	^(bytes dwordAtOffset: 48)!

nBytes: anObject
	"Set the receiver's nBytes field to the value of anObject."

	bytes dwordAtOffset: 48 put: anObject!

nDescription
	"Answer the receiver's nDescription field as a Smalltalk object."

	^(bytes dwordAtOffset: 60)!

nDescription: anObject
	"Set the receiver's nDescription field to the value of anObject."

	bytes dwordAtOffset: 60 put: anObject!

nHandles
	"Answer the receiver's nHandles field as a Smalltalk object."

	^(bytes wordAtOffset: 56)!

nHandles: anObject
	"Set the receiver's nHandles field to the value of anObject."

	bytes wordAtOffset: 56 put: anObject!

nPalEntries
	"Answer the receiver's nPalEntries field as a Smalltalk object."

	^(bytes dwordAtOffset: 68)!

nPalEntries: anObject
	"Set the receiver's nPalEntries field to the value of anObject."

	bytes dwordAtOffset: 68 put: anObject!

nRecords
	"Answer the receiver's nRecords field as a Smalltalk object."

	^(bytes dwordAtOffset: 52)!

nRecords: anObject
	"Set the receiver's nRecords field to the value of anObject."

	bytes dwordAtOffset: 52 put: anObject!

nSize
	"Answer the receiver's nSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

nSize: anObject
	"Set the receiver's nSize field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

nVersion
	"Answer the receiver's nVersion field as a Smalltalk object."

	^(bytes dwordAtOffset: 44)!

nVersion: anObject
	"Set the receiver's nVersion field to the value of anObject."

	bytes dwordAtOffset: 44 put: anObject!

offDescription
	"Answer the receiver's offDescription field as a Smalltalk object."

	^(bytes dwordAtOffset: 64)!

offDescription: anObject
	"Set the receiver's offDescription field to the value of anObject."

	bytes dwordAtOffset: 64 put: anObject!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: (bytes yourAddress + 8)!

rclBounds: anObject
	"Set the receiver's rclBounds field to the value of anObject."

	anObject replaceBytesOf: bytes from: 9 to: 24 startingAt: 1!

rclFrame
	"Answer the receiver's rclFrame field as a Smalltalk object."

	^RECT fromAddress: (bytes yourAddress + 24)!

rclFrame: anObject
	"Set the receiver's rclFrame field to the value of anObject."

	anObject replaceBytesOf: bytes from: 25 to: 40 startingAt: 1!

sReserved
	"Answer the receiver's sReserved field as a Smalltalk object."

	^(bytes wordAtOffset: 58)!

sReserved: anObject
	"Set the receiver's sReserved field to the value of anObject."

	bytes wordAtOffset: 58 put: anObject!

szlDevice
	"Answer the receiver's szlDevice field as a Smalltalk object."

	^SIZE fromAddress: (bytes yourAddress + 72)!

szlDevice: anObject
	"Set the receiver's szlDevice field to the value of anObject."

	anObject replaceBytesOf: bytes from: 73 to: 80 startingAt: 1!

szlMillimeters
	"Answer the receiver's szlMillimeters field as a Smalltalk object."

	^SIZE fromAddress: (bytes yourAddress + 80)!

szlMillimeters: anObject
	"Set the receiver's szlMillimeters field to the value of anObject."

	anObject replaceBytesOf: bytes from: 81 to: 88 startingAt: 1! !
!ENHMETAHEADER3 categoriesFor: #dSignature!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #dSignature:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #iType!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #iType:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nBytes!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nBytes:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nDescription!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nDescription:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nHandles!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nHandles:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nPalEntries!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nPalEntries:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nRecords!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nRecords:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nSize!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nSize:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nVersion!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #nVersion:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #offDescription!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #offDescription:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #rclBounds!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #rclBounds:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #rclFrame!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #rclFrame:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #sReserved!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #sReserved:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #szlDevice!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #szlDevice:!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #szlMillimeters!**compiled accessors**!public! !
!ENHMETAHEADER3 categoriesFor: #szlMillimeters:!**compiled accessors**!public! !

!ENHMETAHEADER3 class methodsFor!

defineFields
	"Define the fields of the ENHMETAHEADER3 structure.
		ENHMETAHEADER3 compileDefinition
	
		typedef [uuid(1B5C3DCF-8EA0-47DF-B752-442DD272A353)]
		struct tagENHMETAHEADER3 {
			unsigned long iType;
			unsigned long nSize;
			RECTL rclBounds;
			RECTL rclFrame;
			unsigned long dSignature;
			unsigned long nVersion;
			unsigned long nBytes;
			unsigned long nRecords;
			unsigned short nHandles;
			unsigned short sReserved;
			unsigned long nDescription;
			unsigned long offDescription;
			unsigned long nPalEntries;
			SIZEL szlDevice;
			SIZEL szlMillimeters;
		} ENHMETAHEADER3;
"

	self
		defineField: #iType type: DWORDField new offset: 0;
		defineField: #nSize type: DWORDField new offset: 4;
		defineField: #rclBounds type: (StructureField type: RECT) offset: 8;
		defineField: #rclFrame type: (StructureField type: RECT) offset: 24;
		defineField: #dSignature type: DWORDField new offset: 40;
		defineField: #nVersion type: DWORDField new offset: 44;
		defineField: #nBytes type: DWORDField new offset: 48;
		defineField: #nRecords type: DWORDField new offset: 52;
		defineField: #nHandles type: WORDField new offset: 56;
		defineField: #sReserved type: WORDField new offset: 58;
		defineField: #nDescription type: DWORDField new offset: 60;
		defineField: #offDescription type: DWORDField new offset: 64;
		defineField: #nPalEntries type: DWORDField new offset: 68;
		defineField: #szlDevice type: (StructureField type: SIZE) offset: 72;
		defineField: #szlMillimeters type: (StructureField type: SIZE) offset: 80.
	self byteSize: 88! !
!ENHMETAHEADER3 class categoriesFor: #defineFields!**auto generated**!initializing!public! !

