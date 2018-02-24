"Filed out from Dolphin Smalltalk 7"!

CCITEM subclass: #TVITEMW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'TreeViewConstants'
	classInstanceVariableNames: ''!
TVITEMW guid: (GUID fromString: '{87b4c622-026e-11d3-9fd7-00a0cc3e4a32}')!
TVITEMW comment: 'TVITEM is an <ExternalStructure> class which represents the Windows common control structure of the same name.

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
!TVITEMW categoriesForClass!External-Data-Structured-Win32! !
!TVITEMW methodsFor!

allCallbacks
	"Set up the receiver to specify that callbacks are required for image, children count, and label text."

	bytes
		sdwordAtOffset: ##(self offsetOf: #iImage) put: I_IMAGECALLBACK;
		sdwordAtOffset: ##(self offsetOf: #cChildren) put: I_CHILDRENCALLBACK;
		dwordAtOffset: ##(self offsetOf: #pszText) put: LPSTR_TEXTCALLBACK.
	self maskIn: ##(TVIF_TEXT | TVIF_CHILDREN | TVIF_IMAGE)!

beStateExpandedOnce
	"Sets the item state to reflect that this item has already been expanded"

	self stateMaskIn: TVIS_EXPANDEDONCE.!

cChildren
	"Answer the <Integer> value of the receiver's 'cChildren' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cChildren)!

cChildren: anInteger
	"Set the receiver's 'cChildren' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cChildren) put: anInteger!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax)!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax) put: anInteger!

cchTextMaxOffset
	^##(self offsetOf: #cchTextMax)!

children: anInteger
	"Set contents' cChildren member from anInteger"

	self cChildren: anInteger.
	self maskIn: TVIF_CHILDREN!

childrenCallback
	"Sets the receiver into children callback mode."

	self children: I_CHILDRENCALLBACK!

dwState
	"Answer the <Integer> value of the receiver's 'dwState' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwState)!

dwState: anInteger
	"Set the receiver's 'dwState' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwState) put: anInteger!

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
	"Answer the <Integer> value of the receiver's 'hItem' field."

	^bytes dwordAtOffset: ##(self offsetOf: #hItem)!

hItem: anInteger
	"Set the receiver's 'hItem' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #hItem) put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anInteger!

iSelectedImage
	"Answer the <Integer> value of the receiver's 'iSelectedImage' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSelectedImage)!

iSelectedImage: anInteger
	"Set the receiver's 'iSelectedImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #iSelectedImage) put: anInteger!

isStateExpandedOnce
	"Answer whether the receiver has already been expanded"

	^self dwState allMask: TVIS_EXPANDEDONCE.!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: ##(self offsetOf: #lParam)!

lParam: anInteger
	"Set the receiver's 'lParam' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: ##(self offsetOf: #lParam) put: anInteger!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #pszText) put: anUtf16String yourAddress!

saveDetails
	"Private - Set the flag in the receiver's mask which informs the TreeView to save
	any details included in this item and not ask for them again."

	self maskIn: TVIF_DI_SETITEM!

selectedImage: anInteger
	"Set contents' iSelectedImage member to anInteger"

	self iSelectedImage: anInteger.
	self maskIn: TVIF_SELECTEDIMAGE!

stateMask
	"Answer the <Integer> value of the receiver's 'stateMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #stateMask)!

stateMask: anInteger
	"Set the receiver's 'stateMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #stateMask) put: anInteger!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^##(self offsetOf: #pszText)! !
!TVITEMW categoriesFor: #allCallbacks!accessing!public! !
!TVITEMW categoriesFor: #beStateExpandedOnce!accessing!public! !
!TVITEMW categoriesFor: #cChildren!**compiled accessors**!public! !
!TVITEMW categoriesFor: #cChildren:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #cchTextMax!**compiled accessors**!public! !
!TVITEMW categoriesFor: #cchTextMax:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #cchTextMaxOffset!constants!private! !
!TVITEMW categoriesFor: #children:!accessing!public! !
!TVITEMW categoriesFor: #childrenCallback!accessing!public! !
!TVITEMW categoriesFor: #dwState!**compiled accessors**!public! !
!TVITEMW categoriesFor: #dwState:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #getValidFields!accessing!private! !
!TVITEMW categoriesFor: #handle!accessing!public! !
!TVITEMW categoriesFor: #hItem!**compiled accessors**!public! !
!TVITEMW categoriesFor: #hItem:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #iImage!**compiled accessors**!public! !
!TVITEMW categoriesFor: #iImage:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #iSelectedImage!**compiled accessors**!public! !
!TVITEMW categoriesFor: #iSelectedImage:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #isStateExpandedOnce!public!testing! !
!TVITEMW categoriesFor: #lParam!**compiled accessors**!public! !
!TVITEMW categoriesFor: #lParam:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #pszText!**compiled accessors**!public! !
!TVITEMW categoriesFor: #pszText:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #saveDetails!accessing!private! !
!TVITEMW categoriesFor: #selectedImage:!accessing!public! !
!TVITEMW categoriesFor: #stateMask!**compiled accessors**!public! !
!TVITEMW categoriesFor: #stateMask:!**compiled accessors**!public! !
!TVITEMW categoriesFor: #textPointerOffset!constants!private! !

!TVITEMW class methodsFor!

defineFields
	"Define the fields of the Win32 TVITEMW structure

		self compileDefinition
	"

	super defineFields.
	self
		defineField: #hItem type: DWORDField new offset: 4;
		defineField: #dwState type: DWORDField new offset: 8;
		defineField: #stateMask type: DWORDField new offset: 12;
		defineField: #pszText type: (PointerField type: self textClass) offset: 16;
		defineField: #cchTextMax type: SDWORDField new offset: 20;
		defineField: #iImage type: SDWORDField new offset: 24;
		defineField: #iSelectedImage type: SDWORDField new offset: 28;
		defineField: #cChildren type: SDWORDField new offset: 32;
		defineField: #lParam type: UINT_PTRField new offset: 36.
	self assert: [self byteSize = 40]
! !
!TVITEMW class categoriesFor: #defineFields!initializing!public! !

