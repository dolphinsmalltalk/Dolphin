"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.MONITORINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_MONITORINFO_Size' -> 16r28.
		'_OffsetOf_dwFlags' -> 16r24.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_rcMonitor' -> 16r4.
		'_OffsetOf_rcWork' -> 16r14.
		'MONITORINFOF_PRIMARY' -> 16r1
	}!
OS.MONITORINFO guid: (Core.GUID fromString: '{58b4f5d6-cd16-4d5d-894d-9b158a5d9e76}')!
OS.MONITORINFO comment: '`MONITORINFO` is an `External.Structure` class to wrap the struct ''Win32.MONITORINFO'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(58b4f5d6-cd16-4d5d-894d-9b158a5d9e76)]
struct tagMONITORINFO {
	[restricted, helpstring("The size of the structure, in bytes.")] DWORD dwSize;
	[readonly, helpstring("Specifies the display monitor rectangle, expressed in virtual-screen coordinates")] RECT rcMonitor;
	[readonly, helpstring("Specifies the work area rectangle of the display monitor, expressed in virtual-screen coordinates.")] RECT rcWork;
	[readonly, helpstring("A set of flags that represent attributes of the display monitor.")] DWORD dwFlags;
} MONITORINFO;
```
'!
!OS.MONITORINFO categoriesForClass!Win32-Structs! !
!OS.MONITORINFO methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

isPrimary
	"Answer whether the receiver represents the primary/main monitor."

	^self dwFlags allMask: MONITORINFOF_PRIMARY!

rcMonitor
	"Answer the <RECTL> value of the receiver's 'rcMonitor' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcMonitor!

rcWork
	"Answer the <RECTL> value of the receiver's 'rcWork' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcWork! !
!OS.MONITORINFO categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
isPrimary!public!testing! !
rcMonitor!**compiled accessors**!public! !
rcWork!**compiled accessors**!public! !
!

!OS.MONITORINFO class methodsFor!

byteSize
	^_MONITORINFO_Size!

defineFields
	"Define the fields of the MONITORINFO structure.

	MONITORINFO compileDefinition

		typedef [uuid(58b4f5d6-cd16-4d5d-894d-9b158a5d9e76)]
		struct tagMONITORINFO {
			[restricted, helpstring('The size of the structure, in bytes.')] DWORD dwSize;
			[readonly, helpstring('Specifies the display monitor rectangle, expressed in virtual-screen coordinates')] RECT rcMonitor;
			[readonly, helpstring('Specifies the work area rectangle of the display monitor, expressed in virtual-screen coordinates.')] RECT rcWork;
			[readonly, helpstring('A set of flags that represent attributes of the display monitor.')] DWORD dwFlags;
		} MONITORINFO;
"

	self
		defineField: #dwSize type: DWORDField new beWriteOnly offset: 0;
		defineField: #rcMonitor type: (StructureField type: RECTL) beReadOnly offset: 4;
		defineField: #rcWork type: (StructureField type: RECTL) beReadOnly offset: 20;
		defineField: #dwFlags type: DWORDField new beReadOnly offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#dwSize #rcMonitor #rcWork #dwFlags)! !
!OS.MONITORINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

