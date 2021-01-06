"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.WSADATA'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iMaxSockets' -> 16r186.
		'_OffsetOf_iMaxUdpDg' -> 16r188.
		'_OffsetOf_lpVendorInfo' -> 16r18C.
		'_OffsetOf_szDescription' -> 16r4.
		'_OffsetOf_szSystemStatus' -> 16r105.
		'_OffsetOf_wHighVersion' -> 16r2.
		'_OffsetOf_wVersion' -> 16r0
	}!
OS.WSADATA guid: (Core.GUID fromString: '{ef5075d3-312c-49e0-b590-98987a18d0d2}')!
OS.WSADATA comment: '<WSADATA> is an <ExternalStructure> class to wrap the struct ''Win32.WSADATA'' from type information in the ''Win32 API'' library.

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
!OS.WSADATA categoriesForClass!Win32-Structs! !
!OS.WSADATA methodsFor!

iMaxSockets
	"Answer the <Integer> value of the receiver's 'iMaxSockets' field."

	^bytes wordAtOffset: _OffsetOf_iMaxSockets!

iMaxUdpDg
	"Answer the <Integer> value of the receiver's 'iMaxUdpDg' field."

	^bytes wordAtOffset: _OffsetOf_iMaxUdpDg!

lpVendorInfo
	"Answer the <Address> value of the receiver's 'lpVendorInfo' field."

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
!OS.WSADATA categoriesFor: #iMaxSockets!**compiled accessors**!public! !
!OS.WSADATA categoriesFor: #iMaxUdpDg!**compiled accessors**!public! !
!OS.WSADATA categoriesFor: #lpVendorInfo!**compiled accessors**!public! !
!OS.WSADATA categoriesFor: #szDescription!**compiled accessors**!public! !
!OS.WSADATA categoriesFor: #szSystemStatus!**compiled accessors**!public! !
!OS.WSADATA categoriesFor: #wHighVersion!**compiled accessors**!public! !
!OS.WSADATA categoriesFor: #wVersion!**compiled accessors**!public! !

!OS.WSADATA class methodsFor!

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
!OS.WSADATA class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!OS.WSADATA class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

