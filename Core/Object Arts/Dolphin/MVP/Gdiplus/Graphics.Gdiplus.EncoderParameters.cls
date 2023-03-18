"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure
	subclass: #'Graphics.Gdiplus.EncoderParameters'
	instanceVariableNames: 'valueBuffer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EncoderParameters_Size' -> 16r20.
			'_OffsetOf_Count' -> 16r0.
			'_OffsetOf_Parameter' -> 16r4
		}!
Graphics.Gdiplus.EncoderParameters guid: (Core.GUID fromString: '{7aa7c3a4-85d9-4298-ad05-11c85d76c885}')!
Graphics.Gdiplus.EncoderParameters comment: '<GpEncoderParameters> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpEncoderParameters'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7AA7C3A4-85D9-4298-AD05-11C85D76C885)]
struct tagGpEncoderParameters {
	unsigned int count;
	GpEncoderParameter Parameter[1];
} GpEncoderParameters;
'!
!Graphics.Gdiplus.EncoderParameters methodsFor!

byteSize
	"Same approach as BITMAPINFO>>byteSize."

	^super byteSize + ((self Count - 1) * EncoderParameter._EncoderParameter_Size)!

Count
	"Answer the <Integer> value of the receiver's 'Count' field."

	^bytes uint32AtOffset: _OffsetOf_Count!

Count: anInteger
	"Set the receiver's 'Count' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Count put: anInteger!

Parameter
	"Answer the <StructureArray> value of the receiver's 'Parameter' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_Parameter
		length: self Count
		elementClass: EncoderParameter!

Parameter: aStructureArrayOfGpEncoderParameter
	"Set the receiver's 'Parameter' field to the value of the argument, aStructureArrayOfGpEncoderParameter"

	| size |
	size := aStructureArrayOfGpEncoderParameter byteSize.
	aStructureArrayOfGpEncoderParameter
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Parameter + 1)
		to: _OffsetOf_Parameter + size
		startingAt: 1.
	self Count: aStructureArrayOfGpEncoderParameter size!

valueBuffer: aByteArray
	valueBuffer := aByteArray! !
!Graphics.Gdiplus.EncoderParameters categoriesForMethods!
byteSize!accessing!public! !
Count!**compiled accessors**!public! !
Count:!**compiled accessors**!public! !
Parameter!**compiled accessors**!public! !
Parameter:!**compiled accessors**!public! !
valueBuffer:!accessing!public! !
!

!Graphics.Gdiplus.EncoderParameters class methodsFor!

byteSize
	^_EncoderParameters_Size!

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
			type: UInt32Field new
			offset: 0;
		defineField: #Parameter
			type: (StructureArrayField type: EncoderParameter
					arrayLength: (ConformantArrayFieldLength lengthField: #Count))
			offset: 4.
	"The byteSize includes space for one parameter, i.e. as in the above structure definition"
	self byteSize: 32!

getFieldNames
	^#(#Count #Parameter)!

length: anInteger
	"Answer a new instance of the receiver with sufficient capacity to contain the specified
	number of parameters."

	^(self new: _EncoderParameters_Size + ((anInteger - 1) * EncoderParameter._EncoderParameter_Size))
		Count: anInteger;
		yourself! !
!Graphics.Gdiplus.EncoderParameters class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
length:!instance creation!public! !
!

