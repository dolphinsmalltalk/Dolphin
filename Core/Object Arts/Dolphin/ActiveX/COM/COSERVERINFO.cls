"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #COSERVERINFO
	instanceVariableNames: 'hostName'
	classVariableNames: '_OffsetOf_dwReserved1 _OffsetOf_dwReserved2 _OffsetOf_pAuthInfo _OffsetOf_pwszName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COSERVERINFO guid: (GUID fromString: '{87b4c5b4-026e-11d3-9fd7-00a0cc3e4a32}')!
COSERVERINFO addClassConstant: '_OffsetOf_dwReserved1' value: 16r0!
COSERVERINFO addClassConstant: '_OffsetOf_dwReserved2' value: 16rC!
COSERVERINFO addClassConstant: '_OffsetOf_pAuthInfo' value: 16r8!
COSERVERINFO addClassConstant: '_OffsetOf_pwszName' value: 16r4!
COSERVERINFO comment: 'COSERVERINFO is an ExternalStructure class to represent the DCOM structure of the same name.

COSERVERINFO is used to explicitly identify a remote machine when instantiating COM objects (i.e. it is used in conjunction with CoCreateInstanceEx)..

The only relevant member at present is #pwszName, which would usually be a UNC or DNS name, or a numeric IP address.'!
!COSERVERINFO categoriesForClass!External-Data-Structured-COM! !
!COSERVERINFO methodsFor!

hostName
	"Answer the <String> value of the receiver's member variable pwszName."

	^self pwszName asString!

hostName: aString
	"Set the value of the receiver's pwszName member to the Unicode
	representation of the argument, aString. The Unicode String is stored
	into an inst. var. to prevent it from being GC'd."

	hostName := aString asUtf16String.
	self pwszName: hostName!

pAuthInfo
	"Answer the <COAUTHINFO> value of the receiver's 'pAuthInfo' field."

	^COAUTHINFO fromAddress: (bytes intPtrAtOffset: _OffsetOf_pAuthInfo)!

pAuthInfo: aCOAUTHINFO
	"Set the receiver's 'pAuthInfo' field to the value of the argument, aCOAUTHINFO"

	bytes uintPtrAtOffset: _OffsetOf_pAuthInfo put: aCOAUTHINFO yourAddress!

pwszName
	"Answer the <Utf16String> value of the receiver's 'pwszName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwszName)!

pwszName: anUtf16String
	"Set the receiver's 'pwszName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwszName put: anUtf16String yourAddress! !
!COSERVERINFO categoriesFor: #hostName!accessing!public! !
!COSERVERINFO categoriesFor: #hostName:!accessing!public! !
!COSERVERINFO categoriesFor: #pAuthInfo!**compiled accessors**!public! !
!COSERVERINFO categoriesFor: #pAuthInfo:!**compiled accessors**!public! !
!COSERVERINFO categoriesFor: #pwszName!**compiled accessors**!public! !
!COSERVERINFO categoriesFor: #pwszName:!**compiled accessors**!public! !

!COSERVERINFO class methodsFor!

defineFields
	"Define the fields of the COSERVERINFO structure.
		COSERVERINFO compileDefinition
	
		typedef 		struct tagCOSERVERINFO {
			unsigned long dwReserved1;
			LPWSTR pwszName;
			COAUTHINFO* pAuthInfo;
			unsigned long dwReserved2;
		} COSERVERINFO;	

	"

	self
		defineField: #dwReserved1 type: DWORDField filler;
		defineField: #pwszName type: (PointerField type: Utf16String);
		defineField: #pAuthInfo type: (PointerField type: COAUTHINFO);
		defineField: #dwReserved2 type: DWORDField filler!

getFieldNames
	^#(#pwszName #pAuthInfo)! !
!COSERVERINFO class categoriesFor: #defineFields!initializing!public! !
!COSERVERINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

