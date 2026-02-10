"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.STATPROPSETSTG'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_atime' -> 16r34.
			'_OffsetOf_clsid' -> 16r10.
			'_OffsetOf_ctime' -> 16r2C.
			'_OffsetOf_dwOSVersion' -> 16r3C.
			'_OffsetOf_fmtid' -> 16r0.
			'_OffsetOf_grfFlags' -> 16r20.
			'_OffsetOf_mtime' -> 16r24.
			'_STATPROPSETSTG_Size' -> 16r40
		}!

OS.COM.STATPROPSETSTG guid: (Core.GUID fromString: '{457a3996-9c69-41cf-8ded-aeca7d71db71}')!

OS.COM.STATPROPSETSTG comment: '`STATPROPSETSTG` is an `External.Structure` class to represent the Win32/COM Property Storage structure of the same name.

The STATPROPSETSTG structure contains information about a property set. To get this information, call IPropertyStorage::Stat, which fills in a buffer containing the information describing the current property set. To enumerate the STATPROPSETSTG structures for the property sets in the current property-set storage, call IPropertySetStorage::Enum to get a pointer to an enumerator. You can then call the enumeration methods of the IEnumSTATPROPSETSTG interface on the enumerator.

IDL definition follows:
```
typedef 
struct tagSTATPROPSETSTG {
	GUID fmtid;
	GUID clsid;
	DWORD grfFlags;
	FILETIME mtime;
	FILETIME ctime;
	FILETIME atime;
	DWORD dwOSVersion;
} STATPROPSETSTG;
```
'!

!OS.COM.STATPROPSETSTG categoriesForClass!Win32-Structs! !

!OS.COM.STATPROPSETSTG methodsFor!

atime
	"Answer the <FILETIME> value of the receiver's 'atime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_atime owner: self fieldOwner!

atime: aFILETIME
	"Set the receiver's 'atime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_atime + 1)
		to: ##(_OffsetOf_atime + FILETIME._FILETIME_Size)
		startingAt: 1!

clsid
	"Answer the <CLSID> value of the receiver's 'clsid' field."

	^CLSID fromAddress: bytes yourAddress + _OffsetOf_clsid owner: self fieldOwner!

clsid: aCLSID
	"Set the receiver's 'clsid' field to the value of the argument, aCLSID"

	aCLSID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_clsid + 1)
		to: ##(_OffsetOf_clsid + CLSID._CLSID_Size)
		startingAt: 1!

ctime
	"Answer the <FILETIME> value of the receiver's 'ctime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ctime owner: self fieldOwner!

ctime: aFILETIME
	"Set the receiver's 'ctime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ctime + 1)
		to: ##(_OffsetOf_ctime + FILETIME._FILETIME_Size)
		startingAt: 1!

dwOSVersion
	"Answer the <Integer> value of the receiver's 'dwOSVersion' field."

	^bytes uint32AtOffset: _OffsetOf_dwOSVersion!

dwOSVersion: anInteger
	"Set the receiver's 'dwOSVersion' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwOSVersion put: anInteger!

fmtid
	"Answer the <GUID> value of the receiver's 'fmtid' field."

	^GUID fromAddress: bytes yourAddress owner: self fieldOwner!

fmtid: aGUID
	"Set the receiver's 'fmtid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_fmtid + 1)
		to: ##(_OffsetOf_fmtid + GUID._GUID_Size)
		startingAt: 1!

grfFlags
	"Answer the <Integer> value of the receiver's 'grfFlags' field."

	^bytes uint32AtOffset: _OffsetOf_grfFlags!

grfFlags: anInteger
	"Set the receiver's 'grfFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_grfFlags put: anInteger!

mtime
	"Answer the <FILETIME> value of the receiver's 'mtime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_mtime owner: self fieldOwner!

mtime: aFILETIME
	"Set the receiver's 'mtime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_mtime + 1)
		to: ##(_OffsetOf_mtime + FILETIME._FILETIME_Size)
		startingAt: 1! !

!OS.COM.STATPROPSETSTG categoriesForMethods!
atime!**compiled accessors**!public! !
atime:!**compiled accessors**!public! !
clsid!**compiled accessors**!public! !
clsid:!**compiled accessors**!public! !
ctime!**compiled accessors**!public! !
ctime:!**compiled accessors**!public! !
dwOSVersion!**compiled accessors**!public! !
dwOSVersion:!**compiled accessors**!public! !
fmtid!**compiled accessors**!public! !
fmtid:!**compiled accessors**!public! !
grfFlags!**compiled accessors**!public! !
grfFlags:!**compiled accessors**!public! !
mtime!**compiled accessors**!public! !
mtime:!**compiled accessors**!public! !
!

!OS.COM.STATPROPSETSTG class methodsFor!

byteSize
	^_STATPROPSETSTG_Size!

defineFields
	"Define the fields of the STATPROPSETSTG structure.

	STATPROPSETSTG compileDefinition

		typedef 
		struct tagSTATPROPSETSTG {
			GUID fmtid;
			CLSID clsid;
			DWORD grfFlags;
			FILETIME mtime;
			FILETIME ctime;
			FILETIME atime;
			DWORD dwOSVersion;
		} STATPROPSETSTG;
"

	self
		defineField: #fmtid type: (StructureField type: GUID) offset: 0;
		defineField: #clsid type: (StructureField type: CLSID) offset: 16;
		defineField: #grfFlags type: UInt32Field new offset: 32;
		defineField: #mtime type: (StructureField type: FILETIME) offset: 36;
		defineField: #ctime type: (StructureField type: FILETIME) offset: 44;
		defineField: #atime type: (StructureField type: FILETIME) offset: 52;
		defineField: #dwOSVersion type: UInt32Field new offset: 60.
	self byteSize: 64!

getFieldNames
	^#(#fmtid #clsid #grfFlags #mtime #ctime #atime #dwOSVersion)! !

!OS.COM.STATPROPSETSTG class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

