"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #OFNOTIFYEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OFNOTIFYEX guid: (GUID fromString: '{4c069709-5fae-4af1-ab44-f69e79128090}')!
OFNOTIFYEX comment: '<OFNOTIFYEX> is an <ExternalStructure> class to wrap the struct ''Win32.OFNOTIFYEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(4C069709-5FAE-4AF1-AB44-F69E79128090)]
struct tagOFNOTIFYEX {
	NMHDR hdr;
	OPENFILENAME* lpOFN;
	LPVOID psf;
	LPVOID pidl;
} OFNOTIFYEX;
'!
!OFNOTIFYEX categoriesForClass!Win32-Structs! !
!OFNOTIFYEX methodsFor!

lpOFN
	"Answer the receiver's lpOFN field as a Smalltalk object."

	^OPENFILENAME fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpOFN))!

pidl
	"Answer the receiver's pidl field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pidl)) asExternalAddress!

psf
	"Answer the receiver's psf field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #psf)) asExternalAddress! !
!OFNOTIFYEX categoriesFor: #lpOFN!**compiled accessors**!public! !
!OFNOTIFYEX categoriesFor: #pidl!**compiled accessors**!public! !
!OFNOTIFYEX categoriesFor: #psf!**compiled accessors**!public! !

!OFNOTIFYEX class methodsFor!

defineFields
	"Define the fields of the OFNOTIFYEX structure.

	OFNOTIFYEX  compileDefinition

		typedef [uuid(4C069709-5FAE-4AF1-AB44-F69E79128090)]
		struct tagOFNOTIFYEX {
			NMHDR hdr;
			OPENFILENAME* lpOFN;
			LPVOID psf;
			LPVOID pidl;
		} OFNOTIFYEX;
"

	super defineFields.
	self
		defineField: #lpOFN type: (PointerField type: OPENFILENAME) beReadOnly;
		defineField: #psf type: LPVOIDField readOnly;
		defineField: #pidl type: LPVOIDField readOnly! !
!OFNOTIFYEX class categoriesFor: #defineFields!initializing!public! !

