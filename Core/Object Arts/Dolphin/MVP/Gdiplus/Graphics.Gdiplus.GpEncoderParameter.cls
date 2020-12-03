"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'Graphics.Gdiplus.GpEncoderParameter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Guid' -> 16r0.
		'_OffsetOf_NumberOfValues' -> 16r10.
		'_OffsetOf_Type' -> 16r14.
		'_OffsetOf_Value' -> 16r18
	}!
Graphics.Gdiplus.GpEncoderParameter guid: (Core.GUID fromString: '{d4caa392-ba63-47ec-9ae5-093a1081a016}')!
Graphics.Gdiplus.GpEncoderParameter comment: '<GpEncoderParameter> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpEncoderParameter'' from type information in the ''GDI+ Library 1.0'' library.

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
!Graphics.Gdiplus.GpEncoderParameter categoriesForClass!Unclassified! !
!Graphics.Gdiplus.GpEncoderParameter methodsFor!

Guid
	"Answer the <GUID> value of the receiver's 'Guid' field."

	^GUID fromAddress: bytes yourAddress!

Guid: aGUID
	"Set the receiver's 'Guid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Guid + 1)
		to: ##(_OffsetOf_Guid + GUID basicByteSize)
		startingAt: 1!

NumberOfValues
	"Answer the <Integer> value of the receiver's 'NumberOfValues' field."

	^bytes dwordAtOffset: _OffsetOf_NumberOfValues!

NumberOfValues: anInteger
	"Set the receiver's 'NumberOfValues' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_NumberOfValues put: anInteger!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes dwordAtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Type put: anInteger!

Value
	"Answer the <ExternalAddress> value of the receiver's 'Value' field."

	^(bytes uintPtrAtOffset: _OffsetOf_Value) asExternalAddress!

Value: anExternalAddress
	"Set the receiver's 'Value' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_Value put: anExternalAddress! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #Guid!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #Guid:!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #NumberOfValues!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #NumberOfValues:!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #Type!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #Type:!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #Value!**compiled accessors**!public! !
!Graphics.Gdiplus.GpEncoderParameter categoriesFor: #Value:!**compiled accessors**!public! !

!Graphics.Gdiplus.GpEncoderParameter class methodsFor!

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
			type: DWORDField new
			offset: 16;
		defineField: #Type
			type: DWORDField new
			offset: 20;
		defineField: #Value
			type: LPVOIDField new
			offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#Guid #NumberOfValues #Type #Value)! !
!Graphics.Gdiplus.GpEncoderParameter class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!Graphics.Gdiplus.GpEncoderParameter class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

