"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.WSAPROTOCOL_INFOW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_dwCatalogEntryId' -> 16r24.
			'_OffsetOf_dwMessageSize' -> 16r6C.
			'_OffsetOf_dwProviderFlags' -> 16r10.
			'_OffsetOf_dwProviderReserved' -> 16r70.
			'_OffsetOf_dwServiceFlags1' -> 16r0.
			'_OffsetOf_dwServiceFlags2' -> 16r4.
			'_OffsetOf_dwServiceFlags3' -> 16r8.
			'_OffsetOf_dwServiceFlags4' -> 16rC.
			'_OffsetOf_iAddressFamily' -> 16r4C.
			'_OffsetOf_iMaxSockAddr' -> 16r50.
			'_OffsetOf_iMinSockAddr' -> 16r54.
			'_OffsetOf_iNetworkByteOrder' -> 16r64.
			'_OffsetOf_iProtocol' -> 16r5C.
			'_OffsetOf_iProtocolMaxOffset' -> 16r60.
			'_OffsetOf_iSecurityScheme' -> 16r68.
			'_OffsetOf_iSocketType' -> 16r58.
			'_OffsetOf_iVersion' -> 16r48.
			'_OffsetOf_ProtocolChain' -> 16r28.
			'_OffsetOf_ProviderId' -> 16r14.
			'_OffsetOf_szProtocol' -> 16r74.
			'_WSAPROTOCOL_INFOW_Size' -> 16r274
		}!

OS.WSAPROTOCOL_INFOW guid: (Core.GUID fromString: '{1309bf11-05a9-46e9-9db2-e33d3bacf334}')!

OS.WSAPROTOCOL_INFOW comment: '`WSAPROTOCOL_INFOW` is an `External.Structure` class to wrap the struct ''Win32.WSAPROTOCOL_INFOW'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagWSAPROTOCOL_INFOW {
	DWORD dwServiceFlags1;
	DWORD dwServiceFlags2;
	DWORD dwServiceFlags3;
	DWORD dwServiceFlags4;
	DWORD dwProviderFlags;
	guid ProviderId;
	DWORD dwCatalogEntryId;
	WSAPROTOCOLCHAIN ProtocolChain;
	int iVersion;
	int iAddressFamily;
	int iMaxSockAddr;
	int iMinSockAddr;
	int iSocketType;
	int iProtocol;
	int iProtocolMaxOffset;
	int iNetworkByteOrder;
	int iSecurityScheme;
	DWORD dwMessageSize;
	DWORD dwProviderReserved;
	unsigned short szProtocol[256];
} WSAPROTOCOL_INFOW;
```
'!

!OS.WSAPROTOCOL_INFOW categoriesForClass!Win32-Structs! !

!OS.WSAPROTOCOL_INFOW methodsFor!

dwCatalogEntryId
	"Answer the <Integer> value of the receiver's 'dwCatalogEntryId' field."

	^bytes uint32AtOffset: _OffsetOf_dwCatalogEntryId!

dwCatalogEntryId: anInteger
	"Set the receiver's 'dwCatalogEntryId' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwCatalogEntryId put: anInteger!

dwMessageSize
	"Answer the <Integer> value of the receiver's 'dwMessageSize' field."

	^bytes uint32AtOffset: _OffsetOf_dwMessageSize!

dwMessageSize: anInteger
	"Set the receiver's 'dwMessageSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwMessageSize put: anInteger!

dwProviderFlags
	"Answer the <Integer> value of the receiver's 'dwProviderFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwProviderFlags!

dwProviderFlags: anInteger
	"Set the receiver's 'dwProviderFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwProviderFlags put: anInteger!

dwProviderReserved
	"Answer the <Integer> value of the receiver's 'dwProviderReserved' field."

	^bytes uint32AtOffset: _OffsetOf_dwProviderReserved!

dwProviderReserved: anInteger
	"Set the receiver's 'dwProviderReserved' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwProviderReserved put: anInteger!

dwServiceFlags1
	"Answer the <Integer> value of the receiver's 'dwServiceFlags1' field."

	^bytes uint32AtOffset: _OffsetOf_dwServiceFlags1!

dwServiceFlags1: anInteger
	"Set the receiver's 'dwServiceFlags1' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwServiceFlags1 put: anInteger!

dwServiceFlags2
	"Answer the <Integer> value of the receiver's 'dwServiceFlags2' field."

	^bytes uint32AtOffset: _OffsetOf_dwServiceFlags2!

dwServiceFlags2: anInteger
	"Set the receiver's 'dwServiceFlags2' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwServiceFlags2 put: anInteger!

dwServiceFlags3
	"Answer the <Integer> value of the receiver's 'dwServiceFlags3' field."

	^bytes uint32AtOffset: _OffsetOf_dwServiceFlags3!

dwServiceFlags3: anInteger
	"Set the receiver's 'dwServiceFlags3' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwServiceFlags3 put: anInteger!

dwServiceFlags4
	"Answer the <Integer> value of the receiver's 'dwServiceFlags4' field."

	^bytes uint32AtOffset: _OffsetOf_dwServiceFlags4!

dwServiceFlags4: anInteger
	"Set the receiver's 'dwServiceFlags4' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwServiceFlags4 put: anInteger!

iAddressFamily
	"Answer the <Integer> value of the receiver's 'iAddressFamily' field."

	^bytes int32AtOffset: _OffsetOf_iAddressFamily!

iAddressFamily: anInteger
	"Set the receiver's 'iAddressFamily' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iAddressFamily put: anInteger!

iMaxSockAddr
	"Answer the <Integer> value of the receiver's 'iMaxSockAddr' field."

	^bytes int32AtOffset: _OffsetOf_iMaxSockAddr!

iMaxSockAddr: anInteger
	"Set the receiver's 'iMaxSockAddr' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iMaxSockAddr put: anInteger!

iMinSockAddr
	"Answer the <Integer> value of the receiver's 'iMinSockAddr' field."

	^bytes int32AtOffset: _OffsetOf_iMinSockAddr!

iMinSockAddr: anInteger
	"Set the receiver's 'iMinSockAddr' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iMinSockAddr put: anInteger!

iNetworkByteOrder
	"Answer the <Integer> value of the receiver's 'iNetworkByteOrder' field."

	^bytes int32AtOffset: _OffsetOf_iNetworkByteOrder!

iNetworkByteOrder: anInteger
	"Set the receiver's 'iNetworkByteOrder' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iNetworkByteOrder put: anInteger!

iProtocol
	"Answer the <Integer> value of the receiver's 'iProtocol' field."

	^bytes int32AtOffset: _OffsetOf_iProtocol!

iProtocol: anInteger
	"Set the receiver's 'iProtocol' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iProtocol put: anInteger!

iProtocolMaxOffset
	"Answer the <Integer> value of the receiver's 'iProtocolMaxOffset' field."

	^bytes int32AtOffset: _OffsetOf_iProtocolMaxOffset!

iProtocolMaxOffset: anInteger
	"Set the receiver's 'iProtocolMaxOffset' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iProtocolMaxOffset put: anInteger!

iSecurityScheme
	"Answer the <Integer> value of the receiver's 'iSecurityScheme' field."

	^bytes int32AtOffset: _OffsetOf_iSecurityScheme!

iSecurityScheme: anInteger
	"Set the receiver's 'iSecurityScheme' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iSecurityScheme put: anInteger!

iSocketType
	"Answer the <Integer> value of the receiver's 'iSocketType' field."

	^bytes int32AtOffset: _OffsetOf_iSocketType!

iSocketType: anInteger
	"Set the receiver's 'iSocketType' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iSocketType put: anInteger!

iVersion
	"Answer the <Integer> value of the receiver's 'iVersion' field."

	^bytes int32AtOffset: _OffsetOf_iVersion!

iVersion: anInteger
	"Set the receiver's 'iVersion' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iVersion put: anInteger!

ProtocolChain
	"Answer the <WSAPROTOCOLCHAIN> value of the receiver's 'ProtocolChain' field."

	^WSAPROTOCOLCHAIN fromAddress: bytes yourAddress + _OffsetOf_ProtocolChain!

ProtocolChain: aWSAPROTOCOLCHAIN
	"Set the receiver's 'ProtocolChain' field to the value of the argument, aWSAPROTOCOLCHAIN"

	aWSAPROTOCOLCHAIN
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ProtocolChain + 1)
		to: ##(_OffsetOf_ProtocolChain + WSAPROTOCOLCHAIN._WSAPROTOCOLCHAIN_Size)
		startingAt: 1!

ProviderId
	"Answer the <GUID> value of the receiver's 'ProviderId' field."

	^GUID fromAddress: bytes yourAddress + _OffsetOf_ProviderId!

ProviderId: aGUID
	"Set the receiver's 'ProviderId' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ProviderId + 1)
		to: ##(_OffsetOf_ProviderId + GUID._GUID_Size)
		startingAt: 1!

szProtocol
	"Answer the <UInt16Array> value of the receiver's 'szProtocol' field."

	^UInt16Array fromAddress: bytes yourAddress + _OffsetOf_szProtocol length: 256!

szProtocol: anUInt16Array
	"Set the receiver's 'szProtocol' field to the value of the argument, anUInt16Array"

	| size |
	size := anUInt16Array byteSize min: ##(256 * UInt16Array elementSize).
	anUInt16Array
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szProtocol + 1)
		to: _OffsetOf_szProtocol + size
		startingAt: 1! !

!OS.WSAPROTOCOL_INFOW categoriesForMethods!
dwCatalogEntryId!**compiled accessors**!public! !
dwCatalogEntryId:!**compiled accessors**!public! !
dwMessageSize!**compiled accessors**!public! !
dwMessageSize:!**compiled accessors**!public! !
dwProviderFlags!**compiled accessors**!public! !
dwProviderFlags:!**compiled accessors**!public! !
dwProviderReserved!**compiled accessors**!public! !
dwProviderReserved:!**compiled accessors**!public! !
dwServiceFlags1!**compiled accessors**!public! !
dwServiceFlags1:!**compiled accessors**!public! !
dwServiceFlags2!**compiled accessors**!public! !
dwServiceFlags2:!**compiled accessors**!public! !
dwServiceFlags3!**compiled accessors**!public! !
dwServiceFlags3:!**compiled accessors**!public! !
dwServiceFlags4!**compiled accessors**!public! !
dwServiceFlags4:!**compiled accessors**!public! !
iAddressFamily!**compiled accessors**!public! !
iAddressFamily:!**compiled accessors**!public! !
iMaxSockAddr!**compiled accessors**!public! !
iMaxSockAddr:!**compiled accessors**!public! !
iMinSockAddr!**compiled accessors**!public! !
iMinSockAddr:!**compiled accessors**!public! !
iNetworkByteOrder!**compiled accessors**!public! !
iNetworkByteOrder:!**compiled accessors**!public! !
iProtocol!**compiled accessors**!public! !
iProtocol:!**compiled accessors**!public! !
iProtocolMaxOffset!**compiled accessors**!public! !
iProtocolMaxOffset:!**compiled accessors**!public! !
iSecurityScheme!**compiled accessors**!public! !
iSecurityScheme:!**compiled accessors**!public! !
iSocketType!**compiled accessors**!public! !
iSocketType:!**compiled accessors**!public! !
iVersion!**compiled accessors**!public! !
iVersion:!**compiled accessors**!public! !
ProtocolChain!**compiled accessors**!public! !
ProtocolChain:!**compiled accessors**!public! !
ProviderId!**compiled accessors**!public! !
ProviderId:!**compiled accessors**!public! !
szProtocol!**compiled accessors**!public! !
szProtocol:!**compiled accessors**!public! !
!

!OS.WSAPROTOCOL_INFOW class methodsFor!

byteSize
	^_WSAPROTOCOL_INFOW_Size!

defineFields
	"Define the fields of the WSAPROTOCOL_INFOW structure.

	WSAPROTOCOL_INFOW compileDefinition

		typedef 
		struct tagWSAPROTOCOL_INFOW {
			DWORD dwServiceFlags1;
			DWORD dwServiceFlags2;
			DWORD dwServiceFlags3;
			DWORD dwServiceFlags4;
			DWORD dwProviderFlags;
			guid ProviderId;
			DWORD dwCatalogEntryId;
			WSAPROTOCOLCHAIN ProtocolChain;
			int iVersion;
			int iAddressFamily;
			int iMaxSockAddr;
			int iMinSockAddr;
			int iSocketType;
			int iProtocol;
			int iProtocolMaxOffset;
			int iNetworkByteOrder;
			int iSecurityScheme;
			DWORD dwMessageSize;
			DWORD dwProviderReserved;
			unsigned short szProtocol[256];
		} WSAPROTOCOL_INFOW;
"

	self
		defineField: #dwServiceFlags1 type: UInt32Field new offset: 0;
		defineField: #dwServiceFlags2 type: UInt32Field new offset: 4;
		defineField: #dwServiceFlags3 type: UInt32Field new offset: 8;
		defineField: #dwServiceFlags4 type: UInt32Field new offset: 12;
		defineField: #dwProviderFlags type: UInt32Field new offset: 16;
		defineField: #ProviderId type: (StructureField type: GUID) offset: 20;
		defineField: #dwCatalogEntryId type: UInt32Field new offset: 36;
		defineField: #ProtocolChain type: (StructureField type: WSAPROTOCOLCHAIN) offset: 40;
		defineField: #iVersion type: Int32Field new offset: 72;
		defineField: #iAddressFamily type: Int32Field new offset: 76;
		defineField: #iMaxSockAddr type: Int32Field new offset: 80;
		defineField: #iMinSockAddr type: Int32Field new offset: 84;
		defineField: #iSocketType type: Int32Field new offset: 88;
		defineField: #iProtocol type: Int32Field new offset: 92;
		defineField: #iProtocolMaxOffset type: Int32Field new offset: 96;
		defineField: #iNetworkByteOrder type: Int32Field new offset: 100;
		defineField: #iSecurityScheme type: Int32Field new offset: 104;
		defineField: #dwMessageSize type: UInt32Field new offset: 108;
		defineField: #dwProviderReserved type: UInt32Field new offset: 112;
		defineField: #szProtocol type: (ArrayField type: UInt16Array length: 256) offset: 116.
	self byteSize: 628!

getFieldNames
	^#(#dwServiceFlags1 #dwServiceFlags2 #dwServiceFlags3 #dwServiceFlags4 #dwProviderFlags #ProviderId #dwCatalogEntryId #ProtocolChain #iVersion #iAddressFamily #iMaxSockAddr #iMinSockAddr #iSocketType #iProtocol #iProtocolMaxOffset #iNetworkByteOrder #iSecurityScheme #dwMessageSize #dwProviderReserved #szProtocol)! !

!OS.WSAPROTOCOL_INFOW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

