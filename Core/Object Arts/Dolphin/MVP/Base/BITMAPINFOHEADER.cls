"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #BITMAPINFOHEADER
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_biBitCount _OffsetOf_biClrImportant _OffsetOf_biClrUsed _OffsetOf_biCompression _OffsetOf_biHeight _OffsetOf_biPlanes _OffsetOf_biSizeImage _OffsetOf_biWidth _OffsetOf_biXPelsPerMeter _OffsetOf_biYPelsPerMeter _OffsetOf_dwSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BITMAPINFOHEADER guid: (GUID fromString: '{87b4c5cb-026e-11d3-9fd7-00a0cc3e4a32}')!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biBitCount' value: 16rE!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biClrImportant' value: 16r24!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biClrUsed' value: 16r20!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biCompression' value: 16r10!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biHeight' value: 16r8!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biPlanes' value: 16rC!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biSizeImage' value: 16r14!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biWidth' value: 16r4!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biXPelsPerMeter' value: 16r18!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_biYPelsPerMeter' value: 16r1C!
BITMAPINFOHEADER addClassConstant: '_OffsetOf_dwSize' value: 16r0!
BITMAPINFOHEADER comment: 'BITMAPINFOHEADER is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAPINFOHEADER structure is used for header information describing device-independent bitmaps.'!
!BITMAPINFOHEADER categoriesForClass!External-Data-Structured-Win32! !
!BITMAPINFOHEADER methodsFor!

biBitCount
	"Answer the <Integer> value of the receiver's 'biBitCount' field."

	^bytes wordAtOffset: _OffsetOf_biBitCount!

biBitCount: anInteger
	"Set the receiver's 'biBitCount' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_biBitCount put: anInteger!

biClrImportant
	"Answer the <Integer> value of the receiver's 'biClrImportant' field."

	^bytes dwordAtOffset: _OffsetOf_biClrImportant!

biClrImportant: anInteger
	"Set the receiver's 'biClrImportant' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_biClrImportant put: anInteger!

biClrUsed
	"Answer the <Integer> value of the receiver's 'biClrUsed' field."

	^bytes dwordAtOffset: _OffsetOf_biClrUsed!

biClrUsed: anInteger
	"Set the receiver's 'biClrUsed' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_biClrUsed put: anInteger!

biCompression
	"Answer the <Integer> value of the receiver's 'biCompression' field."

	^bytes dwordAtOffset: _OffsetOf_biCompression!

biCompression: anInteger
	"Set the receiver's 'biCompression' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_biCompression put: anInteger!

biHeight
	"Answer the <Integer> value of the receiver's 'biHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_biHeight!

biHeight: anInteger
	"Set the receiver's 'biHeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_biHeight put: anInteger!

biPlanes
	"Answer the <Integer> value of the receiver's 'biPlanes' field."

	^bytes wordAtOffset: _OffsetOf_biPlanes!

biPlanes: anInteger
	"Set the receiver's 'biPlanes' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_biPlanes put: anInteger!

biSizeImage
	"Answer the <Integer> value of the receiver's 'biSizeImage' field."

	^bytes dwordAtOffset: _OffsetOf_biSizeImage!

biSizeImage: anInteger
	"Set the receiver's 'biSizeImage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_biSizeImage put: anInteger!

biWidth
	"Answer the <Integer> value of the receiver's 'biWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_biWidth!

biWidth: anInteger
	"Set the receiver's 'biWidth' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_biWidth put: anInteger!

biXPelsPerMeter
	"Answer the <Integer> value of the receiver's 'biXPelsPerMeter' field."

	^bytes sdwordAtOffset: _OffsetOf_biXPelsPerMeter!

biXPelsPerMeter: anInteger
	"Set the receiver's 'biXPelsPerMeter' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_biXPelsPerMeter put: anInteger!

biYPelsPerMeter
	"Answer the <Integer> value of the receiver's 'biYPelsPerMeter' field."

	^bytes sdwordAtOffset: _OffsetOf_biYPelsPerMeter!

biYPelsPerMeter: anInteger
	"Set the receiver's 'biYPelsPerMeter' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_biYPelsPerMeter put: anInteger!

depth
	"Answer the colour depth of the bitmap described by the receiver."

	^self biBitCount!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

extent
	"Answer the width and height (in pels) of the the bitmap described by the receiver."

	^self biWidth @ self biHeight!

numQuads
	"Answer the number of RGBQUADs specified in the receiver (for use in conjunction
	with BITMAPINFO).
	N.B. The determination of the number of colors is rather complicated - please
	check the Win32 help to assure yourself that this calculation is correct."

	| depth |
	depth := self depth.
	^depth < 16 
		ifTrue: [2 raisedToInteger: depth]
		ifFalse: [
			(depth == 24 or: [self biCompression == BI_RGB])
				ifTrue: [0]
				ifFalse: [3]]
! !
!BITMAPINFOHEADER categoriesForMethods!
biBitCount!**compiled accessors**!public! !
biBitCount:!**compiled accessors**!public! !
biClrImportant!**compiled accessors**!public! !
biClrImportant:!**compiled accessors**!public! !
biClrUsed!**compiled accessors**!public! !
biClrUsed:!**compiled accessors**!public! !
biCompression!**compiled accessors**!public! !
biCompression:!**compiled accessors**!public! !
biHeight!**compiled accessors**!public! !
biHeight:!**compiled accessors**!public! !
biPlanes!**compiled accessors**!public! !
biPlanes:!**compiled accessors**!public! !
biSizeImage!**compiled accessors**!public! !
biSizeImage:!**compiled accessors**!public! !
biWidth!**compiled accessors**!public! !
biWidth:!**compiled accessors**!public! !
biXPelsPerMeter!**compiled accessors**!public! !
biXPelsPerMeter:!**compiled accessors**!public! !
biYPelsPerMeter!**compiled accessors**!public! !
biYPelsPerMeter:!**compiled accessors**!public! !
depth!accessing!public! !
dwSize:!**compiled accessors**!public! !
extent!accessing!public! !
numQuads!initializing!public! !
!

!BITMAPINFOHEADER class methodsFor!

defineFields
	"Define the Win32 BITMAPINFOHEADER structure
		BITMAPINFOHEADER compileDefinition
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #biWidth type: SDWORDField new;
		defineField: #biHeight type: SDWORDField new;
		defineField: #biPlanes type: WORDField new;
		defineField: #biBitCount type: WORDField new;
		defineField: #biCompression type: DWORDField new;
		defineField: #biSizeImage type: DWORDField new;
		defineField: #biXPelsPerMeter type: SDWORDField new;
		defineField: #biYPelsPerMeter type: SDWORDField new;
		defineField: #biClrUsed type: DWORDField new;
		defineField: #biClrImportant type: DWORDField new
!

getFieldNames
	^#(#dwSize #biWidth #biHeight #biPlanes #biBitCount #biCompression #biSizeImage #biXPelsPerMeter #biYPelsPerMeter #biClrUsed #biClrImportant)! !
!BITMAPINFOHEADER class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

