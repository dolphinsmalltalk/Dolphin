"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.LVCOLUMNW'
	instanceVariableNames: 'text'
	classVariableNames: 'AlignmentMap'
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_LVCOLUMNW_Size' -> 16r2C.
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
OS.LVCOLUMNW guid: (Core.GUID fromString: '{87b4c5fc-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.LVCOLUMNW comment: 'LVCOLUMN is an <ExternalStructure> class which represents the Windows List View common control structure of the same name.

LVCOLUMN is used in conjunction with the ListView to specify the details of individual columns when in report mode.

Instance Variables:
	text	<String> column header text whose address is stored in the structure.'!
!OS.LVCOLUMNW categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!OS.LVCOLUMNW methodsFor!

alignment: alignmentSymbol
	"Set the alignment of the text within this column to the
	value for alignmentSymbol; left, right, center"

	self format: (AlignmentMap at: alignmentSymbol)!

cchTextMax: anInteger
	"Set the receiver's 'cchTextMax' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cchTextMax put: anInteger!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes int32AtOffset: _OffsetOf_cx!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cx put: anInteger!

cxDefault
	"Answer the <Integer> value of the receiver's 'cxDefault' field."

	^bytes int32AtOffset: _OffsetOf_cxDefault!

cxDefault: anInteger
	"Set the receiver's 'cxDefault' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cxDefault put: anInteger!

cxIdeal
	"Answer the <Integer> value of the receiver's 'cxIdeal' field."

	^bytes int32AtOffset: _OffsetOf_cxIdeal!

cxIdeal: anInteger
	"Set the receiver's 'cxIdeal' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cxIdeal put: anInteger!

cxMin
	"Answer the <Integer> value of the receiver's 'cxMin' field."

	^bytes int32AtOffset: _OffsetOf_cxMin!

cxMin: anInteger
	"Set the receiver's 'cxMin' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cxMin put: anInteger!

fmt
	"Answer the <Integer> value of the receiver's 'fmt' field."

	^bytes int32AtOffset: _OffsetOf_fmt!

fmt: anInteger
	"Set the receiver's 'fmt' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_fmt put: anInteger!

format: anInteger
	self fmt: anInteger; maskIn: LVCF_FMT!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes int32AtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iImage put: anInteger!

image: anIntegerIndex
	"Set the image of the column to be that with anIntegerIndex in the list view's
	image manager"

	self iImage: anIntegerIndex; maskIn: LVCF_IMAGE!

iOrder
	"Answer the <Integer> value of the receiver's 'iOrder' field."

	^bytes int32AtOffset: _OffsetOf_iOrder!

iOrder: anInteger
	"Set the receiver's 'iOrder' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iOrder put: anInteger!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes int32AtOffset: _OffsetOf_iSubItem!

iSubItem: anInteger
	"Set the receiver's 'iSubItem' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iSubItem put: anInteger!

mask
	"Answer the <Integer> value of the receiver's 'mask' field."

	^bytes uint32AtOffset: _OffsetOf_mask!

mask: anInteger
	"Set the receiver's 'mask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_mask put: anInteger!

maskIn: anInteger
	"OR in to receiver's mask field the bit flags represented by anInteger"

	bytes uint32AtOffset: _OffsetOf_mask put: ((bytes uint32AtOffset: _OffsetOf_mask) bitOr: anInteger)!

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

setColumn: aListViewColumn
	text := aListViewColumn text displayString asUtf16String.
	self
		pszText: text;
		cchTextMax: text size;
		cx: aListViewColumn basicWidth;
		fmt: (AlignmentMap at: aListViewColumn alignment);
		mask: ##(LVCF_TEXT | LVCF_WIDTH | LVCF_FMT).
	^self!

text
	"Answer the text of the receiver"

	^text!

text: aString
	"Sets receiver's pszMember field to a Utf16String. We also hang on to it in our
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
!OS.LVCOLUMNW categoriesForMethods!
alignment:!accessing!public! !
cchTextMax:!**compiled accessors**!public! !
cx!**compiled accessors**!public! !
cx:!**compiled accessors**!public! !
cxDefault!**compiled accessors**!public! !
cxDefault:!**compiled accessors**!public! !
cxIdeal!**compiled accessors**!public! !
cxIdeal:!**compiled accessors**!public! !
cxMin!**compiled accessors**!public! !
cxMin:!**compiled accessors**!public! !
fmt!**compiled accessors**!public! !
fmt:!**compiled accessors**!public! !
format:!accessing!public! !
iImage!**compiled accessors**!public! !
iImage:!**compiled accessors**!public! !
image:!accessing!public! !
iOrder!**compiled accessors**!public! !
iOrder:!**compiled accessors**!public! !
iSubItem!**compiled accessors**!public! !
iSubItem:!**compiled accessors**!public! !
mask!**compiled accessors**!public! !
mask:!**compiled accessors**!public! !
maskIn:!accessing!public! !
newTextBuffer:!helpers!public! !
order:!accessing!public! !
pszText!**compiled accessors**!public! !
pszText:!**compiled accessors**!public! !
setColumn:!initializing!private! !
text!accessing!public! !
text:!accessing!public! !
width:!accessing!public! !
!

!OS.LVCOLUMNW class methodsFor!

byteSize
	^_LVCOLUMNW_Size!

defineFields
	"Define the fields of the Win32 LVCOLUMNW structure
		self compileDefinition
	"

	self
		defineField: #mask
			type: UInt32Field new
			offset: 0;
		defineField: #fmt
			type: Int32Field new
			offset: 4;
		defineField: #cx
			type: Int32Field new
			offset: 8;
		defineField: #pszText
			type: (PointerField type: Utf16String)
			offset: 12;
		defineField: #cchTextMax
			type: Int32Field writeOnly
			offset: 16;
		defineField: #iSubItem
			type: Int32Field new
			offset: 20;
		defineField: #iImage
			type: Int32Field new
			offset: 24;
		defineField: #iOrder
			type: Int32Field new
			offset: 28;
		defineField: #cxMin
			type: Int32Field new
			offset: 32;
		defineField: #cxDefault
			type: Int32Field new
			offset: 36;
		defineField: #cxIdeal
			type: Int32Field new
			offset: 40!

fromColumn: aListViewColumn
	^self newBuffer setColumn: aListViewColumn!

getFieldNames
	^#(#mask #fmt #cx #pszText #cchTextMax #iSubItem #iImage #iOrder #cxMin #cxDefault #cxIdeal)!

initialize
	"Private - Initialize the class variables of the receiver."

	AlignmentMap := ##(IdentityDictionary new
				at: #left put: LVCFMT_LEFT;
				at: #right put: LVCFMT_RIGHT;
				at: #center put: LVCFMT_CENTER;
				shrink;
				yourself)! !
!OS.LVCOLUMNW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromColumn:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!initializing!private! !
!

