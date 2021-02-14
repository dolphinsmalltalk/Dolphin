"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.COAUTHINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwAuthnLevel' -> 16rC.
		'_OffsetOf_dwAuthnSvc' -> 16r0.
		'_OffsetOf_dwAuthzSvc' -> 16r4.
		'_OffsetOf_dwCapabilities' -> 16r18.
		'_OffsetOf_dwImpersonationLevel' -> 16r10.
		'_OffsetOf_pAuthIdentityData' -> 16r14.
		'_OffsetOf_pwszServerPrincName' -> 16r8
	}!
OS.COM.COAUTHINFO guid: (Core.GUID fromString: '{27d02683-c29f-450c-a25f-3186b62d47f2}')!
OS.COM.COAUTHINFO comment: '`OS.COM.COAUTHINFO` is an <External.Structure> class to wrap the struct ''OBJIDL.COAUTHINFO'' from type information in the ''ObjIDL Library'' library.

The COAUTHINFO structure specifies the authentication settings used while making a remote activation request from a client machine to a server machine.'!
!OS.COM.COAUTHINFO categoriesForClass!OBJIDL-Structs! !
!OS.COM.COAUTHINFO methodsFor!

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
!OS.COM.COAUTHINFO categoriesFor: #dwAuthnLevel!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwAuthnLevel:!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwAuthnSvc!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwAuthnSvc:!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwAuthzSvc!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwAuthzSvc:!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwCapabilities!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwCapabilities:!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwImpersonationLevel!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #dwImpersonationLevel:!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #pAuthIdentityData!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #pAuthIdentityData:!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #pwszServerPrincName!**compiled accessors**!public! !
!OS.COM.COAUTHINFO categoriesFor: #pwszServerPrincName:!**compiled accessors**!public! !

!OS.COM.COAUTHINFO class methodsFor!

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
!OS.COM.COAUTHINFO class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.COM.COAUTHINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

