"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.BITMAPINFOHEADER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_BITMAPINFOHEADER_Size' -> 16r28.
		'_OffsetOf_biBitCount' -> 16rE.
		'_OffsetOf_biClrImportant' -> 16r24.
		'_OffsetOf_biClrUsed' -> 16r20.
		'_OffsetOf_biCompression' -> 16r10.
		'_OffsetOf_biHeight' -> 16r8.
		'_OffsetOf_biPlanes' -> 16rC.
		'_OffsetOf_biSizeImage' -> 16r14.
		'_OffsetOf_biWidth' -> 16r4.
		'_OffsetOf_biXPelsPerMeter' -> 16r18.
		'_OffsetOf_biYPelsPerMeter' -> 16r1C.
		'_OffsetOf_dwSize' -> 16r0
	}!
OS.BITMAPINFOHEADER guid: (Core.GUID fromString: '{87b4c5cb-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.BITMAPINFOHEADER comment: 'BITMAPINFOHEADER is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAPINFOHEADER structure is used for header information describing device-independent bitmaps.'!
!OS.BITMAPINFOHEADER categoriesForClass!External-Data-Structured-Win32! !
!OS.BITMAPINFOHEADER methodsFor!

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
	"Answer the width and height (in pels) of the bitmap described by the receiver."

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
!OS.BITMAPINFOHEADER categoriesForMethods!
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

!OS.BITMAPINFOHEADER class methodsFor!

byteSize
	^_BITMAPINFOHEADER_Size!

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
		defineField: #biClrImportant type: DWORDField new!

getFieldNames
	^#(#dwSize #biWidth #biHeight #biPlanes #biBitCount #biCompression #biSizeImage #biXPelsPerMeter #biYPelsPerMeter #biClrUsed #biClrImportant)! !
!OS.BITMAPINFOHEADER class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

