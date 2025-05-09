﻿"Filed out from Dolphin Smalltalk"!

OS.AbstractIN_ADDR
	subclass: #'OS.IN6_ADDR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_IN6_ADDR_Size' -> 16r10. '_OffsetOf_Bytes' -> 16r0. '_OffsetOf_Words' -> 16r0 }!

OS.IN6_ADDR guid: (Core.GUID fromString: '{bebf4c25-ce63-4511-b68e-2434810fa9c3}')!

OS.IN6_ADDR comment: '`OS.IN6_ADDR` is an `External.Structure` class to wrap the struct ''Win32.IN6_ADDR'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BEBF4C25-CE63-4511-B68E-2434810FA9C3)]
struct tagIN6_ADDR {
	union {
		UCHAR Bytes[16];
		[hidden] USHORT Words[8];
	};
} IN6_ADDR;
'!

!OS.IN6_ADDR categoriesForClass!Win32-Structs! !

!OS.IN6_ADDR methodsFor!

Bytes
	"Answer the <ExternalArray> value of the receiver's 'Bytes' field."

	^ExternalArray fromAddress: bytes yourAddress length: 16!

Bytes: anExternalArray
	"Set the receiver's 'Bytes' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize min: ##(16 * ExternalArray elementSize).
	anExternalArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Bytes + 1)
		to: size
		startingAt: 1! !

!OS.IN6_ADDR categoriesForMethods!
Bytes!**compiled accessors**!public! !
Bytes:!**compiled accessors**!public! !
!

!OS.IN6_ADDR class methodsFor!

addressFamily
	^WinSocketConstants.AF_INET6!

byteSize
	^_IN6_ADDR_Size!

defineFields
	"Define the fields of the IN6_ADDR structure.

	IN6_ADDR compileDefinition

		typedef [uuid(bebf4c25-ce63-4511-b68e-2434810fa9c3)]
		struct tagIN6_ADDR {
			union {
				UCHAR Bytes[16];
				[hidden] USHORT Words[8];
			};
		} IN6_ADDR;
"

	self
		defineField: #Bytes type: (ArrayField type: ExternalArray length: 16) offset: 0;
		defineField: #Words type: (ArrayField type: UInt16Array length: 8) beFiller offset: 0.
	self byteSize: 16!

getFieldNames
	^#(#Bytes)! !

!OS.IN6_ADDR class categoriesForMethods!
addressFamily!constants!public! !
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

