"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.BITMAPINFOHEADER'
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
			'_OffsetOf_biYPelsPerMeter' -> 16r1C
		}!

OS.BITMAPINFOHEADER guid: (Core.GUID fromString: '{87b4c5cb-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.BITMAPINFOHEADER comment: 'BITMAPINFOHEADER is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAPINFOHEADER structure is used for header information describing device-independent bitmaps.'!

!OS.BITMAPINFOHEADER categoriesForClass!External-Data-Structured-Win32! !

!OS.BITMAPINFOHEADER methodsFor!

biBitCount
	"Answer the <Integer> value of the receiver's 'biBitCount' field."

	^bytes uint16AtOffset: _OffsetOf_biBitCount!

biBitCount: anInteger
	"Set the receiver's 'biBitCount' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_biBitCount put: anInteger!

biClrImportant
	"Answer the <Integer> value of the receiver's 'biClrImportant' field."

	^bytes uint32AtOffset: _OffsetOf_biClrImportant!

biClrImportant: anInteger
	"Set the receiver's 'biClrImportant' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_biClrImportant put: anInteger!

biClrUsed
	"Answer the <Integer> value of the receiver's 'biClrUsed' field."

	^bytes uint32AtOffset: _OffsetOf_biClrUsed!

biClrUsed: anInteger
	"Set the receiver's 'biClrUsed' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_biClrUsed put: anInteger!

biCompression
	"Answer the <Integer> value of the receiver's 'biCompression' field."

	^bytes uint32AtOffset: _OffsetOf_biCompression!

biCompression: anInteger
	"Set the receiver's 'biCompression' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_biCompression put: anInteger!

biHeight
	"Answer the <Integer> value of the receiver's 'biHeight' field."

	^bytes int32AtOffset: _OffsetOf_biHeight!

biHeight: anInteger
	"Set the receiver's 'biHeight' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_biHeight put: anInteger!

biPlanes
	"Answer the <Integer> value of the receiver's 'biPlanes' field."

	^bytes uint16AtOffset: _OffsetOf_biPlanes!

biPlanes: anInteger
	"Set the receiver's 'biPlanes' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_biPlanes put: anInteger!

biSizeImage
	"Answer the <Integer> value of the receiver's 'biSizeImage' field."

	^bytes uint32AtOffset: _OffsetOf_biSizeImage!

biSizeImage: anInteger
	"Set the receiver's 'biSizeImage' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_biSizeImage put: anInteger!

biWidth
	"Answer the <Integer> value of the receiver's 'biWidth' field."

	^bytes int32AtOffset: _OffsetOf_biWidth!

biWidth: anInteger
	"Set the receiver's 'biWidth' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_biWidth put: anInteger!

biXPelsPerMeter
	"Answer the <Integer> value of the receiver's 'biXPelsPerMeter' field."

	^bytes int32AtOffset: _OffsetOf_biXPelsPerMeter!

biXPelsPerMeter: anInteger
	"Set the receiver's 'biXPelsPerMeter' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_biXPelsPerMeter put: anInteger!

biYPelsPerMeter
	"Answer the <Integer> value of the receiver's 'biYPelsPerMeter' field."

	^bytes int32AtOffset: _OffsetOf_biYPelsPerMeter!

biYPelsPerMeter: anInteger
	"Set the receiver's 'biYPelsPerMeter' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_biYPelsPerMeter put: anInteger!

depth
	"Answer the colour depth of the bitmap described by the receiver."

	^self biBitCount!

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

	super defineFields.
	self
		defineField: #biWidth type: Int32Field new;
		defineField: #biHeight type: Int32Field new;
		defineField: #biPlanes type: UInt16Field new;
		defineField: #biBitCount type: UInt16Field new;
		defineField: #biCompression type: UInt32Field new;
		defineField: #biSizeImage type: UInt32Field new;
		defineField: #biXPelsPerMeter type: Int32Field new;
		defineField: #biYPelsPerMeter type: Int32Field new;
		defineField: #biClrUsed type: UInt32Field new;
		defineField: #biClrImportant type: UInt32Field new!

getFieldNames
	^#(#dwSize #biWidth #biHeight #biPlanes #biBitCount #biCompression #biSizeImage #biXPelsPerMeter #biYPelsPerMeter #biClrUsed #biClrImportant)! !

!OS.BITMAPINFOHEADER class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

