"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #PRINTPAGERANGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PRINTPAGERANGE guid: (GUID fromString: '{7842b7d1-890a-4558-b36e-ebf17614a05b}')!
PRINTPAGERANGE comment: '<PRINTPAGERANGE> is an <ExternalStructure> class to wrap the struct ''Win32.PRINTPAGERANGE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7842B7D1-890A-4558-B36E-EBF17614A05B)]
struct tagPRINTPAGERANGE {
	DWORD nFromPage;
	DWORD nToPage;
} PRINTPAGERANGE;
'!
!PRINTPAGERANGE categoriesForClass!Win32-Structs! !
!PRINTPAGERANGE methodsFor!

nFromPage
	"Answer the receiver's nFromPage field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

nFromPage: anObject
	"Set the receiver's nFromPage field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

nToPage
	"Answer the receiver's nToPage field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

nToPage: anObject
	"Set the receiver's nToPage field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject! !
!PRINTPAGERANGE categoriesFor: #nFromPage!**compiled accessors**!public! !
!PRINTPAGERANGE categoriesFor: #nFromPage:!**compiled accessors**!public! !
!PRINTPAGERANGE categoriesFor: #nToPage!**compiled accessors**!public! !
!PRINTPAGERANGE categoriesFor: #nToPage:!**compiled accessors**!public! !

!PRINTPAGERANGE class methodsFor!

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
		defineField: #nToPage type: DWORDField new! !
!PRINTPAGERANGE class categoriesFor: #defineFields!initializing!public! !

