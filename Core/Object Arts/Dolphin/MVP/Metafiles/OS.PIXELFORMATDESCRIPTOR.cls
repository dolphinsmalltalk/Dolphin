"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.PIXELFORMATDESCRIPTOR'
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
			'_OffsetOf_nVersion' -> 16r2.
			'_PIXELFORMATDESCRIPTOR_Size' -> 16r28
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

	^bytes uint8AtOffset: _OffsetOf_bReserved!

bReserved: anInteger
	"Set the receiver's 'bReserved' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_bReserved put: anInteger!

cAccumAlphaBits
	"Answer the <Integer> value of the receiver's 'cAccumAlphaBits' field."

	^bytes uint8AtOffset: _OffsetOf_cAccumAlphaBits!

cAccumAlphaBits: anInteger
	"Set the receiver's 'cAccumAlphaBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAccumAlphaBits put: anInteger!

cAccumBits
	"Answer the <Integer> value of the receiver's 'cAccumBits' field."

	^bytes uint8AtOffset: _OffsetOf_cAccumBits!

cAccumBits: anInteger
	"Set the receiver's 'cAccumBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAccumBits put: anInteger!

cAccumBlueBits
	"Answer the <Integer> value of the receiver's 'cAccumBlueBits' field."

	^bytes uint8AtOffset: _OffsetOf_cAccumBlueBits!

cAccumBlueBits: anInteger
	"Set the receiver's 'cAccumBlueBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAccumBlueBits put: anInteger!

cAccumGreenBits
	"Answer the <Integer> value of the receiver's 'cAccumGreenBits' field."

	^bytes uint8AtOffset: _OffsetOf_cAccumGreenBits!

cAccumGreenBits: anInteger
	"Set the receiver's 'cAccumGreenBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAccumGreenBits put: anInteger!

cAccumRedBits
	"Answer the <Integer> value of the receiver's 'cAccumRedBits' field."

	^bytes uint8AtOffset: _OffsetOf_cAccumRedBits!

cAccumRedBits: anInteger
	"Set the receiver's 'cAccumRedBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAccumRedBits put: anInteger!

cAlphaBits
	"Answer the <Integer> value of the receiver's 'cAlphaBits' field."

	^bytes uint8AtOffset: _OffsetOf_cAlphaBits!

cAlphaBits: anInteger
	"Set the receiver's 'cAlphaBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAlphaBits put: anInteger!

cAlphaShift
	"Answer the <Integer> value of the receiver's 'cAlphaShift' field."

	^bytes uint8AtOffset: _OffsetOf_cAlphaShift!

cAlphaShift: anInteger
	"Set the receiver's 'cAlphaShift' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAlphaShift put: anInteger!

cAuxBuffers
	"Answer the <Integer> value of the receiver's 'cAuxBuffers' field."

	^bytes uint8AtOffset: _OffsetOf_cAuxBuffers!

cAuxBuffers: anInteger
	"Set the receiver's 'cAuxBuffers' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cAuxBuffers put: anInteger!

cBlueBits
	"Answer the <Integer> value of the receiver's 'cBlueBits' field."

	^bytes uint8AtOffset: _OffsetOf_cBlueBits!

cBlueBits: anInteger
	"Set the receiver's 'cBlueBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cBlueBits put: anInteger!

cBlueShift
	"Answer the <Integer> value of the receiver's 'cBlueShift' field."

	^bytes uint8AtOffset: _OffsetOf_cBlueShift!

cBlueShift: anInteger
	"Set the receiver's 'cBlueShift' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cBlueShift put: anInteger!

cColorBits
	"Answer the <Integer> value of the receiver's 'cColorBits' field."

	^bytes uint8AtOffset: _OffsetOf_cColorBits!

cColorBits: anInteger
	"Set the receiver's 'cColorBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cColorBits put: anInteger!

cDepthBits
	"Answer the <Integer> value of the receiver's 'cDepthBits' field."

	^bytes uint8AtOffset: _OffsetOf_cDepthBits!

cDepthBits: anInteger
	"Set the receiver's 'cDepthBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cDepthBits put: anInteger!

cGreenBits
	"Answer the <Integer> value of the receiver's 'cGreenBits' field."

	^bytes uint8AtOffset: _OffsetOf_cGreenBits!

cGreenBits: anInteger
	"Set the receiver's 'cGreenBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cGreenBits put: anInteger!

cGreenShift
	"Answer the <Integer> value of the receiver's 'cGreenShift' field."

	^bytes uint8AtOffset: _OffsetOf_cGreenShift!

cGreenShift: anInteger
	"Set the receiver's 'cGreenShift' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cGreenShift put: anInteger!

cRedBits
	"Answer the <Integer> value of the receiver's 'cRedBits' field."

	^bytes uint8AtOffset: _OffsetOf_cRedBits!

cRedBits: anInteger
	"Set the receiver's 'cRedBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cRedBits put: anInteger!

cRedShift
	"Answer the <Integer> value of the receiver's 'cRedShift' field."

	^bytes uint8AtOffset: _OffsetOf_cRedShift!

cRedShift: anInteger
	"Set the receiver's 'cRedShift' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cRedShift put: anInteger!

cStencilBits
	"Answer the <Integer> value of the receiver's 'cStencilBits' field."

	^bytes uint8AtOffset: _OffsetOf_cStencilBits!

cStencilBits: anInteger
	"Set the receiver's 'cStencilBits' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_cStencilBits put: anInteger!

dwDamageMask
	"Answer the <Integer> value of the receiver's 'dwDamageMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwDamageMask!

dwDamageMask: anInteger
	"Set the receiver's 'dwDamageMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwDamageMask put: anInteger!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger!

dwLayerMask
	"Answer the <Integer> value of the receiver's 'dwLayerMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwLayerMask!

dwLayerMask: anInteger
	"Set the receiver's 'dwLayerMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwLayerMask put: anInteger!

dwVisibleMask
	"Answer the <Integer> value of the receiver's 'dwVisibleMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwVisibleMask!

dwVisibleMask: anInteger
	"Set the receiver's 'dwVisibleMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwVisibleMask put: anInteger!

iLayerType
	"Answer the <Integer> value of the receiver's 'iLayerType' field."

	^bytes uint8AtOffset: _OffsetOf_iLayerType!

iLayerType: anInteger
	"Set the receiver's 'iLayerType' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_iLayerType put: anInteger!

iPixelType
	"Answer the <Integer> value of the receiver's 'iPixelType' field."

	^bytes uint8AtOffset: _OffsetOf_iPixelType!

iPixelType: anInteger
	"Set the receiver's 'iPixelType' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_iPixelType put: anInteger!

nSize
	"Answer the <Integer> value of the receiver's 'nSize' field."

	^bytes uint16AtOffset: _OffsetOf_nSize!

nSize: anInteger
	"Set the receiver's 'nSize' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nSize put: anInteger!

nVersion
	"Answer the <Integer> value of the receiver's 'nVersion' field."

	^bytes uint16AtOffset: _OffsetOf_nVersion!

nVersion: anInteger
	"Set the receiver's 'nVersion' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_nVersion put: anInteger! !
!OS.PIXELFORMATDESCRIPTOR categoriesForMethods!
bReserved!**compiled accessors**!public! !
bReserved:!**compiled accessors**!public! !
cAccumAlphaBits!**compiled accessors**!public! !
cAccumAlphaBits:!**compiled accessors**!public! !
cAccumBits!**compiled accessors**!public! !
cAccumBits:!**compiled accessors**!public! !
cAccumBlueBits!**compiled accessors**!public! !
cAccumBlueBits:!**compiled accessors**!public! !
cAccumGreenBits!**compiled accessors**!public! !
cAccumGreenBits:!**compiled accessors**!public! !
cAccumRedBits!**compiled accessors**!public! !
cAccumRedBits:!**compiled accessors**!public! !
cAlphaBits!**compiled accessors**!public! !
cAlphaBits:!**compiled accessors**!public! !
cAlphaShift!**compiled accessors**!public! !
cAlphaShift:!**compiled accessors**!public! !
cAuxBuffers!**compiled accessors**!public! !
cAuxBuffers:!**compiled accessors**!public! !
cBlueBits!**compiled accessors**!public! !
cBlueBits:!**compiled accessors**!public! !
cBlueShift!**compiled accessors**!public! !
cBlueShift:!**compiled accessors**!public! !
cColorBits!**compiled accessors**!public! !
cColorBits:!**compiled accessors**!public! !
cDepthBits!**compiled accessors**!public! !
cDepthBits:!**compiled accessors**!public! !
cGreenBits!**compiled accessors**!public! !
cGreenBits:!**compiled accessors**!public! !
cGreenShift!**compiled accessors**!public! !
cGreenShift:!**compiled accessors**!public! !
cRedBits!**compiled accessors**!public! !
cRedBits:!**compiled accessors**!public! !
cRedShift!**compiled accessors**!public! !
cRedShift:!**compiled accessors**!public! !
cStencilBits!**compiled accessors**!public! !
cStencilBits:!**compiled accessors**!public! !
dwDamageMask!**compiled accessors**!public! !
dwDamageMask:!**compiled accessors**!public! !
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwLayerMask!**compiled accessors**!public! !
dwLayerMask:!**compiled accessors**!public! !
dwVisibleMask!**compiled accessors**!public! !
dwVisibleMask:!**compiled accessors**!public! !
iLayerType!**compiled accessors**!public! !
iLayerType:!**compiled accessors**!public! !
iPixelType!**compiled accessors**!public! !
iPixelType:!**compiled accessors**!public! !
nSize!**compiled accessors**!public! !
nSize:!**compiled accessors**!public! !
nVersion!**compiled accessors**!public! !
nVersion:!**compiled accessors**!public! !
!

!OS.PIXELFORMATDESCRIPTOR class methodsFor!

byteSize
	^_PIXELFORMATDESCRIPTOR_Size!

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
			type: UInt16Field new
			offset: 0;
		defineField: #nVersion
			type: UInt16Field new
			offset: 2;
		defineField: #dwFlags
			type: UInt32Field new
			offset: 4;
		defineField: #iPixelType
			type: UInt8Field new
			offset: 8;
		defineField: #cColorBits
			type: UInt8Field new
			offset: 9;
		defineField: #cRedBits
			type: UInt8Field new
			offset: 10;
		defineField: #cRedShift
			type: UInt8Field new
			offset: 11;
		defineField: #cGreenBits
			type: UInt8Field new
			offset: 12;
		defineField: #cGreenShift
			type: UInt8Field new
			offset: 13;
		defineField: #cBlueBits
			type: UInt8Field new
			offset: 14;
		defineField: #cBlueShift
			type: UInt8Field new
			offset: 15;
		defineField: #cAlphaBits
			type: UInt8Field new
			offset: 16;
		defineField: #cAlphaShift
			type: UInt8Field new
			offset: 17;
		defineField: #cAccumBits
			type: UInt8Field new
			offset: 18;
		defineField: #cAccumRedBits
			type: UInt8Field new
			offset: 19;
		defineField: #cAccumGreenBits
			type: UInt8Field new
			offset: 20;
		defineField: #cAccumBlueBits
			type: UInt8Field new
			offset: 21;
		defineField: #cAccumAlphaBits
			type: UInt8Field new
			offset: 22;
		defineField: #cDepthBits
			type: UInt8Field new
			offset: 23;
		defineField: #cStencilBits
			type: UInt8Field new
			offset: 24;
		defineField: #cAuxBuffers
			type: UInt8Field new
			offset: 25;
		defineField: #iLayerType
			type: UInt8Field new
			offset: 26;
		defineField: #bReserved
			type: UInt8Field new
			offset: 27;
		defineField: #dwLayerMask
			type: UInt32Field new
			offset: 28;
		defineField: #dwVisibleMask
			type: UInt32Field new
			offset: 32;
		defineField: #dwDamageMask
			type: UInt32Field new
			offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#nSize #nVersion #dwFlags #iPixelType #cColorBits #cRedBits #cRedShift #cGreenBits #cGreenShift #cBlueBits #cBlueShift #cAlphaBits #cAlphaShift #cAccumBits #cAccumRedBits #cAccumGreenBits #cAccumBlueBits #cAccumAlphaBits #cDepthBits #cStencilBits #cAuxBuffers #iLayerType #bReserved #dwLayerMask #dwVisibleMask #dwDamageMask)! !
!OS.PIXELFORMATDESCRIPTOR class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

