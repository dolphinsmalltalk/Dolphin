"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #BITMAP
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bmBits _OffsetOf_bmBitsPixel _OffsetOf_bmHeight _OffsetOf_bmPlanes _OffsetOf_bmType _OffsetOf_bmWidth _OffsetOf_bmWidthBytes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BITMAP guid: (GUID fromString: '{f44c9143-2b3f-11d3-8368-7a8b5a000000}')!

BITMAP addClassConstant: '_OffsetOf_bmBits' value: 16r14!
BITMAP addClassConstant: '_OffsetOf_bmBitsPixel' value: 16r12!
BITMAP addClassConstant: '_OffsetOf_bmHeight' value: 16r8!
BITMAP addClassConstant: '_OffsetOf_bmPlanes' value: 16r10!
BITMAP addClassConstant: '_OffsetOf_bmType' value: 16r0!
BITMAP addClassConstant: '_OffsetOf_bmWidth' value: 16r4!
BITMAP addClassConstant: '_OffsetOf_bmWidthBytes' value: 16rC!

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

!BITMAP categoriesForMethods!
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

!BITMAP class categoriesForMethods!
defineFields!public!template definition! !
fileOutStem!private!source filing! !
getFieldNames!**compiled accessors**!constants!private! !
!

