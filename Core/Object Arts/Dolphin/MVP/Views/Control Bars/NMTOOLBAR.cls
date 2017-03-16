"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTOOLBAR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTOOLBAR guid: (GUID fromString: '{87b4c629-026e-11d3-9fd7-00a0cc3e4a32}')!
NMTOOLBAR comment: 'NMTOOLBAR is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMTOOLBAR accompanies certain notifications that are sent by a Toolbar control to its parent, e.g. when a drop-down button is pressed, such as the browser history list buttons (TBN_DROPDOWN). See the Win32 documentation for further details.
'!
!NMTOOLBAR categoriesForClass!External-Data-Structured-Win32! !
!NMTOOLBAR methodsFor!

cchText
	"Answer the receiver's cchText field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchText)!

iItem
	"Answer the receiver's iItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

tbButton
	"Answer the receiver's tbButton field as a Smalltalk object."

	^TBBUTTON fromAddress: bytes yourAddress + ##(self offsetOf: #tbButton)! !
!NMTOOLBAR categoriesFor: #cchText!**compiled accessors**!public! !
!NMTOOLBAR categoriesFor: #iItem!**compiled accessors**!public! !
!NMTOOLBAR categoriesFor: #pszText!**compiled accessors**!public! !
!NMTOOLBAR categoriesFor: #tbButton!**compiled accessors**!public! !

!NMTOOLBAR class methodsFor!

defineFields
	"Define the structure template for Win32 NMTOOLBAR structure.

		NMTOOLBAR compileDefinition

	typedef struct  tagNMTOOLBAR {
		NMHDR hdr; 
		int iItem; 
		TBBUTTON tbButton; 
		int cchText; 
		LPTSTR pszText; 
	 } NMTOOLBAR;"

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #tbButton type: (StructureField type: TBBUTTON) beReadOnly;
		defineField: #cchText type: SDWORDField new beReadOnly;
		defineField: #pszText type: (PointerField type: String) beReadOnly! !
!NMTOOLBAR class categoriesFor: #defineFields!initializing!public! !

