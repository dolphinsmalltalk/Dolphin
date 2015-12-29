"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #COAUTHINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COAUTHINFO guid: (GUID fromString: '{27D02683-C29F-450C-A25F-3186B62D47F2}')!
COAUTHINFO comment: '<COAUTHINFO> is an <ExternalStructure> class to wrap the struct ''OBJIDL.COAUTHINFO'' from type information in the ''ObjIDL Library'' library.

The COAUTHINFO structure specifies the authentication settings used while making a remote activation request from a client machine to a server machine.'!
!COAUTHINFO categoriesForClass!OBJIDL-Structs! !
!COAUTHINFO methodsFor!

dwAuthnLevel
	"Answer the receiver's dwAuthnLevel field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwAuthnLevel)!

dwAuthnLevel: anObject 
	"Set the receiver's dwAuthnLevel field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwAuthnLevel) put: anObject!

dwAuthnSvc
	"Answer the receiver's dwAuthnSvc field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

dwAuthnSvc: anObject 
	"Set the receiver's dwAuthnSvc field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dwAuthzSvc
	"Answer the receiver's dwAuthzSvc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwAuthzSvc)!

dwAuthzSvc: anObject 
	"Set the receiver's dwAuthzSvc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwAuthzSvc) put: anObject!

dwCapabilities
	"Answer the receiver's dwCapabilities field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwCapabilities)!

dwCapabilities: anObject 
	"Set the receiver's dwCapabilities field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwCapabilities) put: anObject!

dwImpersonationLevel
	"Answer the receiver's dwImpersonationLevel field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwImpersonationLevel)!

dwImpersonationLevel: anObject 
	"Set the receiver's dwImpersonationLevel field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwImpersonationLevel) put: anObject!

pAuthIdentityData
	"Answer the receiver's pAuthIdentityData field as a Smalltalk object."

	^COAUTHIDENTITY fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pAuthIdentityData))!

pAuthIdentityData: anObject 
	"Set the receiver's pAuthIdentityData field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pAuthIdentityData) put: anObject yourAddress!

pwszServerPrincName
	"Answer the receiver's pwszServerPrincName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pwszServerPrincName))!

pwszServerPrincName: anObject 
	"Set the receiver's pwszServerPrincName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pwszServerPrincName) put: anObject yourAddress! !
!COAUTHINFO categoriesFor: #dwAuthnLevel!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwAuthnLevel:!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwAuthnSvc!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwAuthnSvc:!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwAuthzSvc!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwAuthzSvc:!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwCapabilities!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwCapabilities:!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwImpersonationLevel!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #dwImpersonationLevel:!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #pAuthIdentityData!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #pAuthIdentityData:!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #pwszServerPrincName!**compiled accessors**!public! !
!COAUTHINFO categoriesFor: #pwszServerPrincName:!**compiled accessors**!public! !

!COAUTHINFO class methodsFor!

defineFields
	"Define the fields of the COAUTHINFO structure.
		COAUTHINFO compileDefinition
	
		typedef 		struct tagCOAUTHINFO {
			unsigned long dwAuthnSvc;
			unsigned long dwAuthzSvc;
			LPWSTR pwszServerPrincName;
			unsigned long dwAuthnLevel;
			unsigned long dwImpersonationLevel;
			COAUTHIDENTITY* pAuthIdentityData;
			unsigned long dwCapabilities;
		} COAUTHINFO;

	"

	self
		defineField: #dwAuthnSvc type: DWORDField new;
		defineField: #dwAuthzSvc type: DWORDField new;
		defineField: #pwszServerPrincName type: (PointerField type: UnicodeString);
		defineField: #dwAuthnLevel type: DWORDField new;
		defineField: #dwImpersonationLevel type: DWORDField new;
		defineField: #pAuthIdentityData type: (PointerField type: COAUTHIDENTITY);
		defineField: #dwCapabilities type: DWORDField new! !
!COAUTHINFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

