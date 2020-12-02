"Filed out from Dolphin Smalltalk 7"!

CCHITTESTINFO subclass: #TVHITTESTINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hItem' -> 16rC
	}!
TVHITTESTINFO guid: (GUID fromString: '{87b4c61f-026e-11d3-9fd7-00a0cc3e4a32}')!
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
	"Answer the <Integer> value of the receiver's 'hItem' field."

	^bytes dwordAtOffset: _OffsetOf_hItem!

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
		defineField: #hItem type: DWORDField readOnly!

getFieldNames
	^#(#pt #flags #hItem)! !
!TVHITTESTINFO class categoriesFor: #defineFields!public!template definition! !
!TVHITTESTINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

