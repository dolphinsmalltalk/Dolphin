"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #PIXELFORMATDESCRIPTOR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PIXELFORMATDESCRIPTOR guid: (GUID fromString: '{9b1f091d-48dd-4f2d-98c3-6e6348abdb67}')!
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
	"Answer the receiver's bReserved field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #bReserved)!

bReserved: anObject 
	"Set the receiver's bReserved field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #bReserved) put: anObject!

cAccumAlphaBits
	"Answer the receiver's cAccumAlphaBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAccumAlphaBits)!

cAccumAlphaBits: anObject 
	"Set the receiver's cAccumAlphaBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAccumAlphaBits) put: anObject!

cAccumBits
	"Answer the receiver's cAccumBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAccumBits)!

cAccumBits: anObject 
	"Set the receiver's cAccumBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAccumBits) put: anObject!

cAccumBlueBits
	"Answer the receiver's cAccumBlueBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAccumBlueBits)!

cAccumBlueBits: anObject 
	"Set the receiver's cAccumBlueBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAccumBlueBits) put: anObject!

cAccumGreenBits
	"Answer the receiver's cAccumGreenBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAccumGreenBits)!

cAccumGreenBits: anObject 
	"Set the receiver's cAccumGreenBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAccumGreenBits) put: anObject!

cAccumRedBits
	"Answer the receiver's cAccumRedBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAccumRedBits)!

cAccumRedBits: anObject 
	"Set the receiver's cAccumRedBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAccumRedBits) put: anObject!

cAlphaBits
	"Answer the receiver's cAlphaBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAlphaBits)!

cAlphaBits: anObject 
	"Set the receiver's cAlphaBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAlphaBits) put: anObject!

cAlphaShift
	"Answer the receiver's cAlphaShift field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAlphaShift)!

cAlphaShift: anObject 
	"Set the receiver's cAlphaShift field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAlphaShift) put: anObject!

cAuxBuffers
	"Answer the receiver's cAuxBuffers field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cAuxBuffers)!

cAuxBuffers: anObject 
	"Set the receiver's cAuxBuffers field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cAuxBuffers) put: anObject!

cBlueBits
	"Answer the receiver's cBlueBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cBlueBits)!

cBlueBits: anObject 
	"Set the receiver's cBlueBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cBlueBits) put: anObject!

cBlueShift
	"Answer the receiver's cBlueShift field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cBlueShift)!

cBlueShift: anObject 
	"Set the receiver's cBlueShift field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cBlueShift) put: anObject!

cColorBits
	"Answer the receiver's cColorBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cColorBits)!

cColorBits: anObject 
	"Set the receiver's cColorBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cColorBits) put: anObject!

cDepthBits
	"Answer the receiver's cDepthBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cDepthBits)!

cDepthBits: anObject 
	"Set the receiver's cDepthBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cDepthBits) put: anObject!

cGreenBits
	"Answer the receiver's cGreenBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cGreenBits)!

cGreenBits: anObject 
	"Set the receiver's cGreenBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cGreenBits) put: anObject!

cGreenShift
	"Answer the receiver's cGreenShift field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cGreenShift)!

cGreenShift: anObject 
	"Set the receiver's cGreenShift field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cGreenShift) put: anObject!

cRedBits
	"Answer the receiver's cRedBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cRedBits)!

cRedBits: anObject 
	"Set the receiver's cRedBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cRedBits) put: anObject!

cRedShift
	"Answer the receiver's cRedShift field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cRedShift)!

cRedShift: anObject 
	"Set the receiver's cRedShift field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cRedShift) put: anObject!

cStencilBits
	"Answer the receiver's cStencilBits field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #cStencilBits)!

cStencilBits: anObject 
	"Set the receiver's cStencilBits field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #cStencilBits) put: anObject!

dwDamageMask
	"Answer the receiver's dwDamageMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwDamageMask)!

dwDamageMask: anObject 
	"Set the receiver's dwDamageMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwDamageMask) put: anObject!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject!

dwLayerMask
	"Answer the receiver's dwLayerMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwLayerMask)!

dwLayerMask: anObject 
	"Set the receiver's dwLayerMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwLayerMask) put: anObject!

dwVisibleMask
	"Answer the receiver's dwVisibleMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwVisibleMask)!

dwVisibleMask: anObject 
	"Set the receiver's dwVisibleMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwVisibleMask) put: anObject!

iLayerType
	"Answer the receiver's iLayerType field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #iLayerType)!

iLayerType: anObject 
	"Set the receiver's iLayerType field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #iLayerType) put: anObject!

iPixelType
	"Answer the receiver's iPixelType field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #iPixelType)!

iPixelType: anObject 
	"Set the receiver's iPixelType field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #iPixelType) put: anObject!

nSize
	"Answer the receiver's nSize field as a Smalltalk object."

	^bytes wordAtOffset: 0!

nSize: anObject 
	"Set the receiver's nSize field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

nVersion
	"Answer the receiver's nVersion field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #nVersion)!

nVersion: anObject 
	"Set the receiver's nVersion field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #nVersion) put: anObject! !
!PIXELFORMATDESCRIPTOR categoriesFor: #bReserved!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #bReserved:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumAlphaBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumAlphaBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBlueBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumBlueBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumGreenBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumGreenBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumRedBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAccumRedBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaShift!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAlphaShift:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAuxBuffers!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cAuxBuffers:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cBlueBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cBlueBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cBlueShift!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cBlueShift:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cColorBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cColorBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cDepthBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cDepthBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cGreenBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cGreenBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cGreenShift!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cGreenShift:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cRedBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cRedBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cRedShift!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cRedShift:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cStencilBits!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #cStencilBits:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwDamageMask!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwDamageMask:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwFlags!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwFlags:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwLayerMask!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwLayerMask:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwVisibleMask!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #dwVisibleMask:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #iLayerType!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #iLayerType:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #iPixelType!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #iPixelType:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #nSize!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #nSize:!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #nVersion!**compiled accessors**!public! !
!PIXELFORMATDESCRIPTOR categoriesFor: #nVersion:!**compiled accessors**!public! !

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
	self byteSize: 40! !
!PIXELFORMATDESCRIPTOR class categoriesFor: #defineFields!**auto generated**!initializing!public! !

