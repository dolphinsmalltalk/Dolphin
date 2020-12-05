"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.PROCESS_INFORMATION'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwProcessId' -> 16r8.
		'_OffsetOf_dwThreadId' -> 16rC.
		'_OffsetOf_hProcess' -> 16r0.
		'_OffsetOf_hThread' -> 16r4
	}!
OS.PROCESS_INFORMATION guid: (Core.GUID fromString: '{f44c9144-2b3f-11d3-8368-7a8b5a000000}')!
OS.PROCESS_INFORMATION comment: ''!
!OS.PROCESS_INFORMATION categoriesForClass!External-Data-Structured-Win32! !
!OS.PROCESS_INFORMATION methodsFor!

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
!OS.PROCESS_INFORMATION categoriesFor: #dwProcessId!**compiled accessors**!public! !
!OS.PROCESS_INFORMATION categoriesFor: #dwThreadId!**compiled accessors**!public! !
!OS.PROCESS_INFORMATION categoriesFor: #hProcess!**compiled accessors**!public! !
!OS.PROCESS_INFORMATION categoriesFor: #hThread!**compiled accessors**!public! !

!OS.PROCESS_INFORMATION class methodsFor!

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
!OS.PROCESS_INFORMATION class categoriesFor: #defineFields!initializing!public! !
!OS.PROCESS_INFORMATION class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

