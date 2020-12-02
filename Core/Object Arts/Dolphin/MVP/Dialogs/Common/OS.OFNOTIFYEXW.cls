"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #OFNOTIFYEXW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_lpOFN' -> 16rC.
		'_OffsetOf_pidl' -> 16r14.
		'_OffsetOf_psf' -> 16r10
	}!
OFNOTIFYEXW guid: (GUID fromString: '{4c069709-5fae-4af1-ab44-f69e79128090}')!
OFNOTIFYEXW comment: '<OFNOTIFYEX> is an <ExternalStructure> class to wrap the struct ''Win32.OFNOTIFYEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OFNOTIFYEXW categoriesForClass!Win32-Structs! !
!OFNOTIFYEXW methodsFor!

lpOFN
	"Answer the <OPENFILENAMEW> value of the receiver's 'lpOFN' field."

	^OPENFILENAMEW fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpOFN)!

pidl
	"Answer the <ExternalAddress> value of the receiver's 'pidl' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pidl) asExternalAddress!

psf
	"Answer the <ExternalAddress> value of the receiver's 'psf' field."

	^(bytes uintPtrAtOffset: _OffsetOf_psf) asExternalAddress! !
!OFNOTIFYEXW categoriesFor: #lpOFN!**compiled accessors**!public! !
!OFNOTIFYEXW categoriesFor: #pidl!**compiled accessors**!public! !
!OFNOTIFYEXW categoriesFor: #psf!**compiled accessors**!public! !

!OFNOTIFYEXW class methodsFor!

defineFields
	"Define the fields of the OFNOTIFYEX structure.

	self compileDefinition

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
		defineField: #lpOFN type: (PointerField type: OPENFILENAMEW) beReadOnly;
		defineField: #psf type: LPVOIDField readOnly;
		defineField: #pidl type: LPVOIDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #lpOFN #psf #pidl)! !
!OFNOTIFYEXW class categoriesFor: #defineFields!public!template definition! !
!OFNOTIFYEXW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

