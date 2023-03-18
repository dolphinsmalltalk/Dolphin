"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.PARAFORMAT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.RichEditConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cTabCount' -> 16r1A.
			'_OffsetOf_dwMask' -> 16r4.
			'_OffsetOf_dwSize' -> 16r0.
			'_OffsetOf_dxOffset' -> 16r14.
			'_OffsetOf_dxRightIndent' -> 16r10.
			'_OffsetOf_dxStartIndent' -> 16rC.
			'_OffsetOf_rgxTabs' -> 16r1C.
			'_OffsetOf_wAlignment' -> 16r18.
			'_OffsetOf_wEffects' -> 16rA.
			'_OffsetOf_wNumbering' -> 16r8.
			'_PARAFORMAT_Size' -> 16r9C
		}!
OS.PARAFORMAT guid: (Core.GUID fromString: '{87b4c607-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.PARAFORMAT comment: ''!
!OS.PARAFORMAT categoriesForClass!External-Data-Structured-Win32! !
!OS.PARAFORMAT methodsFor!

alignment
	"Answer the receiver's alignment as an integer value"

	^self wAlignment!

alignment: anInteger
	"Sets the receiver alignment according to anInteger"

	self maskIn: PFM_ALIGNMENT.
	self wAlignment: anInteger!

cTabCount
	"Answer the <Integer> value of the receiver's 'cTabCount' field."

	^bytes int16AtOffset: _OffsetOf_cTabCount!

cTabCount: anInteger
	"Set the receiver's 'cTabCount' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_cTabCount put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwMask put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

dxOffset
	"Answer the <Integer> value of the receiver's 'dxOffset' field."

	^bytes int32AtOffset: _OffsetOf_dxOffset!

dxOffset: anInteger
	"Set the receiver's 'dxOffset' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_dxOffset put: anInteger!

dxRightIndent
	"Answer the <Integer> value of the receiver's 'dxRightIndent' field."

	^bytes int32AtOffset: _OffsetOf_dxRightIndent!

dxRightIndent: anInteger
	"Set the receiver's 'dxRightIndent' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_dxRightIndent put: anInteger!

dxStartIndent
	"Answer the <Integer> value of the receiver's 'dxStartIndent' field."

	^bytes int32AtOffset: _OffsetOf_dxStartIndent!

dxStartIndent: anInteger
	"Set the receiver's 'dxStartIndent' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_dxStartIndent put: anInteger!

maskIn: anInteger
	"Private - OR in to receiver's mask field the bit flags represented by anInteger.
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
	"Answer the <UInt32Array> value of the receiver's 'rgxTabs' field."

	^UInt32Array fromAddress: bytes yourAddress + _OffsetOf_rgxTabs length: 32!

rgxTabs: aUInt32Array
	"Set the receiver's 'rgxTabs' field to the value of the argument, aUInt32Array"

	| size |
	size := aUInt32Array byteSize min: ##(32 * UInt32Array elementSize).
	aUInt32Array
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rgxTabs + 1)
		to: _OffsetOf_rgxTabs + size
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

	^bytes uint16AtOffset: _OffsetOf_wAlignment!

wAlignment: anInteger
	"Set the receiver's 'wAlignment' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wAlignment put: anInteger!

wEffects
	"Answer the <Integer> value of the receiver's 'wEffects' field."

	^bytes uint16AtOffset: _OffsetOf_wEffects!

wEffects: anInteger
	"Set the receiver's 'wEffects' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wEffects put: anInteger!

wNumbering
	"Answer the <Integer> value of the receiver's 'wNumbering' field."

	^bytes uint16AtOffset: _OffsetOf_wNumbering!

wNumbering: anInteger
	"Set the receiver's 'wNumbering' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wNumbering put: anInteger! !
!OS.PARAFORMAT categoriesForMethods!
alignment!accessing!public! !
alignment:!accessing!public! !
cTabCount!**compiled accessors**!public! !
cTabCount:!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwMask:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
dxOffset!**compiled accessors**!public! !
dxOffset:!**compiled accessors**!public! !
dxRightIndent!**compiled accessors**!public! !
dxRightIndent:!**compiled accessors**!public! !
dxStartIndent!**compiled accessors**!public! !
dxStartIndent:!**compiled accessors**!public! !
maskIn:!accessing!private! !
offset!accessing!public! !
offset:!accessing!public! !
rgxTabs!**compiled accessors**!public! !
rgxTabs:!**compiled accessors**!public! !
startIndent!accessing!public! !
startIndent:!accessing!public! !
wAlignment!**compiled accessors**!public! !
wAlignment:!**compiled accessors**!public! !
wEffects!**compiled accessors**!public! !
wEffects:!**compiled accessors**!public! !
wNumbering!**compiled accessors**!public! !
wNumbering:!**compiled accessors**!public! !
!

!OS.PARAFORMAT class methodsFor!

byteSize
	^_PARAFORMAT_Size!

defineFields
	"Define the Win32 PARAFORMAT Structure (used for paragraph formatting
	in the RichEdit control)
.
		PARAFORMAT compileDefinition
	"

	self
		defineField: #dwSize type: UInt32Field writeOnly beOverride;
		defineField: #dwMask type: UInt32Field new;
		defineField: #wNumbering type: UInt16Field new;
		defineField: #wEffects type: UInt16Field new;
		defineField: #dxStartIndent type: Int32Field new;
		defineField: #dxRightIndent type: Int32Field new;
		defineField: #dxOffset type: Int32Field new;
		defineField: #wAlignment type: UInt16Field new;
		defineField: #cTabCount type: Int16Field new;
		defineField: #rgxTabs type: (ArrayField type: UInt32Array length: 32)!

getFieldNames
	^#(#dwSize #dwMask #wNumbering #wEffects #dxStartIndent #dxRightIndent #dxOffset #wAlignment #cTabCount #rgxTabs)!

packing
	^VMConstants.IntPtrSize! !
!OS.PARAFORMAT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

