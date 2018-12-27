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
	"Answer the <Integer> value of the receiver's 'cTabCount' field."

	^bytes swordAtOffset: ##(self offsetOf: #cTabCount)!

cTabCount: anInteger
	"Set the receiver's 'cTabCount' field to the value of the argument, anInteger"

	bytes swordAtOffset: ##(self offsetOf: #cTabCount) put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwMask)!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwMask) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

dxOffset
	"Answer the <Integer> value of the receiver's 'dxOffset' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #dxOffset)!

dxOffset: anInteger
	"Set the receiver's 'dxOffset' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #dxOffset) put: anInteger!

dxRightIndent
	"Answer the <Integer> value of the receiver's 'dxRightIndent' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #dxRightIndent)!

dxRightIndent: anInteger
	"Set the receiver's 'dxRightIndent' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #dxRightIndent) put: anInteger!

dxStartIndent
	"Answer the <Integer> value of the receiver's 'dxStartIndent' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #dxStartIndent)!

dxStartIndent: anInteger
	"Set the receiver's 'dxStartIndent' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #dxStartIndent) put: anInteger!

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
	"Answer the <DWORDArray> value of the receiver's 'rgxTabs' field."

	^DWORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #rgxTabs) length: 32!

rgxTabs: aDWORDArray
	"Set the receiver's 'rgxTabs' field to the value of the argument, aDWORDArray"

	| size |
	size := aDWORDArray byteSize min: ##(32 * DWORDArray elementSize).
	aDWORDArray
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
	"Answer the <Integer> value of the receiver's 'wAlignment' field."

	^bytes wordAtOffset: ##(self offsetOf: #wAlignment)!

wAlignment: anInteger
	"Set the receiver's 'wAlignment' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wAlignment) put: anInteger!

wEffects
	"Answer the <Integer> value of the receiver's 'wEffects' field."

	^bytes wordAtOffset: ##(self offsetOf: #wEffects)!

wEffects: anInteger
	"Set the receiver's 'wEffects' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wEffects) put: anInteger!

wNumbering
	"Answer the <Integer> value of the receiver's 'wNumbering' field."

	^bytes wordAtOffset: ##(self offsetOf: #wNumbering)!

wNumbering: anInteger
	"Set the receiver's 'wNumbering' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wNumbering) put: anInteger! !
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
!PARAFORMAT categoriesFor: #wEffects!**compiled accessors**!public! !
!PARAFORMAT categoriesFor: #wEffects:!**compiled accessors**!public! !
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
		defineField: #wEffects type: WORDField new;
		defineField: #dxStartIndent type: SDWORDField new;
		defineField: #dxRightIndent type: SDWORDField new;
		defineField: #dxOffset type: SDWORDField new;
		defineField: #wAlignment type: WORDField new;
		defineField: #cTabCount type: SWORDField new;
		defineField: #rgxTabs type: (ArrayField type: DWORDArray length: 32)!

getFieldNames
	^#(#dwSize #dwMask #wNumbering #wEffects #dxStartIndent #dxRightIndent #dxOffset #wAlignment #cTabCount #rgxTabs)!

packing
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [8] ifFalse: [4]! !
!PARAFORMAT class categoriesFor: #defineFields!initializing!public! !
!PARAFORMAT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!PARAFORMAT class categoriesFor: #packing!constants!public! !

