"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #PROCESS_INFORMATION
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwProcessId _OffsetOf_dwThreadId _OffsetOf_hProcess _OffsetOf_hThread _PROCESS_INFORMATION_Size'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PROCESS_INFORMATION guid: (GUID fromString: '{f44c9144-2b3f-11d3-8368-7a8b5a000000}')!
PROCESS_INFORMATION addClassConstant: '_OffsetOf_dwProcessId' value: 16r8!
PROCESS_INFORMATION addClassConstant: '_OffsetOf_dwThreadId' value: 16rC!
PROCESS_INFORMATION addClassConstant: '_OffsetOf_hProcess' value: 16r0!
PROCESS_INFORMATION addClassConstant: '_OffsetOf_hThread' value: 16r4!
PROCESS_INFORMATION addClassConstant: '_PROCESS_INFORMATION_Size' value: 16r10!
PROCESS_INFORMATION comment: ''!
!PROCESS_INFORMATION categoriesForClass!External-Data-Structured-Win32! !
!PROCESS_INFORMATION methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes dwordAtOffset: _OffsetOf_dwProcessId!

dwThreadId
	"Answer the <Integer> value of the receiver's 'dwThreadId' field."

	^bytes dwordAtOffset: _OffsetOf_dwThreadId!

hProcess
	"Answer the <Integer> value of the receiver's 'hProcess' field."

	^bytes dwordAtOffset: _OffsetOf_hProcess!

hThread
	"Answer the <Integer> value of the receiver's 'hThread' field."

	^bytes dwordAtOffset: _OffsetOf_hThread! !
!PROCESS_INFORMATION categoriesForMethods!
dwProcessId!**compiled accessors**!public! !
dwThreadId!**compiled accessors**!public! !
hProcess!**compiled accessors**!public! !
hThread!**compiled accessors**!public! !
!

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
		defineField: #dwThreadId type: DWORDField readOnly!

getFieldNames
	^#(#hProcess #hThread #dwProcessId #dwThreadId)! !
!PROCESS_INFORMATION class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

