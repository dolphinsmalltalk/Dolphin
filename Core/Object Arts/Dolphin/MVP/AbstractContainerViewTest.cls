"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #AbstractContainerViewTest
	instanceVariableNames: 'containerView'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

AbstractContainerViewTest guid: (GUID fromString: '{79c3a28a-ce43-49e3-a030-adb99de3efea}')!

AbstractContainerViewTest isAbstract: true!

AbstractContainerViewTest comment: ''!

!AbstractContainerViewTest categoriesForClass!Unclassified! !

!AbstractContainerViewTest methodsFor!

backgroundColor
	"Private - Answer the background color we will test with. This shuld be different from that of the parent window background"

	^Color red!

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

	| clientRect parentRect calcClientRect calcNcRect |
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

	| bitmapCanvas requiredColor foundColorValue |
	bitmapCanvas := bitmap canvas.
	requiredColor := color asRGB.
	aPointsArray
		do: [:each | self assert: (foundColorValue := bitmapCanvas pixelAt: each) equals: requiredColor]!

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
	self subclassResponsibility!

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
	containerView topView destroy.
	containerView := nil!

testBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"
	
	containerView hasBorder: true.
	self assert: containerView hasBorder.
	self checkBorderedNcRectangle:1.!

testNcCalcSize
	"Border off - simple text"

	| rect params ret parentRect |
	rect := RECT fromRectangle: containerView rectangle.
	self assert: rect asRectangle equals: self initialParentRect.
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: false asParameter
				lpParam: rect asParameter.
	self assert: ret equals: 0.
	self assert: rect asRectangle equals: self initialParentRect.

	"Border off advanced test"
	params := NCCALCSIZE_PARAMS new.
	parentRect := containerView rectangle.
	params rgrc at: 1 put: (RECT fromRectangle: parentRect).
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: true asParameter
				lpParam: params asParameter.
	self assert: ret equals: 0.

	"Border on simple test"
	containerView hasBorder: true.
	rect := RECT fromRectangle: containerView rectangle.
	self assert: rect asRectangle equals: self initialParentRect.
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: false asParameter
				lpParam: rect asParameter.
	self assert: ret equals: 0.
	self assert: rect topLeft equals: self initialParentRect topLeft + 1 asPoint.
	self assert: rect bottomRight equals: self initialParentRect bottomRight - 1 asPoint.

	"Border on advanced test"
	params := NCCALCSIZE_PARAMS new.
	parentRect := containerView rectangle.
	params rgrc at: 1 put: (RECT fromRectangle: parentRect).
	ret := containerView
				sendMessage: WM_NCCALCSIZE
				wParam: true asParameter
				lpParam: params asParameter.
	self assert: ret equals: 0!

testNonBorderedNcRectangle
	"Check that applying a border correctly changes the NC and Client rectagle calcs"

	| clientRect parentRect calcClientRect calcNcRect |
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
	containerView topView update.
	"5 timesRepeat: 
			[SessionManager current inputState pumpMessages.
			Processor sleep: 100]"! !

!AbstractContainerViewTest categoriesForMethods!
backgroundColor!private! !
bitmapOfPrintView:!helpers!private! !
borderColor!private! !
borderRectangleOf:!private! !
checkBorderedNcRectangle:!private! !
checkPoints:inBitmap:color:!private! !
checkRectangle:inBitmap:color:!private! !
containerClass!private! !
initialParentExtent!private!Running! !
initialParentRect!private!Running! !
setUp!public!Running! !
tearDown!public!Running! !
testBorderedNcRectangle!public! !
testNcCalcSize!public! !
testNonBorderedNcRectangle!public! !
waitForScreenUpdate!private! !
!

