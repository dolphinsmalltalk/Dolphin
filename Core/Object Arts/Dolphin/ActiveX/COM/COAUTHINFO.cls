"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #COAUTHINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwAuthnLevel _OffsetOf_dwAuthnSvc _OffsetOf_dwAuthzSvc _OffsetOf_dwCapabilities _OffsetOf_dwImpersonationLevel _OffsetOf_pAuthIdentityData _OffsetOf_pwszServerPrincName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

COAUTHINFO guid: (GUID fromString: '{27d02683-c29f-450c-a25f-3186b62d47f2}')!

COAUTHINFO addClassConstant: '_OffsetOf_dwAuthnLevel' value: 16rC!
COAUTHINFO addClassConstant: '_OffsetOf_dwAuthnSvc' value: 16r0!
COAUTHINFO addClassConstant: '_OffsetOf_dwAuthzSvc' value: 16r4!
COAUTHINFO addClassConstant: '_OffsetOf_dwCapabilities' value: 16r18!
COAUTHINFO addClassConstant: '_OffsetOf_dwImpersonationLevel' value: 16r10!
COAUTHINFO addClassConstant: '_OffsetOf_pAuthIdentityData' value: 16r14!
COAUTHINFO addClassConstant: '_OffsetOf_pwszServerPrincName' value: 16r8!

COAUTHINFO comment: '<COAUTHINFO> is an <ExternalStructure> class to wrap the struct ''OBJIDL.COAUTHINFO'' from type information in the ''ObjIDL Library'' library.

The COAUTHINFO structure specifies the authentication settings used while making a remote activation request from a client machine to a server machine.'!

!COAUTHINFO categoriesForClass!OBJIDL-Structs! !

!COAUTHINFO methodsFor!

dwAuthnLevel
	"Answer the <Integer> value of the receiver's 'dwAuthnLevel' field."

	^bytes dwordAtOffset: _OffsetOf_dwAuthnLevel!

dwAuthnLevel: anInteger
	"Set the receiver's 'dwAuthnLevel' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwAuthnLevel put: anInteger!

dwAuthnSvc
	"Answer the <Integer> value of the receiver's 'dwAuthnSvc' field."

	^bytes dwordAtOffset: _OffsetOf_dwAuthnSvc!

dwAuthnSvc: anInteger
	"Set the receiver's 'dwAuthnSvc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwAuthnSvc put: anInteger!

dwAuthzSvc
	"Answer the <Integer> value of the receiver's 'dwAuthzSvc' field."

	^bytes dwordAtOffset: _OffsetOf_dwAuthzSvc!

dwAuthzSvc: anInteger
	"Set the receiver's 'dwAuthzSvc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwAuthzSvc put: anInteger!

dwCapabilities
	"Answer the <Integer> value of the receiver's 'dwCapabilities' field."

	^bytes dwordAtOffset: _OffsetOf_dwCapabilities!

dwCapabilities: anInteger
	"Set the receiver's 'dwCapabilities' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwCapabilities put: anInteger!

dwImpersonationLevel
	"Answer the <Integer> value of the receiver's 'dwImpersonationLevel' field."

	^bytes dwordAtOffset: _OffsetOf_dwImpersonationLevel!

dwImpersonationLevel: anInteger
	"Set the receiver's 'dwImpersonationLevel' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwImpersonationLevel put: anInteger!

pAuthIdentityData
	"Answer the <COAUTHIDENTITY> value of the receiver's 'pAuthIdentityData' field."

	^COAUTHIDENTITY fromAddress: (bytes intPtrAtOffset: _OffsetOf_pAuthIdentityData)!

pAuthIdentityData: aCOAUTHIDENTITY
	"Set the receiver's 'pAuthIdentityData' field to the value of the argument, aCOAUTHIDENTITY"

	bytes uintPtrAtOffset: _OffsetOf_pAuthIdentityData put: aCOAUTHIDENTITY yourAddress!

pwszServerPrincName
	"Answer the <Utf16String> value of the receiver's 'pwszServerPrincName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwszServerPrincName)!

pwszServerPrincName: anUtf16String
	"Set the receiver's 'pwszServerPrincName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwszServerPrincName put: anUtf16String yourAddress! !

!COAUTHINFO categoriesForMethods!
dwAuthnLevel!**compiled accessors**!public! !
dwAuthnLevel:!**compiled accessors**!public! !
dwAuthnSvc!**compiled accessors**!public! !
dwAuthnSvc:!**compiled accessors**!public! !
dwAuthzSvc!**compiled accessors**!public! !
dwAuthzSvc:!**compiled accessors**!public! !
dwCapabilities!**compiled accessors**!public! !
dwCapabilities:!**compiled accessors**!public! !
dwImpersonationLevel!**compiled accessors**!public! !
dwImpersonationLevel:!**compiled accessors**!public! !
pAuthIdentityData!**compiled accessors**!public! !
pAuthIdentityData:!**compiled accessors**!public! !
pwszServerPrincName!**compiled accessors**!public! !
pwszServerPrincName:!**compiled accessors**!public! !
!

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
		defineField: #pwszServerPrincName type: (PointerField type: Utf16String);
		defineField: #dwAuthnLevel type: DWORDField new;
		defineField: #dwImpersonationLevel type: DWORDField new;
		defineField: #pAuthIdentityData type: (PointerField type: COAUTHIDENTITY);
		defineField: #dwCapabilities type: DWORDField new!

getFieldNames
	^#(#dwAuthnSvc #dwAuthzSvc #pwszServerPrincName #dwAuthnLevel #dwImpersonationLevel #pAuthIdentityData #dwCapabilities)! !

!COAUTHINFO class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

