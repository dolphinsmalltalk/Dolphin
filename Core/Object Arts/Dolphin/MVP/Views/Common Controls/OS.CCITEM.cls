"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.CCITEM'
	instanceVariableNames: 'text'
	classVariableNames: ''
	imports: #(#{OS.CommCtrlConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_CCITEM_Size' -> 16r4.
		'_OffsetOf_mask' -> 16r0
	}!
OS.CCITEM guid: (Core.GUID fromString: '{87b4c5ce-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.CCITEM isNonInstantiable: true!
OS.CCITEM comment: 'CCITEM is an <ExternalStructure> class which implements shared behaviour and state for the common controls item structures, LVITEM, TCITEM and TVITEM. There is no actual Win32 common control structure of this name.'!
!OS.CCITEM categoriesForClass!External-Data-Structured-Win32! !
!OS.CCITEM methodsFor!

cchTextMax
	^self subclassResponsibility!

cchTextMax: anObject 
	"Set the receiver's cchTextMax field to the value of anObject."

	self subclassResponsibility!

dwState
	"Answer the receiver's dwState field as a Smalltalk object."

	^self subclassResponsibility!

dwState: anObject 
	"Set the receiver's dwState field to the value of anObject."

	self subclassResponsibility!

handle
	"Answer the 'handle' of the item described by the receiver."

	^self subclassResponsibility!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^self subclassResponsibility!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	self subclassResponsibility!

image: anInteger
	"Set receiver's iImage field to anInteger"

	self iImage: anInteger.
	self maskIn: self imageValidMask!

imageCallback
	"Sets the receiver into image callback mode"

	self image: I_IMAGECALLBACK!

imageValidMask
	"Private - Answer the bit mask the receiver uses to denote that the iImage
	field has valid contents."

	"It turns out that this mask value is the same for all the controls."

	^16r2!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^self subclassResponsibility!

lParam: anObject 
	"Set the receiver's lParam field to the value of anObject."

	self subclassResponsibility!

mask
	"Answer the <Integer> value of the receiver's 'mask' field."

	^bytes dwordAtOffset: _OffsetOf_mask!

mask: anInteger
	"Set the receiver's 'mask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_mask put: anInteger!

maskIn: anInteger
	"OR in to receiver's mask field the bit flags represented by anInteger"

	bytes dwordAtOffset: _OffsetOf_mask put: ((bytes dwordAtOffset: _OffsetOf_mask) bitOr: anInteger)!

newTextBuffer: anInteger
	"Allocate a new text buffer for the receiver of the specified size."

	text := Utf16String newFixed: anInteger.
	self
		pszText: text;
		cchTextMax: anInteger;
		maskIn: self textValidMask!

param: anInteger
	"Set receiver's lParam field to anInteger marking the modifications in the mask."

	self lParam: anInteger.
	self maskIn: self paramValidMask!

paramValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	"This mask value is the same for most of the controls."

	^16r4!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^self subclassResponsibility!

pszText: anObject 
	"Set the receiver's pszText field to the value of anObject."

	self subclassResponsibility!

state: anInteger
	"Set receiver's state field from anInteger"

	self dwState: anInteger; 
		maskIn: self stateValidMask;
		stateMask: anInteger!

stateMask
	"Answer the receiver's stateMask field as a Smalltalk object."

	^self subclassResponsibility!

stateMask: anObject 
	"Set the receiver's stateMask field to the value of anObject."

	self subclassResponsibility!

stateMaskIn: anInteger
	"Private - OR in to receiver's state field the bit flags represented by anInteger"

	self state: (self dwState bitOr: anInteger)!

stateMaskOut: anInteger
	"Private - Mask out of receiver's state field the bit flags represented by anInteger"

	self state: (self dwState maskClear: anInteger)!

stateValidMask
	"Private - Answer the bit mask the receiver uses to denote that the dwState
	field has valid contents."

	"This mask value is the same for most of the controls."

	^8!

text
	"Answer the text of the receiver"

	^text ifNil: [self pszText]!

text: aString
	"Sets receiver's pszMember field to Utf16String. We also hang on to it in our text instance var to
	ensure that its lifetime is sufficiently long for us to safely use it."

	text := aString displayString asUtf16String.
	self
		pszText: text;
		cchTextMax: text size;
		maskIn: self textValidMask!

textCallback
	"Sets the receiver into text callback mode"

	bytes dwordAtOffset: self textPointerOffset put: LPSTR_TEXTCALLBACK.
	self maskIn: self textValidMask!

textInBuffer: aString
	"Writes aString into a system buffer pointed to by pszText and of size cchTextMax (including null terminator). This is used to provide text back to the control, and it has allocated the buffer. If the string is too large for the buffer, it is ellipsised with U+2026."

	| utf16 max |
	utf16 := aString displayString asUtf16String.
	utf16 size >= (max := self cchTextMax)
		ifTrue: 
			[| last |
			"We need to allow space for a U+2026 and the null terminator"
			last := max - 2.
			"Ensure we don't truncate in the middle of a character"
			(utf16 at: last) isUtf16Lead ifTrue: [last := last - 1].
			utf16 := (utf16 copyFrom: 1 to: last) , '…'].
	utf16 copyToBuffer: (bytes sdwordAtOffset: self textPointerOffset) ofSize: max!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^self subclassResponsibility!

textValidMask
	"Private - Answer the bit mask the receiver uses to denote that the pszText
	field has valid contents."

	"This mask value is the same for most of the controls."

	^16r1! !
!OS.CCITEM categoriesForMethods!
cchTextMax!accessing!public! !
cchTextMax:!accessing!public! !
dwState!accessing!public! !
dwState:!accessing!public! !
handle!accessing!public! !
iImage!accessing!public! !
iImage:!accessing!public! !
image:!accessing!public! !
imageCallback!accessing!public! !
imageValidMask!constants!private! !
lParam!accessing!public! !
lParam:!accessing!public! !
mask!**compiled accessors**!public! !
mask:!**compiled accessors**!public! !
maskIn:!accessing!public! !
newTextBuffer:!helpers!public! !
param:!accessing!public! !
paramValidMask!constants!private! !
pszText!accessing!public! !
pszText:!accessing!public! !
state:!accessing!public! !
stateMask!accessing!public! !
stateMask:!accessing!public! !
stateMaskIn:!accessing!private! !
stateMaskOut:!accessing!private! !
stateValidMask!constants!private! !
text!accessing!public! !
text:!accessing!public! !
textCallback!accessing!public! !
textInBuffer:!constants!public! !
textPointerOffset!constants!private! !
textValidMask!constants!private! !
!

!OS.CCITEM class methodsFor!

byteSize
	^_CCITEM_Size!

defineFields
	"
		CCITEM compileDefinition
	"

	self
		defineField: #mask
		type: DWORDField new
		offset: 0! !
!OS.CCITEM class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

