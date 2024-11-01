"Filed out from Dolphin Smalltalk"!

SERVICE_STATUS subclass: #SERVICE_STATUS_PROCESS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwProcessId _OffsetOf_dwServiceFlags'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SERVICE_STATUS_PROCESS guid: (GUID fromString: '{ae79552d-1aa8-44a2-a37b-784deabdd960}')!

SERVICE_STATUS_PROCESS addClassConstant: '_OffsetOf_dwProcessId' value: 16r1C!
SERVICE_STATUS_PROCESS addClassConstant: '_OffsetOf_dwServiceFlags' value: 16r20!

SERVICE_STATUS_PROCESS comment: '`SERVICE_STATUS_PROCESS` is an `ExternalStructure` class to wrap the struct ''Win32.SERVICE_STATUS_PROCESS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains the name of a service in a service control manager database and information about the service. Used by the EnumServicesStatusEx function."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(ae79552d-1aa8-44a2-a37b-784deabdd960), helpstring("Contains the name of a service in a service control manager database and information about the service. Used by the EnumServicesStatusEx function.")]
struct tagSERVICE_STATUS_PROCESS {
	DWORD dwServiceType;
	DWORD dwCurrentState;
	DWORD dwControlsAccepted;
	DWORD dwWin32ExitCode;
	DWORD dwServiceSpecificExitCode;
	DWORD dwCheckPoint;
	DWORD dwWaitHint;
	DWORD dwProcessId;
	DWORD dwServiceFlags;
} SERVICE_STATUS_PROCESS;
```
'!

!SERVICE_STATUS_PROCESS categoriesForClass!Win32-Structs! !

!SERVICE_STATUS_PROCESS methodsFor!

dwProcessId
	"Answer the <Integer> value of the receiver's 'dwProcessId' field."

	^bytes dwordAtOffset: _OffsetOf_dwProcessId!

dwServiceFlags
	"Answer the <Integer> value of the receiver's 'dwServiceFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwServiceFlags! !

!SERVICE_STATUS_PROCESS categoriesForMethods!
dwProcessId!**compiled accessors**!public! !
dwServiceFlags!**compiled accessors**!public! !
!

!SERVICE_STATUS_PROCESS class methodsFor!

defineFields
	"Define the fields of the SERVICE_STATUS_PROCESS structure.

	SERVICE_STATUS_PROCESS compileDefinition

		typedef [uuid(ae79552d-1aa8-44a2-a37b-784deabdd960), helpstring('Contains the name of a service in a service control manager database and information about the service. Used by the EnumServicesStatusEx function.')]
		struct tagSERVICE_STATUS_PROCESS {
			DWORD dwServiceType;
			DWORD dwCurrentState;
			DWORD dwControlsAccepted;
			DWORD dwWin32ExitCode;
			DWORD dwServiceSpecificExitCode;
			DWORD dwCheckPoint;
			DWORD dwWaitHint;
			DWORD dwProcessId;
			DWORD dwServiceFlags;
		} SERVICE_STATUS_PROCESS;
"

	super defineFields.
	self
		defineField: #dwProcessId type: DWORDField readOnly offset: 28;
		defineField: #dwServiceFlags type: DWORDField readOnly offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#dwServiceType #dwCurrentState #dwControlsAccepted #dwWin32ExitCode #dwServiceSpecificExitCode #dwCheckPoint #dwWaitHint #dwProcessId #dwServiceFlags)! !

!SERVICE_STATUS_PROCESS class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

