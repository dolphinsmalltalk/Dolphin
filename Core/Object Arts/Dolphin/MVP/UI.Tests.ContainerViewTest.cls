"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractContainerViewTest subclass: #'UI.Tests.ContainerViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ContainerViewTest guid: (Core.GUID fromString: '{4e892cf1-595a-44ad-9a6d-0c319b32d174}')!
UI.Tests.ContainerViewTest comment: ''!
!UI.Tests.ContainerViewTest categoriesForClass!Unclassified! !
!UI.Tests.ContainerViewTest methodsFor!

containerClass
	^ContainerView!

test1PixBorderPaint
	"Tests the validity of WM_PAINT of a 1 pixel border"

	| paintBitmap |
	self skipIfCiBuild.	"Fails on AppVeyor only"
	containerView hasBorder: false.
	self waitForScreenUpdate.
	paintBitmap := self bitmapOfPaintView: containerView.
	self
		checkRectangle: (self borderRectangleOf: containerView)
		inBitmap: paintBitmap
		color: self backgroundColor.
	self
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: paintBitmap
		color: self backgroundColor.
	containerView hasBorder: true.
	self waitForScreenUpdate.
	paintBitmap := self bitmapOfPaintView: containerView.
	self
		checkRectangle: (self borderRectangleOf: containerView)
		inBitmap: paintBitmap
		color: self borderColor.
	self
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: paintBitmap
		color: self backgroundColor!

test1PixBorderPrint
	"Tests the validity of WM_PRINT of a 1 pixel border"

	| printBitmap |
	containerView hasBorder: false.
	self waitForScreenUpdate.
	printBitmap := self bitmapOfPrintView: containerView.
	self 
		checkRectangle: (self borderRectangleOf: containerView)
		inBitmap: printBitmap
		color: self backgroundColor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: printBitmap
		color: self backgroundColor.
	containerView hasBorder: true.
	self waitForScreenUpdate.
	printBitmap := self bitmapOfPrintView: containerView.
	self 
		checkRectangle: (self borderRectangleOf: containerView)
		inBitmap: printBitmap
		color: self borderColor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: printBitmap
		color: self backgroundColor!

testBordersPrintAndPaintIdentical
	"Checks that the WM_PRINT image (used by the VC) and the WM_PAINT image (shown on the
	display) are the same. This uses the rather slow Bitmap>>pixelData method so best keep the
	actual view size fairly small."

	"Test not bordered"

	| paintPixels printPixels paintPixelsBordered printPixelsBordered |
	self skipIfCiBuild.	"Fails on AppVeyor only"
	containerView hasBorder: false.
	self waitForScreenUpdate.
	paintPixels := (self bitmapOfPaintView: containerView) pixelData.
	printPixels := (self bitmapOfPrintView: containerView) pixelData.
	self assert: paintPixels = printPixels.

	"Test bordered"
	containerView hasBorder: true.
	self waitForScreenUpdate.
	paintPixelsBordered := (self bitmapOfPaintView: containerView) pixelData.
	printPixelsBordered := (self bitmapOfPrintView: containerView) pixelData.
	self assert: paintPixelsBordered = printPixelsBordered.
	self deny: paintPixels = paintPixelsBordered! !
!UI.Tests.ContainerViewTest categoriesForMethods!
containerClass!private! !
test1PixBorderPaint!public! !
test1PixBorderPrint!public! !
testBordersPrintAndPaintIdentical!public! !
!

