"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ContainerViewTest
	instanceVariableNames: 'containerView'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
ContainerViewTest guid: (GUID fromString: '{4E892CF1-595A-44AD-9A6D-0C319B32D174}')!
ContainerViewTest comment: ''!
!ContainerViewTest categoriesForClass!Unclassified! !
!ContainerViewTest methodsFor!

backgroundColor
	"Private - Answer the background color we will test with. This shuld be different from that of the parent window background"

	^Color red!

borderColor
	"Private - Answer the standard border color. This may have to be changed depending on the Windows theme settings"

	^RGB fromInteger: 6579300!

borderRectangleOf: aView 
	"Private - Answer the Rectangle for the non-client border of aView in the coordinate system of the NC area. Note that this is not the same as the
	#rectangle since the right and bottom edges of the border must fit withing the latter."

	^0 @ 0 extent: aView extent - 1 asPoint!

checkBorderedNcRectangle: borderWidth 
	"Private - Check that applying a border correctly changes the NC and Client rectagle calcs"

	| clientRect parentRect calcClientRect calcNcRect |
	clientRect := containerView clientRectangle.
	parentRect := containerView rectangle.
	self assert: clientRect position = Point zero.
	self assert: clientRect extent = (parentRect extent - (borderWidth * 2) asPoint).
	self assert: parentRect position = containerView position.

	calcClientRect := containerView calcClientRectangleFromRectangle: parentRect.
	self assert: calcClientRect position = Point zero.
	self assert: calcClientRect extent = (parentRect extent - (borderWidth * 2) asPoint).

	calcNcRect := containerView calcRectangleFromClientRectangle: clientRect.
	self assert: calcNcRect position = (Point zero - (borderWidth) asPoint).
	self assert: calcNcRect extent = (clientRect extent + (2*borderWidth) asPoint).
	self assert: calcNcRect extent = parentRect extent.

	calcNcRect := containerView calcRectangleFromClientRectangle: calcClientRect.
	self assert: calcNcRect position = (Point zero - borderWidth asPoint).
	self assert: calcNcRect extent = (clientRect extent + (2*borderWidth) asPoint).
	self assert: calcNcRect extent = parentRect extent!

checkPoints: aPointsArray inBitmap: bitmap color: color 
	"
	ImagePresenter showOn: bitmap
	"

	| bitmapCanvas requiredColor foundColorValue |
	bitmapCanvas := bitmap canvas.
	requiredColor := color asRGB.
	aPointsArray 
		do: [:each | self assert: (foundColorValue := bitmapCanvas pixelAt: each) = requiredColor]!

checkRectangle: rect inBitmap: bitmap color: color 
	"
	ImagePresenter showOn: bitmap
	"

	self 
		checkPoints: (Array 
				with: rect topLeft
				with: rect topRight
				with: rect bottomLeft
				with: rect bottomRight)
		inBitmap: bitmap
		color: color!

containerClass
	^ContainerView!

initialParentExtent
	"Answer the extent of the view under test. Keep this fairly small to avoid length
	Bitmap>>pixelData calls when extracting the visible data"

	^30 @ 40!

initialParentRect
	^10 @ 20 extent: self initialParentExtent!

setUp
	containerView := self containerClass show.
	containerView topView layoutManager: nil.
	containerView rectangle: self initialParentRect.
	containerView backcolor: self backgroundColor!

tearDown	
	containerView topView destroy!

test1PixBorderPaint
	"Tests the validity of WM_PAINT of a 1 pixel border"

	| paintBitmap |
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

testBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"
	
	containerView hasBorder: true.
	self assert: containerView hasBorder.
	self checkBorderedNcRectangle:1.!

testBordersPrintAndPaintIdentical
	"Checks that the WM_PRINT image (used by the VC) and the WM_PAINT image (shown on the
	display) are the same. This uses the rather slow Bitmap>>pixelData method so best keep the
	actual view size fairly small."

	"Test not bordered"

	| paintPixels printPixels paintPixelsBordered printPixelsBordered |
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
	self deny: paintPixels = paintPixelsBordered!

testNcCalcSize
	"Border off - simple text"

	| rect params ret clientRect parentRect |
	rect := RECT fromRectangle: containerView rectangle.
	self assert: rect asRectangle = self initialParentRect.
	ret := containerView 
				sendMessage: WM_NCCALCSIZE
				wParam: false asParameter
				lpParam: rect asParameter.
	self assert: ret = 0.
	self assert: rect asRectangle = self initialParentRect.

	"Border off advanced test"
	params := NCCALCSIZE_PARAMS new.
	parentRect := containerView rectangle.
	params rgrc at: 1 put: (RECT fromRectangle: parentRect).
	ret := containerView 
				sendMessage: WM_NCCALCSIZE
				wParam: true asParameter
				lpParam: params asParameter.
	self assert: ret = 0.

	"Border on simple test"
	containerView hasBorder: true.
	rect := RECT fromRectangle: containerView rectangle.
	self assert: rect asRectangle = self initialParentRect.
	ret := containerView 
				sendMessage: WM_NCCALCSIZE
				wParam: false asParameter
				lpParam: rect asParameter.
	self assert: ret = 0.
	self assert: rect topLeft = (self initialParentRect topLeft + 1 asPoint).
	self assert: rect bottomRight = (self initialParentRect bottomRight - 1 asPoint).

	"Border on advanced test"
	params := NCCALCSIZE_PARAMS new.
	parentRect := containerView rectangle.
	params rgrc at: 1 put: (RECT fromRectangle: parentRect).
	ret := containerView 
				sendMessage: WM_NCCALCSIZE
				wParam: true asParameter
				lpParam: params asParameter.
	self assert: ret = 0!

testNonBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"

	| clientRect parentRect calcClientRect calcNcRect |
	self deny: containerView hasBorder.
	clientRect := containerView clientRectangle.
	parentRect := containerView rectangle.
	self assert: clientRect position=Point zero.
	self assert: clientRect extent=parentRect extent.
	self assert: parentRect position=containerView position.

	calcClientRect := containerView calcClientRectangleFromRectangle: parentRect.
	self assert: calcClientRect position=Point zero.
	self assert: calcClientRect extent=parentRect extent.	

	calcNcRect := containerView calcRectangleFromClientRectangle: clientRect.
	self assert: calcNcRect position=Point zero.
	self assert: calcNcRect extent=clientRect extent.	

	calcNcRect := containerView calcRectangleFromClientRectangle: calcClientRect .
	self assert: calcNcRect position=Point zero.
	self assert: calcNcRect extent=clientRect extent.	


	!

waitForScreenUpdate
	containerView topView update.
	5 timesRepeat: 
			[SessionManager current inputState pumpMessages.
			Processor sleep: 100]! !
!ContainerViewTest categoriesFor: #backgroundColor!private! !
!ContainerViewTest categoriesFor: #borderColor!private! !
!ContainerViewTest categoriesFor: #borderRectangleOf:!private! !
!ContainerViewTest categoriesFor: #checkBorderedNcRectangle:!private! !
!ContainerViewTest categoriesFor: #checkPoints:inBitmap:color:!private! !
!ContainerViewTest categoriesFor: #checkRectangle:inBitmap:color:!private! !
!ContainerViewTest categoriesFor: #containerClass!private! !
!ContainerViewTest categoriesFor: #initialParentExtent!private!Running! !
!ContainerViewTest categoriesFor: #initialParentRect!private!Running! !
!ContainerViewTest categoriesFor: #setUp!public!Running! !
!ContainerViewTest categoriesFor: #tearDown!public!Running! !
!ContainerViewTest categoriesFor: #test1PixBorderPaint!public! !
!ContainerViewTest categoriesFor: #test1PixBorderPrint!public! !
!ContainerViewTest categoriesFor: #testBorderedNcRectangle!public! !
!ContainerViewTest categoriesFor: #testBordersPrintAndPaintIdentical!public! !
!ContainerViewTest categoriesFor: #testNcCalcSize!public! !
!ContainerViewTest categoriesFor: #testNonBorderedNcRectangle!public! !
!ContainerViewTest categoriesFor: #waitForScreenUpdate!private! !

