"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #LVCOLUMN
	instanceVariableNames: 'text'
	classVariableNames: 'AlignmentMap'
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
LVCOLUMN guid: (GUID fromString: '{87B4C5FC-026E-11D3-9FD7-00A0CC3E4A32}')!
LVCOLUMN comment: 'LVCOLUMN is an <ExternalStructure> class which represents the Windows List View common control structure of the same name.

LVCOLUMN is used in conjunction with the ListView to specify the details of individual columns when in report mode.

Instance Variables:
	text	<String> column header text whose address is stored in the structure.'!
!LVCOLUMN categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!LVCOLUMN methodsFor!

alignment: alignmentSymbol
	"Set the alignment of the text within this column to the
	value for alignmentSymbol; left, right, center"

	self format: (AlignmentMap at: alignmentSymbol)!

cchTextMax: anObject 
	"Set the receiver's cchTextMax field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax) put: anObject!

cx
	"Answer the receiver's cx field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cx)!

cx: anObject 
	"Set the receiver's cx field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cx) put: anObject!

fmt
	"Answer the receiver's fmt field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #fmt)!

fmt: anObject 
	"Set the receiver's fmt field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #fmt) put: anObject!

format: anInteger
	self fmt: anInteger; maskIn: LVCF_FMT!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anObject!

image: anIntegerIndex
	"Set the image of the column to be that with anIntegerIndex in the list view's
	image manager"

	self iImage: anIntegerIndex; maskIn: LVCF_IMAGE!

iOrder
	"Answer the receiver's iOrder field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iOrder)!

iOrder: anObject 
	"Set the receiver's iOrder field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iOrder) put: anObject!

iSubItem
	"Answer the receiver's iSubItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

iSubItem: anObject 
	"Set the receiver's iSubItem field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iSubItem) put: anObject!

mask
	"Answer the receiver's mask field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

mask: anObject 
	"Set the receiver's mask field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self mask: (self mask bitOr: anInteger)!

order: anIntegerIndex
	"Set the order of the column to be that with of anIntegerIndex within the list view"

	self order: anIntegerIndex; maskIn: LVCF_ORDER!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pszText))!

pszText: anObject 
	"Set the receiver's pszText field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pszText) put: anObject yourAddress!

text
	"Answer the text of the receiver"

	^text!

text: aString
	"Sets contents' pszMember to aString. We also hang on to it in our
	text instance var to ensure that its lifetime is sufficiently long
	for us to safely use it."

	text := aString.
	self
		pszText: aString;
		cchTextMax: aString size;
		maskIn: LVCF_TEXT
!

width: pixelWidth
	"Set the width of the column to pixelWidth."

	self cx: pixelWidth; maskIn: LVCF_WIDTH! !
!LVCOLUMN categoriesFor: #alignment:!accessing!public! !
!LVCOLUMN categoriesFor: #cchTextMax:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #cx!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #cx:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #fmt!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #fmt:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #format:!accessing!public! !
!LVCOLUMN categoriesFor: #iImage!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #iImage:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #image:!accessing!public! !
!LVCOLUMN categoriesFor: #iOrder!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #iOrder:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #iSubItem!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #iSubItem:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #mask!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #mask:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #maskIn:!accessing!public! !
!LVCOLUMN categoriesFor: #order:!accessing!public! !
!LVCOLUMN categoriesFor: #pszText!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #pszText:!**compiled accessors**!public! !
!LVCOLUMN categoriesFor: #text!accessing!public! !
!LVCOLUMN categoriesFor: #text:!accessing!public! !
!LVCOLUMN categoriesFor: #width:!accessing!public! !

!LVCOLUMN class methodsFor!

defineFields
	"Define the fields of the Win32 LVCOLUMN structure
		LVCOLUMN compileDefinition
	"

	self
		defineField: #mask type: DWORDField new;
		defineField: #fmt type: SDWORDField new;
		defineField: #cx type: SDWORDField new;
		defineField: #pszText type: (PointerField type: String);
		defineField: #cchTextMax type: SDWORDField writeOnly;
		defineField: #iSubItem type: SDWORDField new;
		defineField: #iImage type: SDWORDField new;
		defineField: #iOrder type: SDWORDField new!

fromColumn: aListViewColumn in: aListView
	"Answer an LVCOLUMN generated from aListViewColumn using the
	attributes of aListView to generate the width of the column
	if necessary."

	^self new
		text: aListViewColumn text;
		width: aListViewColumn basicWidth;
		alignment: aListViewColumn alignment;
		yourself!

initialize
	"Private - Initialize the class variables of the receiver."

	AlignmentMap := 
		##(IdentityDictionary new
			at: #left put: LVCFMT_LEFT;
			at: #right put: LVCFMT_RIGHT;
			at: #center put: LVCFMT_CENTER;
			shrink;
			yourself)! !
!LVCOLUMN class categoriesFor: #defineFields!initializing!public! !
!LVCOLUMN class categoriesFor: #fromColumn:in:!instance creation!public! !
!LVCOLUMN class categoriesFor: #initialize!development!initializing!private! !

