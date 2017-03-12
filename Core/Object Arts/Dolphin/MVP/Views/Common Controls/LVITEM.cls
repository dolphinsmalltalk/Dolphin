"Filed out from Dolphin Smalltalk 7"!

CCITEM subclass: #LVITEM
	instanceVariableNames: ''
	classVariableNames: 'CallbackPrototype'
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
LVITEM guid: (GUID fromString: '{87b4c620-026e-11d3-9fd7-00a0cc3e4a32}')!
LVITEM comment: 'LVITEM is an <ExternalStructure> class which represents the Windows common control structure of the same name.

LVITEM is used to communicate information about the items (rows) in a List View control such as the text, icon, state, etc.

''typedef [uuid(87B4C620-026E-11D3-9FD7-00A0CC3E4A32)]
struct tagLVITEM {
	unsigned int mask;
	int iItem;
	int iSubItem;
	unsigned int State;
	unsigned int stateMask;
	LPSTR pszText;
	int cchTextMax;
	int iImage;
	LPARAM LPARAM;
	int iIndent;
} LVITEM;
'''!
!LVITEM categoriesForClass!External-Data-Structured-Win32! !
!LVITEM methodsFor!

allCallbacks
	bytes
		sdwordAtOffset: ##(self offsetOf: #iImage) put: I_IMAGECALLBACK;
		dwordAtOffset: ##(self offsetOf: #pszText) put: LPSTR_TEXTCALLBACK.
	self maskIn: ##(LVIF_TEXT | LVIF_IMAGE)!

cchTextMaxOffset
	^24!

column: colInteger 
	self iSubItem: colInteger - 1!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwState)!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwState) put: anObject!

dwStateOffset
	^12!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self iItem + 1!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anObject!

iImageOffset
	^28!

iIndent
	"Answer the receiver's iIndent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iIndent)!

iIndent: anObject 
	"Set the receiver's iIndent field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iIndent) put: anObject!

iItem
	"Answer the receiver's iItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iItem: anObject 
	"Set the receiver's iItem field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iItem) put: anObject!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the iImage
	field has valid contents."

	^LVIF_IMAGE!

indent: widths
	"Set the number of image widths to indent the item text."

	self iIndent: widths.
	self maskIn: LVIF_INDENT!

iSubItem
	"Answer the receiver's iSubItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

iSubItem: anObject 
	"Set the receiver's iSubItem field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iSubItem) put: anObject!

lParamOffset
	"struct tagLVITEM {
		unsigned int mask;
		int iItem;
		int iSubItem;
		unsigned int State;
		unsigned int stateMask;
		LPSTR pszText;
		int cchTextMax;
		int iImage;
		LPARAM LPARAM;
		int iIndent;
	} LVITEM;"

	^##(4 + 4 + 4 + 4 + 4 + VMConstants.IntPtrSize + 4 + 4)!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the lParam
	field has valid contents."

	^LVIF_PARAM!

row: rowInteger text: aString imageIndex: imageInteger indent: indentInteger 
	| mask iImage |
	self
		iItem: rowInteger - 1;
		pszText: (text := aString).
	mask := LVIF_TEXT.
	imageInteger notNil ifTrue: [iImage := imageInteger - 1].
	indentInteger notNil 
		ifTrue: 
			[self iIndent: indentInteger.
			mask := mask bitOr: LVIF_INDENT.
			indentInteger < 0 ifTrue: [iImage := -1]].
	iImage notNil 
		ifTrue: 
			[self iImage: iImage.
			mask := mask bitOr: LVIF_IMAGE].
	self mask: mask!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #stateMask)!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #stateMask) put: anObject!

stateMaskOffset
	^16!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	^LVIF_STATE!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^##(self offsetOf: #pszText)!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^LVIF_TEXT! !
!LVITEM categoriesFor: #allCallbacks!accessing!public! !
!LVITEM categoriesFor: #cchTextMaxOffset!constants!private! !
!LVITEM categoriesFor: #column:!accessing!public! !
!LVITEM categoriesFor: #dwState!**compiled accessors**!public! !
!LVITEM categoriesFor: #dwState:!**compiled accessors**!public! !
!LVITEM categoriesFor: #dwStateOffset!constants!private! !
!LVITEM categoriesFor: #handle!accessing!public! !
!LVITEM categoriesFor: #iImage!**compiled accessors**!public! !
!LVITEM categoriesFor: #iImage:!**compiled accessors**!public! !
!LVITEM categoriesFor: #iImageOffset!constants!private! !
!LVITEM categoriesFor: #iIndent!**compiled accessors**!public! !
!LVITEM categoriesFor: #iIndent:!**compiled accessors**!public! !
!LVITEM categoriesFor: #iItem!**compiled accessors**!public! !
!LVITEM categoriesFor: #iItem:!**compiled accessors**!public! !
!LVITEM categoriesFor: #imageValidMask!constants!private! !
!LVITEM categoriesFor: #indent:!accessing!public! !
!LVITEM categoriesFor: #iSubItem!**compiled accessors**!public! !
!LVITEM categoriesFor: #iSubItem:!**compiled accessors**!public! !
!LVITEM categoriesFor: #lParamOffset!constants!private! !
!LVITEM categoriesFor: #paramValidMask!constants!private! !
!LVITEM categoriesFor: #row:text:imageIndex:indent:!accessing!private! !
!LVITEM categoriesFor: #stateMask!**compiled accessors**!public! !
!LVITEM categoriesFor: #stateMask:!**compiled accessors**!public! !
!LVITEM categoriesFor: #stateMaskOffset!constants!private! !
!LVITEM categoriesFor: #stateValidMask!constants!private! !
!LVITEM categoriesFor: #textPointerOffset!constants!private! !
!LVITEM categoriesFor: #textValidMask!constants!private! !

!LVITEM class methodsFor!

allCallbacks
	^self fromBytes: CallbackPrototype!

defineFields
	"Define the fields of the Win32 LVITEM structure

		LVITEM compileDefinition
	"

	super defineFields.
	self
		defineField: #iItem type: SDWORDField new;
		defineField: #iSubItem type: SDWORDField new;
		defineField: #dwState type: DWORDField new;
		defineField: #stateMask type: DWORDField new;
		defineField: #pszText type: (PointerField type: String) beUncompiled;
		defineField: #cchTextMax type: SDWORDField uncompiled;
		defineField: #iImage type: SDWORDField new;
		defineField: #lParam type: UINT_PTRField uncompiled;
		defineField: #iIndent type: SDWORDField new.
	self assert: [(self offsetOf: #pszText) = 20]!

initialize
	CallbackPrototype := self new allCallbacks; bytes! !
!LVITEM class categoriesFor: #allCallbacks!public! !
!LVITEM class categoriesFor: #defineFields!initializing!public! !
!LVITEM class categoriesFor: #initialize!development!public! !

