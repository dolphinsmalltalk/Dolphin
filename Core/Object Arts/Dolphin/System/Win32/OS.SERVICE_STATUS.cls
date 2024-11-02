"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.SERVICE_STATUS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_dwCheckPoint' -> 16r14.
			'_OffsetOf_dwControlsAccepted' -> 16r8.
			'_OffsetOf_dwCurrentState' -> 16r4.
			'_OffsetOf_dwServiceSpecificExitCode' -> 16r10.
			'_OffsetOf_dwServiceType' -> 16r0.
			'_OffsetOf_dwWaitHint' -> 16r18.
			'_OffsetOf_dwWin32ExitCode' -> 16rC.
			'_SERVICE_STATUS_Size' -> 16r1C.
			'SC_STATUS_PROCESS_INFO' -> 16r0.
			'SERVICE_CONTINUE_PENDING' -> 16r5.
			'SERVICE_PAUSE_PENDING' -> 16r6.
			'SERVICE_PAUSED' -> 16r7.
			'SERVICE_RUNNING' -> 16r4.
			'SERVICE_START_PENDING' -> 16r2.
			'SERVICE_STOP_PENDING' -> 16r3.
			'SERVICE_STOPPED' -> 16r1
		}!

OS.SERVICE_STATUS guid: (Core.GUID fromString: '{10bf8fd2-860a-42c1-bf63-5594e8e4a2b1}')!

OS.SERVICE_STATUS comment: '`SERVICE_STATUS` is an `ExternalStructure` class to wrap the struct ''Win32.SERVICE_STATUS'' from type information in the ''Win32 API'' library.

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

!OS.SERVICE_STATUS categoriesForClass!Win32-Structs! !

!OS.SERVICE_STATUS methodsFor!

currentState
	^#(#stopped #starting #stopping #running #continuing #pausing #paused) at: self dwCurrentState!

dwCheckPoint
	"Answer the <Integer> value of the receiver's 'dwCheckPoint' field."

	^bytes uint32AtOffset: _OffsetOf_dwCheckPoint!

dwCheckPoint: anInteger
	"Set the receiver's 'dwCheckPoint' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwCheckPoint put: anInteger!

dwControlsAccepted
	"Answer the <Integer> value of the receiver's 'dwControlsAccepted' field."

	^bytes uint32AtOffset: _OffsetOf_dwControlsAccepted!

dwControlsAccepted: anInteger
	"Set the receiver's 'dwControlsAccepted' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwControlsAccepted put: anInteger!

dwCurrentState
	"Answer the <Integer> value of the receiver's 'dwCurrentState' field."

	^bytes uint32AtOffset: _OffsetOf_dwCurrentState!

dwCurrentState: anInteger
	"Set the receiver's 'dwCurrentState' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwCurrentState put: anInteger!

dwServiceSpecificExitCode
	"Answer the <Integer> value of the receiver's 'dwServiceSpecificExitCode' field."

	^bytes uint32AtOffset: _OffsetOf_dwServiceSpecificExitCode!

dwServiceSpecificExitCode: anInteger
	"Set the receiver's 'dwServiceSpecificExitCode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwServiceSpecificExitCode put: anInteger!

dwServiceType
	"Answer the <Integer> value of the receiver's 'dwServiceType' field."

	^bytes uint32AtOffset: _OffsetOf_dwServiceType!

dwServiceType: anInteger
	"Set the receiver's 'dwServiceType' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwServiceType put: anInteger!

dwWaitHint
	"Answer the <Integer> value of the receiver's 'dwWaitHint' field."

	^bytes uint32AtOffset: _OffsetOf_dwWaitHint!

dwWaitHint: anInteger
	"Set the receiver's 'dwWaitHint' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwWaitHint put: anInteger!

dwWin32ExitCode
	"Answer the <Integer> value of the receiver's 'dwWin32ExitCode' field."

	^bytes uint32AtOffset: _OffsetOf_dwWin32ExitCode!

dwWin32ExitCode: anInteger
	"Set the receiver's 'dwWin32ExitCode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwWin32ExitCode put: anInteger! !

!OS.SERVICE_STATUS categoriesForMethods!
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

!OS.SERVICE_STATUS class methodsFor!

byteSize
	^_SERVICE_STATUS_Size!

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
		defineField: #dwServiceType type: UInt32Field new offset: 0;
		defineField: #dwCurrentState type: UInt32Field new offset: 4;
		defineField: #dwControlsAccepted type: UInt32Field new offset: 8;
		defineField: #dwWin32ExitCode type: UInt32Field new offset: 12;
		defineField: #dwServiceSpecificExitCode type: UInt32Field new offset: 16;
		defineField: #dwCheckPoint type: UInt32Field new offset: 20;
		defineField: #dwWaitHint type: UInt32Field new offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#dwServiceType #dwCurrentState #dwControlsAccepted #dwWin32ExitCode #dwServiceSpecificExitCode #dwCheckPoint #dwWaitHint)! !

!OS.SERVICE_STATUS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

