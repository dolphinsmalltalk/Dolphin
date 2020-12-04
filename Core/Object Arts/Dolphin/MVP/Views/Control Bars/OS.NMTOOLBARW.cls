"Filed out from Dolphin Smalltalk 7"!

OS.NMHDR subclass: #'OS.NMTOOLBARW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cchText' -> 16r24.
		'_OffsetOf_iItem' -> 16rC.
		'_OffsetOf_pszText' -> 16r28.
		'_OffsetOf_tbButton' -> 16r10
	}!
OS.NMTOOLBARW guid: (Core.GUID fromString: '{87b4c629-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.NMTOOLBARW comment: 'NMTOOLBARW is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMTOOLBARW accompanies certain notifications that are sent by a Toolbar control to its parent, e.g. when a drop-down button is pressed, such as the browser history list buttons (TBN_DROPDOWN). See the Win32 documentation for further details.
'!
!OS.NMTOOLBARW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMTOOLBARW methodsFor!

cchText
	"Answer the <Integer> value of the receiver's 'cchText' field."

	^bytes sdwordAtOffset: _OffsetOf_cchText!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iItem!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

tbButton
	"Answer the <TBBUTTON> value of the receiver's 'tbButton' field."

	^TBBUTTON fromAddress: bytes yourAddress + _OffsetOf_tbButton! !
!OS.NMTOOLBARW categoriesFor: #cchText!**compiled accessors**!public! !
!OS.NMTOOLBARW categoriesFor: #iItem!**compiled accessors**!public! !
!OS.NMTOOLBARW categoriesFor: #pszText!**compiled accessors**!public! !
!OS.NMTOOLBARW categoriesFor: #tbButton!**compiled accessors**!public! !

!OS.NMTOOLBARW class methodsFor!

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
!OS.NMTOOLBARW class categoriesFor: #defineFields!public!template definition! !
!OS.NMTOOLBARW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

