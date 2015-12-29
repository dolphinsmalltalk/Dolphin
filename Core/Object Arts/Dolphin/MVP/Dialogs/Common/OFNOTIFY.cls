"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #OFNOTIFY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OFNOTIFY guid: (GUID fromString: '{7255745F-1034-4D61-BE74-66DE1D5068AA}')!
OFNOTIFY comment: '<OFNOTIFY> is an <ExternalStructure> class to wrap the struct ''Win32.OFNOTIFY'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OFNOTIFY categoriesForClass!Win32-Structs! !
!OFNOTIFY methodsFor!

lpOFN
	"Answer the receiver's lpOFN field as a Smalltalk object."

	^OPENFILENAME fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpOFN))!

pszFile
	"Answer the receiver's pszFile field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszFile))! !
!OFNOTIFY categoriesFor: #lpOFN!**compiled accessors**!public! !
!OFNOTIFY categoriesFor: #pszFile!**compiled accessors**!public! !

!OFNOTIFY class methodsFor!

defineFields
	"Define the fields of the OFNOTIFY structure.

	OFNOTIFY  compileDefinition

		typedef [uuid(7255745F-1034-4D61-BE74-66DE1D5068AA)]
		struct tagOFNOTIFY {
			NMHDR hdr;
			OPENFILENAME* lpOFN;
			[helpstring('May be NULL')] LPSTR pszFile;
		} OFNOTIFY;
"

	super defineFields.
	self
		defineField: #lpOFN type: (PointerField type: OPENFILENAME) beReadOnly;
		defineField: #pszFile type: (PointerField type: String) beReadOnly! !
!OFNOTIFY class categoriesFor: #defineFields!initializing!public! !

