"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #OFNOTIFYW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lpOFN _OffsetOf_pszFile'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OFNOTIFYW guid: (GUID fromString: '{7255745f-1034-4d61-be74-66de1d5068aa}')!
OFNOTIFYW addClassConstant: '_OffsetOf_lpOFN' value: 16rC!
OFNOTIFYW addClassConstant: '_OffsetOf_pszFile' value: 16r10!
OFNOTIFYW comment: '<OFNOTIFY> is an <ExternalStructure> class to wrap the struct ''Win32.OFNOTIFY'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7255745F-1034-4D61-BE74-66DE1D5068AA)]
struct tagOFNOTIFY {
	NMHDR hdr;
	OPENFILENAME* lpOFN;
	[helpstring("May be NULL")] LPSTR pszFile;
} OFNOTIFY;
'!
!OFNOTIFYW categoriesForClass!Win32-Structs! !
!OFNOTIFYW methodsFor!

lpOFN
	"Answer the <OPENFILENAMEW> value of the receiver's 'lpOFN' field."

	^OPENFILENAMEW fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpOFN)!

pszFile
	"Answer the <Utf16String> value of the receiver's 'pszFile' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszFile)! !
!OFNOTIFYW categoriesForMethods!
lpOFN!**compiled accessors**!public! !
pszFile!**compiled accessors**!public! !
!

!OFNOTIFYW class methodsFor!

defineFields
	"Define the fields of the OFNOTIFY structure.

	self  compileDefinition

		typedef [uuid(7255745F-1034-4D61-BE74-66DE1D5068AA)]
		struct tagOFNOTIFY {
			NMHDR hdr;
			OPENFILENAME* lpOFN;
			[helpstring('May be NULL')] LPSTR pszFile;
		} OFNOTIFY;
"

	super defineFields.
	self
		defineField: #lpOFN type: (PointerField type: OPENFILENAMEW) beReadOnly;
		defineField: #pszFile type: (PointerField type: Utf16String) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #lpOFN #pszFile)! !
!OFNOTIFYW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

