"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #WSADATA
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iMaxSockets _OffsetOf_iMaxUdpDg _OffsetOf_lpVendorInfo _OffsetOf_szDescription _OffsetOf_szSystemStatus _OffsetOf_wHighVersion _OffsetOf_wVersion'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WSADATA guid: (GUID fromString: '{ef5075d3-312c-49e0-b590-98987a18d0d2}')!
WSADATA addClassConstant: '_OffsetOf_iMaxSockets' value: 16r186!
WSADATA addClassConstant: '_OffsetOf_iMaxUdpDg' value: 16r188!
WSADATA addClassConstant: '_OffsetOf_lpVendorInfo' value: 16r18C!
WSADATA addClassConstant: '_OffsetOf_szDescription' value: 16r4!
WSADATA addClassConstant: '_OffsetOf_szSystemStatus' value: 16r105!
WSADATA addClassConstant: '_OffsetOf_wHighVersion' value: 16r2!
WSADATA addClassConstant: '_OffsetOf_wVersion' value: 16r0!
WSADATA comment: '<WSADATA> is an <ExternalStructure> class to wrap the struct ''Win32.WSADATA'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(EF5075D3-312C-49E0-B590-98987A18D0D2)]
struct tagWSADATA {
	[readonly, helpstring("The version of the Windows Sockets specification that the Ws2_32.dll expects the caller to use. The high-order byte specifies the minor version number; the low-order byte specifies the major version number.")] unsigned short wVersion;
	[readonly, helpstring("The highest version of the Windows Sockets specification that the Ws2_32.dll can support. The high-order byte specifies the minor version number; the low-order byte specifies the major version number.")] unsigned short wHighVersion;
	[readonly, helpstring("A NULL-terminated ASCII string into which the Ws2_32.dll copies a description of the Windows Sockets implementation. The text (up to 256 characters in length) can contain any characters except control and formatting characters.")] CHAR szDescription[257];
	[readonly, helpstring("A NULL-terminated ASCII string into which the Ws2_32.dll copies relevant status or configuration information. This member should not be considered as an extension of the szDescription parameter.")] CHAR szSystemStatus[129];
	[readonly, helpstring("The maximum number of sockets that may be opened. This member should be ignored for Windows Sockets version 2 and later.")] unsigned short iMaxSockets;
	[readonly, helpstring("The maximum datagram message size. This member is ignored for Windows Sockets version 2 and later.")] unsigned short iMaxUdpDg;
	[readonly, helpstring("A pointer to vendor-specific information. This member should be ignored for Windows Sockets version 2 and later.")] void* lpVendorInfo;
} WSADATA;
'!
!WSADATA categoriesForClass!Win32-Structs! !
!WSADATA methodsFor!

iMaxSockets
	"Answer the <Integer> value of the receiver's 'iMaxSockets' field."

	^bytes wordAtOffset: _OffsetOf_iMaxSockets!

iMaxUdpDg
	"Answer the <Integer> value of the receiver's 'iMaxUdpDg' field."

	^bytes wordAtOffset: _OffsetOf_iMaxUdpDg!

lpVendorInfo
	"Answer the <ExternalAddress> value of the receiver's 'lpVendorInfo' field."

	^(bytes uintPtrAtOffset: _OffsetOf_lpVendorInfo) asExternalAddress!

szDescription
	"Answer the <AnsiString> value of the receiver's 'szDescription' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_szDescription!

szSystemStatus
	"Answer the <AnsiString> value of the receiver's 'szSystemStatus' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_szSystemStatus!

wHighVersion
	"Answer the <Integer> value of the receiver's 'wHighVersion' field."

	^bytes wordAtOffset: _OffsetOf_wHighVersion!

wVersion
	"Answer the <Integer> value of the receiver's 'wVersion' field."

	^bytes wordAtOffset: _OffsetOf_wVersion! !
!WSADATA categoriesForMethods!
iMaxSockets!**compiled accessors**!public! !
iMaxUdpDg!**compiled accessors**!public! !
lpVendorInfo!**compiled accessors**!public! !
szDescription!**compiled accessors**!public! !
szSystemStatus!**compiled accessors**!public! !
wHighVersion!**compiled accessors**!public! !
wVersion!**compiled accessors**!public! !
!

!WSADATA class methodsFor!

defineFields
	"Define the fields of the WSADATA structure.

	WSADATA compileDefinition

		typedef [uuid(ef5075d3-312c-49e0-b590-98987a18d0d2), helpstring('Contains information about the Windows Sockets implementation on the machine.')]
		struct tagWSADATA {
			[readonly, helpstring('The version of the Windows Sockets specification that the Ws2_32.dll expects the caller to use. The high-order byte specifies the minor version number; the low-order byte specifies the major version number.')] WORD wVersion;
			[readonly, helpstring('The highest version of the Windows Sockets specification that the Ws2_32.dll can support. The high-order byte specifies the minor version number; the low-order byte specifies the major version number.')] WORD wHighVersion;
			[readonly, helpstring('A NULL-terminated ASCII string into which the Ws2_32.dll copies a description of the Windows Sockets implementation. The text (up to 256 characters in length) can contain any characters except control and formatting characters.'), string] BYTE szDescription[257];
			[readonly, helpstring('A NULL-terminated ASCII string into which the Ws2_32.dll copies relevant status or configuration information. This member should not be considered as an extension of the szDescription parameter.'), string] BYTE szSystemStatus[129];
			[readonly, helpstring('The maximum number of sockets that may be opened. This member should be ignored for Windows Sockets version 2 and later.')] unsigned short iMaxSockets;
			[readonly, helpstring('The maximum datagram message size. This member is ignored for Windows Sockets version 2 and later.')] unsigned short iMaxUdpDg;
			[readonly, helpstring('A pointer to vendor-specific information. This member should be ignored for Windows Sockets version 2 and later.')] void* lpVendorInfo;
		} WSADATA;
"

	self
		defineField: #wVersion type: WORDField new beReadOnly offset: 0;
		defineField: #wHighVersion type: WORDField new beReadOnly offset: 2;
		defineField: #szDescription type: (StringField type: AnsiString length: 257) beReadOnly offset: 4;
		defineField: #szSystemStatus type: (StringField type: AnsiString length: 129) beReadOnly offset: 261;
		defineField: #iMaxSockets type: WORDField new beReadOnly offset: 390;
		defineField: #iMaxUdpDg type: WORDField new beReadOnly offset: 392;
		defineField: #lpVendorInfo type: LPVOIDField new beReadOnly offset: 396.
	self byteSize: 400!

getFieldNames
	^#(#wVersion #wHighVersion #szDescription #szSystemStatus #iMaxSockets #iMaxUdpDg #lpVendorInfo)! !
!WSADATA class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

