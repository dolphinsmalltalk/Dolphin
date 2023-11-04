"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.COAUTHINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_COAUTHINFO_Size' -> 16r1C.
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

	^bytes uint32AtOffset: _OffsetOf_dwAuthnLevel!

dwAuthnLevel: anInteger
	"Set the receiver's 'dwAuthnLevel' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwAuthnLevel put: anInteger!

dwAuthnSvc
	"Answer the <Integer> value of the receiver's 'dwAuthnSvc' field."

	^bytes uint32AtOffset: _OffsetOf_dwAuthnSvc!

dwAuthnSvc: anInteger
	"Set the receiver's 'dwAuthnSvc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwAuthnSvc put: anInteger!

dwAuthzSvc
	"Answer the <Integer> value of the receiver's 'dwAuthzSvc' field."

	^bytes uint32AtOffset: _OffsetOf_dwAuthzSvc!

dwAuthzSvc: anInteger
	"Set the receiver's 'dwAuthzSvc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwAuthzSvc put: anInteger!

dwCapabilities
	"Answer the <Integer> value of the receiver's 'dwCapabilities' field."

	^bytes uint32AtOffset: _OffsetOf_dwCapabilities!

dwCapabilities: anInteger
	"Set the receiver's 'dwCapabilities' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwCapabilities put: anInteger!

dwImpersonationLevel
	"Answer the <Integer> value of the receiver's 'dwImpersonationLevel' field."

	^bytes uint32AtOffset: _OffsetOf_dwImpersonationLevel!

dwImpersonationLevel: anInteger
	"Set the receiver's 'dwImpersonationLevel' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwImpersonationLevel put: anInteger!

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
!OS.COM.COAUTHINFO categoriesForMethods!
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

!OS.COM.COAUTHINFO class methodsFor!

byteSize
	^_COAUTHINFO_Size!

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
		defineField: #dwAuthnSvc type: UInt32Field new;
		defineField: #dwAuthzSvc type: UInt32Field new;
		defineField: #pwszServerPrincName type: (PointerField type: Utf16String);
		defineField: #dwAuthnLevel type: UInt32Field new;
		defineField: #dwImpersonationLevel type: UInt32Field new;
		defineField: #pAuthIdentityData type: (PointerField type: COAUTHIDENTITY);
		defineField: #dwCapabilities type: UInt32Field new!

getFieldNames
	^#(#dwAuthnSvc #dwAuthzSvc #pwszServerPrincName #dwAuthnLevel #dwImpersonationLevel #pAuthIdentityData #dwCapabilities)! !
!OS.COM.COAUTHINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

