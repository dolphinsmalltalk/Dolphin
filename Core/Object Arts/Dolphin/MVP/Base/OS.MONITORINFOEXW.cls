"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.MONITORINFOEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MONITORINFOEXW_Size' -> 16r68.
			'_OffsetOf_dwFlags' -> 16r24.
			'_OffsetOf_rcMonitor' -> 16r4.
			'_OffsetOf_rcWork' -> 16r14.
			'_OffsetOf_szDevice' -> 16r28.
			'MONITORINFOF_PRIMARY' -> 16r1
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

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

isPrimary
	"Answer whether the receiver represents the primary/main monitor."

	^self dwFlags allMask: MONITORINFOF_PRIMARY!

rcWork
	"Answer the <RECTL> value of the receiver's 'rcWork' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcWork!

rectangle
	"Answer a <Rectangle> representing the total area of the monitor."

	^Graphics.Rectangle
		left: (bytes int32AtOffset: _OffsetOf_rcMonitor + RECTL._OffsetOf_left)
		top: (bytes int32AtOffset: _OffsetOf_rcMonitor + RECTL._OffsetOf_top)
		right: (bytes int32AtOffset: _OffsetOf_rcMonitor + RECTL._OffsetOf_right)
		bottom: (bytes int32AtOffset: _OffsetOf_rcMonitor + RECTL._OffsetOf_bottom)!

szDevice
	"Answer the <Utf16String> value of the receiver's 'szDevice' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szDevice!

workArea
	"Answer a <Rectangle> representing the usable area of the monitor."

	^Graphics.Rectangle
		left: (bytes int32AtOffset: _OffsetOf_rcWork + RECTL._OffsetOf_left)
		top: (bytes int32AtOffset: _OffsetOf_rcWork + RECTL._OffsetOf_top)
		right: (bytes int32AtOffset: _OffsetOf_rcWork + RECTL._OffsetOf_right)
		bottom: (bytes int32AtOffset: _OffsetOf_rcWork + RECTL._OffsetOf_bottom)! !

!OS.MONITORINFOEXW categoriesForMethods!
dwFlags!**compiled accessors**!public! !
isPrimary!public!testing! !
rcWork!**compiled accessors**!public! !
rectangle!accessing!public! !
szDevice!**compiled accessors**!public! !
workArea!accessing!public! !
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
		defineField: #rcMonitor type: (StructureField type: RECTL) beUncompiled offset: 4;
		defineField: #rcWork type: (StructureField type: RECTL) beReadOnly offset: 20;
		defineField: #dwFlags type: UInt32Field new beReadOnly offset: 36;
		defineField: #szDevice type: (StringField type: Utf16String length: 32) beReadOnly offset: 40.
	self byteSize: 104!

getFieldNames
	^#(#dwSize #rcMonitor #rcWork #dwFlags #szDevice)! !

!OS.MONITORINFOEXW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

