"Filed out from Dolphin Smalltalk X6.1"!

CCHITTESTINFO subclass: #TVHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TVHITTESTINFO guid: (GUID fromString: '{87B4C61F-026E-11D3-9FD7-00A0CC3E4A32}')!
TVHITTESTINFO comment: 'TVHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

TVHISTTESTINFO is used for hit-testing with Tree View controls.

This Supercedes the TV_HITTESTINFO class present in release 2.1 and earlier.'!
!TVHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!TVHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a TreeView hit-test, this is tree view item handle."

	^self hItem!

hItem
	"Answer the receiver's hItem field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #hItem)!

item
	"Answer the 'item' which has been hit (in this case the handle of node)."

	^self hItem! !
!TVHITTESTINFO categoriesFor: #handle!accessing!private! !
!TVHITTESTINFO categoriesFor: #hItem!**compiled accessors**!public! !
!TVHITTESTINFO categoriesFor: #item!accessing!public! !

!TVHITTESTINFO class methodsFor!

defineFields
	"Define the fields of the Win32 TV_HITTESTINFO structure.

		TVHITTESTINFO compileDefinition

		typedef struct _TVHITTESTINFO	tvhtst {
			POINT		pt; 
			UINT			flags; 
			HTREEITEM	hItem;
		} TV_HITTESTINFO, FAR *LPTV_HITTESTINFO; 
	"

	super defineFields.
	self
		defineField: #hItem type: DWORDField readOnly! !
!TVHITTESTINFO class categoriesFor: #defineFields!initializing!public! !

