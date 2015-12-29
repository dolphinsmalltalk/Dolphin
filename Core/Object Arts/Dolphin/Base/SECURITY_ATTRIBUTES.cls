"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #SECURITY_ATTRIBUTES
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SECURITY_ATTRIBUTES guid: (GUID fromString: '{F44C9145-2B3F-11D3-8368-7A8B5A000000}')!
SECURITY_ATTRIBUTES comment: ''!
!SECURITY_ATTRIBUTES categoriesForClass!External-Data-Structured-Win32! !
!SECURITY_ATTRIBUTES methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!SECURITY_ATTRIBUTES categoriesFor: #dwSize:!**compiled accessors**!public! !

!SECURITY_ATTRIBUTES class methodsFor!

defineFields
	"Define the fields of the SECURITY_ATTRIBUTES structure:

		SECURITY_ATTRIBUTES compileDefinition.

	typedef struct _SECURITY_ATTRIBUTES { // sa 
		DWORD nLength; 
		LPVOID lpSecurityDescriptor; 
		BOOL bInheritHandle; 
	} SECURITY_ATTRIBUTES; "

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		beUncompiled;
		defineField: #lpSecurityDescriptor type: LPVOIDField new;
		defineField: #bInheritHandle type: BOOLField new
! !
!SECURITY_ATTRIBUTES class categoriesFor: #defineFields!initializing!public! !

