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

OS.COM.STATPROPSETSTG guid: (Core.GUID fromString: '{d84b17c5-f75e-4f3d-b9a0-dd0b1fce58b7}')!

OS.COM.STATPROPSETSTG comment: '<STATPROPSETSTG> is an <ExternalStructure> class to wrap the struct ''OBJIDL.STATPROPSETSTG'' from type information in the ''ObjIDL Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagSTATPROPSETSTG {
	GUID fmtid;
	GUID clsid;
	unsigned long grfFlags;
	FILETIME mtime;
	FILETIME ctime;
	FILETIME atime;
	unsigned long dwOSVersion;
} STATPROPSETSTG;
'!

!OS.COM.STATPROPSETSTG categoriesForClass!OBJIDL-Structs! !

!OS.COM.STATPROPSETSTG methodsFor!

atime
	"Answer the <FILETIME> value of the receiver's 'atime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_atime!

atime: aFILETIME
	"Set the receiver's 'atime' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_atime + 1)
		to: ##(_OffsetOf_atime + FILETIME._FILETIME_Size)
		startingAt: 1!

clsid
	"Answer the <GUID> value of the receiver's 'clsid' field."

	^GUID fromAddress: bytes yourAddress + _OffsetOf_clsid!

clsid: aGUID
	"Set the receiver's 'clsid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_clsid + 1)
		to: ##(_OffsetOf_clsid + GUID._GUID_Size)
		startingAt: 1!

ctime
	"Answer the <FILETIME> value of the receiver's 'ctime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ctime!

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

	^GUID fromAddress: bytes yourAddress!

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

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_mtime!

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
	
		typedef 		struct tagSTATPROPSETSTG {
			GUID fmtid;
			GUID clsid;
			unsigned long grfFlags;
			FILETIME mtime;
			FILETIME ctime;
			FILETIME atime;
			unsigned long dwOSVersion;
		} STATPROPSETSTG;

	"

	self
		defineField: #fmtid type: (StructureField type: GUID);
		defineField: #clsid type: (StructureField type: GUID);
		defineField: #grfFlags type: UInt32Field new;
		defineField: #mtime type: (StructureField type: FILETIME);
		defineField: #ctime type: (StructureField type: FILETIME);
		defineField: #atime type: (StructureField type: FILETIME);
		defineField: #dwOSVersion type: UInt32Field new!

getFieldNames
	^#(#fmtid #clsid #grfFlags #mtime #ctime #atime #dwOSVersion)! !

!OS.COM.STATPROPSETSTG class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

