"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_LOG_FIELDS_DATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ClientIp))
		length: self ClientIpLength!

ClientIp: aString
	"Set the receiver's 'ClientIp' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #ClientIp) put: aString yourAddress.
	self ClientIpLength: aString size!

ClientIpLength
	"Answer the <Integer> value of the receiver's 'ClientIpLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #ClientIpLength)!

ClientIpLength: anInteger
	"Set the receiver's 'ClientIpLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ClientIpLength) put: anInteger!

Cookie
	"Answer the <String> value of the receiver's 'Cookie' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Cookie)) length: self CookieLength!

Cookie: aString
	"Set the receiver's 'Cookie' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #Cookie) put: aString yourAddress.
	self CookieLength: aString size!

CookieLength
	"Answer the <Integer> value of the receiver's 'CookieLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #CookieLength)!

CookieLength: anInteger
	"Set the receiver's 'CookieLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #CookieLength) put: anInteger!

Host
	"Answer the <String> value of the receiver's 'Host' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Host)) length: self HostLength!

Host: aString
	"Set the receiver's 'Host' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #Host) put: aString yourAddress.
	self HostLength: aString size!

HostLength
	"Answer the <Integer> value of the receiver's 'HostLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #HostLength)!

HostLength: anInteger
	"Set the receiver's 'HostLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #HostLength) put: anInteger!

Method
	"Answer the <String> value of the receiver's 'Method' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Method)) length: self MethodLength!

Method: aString
	"Set the receiver's 'Method' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #Method) put: aString yourAddress.
	self MethodLength: aString size!

MethodLength
	"Answer the <Integer> value of the receiver's 'MethodLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #MethodLength)!

MethodLength: anInteger
	"Set the receiver's 'MethodLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #MethodLength) put: anInteger!

MethodNum
	"Answer the <Integer> value of the receiver's 'MethodNum' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #MethodNum)!

MethodNum: anInteger
	"Set the receiver's 'MethodNum' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #MethodNum) put: anInteger!

ProtocolStatus
	"Answer the <Integer> value of the receiver's 'ProtocolStatus' field."

	^bytes wordAtOffset: ##(self offsetOf: #ProtocolStatus)!

ProtocolStatus: anInteger
	"Set the receiver's 'ProtocolStatus' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ProtocolStatus) put: anInteger!

Referrer
	"Answer the <String> value of the receiver's 'Referrer' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Referrer))
		length: self ReferrerLength!

Referrer: aString
	"Set the receiver's 'Referrer' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #Referrer) put: aString yourAddress.
	self ReferrerLength: aString size!

ReferrerLength
	"Answer the <Integer> value of the receiver's 'ReferrerLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #ReferrerLength)!

ReferrerLength: anInteger
	"Set the receiver's 'ReferrerLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ReferrerLength) put: anInteger!

ServerIp
	"Answer the <String> value of the receiver's 'ServerIp' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ServerIp))
		length: self ServerIpLength!

ServerIp: aString
	"Set the receiver's 'ServerIp' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #ServerIp) put: aString yourAddress.
	self ServerIpLength: aString size!

ServerIpLength
	"Answer the <Integer> value of the receiver's 'ServerIpLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #ServerIpLength)!

ServerIpLength: anInteger
	"Set the receiver's 'ServerIpLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ServerIpLength) put: anInteger!

ServerName
	"Answer the <String> value of the receiver's 'ServerName' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ServerName))
		length: self ServerNameLength!

ServerName: aString
	"Set the receiver's 'ServerName' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #ServerName) put: aString yourAddress.
	self ServerNameLength: aString size!

ServerNameLength
	"Answer the <Integer> value of the receiver's 'ServerNameLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #ServerNameLength)!

ServerNameLength: anInteger
	"Set the receiver's 'ServerNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ServerNameLength) put: anInteger!

ServerPort
	"Answer the <Integer> value of the receiver's 'ServerPort' field."

	^bytes wordAtOffset: ##(self offsetOf: #ServerPort)!

ServerPort: anInteger
	"Set the receiver's 'ServerPort' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ServerPort) put: anInteger!

ServiceName
	"Answer the <String> value of the receiver's 'ServiceName' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ServiceName))
		length: self ServiceNameLength!

ServiceName: aString
	"Set the receiver's 'ServiceName' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #ServiceName) put: aString yourAddress.
	self ServiceNameLength: aString size!

ServiceNameLength
	"Answer the <Integer> value of the receiver's 'ServiceNameLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #ServiceNameLength)!

ServiceNameLength: anInteger
	"Set the receiver's 'ServiceNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #ServiceNameLength) put: anInteger!

SubStatus
	"Answer the <Integer> value of the receiver's 'SubStatus' field."

	^bytes wordAtOffset: ##(self offsetOf: #SubStatus)!

SubStatus: anInteger
	"Set the receiver's 'SubStatus' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #SubStatus) put: anInteger!

Type
	"Answer the <Integer> value of the receiver's 'Type' field."

	^bytes sdwordAtOffset: 0!

Type: anInteger
	"Set the receiver's 'Type' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

UriQuery
	"Answer the <String> value of the receiver's 'UriQuery' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UriQuery))
		length: self UriQueryLength!

UriQuery: aString
	"Set the receiver's 'UriQuery' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #UriQuery) put: aString yourAddress.
	self UriQueryLength: aString size!

UriQueryLength
	"Answer the <Integer> value of the receiver's 'UriQueryLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #UriQueryLength)!

UriQueryLength: anInteger
	"Set the receiver's 'UriQueryLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #UriQueryLength) put: anInteger!

UriStem
	"Answer the <Utf16String> value of the receiver's 'UriStem' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UriStem))
		length: self UriStemLength!

UriStem: anUtf16String
	"Set the receiver's 'UriStem' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #UriStem) put: anUtf16String yourAddress.
	self UriStemLength: anUtf16String size!

UriStemLength
	"Answer the <Integer> value of the receiver's 'UriStemLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #UriStemLength)!

UriStemLength: anInteger
	"Set the receiver's 'UriStemLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #UriStemLength) put: anInteger!

UserAgent
	"Answer the <String> value of the receiver's 'UserAgent' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UserAgent))
		length: self UserAgentLength!

UserAgent: aString
	"Set the receiver's 'UserAgent' field to the value of the argument, aString"

	bytes uintPtrAtOffset: ##(self offsetOf: #UserAgent) put: aString yourAddress.
	self UserAgentLength: aString size!

UserAgentLength
	"Answer the <Integer> value of the receiver's 'UserAgentLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #UserAgentLength)!

UserAgentLength: anInteger
	"Set the receiver's 'UserAgentLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #UserAgentLength) put: anInteger!

UserName
	"Answer the <Utf16String> value of the receiver's 'UserName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UserName))
		length: self UserNameLength!

UserName: anUtf16String
	"Set the receiver's 'UserName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #UserName) put: anUtf16String yourAddress.
	self UserNameLength: anUtf16String size!

UserNameLength
	"Answer the <Integer> value of the receiver's 'UserNameLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #UserNameLength)!

UserNameLength: anInteger
	"Set the receiver's 'UserNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #UserNameLength) put: anInteger!

Win32Status
	"Answer the <Integer> value of the receiver's 'Win32Status' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Win32Status)!

Win32Status: anInteger
	"Set the receiver's 'Win32Status' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Win32Status) put: anInteger! !
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
	self byteSize: 92! !
!HTTP_LOG_FIELDS_DATA class categoriesFor: #defineFields!**auto generated**!initializing!public! !

