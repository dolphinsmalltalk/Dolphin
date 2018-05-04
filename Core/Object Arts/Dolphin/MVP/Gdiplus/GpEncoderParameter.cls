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
	"Answer the receiver's Guid field as a Smalltalk object."

	^GUID fromAddress: (bytes yourAddress)!

Guid: anObject
	"Set the receiver's Guid field to the value of anObject."

	anObject replaceBytesOf: bytes from: 1 to: 16 startingAt: 1!

NumberOfValues
	"Answer the receiver's NumberOfValues field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

NumberOfValues: anObject
	"Set the receiver's NumberOfValues field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

Type
	"Answer the receiver's Type field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

Type: anObject
	"Set the receiver's Type field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject!

Value
	"Answer the receiver's Value field as a Smalltalk object."

	^(bytes dwordAtOffset: 24) asExternalAddress!

Value: anObject
	"Set the receiver's Value field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject! !
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
	self byteSize: 28! !
!GpEncoderParameter class categoriesFor: #defineFields!**auto generated**!initializing!public! !

