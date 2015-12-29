"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #WSADATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WSADATA guid: (GUID fromString: '{87B4C61D-026E-11D3-9FD7-00A0CC3E4A32}')!
WSADATA comment: '<WSADATA> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.WSAData'' from type information in the ''Windows Sockets 2 Type Library'' library. The WSADATA structure is used to request information about the current state of the Windows Asynchronous Socket system.

IDL definition follows:

typedef struct tagWSAData {
	unsigned short wVersion;
	unsigned short wHighVersion;
	CHAR szDescription[257];
	CHAR szSystemStatus[129];
	unsigned short iMaxSockets;
	unsigned short iMaxUdpDg;
	CHAR* lpVendorInfo;
} WSAData;
'!
!WSADATA categoriesForClass!External-Data-Structured-Win32!Windows Sockets! !
!WSADATA methodsFor!

iMaxSockets
	"Answer the receiver's iMaxSockets field as a Smalltalk object."

	^(bytes wordAtOffset: 390)!

iMaxUdpDg
	"Answer the receiver's iMaxUdpDg field as a Smalltalk object."

	^(bytes wordAtOffset: 392)!

lpVendorInfo
	"Answer the receiver's lpVendorInfo field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: 396)!

szDescription
	"Answer the receiver's szDescription field as a Smalltalk object."

	^String fromAddress: (bytes yourAddress + 4)!

szSystemStatus
	"Answer the receiver's szSystemStatus field as a Smalltalk object."

	^String fromAddress: (bytes yourAddress + 261)!

wHighVersion
	"Answer the receiver's wHighVersion field as a Smalltalk object."

	^(bytes wordAtOffset: 2)!

wVersion
	"Answer the receiver's wVersion field as a Smalltalk object."

	^(bytes wordAtOffset: 0)! !
!WSADATA categoriesFor: #iMaxSockets!**compiled accessors**!public! !
!WSADATA categoriesFor: #iMaxUdpDg!**compiled accessors**!public! !
!WSADATA categoriesFor: #lpVendorInfo!**compiled accessors**!public! !
!WSADATA categoriesFor: #szDescription!**compiled accessors**!public! !
!WSADATA categoriesFor: #szSystemStatus!**compiled accessors**!public! !
!WSADATA categoriesFor: #wHighVersion!**compiled accessors**!public! !
!WSADATA categoriesFor: #wVersion!**compiled accessors**!public! !

!WSADATA class methodsFor!

defineFields
	"Define the fields of the WSAData structure. Note that this structure is unusual in having a
	completely different layout for x64.

	WSADATA compileDefinition
	
		typedef struct WSAData {
				WORD                    wVersion;
				WORD                    wHighVersion;
		#ifdef _WIN64
				unsigned short          iMaxSockets;
				unsigned short          iMaxUdpDg;
				char FAR *              lpVendorInfo;
				char                    szDescription[WSADESCRIPTION_LEN+1];
				char                    szSystemStatus[WSASYS_STATUS_LEN+1];
		#else
				char                    szDescription[WSADESCRIPTION_LEN+1];
				char                    szSystemStatus[WSASYS_STATUS_LEN+1];
				unsigned short          iMaxSockets;
				unsigned short          iMaxUdpDg;
				char FAR *              lpVendorInfo;
		#endif
		} WSADATA, FAR * LPWSADATA;"

	self
		defineField: #wVersion type: WORDField readOnly;
		defineField: #wHighVersion type: WORDField readOnly.
	VMConstants.IsWin64 
		ifTrue: 
			[self
				defineField: #iMaxSockets type: WORDField readOnly;
				defineField: #iMaxUdpDg type: WORDField readOnly;
				defineField: #lpVendorInfo type: (PointerField type: String) beReadOnly;
				defineField: #szDescription
					type: (StringField length: WinSocketConstants.WSADESCRIPTION_LEN + 1) beReadOnly;
				defineField: #szSystemStatus
					type: (StringField length: WinSocketConstants.WSASYS_STATUS_LEN + 1) beReadOnly]
		ifFalse: 
			[self
				defineField: #szDescription
					type: (StringField length: WinSocketConstants.WSADESCRIPTION_LEN + 1) beReadOnly;
				defineField: #szSystemStatus
					type: (StringField length: WinSocketConstants.WSASYS_STATUS_LEN + 1) beReadOnly;
				defineField: #iMaxSockets type: WORDField readOnly;
				defineField: #iMaxUdpDg type: WORDField readOnly;
				defineField: #lpVendorInfo type: (PointerField type: String) beReadOnly]!

packing
	^4! !
!WSADATA class categoriesFor: #defineFields!initializing!public! !
!WSADATA class categoriesFor: #packing!public! !

