"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #IP_ADDR_STRING
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Context' -> 16r24.
		'_OffsetOf_IpAddress' -> 16r4.
		'_OffsetOf_IpMask' -> 16r14.
		'_OffsetOf_Next' -> 16r0
	}!
IP_ADDR_STRING guid: (GUID fromString: '{ba94c426-f5a5-47e8-b2c5-43d6c2456846}')!
IP_ADDR_STRING comment: '<IP_ADDR_STRING> is an <ExternalStructure> class to wrap the struct ''Win32.IP_ADDR_STRING'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_ADDR_STRING {
	IP_ADDR_STRING* Next;
	IP_ADDRESS_STRING IpAddress;
	IP_MASK_STRING IpMask;
	unsigned long Context;
} IP_ADDR_STRING;
'!
!IP_ADDR_STRING categoriesForClass!Win32-Structs! !
!IP_ADDR_STRING methodsFor!

Context
	"Answer the <Integer> value of the receiver's 'Context' field."

	^bytes dwordAtOffset: _OffsetOf_Context!

IpAddress
	"Answer the <AnsiString> value of the receiver's 'IpAddress' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_IpAddress!

IpMask
	"Answer the <AnsiString> value of the receiver's 'IpMask' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_IpMask!

Next
	"Answer the <IP_ADDR_STRING> value of the receiver's 'Next' field."

	^IP_ADDR_STRING fromAddress: (bytes intPtrAtOffset: _OffsetOf_Next)! !
!IP_ADDR_STRING categoriesFor: #Context!**compiled accessors**!public! !
!IP_ADDR_STRING categoriesFor: #IpAddress!**compiled accessors**!public! !
!IP_ADDR_STRING categoriesFor: #IpMask!**compiled accessors**!public! !
!IP_ADDR_STRING categoriesFor: #Next!**compiled accessors**!public! !

!IP_ADDR_STRING class methodsFor!

defineFields
	"Define the fields of the IP_ADDR_STRING structure.
		IP_ADDR_STRING compileDefinition
	
		typedef 
		struct tagIP_ADDR_STRING {
			IP_ADDR_STRING* Next;
			IP_ADDRESS_STRING IpAddress;
			IP_ADDRESS_STRING IpMask;
			unsigned long Context;
		} IP_ADDR_STRING;
"

	self
		defineField: #Next
			type: ((PointerField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 0;
		defineField: #IpAddress
			type: ((StringField length: 16)
					beReadOnly;
					yourself)
			offset: 4;
		defineField: #IpMask
			type: ((StringField length: 16)
					beReadOnly;
					yourself)
			offset: 20;
		defineField: #Context
			type: DWORDField readOnly
			offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#Next #IpAddress #IpMask #Context)! !
!IP_ADDR_STRING class categoriesFor: #defineFields!initializing!public! !
!IP_ADDR_STRING class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

