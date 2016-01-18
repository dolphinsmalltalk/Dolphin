"Filed out from Dolphin Smalltalk 7"!

ContainerViewTest subclass: #StyledContainerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StyledContainerTest guid: (GUID fromString: '{C2D30AF9-3DDD-440F-ADD5-535CD0E410A9}')!
StyledContainerTest comment: ''!
!StyledContainerTest categoriesForClass!Unclassified! !
!StyledContainerTest methodsFor!

containerClass
	^StyledContainer!

parentBackcolor
	^Color green!

styledBorderColor
	^Color blue!

test1PixBorderPaint
	"Tests the validity of WM_PAINT of a 1 pixel border"

	super test1PixBorderPaint!

test1PixBorderPrint
	"Tests the validity of WM_PRINT of a 1 pixel border"

	super test1PixBorderPrint!

test1PixDottedBorderPaint
	"Tests the validity of WM_PAINT of a 1 pixel styled dotted border"

	| bitmap rect |
	containerView hasBorder: true.
	containerView styledPen: (StyledPen 
				color: self styledBorderColor
				width: 1
				style: #dotted).
	containerView parentView backcolor: self parentBackcolor.
	self waitForScreenUpdate.
	bitmap := self bitmapOfPaintView: containerView.
	rect := self borderRectangleOf: containerView.
	self 
		checkPoints: (Array 
				with: rect topRight
				with: rect bottomLeft
				with: rect topLeft)
		inBitmap: bitmap
		color: self styledBorderColor.
	self 
		checkPoints: (Array with: rect bottomRight)
		inBitmap: bitmap
		color: self parentBackcolor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: bitmap
		color: self backgroundColor!

test1PixDottedBorderPrint
	"Tests the validity of WM_PRINT of a 1 pixel styled dotted border"

	| bitmap rect |
	containerView hasBorder: true.
	containerView styledPen: (StyledPen 
				color: self styledBorderColor
				width: 1
				style: #dotted).
	containerView parentView backcolor: self parentBackcolor.
	self waitForScreenUpdate.
	bitmap := self bitmapOfPrintView: containerView.
	rect := self borderRectangleOf: containerView.
	self 
		checkPoints: (Array with: rect topRight with: rect bottomLeft)
		inBitmap: bitmap
		color: self styledBorderColor.

	"Not sure why this test is failing .. appears to work okay in VC"
	self 
		checkPoints: (Array with: rect topLeft with: rect bottomRight)
		inBitmap: bitmap
		color: self parentBackcolor.
	self 
		checkRectangle: ((self borderRectangleOf: containerView) insetBy: 1 asPoint)
		inBitmap: bitmap
		color: self backgroundColor!

testBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"
	
	super testBorderedNcRectangle!

testBordersPrintAndPaintIdentical
	"Checks that the WM_PRINT image (used by the VC) and the WM_PAINT image (shown on the
	display) are the same. This uses the rather slow Bitmap>>pixelData method so best keep the
	actual view size fairly small."

	super testBordersPrintAndPaintIdentical!

testNcCalcSize
	"Border off - simple text"

	super testNcCalcSize!

testNonBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"

	super testNonBorderedNcRectangle! !
!StyledContainerTest categoriesFor: #containerClass!private! !
!StyledContainerTest categoriesFor: #parentBackcolor!private! !
!StyledContainerTest categoriesFor: #styledBorderColor!private! !
!StyledContainerTest categoriesFor: #test1PixBorderPaint!public! !
!StyledContainerTest categoriesFor: #test1PixBorderPrint!public! !
!StyledContainerTest categoriesFor: #test1PixDottedBorderPaint!public! !
!StyledContainerTest categoriesFor: #test1PixDottedBorderPrint!public! !
!StyledContainerTest categoriesFor: #testBorderedNcRectangle!public! !
!StyledContainerTest categoriesFor: #testBordersPrintAndPaintIdentical!public! !
!StyledContainerTest categoriesFor: #testNcCalcSize!public! !
!StyledContainerTest categoriesFor: #testNonBorderedNcRectangle!public! !

