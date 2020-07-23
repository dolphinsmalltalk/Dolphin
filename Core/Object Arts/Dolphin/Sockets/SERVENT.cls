"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #SERVENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_s_aliases' -> 16r4.
		'_OffsetOf_s_name' -> 16r0.
		'_OffsetOf_s_port' -> 16r8.
		'_OffsetOf_s_proto' -> 16rC
	}!
SERVENT guid: (GUID fromString: '{87b4c610-026e-11d3-9fd7-00a0cc3e4a32}')!
SERVENT comment: '<SERVENT> is an <ExternalStructure> class to wrap the struct ''Win32.SERVENT'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used to store or return the name and service number for a given service name."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(87B4C610-026E-11D3-9FD7-00A0CC3E4A32), helpstring("Used to store or return the name and service number for a given service name.")]
struct tagSERVENT {
	[readonly, helpstring("The official name of the service.")] LPCSTR s_name;
	[hidden, readonly, helpstring("A NULL-terminated array of alternate names.")] LPCSTR* s_aliases;
	[readonly, helpstring("The port number at which the service can be contacted. Port numbers are returned in network byte order.")] short s_port;
	[readonly, helpstring("The name of the protocol to use when contacting the service.")] LPCSTR s_proto;
} SERVENT;
'!
!SERVENT categoriesForClass!Win32-Structs! !
!SERVENT methodsFor!

aliases
	"Answer an <Array> of <String>, being the alias names for the protocol."

	| i addresses list each |
	addresses := Array writeStream.
	i := 0.
	list := (bytes uintPtrAtOffset: _OffsetOf_s_aliases) asExternalAddress.
	
	[each := list uintPtrAtOffset: i.
	each isNull] whileFalse: 
				[addresses nextPut: (AnsiString fromAddress: each).
				i := i + VMConstants.IntPtrSize].
	^addresses contents!

port
	"Answer the <integer> port number."

	^WS2_32Library default ntohs: self s_port!

printFieldsOn: aStream
	super printFieldsOn: aStream.
	aStream
		nextPutAll: ', aliases=';
		print: self aliases!

s_name
	"Answer the <AnsiString> value of the receiver's 's_name' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_s_name)!

s_port
	"Answer the <Integer> value of the receiver's 's_port' field."

	^bytes swordAtOffset: _OffsetOf_s_port!

s_proto
	"Answer the <AnsiString> value of the receiver's 's_proto' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_s_proto)! !
!SERVENT categoriesFor: #aliases!public! !
!SERVENT categoriesFor: #port!accessing!public! !
!SERVENT categoriesFor: #printFieldsOn:!development!printing!private! !
!SERVENT categoriesFor: #s_name!**compiled accessors**!public! !
!SERVENT categoriesFor: #s_port!**compiled accessors**!public! !
!SERVENT categoriesFor: #s_proto!**compiled accessors**!public! !

!SERVENT class methodsFor!

defineFields
	"Define the fields of the SERVENT structure.

	SERVENT  compileDefinition

		typedef [uuid(87B4C610-026E-11D3-9FD7-00A0CC3E4A32), helpstring('Used to store or return the name and service number for a given service name.')]
		struct tagSERVENT {
			[readonly, helpstring('The official name of the service.')] LPCSTR s_name;
			[hidden, readonly, helpstring('A NULL-terminated array of alternate names.')] LPCSTR* s_aliases;
			[readonly, helpstring('The port number at which the service can be contacted. Port numbers are returned in network byte order.')] short s_port;
			[readonly, helpstring('The name of the protocol to use when contacting the service.')] LPCSTR s_proto;
		} SERVENT;
"

	self
		defineField: #s_name type: (PointerField type: AnsiString) beReadOnly offset: 0;
		defineField: #s_aliases type: (PointerField type: LPSTR) beReadOnly beFiller offset: 4;
		defineField: #s_port type: SWORDField new beReadOnly offset: 8;
		defineField: #s_proto type: (PointerField type: AnsiString) beReadOnly offset: 12.
	self byteSize: 16!

fromInteger: anInteger
	"Answer the static (per-thread) SERVENT instance populated with data for the service associated with the specified port.
		(self fromInteger: 80) 
	"

	| answer lib port |
	lib := WS2_32Library default.
	"Flip port number into network order"
	port := (anInteger << 8 bitOr: anInteger >> 8) bitAnd: 16rFFFF.
	answer := lib getservbyport: port proto: nil.
	^answer isNull ifTrue: [SocketError signalWith: lib wsaGetLastError] ifFalse: [answer]!

fromString: aString
	"Answer the static (per-thread) SERVENT instance populated with data for the named service.
		(self fromString: 'http')
	"

	| answer lib |
	lib := WS2_32Library default.
	answer := lib getservbyname: aString proto: nil.
	^answer isNull ifTrue: [SocketError signalWith: lib wsaGetLastError] ifFalse: [answer]!

getFieldNames
	^#(#s_name #s_port #s_proto)! !
!SERVENT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!SERVENT class categoriesFor: #fromInteger:!public! !
!SERVENT class categoriesFor: #fromString:!public! !
!SERVENT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

