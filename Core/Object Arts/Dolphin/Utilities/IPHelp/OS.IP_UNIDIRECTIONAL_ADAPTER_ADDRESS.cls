"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #IP_UNIDIRECTIONAL_ADAPTER_ADDRESS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Address' -> 16r4.
		'_OffsetOf_NumAdapters' -> 16r0
	}!
IP_UNIDIRECTIONAL_ADAPTER_ADDRESS guid: (GUID fromString: '{7f8b1ec9-1399-47a6-94be-768366dac0dc}')!
IP_UNIDIRECTIONAL_ADAPTER_ADDRESS comment: '<IP_UNIDIRECTIONAL_ADAPTER_ADDRESS> is an <ExternalStructure> class to wrap the struct ''Win32.IP_UNIDIRECTIONAL_ADAPTER_ADDRESS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_UNIDIRECTIONAL_ADAPTER_ADDRESS {
	unsigned long NumAdapters;
	unsigned long Address[1];
} IP_UNIDIRECTIONAL_ADAPTER_ADDRESS;
'!
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesForClass!Win32-Structs! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS methodsFor!

Address
	"Answer the <DWORDArray> value of the receiver's 'Address' field."

	^DWORDArray fromAddress: bytes yourAddress + _OffsetOf_Address length: 1!

Address: aDWORDArray
	"Set the receiver's 'Address' field to the value of the argument, aDWORDArray"

	| size |
	size := aDWORDArray byteSize min: ##(1 * DWORDArray elementSize).
	aDWORDArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Address + 1)
		to: _OffsetOf_Address + size
		startingAt: 1!

NumAdapters
	"Answer the <Integer> value of the receiver's 'NumAdapters' field."

	^bytes dwordAtOffset: _OffsetOf_NumAdapters! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesFor: #Address!**compiled accessors**!public! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesFor: #Address:!**compiled accessors**!public! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesFor: #NumAdapters!**compiled accessors**!public! !

!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS class methodsFor!

defineFields
	"Define the fields of the IP_UNIDIRECTIONAL_ADAPTER_ADDRESS structure.
		IP_UNIDIRECTIONAL_ADAPTER_ADDRESS compileDefinition
	
		typedef 
		struct tagIP_UNIDIRECTIONAL_ADAPTER_ADDRESS {
			unsigned long NumAdapters;
			unsigned long Address[1];
		} IP_UNIDIRECTIONAL_ADAPTER_ADDRESS;
"

	self
		defineField: #NumAdapters type: DWORDField readOnly offset: 0;
		defineField: #Address type: (ArrayField type: DWORDArray length: 1) offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#NumAdapters #Address)! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS class categoriesFor: #defineFields!initializing!public! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

