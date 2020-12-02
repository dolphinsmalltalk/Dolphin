"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #BITMAP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bmBits' -> 16r14.
		'_OffsetOf_bmBitsPixel' -> 16r12.
		'_OffsetOf_bmHeight' -> 16r8.
		'_OffsetOf_bmPlanes' -> 16r10.
		'_OffsetOf_bmType' -> 16r0.
		'_OffsetOf_bmWidth' -> 16r4.
		'_OffsetOf_bmWidthBytes' -> 16rC
	}!
BITMAP guid: (GUID fromString: '{f44c9143-2b3f-11d3-8368-7a8b5a000000}')!
BITMAP comment: 'BITMAP is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAP structure is used to describe bitmaps, containing attributes such as the width, height, and color format, and a pointer to the bitmap''s bits.'!
!BITMAP categoriesForClass!External-Data-Structured-Win32! !
!BITMAP methodsFor!

bmBits
	"Answer the <ExternalAddress> value of the receiver's 'bmBits' field."

	^(bytes uintPtrAtOffset: _OffsetOf_bmBits) asExternalAddress!

bmBitsPixel
	"Answer the <Integer> value of the receiver's 'bmBitsPixel' field."

	^bytes wordAtOffset: _OffsetOf_bmBitsPixel!

bmHeight
	"Answer the <Integer> value of the receiver's 'bmHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_bmHeight!

bmPlanes
	"Answer the <Integer> value of the receiver's 'bmPlanes' field."

	^bytes wordAtOffset: _OffsetOf_bmPlanes!

bmType
	"Answer the <Integer> value of the receiver's 'bmType' field."

	^bytes sdwordAtOffset: _OffsetOf_bmType!

bmWidth
	"Answer the <Integer> value of the receiver's 'bmWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_bmWidth!

bmWidthBytes
	"Answer the <Integer> value of the receiver's 'bmWidthBytes' field."

	^bytes sdwordAtOffset: _OffsetOf_bmWidthBytes!

depth
	"Answer the colour depth of the bitmap described by the receiver."

	^self bmBitsPixel!

extent
	"Answer the width and height (in pels) of the the bitmap described by the receiver."

	^self bmWidth @ self bmHeight! !
!BITMAP categoriesFor: #bmBits!**compiled accessors**!public! !
!BITMAP categoriesFor: #bmBitsPixel!**compiled accessors**!public! !
!BITMAP categoriesFor: #bmHeight!**compiled accessors**!public! !
!BITMAP categoriesFor: #bmPlanes!**compiled accessors**!public! !
!BITMAP categoriesFor: #bmType!**compiled accessors**!public! !
!BITMAP categoriesFor: #bmWidth!**compiled accessors**!public! !
!BITMAP categoriesFor: #bmWidthBytes!**compiled accessors**!public! !
!BITMAP categoriesFor: #depth!accessing!public! !
!BITMAP categoriesFor: #extent!accessing!public! !

!BITMAP class methodsFor!

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
	     defineField: #bmType type: SDWORDField readOnly;
	     defineField: #bmWidth type: SDWORDField readOnly;
	     defineField: #bmHeight type: SDWORDField readOnly;
	     defineField: #bmWidthBytes type: SDWORDField readOnly;
	     defineField: #bmPlanes type: WORDField readOnly;
	     defineField: #bmBitsPixel type:WORDField readOnly;
	     defineField: #bmBits type: LPVOIDField readOnly!

fileOutStem
	"Private - Answer standard file name stem for the class to file out on."

	^'BITMAP_Struct'!

getFieldNames
	^#(#bmType #bmWidth #bmHeight #bmWidthBytes #bmPlanes #bmBitsPixel #bmBits)! !
!BITMAP class categoriesFor: #defineFields!public!template definition! !
!BITMAP class categoriesFor: #fileOutStem!private!source filing! !
!BITMAP class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

