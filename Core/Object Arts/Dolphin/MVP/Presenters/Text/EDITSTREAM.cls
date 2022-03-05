"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #EDITSTREAM
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwCookie _OffsetOf_dwError _OffsetOf_pfnCallback'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EDITSTREAM guid: (GUID fromString: '{87b4c5ef-026e-11d3-9fd7-00a0cc3e4a32}')!
EDITSTREAM addClassConstant: '_OffsetOf_dwCookie' value: 16r0!
EDITSTREAM addClassConstant: '_OffsetOf_dwError' value: 16r4!
EDITSTREAM addClassConstant: '_OffsetOf_pfnCallback' value: 16r8!
EDITSTREAM comment: ''!
!EDITSTREAM categoriesForClass!External-Data-Structured-Win32! !
!EDITSTREAM methodsFor!

pfnCallback: anExternalAddress
	"Set the receiver's 'pfnCallback' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_pfnCallback put: anExternalAddress! !
!EDITSTREAM categoriesForMethods!
pfnCallback:!**compiled accessors**!public! !
!

!EDITSTREAM class methodsFor!

defineFields
	"Define the fields of the Win32 EDITSTREAM structure.

		EDITSTREAM compileDefinition

	typedef struct _editstream { 
		DWORD dwCookie; 
		DWORD dwError; 
		EDITSTREAMCALLBACK pfnCallback; 
	} EDITSTREAM;"

	self 
		defineField: #dwCookie			type: DWORDField filler;
		defineField: #dwError			type: DWORDField filler;
		defineField: #pfnCallback		type: LPVOIDField writeOnly!

getFieldNames
	^#(#pfnCallback)! !
!EDITSTREAM class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

