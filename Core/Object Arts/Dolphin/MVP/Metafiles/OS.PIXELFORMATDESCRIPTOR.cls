"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.PIXELFORMATDESCRIPTOR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bReserved' -> 16r1B.
		'_OffsetOf_cAccumAlphaBits' -> 16r16.
		'_OffsetOf_cAccumBits' -> 16r12.
		'_OffsetOf_cAccumBlueBits' -> 16r15.
		'_OffsetOf_cAccumGreenBits' -> 16r14.
		'_OffsetOf_cAccumRedBits' -> 16r13.
		'_OffsetOf_cAlphaBits' -> 16r10.
		'_OffsetOf_cAlphaShift' -> 16r11.
		'_OffsetOf_cAuxBuffers' -> 16r19.
		'_OffsetOf_cBlueBits' -> 16rE.
		'_OffsetOf_cBlueShift' -> 16rF.
		'_OffsetOf_cColorBits' -> 16r9.
		'_OffsetOf_cDepthBits' -> 16r17.
		'_OffsetOf_cGreenBits' -> 16rC.
		'_OffsetOf_cGreenShift' -> 16rD.
		'_OffsetOf_cRedBits' -> 16rA.
		'_OffsetOf_cRedShift' -> 16rB.
		'_OffsetOf_cStencilBits' -> 16r18.
		'_OffsetOf_dwDamageMask' -> 16r24.
		'_OffsetOf_dwFlags' -> 16r4.
		'_OffsetOf_dwLayerMask' -> 16r1C.
		'_OffsetOf_dwVisibleMask' -> 16r20.
		'_OffsetOf_iLayerType' -> 16r1A.
		'_OffsetOf_iPixelType' -> 16r8.
		'_OffsetOf_nSize' -> 16r0.
		'_OffsetOf_nVersion' -> 16r2
	}!
OS.PIXELFORMATDESCRIPTOR guid: (Core.GUID fromString: '{9b1f091d-48dd-4f2d-98c3-6e6348abdb67}')!
OS.PIXELFORMATDESCRIPTOR comment: '<PIXELFORMATDESCRIPTOR> is an <ExternalStructure> class to wrap the struct ''Win32.PIXELFORMATDESCRIPTOR'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(9B1F091D-48DD-4F2D-98C3-6E6348ABDB67)]
struct tagPIXELFORMATDESCRIPTOR {
	unsigned short nSize;
	unsigned short nVersion;
	unsigned long dwFlags;
	BYTE iPixelType;
	BYTE cColorBits;
	BYTE cRedBits;
	BYTE cRedShift;
	BYTE cGreenBits;
	BYTE cGreenShift;
	BYTE cBlueBits;
	BYTE cBlueShift;
	BYTE cAlphaBits;
	BYTE cAlphaShift;
	BYTE cAccumBits;
	BYTE cAccumRedBits;
	BYTE cAccumGreenBits;
	BYTE cAccumBlueBits;
	BYTE cAccumAlphaBits;
	BYTE cDepthBits;
	BYTE cStencilBits;
	BYTE cAuxBuffers;
	BYTE iLayerType;
	BYTE bReserved;
	unsigned long dwLayerMask;
	unsigned long dwVisibleMask;
	unsigned long dwDamageMask;
} PIXELFORMATDESCRIPTOR;
'!
!OS.PIXELFORMATDESCRIPTOR categoriesForClass!Win32-Structs! !
!OS.PIXELFORMATDESCRIPTOR methodsFor!

bReserved
	"Answer the <Integer> value of the receiver's 'bReserved' field."

	^bytes byteAtOffset: _OffsetOf_bReserved!

bReserved: anInteger
	"Set the receiver's 'bReserved' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_bReserved put: anInteger!

cAccumAlphaBits
	"Answer the <Integer> value of the receiver's 'cAccumAlphaBits' field."

	^bytes byteAtOffset: _OffsetOf_cAccumAlphaBits!

cAccumAlphaBits: anInteger
	"Set the receiver's 'cAccumAlphaBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAccumAlphaBits put: anInteger!

cAccumBits
	"Answer the <Integer> value of the receiver's 'cAccumBits' field."

	^bytes byteAtOffset: _OffsetOf_cAccumBits!

cAccumBits: anInteger
	"Set the receiver's 'cAccumBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAccumBits put: anInteger!

cAccumBlueBits
	"Answer the <Integer> value of the receiver's 'cAccumBlueBits' field."

	^bytes byteAtOffset: _OffsetOf_cAccumBlueBits!

cAccumBlueBits: anInteger
	"Set the receiver's 'cAccumBlueBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAccumBlueBits put: anInteger!

cAccumGreenBits
	"Answer the <Integer> value of the receiver's 'cAccumGreenBits' field."

	^bytes byteAtOffset: _OffsetOf_cAccumGreenBits!

cAccumGreenBits: anInteger
	"Set the receiver's 'cAccumGreenBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAccumGreenBits put: anInteger!

cAccumRedBits
	"Answer the <Integer> value of the receiver's 'cAccumRedBits' field."

	^bytes byteAtOffset: _OffsetOf_cAccumRedBits!

cAccumRedBits: anInteger
	"Set the receiver's 'cAccumRedBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAccumRedBits put: anInteger!

cAlphaBits
	"Answer the <Integer> value of the receiver's 'cAlphaBits' field."

	^bytes byteAtOffset: _OffsetOf_cAlphaBits!

cAlphaBits: anInteger
	"Set the receiver's 'cAlphaBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAlphaBits put: anInteger!

cAlphaShift
	"Answer the <Integer> value of the receiver's 'cAlphaShift' field."

	^bytes byteAtOffset: _OffsetOf_cAlphaShift!

cAlphaShift: anInteger
	"Set the receiver's 'cAlphaShift' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAlphaShift put: anInteger!

cAuxBuffers
	"Answer the <Integer> value of the receiver's 'cAuxBuffers' field."

	^bytes byteAtOffset: _OffsetOf_cAuxBuffers!

cAuxBuffers: anInteger
	"Set the receiver's 'cAuxBuffers' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cAuxBuffers put: anInteger!

cBlueBits
	"Answer the <Integer> value of the receiver's 'cBlueBits' field."

	^bytes byteAtOffset: _OffsetOf_cBlueBits!

cBlueBits: anInteger
	"Set the receiver's 'cBlueBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cBlueBits put: anInteger!

cBlueShift
	"Answer the <Integer> value of the receiver's 'cBlueShift' field."

	^bytes byteAtOffset: _OffsetOf_cBlueShift!

cBlueShift: anInteger
	"Set the receiver's 'cBlueShift' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cBlueShift put: anInteger!

cColorBits
	"Answer the <Integer> value of the receiver's 'cColorBits' field."

	^bytes byteAtOffset: _OffsetOf_cColorBits!

cColorBits: anInteger
	"Set the receiver's 'cColorBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cColorBits put: anInteger!

cDepthBits
	"Answer the <Integer> value of the receiver's 'cDepthBits' field."

	^bytes byteAtOffset: _OffsetOf_cDepthBits!

cDepthBits: anInteger
	"Set the receiver's 'cDepthBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cDepthBits put: anInteger!

cGreenBits
	"Answer the <Integer> value of the receiver's 'cGreenBits' field."

	^bytes byteAtOffset: _OffsetOf_cGreenBits!

cGreenBits: anInteger
	"Set the receiver's 'cGreenBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cGreenBits put: anInteger!

cGreenShift
	"Answer the <Integer> value of the receiver's 'cGreenShift' field."

	^bytes byteAtOffset: _OffsetOf_cGreenShift!

cGreenShift: anInteger
	"Set the receiver's 'cGreenShift' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cGreenShift put: anInteger!

cRedBits
	"Answer the <Integer> value of the receiver's 'cRedBits' field."

	^bytes byteAtOffset: _OffsetOf_cRedBits!

cRedBits: anInteger
	"Set the receiver's 'cRedBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cRedBits put: anInteger!

cRedShift
	"Answer the <Integer> value of the receiver's 'cRedShift' field."

	^bytes byteAtOffset: _OffsetOf_cRedShift!

cRedShift: anInteger
	"Set the receiver's 'cRedShift' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cRedShift put: anInteger!

cStencilBits
	"Answer the <Integer> value of the receiver's 'cStencilBits' field."

	^bytes byteAtOffset: _OffsetOf_cStencilBits!

cStencilBits: anInteger
	"Set the receiver's 'cStencilBits' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_cStencilBits put: anInteger!

dwDamageMask
	"Answer the <Integer> value of the receiver's 'dwDamageMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwDamageMask!

dwDamageMask: anInteger
	"Set the receiver's 'dwDamageMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwDamageMask put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

dwLayerMask
	"Answer the <Integer> value of the receiver's 'dwLayerMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwLayerMask!

dwLayerMask: anInteger
	"Set the receiver's 'dwLayerMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwLayerMask put: anInteger!

dwVisibleMask
	"Answer the <Integer> value of the receiver's 'dwVisibleMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwVisibleMask!

dwVisibleMask: anInteger
	"Set the receiver's 'dwVisibleMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwVisibleMask put: anInteger!

iLayerType
	"Answer the <Integer> value of the receiver's 'iLayerType' field."

	^bytes byteAtOffset: _OffsetOf_iLayerType!

iLayerType: anInteger
	"Set the receiver's 'iLayerType' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_iLayerType put: anInteger!

iPixelType
	"Answer the <Integer> value of the receiver's 'iPixelType' field."

	^bytes byteAtOffset: _OffsetOf_iPixelType!

iPixelType: anInteger
	"Set the receiver's 'iPixelType' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_iPixelType put: anInteger!

nSize
	"Answer the <Integer> value of the receiver's 'nSize' field."

	^bytes wordAtOffset: _OffsetOf_nSize!

nSize: anInteger
	"Set the receiver's 'nSize' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nSize put: anInteger!

nVersion
	"Answer the <Integer> value of the receiver's 'nVersion' field."

	^bytes wordAtOffset: _OffsetOf_nVersion!

nVersion: anInteger
	"Set the receiver's 'nVersion' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_nVersion put: anInteger! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #bReserved!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #bReserved:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumAlphaBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumAlphaBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBlueBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBlueBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumGreenBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumGreenBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumRedBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAccumRedBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaShift!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaShift:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAuxBuffers!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cAuxBuffers:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cBlueBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cBlueBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cBlueShift!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cBlueShift:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cColorBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cColorBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cDepthBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cDepthBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cGreenBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cGreenBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cGreenShift!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cGreenShift:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cRedBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cRedBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cRedShift!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cRedShift:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cStencilBits!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #cStencilBits:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwDamageMask!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwDamageMask:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwFlags!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwFlags:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwLayerMask!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwLayerMask:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwVisibleMask!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #dwVisibleMask:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #iLayerType!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #iLayerType:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #iPixelType!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #iPixelType:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #nSize!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #nSize:!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #nVersion!**compiled accessors**!public! !
!OS.PIXELFORMATDESCRIPTOR categoriesFor: #nVersion:!**compiled accessors**!public! !

!OS.PIXELFORMATDESCRIPTOR class methodsFor!

defineFields
	"Define the fields of the PIXELFORMATDESCRIPTOR structure.

	PIXELFORMATDESCRIPTOR  compileDefinition

		typedef [uuid(9B1F091D-48DD-4F2D-98C3-6E6348ABDB67)]
		struct tagPIXELFORMATDESCRIPTOR {
			unsigned short nSize;
			unsigned short nVersion;
			unsigned long dwFlags;
			BYTE iPixelType;
			BYTE cColorBits;
			BYTE cRedBits;
			BYTE cRedShift;
			BYTE cGreenBits;
			BYTE cGreenShift;
			BYTE cBlueBits;
			BYTE cBlueShift;
			BYTE cAlphaBits;
			BYTE cAlphaShift;
			BYTE cAccumBits;
			BYTE cAccumRedBits;
			BYTE cAccumGreenBits;
			BYTE cAccumBlueBits;
			BYTE cAccumAlphaBits;
			BYTE cDepthBits;
			BYTE cStencilBits;
			BYTE cAuxBuffers;
			BYTE iLayerType;
			BYTE bReserved;
			unsigned long dwLayerMask;
			unsigned long dwVisibleMask;
			unsigned long dwDamageMask;
		} PIXELFORMATDESCRIPTOR;
"

	self
		defineField: #nSize
			type: WORDField new
			offset: 0;
		defineField: #nVersion
			type: WORDField new
			offset: 2;
		defineField: #dwFlags
			type: DWORDField new
			offset: 4;
		defineField: #iPixelType
			type: BYTEField new
			offset: 8;
		defineField: #cColorBits
			type: BYTEField new
			offset: 9;
		defineField: #cRedBits
			type: BYTEField new
			offset: 10;
		defineField: #cRedShift
			type: BYTEField new
			offset: 11;
		defineField: #cGreenBits
			type: BYTEField new
			offset: 12;
		defineField: #cGreenShift
			type: BYTEField new
			offset: 13;
		defineField: #cBlueBits
			type: BYTEField new
			offset: 14;
		defineField: #cBlueShift
			type: BYTEField new
			offset: 15;
		defineField: #cAlphaBits
			type: BYTEField new
			offset: 16;
		defineField: #cAlphaShift
			type: BYTEField new
			offset: 17;
		defineField: #cAccumBits
			type: BYTEField new
			offset: 18;
		defineField: #cAccumRedBits
			type: BYTEField new
			offset: 19;
		defineField: #cAccumGreenBits
			type: BYTEField new
			offset: 20;
		defineField: #cAccumBlueBits
			type: BYTEField new
			offset: 21;
		defineField: #cAccumAlphaBits
			type: BYTEField new
			offset: 22;
		defineField: #cDepthBits
			type: BYTEField new
			offset: 23;
		defineField: #cStencilBits
			type: BYTEField new
			offset: 24;
		defineField: #cAuxBuffers
			type: BYTEField new
			offset: 25;
		defineField: #iLayerType
			type: BYTEField new
			offset: 26;
		defineField: #bReserved
			type: BYTEField new
			offset: 27;
		defineField: #dwLayerMask
			type: DWORDField new
			offset: 28;
		defineField: #dwVisibleMask
			type: DWORDField new
			offset: 32;
		defineField: #dwDamageMask
			type: DWORDField new
			offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#nSize #nVersion #dwFlags #iPixelType #cColorBits #cRedBits #cRedShift #cGreenBits #cGreenShift #cBlueBits #cBlueShift #cAlphaBits #cAlphaShift #cAccumBits #cAccumRedBits #cAccumGreenBits #cAccumBlueBits #cAccumAlphaBits #cDepthBits #cStencilBits #cAuxBuffers #iLayerType #bReserved #dwLayerMask #dwVisibleMask #dwDamageMask)! !
!OS.PIXELFORMATDESCRIPTOR class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.PIXELFORMATDESCRIPTOR class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

