"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRGRADIENTFILL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRGRADIENTFILL guid: (GUID fromString: '{1302823f-242e-4301-b5eb-ee7a20a4b787}')!
EMRGRADIENTFILL comment: '<EMRGRADIENTFILL> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGRADIENTFILL'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1302823F-242E-4301-B5EB-EE7A20A4B787)]
struct tagEMRGRADIENTFILL {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	DWORD nVer;
	DWORD nTri;
	ULONG ulMode;
	TRIVERTEX Ver[1];
} EMRGRADIENTFILL;
'!
!EMRGRADIENTFILL categoriesForClass!Win32-Structs! !
!EMRGRADIENTFILL methodsFor!

nTri
	"Answer the receiver's nTri field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nTri)!

nTri: anObject 
	"Set the receiver's nTri field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nTri) put: anObject!

nVer
	"Answer the receiver's nVer field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nVer)!

nVer: anObject 
	"Set the receiver's nVer field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nVer) put: anObject!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: anObject 
	"Set the receiver's rclBounds field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1!

ulMode
	"Answer the receiver's ulMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ulMode)!

ulMode: anObject 
	"Set the receiver's ulMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ulMode) put: anObject!

Ver
	"Answer the receiver's Ver field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #Ver)
		length: self nVer
		elementClass: TRIVERTEX!

Ver: anObject 
	"Set the receiver's Ver field to the value of anObject."

	| size |
	size := anObject byteSize min: self nVer * ##(TRIVERTEX basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Ver) + 1)
		to: ##(self offsetOf: #Ver) + size
		startingAt: 1! !
!EMRGRADIENTFILL categoriesFor: #nTri!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #nTri:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #nVer!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #nVer:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #ulMode!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #ulMode:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #Ver!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #Ver:!**compiled accessors**!public! !

!EMRGRADIENTFILL class methodsFor!

defineFields
	"Define the fields of the EMRGRADIENTFILL structure.

	EMRGRADIENTFILL  compileDefinition

		typedef [uuid(1302823F-242E-4301-B5EB-EE7A20A4B787)]
		struct tagEMRGRADIENTFILL {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			DWORD nVer;
			DWORD nTri;
			ULONG ulMode;
			[size_is(nVer)]TRIVERTEX Ver[];
		} EMRGRADIENTFILL;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #nVer
			type: DWORDField new
			offset: 24;
		defineField: #nTri
			type: DWORDField new
			offset: 28;
		defineField: #ulMode
			type: DWORDField new
			offset: 32;
		defineField: #Ver
			type: (ConformantStructureArrayField  type: TRIVERTEX length: #nVer)
			offset: 36!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_GRADIENTFILL! !
!EMRGRADIENTFILL class categoriesFor: #defineFields!initializing!public! !
!EMRGRADIENTFILL class categoriesFor: #iTypes!constants!public! !

