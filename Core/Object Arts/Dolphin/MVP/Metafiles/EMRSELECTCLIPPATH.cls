"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSELECTCLIPPATH
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iMode' -> 16r8
	}!
EMRSELECTCLIPPATH guid: (GUID fromString: '{c8b98c6c-58b3-4b3c-a5c6-a65f676491c6}')!
EMRSELECTCLIPPATH comment: '<EMRSELECTCLIPPATH> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSELECTCLIPPATH'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(C8B98C6C-58B3-4B3C-A5C6-A65F676491C6)]
struct tagEMRSELECTCLIPPATH {
	EMR EMR;
	DWORD iMode;
} EMRSELECTCLIPPATH;
'!
!EMRSELECTCLIPPATH categoriesForClass!Win32-Structs! !
!EMRSELECTCLIPPATH methodsFor!

iMode
	"Answer the <Integer> value of the receiver's 'iMode' field."

	^bytes dwordAtOffset: _OffsetOf_iMode!

iMode: anInteger
	"Set the receiver's 'iMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iMode put: anInteger! !
!EMRSELECTCLIPPATH categoriesFor: #iMode!**compiled accessors**!public! !
!EMRSELECTCLIPPATH categoriesFor: #iMode:!**compiled accessors**!public! !

!EMRSELECTCLIPPATH class methodsFor!

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
			type: DWORDField new
			offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #iMode)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SELECTCLIPPATH. EMR_SETBKMODE. EMR_SETMAPMODE. EMR_SETLAYOUT. EMR_SETPOLYFILLMODE}
		, {EMR_SETROP2. EMR_SETSTRETCHBLTMODE. EMR_SETICMMODE. EMR_SETTEXTALIGN}! !
!EMRSELECTCLIPPATH class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSELECTCLIPPATH class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSELECTCLIPPATH class categoriesFor: #iTypes!constants!public! !

