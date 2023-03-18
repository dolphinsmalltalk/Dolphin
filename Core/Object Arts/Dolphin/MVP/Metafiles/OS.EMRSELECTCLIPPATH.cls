"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSELECTCLIPPATH'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRSELECTCLIPPATH_Size' -> 16rC. '_OffsetOf_iMode' -> 16r8 }!
OS.EMRSELECTCLIPPATH guid: (Core.GUID fromString: '{c8b98c6c-58b3-4b3c-a5c6-a65f676491c6}')!
OS.EMRSELECTCLIPPATH comment: '<EMRSELECTCLIPPATH> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSELECTCLIPPATH'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(C8B98C6C-58B3-4B3C-A5C6-A65F676491C6)]
struct tagEMRSELECTCLIPPATH {
	EMR EMR;
	DWORD iMode;
} EMRSELECTCLIPPATH;
'!
!OS.EMRSELECTCLIPPATH categoriesForClass!Win32-Structs! !
!OS.EMRSELECTCLIPPATH methodsFor!

iMode
	"Answer the <Integer> value of the receiver's 'iMode' field."

	^bytes uint32AtOffset: _OffsetOf_iMode!

iMode: anInteger
	"Set the receiver's 'iMode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_iMode put: anInteger! !
!OS.EMRSELECTCLIPPATH categoriesForMethods!
iMode!**compiled accessors**!public! !
iMode:!**compiled accessors**!public! !
!

!OS.EMRSELECTCLIPPATH class methodsFor!

byteSize
	^_EMRSELECTCLIPPATH_Size!

defineFields
	"Define the fields of the EMRSELECTCLIPPATH structure.

	EMRSELECTCLIPPATH  compileDefinition

		typedef [uuid(C8B98C6C-58B3-4B3C-A5C6-A65F676491C6)]
		struct tagEMRSELECTCLIPPATH {
			EMR EMR;
			DWORD iMode;
		} EMRSELECTCLIPPATH;
"

	super defineFields.
	self
		defineField: #iMode
		type: UInt32Field new
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #iMode)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SELECTCLIPPATH. EMR_SETBKMODE. EMR_SETMAPMODE. EMR_SETLAYOUT. EMR_SETPOLYFILLMODE}
		, {EMR_SETROP2. EMR_SETSTRETCHBLTMODE. EMR_SETICMMODE. EMR_SETTEXTALIGN}! !
!OS.EMRSELECTCLIPPATH class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

