"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #PIXELFORMATDESCRIPTOR
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bReserved _OffsetOf_cAccumAlphaBits _OffsetOf_cAccumBits _OffsetOf_cAccumBlueBits _OffsetOf_cAccumGreenBits _OffsetOf_cAccumRedBits _OffsetOf_cAlphaBits _OffsetOf_cAlphaShift _OffsetOf_cAuxBuffers _OffsetOf_cBlueBits _OffsetOf_cBlueShift _OffsetOf_cColorBits _OffsetOf_cDepthBits _OffsetOf_cGreenBits _OffsetOf_cGreenShift _OffsetOf_cRedBits _OffsetOf_cRedShift _OffsetOf_cStencilBits _OffsetOf_dwDamageMask _OffsetOf_dwFlags _OffsetOf_dwLayerMask _OffsetOf_dwVisibleMask _OffsetOf_iLayerType _OffsetOf_iPixelType _OffsetOf_nSize _OffsetOf_nVersion'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PIXELFORMATDESCRIPTOR guid: (GUID fromString: '{9b1f091d-48dd-4f2d-98c3-6e6348abdb67}')!

PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_bReserved' value: 16r1B!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAccumAlphaBits' value: 16r16!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAccumBits' value: 16r12!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAccumBlueBits' value: 16r15!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAccumGreenBits' value: 16r14!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAccumRedBits' value: 16r13!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAlphaBits' value: 16r10!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAlphaShift' value: 16r11!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cAuxBuffers' value: 16r19!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cBlueBits' value: 16rE!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cBlueShift' value: 16rF!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cColorBits' value: 16r9!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cDepthBits' value: 16r17!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cGreenBits' value: 16rC!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cGreenShift' value: 16rD!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cRedBits' value: 16rA!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cRedShift' value: 16rB!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_cStencilBits' value: 16r18!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_dwDamageMask' value: 16r24!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_dwFlags' value: 16r4!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_dwLayerMask' value: 16r1C!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_dwVisibleMask' value: 16r20!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_iLayerType' value: 16r1A!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_iPixelType' value: 16r8!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_nSize' value: 16r0!
PIXELFORMATDESCRIPTOR addClassConstant: '_OffsetOf_nVersion' value: 16r2!

PIXELFORMATDESCRIPTOR comment: '<PIXELFORMATDESCRIPTOR> is an <ExternalStructure> class to wrap the struct ''Win32.PIXELFORMATDESCRIPTOR'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!PIXELFORMATDESCRIPTOR categoriesForClass!Win32-Structs! !

!PIXELFORMATDESCRIPTOR methodsFor!

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

!PIXELFORMATDESCRIPTOR categoriesForMethods!
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

!PIXELFORMATDESCRIPTOR class methodsFor!

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
		defineField: #nSize type: WORDField new offset: 0;
		defineField: #nVersion type: WORDField new offset: 2;
		defineField: #dwFlags type: DWORDField new offset: 4;
		defineField: #iPixelType type: BYTEField new offset: 8;
		defineField: #cColorBits type: BYTEField new offset: 9;
		defineField: #cRedBits type: BYTEField new offset: 10;
		defineField: #cRedShift type: BYTEField new offset: 11;
		defineField: #cGreenBits type: BYTEField new offset: 12;
		defineField: #cGreenShift type: BYTEField new offset: 13;
		defineField: #cBlueBits type: BYTEField new offset: 14;
		defineField: #cBlueShift type: BYTEField new offset: 15;
		defineField: #cAlphaBits type: BYTEField new offset: 16;
		defineField: #cAlphaShift type: BYTEField new offset: 17;
		defineField: #cAccumBits type: BYTEField new offset: 18;
		defineField: #cAccumRedBits type: BYTEField new offset: 19;
		defineField: #cAccumGreenBits type: BYTEField new offset: 20;
		defineField: #cAccumBlueBits type: BYTEField new offset: 21;
		defineField: #cAccumAlphaBits type: BYTEField new offset: 22;
		defineField: #cDepthBits type: BYTEField new offset: 23;
		defineField: #cStencilBits type: BYTEField new offset: 24;
		defineField: #cAuxBuffers type: BYTEField new offset: 25;
		defineField: #iLayerType type: BYTEField new offset: 26;
		defineField: #bReserved type: BYTEField new offset: 27;
		defineField: #dwLayerMask type: DWORDField new offset: 28;
		defineField: #dwVisibleMask type: DWORDField new offset: 32;
		defineField: #dwDamageMask type: DWORDField new offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#nSize #nVersion #dwFlags #iPixelType #cColorBits #cRedBits #cRedShift #cGreenBits #cGreenShift #cBlueBits #cBlueShift #cAlphaBits #cAlphaShift #cAccumBits #cAccumRedBits #cAccumGreenBits #cAccumBlueBits #cAccumAlphaBits #cDepthBits #cStencilBits #cAuxBuffers #iLayerType #bReserved #dwLayerMask #dwVisibleMask #dwDamageMask)! !

!PIXELFORMATDESCRIPTOR class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

