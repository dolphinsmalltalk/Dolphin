"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYLINE16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPOLYLINE16 guid: (GUID fromString: '{89918c5e-59a5-4f2a-a8a0-61e552795224}')!
EMRPOLYLINE16 comment: '<EMRPOLYLINE16> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYLINE16'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(89918C5E-59A5-4F2A-A8A0-61E552795224)]
struct tagEMRPOLYLINE16 {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	DWORD cpts;
	POINTS* apts;
} EMRPOLYLINE16;
'!
!EMRPOLYLINE16 categoriesForClass!Win32-Structs! !
!EMRPOLYLINE16 methodsFor!

apts
	"Answer the <StructureArray> value of the receiver's 'apts' field."

	^StructureArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #apts)
		length: self cpts
		elementClass: POINTS!

apts: aStructureArrayOfPOINTS
	"Set the receiver's 'apts' field to the value of the argument, aStructureArrayOfPOINTS"

	| size |
	size := aStructureArrayOfPOINTS byteSize.
	aStructureArrayOfPOINTS
		replaceBytesOf: bytes
		from: ##((self offsetOf: #apts) + 1)
		to: ##(self offsetOf: #apts) + size
		startingAt: 1.
	self cpts: aStructureArrayOfPOINTS size!

cpts
	"Answer the <Integer> value of the receiver's 'cpts' field."

	^bytes dwordAtOffset: ##(self offsetOf: #cpts)!

cpts: anInteger
	"Set the receiver's 'cpts' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #cpts) put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1! !
!EMRPOLYLINE16 categoriesFor: #apts!**compiled accessors**!public! !
!EMRPOLYLINE16 categoriesFor: #apts:!**compiled accessors**!public! !
!EMRPOLYLINE16 categoriesFor: #cpts!**compiled accessors**!public! !
!EMRPOLYLINE16 categoriesFor: #cpts:!**compiled accessors**!public! !
!EMRPOLYLINE16 categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPOLYLINE16 categoriesFor: #rclBounds:!**compiled accessors**!public! !

!EMRPOLYLINE16 class methodsFor!

defineFields
	"Define the fields of the EMRPOLYLINE16 structure.

	EMRPOLYLINE16  compileDefinition

		typedef [uuid(89918C5E-59A5-4F2A-A8A0-61E552795224)]
		struct tagEMRPOLYLINE16 {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			DWORD cpts;
			[size_is(cpts)]POINTS apts[];
		} EMRPOLYLINE16;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #cpts
			type: DWORDField new
			offset: 24;
		defineField: #apts
			type: (StructureArrayField type: POINTS lengthField: #cpts)
			offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#iType #nSize #rclBounds #cpts #apts)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array 
		with: EMR_POLYLINE16
		with: EMR_POLYBEZIER16
		with: EMR_POLYGON16
		with: EMR_POLYBEZIERTO16
		with: EMR_POLYLINETO16! !
!EMRPOLYLINE16 class categoriesFor: #defineFields!initializing!public! !
!EMRPOLYLINE16 class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRPOLYLINE16 class categoriesFor: #iTypes!constants!public! !

