"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.ADDRINFOW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.WinSocketConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_ADDRINFOW_Size' -> 16r20.
			'_OffsetOf_ai_addr' -> 16r18.
			'_OffsetOf_ai_addrlen' -> 16r10.
			'_OffsetOf_ai_canonname' -> 16r14.
			'_OffsetOf_ai_family' -> 16r4.
			'_OffsetOf_ai_flags' -> 16r0.
			'_OffsetOf_ai_next' -> 16r1C.
			'_OffsetOf_ai_protocol' -> 16rC.
			'_OffsetOf_ai_socktype' -> 16r8
		}!

OS.ADDRINFOW guid: (Core.GUID fromString: '{b9b7eb38-57f8-4e2a-b606-3fab05f505ea}')!

OS.ADDRINFOW comment: '`ADDRINFOW` is an `External.Structure` class to wrap the struct ''Win32.ADDRINFOW'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used by the GetAddrInfoW function to hold host address information."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(b9b7eb38-57f8-4e2a-b606-3fab05f505ea), helpstring("Used by the GetAddrInfoW function to hold host address information.")]
struct tagADDRINFOW {
	int ai_flags;
	int ai_family;
	int ai_socktype;
	int ai_protocol;
	ULONG_PTR ai_addrlen;
	LPWSTR ai_canonname;
	SOCKADDR* ai_addr;
	ADDRINFOW* ai_next;
} ADDRINFOW;
```
'!

!OS.ADDRINFOW categoriesForClass!Win32-Structs! !

!OS.ADDRINFOW methodsFor!

address
	"Answer the primary <InternetAddress> for the receiver"

	^self ai_addr address!

addressClass
	^self ai_family == AF_INET6 ifTrue: [SOCKADDR_IN6] ifFalse: [SOCKADDR_IN]!

ai_addr
	"Answer the <SOCKADDR> value of the receiver's 'ai_addr' field."

	^self addressClass fromAddress: (bytes intPtrAtOffset: _OffsetOf_ai_addr)!

ai_addr: aSOCKADDR
	"Set the receiver's 'ai_addr' field to the value of the argument, aSOCKADDR"

	bytes uintPtrAtOffset: _OffsetOf_ai_addr put: aSOCKADDR yourAddress!

ai_addrlen
	"Answer the <Integer> value of the receiver's 'ai_addrlen' field."

	^bytes uintPtrAtOffset: _OffsetOf_ai_addrlen!

ai_addrlen: anInteger
	"Set the receiver's 'ai_addrlen' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_ai_addrlen put: anInteger!

ai_canonname
	"Answer the <Utf16String> value of the receiver's 'ai_canonname' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_ai_canonname)!

ai_canonname: anUtf16String
	"Set the receiver's 'ai_canonname' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_ai_canonname put: anUtf16String yourAddress!

ai_family
	"Answer the <Integer> value of the receiver's 'ai_family' field."

	^bytes int32AtOffset: _OffsetOf_ai_family!

ai_family: anInteger
	"Set the receiver's 'ai_family' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_ai_family put: anInteger!

ai_flags
	"Answer the <Integer> value of the receiver's 'ai_flags' field."

	^bytes int32AtOffset: _OffsetOf_ai_flags!

ai_flags: anInteger
	"Set the receiver's 'ai_flags' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_ai_flags put: anInteger!

ai_next
	"Answer the <ADDRINFOW> value of the receiver's 'ai_next' field."

	^ADDRINFOW fromAddress: (bytes intPtrAtOffset: _OffsetOf_ai_next)!

ai_next: anADDRINFOW
	"Set the receiver's 'ai_next' field to the value of the argument, anADDRINFOW"

	bytes uintPtrAtOffset: _OffsetOf_ai_next put: anADDRINFOW yourAddress!

ai_protocol
	"Answer the <Integer> value of the receiver's 'ai_protocol' field."

	^bytes int32AtOffset: _OffsetOf_ai_protocol!

ai_protocol: anInteger
	"Set the receiver's 'ai_protocol' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_ai_protocol put: anInteger!

ai_socktype
	"Answer the <Integer> value of the receiver's 'ai_socktype' field."

	^bytes int32AtOffset: _OffsetOf_ai_socktype!

ai_socktype: anInteger
	"Set the receiver's 'ai_socktype' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_ai_socktype put: anInteger!

allAddresses
	"Answer an <Array> of <InternetAddress>, composed from the linked list of which the receiver is the first element."

	^self asArray collect: [:each | each address]!

asArray
	"Answer an <Array> of <ADDRINFOW>, composed from the linked list of which the receiver is the first element."

	| current addresses |
	addresses := Array writeStream.
	current := self.
	
	[addresses nextPut: current.
	current := current ai_next.
	current isNil] whileFalse.
	^addresses contents!

initialize
	"We don't want buffer instances to be finalizable, only pointer instances that are populated by GetAddrInfo"!

needsFree
	^self isNull not and: [self isPointer]! !

!OS.ADDRINFOW categoriesForMethods!
address!accessing!public! !
addressClass!helpers!private! !
ai_addr!accessing!public! !
ai_addr:!**compiled accessors**!public! !
ai_addrlen!**compiled accessors**!public! !
ai_addrlen:!**compiled accessors**!public! !
ai_canonname!**compiled accessors**!public! !
ai_canonname:!**compiled accessors**!public! !
ai_family!**compiled accessors**!public! !
ai_family:!**compiled accessors**!public! !
ai_flags!**compiled accessors**!public! !
ai_flags:!**compiled accessors**!public! !
ai_next!**compiled accessors**!public! !
ai_next:!**compiled accessors**!public! !
ai_protocol!**compiled accessors**!public! !
ai_protocol:!**compiled accessors**!public! !
ai_socktype!**compiled accessors**!public! !
ai_socktype:!**compiled accessors**!public! !
allAddresses!accessing!public! !
asArray!accessing!public! !
initialize!public! !
needsFree!private!realizing/unrealizing! !
!

!OS.ADDRINFOW class methodsFor!

byteSize
	^_ADDRINFOW_Size!

clear: addressOrBytes
	"Free external resources referenced by the structure of the receiver's element type at the specified address."

	Ws2_32 freeAddrInfoW: addressOrBytes!

defineFields
	"Define the fields of the ADDRINFOW structure.

	ADDRINFOW compileDefinition

		typedef [uuid(b9b7eb38-57f8-4e2a-b606-3fab05f505ea), helpstring('Used by the GetAddrInfoW function to hold host address information.')]
		struct tagADDRINFOW {
			int ai_flags;
			int ai_family;
			int ai_socktype;
			int ai_protocol;
			ULONG_PTR ai_addrlen;
			LPWSTR ai_canonname;
			SOCKADDR* ai_addr;
			ADDRINFOW* ai_next;
		} ADDRINFOW;
"

	self
		defineField: #ai_flags type: Int32Field new offset: 0;
		defineField: #ai_family type: Int32Field new offset: 4;
		defineField: #ai_socktype type: Int32Field new offset: 8;
		defineField: #ai_protocol type: Int32Field new offset: 12;
		defineField: #ai_addrlen type: UIntPtrField new offset: 16;
		defineField: #ai_canonname type: (PointerField type: Utf16String) offset: 20;
		defineField: #ai_addr type: (PointerField type: SOCKADDR) offset: 24;
		defineField: #ai_next type: (PointerField type: ADDRINFOW) offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#ai_flags #ai_family #ai_socktype #ai_protocol #ai_addrlen #ai_canonname #ai_addr #ai_next)!

host: aString
	"Answer a new instance of the receiver describing a host with the name specified by the <String> argument. If the argument is the empty string, then the instance describes the localhost.
		(self host: '')
	"

	^Ws2_32 getAddrInfo: aString family: WinSocketConstants.AF_INET!

localhost
	"Answer a new instance of the receiver describing the local host."

	^self host: ''! !

!OS.ADDRINFOW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
host:!instance creation!public! !
localhost!instance creation!public! !
!

