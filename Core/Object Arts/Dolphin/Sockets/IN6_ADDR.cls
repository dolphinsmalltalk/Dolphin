"Filed out from Dolphin Smalltalk 7"!

AbstractIN_ADDR subclass: #IN6_ADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IN6_ADDR guid: (GUID fromString: '{BEBF4C25-CE63-4511-B68E-2434810FA9C3}')!
IN6_ADDR comment: '<IN6_ADDR> is an <ExternalStructure> class to wrap the struct ''Win32.IN6_ADDR'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BEBF4C25-CE63-4511-B68E-2434810FA9C3)]
struct tagIN6_ADDR {
	union {
		BYTE Byte[16];
		unsigned short Word[8];
	};
} IN6_ADDR;
'!
!IN6_ADDR categoriesForClass!Win32-Structs! !
!IN6_ADDR methodsFor!

Byte
	"Answer the receiver's Byte field as a Smalltalk object."

	^bytes!

Byte: anObject
	"Set the receiver's Byte field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(16 * ByteArray elementSize).
	anObject
		replaceBytesOf: bytes
		from: 1
		to: size
		startingAt: 1! !
!IN6_ADDR categoriesFor: #Byte!public! !
!IN6_ADDR categoriesFor: #Byte:!**compiled accessors**!public! !

!IN6_ADDR class methodsFor!

addressFamily
	^WinSocketConstants.AF_INET6!

defineFields
	"Define the fields of the IN6_ADDR structure.

	IN6_ADDR  compileDefinition

		typedef [uuid(BEBF4C25-CE63-4511-B68E-2434810FA9C3)]
		struct tagIN6_ADDR {
			union {
				BYTE Byte[16];
				unsigned short Word[8];
			};
		} IN6_ADDR;
	"

	"As the IN_ADDR structs are in network order (big endian) its likely to lead to errors
	attempting to access as words on a little-endian machine architecture."

	self
		defineField: #Byte
			type: (ArrayField type: ByteArray length: 16)
			offset: 0;
		defineField: #Word
			type: (ArrayField type: WORDArray length: 8) beFiller
			offset: 0.
	self byteSize: 16! !
!IN6_ADDR class categoriesFor: #addressFamily!public! !
!IN6_ADDR class categoriesFor: #defineFields!initializing!public! !

