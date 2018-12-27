"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpEncoderParameter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpEncoderParameter guid: (GUID fromString: '{d4caa392-ba63-47ec-9ae5-093a1081a016}')!
GpEncoderParameter comment: '<GpEncoderParameter> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpEncoderParameter'' from type information in the ''GDI+ Library 1.0'' library.

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
!GpEncoderParameter categoriesForClass!Unclassified! !
!GpEncoderParameter methodsFor!

Guid
	"Answer the <GUID> value of the receiver's 'Guid' field."

	^GUID fromAddress: bytes yourAddress!

Guid: aGUID
	"Set the receiver's 'Guid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: 1
		to: ##(GUID basicByteSize)
		startingAt: 1!

NumberOfValues
	"Answer the <Integer> value of the receiver's 'NumberOfValues' field."

	^bytes dwordAtOffset: ##(self offsetOf: #NumberOfValues)!

NumberOfValues: anInteger
	"Set the receiver's 'NumberOfValues' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #NumberOfValues) put: anInteger!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Type)!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Type) put: anInteger!

Value
	"Answer the <ExternalAddress> value of the receiver's 'Value' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #Value)) asExternalAddress!

Value: anExternalAddress
	"Set the receiver's 'Value' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #Value) put: anExternalAddress! !
!GpEncoderParameter categoriesFor: #Guid!**compiled accessors**!public! !
!GpEncoderParameter categoriesFor: #Guid:!**compiled accessors**!public! !
!GpEncoderParameter categoriesFor: #NumberOfValues!**compiled accessors**!public! !
!GpEncoderParameter categoriesFor: #NumberOfValues:!**compiled accessors**!public! !
!GpEncoderParameter categoriesFor: #Type!**compiled accessors**!public! !
!GpEncoderParameter categoriesFor: #Type:!**compiled accessors**!public! !
!GpEncoderParameter categoriesFor: #Value!**compiled accessors**!public! !
!GpEncoderParameter categoriesFor: #Value:!**compiled accessors**!public! !

!GpEncoderParameter class methodsFor!

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
		defineField: #Guid type: (StructureField type: GUID) offset: 0;
		defineField: #NumberOfValues type: DWORDField new offset: 16;
		defineField: #Type type: DWORDField new offset: 20;
		defineField: #Value type: LPVOIDField new offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#Guid #NumberOfValues #Type #Value)! !
!GpEncoderParameter class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!GpEncoderParameter class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

