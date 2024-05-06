"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #MONITORINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwFlags _OffsetOf_dwSize _OffsetOf_rcMonitor _OffsetOf_rcWork MONITORINFOF_PRIMARY'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MONITORINFO guid: (GUID fromString: '{58b4f5d6-cd16-4d5d-894d-9b158a5d9e76}')!

MONITORINFO addClassConstant: '_OffsetOf_dwFlags' value: 16r24!
MONITORINFO addClassConstant: '_OffsetOf_dwSize' value: 16r0!
MONITORINFO addClassConstant: '_OffsetOf_rcMonitor' value: 16r4!
MONITORINFO addClassConstant: '_OffsetOf_rcWork' value: 16r14!
MONITORINFO addClassConstant: 'MONITORINFOF_PRIMARY' value: 16r1!

MONITORINFO comment: '`MONITORINFO` is an `External.Structure` class to wrap the struct ''Win32.MONITORINFO'' from type information in the ''Win32 API'' library.

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

!MONITORINFO categoriesForClass!Win32-Structs! !

!MONITORINFO methodsFor!

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

!MONITORINFO categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
isPrimary!public!testing! !
rcMonitor!**compiled accessors**!public! !
rcWork!**compiled accessors**!public! !
!

!MONITORINFO class methodsFor!

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

!MONITORINFO class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

