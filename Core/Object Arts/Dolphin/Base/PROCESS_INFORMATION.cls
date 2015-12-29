"Filed out from Dolphin Smalltalk X6"!

Win32Structure subclass: #PROCESS_INFORMATION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PROCESS_INFORMATION guid: (GUID fromString: '{F44C9144-2B3F-11D3-8368-7A8B5A000000}')!
PROCESS_INFORMATION comment: ''!
!PROCESS_INFORMATION categoriesForClass!External-Data-Structured-Win32! !
!PROCESS_INFORMATION class methodsFor!

defineFields
	"Define the fields of the Win32 PROCESS_INFORMATION structure.

		PROCESS_INFORMATION compileDefinition

	typedef struct _PROCESS_INFORMATION { // pi 
		HANDLE hProcess; 
		HANDLE hThread; 
		DWORD dwProcessId; 
		DWORD dwThreadId; 
	} PROCESS_INFORMATION; "

	self 
		beUncompiled;
		defineField: #hProcess type: DWORDField readOnly;
		defineField: #hThread type: DWORDField readOnly;
		defineField: #dwProcessId type: DWORDField readOnly;
		defineField: #dwThreadId type: DWORDField readOnly
! !
!PROCESS_INFORMATION class categoriesFor: #defineFields!initializing!public! !

