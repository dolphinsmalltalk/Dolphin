"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #WINDOWPLACEMENT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_flags _OffsetOf_ptMaxPosition _OffsetOf_ptMinPosition _OffsetOf_rcNormalPosition _OffsetOf_showCmd'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WINDOWPLACEMENT guid: (GUID fromString: '{87b4c61b-026e-11d3-9fd7-00a0cc3e4a32}')!

WINDOWPLACEMENT addClassConstant: '_OffsetOf_dwSize' value: 16r0!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_flags' value: 16r4!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_ptMaxPosition' value: 16r14!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_ptMinPosition' value: 16rC!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_rcNormalPosition' value: 16r1C!
WINDOWPLACEMENT addClassConstant: '_OffsetOf_showCmd' value: 16r8!

WINDOWPLACEMENT comment: ''!

!WINDOWPLACEMENT categoriesForClass!External-Data-Structured-Win32! !

!WINDOWPLACEMENT methodsFor!

corner: aPoint
	"Set the <point> representing the corner of the placement rectangle."

	bytes
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_right) put: aPoint x;
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_bottom) put: aPoint y!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

extent
	^self width @ self height!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger!

height
	"Answer the height of the receiver's placement rectangle."

	^(bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_bottom))
		- (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_top))!

height: anInteger
	"Set the height of the placement rectangle to the <integer> argument."

	bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_bottom)
		put: (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_bottom)) + anInteger!

origin
	"Answer a <Point> representing the origin (top-left corner) of the placement rectangle."

	^(bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_left))
		@ (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_top))!

origin: aPoint
	"Set the <point> representing the origin of the placement rectangle."

	bytes
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_left) put: aPoint x;
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_top) put: aPoint y!

ptMaxPosition
	"Private - Answer the <POINTL> value of the receiver's 'ptMaxPosition' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMaxPosition!

ptMaxPosition: aPOINTL
	"Set the receiver's 'ptMaxPosition' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMaxPosition + 1)
		to: ##(_OffsetOf_ptMaxPosition + POINTL basicByteSize)
		startingAt: 1!

ptMinPosition
	"Private - Answer the <POINTL> value of the receiver's 'ptMinPosition' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptMinPosition!

ptMinPosition: aPOINTL
	"Set the receiver's 'ptMinPosition' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptMinPosition + 1)
		to: ##(_OffsetOf_ptMinPosition + POINTL basicByteSize)
		startingAt: 1!

rcNormalPosition
	"Answer the <RECT> value of the receiver's 'rcNormalPosition' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcNormalPosition!

rcNormalPosition: aRECT
	"Set the receiver's 'rcNormalPosition' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcNormalPosition + 1)
		to: ##(_OffsetOf_rcNormalPosition + RECT basicByteSize)
		startingAt: 1!

scaleBy: aMagnitude
	"Scale the receiver in-place by the specified <Point> or <Number> multiplier."

	"At present this only adjusts the placement rectangle, i.e. the rcNormalPosition field. This is done using inline code to directly access the RECT because this is called a lot when opening a complex view resource.The minimum and maximum position points are notionally used to represent the positions when minimised and maximised, although it is not clear that these are in fact relevant anymore. ptMinPosition is either (-1@-1) or -(32000@-32000) (after the window has been minimised or maximised), and ptMaxPosition is always (-1@-1)."

	| pt |
	pt := (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_left))
				@ (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_top)) * aMagnitude.
	bytes
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_left) put: pt x truncated;
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_top) put: pt y truncated.
	pt := (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_right))
				@ (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_bottom)) * aMagnitude.
	bytes
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_right) put: pt x truncated;
		sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_bottom) put: pt y truncated!

showCmd
	"Answer the <Integer> value of the receiver's 'showCmd' field."

	^bytes dwordAtOffset: _OffsetOf_showCmd!

showCmd: anInteger
	"Set the receiver's 'showCmd' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_showCmd put: anInteger!

width
	"Answer the width of the receiver's placement rectangle."

	^(bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_right))
		- (bytes sdwordAtOffset: ##(_OffsetOf_rcNormalPosition + RECT._OffsetOf_left))! !

!WINDOWPLACEMENT categoriesForMethods!
corner:!accessing!public! !
dwSize:!**compiled accessors**!public! !
extent!public! !
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

!WINDOWPLACEMENT class methodsFor!

defineFields
	"Define the layout of the Win32 WINDOWPLACEMENT structure. 
	Currently to avoid wasting space, the structure is defined as mostly filler 
	fields.

		WINDOWPLACEMENT compileDefinition

		typedef struct tagWINDOWPLACEMENT {
			UINT  length;
			UINT  flags;
			UINT  showCmd;
			POINT ptMinPosition;
			POINT ptMaxPosition;
			RECT  rcNormalPosition;
		} WINDOWPLACEMENT;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #flags type: DWORDField new;
		defineField: #showCmd type: DWORDField new;
		defineField: #ptMinPosition type: (StructureField type: POINTL) beNonBrowsable;
		defineField: #ptMaxPosition type: (StructureField type: POINTL) beNonBrowsable;
		defineField: #rcNormalPosition type: (StructureField type: RECT)!

getFieldNames
	^#(#dwSize #flags #showCmd #ptMinPosition #ptMaxPosition #rcNormalPosition)! !

!WINDOWPLACEMENT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

