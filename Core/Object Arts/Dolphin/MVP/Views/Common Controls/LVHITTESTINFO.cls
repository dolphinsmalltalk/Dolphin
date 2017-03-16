"Filed out from Dolphin Smalltalk 7"!

CCHITTESTINFO subclass: #LVHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
LVHITTESTINFO guid: (GUID fromString: '{87b4c61e-026e-11d3-9fd7-00a0cc3e4a32}')!
LVHITTESTINFO comment: 'LVHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

LVHISTTESTINFO is used for hit-testing with Enhanced List View controls. For example usage see ListView>>itemFromPoint:

This Supercedes the LV_HITTESTINFO class present in release 2.1 and earlier.'!
!LVHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!LVHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a ListView hit-test, this is a 1-based integer index."

	^self iItem + 1!

iItem
	"Answer the receiver's iItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iSubItem
	"Answer the receiver's iSubItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)! !
!LVHITTESTINFO categoriesFor: #handle!accessing!private! !
!LVHITTESTINFO categoriesFor: #iItem!**compiled accessors**!public! !
!LVHITTESTINFO categoriesFor: #iSubItem!**compiled accessors**!public! !

!LVHITTESTINFO class methodsFor!

defineFields
	"Define the fields of the Win32 LVHITTESTINFO structure.

		LVHITTESTINFO compileDefinition

		typedef struct _LVHITTESTINFO { 
			POINT pt; 
			UINT flags; 
			int iItem; 
			int iSubItem; 
		} LVHITTESTINFO, FAR *LPLVHITTESTINFO;"

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly
! !
!LVHITTESTINFO class categoriesFor: #defineFields!development!public! !

