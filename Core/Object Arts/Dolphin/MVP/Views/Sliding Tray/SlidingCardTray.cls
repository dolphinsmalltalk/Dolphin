"Filed out from Dolphin Smalltalk"!

CardContainer subclass: #SlidingCardTray
	instanceVariableNames: '_sctReserved0 slider pinSize pinInteractor _sctReserved1 _sctReserved2'
	classVariableNames: 'PinImageList'
	poolDictionaries: 'TabViewConstants ThemeConstants'
	classInstanceVariableNames: ''!

SlidingCardTray guid: (GUID fromString: '{c8908738-f06b-4eac-89ba-67add22cec3b}')!

SlidingCardTray comment: 'A SlidingCardTray is a specialised <CardContainer> for use in conjunction with a <SlideyInneyOuteyView> to implement a tabbed view which slides out the contained cards when the user hovers over the tabs, and slides them back in again when the user leaves the window for a short while. 

Instance Variables:
	theme		<ExternalHandle>. XP theme handle.
	slider		<SlideyInneyOuteyView>. Owner controlling the slide animation.
	pinSize		<Point>. Size of the pin displayed on the tray caption bar.
	pinInteractor	<ButtonInteractor> for the pin.
	'!

!SlidingCardTray categoriesForClass!MVP-Views! !

!SlidingCardTray methodsFor!

calcClientRectangleFromRectangle: aRectangle 
	| rect |
	self isPinned ifTrue: [^super calcClientRectangleFromRectangle: aRectangle].
	rect := tabs calcClientRectangleFromRectangle: aRectangle.
	self isVertical 
		ifTrue: [self isInverted ifTrue: [rect right: aRectangle right] ifFalse: [rect left: aRectangle left]]
		ifFalse: [self isInverted ifTrue: [rect bottom: aRectangle bottom] ifFalse: [rect top: aRectangle top]].
	^rect!

calculateExtent: aLayoutContext 
	"Private - Answer the calculated extent of the receiver that should be used by a
	layout manager during it's layout process."

	^self layoutManager preferredLayoutExtentOf: self context: aLayoutContext!

captionGeometryChanged
	pinInteractor buttonRectangle: self pinRectangle.
	self invalidateRect: self headerRectangle!

edgeExtent
	^2 @ 2!

getThemePinSize
	"Pin size from theme doesn't scale with DPI - always 16@16. This is the case even with per-monitor DPI awareness, and using a theme handle opened with OpenThemeDataForDpi at a DPI that corresponds to the dpi of one of the monitors (so that the system has definitely loaded the theme resource). I suspect that because windows itself doesn't use the pin graphic, that Microsoft haven't bothered to provide larger versions for higher DPI settings. Therefore we just assume the (scaled) small icon extent."

	^(false and: [self isThemed])
		ifTrue: 
			[| pt |
			pt := POINTL newBuffer.
			ThemeLibrary default
				getThemePartSize: self theme
				hdc: nil
				iPartId: EBP_HEADERPIN
				iStateId: EBHP_NORMAL
				prc: nil
				eSize: TS_DRAW
				psz: pt.
			pt asObject]
		ifFalse: [self metrics smallIconExtent]!

headerHeight
	^self pinSize y + 2!

headerRectangle
	| rect |
	rect := self clientRectangle.
	^(self isVertical not and: [self isInverted not]) 
		ifTrue: [rect left @ (rect bottom - self headerHeight) corner: rect corner]
		ifFalse: [rect origin extent: rect width @ self headerHeight]!

hitTest: aMouseEvent 
	(self headerRectangle containsPoint: aMouseEvent position) 
		ifTrue: 
			[(pinInteractor hitTest: aMouseEvent) ifTrue: [^#pin].
			^#header].
	^nil!

implicitInsets: aLayoutContext 
	"Private - Answer a <Rectangle> whose edges specify the implicit distance (in pixels) by
	which the sub views have to be inset from the edges of the client area of the receiver."

	"Implementation Note: We must calculate this to allow space for the sliding tray decoration (i.e. the caption bar)."

	^(self isVertical not and: [self isInverted not]) 
		ifTrue: [0 @ 0 corner: 0 @ self headerHeight]
		ifFalse: [0 @ self headerHeight corner: 0 @ 0]!

isPinHot
	^pinInteractor ifNil: [false] ifNotNil: [:value | value isHot]!

isPinned
	^slider notNil and: [slider isPinned]!

isPinPressed
	^pinInteractor isPressed!

isResizable
	^slider notNil and: [slider isTrayResizable]!

onLeftButtonPressed: aMouseEvent 
	| hit |
	self class releaseCapture.
	hit := self hitTest: aMouseEvent.
	hit == #pin 
		ifTrue: 
			[self trackMouseOverPin: aMouseEvent.
			^0].
	hit == #header 
		ifTrue: 
			[self trigger: #headerClicked.
			^0].
	^nil!

onMouseMoved: aMouseEvent 
	"Private - Handler for a mouse move event."

	(self hitTest: aMouseEvent) == #pin ifTrue: [self trackMouseOverPin: aMouseEvent].
	^super onMouseMoved: aMouseEvent!

onPaintRequired: aPaintEvent 
	"Private - Paint the tray decoration."

	| canvas |
	canvas := aPaintEvent canvas.
	self isThemed ifTrue: [self paintThemedOn: canvas] ifFalse: [self paintClassicOn: canvas]!

onPositionChanged: aPositionEvent 
	"Private - Handler for window position change (move or resize).
	If resized we must invalidate the header so that the pin is redrawn correctly."

	aPositionEvent isResize ifTrue: [self onResize].
	^super onPositionChanged: aPositionEvent!

onResize
	| rect frameExtent |
	rect := 0 @ 0 extent: self extent.
	frameExtent := self edgeExtent.
	self isVertical 
		ifTrue: 
			[self
				invalidateRect: (RECT origin: rect topLeft extent: rect width @ frameExtent y);
				invalidateRect: (RECT 
							left: rect left
							top: rect bottom - frameExtent y
							right: rect right
							bottom: rect bottom)]
		ifFalse: 
			[self
				invalidateRect: (RECT origin: rect topLeft extent: frameExtent x @ rect height);
				invalidateRect: (RECT 
							left: rect right - frameExtent x
							top: rect top
							right: rect right
							bottom: rect bottom)].
	self captionGeometryChanged!

onViewDestroyed
	"Private - Handler for view final view destruction."

	super onViewDestroyed.
	self freeTheme!

openTheme
	pinSize := self getThemePinSize!

paintClassicBackgroundOn: aCanvas
	aCanvas fillRectangle: self headerRectangle color: Color inactiveCaption!

paintClassicEdgesOn: aCanvas 
	self isPinned ifTrue: [^nil].
	"Note that we omit one line of the top-edge in order to give the same appearance as the tab control when pinned"
	UserLibrary default 
		drawEdge: aCanvas asParameter
		qrc: (0 @ -1 corner: self extent) asParameter
		edge: (self isResizable ifTrue: [EDGE_RAISED] ifFalse: [EDGE_ETCHED])
		grfFlags: BF_TOP | BF_RIGHT | BF_BOTTOM | BF_MIDDLE!

paintClassicOn: aCanvas 
	self paintClassicEdgesOn: aCanvas.
	self paintClassicBackgroundOn: aCanvas.
	self paintClassicPinOn: aCanvas!

paintClassicPinOn: aCanvas 
	self pinImageList 
		draw: self pinStateId
		on: aCanvas
		at: self pinRectangle topLeft!

paintEdgesOn: aCanvas 
	aCanvas excludeClipRectangle: (self calcClientRectangleFromRectangle: (0 @ 0 extent: self extent)).
	self isThemed 
		ifTrue: [self paintThemedEdgesOn: aCanvas]
		ifFalse: [self paintClassicEdgesOn: aCanvas]!

paintThemedBackgroundOn: aCanvas 
	ThemeLibrary default 
		drawThemeBackground: self theme
		hdc: aCanvas asParameter
		iPartId: EBP_HEADERBACKGROUND
		iStateId: 0
		pRect: self headerRectangle asParameter
		pClipRect: nil!

paintThemedEdgesOn: aCanvas 
	self isPinned ifTrue: [^nil].
	ThemeLibrary default 
		drawThemeBackground: tabs theme
		hdc: aCanvas asParameter
		iPartId: TABP_PANE
		iStateId: 0
		pRect: aCanvas clipBox asParameter
		pClipRect: nil!

paintThemedOn: aCanvas 
	self paintThemedBackgroundOn: aCanvas.
	self paintThemedPinOn: aCanvas!

paintThemedPinOn: aCanvas 
	ThemeLibrary default 
		drawThemeBackground: self theme
		hdc: aCanvas asParameter
		iPartId: EBP_HEADERPIN
		iStateId: self pinStateId
		pRect: self pinRectangle asParameter
		pClipRect: nil!

pinImageList
	| bitmap |
	(PinImageList isNil or: [PinImageList isRealized not]) 
		ifTrue: 
			[| imageList |
			imageList := WinImageList 
						newExtent: 16 @ 16
						depth: 8
						initialSize: 6
						growBy: 1
						masked: true.
			bitmap := Bitmap fromId: 'HeaderPin.bmp'.
			imageList addBitmap: bitmap mask: Color magenta.
			bitmap free.
			PinImageList := imageList].
	^PinImageList!

pinInset
	^2 @ 1!

pinRectangle
	| insetRect pinExt |
	insetRect := self headerRectangle insetBy: self pinInset.
	pinExt := self pinSize.
	^(self isVertical and: [self isInverted])
		ifTrue: [insetRect origin extent: pinExt]
		ifFalse: [(insetRect right - pinExt x) @ insetRect top extent: pinExt]!

pinSize
	^pinSize ifNil: [pinSize := self getThemePinSize]!

pinStateId
	^self isPinned 
		ifTrue: 
			[self isPinHot 
				ifTrue: [self isPinPressed ifTrue: [EBHP_SELECTEDPRESSED] ifFalse: [EBHP_SELECTEDHOT]]
				ifFalse: [EBHP_SELECTEDNORMAL]]
		ifFalse: 
			[self isPinHot 
				ifTrue: [self isPinPressed ifTrue: [EBHP_PRESSED] ifFalse: [EBHP_HOT]]
				ifFalse: [EBHP_NORMAL]]!

resolutionScaledBy: aPoint
	super resolutionScaledBy: aPoint.
	pinSize := nil!

setSlider: aSlideyInneyOuteyThing 
	slider := aSlideyInneyOuteyThing.
	tabs := slider tabs.
	pinInteractor := (ButtonInteractor forPresenter: self)
				buttonRectangle: self pinRectangle;
				commandDescription: (CommandDescription command: #togglePin description: 'Pin or Unpin the tray');
				yourself!

sizingEdgeInfo
	| rect frameExtent hit |
	rect := self screenRectangle.
	frameExtent := self metrics sizingFrameExtent.
	hit := self isVertical 
				ifTrue: 
					[self isInverted 
						ifTrue: 
							[rect right: rect left + frameExtent x.
							HTLEFT]
						ifFalse: 
							[rect left: rect right - frameExtent x.
							HTRIGHT]]
				ifFalse: 
					[self isInverted 
						ifTrue: 
							[rect bottom: rect top + frameExtent y.
							HTTOP]
						ifFalse: 
							[rect top: rect bottom - frameExtent y.
							HTBOTTOM]].
	^hit -> rect!

tabOrientation: aSymbol 
	"Set the orientation of the receiver. This primarily controls where the tab strip is
	displayed. The <Symbol> argument can be one of #left, #right, #top (the default) or
	#bottom."

	tabs tabOrientation: aSymbol.
	self captionGeometryChanged!

togglePin
	slider ifNotNil: [slider isPinned: slider isPinned not]!

trackMouseOverPin: aMouseEvent 
	pinInteractor startCaptureOn: aMouseEvent!

wmNcCalcSize: message wParam: wParam lParam: lParam 
	"Private - Handler for a WM_NCCALCSIZE message. Allow for the resizing frame on 3-sides of
	the window (even though only one edge is moveable) when unpinned."

	| params rect rc |
	(self isPinned or: [wParam == 0]) ifTrue: [^nil].
	params := NCCALCSIZE_PARAMS fromAddress: lParam.
	rc := params rgrc at: 1.
	rect := self calcClientRectangleFromRectangle: rc asRectangle.
	rc copyBytes: rect asParameter.
	^0!

wmNcHitTest: message wParam: wParam lParam: lParam 
	"Private - Handler for a WM_NCHITTEST. Look for hits along the tray's resizable edge."

	| edge |
	(self isPinned or: [self isResizable not]) 
		ifTrue: 
			["Not resizable by dragging edge when pinned"
			^nil].
	edge := self sizingEdgeInfo.
	^(edge value containsPoint: lParam lowWord @ lParam highWord) ifTrue: [edge key] ifFalse: [HTCLIENT]!

wmNcPaint: message wParam: wParam lParam: lParam
	"Private - Paint the non-client area of the window when unpinned."

	| canvas |
	self isPinned ifTrue: [^nil].
	canvas := Canvas forNonClientView: self.
	self paintEdgesOn: canvas.
	canvas free.
	^0!

wmPrint: message wParam: wParam lParam: lParam 
	"Private - Handle WM_PRINT."

	| result |
	self ensureLayoutValid.
	result := self 
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam.
	(lParam allMask: PRF_NONCLIENT) ifTrue: [self paintEdgesOn: (Canvas withNonOwnedDC: wParam)].
	^result! !

!SlidingCardTray categoriesForMethods!
calcClientRectangleFromRectangle:!event handling-win32!private! !
calculateExtent:!geometry!private! !
captionGeometryChanged!event handling!private! !
edgeExtent!constants!private! !
getThemePinSize!helpers!private! !
headerHeight!constants!private! !
headerRectangle!painting!private! !
hitTest:!painting!private! !
implicitInsets:!accessing!private! !
isPinHot!private!testing! !
isPinned!private!testing! !
isPinPressed!private!testing! !
isResizable!private!testing! !
onLeftButtonPressed:!event handling!private! !
onMouseMoved:!event handling!private! !
onPaintRequired:!event handling!private! !
onPositionChanged:!event handling!private! !
onResize!helpers!private! !
onViewDestroyed!event handling!private! !
openTheme!helpers!private! !
paintClassicBackgroundOn:!painting!private! !
paintClassicEdgesOn:!event handling!private! !
paintClassicOn:!painting!private! !
paintClassicPinOn:!painting!private! !
paintEdgesOn:!painting!private! !
paintThemedBackgroundOn:!painting!private! !
paintThemedEdgesOn:!event handling!private! !
paintThemedOn:!painting!private! !
paintThemedPinOn:!painting!private! !
pinImageList!accessing!private! !
pinInset!constants!private! !
pinRectangle!accessing!private! !
pinSize!accessing!private! !
pinStateId!accessing!private! !
resolutionScaledBy:!geometry!private! !
setSlider:!initializing!private! !
sizingEdgeInfo!helpers!private! !
tabOrientation:!accessing-styles!public! !
togglePin!commands!public! !
trackMouseOverPin:!helpers!private! !
wmNcCalcSize:wParam:lParam:!event handling-win32!private! !
wmNcHitTest:wParam:lParam:!event handling-win32!private! !
wmNcPaint:wParam:lParam:!event handling-win32!private! !
wmPrint:wParam:lParam:!event handling-win32!private! !
!

!SlidingCardTray class methodsFor!

initialize
	PinImageList := nil!

themePartName
	^'EXPLORERBAR'! !

!SlidingCardTray class categoriesForMethods!
initialize!initializing!private! !
themePartName!constants!public!theming! !
!

