"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSETCOLORSPACE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRSETCOLORSPACE_Size' -> 16rC. '_OffsetOf_ihCS' -> 16r8 }!
OS.EMRSETCOLORSPACE guid: (Core.GUID fromString: '{619bf7a2-5722-4d4b-843e-a482ed1e1b39}')!
OS.EMRSETCOLORSPACE comment: '<EMRSETCOLORSPACE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETCOLORSPACE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(619BF7A2-5722-4D4B-843E-A482ED1E1B39)]
struct tagEMRSETCOLORSPACE {
	EMR EMR;
	[helpstring("ColorSpace handle index")] DWORD ihCS;
} EMRSETCOLORSPACE;
'!
!OS.EMRSETCOLORSPACE categoriesForClass!Win32-Structs! !
!OS.EMRSETCOLORSPACE methodsFor!

ihCS
	"Answer the <Integer> value of the receiver's 'ihCS' field."

	^bytes uint32AtOffset: _OffsetOf_ihCS!

ihCS: anInteger
	"Set the receiver's 'ihCS' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ihCS put: anInteger! !
!OS.EMRSETCOLORSPACE categoriesForMethods!
ihCS!**compiled accessors**!public! !
ihCS:!**compiled accessors**!public! !
!

!OS.EMRSETCOLORSPACE class methodsFor!

byteSize
	^_EMRSETCOLORSPACE_Size!

defineFields
	"Define the fields of the EMRSETCOLORSPACE structure.

	EMRSETCOLORSPACE  compileDefinition

		typedef [uuid(619BF7A2-5722-4D4B-843E-A482ED1E1B39)]
		struct tagEMRSELECTCOLORSPACE {
			EMR EMR;
			[helpstring('ColorSpace handle index')] DWORD ihCS;
		} EMRSETCOLORSPACE;
"

	super defineFields.
	self
		defineField: #ihCS
		type: UInt32Field new
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #ihCS)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETCOLORSPACE. EMR_DELETECOLORSPACE}! !
!OS.EMRSETCOLORSPACE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

