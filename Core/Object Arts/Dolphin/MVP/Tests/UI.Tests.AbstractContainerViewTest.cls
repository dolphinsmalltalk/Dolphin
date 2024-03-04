"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.AbstractContainerViewTest'
	instanceVariableNames: 'initialParentRect'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.AbstractContainerViewTest guid: (Core.GUID fromString: '{79c3a28a-ce43-49e3-a030-adb99de3efea}')!

UI.Tests.AbstractContainerViewTest isNonInstantiable: true!

UI.Tests.AbstractContainerViewTest comment: ''!

!UI.Tests.AbstractContainerViewTest methodsFor!

backgroundColor
	"Private - Answer the background color we will test with. This shuld be different from that of the parent window background"

	^Color red!

bitmapOfPaintView: aContainerView 
	| answer ncCanvas extent |
	extent := aContainerView extent.
	answer := Bitmap displayCompatibleWithExtent: extent.
	aContainerView update.
	ncCanvas := aContainerView nonClientCanvas.
	
	[answer canvas 
		bitBlt: ncCanvas
		rectangle: (0 @ 0 extent: extent)
		to: 0 @ 0
		rop: SRCCOPY] 
			ensure: [ncCanvas free].
	^answer!

bitmapOfPrintView: aContainerView
	^Bitmap fromView: aContainerView!

borderColor
	"Private - Answer the standard border color. This may have to be changed depending on the Windows theme settings"

	^Color fromRgbCode: 16r646464!

borderRectangleOf: aView 
	"Private - Answer the Rectangle for the non-client border of aView in the coordinate system of the NC area. Note that this is not the same as the
	#rectangle since the right and bottom edges of the border must fit withing the latter."

	^0 @ 0 extent: aView extent - 1 asPoint!

checkBorderedNcRectangle: borderWidth
	"Private - Check that applying a border correctly changes the NC and Client rectagle calcs"

	| containerView clientRect parentRect calcClientRect calcNcRect |
	containerView := self view.
	clientRect := containerView clientRectangle.
	parentRect := containerView rectangle.
	self assert: clientRect position equals: Point zero.
	self assert: clientRect extent equals: parentRect extent - (borderWidth * 2) asPoint.
	self assert: parentRect position equals: containerView position.
	calcClientRect := containerView calcClientRectangleFromRectangle: parentRect.
	self assert: calcClientRect position equals: Point zero.
	self assert: calcClientRect extent equals: parentRect extent - (borderWidth * 2) asPoint.
	calcNcRect := containerView calcRectangleFromClientRectangle: clientRect.
	self assert: calcNcRect position equals: Point zero - borderWidth asPoint.
	self assert: calcNcRect extent equals: clientRect extent + (2 * borderWidth) asPoint.
	self assert: calcNcRect extent equals: parentRect extent.
	calcNcRect := containerView calcRectangleFromClientRectangle: calcClientRect.
	self assert: calcNcRect position equals: Point zero - borderWidth asPoint.
	self assert: calcNcRect extent equals: clientRect extent + (2 * borderWidth) asPoint.
	self assert: calcNcRect extent equals: parentRect extent!

checkPoints: aPointsArray inBitmap: bitmap color: color
	"
	ImagePresenter showOn: bitmap
	"

	| bitmapCanvas |
	bitmapCanvas := bitmap canvas.
	aPointsArray do: [:each | self assert: (bitmapCanvas pixelAt: each) equals: color]!

checkRectangle: rect inBitmap: bitmap color: color
	"
	ImagePresenter showOn: bitmap
	"

	self
		checkPoints: {rect topLeft. rect topRight. rect bottomLeft. rect bottomRight}
		inBitmap: bitmap
		color: color!

initializePresenter
	presenter := self classToTest show.
	presenter topView layoutManager: nil.
	presenter rectangle: self initialParentRect.
	presenter backcolor: self backgroundColor!

initialParentExtent
	"Private - Answer the extent of the view under test. Keep this fairly small to avoid length
	Bitmap>>pixelData calls when extracting the visible data"

	^30 @ 40!

initialParentRect
	^initialParentRect!

setUp
	super setUp.
	initialParentRect := ((10 @ 20 extent: self initialParentExtent) scaledBy: self view scaleFactor)
				truncated!

testBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"
	
	| containerView |
	containerView := self view.
	containerView hasBorder: true.
	self assert: containerView hasBorder.
	self checkBorderedNcRectangle:1.!

testNcCalcSize
	"Border off - simple text"
	| containerView rect params ret parentRect |
	containerView := self view.
	rect := RECTL marshal: containerView rectangle.
	self assert: rect asRectangle equals: initialParentRect.
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: false asParameter
				lpParam: rect asParameter.
	self assert: ret equals: 0.
	self assert: rect asRectangle equals: initialParentRect.

	"Border off advanced test"
	params := NCCALCSIZE_PARAMS new.
	parentRect := containerView rectangle.
	params rgrc at: 1 put: (RECTL marshal: parentRect).
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: true asParameter
				lpParam: params asParameter.
	self assert: ret equals: 0.

	"Border on simple test"
	rect := RECTL marshal: containerView rectangle.
	self assert: rect asRectangle equals: initialParentRect.
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: false asParameter
				lpParam: rect asParameter.
	self assert: ret equals: 0.
	self assert: rect topLeft equals: initialParentRect topLeft + 1 asPoint.
	self assert: rect bottomRight equals: initialParentRect bottomRight - 1 asPoint.

	"Border on advanced test"
	params := NCCALCSIZE_PARAMS new.
	parentRect := containerView rectangle.
	params rgrc at: 1 put: (RECTL marshal: parentRect).
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: true asParameter
				lpParam: params asParameter.
	self assert: ret equals: 0!

testNonBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"

	| containerView clientRect parentRect calcClientRect calcNcRect |
	containerView := self view.
	self deny: containerView hasBorder.
	clientRect := containerView clientRectangle.
	parentRect := containerView rectangle.
	self assert: clientRect position equals: Point zero.
	self assert: clientRect extent equals: parentRect extent.
	self assert: parentRect position equals: containerView position.
	calcClientRect := containerView calcClientRectangleFromRectangle: parentRect.
	self assert: calcClientRect position equals: Point zero.
	self assert: calcClientRect extent equals: parentRect extent.
	calcNcRect := containerView calcRectangleFromClientRectangle: clientRect.
	self assert: calcNcRect position equals: Point zero.
	self assert: calcNcRect extent equals: clientRect extent.
	calcNcRect := containerView calcRectangleFromClientRectangle: calcClientRect.
	self assert: calcNcRect position equals: Point zero.
	self assert: calcNcRect extent equals: clientRect extent!

waitForScreenUpdate
	self view topView update.
	"5 timesRepeat: 
			[SessionManager current inputState pumpMessages.
			Processor sleep: 100]"! !

!UI.Tests.AbstractContainerViewTest categoriesForMethods!
backgroundColor!constants!private! !
bitmapOfPaintView:!helpers!public! !
bitmapOfPrintView:!helpers!private! !
borderColor!constants!private! !
borderRectangleOf:!helpers!private! !
checkBorderedNcRectangle:!helpers!private! !
checkPoints:inBitmap:color:!helpers!private! !
checkRectangle:inBitmap:color:!helpers!private! !
initializePresenter!public!Running! !
initialParentExtent!constants!private! !
initialParentRect!accessing!private! !
setUp!public!Running! !
testBorderedNcRectangle!public!unit tests! !
testNcCalcSize!public!unit tests! !
testNonBorderedNcRectangle!public!unit tests! !
waitForScreenUpdate!helpers!private! !
!

