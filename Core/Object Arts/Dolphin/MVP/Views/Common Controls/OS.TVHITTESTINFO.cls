"Filed out from Dolphin Smalltalk"!

OS.CCHITTESTINFO
	subclass: #'OS.TVHITTESTINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_flags' -> 16r8.
			'_OffsetOf_hItem' -> 16rC.
			'_TVHITTESTINFO_Size' -> 16r10
		}!

OS.TVHITTESTINFO guid: (Core.GUID fromString: '{87b4c61f-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.TVHITTESTINFO comment: 'TVHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

TVHISTTESTINFO is used for hit-testing with Tree View controls.

This Supercedes the TV_HITTESTINFO class present in release 2.1 and earlier.'!

!OS.TVHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !

!OS.TVHITTESTINFO methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a TreeView hit-test, this is tree view item handle."

	^self hItem!

hItem
	"Answer the <Integer> value of the receiver's 'hItem' field."

	^bytes uintPtrAtOffset: _OffsetOf_hItem!

item
	"Answer the 'item' which has been hit (in this case the handle of node)."

	^self hItem! !

!OS.TVHITTESTINFO categoriesForMethods!
flags!**compiled accessors**!public! !
handle!accessing!private! !
hItem!**compiled accessors**!public! !
item!accessing!public! !
!

!OS.TVHITTESTINFO class methodsFor!

byteSize
	^_TVHITTESTINFO_Size!

defineFields
	"Define the fields of the Win32 TV_HITTESTINFO structure.

		TVHITTESTINFO compileDefinition

		typedef struct _TVHITTESTINFO	tvhtst {
			POINTL		pt; 
			UINT			flags; 
			HTREEITEM	hItem;
		} TV_HITTESTINFO, FAR *LPTV_HITTESTINFO; 
	"

	super defineFields.
	self
		defineField: #flags type: UInt32Field readOnly;
		defineField: #hItem type: UIntPtrField readOnly.
	self assert: [self byteSize = 16]!

getFieldNames
	^#(#pt #flags #hItem)! !

!OS.TVHITTESTINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

