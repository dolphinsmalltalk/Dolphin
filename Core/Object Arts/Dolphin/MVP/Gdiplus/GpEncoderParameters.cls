"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #GpEncoderParameters
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpEncoderParameters guid: (GUID fromString: '{7AA7C3A4-85D9-4298-AD05-11C85D76C885}')!
GpEncoderParameters comment: '<GpEncoderParameters> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpEncoderParameters'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7AA7C3A4-85D9-4298-AD05-11C85D76C885)]
struct tagGpEncoderParameters {
	unsigned int count;
	GpEncoderParameter Parameter[1];
} GpEncoderParameters;
'!
!GpEncoderParameters categoriesForClass!Unclassified! !
!GpEncoderParameters methodsFor!

byteSize
	"Same approach as BITMAPINFO>>byteSize."

	^super byteSize + ((self Count - 1) * GpEncoderParameter byteSize)!

Count
	"Answer the receiver's Count field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

Count: anObject
	"Set the receiver's Count field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

Parameter
	"Answer the receiver's Parameter field as a Smalltalk object."

	^StructureArray fromAddress: (bytes yourAddress + 4) length: self Count elementClass: GpEncoderParameter!

Parameter: anObject
	"Set the receiver's Parameter field to the value of anObject."

	| size |
	size := anObject byteSize min: (self Count * 28).
	anObject replaceBytesOf: bytes from: 5 to: 4 + size startingAt: 1! !
!GpEncoderParameters categoriesFor: #byteSize!accessing!public! !
!GpEncoderParameters categoriesFor: #Count!**compiled accessors**!public! !
!GpEncoderParameters categoriesFor: #Count:!**compiled accessors**!public! !
!GpEncoderParameters categoriesFor: #Parameter!**compiled accessors**!public! !
!GpEncoderParameters categoriesFor: #Parameter:!**compiled accessors**!public! !

!GpEncoderParameters class methodsFor!

defineFields
	"Define the fields of the GpEncoderParameters structure.
		GpEncoderParameters compileDefinition
	
		typedef [uuid(7AA7C3A4-85D9-4298-AD05-11C85D76C885)]
		struct tagGpEncoderParameters {
			[helpstring('Number of parameters in this structure')] unsigned int Count;
			[helpstring('Parameter values')] GpEncoderParameter Parameter[1];
		} GpEncoderParameters;
"

	self
		defineField: #Count
			type: DWORDField new
			offset: 0;
		defineField: #Parameter
			type: (ConformantStructureArrayField type: GpEncoderParameter length: #Count)
			offset: 4.
	"The byteSize includes space for one parameter, i.e. as in the above structure definition"
	self byteSize: 32!

length: anInteger 
	"Answer a new instance of the receiver with sufficient capacity to contain the specified
	number of parameters."

	^(self new: self byteSize + ((anInteger - 1) * GpEncoderParameter byteSize))
		Count: anInteger;
		yourself! !
!GpEncoderParameters class categoriesFor: #defineFields!initializing!public! !
!GpEncoderParameters class categoriesFor: #length:!public! !

