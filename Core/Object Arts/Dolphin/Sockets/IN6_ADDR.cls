"Filed out from Dolphin Smalltalk 7"!

AbstractIN_ADDR subclass: #IN6_ADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IN6_ADDR guid: (GUID fromString: '{bebf4c25-ce63-4511-b68e-2434810fa9c3}')!
IN6_ADDR comment: '<IN6_ADDR> is an <ExternalStructure> class to wrap the struct ''Win32.IN6_ADDR'' from type information in the ''Win32 API'' library.

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
!IN6_ADDR categoriesForClass!Win32-Structs! !
!IN6_ADDR methodsFor!

Bytes
	"Answer the <ByteArray> value of the receiver's 'Bytes' field."

	^ByteArray fromAddress: bytes yourAddress length: 16!

Bytes: aByteArray
	"Set the receiver's 'Bytes' field to the value of the argument, aByteArray"

	| size |
	size := aByteArray byteSize min: ##(16 * ByteArray elementSize).
	aByteArray
		replaceBytesOf: bytes
		from: 1
		to: size
		startingAt: 1! !
!IN6_ADDR categoriesFor: #Bytes!**compiled accessors**!public! !
!IN6_ADDR categoriesFor: #Bytes:!**compiled accessors**!public! !

!IN6_ADDR class methodsFor!

addressFamily
	^WinSocketConstants.AF_INET6!

defineFields
	"Define the fields of the IN6_ADDR structure.

	IN6_ADDR  compileDefinition

		typedef [uuid(BEBF4C25-CE63-4511-B68E-2434810FA9C3)]
		struct tagIN6_ADDR {
			union {
				UCHAR Bytes[16];
				[hidden] USHORT Words[8];
			};
		} IN6_ADDR;
"

	self
		defineField: #Bytes type: (ArrayField type: ByteArray length: 16) offset: 0;
		defineField: #Words type: (ArrayField type: WORDArray length: 8) beFiller offset: 0.
	self byteSize: 16! !
!IN6_ADDR class categoriesFor: #addressFamily!constants!public! !
!IN6_ADDR class categoriesFor: #defineFields!**auto generated**!initializing!public! !

