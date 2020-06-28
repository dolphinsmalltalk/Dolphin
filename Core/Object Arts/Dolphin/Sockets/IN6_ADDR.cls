"Filed out from Dolphin Smalltalk 7"!

AbstractIN_ADDR subclass: #IN6_ADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Bytes' -> 16r0.
		'_OffsetOf_Words' -> 16r0
	}!
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
!IN6_ADDR categoriesFor: #Bytes!**compiled accessors**!public! !
!IN6_ADDR categoriesFor: #Bytes:!**compiled accessors**!public! !

!IN6_ADDR class methodsFor!

addressFamily
	^WinSocketConstants.AF_INET6!

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
		defineField: #Words type: (ArrayField type: WORDArray length: 8) beFiller offset: 0.
	self byteSize: 16!

getFieldNames
	^#(#Bytes)! !
!IN6_ADDR class categoriesFor: #addressFamily!constants!public! !
!IN6_ADDR class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!IN6_ADDR class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

