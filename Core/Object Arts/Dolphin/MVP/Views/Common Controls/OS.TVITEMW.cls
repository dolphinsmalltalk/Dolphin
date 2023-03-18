"Filed out from Dolphin Smalltalk"!

OS.CCITEM subclass: #'OS.TVITEMW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.TreeViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cChildren' -> 16r20.
		'_OffsetOf_cchTextMax' -> 16r14.
		'_OffsetOf_dwState' -> 16r8.
		'_OffsetOf_hItem' -> 16r4.
		'_OffsetOf_iImage' -> 16r18.
		'_OffsetOf_iSelectedImage' -> 16r1C.
		'_OffsetOf_lParam' -> 16r24.
		'_OffsetOf_pszText' -> 16r10.
		'_OffsetOf_stateMask' -> 16rC.
		'_TVITEMW_Size' -> 16r28
	}!
OS.TVITEMW guid: (Core.GUID fromString: '{87b4c622-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.TVITEMW comment: 'TVITEM is an <ExternalStructure> class which represents the Windows common control structure of the same name.

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
!OS.TVITEMW categoriesForClass!External-Data-Structured-Win32! !
!OS.TVITEMW methodsFor!

allCallbacks
	"Set up the receiver to specify that callbacks are required for image, children count, and label text."

	bytes
		int32AtOffset: _OffsetOf_iImage put: I_IMAGECALLBACK;
		int32AtOffset: _OffsetOf_cChildren put: I_CHILDRENCALLBACK;
		uint32AtOffset: _OffsetOf_pszText put: LPSTR_TEXTCALLBACK.
	self maskIn: ##(TVIF_TEXT | TVIF_CHILDREN | TVIF_IMAGE)!

beStateExpandedOnce
	"Sets the item state to reflect that this item has already been expanded"

	self stateMaskIn: TVIS_EXPANDEDONCE.!

cChildren
	"Answer the <Integer> value of the receiver's 'cChildren' field."

	^bytes int32AtOffset: _OffsetOf_cChildren!

cChildren: anInteger
	"Set the receiver's 'cChildren' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cChildren put: anInteger!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes int32AtOffset: _OffsetOf_cchTextMax!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cchTextMax put: anInteger!

cchTextMaxOffset
	^_OffsetOf_cchTextMax!

children: anInteger
	"Set receiver's child count to anInteger."

	bytes
		int32AtOffset: _OffsetOf_cChildren put: anInteger;
		uint32AtOffset: _OffsetOf_mask put: ((bytes uint32AtOffset: _OffsetOf_mask) bitOr: TVIF_CHILDREN)!

childrenCallback
	"Sets the receiver into children callback mode."

	self children: I_CHILDRENCALLBACK!

dwState
	"Answer the <Integer> value of the receiver's 'dwState' field."

	^bytes uint32AtOffset: _OffsetOf_dwState!

dwState: anInteger
	"Set the receiver's 'dwState' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwState put: anInteger!

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

	^bytes uint32AtOffset: _OffsetOf_hItem!

hItem: anInteger
	"Set the receiver's 'hItem' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_hItem put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes int32AtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iImage put: anInteger!

images: anInteger
	"Set the receiver's images (including that if selected) to that in the image list with the specified index."

	bytes
		int32AtOffset: _OffsetOf_iImage put: anInteger;
		int32AtOffset: _OffsetOf_iSelectedImage put: anInteger;
		uint32AtOffset: _OffsetOf_mask
			put: ((bytes uint32AtOffset: _OffsetOf_mask) bitOr: ##(TVIF_IMAGE | TVIF_SELECTEDIMAGE))!

iSelectedImage
	"Answer the <Integer> value of the receiver's 'iSelectedImage' field."

	^bytes int32AtOffset: _OffsetOf_iSelectedImage!

iSelectedImage: anInteger
	"Set the receiver's 'iSelectedImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iSelectedImage put: anInteger!

isStateExpandedOnce
	"Answer whether the receiver describes a node that has already been expanded"

	^(bytes uint32AtOffset: _OffsetOf_dwState) allMask: TVIS_EXPANDEDONCE!

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
	"Set content's iSelectedImage member to anInteger"

	bytes int32AtOffset: _OffsetOf_iSelectedImage put: anInteger.
	self maskIn: TVIF_SELECTEDIMAGE!

stateMask
	"Answer the <Integer> value of the receiver's 'stateMask' field."

	^bytes uint32AtOffset: _OffsetOf_stateMask!

stateMask: anInteger
	"Set the receiver's 'stateMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_stateMask put: anInteger!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^_OffsetOf_pszText! !
!OS.TVITEMW categoriesForMethods!
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
images:!accessing!public! !
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

!OS.TVITEMW class methodsFor!

byteSize
	^_TVITEMW_Size!

defineFields
	"Define the fields of the Win32 TVITEMW structure

		self compileDefinition
	"

	super defineFields.
	self
		defineField: #hItem
			type: UInt32Field new
			offset: 4;
		defineField: #dwState
			type: UInt32Field new
			offset: 8;
		defineField: #stateMask
			type: UInt32Field new
			offset: 12;
		defineField: #pszText
			type: (PointerField type: Utf16String)
			offset: 16;
		defineField: #cchTextMax
			type: Int32Field new
			offset: 20;
		defineField: #iImage
			type: Int32Field new
			offset: 24;
		defineField: #iSelectedImage
			type: Int32Field new
			offset: 28;
		defineField: #cChildren
			type: Int32Field new
			offset: 32;
		defineField: #lParam
			type: UIntPtrField new
			offset: 36.
	self assert: [self basicByteSize = 40]!

getFieldNames
	^#(#mask #hItem #dwState #stateMask #pszText #cchTextMax #iImage #iSelectedImage #cChildren #lParam)! !
!OS.TVITEMW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

