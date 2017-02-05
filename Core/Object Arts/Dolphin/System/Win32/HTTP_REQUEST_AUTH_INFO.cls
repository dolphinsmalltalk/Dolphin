"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_REQUEST_AUTH_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST_AUTH_INFO guid: (GUID fromString: '{E0696C2E-1353-45E2-BDCC-A52B6142B827}')!
HTTP_REQUEST_AUTH_INFO comment: '<HTTP_REQUEST_AUTH_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_AUTH_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Authentication request info structure"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(E0696C2E-1353-45E2-BDCC-A52B6142B827), helpstring("Authentication request info structure")]
struct tagHTTP_REQUEST_AUTH_INFO {
	HTTP_AUTH_STATUS AuthStatus;
	long SecStatus;
	unsigned long flags;
	HTTP_REQUEST_AUTH_TYPE AuthType;
	HANDLE AccessToken;
	unsigned long ContextAttributes;
	[helpstring("Optional serialized context.")] unsigned long PackedContextLength;
	unsigned long PackedContextType;
	void* PackedContext;
	[helpstring("Optional mutual authentication data and its length in bytes.")] unsigned long MutualAuthDataLength;
	CHAR* pMutualAuthData;
	[helpstring("For SSPI based schemes the package name is returned. Length does not include the terminating null and it is in bytes.")] unsigned short PackageNameLength;
	LPWSTR pPackageName;
} HTTP_REQUEST_AUTH_INFO;
'!
!HTTP_REQUEST_AUTH_INFO categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_AUTH_INFO methodsFor!

AccessToken
	"Answer the receiver's AccessToken field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #AccessToken)) asExternalHandle!

AccessToken: anObject
	"Set the receiver's AccessToken field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #AccessToken) put: anObject!

AuthStatus
	"Answer the receiver's AuthStatus field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

AuthStatus: anObject
	"Set the receiver's AuthStatus field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

AuthType
	"Answer the receiver's AuthType field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #AuthType)!

AuthType: anObject
	"Set the receiver's AuthType field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #AuthType) put: anObject!

ContextAttributes
	"Answer the receiver's ContextAttributes field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ContextAttributes)!

ContextAttributes: anObject
	"Set the receiver's ContextAttributes field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ContextAttributes) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

MutualAuthDataLength
	"Answer the receiver's MutualAuthDataLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #MutualAuthDataLength)!

MutualAuthDataLength: anObject
	"Set the receiver's MutualAuthDataLength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #MutualAuthDataLength) put: anObject!

PackageNameLength
	"Answer the receiver's PackageNameLength field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #PackageNameLength)!

PackageNameLength: anObject
	"Set the receiver's PackageNameLength field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #PackageNameLength) put: anObject!

PackedContext
	"Answer the receiver's PackedContext field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #PackedContext)) asExternalAddress!

PackedContext: anObject
	"Set the receiver's PackedContext field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #PackedContext) put: anObject!

PackedContextLength
	"Answer the receiver's PackedContextLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #PackedContextLength)!

PackedContextLength: anObject
	"Set the receiver's PackedContextLength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #PackedContextLength) put: anObject!

PackedContextType
	"Answer the receiver's PackedContextType field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #PackedContextType)!

PackedContextType: anObject
	"Set the receiver's PackedContextType field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #PackedContextType) put: anObject!

pMutualAuthData
	"Answer the receiver's pMutualAuthData field as a Smalltalk object."

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pMutualAuthData))!

pMutualAuthData: anObject
	"Set the receiver's pMutualAuthData field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pMutualAuthData) put: anObject yourAddress!

pPackageName
	"Answer the receiver's pPackageName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pPackageName))!

pPackageName: anObject
	"Set the receiver's pPackageName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pPackageName) put: anObject yourAddress!

SecStatus
	"Answer the receiver's SecStatus field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #SecStatus)!

SecStatus: anObject
	"Set the receiver's SecStatus field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #SecStatus) put: anObject! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #AccessToken!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #AccessToken:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthStatus!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthStatus:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthType!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthType:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #ContextAttributes!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #ContextAttributes:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #MutualAuthDataLength!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #MutualAuthDataLength:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackageNameLength!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackageNameLength:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContext!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContext:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextLength!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextLength:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextType!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextType:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #pMutualAuthData!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #pMutualAuthData:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #pPackageName!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #pPackageName:!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #SecStatus!**compiled accessors**!public! !
!HTTP_REQUEST_AUTH_INFO categoriesFor: #SecStatus:!**compiled accessors**!public! !

!HTTP_REQUEST_AUTH_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_AUTH_INFO structure.

	HTTP_REQUEST_AUTH_INFO  compileDefinition

		typedef [uuid(E0696C2E-1353-45E2-BDCC-A52B6142B827), helpstring('Authentication request info structure')]
		struct tagHTTP_REQUEST_AUTH_INFO {
			HTTP_AUTH_STATUS AuthStatus;
			long SecStatus;
			unsigned long flags;
			HTTP_REQUEST_AUTH_TYPE AuthType;
			HANDLE AccessToken;
			unsigned long ContextAttributes;
			[helpstring('Optional serialized context.')] unsigned long PackedContextLength;
			unsigned long PackedContextType;
			void* PackedContext;
			[helpstring('Optional mutual authentication data and its length in bytes.')] unsigned long MutualAuthDataLength;
			CHAR* pMutualAuthData;
			[helpstring('For SSPI based schemes the package name is returned. Length does not include the terminating null and it is in bytes.')] unsigned short PackageNameLength;
			LPWSTR pPackageName;
		} HTTP_REQUEST_AUTH_INFO;
"

	self
		defineField: #AuthStatus type: SDWORDField new offset: 0;
		defineField: #SecStatus type: SDWORDField new offset: 4;
		defineField: #flags type: DWORDField new offset: 8;
		defineField: #AuthType type: SDWORDField new offset: 12;
		defineField: #AccessToken type: HANDLEField new offset: 16;
		defineField: #ContextAttributes type: DWORDField new offset: 20;
		defineField: #PackedContextLength type: DWORDField new offset: 24;
		defineField: #PackedContextType type: DWORDField new offset: 28;
		defineField: #PackedContext type: LPVOIDField new offset: 32;
		defineField: #MutualAuthDataLength type: DWORDField new offset: 36;
		defineField: #pMutualAuthData type: (PointerField type: SBYTE) offset: 40;
		defineField: #PackageNameLength type: WORDField new offset: 44;
		defineField: #pPackageName type: (PointerField type: UnicodeString) offset: 48.
	self byteSize: 52! !
!HTTP_REQUEST_AUTH_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

