"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #SERVICE_STATUS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwCheckPoint _OffsetOf_dwControlsAccepted _OffsetOf_dwCurrentState _OffsetOf_dwServiceSpecificExitCode _OffsetOf_dwServiceType _OffsetOf_dwWaitHint _OffsetOf_dwWin32ExitCode SC_STATUS_PROCESS_INFO SERVICE_CONTINUE_PENDING SERVICE_PAUSE_PENDING SERVICE_PAUSED SERVICE_RUNNING SERVICE_START_PENDING SERVICE_STOP_PENDING SERVICE_STOPPED'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SERVICE_STATUS guid: (GUID fromString: '{10bf8fd2-860a-42c1-bf63-5594e8e4a2b1}')!

SERVICE_STATUS addClassConstant: '_OffsetOf_dwCheckPoint' value: 16r14!
SERVICE_STATUS addClassConstant: '_OffsetOf_dwControlsAccepted' value: 16r8!
SERVICE_STATUS addClassConstant: '_OffsetOf_dwCurrentState' value: 16r4!
SERVICE_STATUS addClassConstant: '_OffsetOf_dwServiceSpecificExitCode' value: 16r10!
SERVICE_STATUS addClassConstant: '_OffsetOf_dwServiceType' value: 16r0!
SERVICE_STATUS addClassConstant: '_OffsetOf_dwWaitHint' value: 16r18!
SERVICE_STATUS addClassConstant: '_OffsetOf_dwWin32ExitCode' value: 16rC!
SERVICE_STATUS addClassConstant: 'SC_STATUS_PROCESS_INFO' value: 16r0!
SERVICE_STATUS addClassConstant: 'SERVICE_CONTINUE_PENDING' value: 16r5!
SERVICE_STATUS addClassConstant: 'SERVICE_PAUSE_PENDING' value: 16r6!
SERVICE_STATUS addClassConstant: 'SERVICE_PAUSED' value: 16r7!
SERVICE_STATUS addClassConstant: 'SERVICE_RUNNING' value: 16r4!
SERVICE_STATUS addClassConstant: 'SERVICE_START_PENDING' value: 16r2!
SERVICE_STATUS addClassConstant: 'SERVICE_STOP_PENDING' value: 16r3!
SERVICE_STATUS addClassConstant: 'SERVICE_STOPPED' value: 16r1!

SERVICE_STATUS comment: '`SERVICE_STATUS` is an `ExternalStructure` class to wrap the struct ''Win32.SERVICE_STATUS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains status information for a service."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(10bf8fd2-860a-42c1-bf63-5594e8e4a2b1), helpstring("Contains status information for a service.")]
struct tagSERVICE_STATUS {
	DWORD dwServiceType;
	DWORD dwCurrentState;
	DWORD dwControlsAccepted;
	DWORD dwWin32ExitCode;
	DWORD dwServiceSpecificExitCode;
	DWORD dwCheckPoint;
	DWORD dwWaitHint;
} SERVICE_STATUS;
```
'!

!SERVICE_STATUS categoriesForClass!Win32-Structs! !

!SERVICE_STATUS methodsFor!

currentState
	^#(#stopped #starting #stopping #running #continuing #pausing #paused) at: self dwCurrentState!

dwCheckPoint
	"Answer the <Integer> value of the receiver's 'dwCheckPoint' field."

	^bytes dwordAtOffset: _OffsetOf_dwCheckPoint!

dwCheckPoint: anInteger
	"Set the receiver's 'dwCheckPoint' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwCheckPoint put: anInteger!

dwControlsAccepted
	"Answer the <Integer> value of the receiver's 'dwControlsAccepted' field."

	^bytes dwordAtOffset: _OffsetOf_dwControlsAccepted!

dwControlsAccepted: anInteger
	"Set the receiver's 'dwControlsAccepted' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwControlsAccepted put: anInteger!

dwCurrentState
	"Answer the <Integer> value of the receiver's 'dwCurrentState' field."

	^bytes dwordAtOffset: _OffsetOf_dwCurrentState!

dwCurrentState: anInteger
	"Set the receiver's 'dwCurrentState' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwCurrentState put: anInteger!

dwServiceSpecificExitCode
	"Answer the <Integer> value of the receiver's 'dwServiceSpecificExitCode' field."

	^bytes dwordAtOffset: _OffsetOf_dwServiceSpecificExitCode!

dwServiceSpecificExitCode: anInteger
	"Set the receiver's 'dwServiceSpecificExitCode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwServiceSpecificExitCode put: anInteger!

dwServiceType
	"Answer the <Integer> value of the receiver's 'dwServiceType' field."

	^bytes dwordAtOffset: _OffsetOf_dwServiceType!

dwServiceType: anInteger
	"Set the receiver's 'dwServiceType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwServiceType put: anInteger!

dwWaitHint
	"Answer the <Integer> value of the receiver's 'dwWaitHint' field."

	^bytes dwordAtOffset: _OffsetOf_dwWaitHint!

dwWaitHint: anInteger
	"Set the receiver's 'dwWaitHint' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwWaitHint put: anInteger!

dwWin32ExitCode
	"Answer the <Integer> value of the receiver's 'dwWin32ExitCode' field."

	^bytes dwordAtOffset: _OffsetOf_dwWin32ExitCode!

dwWin32ExitCode: anInteger
	"Set the receiver's 'dwWin32ExitCode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwWin32ExitCode put: anInteger! !

!SERVICE_STATUS categoriesForMethods!
currentState!accessing!public! !
dwCheckPoint!**compiled accessors**!public! !
dwCheckPoint:!**compiled accessors**!public! !
dwControlsAccepted!**compiled accessors**!public! !
dwControlsAccepted:!**compiled accessors**!public! !
dwCurrentState!**compiled accessors**!public! !
dwCurrentState:!**compiled accessors**!public! !
dwServiceSpecificExitCode!**compiled accessors**!public! !
dwServiceSpecificExitCode:!**compiled accessors**!public! !
dwServiceType!**compiled accessors**!public! !
dwServiceType:!**compiled accessors**!public! !
dwWaitHint!**compiled accessors**!public! !
dwWaitHint:!**compiled accessors**!public! !
dwWin32ExitCode!**compiled accessors**!public! !
dwWin32ExitCode:!**compiled accessors**!public! !
!

!SERVICE_STATUS class methodsFor!

defineFields
	"Define the fields of the SERVICE_STATUS structure.

	SERVICE_STATUS compileDefinition

		typedef [uuid(10bf8fd2-860a-42c1-bf63-5594e8e4a2b1), helpstring('Contains status information for a service.')]
		struct tagSERVICE_STATUS {
			DWORD dwServiceType;
			DWORD dwCurrentState;
			DWORD dwControlsAccepted;
			DWORD dwWin32ExitCode;
			DWORD dwServiceSpecificExitCode;
			DWORD dwCheckPoint;
			DWORD dwWaitHint;
		} SERVICE_STATUS;
"

	self
		defineField: #dwServiceType type: DWORDField new offset: 0;
		defineField: #dwCurrentState type: DWORDField new offset: 4;
		defineField: #dwControlsAccepted type: DWORDField new offset: 8;
		defineField: #dwWin32ExitCode type: DWORDField new offset: 12;
		defineField: #dwServiceSpecificExitCode type: DWORDField new offset: 16;
		defineField: #dwCheckPoint type: DWORDField new offset: 20;
		defineField: #dwWaitHint type: DWORDField new offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#dwServiceType #dwCurrentState #dwControlsAccepted #dwWin32ExitCode #dwServiceSpecificExitCode #dwCheckPoint #dwWaitHint)! !

!SERVICE_STATUS class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

