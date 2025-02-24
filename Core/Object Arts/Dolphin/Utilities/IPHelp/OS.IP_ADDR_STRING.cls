﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.IP_ADDR_STRING'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_IP_ADDR_STRING_Size' -> 16r28.
			'_OffsetOf_Context' -> 16r24.
			'_OffsetOf_IpAddress' -> 16r4.
			'_OffsetOf_IpMask' -> 16r14.
			'_OffsetOf_Next' -> 16r0
		}!

OS.IP_ADDR_STRING guid: (Core.GUID fromString: '{ba94c426-f5a5-47e8-b2c5-43d6c2456846}')!

OS.IP_ADDR_STRING comment: '<IP_ADDR_STRING> is an <ExternalStructure> class to wrap the struct ''Win32.IP_ADDR_STRING'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.IP_ADDR_STRING categoriesForClass!Win32-Structs! !

!OS.IP_ADDR_STRING methodsFor!

Context
	"Answer the <Integer> value of the receiver's 'Context' field."

	^bytes uint32AtOffset: _OffsetOf_Context!

IpAddress
	"Answer the <AnsiString> value of the receiver's 'IpAddress' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_IpAddress!

IpMask
	"Answer the <AnsiString> value of the receiver's 'IpMask' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_IpMask!

Next
	"Answer the <IP_ADDR_STRING> value of the receiver's 'Next' field."

	^IP_ADDR_STRING fromAddress: (bytes intPtrAtOffset: _OffsetOf_Next)! !

!OS.IP_ADDR_STRING categoriesForMethods!
Context!**compiled accessors**!public! !
IpAddress!**compiled accessors**!public! !
IpMask!**compiled accessors**!public! !
Next!**compiled accessors**!public! !
!

!OS.IP_ADDR_STRING class methodsFor!

byteSize
	^_IP_ADDR_STRING_Size!

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
			type: UInt32Field readOnly
			offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#Next #IpAddress #IpMask #Context)! !

!OS.IP_ADDR_STRING class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

