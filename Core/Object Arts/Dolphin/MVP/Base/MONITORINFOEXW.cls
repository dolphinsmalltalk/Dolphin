"Filed out from Dolphin Smalltalk"!

MONITORINFO subclass: #MONITORINFOEXW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_szDevice'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MONITORINFOEXW guid: (GUID fromString: '{b51d5aa0-7d88-48dc-8c48-36240b05b9ad}')!

MONITORINFOEXW addClassConstant: '_OffsetOf_szDevice' value: 16r28!

MONITORINFOEXW comment: '`MONITORINFOEXW` is an `External.Structure` class to wrap the struct ''Win32.MONITORINFOEXW'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(b51d5aa0-7d88-48dc-8c48-36240b05b9ad)]
struct tagMONITORINFOEXW {
	[restricted, helpstring("The size of the structure, in bytes.")] DWORD dwSize;
	[readonly, helpstring("Specifies the display monitor rectangle, expressed in virtual-screen coordinates")] RECT rcMonitor;
	[readonly, helpstring("Specifies the work area rectangle of the display monitor, expressed in virtual-screen coordinates.")] RECT rcWork;
	[readonly, helpstring("A set of flags that represent attributes of the display monitor.")] DWORD dwFlags;
	[readonly, helpstring("specifies the device name of the monitor being used"), string] unsigned short szDevice[32];
} MONITORINFOEXW;
```
'!

!MONITORINFOEXW categoriesForClass!Win32-Structs! !

!MONITORINFOEXW methodsFor!

szDevice
	"Answer the <Utf16String> value of the receiver's 'szDevice' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szDevice! !

!MONITORINFOEXW categoriesForMethods!
szDevice!**compiled accessors**!public! !
!

!MONITORINFOEXW class methodsFor!

defineFields
	"Define the fields of the MONITORINFOEXW structure.

	MONITORINFOEXW compileDefinition

		typedef [uuid(b51d5aa0-7d88-48dc-8c48-36240b05b9ad)]
		struct tagMONITORINFOEXW {
			[restricted, helpstring('The size of the structure, in bytes.')] DWORD dwSize;
			[readonly, helpstring('Specifies the display monitor rectangle, expressed in virtual-screen coordinates')] RECT rcMonitor;
			[readonly, helpstring('Specifies the work area rectangle of the display monitor, expressed in virtual-screen coordinates.')] RECT rcWork;
			[readonly, helpstring('A set of flags that represent attributes of the display monitor.')] DWORD dwFlags;
			[readonly, helpstring('specifies the device name of the monitor being used'), string] unsigned short szDevice[32];
		} MONITORINFOEXW;
"

	super defineFields.
	self
		defineField: #szDevice
		type: (StringField type: Utf16String length: 32) beReadOnly
		offset: 40.
	self byteSize: 104!

getFieldNames
	^#(#dwSize #rcMonitor #rcWork #dwFlags #szDevice)! !

!MONITORINFOEXW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

