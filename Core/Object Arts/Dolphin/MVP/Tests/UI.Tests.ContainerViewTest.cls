"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractContainerViewTest
	subclass: #'UI.Tests.ContainerViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ContainerViewTest guid: (Core.GUID fromString: '{4e892cf1-595a-44ad-9a6d-0c319b32d174}')!
UI.Tests.ContainerViewTest comment: ''!
!UI.Tests.ContainerViewTest methodsFor!

classToTest
	^ContainerView!

test1PixBorderPaint
	"Tests the validity of WM_PAINT of a 1 pixel border"
	<skipIf: #isCiBuild>	"Fails on AppVeyor only"

	| containerView paintBitmap |
	containerView := self view.
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

	| containerView printBitmap |
	containerView := self view.
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

	"Fails on AppVeyor only"

	<skipIf: #isCiBuild>
	| containerView paintPixels printPixels paintPixelsBordered printPixelsBordered |
	containerView := self view.
	"Test not bordered"
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
classToTest!helpers!private! !
test1PixBorderPaint!public!unit tests! !
test1PixBorderPrint!public!unit tests! !
testBordersPrintAndPaintIdentical!public!unit tests! !
!

!UI.Tests.ContainerViewTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ContainerView)  98 15 0 0 98 2 8 1140850688 131073 416 0 0 0 5 0 0 0 416 0 234 256 98 0 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  1 1 658 701 501 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 658 193 193 0 27 )!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1140850688 131073 416 nil nil nil 5 nil nil nil 416 nil 170 192 8 #() nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 626 701 501 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 626 193 193 nil 27 )! !
!UI.Tests.ContainerViewTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

