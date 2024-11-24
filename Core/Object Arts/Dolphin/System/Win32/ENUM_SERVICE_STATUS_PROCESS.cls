"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #ENUM_SERVICE_STATUS_PROCESS
	instanceVariableNames: ''
	classVariableNames: '_ENUM_SERVICE_STATUS_PROCESS_Size _OffsetOf_lpDisplayName _OffsetOf_lpServiceName _OffsetOf_ServiceStatusProcess SERVICE_ACTIVE SERVICE_ADAPTER SERVICE_DRIVER SERVICE_FILE_SYSTEM_DRIVER SERVICE_INACTIVE SERVICE_INTERACTIVE_PROCESS SERVICE_KERNEL_DRIVER SERVICE_PKG_SERVICE SERVICE_RECOGNIZER_DRIVER SERVICE_STATE_ALL SERVICE_TYPE_ALL SERVICE_USER_OWN_PROCESS SERVICE_USER_SERVICE SERVICE_USER_SHARE_PROCESS SERVICE_USERSERVICE_INSTANCE SERVICE_WIN32 SERVICE_WIN32_OWN_PROCESS SERVICE_WIN32_SHARE_PROCESS'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ENUM_SERVICE_STATUS_PROCESS guid: (GUID fromString: '{878e62ff-4a85-4c6c-ade5-3b7441db1aea}')!

ENUM_SERVICE_STATUS_PROCESS addClassConstant: '_OffsetOf_lpDisplayName' value: 16r4!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: '_OffsetOf_lpServiceName' value: 16r0!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: '_OffsetOf_ServiceStatusProcess' value: 16r8!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_ACTIVE' value: 16r1!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_ADAPTER' value: 16r4!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_DRIVER' value: 16rB!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_FILE_SYSTEM_DRIVER' value: 16r2!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_INACTIVE' value: 16r2!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_INTERACTIVE_PROCESS' value: 16r100!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_KERNEL_DRIVER' value: 16r1!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_PKG_SERVICE' value: 16r200!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_RECOGNIZER_DRIVER' value: 16r8!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_STATE_ALL' value: 16r3!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_TYPE_ALL' value: 16r3FF!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_USER_OWN_PROCESS' value: 16r50!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_USER_SERVICE' value: 16r40!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_USER_SHARE_PROCESS' value: 16r60!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_USERSERVICE_INSTANCE' value: 16r80!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_WIN32' value: 16r30!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_WIN32_OWN_PROCESS' value: 16r10!
ENUM_SERVICE_STATUS_PROCESS addClassConstant: 'SERVICE_WIN32_SHARE_PROCESS' value: 16r20!

ENUM_SERVICE_STATUS_PROCESS comment: '`ENUM_SERVICE_STATUS_PROCESS` is an `External.Structure` class to wrap the struct ''Win32.ENUM_SERVICE_STATUS_PROCESS'' from type information in the ''Win32 API'' library.

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

!ENUM_SERVICE_STATUS_PROCESS categoriesForClass!Win32-Structs! !

!ENUM_SERVICE_STATUS_PROCESS methodsFor!

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
		to: _OffsetOf_ServiceStatusProcess + self byteSize
		startingAt: 1! !

!ENUM_SERVICE_STATUS_PROCESS categoriesForMethods!
lpDisplayName!**compiled accessors**!public! !
lpDisplayName:!**compiled accessors**!public! !
lpServiceName!**compiled accessors**!public! !
lpServiceName:!**compiled accessors**!public! !
ServiceStatusProcess!**compiled accessors**!public! !
ServiceStatusProcess:!**compiled accessors**!public! !
!

!ENUM_SERVICE_STATUS_PROCESS class methodsFor!

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

!ENUM_SERVICE_STATUS_PROCESS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

