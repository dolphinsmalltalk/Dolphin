"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LVCOLUMNW
	instanceVariableNames: 'text'
	classVariableNames: 'AlignmentMap'
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cchTextMax' -> 16r10.
		'_OffsetOf_cx' -> 16r8.
		'_OffsetOf_cxDefault' -> 16r24.
		'_OffsetOf_cxIdeal' -> 16r28.
		'_OffsetOf_cxMin' -> 16r20.
		'_OffsetOf_fmt' -> 16r4.
		'_OffsetOf_iImage' -> 16r18.
		'_OffsetOf_iOrder' -> 16r1C.
		'_OffsetOf_iSubItem' -> 16r14.
		'_OffsetOf_mask' -> 16r0.
		'_OffsetOf_pszText' -> 16rC
	}!
LVCOLUMNW guid: (GUID fromString: '{87b4c5fc-026e-11d3-9fd7-00a0cc3e4a32}')!
LVCOLUMNW comment: 'LVCOLUMN is an <ExternalStructure> class which represents the Windows List View common control structure of the same name.

LVCOLUMN is used in conjunction with the ListView to specify the details of individual columns when in report mode.

Instance Variables:
	text	<String> column header text whose address is stored in the structure.'!
!LVCOLUMNW categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!LVCOLUMNW methodsFor!

alignment: alignmentSymbol
	"Set the alignment of the text within this column to the
	value for alignmentSymbol; left, right, center"

	self format: (AlignmentMap at: alignmentSymbol)!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cchTextMax put: anInteger!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes sdwordAtOffset: _OffsetOf_cx!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cx put: anInteger!

cxDefault
	"Answer the <Integer> value of the receiver's 'cxDefault' field."

	^bytes sdwordAtOffset: _OffsetOf_cxDefault!

cxDefault: anInteger
	"Set the receiver's 'cxDefault' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxDefault put: anInteger!

cxIdeal
	"Answer the <Integer> value of the receiver's 'cxIdeal' field."

	^bytes sdwordAtOffset: _OffsetOf_cxIdeal!

cxIdeal: anInteger
	"Set the receiver's 'cxIdeal' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxIdeal put: anInteger!

cxMin
	"Answer the <Integer> value of the receiver's 'cxMin' field."

	^bytes sdwordAtOffset: _OffsetOf_cxMin!

cxMin: anInteger
	"Set the receiver's 'cxMin' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxMin put: anInteger!

fmt
	"Answer the <Integer> value of the receiver's 'fmt' field."

	^bytes sdwordAtOffset: _OffsetOf_fmt!

fmt: anInteger
	"Set the receiver's 'fmt' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_fmt put: anInteger!

format: anInteger
	self fmt: anInteger; maskIn: LVCF_FMT!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iImage put: anInteger!

image: anIntegerIndex
	"Set the image of the column to be that with anIntegerIndex in the list view's
	image manager"

	self iImage: anIntegerIndex; maskIn: LVCF_IMAGE!

iOrder
	"Answer the <Integer> value of the receiver's 'iOrder' field."

	^bytes sdwordAtOffset: _OffsetOf_iOrder!

iOrder: anInteger
	"Set the receiver's 'iOrder' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iOrder put: anInteger!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iSubItem!

iSubItem: anInteger
	"Set the receiver's 'iSubItem' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iSubItem put: anInteger!

mask
	"Answer the <Integer> value of the receiver's 'mask' field."

	^bytes dwordAtOffset: _OffsetOf_mask!

mask: anInteger
	"Set the receiver's 'mask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_mask put: anInteger!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self mask: (self mask bitOr: anInteger)!

newTextBuffer: anInteger
	"Allocate a new text buffer for the receiver of the specified size."

	text := Utf16String newFixed: anInteger.
	self
		pszText: text;
		cchTextMax: anInteger;
		maskIn: LVCF_TEXT!

order: anIntegerIndex
	"Set the order of the column to be that with of anIntegerIndex within the list view"

	self order: anIntegerIndex; maskIn: LVCF_ORDER!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszText put: anUtf16String yourAddress!

text
	"Answer the text of the receiver"

	^text!

text: aString
	"Sets contents' pszMember to a Utf16String. We also hang on to it in our
	text instance var to ensure that its lifetime is sufficiently long
	for us to safely use it."

	text := aString displayString asUtf16String.
	self
		pszText: text;
		cchTextMax: text size;
		maskIn: LVCF_TEXT!

width: pixelWidth
	"Set the width of the column to pixelWidth."

	self cx: pixelWidth; maskIn: LVCF_WIDTH! !
!LVCOLUMNW categoriesFor: #alignment:!accessing!public! !
!LVCOLUMNW categoriesFor: #cchTextMax:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cx!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cx:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cxDefault!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cxDefault:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cxIdeal!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cxIdeal:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cxMin!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #cxMin:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #fmt!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #fmt:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #format:!accessing!public! !
!LVCOLUMNW categoriesFor: #iImage!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #iImage:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #image:!accessing!public! !
!LVCOLUMNW categoriesFor: #iOrder!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #iOrder:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #iSubItem!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #iSubItem:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #mask!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #mask:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #maskIn:!accessing!public! !
!LVCOLUMNW categoriesFor: #newTextBuffer:!helpers!public! !
!LVCOLUMNW categoriesFor: #order:!accessing!public! !
!LVCOLUMNW categoriesFor: #pszText!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #pszText:!**compiled accessors**!public! !
!LVCOLUMNW categoriesFor: #text!accessing!public! !
!LVCOLUMNW categoriesFor: #text:!accessing!public! !
!LVCOLUMNW categoriesFor: #width:!accessing!public! !

!LVCOLUMNW class methodsFor!

defineFields
	"Define the fields of the Win32 LVCOLUMNW structure
		self compileDefinition
	"

	self
		defineField: #mask type: DWORDField new offset: 0;
		defineField: #fmt type: SDWORDField new offset: 4;
		defineField: #cx type: SDWORDField new offset: 8;
		defineField: #pszText type: (PointerField type: Utf16String) offset: 12;
		defineField: #cchTextMax type: SDWORDField writeOnly offset: 16;
		defineField: #iSubItem type: SDWORDField new offset: 20;
		defineField: #iImage type: SDWORDField new offset: 24;
		defineField: #iOrder type: SDWORDField new offset: 28;
		defineField: #cxMin type: SDWORDField new offset: 32;
		defineField: #cxDefault type: SDWORDField new offset: 36;
		defineField: #cxIdeal type: SDWORDField new offset: 40.!

fromColumn: aListViewColumn in: aListView
	"Answer an LVCOLUMN generated from aListViewColumn using the
	attributes of aListView to generate the width of the column
	if necessary."

	^self new
		text: aListViewColumn text;
		width: aListViewColumn basicWidth;
		alignment: aListViewColumn alignment;
		yourself!

getFieldNames
	^#(#mask #fmt #cx #pszText #cchTextMax #iSubItem #iImage #iOrder #cxMin #cxDefault #cxIdeal)!

initialize
	"Private - Initialize the class variables of the receiver."

	AlignmentMap := 
		##(IdentityDictionary new
			at: #left put: LVCFMT_LEFT;
			at: #right put: LVCFMT_RIGHT;
			at: #center put: LVCFMT_CENTER;
			shrink;
			yourself)! !
!LVCOLUMNW class categoriesFor: #defineFields!public!template definition! !
!LVCOLUMNW class categoriesFor: #fromColumn:in:!instance creation!public! !
!LVCOLUMNW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!LVCOLUMNW class categoriesFor: #initialize!development!initializing!private! !

