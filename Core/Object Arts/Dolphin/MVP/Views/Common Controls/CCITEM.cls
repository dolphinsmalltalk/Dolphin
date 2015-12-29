"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #CCITEM
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!
CCITEM guid: (GUID fromString: '{87B4C5CE-026E-11D3-9FD7-00A0CC3E4A32}')!
CCITEM comment: 'CCITEM is an <ExternalStructure> class which implements shared behaviour and state for the common controls item structures, LVITEM, TCITEM and TVITEM. There is no actual Win32 common control structure of this name.'!
!CCITEM categoriesForClass!External-Data-Structured-Win32! !
!CCITEM methodsFor!

cchTextMax
	^bytes sdwordAtOffset: self cchTextMaxOffset!

cchTextMax: anObject 
	"Set the receiver's cchTextMax field to the value of anObject."

	bytes sdwordAtOffset: self cchTextMaxOffset put: anObject!

cchTextMaxOffset
	^self subclassResponsibility!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^bytes dwordAtOffset: self dwStateOffset!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	bytes dwordAtOffset: self dwStateOffset put: anObject!

dwStateOffset
	^self subclassResponsibility!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self subclassResponsibility!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^bytes sdwordAtOffset: self iImageOffset!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	bytes sdwordAtOffset: self iImageOffset put: anObject!

iImageOffset
	^self subclassResponsibility!

image: anInteger
	"Set contents' iImage member to anInteger"

	self iImage: anInteger.
	self maskIn: self imageValidMask!

imageCallback
	"Sets the receiver into image callback mode"

	self image: I_IMAGECALLBACK!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the iImage
	field has valid contents."

	^self subclassResponsibility!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^bytes uintPtrAtOffset: self lParamOffset!

lParam: anObject 
	"Set the receiver's lParam field to the value of anObject."

	bytes uintPtrAtOffset: self lParamOffset put: anObject!

lParamOffset
	^self subclassResponsibility!

mask
	"Answer the receiver's mask field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

mask: anObject 
	"Set the receiver's mask field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self mask: (self mask bitOr: anInteger)!

param: anId
	"Set contents's lParam member to anIs marking the modifications in the mask."

	self lParam: anId.
	self maskIn: self paramValidMask!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^self subclassResponsibility!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^String fromAddress: (bytes sdwordAtOffset: self textPointerOffset)!

pszText: anObject 
	"Set the receiver's pszText field to the value of anObject."

	bytes dwordAtOffset: self textPointerOffset put: anObject yourAddress!

pszTextAddress
	"Private - Answer the address of the text buffer. "

	^bytes sdwordAtOffset: self textPointerOffset!

state: anInteger
	"Set contents' state member from anInteger"

	self dwState: anInteger; 
		maskIn: self stateValidMask;
		stateMask: anInteger!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^bytes dwordAtOffset: self stateMaskOffset!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	bytes dwordAtOffset: self stateMaskOffset put: anObject!

stateMaskIn: anInteger
	"Private - OR in to contents' state member the bit flags represented by anInteger"

	self state: (self dwState bitOr: anInteger)!

stateMaskOffset
	^self subclassResponsibility!

stateMaskOut: anInteger
	"Private - Mask out of contents' state member the bit flags represented by anInteger"

	self state: (self dwState maskClear: anInteger)!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	^self subclassResponsibility!

text
	"Answer the text of the receiver"

	^text!

text: aString
	"Sets contents' pszMember to aString. We also hang on to it in our text instance var to
	ensure that its lifetime is sufficiently long for us to safely use it."

	text := aString.
	self
		pszText: aString;
		cchTextMax: aString size;
		maskIn: self textValidMask!

textCallback
	"Sets the receiver into text callback mode"

	bytes dwordAtOffset: self textPointerOffset put: LPSTR_TEXTCALLBACK.
	self maskIn: self textValidMask!

textInBuffer: aString
	"Writes aString into a system buffer pointed to by pszText
	and of size cchTextMax."

	CRTLibrary default 
		strncpy: self pszTextAddress	"Raw address of text buffer allocated by control"
		strSource: aString 
		count: self cchTextMax!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^self subclassResponsibility!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	^self subclassResponsibility! !
!CCITEM categoriesFor: #cchTextMax!accessing!public! !
!CCITEM categoriesFor: #cchTextMax:!accessing!public! !
!CCITEM categoriesFor: #cchTextMaxOffset!constants!private! !
!CCITEM categoriesFor: #dwState!accessing!public! !
!CCITEM categoriesFor: #dwState:!accessing!public! !
!CCITEM categoriesFor: #dwStateOffset!constants!private! !
!CCITEM categoriesFor: #handle!accessing!public! !
!CCITEM categoriesFor: #iImage!accessing!public! !
!CCITEM categoriesFor: #iImage:!accessing!public! !
!CCITEM categoriesFor: #iImageOffset!constants!private! !
!CCITEM categoriesFor: #image:!accessing!public! !
!CCITEM categoriesFor: #imageCallback!accessing!public! !
!CCITEM categoriesFor: #imageValidMask!constants!private! !
!CCITEM categoriesFor: #lParam!accessing!public! !
!CCITEM categoriesFor: #lParam:!accessing!public! !
!CCITEM categoriesFor: #lParamOffset!constants!private! !
!CCITEM categoriesFor: #mask!**compiled accessors**!public! !
!CCITEM categoriesFor: #mask:!**compiled accessors**!public! !
!CCITEM categoriesFor: #maskIn:!accessing!public! !
!CCITEM categoriesFor: #param:!accessing!public! !
!CCITEM categoriesFor: #paramValidMask!constants!private! !
!CCITEM categoriesFor: #pszText!accessing!public! !
!CCITEM categoriesFor: #pszText:!accessing!public! !
!CCITEM categoriesFor: #pszTextAddress!accessing!private! !
!CCITEM categoriesFor: #state:!accessing!public! !
!CCITEM categoriesFor: #stateMask!accessing!public! !
!CCITEM categoriesFor: #stateMask:!accessing!public! !
!CCITEM categoriesFor: #stateMaskIn:!accessing!private! !
!CCITEM categoriesFor: #stateMaskOffset!constants!private! !
!CCITEM categoriesFor: #stateMaskOut:!accessing!private! !
!CCITEM categoriesFor: #stateValidMask!constants!private! !
!CCITEM categoriesFor: #text!accessing!public! !
!CCITEM categoriesFor: #text:!accessing!public! !
!CCITEM categoriesFor: #textCallback!accessing!public! !
!CCITEM categoriesFor: #textInBuffer:!accessing!public! !
!CCITEM categoriesFor: #textPointerOffset!constants!private! !
!CCITEM categoriesFor: #textValidMask!constants!private! !

!CCITEM class methodsFor!

defineFields
	"
		CCITEM compileDefinition
	"

	self 
		defineField: #mask type: DWORDField new! !
!CCITEM class categoriesFor: #defineFields!initializing!public! !

