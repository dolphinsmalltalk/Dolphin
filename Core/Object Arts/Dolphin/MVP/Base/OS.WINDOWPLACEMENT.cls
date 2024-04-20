"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.WINDOWPLACEMENT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_flags' -> 16r4.
			'_OffsetOf_ptMaxPosition' -> 16r14.
			'_OffsetOf_ptMinPosition' -> 16rC.
			'_OffsetOf_rcNormalPosition' -> 16r1C.
			'_OffsetOf_showCmd' -> 16r8.
			'_WINDOWPLACEMENT_Size' -> 16r2C
		}!

OS.WINDOWPLACEMENT guid: (Core.GUID fromString: '{87b4c61b-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.WINDOWPLACEMENT comment: ''!

!OS.WINDOWPLACEMENT categoriesForClass!External-Data-Structured-Win32! !

!OS.WINDOWPLACEMENT methodsFor!

corner: aPoint
	"Set the <point> representing the corner of the placement rectangle."

	bytes
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_right) put: aPoint x;
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_bottom) put: aPoint y!

extent
	^self width @ self height!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

height
	"Answer the height of the receiver's placement rectangle."

	^(bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_bottom))
		- (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_top))!

height: anInteger
	"Set the height of the placement rectangle to the <integer> argument."

	bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_bottom)
		put: (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_bottom)) + anInteger!

origin
	"Answer a <Point> representing the origin (top-left corner) of the placement rectangle."

	^(bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_left))
		@ (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_top))!

origin: aPoint
	"Set the <point> representing the origin of the placement rectangle."

	bytes
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_left) put: aPoint x;
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_top) put: aPoint y!

ptMaxPosition
	"Private - Answer the <POINTL> value of the receiver's 'ptMaxPosition' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMaxPosition!

ptMaxPosition: aPOINTL
	"Set the receiver's 'ptMaxPosition' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMaxPosition + 1)
		to: ##(_OffsetOf_ptMaxPosition + POINTL._POINTL_Size)
		startingAt: 1!

ptMinPosition
	"Private - Answer the <POINTL> value of the receiver's 'ptMinPosition' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMinPosition!

ptMinPosition: aPOINTL
	"Set the receiver's 'ptMinPosition' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMinPosition + 1)
		to: ##(_OffsetOf_ptMinPosition + POINTL._POINTL_Size)
		startingAt: 1!

rcNormalPosition
	"Answer the <RECTL> value of the receiver's 'rcNormalPosition' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcNormalPosition!

rcNormalPosition: aRECTL
	"Set the receiver's 'rcNormalPosition' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcNormalPosition + 1)
		to: ##(_OffsetOf_rcNormalPosition + RECTL._RECTL_Size)
		startingAt: 1!

scaleBy: aMagnitude
	"Scale the receiver in-place by the specified <Point> or <Number> multiplier."

	"At present this only adjusts the placement rectangle, i.e. the rcNormalPosition field. This is done using inline code to directly access the RECT because this is called a lot when opening a complex view resource.The minimum and maximum position points are notionally used to represent the positions when minimised and maximised, although it is not clear that these are in fact relevant anymore. ptMinPosition is either (-1@-1) or -(32000@-32000) (after the window has been minimised or maximised), and ptMaxPosition is always (-1@-1)."

	| pt |
	pt := (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_left))
				@ (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_top)) * aMagnitude.
	bytes
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_left) put: pt x truncated;
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_top) put: pt y truncated.
	pt := (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_right))
				@ (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_bottom)) * aMagnitude.
	bytes
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_right) put: pt x truncated;
		int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_bottom) put: pt y truncated!

showCmd
	"Answer the <Integer> value of the receiver's 'showCmd' field."

	^bytes uint32AtOffset: _OffsetOf_showCmd!

showCmd: anInteger
	"Set the receiver's 'showCmd' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_showCmd put: anInteger!

width
	"Answer the width of the receiver's placement rectangle."

	^(bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_right))
		- (bytes int32AtOffset: ##(_OffsetOf_rcNormalPosition + RECTL._OffsetOf_left))! !

!OS.WINDOWPLACEMENT categoriesForMethods!
corner:!accessing!public! !
extent!accessing!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
height!accessing!public! !
height:!accessing!public! !
origin!accessing!public! !
origin:!accessing!public! !
ptMaxPosition!**compiled accessors**!private! !
ptMaxPosition:!**compiled accessors**!private! !
ptMinPosition!**compiled accessors**!private! !
ptMinPosition:!**compiled accessors**!private! !
rcNormalPosition!**compiled accessors**!public! !
rcNormalPosition:!**compiled accessors**!public! !
scaleBy:!public!transforming! !
showCmd!**compiled accessors**!public! !
showCmd:!**compiled accessors**!public! !
width!accessing!public! !
!

!OS.WINDOWPLACEMENT class methodsFor!

byteSize
	^_WINDOWPLACEMENT_Size!

defineFields
	"Define the layout of the Win32 WINDOWPLACEMENT structure. 
	Currently to avoid wasting space, the structure is defined as mostly filler 
	fields.

		WINDOWPLACEMENT compileDefinition

		typedef struct tagWINDOWPLACEMENT {
			UINT  length;
			UINT  flags;
			UINT  showCmd;
			POINTL ptMinPosition;
			POINTL ptMaxPosition;
			RECTL  rcNormalPosition;
		} WINDOWPLACEMENT;"

	super defineFields.
	self
		defineField: #flags type: UInt32Field new;
		defineField: #showCmd type: UInt32Field new;
		defineField: #ptMinPosition type: (StructureField type: POINTL) beNonBrowsable;
		defineField: #ptMaxPosition type: (StructureField type: POINTL) beNonBrowsable;
		defineField: #rcNormalPosition type: (StructureField type: RECTL)!

getFieldNames
	^#(#dwSize #flags #showCmd #ptMinPosition #ptMaxPosition #rcNormalPosition)! !

!OS.WINDOWPLACEMENT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

