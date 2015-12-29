"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #IP_UNIDIRECTIONAL_ADAPTER_ADDRESS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IP_UNIDIRECTIONAL_ADAPTER_ADDRESS guid: (GUID fromString: '{7F8B1EC9-1399-47A6-94BE-768366DAC0DC}')!
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
	"Answer the receiver's Address field as a Smalltalk object."

	^DWORDArray fromAddress: (bytes yourAddress + 4) length: 1!

Address: anObject
	"Set the receiver's Address field to the value of anObject."

	| size |
	size := anObject byteSize min: (1 * 4).
	anObject replaceBytesOf: bytes from: 5 to: 4 + size startingAt: 1!

NumAdapters
	"Answer the receiver's NumAdapters field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

NumAdapters: anObject
	"Set the receiver's NumAdapters field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesFor: #Address!**compiled accessors**!public! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesFor: #Address:!**compiled accessors**!public! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesFor: #NumAdapters!**compiled accessors**!public! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS categoriesFor: #NumAdapters:!**compiled accessors**!public! !

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
	self byteSize: 8! !
!IP_UNIDIRECTIONAL_ADAPTER_ADDRESS class categoriesFor: #defineFields!initializing!public! !

