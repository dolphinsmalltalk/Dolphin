"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure subclass: #'Graphics.Gdiplus.EncoderParameter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EncoderParameter_Size' -> 16r1C.
		'_OffsetOf_Guid' -> 16r0.
		'_OffsetOf_NumberOfValues' -> 16r10.
		'_OffsetOf_Type' -> 16r14.
		'_OffsetOf_Value' -> 16r18
	}!
Graphics.Gdiplus.EncoderParameter guid: (Core.GUID fromString: '{d4caa392-ba63-47ec-9ae5-093a1081a016}')!
Graphics.Gdiplus.EncoderParameter comment: '<GpEncoderParameter> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpEncoderParameter'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D4CAA392-BA63-47EC-9AE5-093A1081A016)]
struct tagGpEncoderParameter {
	GUID Guid;
	unsigned long NumberOfValues;
	unsigned long type;
	void* Value;
} GpEncoderParameter;
'!
!Graphics.Gdiplus.EncoderParameter methodsFor!

Guid
	"Answer the <GUID> value of the receiver's 'Guid' field."

	^GUID fromAddress: bytes yourAddress!

Guid: aGUID
	"Set the receiver's 'Guid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Guid + 1)
		to: ##(_OffsetOf_Guid + GUID._GUID_Size)
		startingAt: 1!

NumberOfValues
	"Answer the <Integer> value of the receiver's 'NumberOfValues' field."

	^bytes uint32AtOffset: _OffsetOf_NumberOfValues!

NumberOfValues: anInteger
	"Set the receiver's 'NumberOfValues' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_NumberOfValues put: anInteger!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes uint32AtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Type put: anInteger!

Value
	"Answer the <Address> value of the receiver's 'Value' field."

	^(bytes uintPtrAtOffset: _OffsetOf_Value) asExternalAddress!

Value: anAddress
	"Set the receiver's 'Value' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_Value put: anAddress! !
!Graphics.Gdiplus.EncoderParameter categoriesForMethods!
Guid!**compiled accessors**!public! !
Guid:!**compiled accessors**!public! !
NumberOfValues!**compiled accessors**!public! !
NumberOfValues:!**compiled accessors**!public! !
Type!**compiled accessors**!public! !
Type:!**compiled accessors**!public! !
Value!**compiled accessors**!public! !
Value:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.EncoderParameter class methodsFor!

byteSize
	^_EncoderParameter_Size!

defineFields
	"Define the fields of the GpEncoderParameter structure.
		GpEncoderParameter compileDefinition
	
		typedef [uuid(D4CAA392-BA63-47EC-9AE5-093A1081A016), helpstring('Encoder Parameter structure')]
		struct tagGpEncoderParameter {
			[helpstring('GUID of the parameter')] GUID Guid;
			[helpstring('Number of the parameter values')] unsigned long NumberOfValues;
			[helpstring('Value type, like ValueTypeLONG  etc.')] unsigned long Type;
			[helpstring('A pointer to the parameter values')] void* Value;
		} GpEncoderParameter;
"

	self
		defineField: #Guid
			type: (StructureField type: GUID)
			offset: 0;
		defineField: #NumberOfValues
			type: UInt32Field new
			offset: 16;
		defineField: #Type
			type: UInt32Field new
			offset: 20;
		defineField: #Value
			type: LPVOIDField new
			offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#Guid #NumberOfValues #Type #Value)! !
!Graphics.Gdiplus.EncoderParameter class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

