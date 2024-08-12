"Filed out from Dolphin Smalltalk"!

ContainerView subclass: #ScrollingDecorator
	instanceVariableNames: 'scrollOffset tracking lineExtent'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScrollingDecorator guid: (GUID fromString: '{87b4c719-026e-11d3-9fd7-00a0cc3e4a32}')!

ScrollingDecorator comment: 'A ScrollingDecorator is a <compositeView> that implements the <scrollingDecoratorView> protocol to allow scrolling around the area occupied by the sub-view it decorates. It has a fixed <ScrollingDecoratorLayout> manager and expects to have only one managed sub-view that it is responsible for scrolling around (typically this will be another <compositeView>). The scrollable area is determined by the #layoutExtent: of the sub-view.

Instance Variables:
	scrollOffset	<Point> holding the current horizontal and vertical scroll offsets.
	tracking		<boolean> indicating whether the view should update dynamically while it is being scrolled.
	lineExtent	<Point> holding the scroll amount representing a scroll distance of one line.

For example, the View Composer uses a ScrollingDecorator to scroll around the editing arena. Another common usage is with the MoenTreeView, which may have quite large extent when displaying large trees, but which has no scrolling capability of its own.'!

!ScrollingDecorator categoriesForClass!MVP-Views! !

!ScrollingDecorator methodsFor!

addSubView: aView 
	"Adds aView as a subview of the receiver. Informs the receiver that the view
	has been added"

	(aView isManaged and: [self managedSubViews notEmpty]) 
		ifTrue: [^self error: 'ScrollingDecorators can scroll only a single child'].
	^super addSubView: aView!

defaultLayoutManager
	"Private - ScrollingDecorators must be used with a ScrollingDecoratorLayout."

	^ScrollingDecoratorLayout new!

defaultWindowStyle
	^super defaultWindowStyle bitOr: ##(WS_HSCROLL | WS_VSCROLL)!

ensureSubView: aView rectangleVisible: aRectangle 
	"Private - Ensures that the aRectangle area of aView is visible in the receiver, its
	parent view."

	| page offset |
	offset := scrollOffset copy.
	page := self scrollPage.
	aRectangle left < scrollOffset x ifTrue: [offset x: aRectangle left].
	aRectangle top < scrollOffset y ifTrue: [offset y: aRectangle top].
	aRectangle left >= (scrollOffset x + page x) ifTrue: [offset x: aRectangle right - page x].
	aRectangle top >= (scrollOffset y + page y) ifTrue: [offset y: aRectangle bottom - page y].
	offset := offset max: 0 @ 0.
	self deferLayout: 
			[:context | 
			self scrollOffset: offset context: context.
			self layoutManager positionScrolledViewOf: self context: context]!

getScrollPage: anInteger
	| struct |
	struct := SCROLLINFO newBuffer
				fMask: SIF_PAGE;
				yourself.
	UserLibrary default
		getScrollInfo: handle
		nBar: anInteger
		lpsi: struct.
	^struct page!

getScrollRange: anInteger
	| struct |
	struct := SCROLLINFO newBuffer
				fMask: SIF_RANGE;
				yourself.
	UserLibrary default
		getScrollInfo: handle
		nBar: anInteger
		lpsi: struct.
	^struct range!

horizontalRange
	^self getScrollRange: SB_HORZ!

horizontalScrollTo: anInteger
	| range newX currentPos |
	range := self horizontalRange.
	newX := (anInteger max: range start) min: range stop - ((self getScrollPage: SB_HORZ) max: 1) + 1.
	currentPos := self scrollOffset.
	^newX ~= currentPos x
		ifTrue: 
			[self deferLayout: 
					[:context |
					self scrollOffset: newX @ currentPos y context: context.
					self layoutManager positionScrolledViewOf: self context: context].
			0]!

initialize
	super initialize.
	self isTrackingContinuous: true.
	scrollOffset := 0 @ 0.
	lineExtent := 8 @ 8!

isTrackingContinuous
	"Answer whether to use the continuous tracking mode for the receiver's scroll bar thumbs."

	^tracking!

isTrackingContinuous: aBoolean 
	"Set whether to use the continuous tracking mode for the receiver's scroll bar thumbs."

	tracking := aBoolean!

lineExtent
	"Answer a <Point> that specifies the extent of a line when scrolling."

	^lineExtent!

lineExtent: aPoint
	"Set the extent of a line when scrolling."

	lineExtent := aPoint!

onHScroll: aScrollEvent
	"Handler for a horizontal scroll event."

	self isTrackingContinuous
		ifTrue: [aScrollEvent thumbTrack ifTrue: [^self horizontalScrollTo: aScrollEvent pos]]
		ifFalse: [aScrollEvent thumbPosition ifTrue: [^self horizontalScrollTo: aScrollEvent pos]].
	aScrollEvent lineRight ifTrue: [^self scrollColumns: 1].
	aScrollEvent lineLeft ifTrue: [^self scrollColumns: -1].
	aScrollEvent pageRight ifTrue: [^self scrollHorizontalPages: 1].
	aScrollEvent pageLeft ifTrue: [^self scrollHorizontalPages: -1].
	aScrollEvent top ifTrue: [^self horizontalScrollTo: self horizontalRange start].
	aScrollEvent bottom ifTrue: [^self horizontalScrollTo: self horizontalRange stop].
	^nil!

onMouseWheeled: aMouseWheelEvent
	"Handler for a mouse wheel movement event. Scroll the receiver vertically
	in the direction indicated, and as per the system configuration."

	| rotation config |
	((config := self wheelScrollLines) == 0 or: [(rotation := aMouseWheelEvent wheelRotation) abs < 1])
		ifTrue: [^super onMouseWheeled: aMouseWheelEvent].
	config = WHEEL_PAGESCROLL
		ifTrue: 
			[| delta |
			delta := rotation sign * -1.
			aMouseWheelEvent isVertical
				ifTrue: [self scrollPages: delta]
				ifFalse: [self scrollHorizontalPages: delta]]
		ifFalse: 
			["N.B. In some rare configurations rotation might not be integral"
			| delta |
			delta := (rotation * config * -1) asInteger.
			aMouseWheelEvent isVertical ifTrue: [self scrollLines: delta] ifFalse: [self scrollColumns: delta]].
	^0!

onVScroll: aScrollEvent
	"Handler for a vertical scroll event."

	self isTrackingContinuous 
		ifTrue: [aScrollEvent thumbTrack ifTrue: [^self verticalScrollTo: aScrollEvent pos]]
		ifFalse: [aScrollEvent thumbPosition ifTrue: [^self verticalScrollTo: aScrollEvent pos]].
	aScrollEvent lineDown ifTrue: [^self scrollLines: 1].
	aScrollEvent lineUp ifTrue: [^self scrollLines: -1].
	aScrollEvent pageDown ifTrue: [^self scrollPages: 1].
	aScrollEvent pageUp ifTrue: [^self scrollPages: -1].
	aScrollEvent top ifTrue: [^self verticalScrollTo: self verticalRange start].
	aScrollEvent bottom ifTrue: [^self verticalScrollTo: self verticalRange stop].
	^nil!

placement: aWINDOWPLACEMENT 
	"Sets the current minimized/maximized/restored locations of the receiver and
	its current state from information in aWINDOWPLACEMENT."

	"Implementation Note: We must initialize the scroll bars based on the receivers subview."

	super placement: aWINDOWPLACEMENT.
	self deferLayout: [:context | self updateScrollBars: context]!

preTranslateKeyboardInput: aMSG 
	"Answer whether the receiver would like to consume the argument aMSG,
	which is a keyboard message. Handle keyboard navigation."

	"First ask the original view for its input mask"
	| msg mask vk |
	mask := UserLibrary default 
				sendMessage: aMSG hwnd
				msg: WM_GETDLGCODE
				wParam: 0
				lpParam: aMSG.

	"If control wants all keys, or this specific message, then don't absorb"
	(mask anyMask: ##(DLGC_WANTALLKEYS | DLGC_WANTMESSAGE)) ifTrue: [^false].
	Keyboard default isModifierDown ifTrue: [^false].
	msg := aMSG message.
	vk := aMSG wParam.
	(vk >= VK_LEFT and: [vk <= VK_DOWN]) 
		ifTrue: 
			["Arrow keys"

			"If control wants arrows, then don't absorb..."
			(mask allMask: DLGC_WANTARROWS) ifTrue: [^false].
			"...otherwise use keydowns for line scrolling"
			msg == WM_KEYDOWN 
				ifTrue: 
					[(vk == VK_LEFT or: [vk == VK_RIGHT]) 
						ifTrue: [self sendMessage: WM_HSCROLL wParam: (vk - VK_LEFT) // 2 + SB_LINELEFT].
					(vk == VK_DOWN or: [vk == VK_UP]) 
						ifTrue: [self sendMessage: WM_VSCROLL wParam: (vk - VK_UP) // 2 + SB_LINEUP].
					^true	"absorbed for line scrolling"].
			^false].
	(vk == VK_END or: [vk == VK_HOME]) 
		ifTrue: 
			[msg == WM_KEYDOWN ifTrue: [self sendMessage: WM_VSCROLL wParam: (vk - VK_HOME) abs + SB_TOP].
			"Absorb home/end for scrolling to top/bottom"
			^true].
	(vk == VK_NEXT or: [vk == VK_PRIOR]) 
		ifTrue: 
			[msg == WM_KEYDOWN ifTrue: [self sendMessage: WM_VSCROLL wParam: vk - VK_PRIOR + SB_PAGEUP].
			"Absorb page-up/page-down for page scrolling"
			^true].
	^false!

scrollColumns: anInteger
	"Scroll the specified number of columns (left if negative, right if positive). Answers 0 if
	successful, or nil if not."

	^self horizontalScrollTo: self scrollOffset x + (anInteger * self lineExtent x)!

scrollHorizontalPages: anInteger
	"Scroll the specified number of pages horizontally (left if negative, right if positive)."

	| pageWidth |
	pageWidth := (self getScrollPage: SB_HORZ) max: 1.
	^self horizontalScrollTo: self scrollOffset x + (anInteger * pageWidth)!

scrollLines: anInteger
	"Scroll the specified number of lines (up if negative, down if positive). Answers 0 if
	successful, or nil if not."

	^self 
		verticalScrollTo: self scrollOffset y + (anInteger * self lineExtent y)!

scrollOffset
	"Answer a <Point> that is the pixel offset of the receiver's subview to itself."

	^scrollOffset!

scrollOffset: aPoint 
	self deferLayout: [:context | self scrollOffset: aPoint context: context]!

scrollOffset: aPoint context: aLayoutContext 
	scrollOffset := aPoint.
	self updateScrollBarOffsets: aLayoutContext!

scrollPage
	"Private - Answer a <Point> which is the pixel page size for horizontal and vertical scroll
	bars."

	^(self getScrollPage: SB_HORZ) @ (self getScrollPage: SB_VERT)!

scrollPages: anInteger
	"Scroll the specified number of pages (up if negative, down if positive)."

	| pageHeight |
	pageHeight := (self getScrollPage: SB_VERT) max: 1.
	^self verticalScrollTo: self scrollOffset y + (anInteger * pageHeight)!

setScrollInfo: aPoint
	| lib scrollinfo |
	lib := UserLibrary default.
	scrollinfo := SCROLLINFO newBuffer.
	scrollinfo pos: aPoint x.
	lib
		setScrollInfo: handle
		nBar: SB_HORZ
		lpsi: scrollinfo
		redraw: true.
	scrollinfo pos: aPoint y.
	lib
		setScrollInfo: handle
		nBar: SB_VERT
		lpsi: scrollinfo
		redraw: true!

setScrollInfo: barInteger position: positionInteger range: rangeInterval page: pageInteger
	"Private - Set the position, range and page size of bar in one operation."

	UserLibrary default
		setScrollInfo: handle
		nBar: barInteger
		lpsi: (SCROLLINFO
				range: rangeInterval
				position: positionInteger
				page: pageInteger)
		redraw: true!

updateScrollBarOffsets: aLayoutContext
	"Private - Update the state of the receivers standard scroll bars to reflect the current
	relationship between the receiver and its subview."

	| clientExtent viewExtent |
	clientExtent := aLayoutContext clientExtentOf: self.
	viewExtent := self layoutManager preferredLayoutExtentOf: self context: aLayoutContext.
	viewExtent isZero ifTrue: [viewExtent := clientExtent].
	self setScrollInfo: self scrollOffset!

updateScrollBars: aLayoutContext 
	"Private - Update the state of the receivers standard scroll bars to reflect the current
	relationship between the receiver and its subview."

	| clientExtent viewExtent |
	clientExtent := aLayoutContext clientExtentOf: self.
	viewExtent := self layoutManager preferredLayoutExtentOf: self context: aLayoutContext.
	viewExtent isZero ifTrue: [viewExtent := clientExtent].
	self 
		setScrollInfo: SB_HORZ
		position: self scrollOffset x
		range: (0 to: viewExtent x - 1)
		page: clientExtent x.
	#todo.	"What do to about this?"
	"need to get the clientExtent again as the horizontal scroll bar may have changed it"
	clientExtent := self clientRectangle extent.
	self 
		setScrollInfo: SB_VERT
		position: self scrollOffset y
		range: (0 to: viewExtent y - 1)
		page: clientExtent y!

verticalRange
	^self getScrollRange: SB_VERT!

verticalScrollTo: anInteger
	| range newY currentPos |
	range := self verticalRange.
	newY := (anInteger max: range start) min: range stop - ((self getScrollPage: SB_VERT) max: 1) + 1.
	currentPos := self scrollOffset.
	^newY ~= currentPos y
		ifTrue: 
			[self deferLayout: 
					[:context |
					self scrollOffset: currentPos x @ newY context: context.
					self layoutManager positionScrolledViewOf: self context: context].
			0]!

wheelScrollLines
	^self metrics wheelScrollLines ! !

!ScrollingDecorator categoriesForMethods!
addSubView:!hierarchy!public!sub views! !
defaultLayoutManager!constants!private! !
defaultWindowStyle!constants!private! !
ensureSubView:rectangleVisible:!accessing!private! !
getScrollPage:!accessing!private! !
getScrollRange:!accessing!private! !
horizontalRange!accessing!private! !
horizontalScrollTo:!operations!private! !
initialize!initializing!private! !
isTrackingContinuous!accessing-styles!public! !
isTrackingContinuous:!accessing-styles!public! !
lineExtent!accessing!public! !
lineExtent:!accessing!public! !
onHScroll:!event handling!public! !
onMouseWheeled:!event handling!public! !
onVScroll:!event handling!public! !
placement:!geometry!public! !
preTranslateKeyboardInput:!dispatching!public! !
scrollColumns:!operations!public! !
scrollHorizontalPages:!operations!public! !
scrollLines:!operations!public! !
scrollOffset!accessing!public! !
scrollOffset:!operations!public! !
scrollOffset:context:!operations!public! !
scrollPage!accessing!private! !
scrollPages:!operations!public! !
setScrollInfo:!private!updating! !
setScrollInfo:position:range:page:!accessing!private! !
updateScrollBarOffsets:!private!updating! !
updateScrollBars:!private!updating! !
verticalRange!accessing!private! !
verticalScrollTo:!operations!private! !
wheelScrollLines!constants!private! !
!

ScrollingDecorator methodProtocol: #scrollingDecoratorView attributes: #(#readOnly) selectors: #(#isTrackingContinuous #isTrackingContinuous: #lineExtent #lineExtent: #onHScroll: #onVScroll: #scrollOffset #scrollOffset:context: #scrollPage)!

!ScrollingDecorator class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScrollingDecorator) 34 18 nil nil 34 2 8 1143996416 131073 416 nil nil nil 5 nil nil nil 416 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) true 170 192 8 #() nil 328198 ##(Smalltalk.Point) 1 1 true 546 17 17 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 193 448 8 '' 416 1 8 #() 546 193 193 nil 27 )! !

!ScrollingDecorator class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

