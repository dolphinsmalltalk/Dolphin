"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_LOG_FIELDS_DATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ClientIp' -> 16r24.
		'_OffsetOf_ClientIpLength' -> 16r8.
		'_OffsetOf_Cookie' -> 16r44.
		'_OffsetOf_CookieLength' -> 16r18.
		'_OffsetOf_Host' -> 16r3C.
		'_OffsetOf_HostLength' -> 16r14.
		'_OffsetOf_Method' -> 16r34.
		'_OffsetOf_MethodLength' -> 16r10.
		'_OffsetOf_MethodNum' -> 16r54.
		'_OffsetOf_ProtocolStatus' -> 16r4E.
		'_OffsetOf_Referrer' -> 16r48.
		'_OffsetOf_ReferrerLength' -> 16r1A.
		'_OffsetOf_ServerIp' -> 16r30.
		'_OffsetOf_ServerIpLength' -> 16rE.
		'_OffsetOf_ServerName' -> 16r28.
		'_OffsetOf_ServerNameLength' -> 16rA.
		'_OffsetOf_ServerPort' -> 16r4C.
		'_OffsetOf_ServiceName' -> 16r2C.
		'_OffsetOf_ServiceNameLength' -> 16rC.
		'_OffsetOf_SubStatus' -> 16r58.
		'_OffsetOf_Type' -> 16r0.
		'_OffsetOf_UriQuery' -> 16r38.
		'_OffsetOf_UriQueryLength' -> 16r12.
		'_OffsetOf_UriStem' -> 16r20.
		'_OffsetOf_UriStemLength' -> 16r6.
		'_OffsetOf_UserAgent' -> 16r40.
		'_OffsetOf_UserAgentLength' -> 16r16.
		'_OffsetOf_UserName' -> 16r1C.
		'_OffsetOf_UserNameLength' -> 16r4.
		'_OffsetOf_Win32Status' -> 16r50
	}!
HTTP_LOG_FIELDS_DATA guid: (GUID fromString: '{35c62b99-abf3-46f3-b967-7b54dc2641cc}')!
HTTP_LOG_FIELDS_DATA comment: '<HTTP_LOG_FIELDS_DATA> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_LOG_FIELDS_DATA'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Current log fields data structure for of type HttpLogDataTypeFields."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(35c62b99-abf3-46f3-b967-7b54dc2641cc), helpstring("Current log fields data structure for of type HttpLogDataTypeFields.")]
struct tagHTTP_LOG_FIELDS_DATA {
	HTTP_LOG_DATA_TYPE Type;
	USHORT UserNameLength;
	USHORT UriStemLength;
	USHORT ClientIpLength;
	USHORT ServerNameLength;
	USHORT ServiceNameLength;
	USHORT ServerIpLength;
	USHORT MethodLength;
	USHORT UriQueryLength;
	USHORT HostLength;
	USHORT UserAgentLength;
	USHORT CookieLength;
	USHORT ReferrerLength;
	[size_is("UserNameLength"), string] PWCHAR UserName;
	[size_is("UriStemLength"), string] PWCHAR UriStem;
	[size_is("ClientIpLength"), string] PCHAR ClientIp;
	[size_is("ServerNameLength"), string] PCHAR ServerName;
	[size_is("ServiceNameLength"), string] PCHAR ServiceName;
	[size_is("ServerIpLength"), string] PCHAR ServerIp;
	[size_is("MethodLength"), string] PCHAR Method;
	[size_is("UriQueryLength"), string] PCHAR UriQuery;
	[size_is("HostLength"), string] PCHAR Host;
	[size_is("UserAgentLength"), string] PCHAR UserAgent;
	[size_is("CookieLength"), string] PCHAR Cookie;
	[size_is("ReferrerLength"), string] PCHAR Referrer;
	USHORT ServerPort;
	USHORT ProtocolStatus;
	ULONG Win32Status;
	HTTP_VERB MethodNum;
	USHORT SubStatus;
} HTTP_LOG_FIELDS_DATA;
'!
!HTTP_LOG_FIELDS_DATA categoriesForClass!WinHttpServer-Structs! !
!HTTP_LOG_FIELDS_DATA methodsFor!

ClientIp
	"Answer the <String> value of the receiver's 'ClientIp' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_ClientIp) length: self ClientIpLength!

ClientIp: aString
	"Set the receiver's 'ClientIp' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_ClientIp put: aString yourAddress.
	self ClientIpLength: aString size!

ClientIpLength
	"Answer the <Integer> value of the receiver's 'ClientIpLength' field."

	^bytes wordAtOffset: _OffsetOf_ClientIpLength!

ClientIpLength: anInteger
	"Set the receiver's 'ClientIpLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ClientIpLength put: anInteger!

Cookie
	"Answer the <String> value of the receiver's 'Cookie' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Cookie) length: self CookieLength!

Cookie: aString
	"Set the receiver's 'Cookie' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_Cookie put: aString yourAddress.
	self CookieLength: aString size!

CookieLength
	"Answer the <Integer> value of the receiver's 'CookieLength' field."

	^bytes wordAtOffset: _OffsetOf_CookieLength!

CookieLength: anInteger
	"Set the receiver's 'CookieLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_CookieLength put: anInteger!

Host
	"Answer the <String> value of the receiver's 'Host' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Host) length: self HostLength!

Host: aString
	"Set the receiver's 'Host' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_Host put: aString yourAddress.
	self HostLength: aString size!

HostLength
	"Answer the <Integer> value of the receiver's 'HostLength' field."

	^bytes wordAtOffset: _OffsetOf_HostLength!

HostLength: anInteger
	"Set the receiver's 'HostLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_HostLength put: anInteger!

Method
	"Answer the <String> value of the receiver's 'Method' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Method) length: self MethodLength!

Method: aString
	"Set the receiver's 'Method' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_Method put: aString yourAddress.
	self MethodLength: aString size!

MethodLength
	"Answer the <Integer> value of the receiver's 'MethodLength' field."

	^bytes wordAtOffset: _OffsetOf_MethodLength!

MethodLength: anInteger
	"Set the receiver's 'MethodLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_MethodLength put: anInteger!

MethodNum
	"Answer the <Integer> value of the receiver's 'MethodNum' field."

	^bytes sdwordAtOffset: _OffsetOf_MethodNum!

MethodNum: anInteger
	"Set the receiver's 'MethodNum' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_MethodNum put: anInteger!

ProtocolStatus
	"Answer the <Integer> value of the receiver's 'ProtocolStatus' field."

	^bytes wordAtOffset: _OffsetOf_ProtocolStatus!

ProtocolStatus: anInteger
	"Set the receiver's 'ProtocolStatus' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ProtocolStatus put: anInteger!

Referrer
	"Answer the <String> value of the receiver's 'Referrer' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Referrer) length: self ReferrerLength!

Referrer: aString
	"Set the receiver's 'Referrer' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_Referrer put: aString yourAddress.
	self ReferrerLength: aString size!

ReferrerLength
	"Answer the <Integer> value of the receiver's 'ReferrerLength' field."

	^bytes wordAtOffset: _OffsetOf_ReferrerLength!

ReferrerLength: anInteger
	"Set the receiver's 'ReferrerLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ReferrerLength put: anInteger!

ServerIp
	"Answer the <String> value of the receiver's 'ServerIp' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_ServerIp) length: self ServerIpLength!

ServerIp: aString
	"Set the receiver's 'ServerIp' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_ServerIp put: aString yourAddress.
	self ServerIpLength: aString size!

ServerIpLength
	"Answer the <Integer> value of the receiver's 'ServerIpLength' field."

	^bytes wordAtOffset: _OffsetOf_ServerIpLength!

ServerIpLength: anInteger
	"Set the receiver's 'ServerIpLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ServerIpLength put: anInteger!

ServerName
	"Answer the <String> value of the receiver's 'ServerName' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_ServerName) length: self ServerNameLength!

ServerName: aString
	"Set the receiver's 'ServerName' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_ServerName put: aString yourAddress.
	self ServerNameLength: aString size!

ServerNameLength
	"Answer the <Integer> value of the receiver's 'ServerNameLength' field."

	^bytes wordAtOffset: _OffsetOf_ServerNameLength!

ServerNameLength: anInteger
	"Set the receiver's 'ServerNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ServerNameLength put: anInteger!

ServerPort
	"Answer the <Integer> value of the receiver's 'ServerPort' field."

	^bytes wordAtOffset: _OffsetOf_ServerPort!

ServerPort: anInteger
	"Set the receiver's 'ServerPort' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ServerPort put: anInteger!

ServiceName
	"Answer the <String> value of the receiver's 'ServiceName' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_ServiceName) length: self ServiceNameLength!

ServiceName: aString
	"Set the receiver's 'ServiceName' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_ServiceName put: aString yourAddress.
	self ServiceNameLength: aString size!

ServiceNameLength
	"Answer the <Integer> value of the receiver's 'ServiceNameLength' field."

	^bytes wordAtOffset: _OffsetOf_ServiceNameLength!

ServiceNameLength: anInteger
	"Set the receiver's 'ServiceNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ServiceNameLength put: anInteger!

SubStatus
	"Answer the <Integer> value of the receiver's 'SubStatus' field."

	^bytes wordAtOffset: _OffsetOf_SubStatus!

SubStatus: anInteger
	"Set the receiver's 'SubStatus' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_SubStatus put: anInteger!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes sdwordAtOffset: _OffsetOf_Type!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_Type put: anInteger!

UriQuery
	"Answer the <String> value of the receiver's 'UriQuery' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_UriQuery) length: self UriQueryLength!

UriQuery: aString
	"Set the receiver's 'UriQuery' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_UriQuery put: aString yourAddress.
	self UriQueryLength: aString size!

UriQueryLength
	"Answer the <Integer> value of the receiver's 'UriQueryLength' field."

	^bytes wordAtOffset: _OffsetOf_UriQueryLength!

UriQueryLength: anInteger
	"Set the receiver's 'UriQueryLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_UriQueryLength put: anInteger!

UriStem
	"Answer the <Utf16String> value of the receiver's 'UriStem' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_UriStem) length: self UriStemLength!

UriStem: anUtf16String
	"Set the receiver's 'UriStem' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_UriStem put: anUtf16String yourAddress.
	self UriStemLength: anUtf16String size!

UriStemLength
	"Answer the <Integer> value of the receiver's 'UriStemLength' field."

	^bytes wordAtOffset: _OffsetOf_UriStemLength!

UriStemLength: anInteger
	"Set the receiver's 'UriStemLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_UriStemLength put: anInteger!

UserAgent
	"Answer the <String> value of the receiver's 'UserAgent' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_UserAgent) length: self UserAgentLength!

UserAgent: aString
	"Set the receiver's 'UserAgent' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_UserAgent put: aString yourAddress.
	self UserAgentLength: aString size!

UserAgentLength
	"Answer the <Integer> value of the receiver's 'UserAgentLength' field."

	^bytes wordAtOffset: _OffsetOf_UserAgentLength!

UserAgentLength: anInteger
	"Set the receiver's 'UserAgentLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_UserAgentLength put: anInteger!

UserName
	"Answer the <Utf16String> value of the receiver's 'UserName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_UserName) length: self UserNameLength!

UserName: anUtf16String
	"Set the receiver's 'UserName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_UserName put: anUtf16String yourAddress.
	self UserNameLength: anUtf16String size!

UserNameLength
	"Answer the <Integer> value of the receiver's 'UserNameLength' field."

	^bytes wordAtOffset: _OffsetOf_UserNameLength!

UserNameLength: anInteger
	"Set the receiver's 'UserNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_UserNameLength put: anInteger!

Win32Status
	"Answer the <Integer> value of the receiver's 'Win32Status' field."

	^bytes dwordAtOffset: _OffsetOf_Win32Status!

Win32Status: anInteger
	"Set the receiver's 'Win32Status' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Win32Status put: anInteger! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ClientIp!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ClientIp:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ClientIpLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ClientIpLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Cookie!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Cookie:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #CookieLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #CookieLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Host!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Host:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #HostLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #HostLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Method!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Method:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #MethodLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #MethodLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #MethodNum!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #MethodNum:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ProtocolStatus!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ProtocolStatus:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Referrer!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Referrer:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ReferrerLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ReferrerLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerIp!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerIp:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerIpLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerIpLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerName!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerName:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerNameLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerNameLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerPort!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServerPort:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServiceName!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServiceName:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServiceNameLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #ServiceNameLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #SubStatus!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #SubStatus:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Type!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Type:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriQuery!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriQuery:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriQueryLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriQueryLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriStem!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriStem:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriStemLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UriStemLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserAgent!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserAgent:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserAgentLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserAgentLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserName!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserName:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserNameLength!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #UserNameLength:!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Win32Status!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Win32Status:!**compiled accessors**!public! !

!HTTP_LOG_FIELDS_DATA class methodsFor!

defineFields
	"Define the fields of the HTTP_LOG_FIELDS_DATA structure.

	HTTP_LOG_FIELDS_DATA compileDefinition

		typedef [uuid(35c62b99-abf3-46f3-b967-7b54dc2641cc), helpstring('Current log fields data structure for of type HttpLogDataTypeFields.')]
		struct tagHTTP_LOG_FIELDS_DATA {
			HTTP_LOG_DATA_TYPE Type;
			USHORT UserNameLength;
			USHORT UriStemLength;
			USHORT ClientIpLength;
			USHORT ServerNameLength;
			USHORT ServiceNameLength;
			USHORT ServerIpLength;
			USHORT MethodLength;
			USHORT UriQueryLength;
			USHORT HostLength;
			USHORT UserAgentLength;
			USHORT CookieLength;
			USHORT ReferrerLength;
			[size_is('UserNameLength'), string] PWCHAR UserName;
			[size_is('UriStemLength'), string] PWCHAR UriStem;
			[size_is('ClientIpLength'), string] PCHAR ClientIp;
			[size_is('ServerNameLength'), string] PCHAR ServerName;
			[size_is('ServiceNameLength'), string] PCHAR ServiceName;
			[size_is('ServerIpLength'), string] PCHAR ServerIp;
			[size_is('MethodLength'), string] PCHAR Method;
			[size_is('UriQueryLength'), string] PCHAR UriQuery;
			[size_is('HostLength'), string] PCHAR Host;
			[size_is('UserAgentLength'), string] PCHAR UserAgent;
			[size_is('CookieLength'), string] PCHAR Cookie;
			[size_is('ReferrerLength'), string] PCHAR Referrer;
			USHORT ServerPort;
			USHORT ProtocolStatus;
			ULONG Win32Status;
			HTTP_VERB MethodNum;
			USHORT SubStatus;
		} HTTP_LOG_FIELDS_DATA;
"

	self
		defineField: #Type type: SDWORDField new offset: 0;
		defineField: #UserNameLength type: WORDField new offset: 4;
		defineField: #UriStemLength type: WORDField new offset: 6;
		defineField: #ClientIpLength type: WORDField new offset: 8;
		defineField: #ServerNameLength type: WORDField new offset: 10;
		defineField: #ServiceNameLength type: WORDField new offset: 12;
		defineField: #ServerIpLength type: WORDField new offset: 14;
		defineField: #MethodLength type: WORDField new offset: 16;
		defineField: #UriQueryLength type: WORDField new offset: 18;
		defineField: #HostLength type: WORDField new offset: 20;
		defineField: #UserAgentLength type: WORDField new offset: 22;
		defineField: #CookieLength type: WORDField new offset: 24;
		defineField: #ReferrerLength type: WORDField new offset: 26;
		defineField: #UserName type: (ArrayPointerField type: Utf16String lengthField: #UserNameLength) offset: 28;
		defineField: #UriStem type: (ArrayPointerField type: Utf16String lengthField: #UriStemLength) offset: 32;
		defineField: #ClientIp type: (ArrayPointerField type: String lengthField: #ClientIpLength) offset: 36;
		defineField: #ServerName type: (ArrayPointerField type: String lengthField: #ServerNameLength) offset: 40;
		defineField: #ServiceName type: (ArrayPointerField type: String lengthField: #ServiceNameLength) offset: 44;
		defineField: #ServerIp type: (ArrayPointerField type: String lengthField: #ServerIpLength) offset: 48;
		defineField: #Method type: (ArrayPointerField type: String lengthField: #MethodLength) offset: 52;
		defineField: #UriQuery type: (ArrayPointerField type: String lengthField: #UriQueryLength) offset: 56;
		defineField: #Host type: (ArrayPointerField type: String lengthField: #HostLength) offset: 60;
		defineField: #UserAgent type: (ArrayPointerField type: String lengthField: #UserAgentLength) offset: 64;
		defineField: #Cookie type: (ArrayPointerField type: String lengthField: #CookieLength) offset: 68;
		defineField: #Referrer type: (ArrayPointerField type: String lengthField: #ReferrerLength) offset: 72;
		defineField: #ServerPort type: WORDField new offset: 76;
		defineField: #ProtocolStatus type: WORDField new offset: 78;
		defineField: #Win32Status type: DWORDField new offset: 80;
		defineField: #MethodNum type: SDWORDField new offset: 84;
		defineField: #SubStatus type: WORDField new offset: 88.
	self byteSize: 92!

getFieldNames
	^#(#Type #UserNameLength #UriStemLength #ClientIpLength #ServerNameLength #ServiceNameLength #ServerIpLength #MethodLength #UriQueryLength #HostLength #UserAgentLength #CookieLength #ReferrerLength #UserName #UriStem #ClientIp #ServerName #ServiceName #ServerIp #Method #UriQuery #Host #UserAgent #Cookie #Referrer #ServerPort #ProtocolStatus #Win32Status #MethodNum #SubStatus)! !
!HTTP_LOG_FIELDS_DATA class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_LOG_FIELDS_DATA class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

