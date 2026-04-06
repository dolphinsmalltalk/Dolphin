"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.PARAFORMAT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cTabCount' -> 16r1A.
			'_OffsetOf_dwMask' -> 16r4.
			'_OffsetOf_dxOffset' -> 16r14.
			'_OffsetOf_dxRightIndent' -> 16r10.
			'_OffsetOf_dxStartIndent' -> 16rC.
			'_OffsetOf_rgxTabs' -> 16r1C.
			'_OffsetOf_wAlignment' -> 16r18.
			'_OffsetOf_wEffects' -> 16rA.
			'_OffsetOf_wNumbering' -> 16r8.
			'_PARAFORMAT_Size' -> 16r9C.
			'PFM_ALIGNMENT' -> 16r8.
			'PFM_BORDER' -> 16r800.
			'PFM_DONOTHYPHEN' -> 16r400000.
			'PFM_KEEP' -> 16r20000.
			'PFM_KEEPNEXT' -> 16r40000.
			'PFM_LINESPACING' -> 16r100.
			'PFM_NOLINENUMBER' -> 16r100000.
			'PFM_NOWIDOWCONTROL' -> 16r200000.
			'PFM_NUMBERING' -> 16r20.
			'PFM_NUMBERINGSTART' -> 16r8000.
			'PFM_NUMBERINGSTYLE' -> 16r2000.
			'PFM_NUMBERINGTAB' -> 16r4000.
			'PFM_OFFSET' -> 16r4.
			'PFM_OFFSETINDENT' -> 16r80000000.
			'PFM_PAGEBREAKBEFORE' -> 16r80000.
			'PFM_RIGHTINDENT' -> 16r2.
			'PFM_RTLPARA' -> 16r10000.
			'PFM_SHADING' -> 16r1000.
			'PFM_SIDEBYSIDE' -> 16r800000.
			'PFM_SPACEAFTER' -> 16r80.
			'PFM_SPACEBEFORE' -> 16r40.
			'PFM_STARTINDENT' -> 16r1.
			'PFM_STYLE' -> 16r400.
			'PFM_TABLE' -> 16r40000000.
			'PFM_TABSTOPS' -> 16r10
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

rgxTabs: anUInt32Array
	"Set the receiver's 'rgxTabs' field to the value of the argument, anUInt32Array"

	| size |
	size := anUInt32Array byteSize min: ##(32 * UInt32Array elementSize).
	anUInt32Array
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

	super defineFields.
	self
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
	^VMLibrary.IntPtrSize! !

!OS.PARAFORMAT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

