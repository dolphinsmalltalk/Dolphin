"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.PRINTPAGERANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_nFromPage' -> 16r0.
		'_OffsetOf_nToPage' -> 16r4
	}!
OS.PRINTPAGERANGE guid: (Core.GUID fromString: '{7842b7d1-890a-4558-b36e-ebf17614a05b}')!
OS.PRINTPAGERANGE comment: '<PRINTPAGERANGE> is an <ExternalStructure> class to wrap the struct ''Win32.PRINTPAGERANGE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7842B7D1-890A-4558-B36E-EBF17614A05B)]
struct tagPRINTPAGERANGE {
	DWORD nFromPage;
	DWORD nToPage;
} PRINTPAGERANGE;
'!
!OS.PRINTPAGERANGE categoriesForClass!Win32-Structs! !
!OS.PRINTPAGERANGE methodsFor!

nFromPage
	"Answer the <Integer> value of the receiver's 'nFromPage' field."

	^bytes dwordAtOffset: _OffsetOf_nFromPage!

nFromPage: anInteger
	"Set the receiver's 'nFromPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nFromPage put: anInteger!

nToPage
	"Answer the <Integer> value of the receiver's 'nToPage' field."

	^bytes dwordAtOffset: _OffsetOf_nToPage!

nToPage: anInteger
	"Set the receiver's 'nToPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nToPage put: anInteger! !
!OS.PRINTPAGERANGE categoriesFor: #nFromPage!**compiled accessors**!public! !
!OS.PRINTPAGERANGE categoriesFor: #nFromPage:!**compiled accessors**!public! !
!OS.PRINTPAGERANGE categoriesFor: #nToPage!**compiled accessors**!public! !
!OS.PRINTPAGERANGE categoriesFor: #nToPage:!**compiled accessors**!public! !

!OS.PRINTPAGERANGE class methodsFor!

defineFields
	"Define the fields of the PRINTPAGERANGE structure.

	PRINTPAGERANGE  compileDefinition

		typedef [uuid(7842B7D1-890A-4558-B36E-EBF17614A05B)]
		struct tagPRINTPAGERANGE {
			DWORD nFromPage;
			DWORD nToPage;
		} PRINTPAGERANGE;
"

	self
		defineField: #nFromPage type: DWORDField new;
		defineField: #nToPage type: DWORDField new!

getFieldNames
	^#(#nFromPage #nToPage)! !
!OS.PRINTPAGERANGE class categoriesFor: #defineFields!public!template definition! !
!OS.PRINTPAGERANGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

