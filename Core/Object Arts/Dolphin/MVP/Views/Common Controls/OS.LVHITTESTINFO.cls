"Filed out from Dolphin Smalltalk"!

OS.CCHITTESTINFO subclass: #'OS.LVHITTESTINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_LVHITTESTINFO_Size' -> 16r14.
		'_OffsetOf_iItem' -> 16rC.
		'_OffsetOf_iSubItem' -> 16r10
	}!
OS.LVHITTESTINFO guid: (Core.GUID fromString: '{87b4c61e-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.LVHITTESTINFO comment: 'LVHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

LVHISTTESTINFO is used for hit-testing with Enhanced List View controls. For example usage see ListView>>itemFromPoint:

This Supercedes the LV_HITTESTINFO class present in release 2.1 and earlier.'!
!OS.LVHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.LVHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a ListView hit-test, this is a 1-based integer index."

	^self iItem + 1!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iItem!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iSubItem! !
!OS.LVHITTESTINFO categoriesForMethods!
handle!accessing!private! !
iItem!**compiled accessors**!public! !
iSubItem!**compiled accessors**!public! !
!

!OS.LVHITTESTINFO class methodsFor!

byteSize
	^_LVHITTESTINFO_Size!

defineFields
	"Define the fields of the Win32 LVHITTESTINFO structure.

		LVHITTESTINFO compileDefinition

		typedef struct _LVHITTESTINFO { 
			POINTL pt; 
			UINT flags; 
			int iItem; 
			int iSubItem; 
		} LVHITTESTINFO, FAR *LPLVHITTESTINFO;"

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly!

getFieldNames
	^#(#pt #flags #iItem #iSubItem)! !
!OS.LVHITTESTINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!development!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

