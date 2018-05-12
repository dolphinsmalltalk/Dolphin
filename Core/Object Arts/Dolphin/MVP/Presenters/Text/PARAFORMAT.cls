"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #PARAFORMAT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'RichEditConstants'
	classInstanceVariableNames: ''!
PARAFORMAT guid: (GUID fromString: '{87b4c607-026e-11d3-9fd7-00a0cc3e4a32}')!
PARAFORMAT comment: ''!
!PARAFORMAT categoriesForClass!External-Data-Structured-Win32! !
!PARAFORMAT methodsFor!

alignment
	"Answer the receiver's alignment as an integer value"

	^self wAlignment!

alignment: anInteger
	"Sets the receiver alignment according to anInteger"

	self maskIn: PFM_ALIGNMENT.
	self wAlignment: anInteger!

cTabCount
	"Answer the receiver's cTabCount field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #cTabCount)!

cTabCount: anObject 
	"Set the receiver's cTabCount field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #cTabCount) put: anObject!

dwMask
	"Answer the receiver's dwMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwMask)!

dwMask: anObject 
	"Set the receiver's dwMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwMask) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dxOffset
	"Answer the receiver's dxOffset field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #dxOffset)!

dxOffset: anObject 
	"Set the receiver's dxOffset field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #dxOffset) put: anObject!

dxRightIndent
	"Answer the receiver's dxRightIndent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #dxRightIndent)!

dxRightIndent: anObject 
	"Set the receiver's dxRightIndent field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #dxRightIndent) put: anObject!

dxStartIndent
	"Answer the receiver's dxStartIndent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #dxStartIndent)!

dxStartIndent: anObject 
	"Set the receiver's dxStartIndent field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #dxStartIndent) put: anObject!

maskIn: anInteger
	"Private - OR in to contents mask member the bit flags represented by anInteger.
	Answer the receiver."

	self dwMask: (self dwMask bitOr: anInteger)!

offset
	"Answers the receiver left offset"

	^self dxOffset!

offset: anInteger 
	"Sets the receiver left offset according to anInteger"

	self maskIn: PFM_OFFSET.
	self dxOffset: anInteger!

rgxTabs
	"Answer the receiver's rgxTabs field as a Smalltalk object."

	^DWORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #rgxTabs) length: 32!

rgxTabs: anObject 
	"Set the receiver's rgxTabs field to the value of anObject."

	| size |
	size := anObject byteSize min: 32 * ##(DWORDArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rgxTabs) + 1)
		to: ##(self offsetOf: #rgxTabs) + size
		startingAt: 1!

startIndent
	"Answers the receiver left indent"

	^self dxStartIndent!

startIndent: anInteger 
	"Sets the receiver left indent according to anInteger"

	self maskIn: PFM_STARTINDENT.
	self dxStartIndent: anInteger!

wAlignment
	"Answer the receiver's wAlignment field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wAlignment)!

wAlignment: anObject 
	"Set the receiver's wAlignment field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wAlignment) put: anObject!

wNumbering
	"Answer the receiver's wNumbering field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wNumbering)!

wNumbering: anObject 
	"Set the receiver's wNumbering field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wNumbering) put: anObject! !
!PARAFORMAT categoriesFor: #alignment!accessing!public! !
!PARAFORMAT categoriesFor: #alignment:!accessing!public! !
!PARAFORMAT categoriesFor: #cTabCount!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #cTabCount:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dwMask!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dwMask:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dwSize:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dxOffset!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dxOffset:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dxRightIndent!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dxRightIndent:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dxStartIndent!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #dxStartIndent:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #maskIn:!accessing!private! !
!PARAFORMAT categoriesFor: #offset!accessing!public! !
!PARAFORMAT categoriesFor: #offset:!accessing!public! !
!PARAFORMAT categoriesFor: #rgxTabs!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #rgxTabs:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #startIndent!accessing!public! !
!PARAFORMAT categoriesFor: #startIndent:!accessing!public! !
!PARAFORMAT categoriesFor: #wAlignment!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #wAlignment:!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #wNumbering!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #wNumbering:!**compiled accessors**!public! !

!PARAFORMAT class methodsFor!

defineFields
	"Define the Win32 PARAFORMAT Structure (used for paragraph formatting
	in the RichEdit control)
.
		PARAFORMAT compileDefinition
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #dwMask type: DWORDField new;
		defineField: #wNumbering type: WORDField new;
		defineField: #wReserved type: WORDField filler;
		defineField: #dxStartIndent type: SDWORDField new;
		defineField: #dxRightIndent type: SDWORDField new;
		defineField: #dxOffset type: SDWORDField new;
		defineField: #wAlignment type: WORDField new;
		defineField: #cTabCount type: SWORDField new;
		defineField: #rgxTabs type: (ArrayField type: DWORDArray length: 32)!

packing
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [8] ifFalse: [4]! !
!PARAFORMAT class categoriesFor: #defineFields!initializing!public! !
!PARAFORMAT class categoriesFor: #packing!constants!public! !

