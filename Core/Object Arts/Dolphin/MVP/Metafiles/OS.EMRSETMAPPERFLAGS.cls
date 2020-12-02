"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETMAPPERFLAGS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFlags' -> 16r8
	}!
EMRSETMAPPERFLAGS guid: (GUID fromString: '{161d7d16-953a-489a-a7f8-b02ce12b0021}')!
EMRSETMAPPERFLAGS comment: '<EMRSETMAPPERFLAGS> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETMAPPERFLAGS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(161D7D16-953A-489A-A7F8-B02CE12B0021)]
struct tagEMRSETMAPPERFLAGS {
	EMR EMR;
	DWORD dwFlags;
} EMRSETMAPPERFLAGS;
'!
!EMRSETMAPPERFLAGS categoriesForClass!Win32-Structs! !
!EMRSETMAPPERFLAGS methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger! !
!EMRSETMAPPERFLAGS categoriesFor: #dwFlags!**compiled accessors**!public! !
!EMRSETMAPPERFLAGS categoriesFor: #dwFlags:!**compiled accessors**!public! !

!EMRSETMAPPERFLAGS class methodsFor!

defineFields
	"Define the fields of the EMRSETMAPPERFLAGS structure.

	EMRSETMAPPERFLAGS  compileDefinition

		typedef [uuid(161D7D16-953A-489A-A7F8-B02CE12B0021)]
		struct tagEMRSETMAPPERFLAGS {
			EMR EMR;
			DWORD dwFlags;
		} EMRSETMAPPERFLAGS;
"

	super defineFields.
	self
		defineField: #dwFlags
			type: DWORDField new
			offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #dwFlags)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETMAPPERFLAGS}! !
!EMRSETMAPPERFLAGS class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSETMAPPERFLAGS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETMAPPERFLAGS class categoriesFor: #iTypes!constants!public! !

