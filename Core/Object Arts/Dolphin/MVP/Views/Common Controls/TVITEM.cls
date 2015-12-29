"Filed out from Dolphin Smalltalk X6.1"!

CCITEM subclass: #TVITEM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'TreeViewConstants'
	classInstanceVariableNames: ''!
TVITEM guid: (GUID fromString: '{87B4C622-026E-11D3-9FD7-00A0CC3E4A32}')!
TVITEM comment: 'TVITEM is an <ExternalStructure> class which represents the Windows common control structure of the same name.

TVITEM is used to communicate information about the items (nodes) in a Tree View control such as the text, icon, state, etc.

    typedef [uuid(87B4C622-026E-11D3-9FD7-00A0CC3E4A32)] struct TVITEM {
        UINT      mask;
        HTREEITEM hItem;
        UINT      state;
        UINT      stateMask;
        LPTSTR		pszText;
        int       cchTextMax;
        int       iImage;
        int       iSelectedImage;
        int       cChildren;
        LPARAM	lParam;
    } TVITEM;'!
!TVITEM categoriesForClass!External-Data-Structured-Win32! !
!TVITEM methodsFor!

allCallbacks
	"Set up the receiver to specify that callbacks are required for image, children count, and label text."

	self iImage: I_IMAGECALLBACK.
	self cChildren: I_CHILDRENCALLBACK.
	bytes dwordAtOffset: self textPointerOffset put: LPSTR_TEXTCALLBACK.
	self maskIn: ##(TVIF_TEXT | TVIF_CHILDREN | TVIF_IMAGE)!

beStateExpandedOnce
	"Sets the item state to reflect that this item has already been expanded"

	self stateMaskIn: TVIS_EXPANDEDONCE.!

cChildren
	"Answer the receiver's cChildren field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cChildren)!

cChildren: anObject 
	"Set the receiver's cChildren field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cChildren) put: anObject!

cchTextMaxOffset
	^20!

children: anInteger
	"Set contents' cChildren member from anInteger"

	self cChildren: anInteger.
	self maskIn: TVIF_CHILDREN!

childrenCallback
	"Sets the receiver into children callback mode."

	self children: I_CHILDRENCALLBACK!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwState)!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwState) put: anObject!

dwStateOffset
	^8!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure, that are valid in this particular instance."

	| mask bit notValid |
	mask := self mask.
	bit := 1.
	notValid := #(#pszText #iImage #lParam #dwState #hItem #iSelectedImage #cChildren) 
				reject: 
					[:each | 
					| maskedIn |
					maskedIn := mask allMask: bit.
					bit := bit bitShift: 1.
					maskedIn].
	notValid first == #pszText ifTrue: [notValid := notValid copyWith: #cchTextMax].
	^super getValidFields reject: [:each | notValid includes: each]!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self hItem!

hItem
	"Answer the receiver's hItem field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #hItem)!

hItem: anObject 
	"Set the receiver's hItem field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hItem) put: anObject!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anObject!

iImageOffset
	^24!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^TVIF_IMAGE!

iSelectedImage
	"Answer the receiver's iSelectedImage field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSelectedImage)!

iSelectedImage: anObject 
	"Set the receiver's iSelectedImage field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iSelectedImage) put: anObject!

isStateExpandedOnce
	"Answer whether the receiver has already been expanded"

	^self dwState allMask: TVIS_EXPANDEDONCE.!

lParamOffset
	"    typedef [uuid(87B4C622-026E-11D3-9FD7-00A0CC3E4A32)] struct TVITEM {
        UINT      mask;
        HTREEITEM hItem;
        UINT      state;
        UINT      stateMask;
        LPTSTR		pszText;
        int       cchTextMax;
        int       iImage;
        int       iSelectedImage;
        int       cChildren;
        LPARAM	lParam;
    } TVITEM;"

	^##(4 + VMConstants.IntPtrSize + 4 + 4 + VMConstants.IntPtrSize + 4 + 4 + 4 + 4)!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the lParam
	field has valid contents."

	^TVIF_PARAM!

saveDetails
	"Private - Set the flag in the receiver's mask which informs the TreeView to save
	any details included in this item and not ask for them again."

	self maskIn: TVIF_DI_SETITEM!

selectedImage: anInteger
	"Set contents' iSelectedImage member to anInteger"

	self iSelectedImage: anInteger.
	self maskIn: TVIF_SELECTEDIMAGE!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #stateMask)!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #stateMask) put: anObject!

stateMaskOffset
	^12!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	^TVIF_STATE!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^16!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^TVIF_TEXT! !
!TVITEM categoriesFor: #allCallbacks!accessing!public! !
!TVITEM categoriesFor: #beStateExpandedOnce!accessing!public! !
!TVITEM categoriesFor: #cChildren!**compiled accessors**!public! !
!TVITEM categoriesFor: #cChildren:!**compiled accessors**!public! !
!TVITEM categoriesFor: #cchTextMaxOffset!constants!private! !
!TVITEM categoriesFor: #children:!accessing!public! !
!TVITEM categoriesFor: #childrenCallback!accessing!public! !
!TVITEM categoriesFor: #dwState!**compiled accessors**!public! !
!TVITEM categoriesFor: #dwState:!**compiled accessors**!public! !
!TVITEM categoriesFor: #dwStateOffset!constants!private! !
!TVITEM categoriesFor: #getValidFields!accessing!private! !
!TVITEM categoriesFor: #handle!accessing!public! !
!TVITEM categoriesFor: #hItem!**compiled accessors**!public! !
!TVITEM categoriesFor: #hItem:!**compiled accessors**!public! !
!TVITEM categoriesFor: #iImage!**compiled accessors**!public! !
!TVITEM categoriesFor: #iImage:!**compiled accessors**!public! !
!TVITEM categoriesFor: #iImageOffset!constants!private! !
!TVITEM categoriesFor: #imageValidMask!constants!private! !
!TVITEM categoriesFor: #iSelectedImage!**compiled accessors**!public! !
!TVITEM categoriesFor: #iSelectedImage:!**compiled accessors**!public! !
!TVITEM categoriesFor: #isStateExpandedOnce!public!testing! !
!TVITEM categoriesFor: #lParamOffset!constants!private! !
!TVITEM categoriesFor: #paramValidMask!constants!private! !
!TVITEM categoriesFor: #saveDetails!accessing!private! !
!TVITEM categoriesFor: #selectedImage:!accessing!public! !
!TVITEM categoriesFor: #stateMask!**compiled accessors**!public! !
!TVITEM categoriesFor: #stateMask:!**compiled accessors**!public! !
!TVITEM categoriesFor: #stateMaskOffset!constants!private! !
!TVITEM categoriesFor: #stateValidMask!constants!private! !
!TVITEM categoriesFor: #textPointerOffset!constants!private! !
!TVITEM categoriesFor: #textValidMask!constants!private! !

!TVITEM class methodsFor!

defineFields
	"Define the fields of the Win32 TVITEM structure

		TVITEM compileDefinition
	"

	super defineFields.
	self
		defineField: #hItem type: DWORDField new;
		defineField: #dwState type: DWORDField new;
		defineField: #stateMask type: DWORDField new;
		defineField: #pszText type: (PointerField type: String) beUncompiled;
		defineField: #cchTextMax type: SDWORDField uncompiled;
		defineField: #iImage type: SDWORDField new;
		defineField: #iSelectedImage type: SDWORDField new;
		defineField: #cChildren type: SDWORDField new;
		defineField: #lParam type: UINT_PTRField uncompiled.
	self assert: [(self offsetOf: #pszText) = 16]! !
!TVITEM class categoriesFor: #defineFields!initializing!public! !

