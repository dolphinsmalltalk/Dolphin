"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_LOG_FIELDS_DATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_LOG_FIELDS_DATA guid: (GUID fromString: '{35C62B99-ABF3-46F3-B967-7B54DC2641CC}')!
HTTP_LOG_FIELDS_DATA comment: '<HTTP_LOG_FIELDS_DATA> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_LOG_FIELDS_DATA'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Current log fields data structure for of type HttpLogDataTypeFields."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(35C62B99-ABF3-46F3-B967-7B54DC2641CC), helpstring("Current log fields data structure for of type HttpLogDataTypeFields.")]
struct tagHTTP_LOG_FIELDS_DATA {
	HTTP_LOG_DATA Base;
	unsigned short UserNameLength;
	unsigned short UriStemLength;
	unsigned short ClientIpLength;
	unsigned short ServerNameLength;
	unsigned short ServiceNameLength;
	unsigned short ServerIpLength;
	unsigned short MethodLength;
	unsigned short UriQueryLength;
	unsigned short HostLength;
	unsigned short UserAgentLength;
	unsigned short CookieLength;
	unsigned short ReferrerLength;
	unsigned short* UserName;
	unsigned short* UriStem;
	CHAR* ClientIp;
	CHAR* ServerName;
	CHAR* ServiceName;
	CHAR* ServerIp;
	CHAR* Method;
	CHAR* UriQuery;
	CHAR* Host;
	CHAR* UserAgent;
	CHAR* Cookie;
	CHAR* Referrer;
	unsigned short ServerPort;
	unsigned short ProtocolStatus;
	unsigned long Win32Status;
	HTTP_VERB MethodNum;
	unsigned short SubStatus;
} HTTP_LOG_FIELDS_DATA;
'!
!HTTP_LOG_FIELDS_DATA categoriesForClass!Win32-Structs! !
!HTTP_LOG_FIELDS_DATA methodsFor!

Base
	"Answer the receiver's Base field as a Smalltalk object."

	^HTTP_LOG_DATA fromAddress: bytes yourAddress!

Base: anObject
	"Set the receiver's Base field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: 1
		to: ##(HTTP_LOG_DATA basicByteSize)
		startingAt: 1!

ClientIp
	"Answer the receiver's ClientIp field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ClientIp))!

ClientIp: anObject
	"Set the receiver's ClientIp field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #ClientIp) put: anObject yourAddress!

ClientIpLength
	"Answer the receiver's ClientIpLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ClientIpLength)!

ClientIpLength: anObject
	"Set the receiver's ClientIpLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ClientIpLength) put: anObject!

Cookie
	"Answer the receiver's Cookie field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Cookie))!

Cookie: anObject
	"Set the receiver's Cookie field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Cookie) put: anObject yourAddress!

CookieLength
	"Answer the receiver's CookieLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #CookieLength)!

CookieLength: anObject
	"Set the receiver's CookieLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #CookieLength) put: anObject!

Host
	"Answer the receiver's Host field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Host))!

Host: anObject
	"Set the receiver's Host field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Host) put: anObject yourAddress!

HostLength
	"Answer the receiver's HostLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #HostLength)!

HostLength: anObject
	"Set the receiver's HostLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #HostLength) put: anObject!

Method
	"Answer the receiver's Method field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Method))!

Method: anObject
	"Set the receiver's Method field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Method) put: anObject yourAddress!

MethodLength
	"Answer the receiver's MethodLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #MethodLength)!

MethodLength: anObject
	"Set the receiver's MethodLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #MethodLength) put: anObject!

MethodNum
	"Answer the receiver's MethodNum field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #MethodNum)!

MethodNum: anObject
	"Set the receiver's MethodNum field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #MethodNum) put: anObject!

ProtocolStatus
	"Answer the receiver's ProtocolStatus field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ProtocolStatus)!

ProtocolStatus: anObject
	"Set the receiver's ProtocolStatus field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ProtocolStatus) put: anObject!

Referrer
	"Answer the receiver's Referrer field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Referrer))!

Referrer: anObject
	"Set the receiver's Referrer field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Referrer) put: anObject yourAddress!

ReferrerLength
	"Answer the receiver's ReferrerLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ReferrerLength)!

ReferrerLength: anObject
	"Set the receiver's ReferrerLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ReferrerLength) put: anObject!

ServerIp
	"Answer the receiver's ServerIp field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ServerIp))!

ServerIp: anObject
	"Set the receiver's ServerIp field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #ServerIp) put: anObject yourAddress!

ServerIpLength
	"Answer the receiver's ServerIpLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ServerIpLength)!

ServerIpLength: anObject
	"Set the receiver's ServerIpLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ServerIpLength) put: anObject!

ServerName
	"Answer the receiver's ServerName field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ServerName))!

ServerName: anObject
	"Set the receiver's ServerName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #ServerName) put: anObject yourAddress!

ServerNameLength
	"Answer the receiver's ServerNameLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ServerNameLength)!

ServerNameLength: anObject
	"Set the receiver's ServerNameLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ServerNameLength) put: anObject!

ServerPort
	"Answer the receiver's ServerPort field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ServerPort)!

ServerPort: anObject
	"Set the receiver's ServerPort field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ServerPort) put: anObject!

ServiceName
	"Answer the receiver's ServiceName field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #ServiceName))!

ServiceName: anObject
	"Set the receiver's ServiceName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #ServiceName) put: anObject yourAddress!

ServiceNameLength
	"Answer the receiver's ServiceNameLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ServiceNameLength)!

ServiceNameLength: anObject
	"Set the receiver's ServiceNameLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ServiceNameLength) put: anObject!

SubStatus
	"Answer the receiver's SubStatus field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #SubStatus)!

SubStatus: anObject
	"Set the receiver's SubStatus field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #SubStatus) put: anObject!

UriQuery
	"Answer the receiver's UriQuery field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UriQuery))!

UriQuery: anObject
	"Set the receiver's UriQuery field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #UriQuery) put: anObject yourAddress!

UriQueryLength
	"Answer the receiver's UriQueryLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #UriQueryLength)!

UriQueryLength: anObject
	"Set the receiver's UriQueryLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #UriQueryLength) put: anObject!

UriStem
	"Answer the receiver's UriStem field as a Smalltalk object."

	^WORD fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UriStem))!

UriStem: anObject
	"Set the receiver's UriStem field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #UriStem) put: anObject yourAddress!

UriStemLength
	"Answer the receiver's UriStemLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #UriStemLength)!

UriStemLength: anObject
	"Set the receiver's UriStemLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #UriStemLength) put: anObject!

UserAgent
	"Answer the receiver's UserAgent field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UserAgent))!

UserAgent: anObject
	"Set the receiver's UserAgent field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #UserAgent) put: anObject yourAddress!

UserAgentLength
	"Answer the receiver's UserAgentLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #UserAgentLength)!

UserAgentLength: anObject
	"Set the receiver's UserAgentLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #UserAgentLength) put: anObject!

UserName
	"Answer the receiver's UserName field as a Smalltalk object."

	^WORD fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #UserName))!

UserName: anObject
	"Set the receiver's UserName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #UserName) put: anObject yourAddress!

UserNameLength
	"Answer the receiver's UserNameLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #UserNameLength)!

UserNameLength: anObject
	"Set the receiver's UserNameLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #UserNameLength) put: anObject!

Win32Status
	"Answer the receiver's Win32Status field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Win32Status)!

Win32Status: anObject
	"Set the receiver's Win32Status field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Win32Status) put: anObject! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Base!**compiled accessors**!public! !
!HTTP_LOG_FIELDS_DATA categoriesFor: #Base:!**compiled accessors**!public! !
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

	HTTP_LOG_FIELDS_DATA  compileDefinition

		typedef [uuid(35C62B99-ABF3-46F3-B967-7B54DC2641CC), helpstring('Current log fields data structure for of type HttpLogDataTypeFields.')]
		struct tagHTTP_LOG_FIELDS_DATA {
			HTTP_LOG_DATA Base;
			unsigned short UserNameLength;
			unsigned short UriStemLength;
			unsigned short ClientIpLength;
			unsigned short ServerNameLength;
			unsigned short ServiceNameLength;
			unsigned short ServerIpLength;
			unsigned short MethodLength;
			unsigned short UriQueryLength;
			unsigned short HostLength;
			unsigned short UserAgentLength;
			unsigned short CookieLength;
			unsigned short ReferrerLength;
			unsigned short* UserName;
			unsigned short* UriStem;
			CHAR* ClientIp;
			CHAR* ServerName;
			CHAR* ServiceName;
			CHAR* ServerIp;
			CHAR* Method;
			CHAR* UriQuery;
			CHAR* Host;
			CHAR* UserAgent;
			CHAR* Cookie;
			CHAR* Referrer;
			unsigned short ServerPort;
			unsigned short ProtocolStatus;
			unsigned long Win32Status;
			HTTP_VERB MethodNum;
			unsigned short SubStatus;
		} HTTP_LOG_FIELDS_DATA;
"

	self
		defineField: #Base type: (StructureField type: HTTP_LOG_DATA) offset: 0;
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
		defineField: #UserName type: (PointerField type: WORD) offset: 28;
		defineField: #UriStem type: (PointerField type: WORD) offset: 32;
		defineField: #ClientIp type: (PointerField type: SBYTE) offset: 36;
		defineField: #ServerName type: (PointerField type: SBYTE) offset: 40;
		defineField: #ServiceName type: (PointerField type: SBYTE) offset: 44;
		defineField: #ServerIp type: (PointerField type: SBYTE) offset: 48;
		defineField: #Method type: (PointerField type: SBYTE) offset: 52;
		defineField: #UriQuery type: (PointerField type: SBYTE) offset: 56;
		defineField: #Host type: (PointerField type: SBYTE) offset: 60;
		defineField: #UserAgent type: (PointerField type: SBYTE) offset: 64;
		defineField: #Cookie type: (PointerField type: SBYTE) offset: 68;
		defineField: #Referrer type: (PointerField type: SBYTE) offset: 72;
		defineField: #ServerPort type: WORDField new offset: 76;
		defineField: #ProtocolStatus type: WORDField new offset: 78;
		defineField: #Win32Status type: DWORDField new offset: 80;
		defineField: #MethodNum type: SDWORDField new offset: 84;
		defineField: #SubStatus type: WORDField new offset: 88.
	self byteSize: 92! !
!HTTP_LOG_FIELDS_DATA class categoriesFor: #defineFields!**auto generated**!initializing!public! !

