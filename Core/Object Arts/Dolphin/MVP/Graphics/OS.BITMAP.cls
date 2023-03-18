"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.BITMAP'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_BITMAP_Size' -> 16r18.
		'_OffsetOf_bmBits' -> 16r14.
		'_OffsetOf_bmBitsPixel' -> 16r12.
		'_OffsetOf_bmHeight' -> 16r8.
		'_OffsetOf_bmPlanes' -> 16r10.
		'_OffsetOf_bmType' -> 16r0.
		'_OffsetOf_bmWidth' -> 16r4.
		'_OffsetOf_bmWidthBytes' -> 16rC
	}!
OS.BITMAP guid: (Core.GUID fromString: '{f44c9143-2b3f-11d3-8368-7a8b5a000000}')!
OS.BITMAP comment: 'BITMAP is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAP structure is used to describe bitmaps, containing attributes such as the width, height, and color format, and a pointer to the bitmap''s bits.'!
!OS.BITMAP categoriesForClass!External-Data-Structured-Win32! !
!OS.BITMAP methodsFor!

bmBits
	"Answer the <ExternalAddress> value of the receiver's 'bmBits' field."

	^(bytes uintPtrAtOffset: _OffsetOf_bmBits) asExternalAddress!

bmBitsPixel
	"Answer the <Integer> value of the receiver's 'bmBitsPixel' field."

	^bytes uint16AtOffset: _OffsetOf_bmBitsPixel!

bmHeight
	"Answer the <Integer> value of the receiver's 'bmHeight' field."

	^bytes int32AtOffset: _OffsetOf_bmHeight!

bmPlanes
	"Answer the <Integer> value of the receiver's 'bmPlanes' field."

	^bytes uint16AtOffset: _OffsetOf_bmPlanes!

bmType
	"Answer the <Integer> value of the receiver's 'bmType' field."

	^bytes int32AtOffset: _OffsetOf_bmType!

bmWidth
	"Answer the <Integer> value of the receiver's 'bmWidth' field."

	^bytes int32AtOffset: _OffsetOf_bmWidth!

bmWidthBytes
	"Answer the <Integer> value of the receiver's 'bmWidthBytes' field."

	^bytes int32AtOffset: _OffsetOf_bmWidthBytes!

depth
	"Answer the colour depth of the bitmap described by the receiver."

	^bytes uint16AtOffset: _OffsetOf_bmBitsPixel!

extent
	"Answer the width and height (in pels) of the bitmap described by the receiver."

	^Graphics.Point x: (bytes int32AtOffset: _OffsetOf_bmWidth)
		y: (bytes int32AtOffset: _OffsetOf_bmHeight)! !
!OS.BITMAP categoriesForMethods!
bmBits!**compiled accessors**!public! !
bmBitsPixel!**compiled accessors**!public! !
bmHeight!**compiled accessors**!public! !
bmPlanes!**compiled accessors**!public! !
bmType!**compiled accessors**!public! !
bmWidth!**compiled accessors**!public! !
bmWidthBytes!**compiled accessors**!public! !
depth!accessing!public! !
extent!accessing!public! !
!

!OS.BITMAP class methodsFor!

byteSize
	^_BITMAP_Size!

defineFields
	"Define the Win32 BITMAP structure
		BITMAP compileDefinition

		typedef struct tagBITMAP {  // bm 
			   LONG   bmType; 
			   LONG   bmWidth; 
			   LONG   bmHeight; 
			   LONG   bmWidthBytes; 
			   WORD   bmPlanes; 
			   WORD   bmBitsPixel; 
			   LPVOID bmBits; 
		} BITMAP;"

	self
		defineField: #bmType type: Int32Field readOnly;
		defineField: #bmWidth type: Int32Field readOnly;
		defineField: #bmHeight type: Int32Field readOnly;
		defineField: #bmWidthBytes type: Int32Field readOnly;
		defineField: #bmPlanes type: UInt16Field readOnly;
		defineField: #bmBitsPixel type: UInt16Field readOnly;
		defineField: #bmBits type: LPVOIDField readOnly!

getFieldNames
	^#(#bmType #bmWidth #bmHeight #bmWidthBytes #bmPlanes #bmBitsPixel #bmBits)! !
!OS.BITMAP class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

