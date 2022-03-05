"Filed out from Dolphin Smalltalk"!

CCITEM subclass: #TVITEMW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cChildren _OffsetOf_cchTextMax _OffsetOf_dwState _OffsetOf_hItem _OffsetOf_iImage _OffsetOf_iSelectedImage _OffsetOf_lParam _OffsetOf_pszText _OffsetOf_stateMask'
	poolDictionaries: 'TreeViewConstants'
	classInstanceVariableNames: ''!
TVITEMW guid: (GUID fromString: '{87b4c622-026e-11d3-9fd7-00a0cc3e4a32}')!
TVITEMW addClassConstant: '_OffsetOf_cChildren' value: 16r20!
TVITEMW addClassConstant: '_OffsetOf_cchTextMax' value: 16r14!
TVITEMW addClassConstant: '_OffsetOf_dwState' value: 16r8!
TVITEMW addClassConstant: '_OffsetOf_hItem' value: 16r4!
TVITEMW addClassConstant: '_OffsetOf_iImage' value: 16r18!
TVITEMW addClassConstant: '_OffsetOf_iSelectedImage' value: 16r1C!
TVITEMW addClassConstant: '_OffsetOf_lParam' value: 16r24!
TVITEMW addClassConstant: '_OffsetOf_pszText' value: 16r10!
TVITEMW addClassConstant: '_OffsetOf_stateMask' value: 16rC!
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
		sdwordAtOffset: _OffsetOf_iImage put: I_IMAGECALLBACK;
		sdwordAtOffset: _OffsetOf_cChildren put: I_CHILDRENCALLBACK;
		dwordAtOffset: _OffsetOf_pszText put: LPSTR_TEXTCALLBACK.
	self maskIn: ##(TVIF_TEXT | TVIF_CHILDREN | TVIF_IMAGE)!

beStateExpandedOnce
	"Sets the item state to reflect that this item has already been expanded"

	self stateMaskIn: TVIS_EXPANDEDONCE.!

cChildren
	"Answer the <Integer> value of the receiver's 'cChildren' field."

	^bytes sdwordAtOffset: _OffsetOf_cChildren!

cChildren: anInteger
	"Set the receiver's 'cChildren' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cChildren put: anInteger!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: _OffsetOf_cchTextMax!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cchTextMax put: anInteger!

cchTextMaxOffset
	^_OffsetOf_cchTextMax!

children: anInteger
	"Set contents' cChildren member from anInteger"

	self cChildren: anInteger.
	self maskIn: TVIF_CHILDREN!

childrenCallback
	"Sets the receiver into children callback mode."

	self children: I_CHILDRENCALLBACK!

dwState
	"Answer the <Integer> value of the receiver's 'dwState' field."

	^bytes dwordAtOffset: _OffsetOf_dwState!

dwState: anInteger
	"Set the receiver's 'dwState' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwState put: anInteger!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure, that are valid in this particular instance."

	| mask fields |
	mask := self mask.
	fields := Array writeStream: 8.
	fields nextPutAll: #(#mask #hItem).
	#(#pszText #iImage #lParam #dwState #hItem #iSelectedImage #cChildren) inject: 1
		into: 
			[:bit :each |
			(mask allMask: bit) ifTrue: [fields nextPut: each].
			bit bitShift: 1].
	^fields contents!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self hItem!

hItem
	"Answer the <Integer> value of the receiver's 'hItem' field."

	^bytes dwordAtOffset: _OffsetOf_hItem!

hItem: anInteger
	"Set the receiver's 'hItem' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hItem put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iImage put: anInteger!

iSelectedImage
	"Answer the <Integer> value of the receiver's 'iSelectedImage' field."

	^bytes sdwordAtOffset: _OffsetOf_iSelectedImage!

iSelectedImage: anInteger
	"Set the receiver's 'iSelectedImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iSelectedImage put: anInteger!

isStateExpandedOnce
	"Answer whether the receiver has already been expanded"

	^self dwState allMask: TVIS_EXPANDEDONCE.!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

lParam: anInteger
	"Set the receiver's 'lParam' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_lParam put: anInteger!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszText put: anUtf16String yourAddress!

selectedImage: anInteger
	"Set contents' iSelectedImage member to anInteger"

	self iSelectedImage: anInteger.
	self maskIn: TVIF_SELECTEDIMAGE!

stateMask
	"Answer the <Integer> value of the receiver's 'stateMask' field."

	^bytes dwordAtOffset: _OffsetOf_stateMask!

stateMask: anInteger
	"Set the receiver's 'stateMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_stateMask put: anInteger!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^_OffsetOf_pszText! !
!TVITEMW categoriesForMethods!
allCallbacks!accessing!public! !
beStateExpandedOnce!accessing!public! !
cChildren!**compiled accessors**!public! !
cChildren:!**compiled accessors**!public! !
cchTextMax!**compiled accessors**!public! !
cchTextMax:!**compiled accessors**!public! !
cchTextMaxOffset!constants!private! !
children:!accessing!public! !
childrenCallback!accessing!public! !
dwState!**compiled accessors**!public! !
dwState:!**compiled accessors**!public! !
getValidFields!accessing!private! !
handle!accessing!public! !
hItem!**compiled accessors**!public! !
hItem:!**compiled accessors**!public! !
iImage!**compiled accessors**!public! !
iImage:!**compiled accessors**!public! !
iSelectedImage!**compiled accessors**!public! !
iSelectedImage:!**compiled accessors**!public! !
isStateExpandedOnce!public!testing! !
lParam!**compiled accessors**!public! !
lParam:!**compiled accessors**!public! !
pszText!**compiled accessors**!public! !
pszText:!**compiled accessors**!public! !
selectedImage:!accessing!public! !
stateMask!**compiled accessors**!public! !
stateMask:!**compiled accessors**!public! !
textPointerOffset!constants!private! !
!

!TVITEMW class methodsFor!

defineFields
	"Define the fields of the Win32 TVITEMW structure

		self compileDefinition
	"

	super defineFields.
	self
		defineField: #hItem
			type: DWORDField new
			offset: 4;
		defineField: #dwState
			type: DWORDField new
			offset: 8;
		defineField: #stateMask
			type: DWORDField new
			offset: 12;
		defineField: #pszText
			type: (PointerField type: Utf16String)
			offset: 16;
		defineField: #cchTextMax
			type: SDWORDField new
			offset: 20;
		defineField: #iImage
			type: SDWORDField new
			offset: 24;
		defineField: #iSelectedImage
			type: SDWORDField new
			offset: 28;
		defineField: #cChildren
			type: SDWORDField new
			offset: 32;
		defineField: #lParam
			type: UINT_PTRField new
			offset: 36.
	self assert: [self byteSize = 40]!

getFieldNames
	^#(#mask #hItem #dwState #stateMask #pszText #cchTextMax #iImage #iSelectedImage #cChildren #lParam)! !
!TVITEMW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

