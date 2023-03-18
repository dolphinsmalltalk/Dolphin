"Filed out from Dolphin Smalltalk"!

OS.NMHDR
	subclass: #'OS.OFNOTIFYEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_lpOFN' -> 16rC.
			'_OffsetOf_pidl' -> 16r14.
			'_OffsetOf_psf' -> 16r10.
			'_OFNOTIFYEXW_Size' -> 16r18
		}!
OS.OFNOTIFYEXW guid: (Core.GUID fromString: '{4c069709-5fae-4af1-ab44-f69e79128090}')!
OS.OFNOTIFYEXW comment: '<OFNOTIFYEX> is an <ExternalStructure> class to wrap the struct ''Win32.OFNOTIFYEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.OFNOTIFYEXW categoriesForClass!Win32-Structs! !
!OS.OFNOTIFYEXW methodsFor!

lpOFN
	"Answer the <OPENFILENAMEW> value of the receiver's 'lpOFN' field."

	^OPENFILENAMEW fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpOFN)!

pidl
	"Answer the <ExternalAddress> value of the receiver's 'pidl' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pidl) asExternalAddress!

psf
	"Answer the <ExternalAddress> value of the receiver's 'psf' field."

	^(bytes uintPtrAtOffset: _OffsetOf_psf) asExternalAddress! !
!OS.OFNOTIFYEXW categoriesForMethods!
lpOFN!**compiled accessors**!public! !
pidl!**compiled accessors**!public! !
psf!**compiled accessors**!public! !
!

!OS.OFNOTIFYEXW class methodsFor!

byteSize
	^_OFNOTIFYEXW_Size!

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
!OS.OFNOTIFYEXW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

