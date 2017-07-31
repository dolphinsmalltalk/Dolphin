"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #PROCESS_INFORMATION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PROCESS_INFORMATION guid: (GUID fromString: '{f44c9144-2b3f-11d3-8368-7a8b5a000000}')!
PROCESS_INFORMATION comment: ''!
!PROCESS_INFORMATION categoriesForClass!External-Data-Structured-Win32! !
!PROCESS_INFORMATION methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwProcessId)!

dwThreadId
	"Answer the <Integer> value of the receiver's 'dwThreadId' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwThreadId)!

hProcess
	"Answer the <Integer> value of the receiver's 'hProcess' field."

	^bytes dwordAtOffset: 0!

hThread
	"Answer the <Integer> value of the receiver's 'hThread' field."

	^bytes dwordAtOffset: ##(self offsetOf: #hThread)! !
!PROCESS_INFORMATION categoriesFor: #dwProcessId!**compiled accessors**!public! !
!PROCESS_INFORMATION categoriesFor: #dwThreadId!**compiled accessors**!public! !
!PROCESS_INFORMATION categoriesFor: #hProcess!**compiled accessors**!public! !
!PROCESS_INFORMATION categoriesFor: #hThread!**compiled accessors**!public! !

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
		defineField: #hProcess type: DWORDField readOnly;
		defineField: #hThread type: DWORDField readOnly;
		defineField: #dwProcessId type: DWORDField readOnly;
		defineField: #dwThreadId type: DWORDField readOnly! !
!PROCESS_INFORMATION class categoriesFor: #defineFields!initializing!public! !

