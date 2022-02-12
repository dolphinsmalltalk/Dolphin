"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRSETMAPPERFLAGS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRSETMAPPERFLAGS_Size' -> 16rC.
		'_OffsetOf_dwFlags' -> 16r8
	}!
OS.EMRSETMAPPERFLAGS guid: (Core.GUID fromString: '{161d7d16-953a-489a-a7f8-b02ce12b0021}')!
OS.EMRSETMAPPERFLAGS comment: '<EMRSETMAPPERFLAGS> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETMAPPERFLAGS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(161D7D16-953A-489A-A7F8-B02CE12B0021)]
struct tagEMRSETMAPPERFLAGS {
	EMR EMR;
	DWORD dwFlags;
} EMRSETMAPPERFLAGS;
'!
!OS.EMRSETMAPPERFLAGS categoriesForClass!Win32-Structs! !
!OS.EMRSETMAPPERFLAGS methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger! !
!OS.EMRSETMAPPERFLAGS categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
!

!OS.EMRSETMAPPERFLAGS class methodsFor!

byteSize
	^_EMRSETMAPPERFLAGS_Size!

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
!OS.EMRSETMAPPERFLAGS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

