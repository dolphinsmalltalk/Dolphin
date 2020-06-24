"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRSETBKCOLOR
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_crColor'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETBKCOLOR guid: (GUID fromString: '{22221f37-ae5e-4040-aa50-03d7ca9f82cb}')!
EMRSETBKCOLOR addClassConstant: '_OffsetOf_crColor' value: 16r8!
EMRSETBKCOLOR comment: '<EMRSETBKCOLOR> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETBKCOLOR'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(22221F37-AE5E-4040-AA50-03D7CA9F82CB)]
struct tagEMRSETBKCOLOR {
	EMR EMR;
	COLORREF crColor;
} EMRSETBKCOLOR;
'!
!EMRSETBKCOLOR categoriesForClass!Win32-Structs! !
!EMRSETBKCOLOR methodsFor!

crColor
	"Answer the <Integer> value of the receiver's 'crColor' field."

	^bytes dwordAtOffset: _OffsetOf_crColor!

crColor: anInteger
	"Set the receiver's 'crColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_crColor put: anInteger! !
!EMRSETBKCOLOR categoriesFor: #crColor!**compiled accessors**!public! !
!EMRSETBKCOLOR categoriesFor: #crColor:!**compiled accessors**!public! !

!EMRSETBKCOLOR class methodsFor!

defineFields
	"Define the fields of the EMRSETBKCOLOR structure.

	EMRSETBKCOLOR  compileDefinition

		typedef [uuid(22221F37-AE5E-4040-AA50-03D7CA9F82CB)]
		struct tagEMRSETBKCOLOR {
			EMR EMR;
			COLORREF crColor;
		} EMRSETBKCOLOR;
"

	super defineFields.
	self
		defineField: #crColor
			type: DWORDField new
			offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #crColor)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SETBKCOLOR. EMR_SETTEXTCOLOR}! !
!EMRSETBKCOLOR class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!EMRSETBKCOLOR class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRSETBKCOLOR class categoriesFor: #iTypes!constants!public! !

