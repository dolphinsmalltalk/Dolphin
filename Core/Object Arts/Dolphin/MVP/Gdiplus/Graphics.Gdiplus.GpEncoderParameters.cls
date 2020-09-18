"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'Graphics.Gdiplus.GpEncoderParameters'
	instanceVariableNames: 'valueBuffer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Count' -> 16r0.
		'_OffsetOf_Parameter' -> 16r4
	}!
Graphics.Gdiplus.GpEncoderParameters guid: (Core.GUID fromString: '{7aa7c3a4-85d9-4298-ad05-11c85d76c885}')!
Graphics.Gdiplus.GpEncoderParameters comment: '<GpEncoderParameters> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpEncoderParameters'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7AA7C3A4-85D9-4298-AD05-11C85D76C885)]
struct tagGpEncoderParameters {
	unsigned int count;
	GpEncoderParameter Parameter[1];
} GpEncoderParameters;
'!
!Graphics.Gdiplus.GpEncoderParameters categoriesForClass!Unclassified! !
!Graphics.Gdiplus.GpEncoderParameters methodsFor!

byteSize
	"Same approach as BITMAPINFO>>byteSize."

	^super byteSize + ((self Count - 1) * GpEncoderParameter byteSize)!

Count
	"Answer the <Integer> value of the receiver's 'Count' field."

	^bytes dwordAtOffset: _OffsetOf_Count!

Count: anInteger
	"Set the receiver's 'Count' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Count put: anInteger!

Parameter
	"Answer the <StructureArray> value of the receiver's 'Parameter' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_Parameter
		length: self Count
		elementClass: GpEncoderParameter!

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
!Graphics.Gdiplus.GpEncoderParameters categoriesFor: #byteSize!accessing!public! !
!Graphics.Gdiplus.GpEncoderParameters categoriesFor: #Count!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameters categoriesFor: #Count:!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameters categoriesFor: #Parameter!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameters categoriesFor: #Parameter:!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameters categoriesFor: #valueBuffer:!public! !

!Graphics.Gdiplus.GpEncoderParameters class methodsFor!

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
			type: (StructureArrayField type: GpEncoderParameter
					arrayLength: (ConformantArrayFieldLength lengthField: #Count))
			offset: 4.
	"The byteSize includes space for one parameter, i.e. as in the above structure definition"
	self byteSize: 32!

getFieldNames
	^#(#Count #Parameter)!

length: anInteger
	"Answer a new instance of the receiver with sufficient capacity to contain the specified
	number of parameters."

	^(self new: self byteSize + ((anInteger - 1) * GpEncoderParameter byteSize))
		Count: anInteger;
		yourself! !
!Graphics.Gdiplus.GpEncoderParameters class categoriesFor: #defineFields!public!template definition! !
!Graphics.Gdiplus.GpEncoderParameters class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!Graphics.Gdiplus.GpEncoderParameters class categoriesFor: #length:!public! !

