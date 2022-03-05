"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #DISPLAY_DEVICEW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_DeviceID _OffsetOf_DeviceKey _OffsetOf_DeviceName _OffsetOf_DeviceString _OffsetOf_dwSize _OffsetOf_StateFlags DISPLAY_DEVICE_ATTACHED_TO_DESKTOP DISPLAY_DEVICE_MIRRORING_DRIVER DISPLAY_DEVICE_MULTI_DRIVER DISPLAY_DEVICE_PRIMARY_DEVICE DISPLAY_DEVICE_VGA_COMPATIBLE'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DISPLAY_DEVICEW guid: (GUID fromString: '{b21c0d9e-8924-4788-ad73-e7751f9f1c6b}')!
DISPLAY_DEVICEW addClassConstant: '_OffsetOf_DeviceID' value: 16r148!
DISPLAY_DEVICEW addClassConstant: '_OffsetOf_DeviceKey' value: 16r248!
DISPLAY_DEVICEW addClassConstant: '_OffsetOf_DeviceName' value: 16r4!
DISPLAY_DEVICEW addClassConstant: '_OffsetOf_DeviceString' value: 16r44!
DISPLAY_DEVICEW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
DISPLAY_DEVICEW addClassConstant: '_OffsetOf_StateFlags' value: 16r144!
DISPLAY_DEVICEW addClassConstant: 'DISPLAY_DEVICE_ATTACHED_TO_DESKTOP' value: 16r1!
DISPLAY_DEVICEW addClassConstant: 'DISPLAY_DEVICE_MIRRORING_DRIVER' value: 16r8!
DISPLAY_DEVICEW addClassConstant: 'DISPLAY_DEVICE_MULTI_DRIVER' value: 16r2!
DISPLAY_DEVICEW addClassConstant: 'DISPLAY_DEVICE_PRIMARY_DEVICE' value: 16r4!
DISPLAY_DEVICEW addClassConstant: 'DISPLAY_DEVICE_VGA_COMPATIBLE' value: 16r10!
DISPLAY_DEVICEW comment: '`DISPLAY_DEVICEW` is an `External.Structure` class to wrap the struct ''Win32.DISPLAY_DEVICEW'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(b21c0d9e-8924-4788-ad73-e7751f9f1c6b)]
struct tagDISPLAY_DEVICEW {
	[restricted, helpstring("The size of the structure, in bytes.")] DWORD dwSize;
	[readonly, helpstring("An array of characters identifying the device name. This is either the adapter device or the monitor device."), string] unsigned short DeviceName[32];
	[readonly, helpstring("An array of characters containing the device context string. This is either a description of the display adapter or of the display monitor."), string] unsigned short DeviceString[128];
	[readonly, helpstring("Device state flags.")] DWORD StateFlags;
	[readonly, string] unsigned short DeviceID[128];
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] unsigned short DeviceKey[128];
} DISPLAY_DEVICEW;
```
'!
!DISPLAY_DEVICEW categoriesForClass!Win32-Structs! !
!DISPLAY_DEVICEW methodsFor!

DeviceID
	"Answer the <Utf16String> value of the receiver's 'DeviceID' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_DeviceID!

DeviceName
	"Answer the <Utf16String> value of the receiver's 'DeviceName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_DeviceName!

DeviceString
	"Answer the <Utf16String> value of the receiver's 'DeviceString' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_DeviceString!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

isAttachedToDesktop
	^self StateFlags allMask: DISPLAY_DEVICE_ATTACHED_TO_DESKTOP!

isPrimaryAdaptor
	"Answer whether the receiver is describing the primary display adaptor."

	^self StateFlags allMask: DISPLAY_DEVICE_PRIMARY_DEVICE!

StateFlags
	"Answer the <Integer> value of the receiver's 'StateFlags' field."

	^bytes dwordAtOffset: _OffsetOf_StateFlags! !
!DISPLAY_DEVICEW categoriesForMethods!
DeviceID!**compiled accessors**!public! !
DeviceName!**compiled accessors**!public! !
DeviceString!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
isAttachedToDesktop!public!testing! !
isPrimaryAdaptor!public!testing! !
StateFlags!**compiled accessors**!public! !
!

!DISPLAY_DEVICEW class methodsFor!

defineFields
	"Define the fields of the DISPLAY_DEVICEW structure.

	DISPLAY_DEVICEW compileDefinition

		typedef [uuid(b21c0d9e-8924-4788-ad73-e7751f9f1c6b)]
		struct tagDISPLAY_DEVICEW {
			[restricted, helpstring('The size of the structure, in bytes.')] DWORD dwSize;
			[readonly, helpstring('An array of characters identifying the device name. This is either the adapter device or the monitor device.'), string] unsigned short DeviceName[32];
			[readonly, helpstring('An array of characters containing the device context string. This is either a description of the display adapter or of the display monitor.'), string] unsigned short DeviceString[128];
			[readonly, helpstring('Device state flags.')] DWORD StateFlags;
			[readonly, string] unsigned short DeviceID[128];
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] unsigned short DeviceKey[128];
		} DISPLAY_DEVICEW;
"

	self
		defineField: #dwSize type: DWORDField new beWriteOnly offset: 0;
		defineField: #DeviceName type: (StringField type: Utf16String length: 32) beReadOnly offset: 4;
		defineField: #DeviceString type: (StringField type: Utf16String length: 128) beReadOnly offset: 68;
		defineField: #StateFlags type: DWORDField new beReadOnly offset: 324;
		defineField: #DeviceID type: (StringField type: Utf16String length: 128) beReadOnly offset: 328;
		defineField: #DeviceKey type: (ArrayField type: WORDArray length: 128) beFiller offset: 584.
	self byteSize: 840!

getFieldNames
	^#(#dwSize #DeviceName #DeviceString #StateFlags #DeviceID)! !
!DISPLAY_DEVICEW class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

