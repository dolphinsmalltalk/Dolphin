"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTOOLBARW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTOOLBARW guid: (GUID fromString: '{87b4c629-026e-11d3-9fd7-00a0cc3e4a32}')!
NMTOOLBARW comment: 'NMTOOLBARW is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMTOOLBARW accompanies certain notifications that are sent by a Toolbar control to its parent, e.g. when a drop-down button is pressed, such as the browser history list buttons (TBN_DROPDOWN). See the Win32 documentation for further details.
'!
!NMTOOLBARW categoriesForClass!External-Data-Structured-Win32! !
!NMTOOLBARW methodsFor!

cchText
	"Answer the <Integer> value of the receiver's 'cchText' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchText)!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

tbButton
	"Answer the <TBBUTTON> value of the receiver's 'tbButton' field."

	^TBBUTTON fromAddress: bytes yourAddress + ##(self offsetOf: #tbButton)! !
!NMTOOLBARW categoriesFor: #cchText!**compiled accessors**!public! !
!NMTOOLBARW categoriesFor: #iItem!**compiled accessors**!public! !
!NMTOOLBARW categoriesFor: #pszText!**compiled accessors**!public! !
!NMTOOLBARW categoriesFor: #tbButton!**compiled accessors**!public! !

!NMTOOLBARW class methodsFor!

defineFields
	"Define the structure template for Win32 NMTOOLBARW structure.

		self compileDefinition

	typedef struct  tagNMTOOLBARW {
		NMHDR hdr; 
		int iItem; 
		TBBUTTON tbButton; 
		int cchText; 
		LPWSTR pszText; 
	 } NMTOOLBARw;"

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #tbButton type: (StructureField type: TBBUTTON) beReadOnly;
		defineField: #cchText type: SDWORDField new beReadOnly;
		defineField: #pszText type: (PointerField type: Utf16String) beReadOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iItem #tbButton #cchText #pszText)! !
!NMTOOLBARW class categoriesFor: #defineFields!initializing!public! !
!NMTOOLBARW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

