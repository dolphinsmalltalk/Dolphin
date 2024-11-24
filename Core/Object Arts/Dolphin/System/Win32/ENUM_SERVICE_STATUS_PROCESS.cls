"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.ENUM_SERVICE_STATUS_PROCESS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ENUM_SERVICE_STATUS_PROCESS_Size' -> 16r2C.
			'_OffsetOf_lpDisplayName' -> 16r4.
			'_OffsetOf_lpServiceName' -> 16r0.
			'_OffsetOf_ServiceStatusProcess' -> 16r8.
			'SERVICE_ACTIVE' -> 16r1.
			'SERVICE_ADAPTER' -> 16r4.
			'SERVICE_DRIVER' -> 16rB.
			'SERVICE_FILE_SYSTEM_DRIVER' -> 16r2.
			'SERVICE_INACTIVE' -> 16r2.
			'SERVICE_INTERACTIVE_PROCESS' -> 16r100.
			'SERVICE_KERNEL_DRIVER' -> 16r1.
			'SERVICE_PKG_SERVICE' -> 16r200.
			'SERVICE_RECOGNIZER_DRIVER' -> 16r8.
			'SERVICE_STATE_ALL' -> 16r3.
			'SERVICE_TYPE_ALL' -> 16r3FF.
			'SERVICE_USER_OWN_PROCESS' -> 16r50.
			'SERVICE_USER_SERVICE' -> 16r40.
			'SERVICE_USER_SHARE_PROCESS' -> 16r60.
			'SERVICE_USERSERVICE_INSTANCE' -> 16r80.
			'SERVICE_WIN32' -> 16r30.
			'SERVICE_WIN32_OWN_PROCESS' -> 16r10.
			'SERVICE_WIN32_SHARE_PROCESS' -> 16r20
		}!

OS.ENUM_SERVICE_STATUS_PROCESS guid: (Core.GUID fromString: '{414cc39f-640b-4f78-b580-bdd5e0ae07e2}')!

OS.ENUM_SERVICE_STATUS_PROCESS comment: '`ENUM_SERVICE_STATUS_PROCESS` is an `External.Structure` class to wrap the struct ''Win32.ENUM_SERVICE_STATUS_PROCESS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains the name of a service in a service control manager database and information about the service. Used by the EnumServicesStatusEx function."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(414cc39f-640b-4f78-b580-bdd5e0ae07e2), helpstring("Contains the name of a service in a service control manager database and information about the service. Used by the EnumServicesStatusEx function.")]
struct tagENUM_SERVICE_STATUS_PROCESS {
	LPWSTR lpServiceName;
	LPWSTR lpDisplayName;
	SERVICE_STATUS_PROCESS ServiceStatusProcess;
} ENUM_SERVICE_STATUS_PROCESS;
```
'!

!OS.ENUM_SERVICE_STATUS_PROCESS categoriesForClass!Win32-Structs! !

!OS.ENUM_SERVICE_STATUS_PROCESS methodsFor!

lpDisplayName
	"Answer the <Utf16String> value of the receiver's 'lpDisplayName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpDisplayName)!

lpDisplayName: anUtf16String
	"Set the receiver's 'lpDisplayName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpDisplayName put: anUtf16String yourAddress!

lpServiceName
	"Answer the <Utf16String> value of the receiver's 'lpServiceName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpServiceName)!

lpServiceName: anUtf16String
	"Set the receiver's 'lpServiceName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpServiceName put: anUtf16String yourAddress!

ServiceStatusProcess
	"Answer the <SERVICE_STATUS_PROCESS> value of the receiver's 'ServiceStatusProcess' field."

	^SERVICE_STATUS_PROCESS fromAddress: bytes yourAddress + _OffsetOf_ServiceStatusProcess!

ServiceStatusProcess: aSERVICE_STATUS_PROCESS
	"Set the receiver's 'ServiceStatusProcess' field to the value of the argument, aSERVICE_STATUS_PROCESS"

	aSERVICE_STATUS_PROCESS
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ServiceStatusProcess + 1)
		to: ##(_OffsetOf_ServiceStatusProcess + SERVICE_STATUS_PROCESS._SERVICE_STATUS_PROCESS_Size)
		startingAt: 1! !

!OS.ENUM_SERVICE_STATUS_PROCESS categoriesForMethods!
lpDisplayName!**compiled accessors**!public! !
lpDisplayName:!**compiled accessors**!public! !
lpServiceName!**compiled accessors**!public! !
lpServiceName:!**compiled accessors**!public! !
ServiceStatusProcess!**compiled accessors**!public! !
ServiceStatusProcess:!**compiled accessors**!public! !
!

!OS.ENUM_SERVICE_STATUS_PROCESS class methodsFor!

byteSize
	^_ENUM_SERVICE_STATUS_PROCESS_Size!

defineFields
	"Define the fields of the ENUM_SERVICE_STATUS_PROCESS structure.

	ENUM_SERVICE_STATUS_PROCESS compileDefinition

		typedef [uuid(414cc39f-640b-4f78-b580-bdd5e0ae07e2), helpstring('Contains the name of a service in a service control manager database and information about the service. Used by the EnumServicesStatusEx function.')]
		struct tagENUM_SERVICE_STATUS_PROCESS {
			LPWSTR lpServiceName;
			LPWSTR lpDisplayName;
			SERVICE_STATUS_PROCESS ServiceStatusProcess;
		} ENUM_SERVICE_STATUS_PROCESS;
"

	self
		defineField: #lpServiceName type: (PointerField type: Utf16String) offset: 0;
		defineField: #lpDisplayName type: (PointerField type: Utf16String) offset: 4;
		defineField: #ServiceStatusProcess type: (StructureField type: SERVICE_STATUS_PROCESS) offset: 8.
	self byteSize: 44!

getFieldNames
	^#(#lpServiceName #lpDisplayName #ServiceStatusProcess)! !

!OS.ENUM_SERVICE_STATUS_PROCESS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

