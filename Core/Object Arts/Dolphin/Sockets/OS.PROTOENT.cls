﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.PROTOENT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_p_aliases' -> 16r4.
			'_OffsetOf_p_name' -> 16r0.
			'_OffsetOf_p_proto' -> 16r8.
			'_PROTOENT_Size' -> 16rC
		}!

OS.PROTOENT guid: (Core.GUID fromString: '{87b4c60a-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.PROTOENT comment: '<PROTOENT> is an <ExternalStructure> class to wrap the struct ''Win32.PROTOENT'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The name and protocol numbers that correspond to a given protocol name. Applications must never attempt to modify this structure or to free any of its components. Furthermore, only one copy of this structure is allocated per thread."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(87B4C60A-026E-11D3-9FD7-00A0CC3E4A32), helpstring("The name and protocol numbers that correspond to a given protocol name. Applications must never attempt to modify this structure or to free any of its components. Furthermore, only one copy of this structure is allocated per thread.")]
struct tagPROTOENT {
	[readonly, helpstring("Official name of the protocol.")] LPCSTR p_name;
	[hidden, readonly, helpstring("Null-terminated array of alternate names.")] void** p_aliases;
	[readonly, helpstring("Protocol number, in host byte order.")] short p_proto;
} PROTOENT;
'!

!OS.PROTOENT categoriesForClass!Win32-Structs! !

!OS.PROTOENT methodsFor!

aliases
	"Answer an <Array> of <String>, being the alias names for the protocol."

	| i addresses list each |
	addresses := Array writeStream.
	i := 0.
	list := (bytes uintPtrAtOffset: _OffsetOf_p_aliases) asExternalAddress.
	
	[each := list uintPtrAtOffset: i.
	each isNull] whileFalse: 
				[addresses nextPut: (AnsiString fromAddress: each).
				i := i + VMConstants.IntPtrSize].
	^addresses contents!

p_name
	"Answer the <AnsiString> value of the receiver's 'p_name' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_p_name)!

p_proto
	"Answer the <Integer> value of the receiver's 'p_proto' field."

	^bytes int16AtOffset: _OffsetOf_p_proto!

printFieldsOn: aStream
	super printFieldsOn: aStream.
	aStream
		nextPutAll: ', aliases=';
		print: self aliases!

protocol
	"Answer the <integer> protocol number."

	| bigEndian |
	bigEndian := self p_proto.
	^(bigEndian << 8 bitOr: bigEndian >> 8) bitAnd: 16rFFFF! !

!OS.PROTOENT categoriesForMethods!
aliases!public! !
p_name!**compiled accessors**!public! !
p_proto!**compiled accessors**!public! !
printFieldsOn:!development!printing!private! !
protocol!public! !
!

!OS.PROTOENT class methodsFor!

byteSize
	^_PROTOENT_Size!

defineFields
	"Define the fields of the PROTOENT structure.

	PROTOENT compileDefinition

		typedef [uuid(87b4c60a-026e-11d3-9fd7-00a0cc3e4a32), helpstring('The name and protocol numbers that correspond to a given protocol name. Applications must never attempt to modify this structure or to free any of its components. Furthermore, only one copy of this structure is allocated per thread.')]
		struct tagPROTOENT {
			[readonly, helpstring('Official name of the protocol.')] LPCSTR p_name;
			[hidden, readonly, helpstring('Null-terminated array of alternate names.')] LPCSTR* p_aliases;
			[readonly, helpstring('Protocol number, in host byte order.')] short p_proto;
		} PROTOENT;
"

	self
		defineField: #p_name type: (PointerField type: AnsiString) beReadOnly offset: 0;
		defineField: #p_aliases type: (PointerField type: AnsiString) beReadOnly beFiller offset: 4;
		defineField: #p_proto type: Int16Field new beReadOnly offset: 8.
	self byteSize: 12!

fromInteger: anInteger
	"Answer the static (per-thread) PROTOENT instance populated with data for the numbered protocol.
		(self fromInteger: 6) 
	"

	| answer |
	answer := Ws2_32 getprotobynumber: anInteger.
	^answer isNull ifTrue: [Net.SocketError signalWith: Ws2_32 wsaGetLastError] ifFalse: [answer]!

fromString: aString
	"Answer the static (per-thread) PROTOENT instance populated with data for the named protocol.
		(self fromString: 'tcp') 
	"

	| answer |
	answer := Ws2_32 getprotobyname: aString.
	^answer isNull ifTrue: [Net.SocketError signalWith: Ws2_32 wsaGetLastError] ifFalse: [answer]!

getFieldNames
	^#(#p_name #p_proto)! !

!OS.PROTOENT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
fromInteger:!instance creation!public! !
fromString:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

