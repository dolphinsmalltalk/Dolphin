"Filed out from Dolphin Smalltalk"!

OS.MONITORINFO subclass: #'OS.MONITORINFOEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_MONITORINFOEXW_Size' -> 16r68.
		'_OffsetOf_szDevice' -> 16r28
	}!
OS.MONITORINFOEXW guid: (Core.GUID fromString: '{b51d5aa0-7d88-48dc-8c48-36240b05b9ad}')!
OS.MONITORINFOEXW comment: '`MONITORINFOEXW` is an `External.Structure` class to wrap the struct ''Win32.MONITORINFOEXW'' from type information in the ''Win32 API'' library.

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
!OS.MONITORINFOEXW categoriesForClass!Win32-Structs! !
!OS.MONITORINFOEXW methodsFor!

szDevice
	"Answer the <Utf16String> value of the receiver's 'szDevice' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szDevice! !
!OS.MONITORINFOEXW categoriesForMethods!
szDevice!**compiled accessors**!public! !
!

!OS.MONITORINFOEXW class methodsFor!

byteSize
	^_MONITORINFOEXW_Size!

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
!OS.MONITORINFOEXW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

