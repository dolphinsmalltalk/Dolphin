"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #EDITSTREAM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EDITSTREAM guid: (GUID fromString: '{87B4C5EF-026E-11D3-9FD7-00A0CC3E4A32}')!
EDITSTREAM comment: ''!
!EDITSTREAM categoriesForClass!External-Data-Structured-Win32! !
!EDITSTREAM methodsFor!

pfnCallback: anObject 
	"Set the receiver's pfnCallback field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pfnCallback) put: anObject! !
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
		defineField: #pfnCallback		type: LPVOIDField writeOnly! !
!EDITSTREAM class categoriesFor: #defineFields!initializing!public! !

