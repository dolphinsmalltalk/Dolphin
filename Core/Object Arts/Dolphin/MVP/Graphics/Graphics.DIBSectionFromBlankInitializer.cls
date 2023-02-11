"Filed out from Dolphin Smalltalk"!

Graphics.AbstractBitmapFromBlankInitializer subclass: #'Graphics.DIBSectionFromBlankInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.DIBSectionFromBlankInitializer guid: (Core.GUID fromString: '{0953f281-a3a6-4a0d-be96-7f12bd1fc826}')!
Graphics.DIBSectionFromBlankInitializer comment: ''!
!Graphics.DIBSectionFromBlankInitializer methodsFor!

createImage: anImage extent: aPoint
	| info |
	info := BITMAPINFOHEADER newBuffer.
	info
		biWidth: aPoint x;
		biHeight: aPoint y negated;
		biPlanes: 1;
		biBitCount: depth.
	"The default compression is BI_RGB (0), so we don't need to set it"
	^depth > 8
		ifTrue: 
			["RGB usage"
			Gdi32
				createDIBSection: 0
				pbmi: info
				iUsage: DIB_RGB_COLORS
				ppvBits: nil
				hSection: 0
				dwOffset: 0]
		ifFalse: 
			[| palBitmap hdc bits dibSection |
			"Palettized usage"
			bits := UInt32Bytes new.
			palBitmap := Gdi32
						createBitmap: 1
						nHeight: 1
						cPlanes: 1
						cBitsPerPel: depth
						lpvBits: bits.
			hdc := Gdi32 createCompatibleDC: nil.
			Gdi32 selectObject: hdc hgdiobj: palBitmap.
			dibSection := Gdi32
						createDIBSection: hdc
						pbmi: info
						iUsage: DIB_PAL_COLORS
						ppvBits: nil
						hSection: 0
						dwOffset: 0.
			Gdi32
				deleteDC: hdc;
				deleteObject: palBitmap.
			dibSection]! !
!Graphics.DIBSectionFromBlankInitializer categoriesForMethods!
createImage:extent:!private!realizing/unrealizing! !
!

!Graphics.DIBSectionFromBlankInitializer class methodsFor!

extent: aPoint depth: anInteger
	<primitive: 157>
	^self new
		extent: aPoint;
		depth: anInteger;
		yourself! !
!Graphics.DIBSectionFromBlankInitializer class categoriesForMethods!
extent:depth:!instance creation!public! !
!

