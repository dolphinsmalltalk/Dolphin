"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #EDITSTREAM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwCookie' -> 16r0.
		'_OffsetOf_dwError' -> 16r4.
		'_OffsetOf_pfnCallback' -> 16r8
	}!
EDITSTREAM guid: (GUID fromString: '{87b4c5ef-026e-11d3-9fd7-00a0cc3e4a32}')!
EDITSTREAM comment: ''!
!EDITSTREAM categoriesForClass!External-Data-Structured-Win32! !
!EDITSTREAM methodsFor!

pfnCallback: anExternalAddress
	"Set the receiver's 'pfnCallback' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_pfnCallback put: anExternalAddress! !
!EDITSTREAM categoriesFor: #pfnCallback:!**compiled accessors**!public! !

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
!EDITSTREAM class categoriesFor: #defineFields!public!template definition! !
!EDITSTREAM class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

