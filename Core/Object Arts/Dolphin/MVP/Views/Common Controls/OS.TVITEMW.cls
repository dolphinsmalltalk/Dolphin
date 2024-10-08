﻿"Filed out from Dolphin Smalltalk"!

OS.CCITEM
	subclass: #'OS.TVITEMW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.TreeViewConstants})
	classInstanceVariableNames: 'callbackPrototype'
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
		uint32AtOffset: _OffsetOf_pszText put: Win32Constants.LPSTR_TEXTCALLBACK.
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
	self maskSelectableFields inject: TVIF_TEXT
		into: 
			[:bit :each |
			(each notNil and: [mask allMask: bit]) ifTrue: [fields nextPut: each].
			bit bitShift: 1].
	^fields contents!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self hItem!

hItem
	"Answer the <Integer> value of the receiver's 'hItem' field."

	^bytes uintPtrAtOffset: _OffsetOf_hItem!

hItem: anInteger
	"Set the receiver's 'hItem' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_hItem put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes int32AtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iImage put: anInteger!

images: anInteger
	"Set the receiver's images (including that if selected) to that with the specified index in the tree view's image list."

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

maskSelectableFields
	^#(#pszText #iImage #lParam #dwState nil #iSelectedImage #cChildren)!

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

text: aString hasChildren: aBoolean image: anInteger
	"Initialize the receiver for setting text ,image and children count of a tree node. Note that this is only used for the #static update mode, as in #dynamic mode the data is requested by callback."

	| iImage |
	iImage := (anInteger ?? ##(I_IMAGENONE + 1)) - 1.
	text := aString displayString asUtf16String.
	bytes
		uintPtrAtOffset: _OffsetOf_pszText put: text yourAddress;
		int32AtOffset: _OffsetOf_cchTextMax put: text size + 1;
		int32AtOffset: _OffsetOf_cChildren put: aBoolean asInteger;
		int32AtOffset: _OffsetOf_iImage put: iImage;
		int32AtOffset: _OffsetOf_iSelectedImage put: iImage;
		uint32AtOffset: _OffsetOf_mask put: ##(TVIF_TEXT | TVIF_CHILDREN | TVIF_IMAGE | TVIF_SELECTEDIMAGE)!

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
maskSelectableFields!constants!private! !
pszText!**compiled accessors**!public! !
pszText:!**compiled accessors**!public! !
selectedImage:!accessing!public! !
stateMask!**compiled accessors**!public! !
stateMask:!**compiled accessors**!public! !
text:hasChildren:image:!initializing!public! !
textPointerOffset!constants!private! !
!

!OS.TVITEMW class methodsFor!

byteSize
	^_TVITEMW_Size!

callbacksForItem: anExternalHandle
	"Answer an instance of the receiver configured to request callbacks for the item text and images of the tree view item with the specified handle."

	^self basicNew
		bytes: (callbackPrototype shallowCopy
					uint32AtOffset: _OffsetOf_hItem put: anExternalHandle;
					yourself);
		yourself!

defineFields
	"Define the fields of the Win32 TVITEMW structure

		self compileDefinition
	"

	super defineFields.
	self
		defineField: #hItem type: UIntPtrField new;
		defineField: #dwState type: UInt32Field new;
		defineField: #stateMask type: UInt32Field new;
		defineField: #pszText type: (PointerField type: Utf16String);
		defineField: #cchTextMax type: Int32Field new;
		defineField: #iImage type: Int32Field new;
		defineField: #iSelectedImage type: Int32Field new;
		defineField: #cChildren type: Int32Field new;
		defineField: #lParam type: UIntPtrField new.
	self assert: [self basicByteSize = 40]!

getFieldNames
	^#(#mask #hItem #dwState #stateMask #pszText #cchTextMax #iImage #iSelectedImage #cChildren #lParam)!

hItem: anExternalHandle
	"Answer an instance of the receiver configured for the item with the specified handle."

	^self basicNew
		bytes: ((ByteArray newFixed: self byteSize)
					uint32AtOffset: _OffsetOf_hItem put: anExternalHandle;
					yourself);
		yourself!

initialize
	self initializeCallbackPrototype!

initializeCallbackPrototype
	callbackPrototype := self new
				allCallbacks;
				bytes.
	callbackPrototype beImmutableObject! !

!OS.TVITEMW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
callbacksForItem:!instance creation!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
hItem:!instance creation!public! !
initialize!class initialization!public! !
initializeCallbackPrototype!class initialization!private! !
!

