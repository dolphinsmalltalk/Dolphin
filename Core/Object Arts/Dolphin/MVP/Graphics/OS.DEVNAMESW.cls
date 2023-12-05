"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.DEVNAMESW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_DEVNAMESW_Size' -> 16r8.
			'_OffsetOf_wDefault' -> 16r6.
			'_OffsetOf_wDeviceOffset' -> 16r2.
			'_OffsetOf_wDriverOffset' -> 16r0.
			'_OffsetOf_wOutputOffset' -> 16r4.
			'DN_DEFAULTPRN' -> 16r1
		}!
OS.DEVNAMESW guid: (Core.GUID fromString: '{776a9e91-190a-4ea6-969c-92bc7b280ad9}')!
OS.DEVNAMESW comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!OS.DEVNAMESW categoriesForClass!IDB Goodies! !
!OS.DEVNAMESW methodsFor!

byteSize
	self isNull ifTrue: [^super byteSize].
	self isPointer
		ifTrue: 
			[| last |
			"Unfortunately the way the structure is designed, there is no 100% reliable way of determining the size. What we can do is to work out the minimum size required to hold the current data."
			last := { self wDeviceOffset. self wDriverOffset. self wOutputOffset } max * 2.
			^last + (((Ucrt wcslen: bytes yourAddress + last) + 1) * 2)].
	^bytes size!

deviceName
	^Utf16String fromAddress: bytes yourAddress + (self wDeviceOffset * 2)!

driverName
	^Utf16String fromAddress: bytes yourAddress + (self wDriverOffset * 2)!

isDefault
	^self wDefault allMask: DN_DEFAULTPRN!

outputName
	^Utf16String fromAddress: bytes yourAddress + (self wOutputOffset * 2)!

printableFields
	self isNull ifTrue: [^#()].
	^#(#driverName #deviceName #outputName #wDefault)!

wDefault
	"Answer the <Integer> value of the receiver's 'wDefault' field."

	^bytes uint16AtOffset: _OffsetOf_wDefault!

wDefault: anInteger
	"Set the receiver's 'wDefault' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wDefault put: anInteger!

wDeviceOffset
	"Answer the <Integer> value of the receiver's 'wDeviceOffset' field."

	^bytes uint16AtOffset: _OffsetOf_wDeviceOffset!

wDeviceOffset: anInteger
	"Set the receiver's 'wDeviceOffset' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wDeviceOffset put: anInteger!

wDriverOffset
	"Answer the <Integer> value of the receiver's 'wDriverOffset' field."

	^bytes uint16AtOffset: _OffsetOf_wDriverOffset!

wDriverOffset: anInteger
	"Set the receiver's 'wDriverOffset' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wDriverOffset put: anInteger!

wOutputOffset
	"Answer the <Integer> value of the receiver's 'wOutputOffset' field."

	^bytes uint16AtOffset: _OffsetOf_wOutputOffset!

wOutputOffset: anInteger
	"Set the receiver's 'wOutputOffset' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wOutputOffset put: anInteger! !
!OS.DEVNAMESW categoriesForMethods!
byteSize!public! !
deviceName!accessing!public! !
driverName!accessing!public! !
isDefault!public!testing! !
outputName!accessing!public! !
printableFields!public! !
wDefault!**compiled accessors**!public! !
wDefault:!**compiled accessors**!public! !
wDeviceOffset!**compiled accessors**!public! !
wDeviceOffset:!**compiled accessors**!public! !
wDriverOffset!**compiled accessors**!public! !
wDriverOffset:!**compiled accessors**!public! !
wOutputOffset!**compiled accessors**!public! !
wOutputOffset:!**compiled accessors**!public! !
!

!OS.DEVNAMESW class methodsFor!

byteSize
	^_DEVNAMESW_Size!

defineFields
	"Define the fields of the Win32 DEVNAMES structure.
	DEVNAMES compileDefinition
	DEVNAMES decompileDefinition
		
	typedef struct _deviNAMES
		WORD wDriverOffset;
		WORD wDeviceOffset;
		WORD wOutputOffset;
		WORD wDefault;
		// strings follow here
		} DEVNAMES"

	self
		defineField: #wDriverOffset type: UInt16Field new;
		defineField: #wDeviceOffset type: UInt16Field new;
		defineField: #wOutputOffset type: UInt16Field new;
		defineField: #wDefault type: UInt16Field new!

getFieldNames
	^#(#wDriverOffset #wDeviceOffset #wOutputOffset #wDefault)! !
!OS.DEVNAMESW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

