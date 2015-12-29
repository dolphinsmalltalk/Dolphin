"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #BITMAPINFOHEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BITMAPINFOHEADER guid: (GUID fromString: '{87B4C5CB-026E-11D3-9FD7-00A0CC3E4A32}')!
BITMAPINFOHEADER comment: 'BITMAPINFOHEADER is an <ExternalStructure> class to represent the Win32 structure of the same name.

The BITMAPINFOHEADER structure is used for header information describing device-independent bitmaps.'!
!BITMAPINFOHEADER categoriesForClass!External-Data-Structured-Win32! !
!BITMAPINFOHEADER methodsFor!

biBitCount
	"Answer the receiver's biBitCount field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #biBitCount)!

biBitCount: anObject 
	"Set the receiver's biBitCount field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #biBitCount) put: anObject!

biClrImportant
	"Answer the receiver's biClrImportant field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #biClrImportant)!

biClrImportant: anObject 
	"Set the receiver's biClrImportant field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #biClrImportant) put: anObject!

biClrUsed
	"Answer the receiver's biClrUsed field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #biClrUsed)!

biClrUsed: anObject 
	"Set the receiver's biClrUsed field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #biClrUsed) put: anObject!

biCompression
	"Answer the receiver's biCompression field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #biCompression)!

biCompression: anObject 
	"Set the receiver's biCompression field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #biCompression) put: anObject!

biHeight
	"Answer the receiver's biHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #biHeight)!

biHeight: anObject 
	"Set the receiver's biHeight field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #biHeight) put: anObject!

biPlanes
	"Answer the receiver's biPlanes field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #biPlanes)!

biPlanes: anObject 
	"Set the receiver's biPlanes field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #biPlanes) put: anObject!

biSizeImage
	"Answer the receiver's biSizeImage field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #biSizeImage)!

biSizeImage: anObject 
	"Set the receiver's biSizeImage field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #biSizeImage) put: anObject!

biWidth
	"Answer the receiver's biWidth field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #biWidth)!

biWidth: anObject 
	"Set the receiver's biWidth field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #biWidth) put: anObject!

biXPelsPerMeter
	"Answer the receiver's biXPelsPerMeter field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #biXPelsPerMeter)!

biXPelsPerMeter: anObject 
	"Set the receiver's biXPelsPerMeter field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #biXPelsPerMeter) put: anObject!

biYPelsPerMeter
	"Answer the receiver's biYPelsPerMeter field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #biYPelsPerMeter)!

biYPelsPerMeter: anObject 
	"Set the receiver's biYPelsPerMeter field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #biYPelsPerMeter) put: anObject!

depth
	"Answer the colour depth of the bitmap described by the receiver."

	^self biBitCount!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

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
!BITMAPINFOHEADER categoriesFor: #biBitCount!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biBitCount:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biClrImportant!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biClrImportant:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biClrUsed!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biClrUsed:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biCompression!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biCompression:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biHeight!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biHeight:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biPlanes!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biPlanes:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biSizeImage!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biSizeImage:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biWidth!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biWidth:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biXPelsPerMeter!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biXPelsPerMeter:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biYPelsPerMeter!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #biYPelsPerMeter:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #depth!accessing!public! !
!BITMAPINFOHEADER categoriesFor: #dwSize:!**compiled accessors**!public! !
!BITMAPINFOHEADER categoriesFor: #extent!accessing!public! !
!BITMAPINFOHEADER categoriesFor: #numQuads!initializing!public! !

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
! !
!BITMAPINFOHEADER class categoriesFor: #defineFields!initializing!public! !

