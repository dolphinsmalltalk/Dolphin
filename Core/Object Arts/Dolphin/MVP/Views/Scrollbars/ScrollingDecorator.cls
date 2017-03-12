"Filed out from Dolphin Smalltalk 7"!

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
	struct := (SCROLLINFO new)
				maskIn: SIF_PAGE;
				yourself.
	UserLibrary default
		getScrollInfo: handle
		fnBar: anInteger
		lpsi: struct.
	^struct page!

getScrollRange: anInteger
	| struct |
	struct := (SCROLLINFO new)
				maskIn: SIF_RANGE;
				yourself.
	UserLibrary default
		getScrollInfo: handle
		fnBar: anInteger
		lpsi: struct.
	^struct range!

horizontalRange
	^self getScrollRange: SB_HORZ!

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

	| currentValue newValue range pageSize |
	range := self horizontalRange.
	pageSize := (self getScrollPage: SB_HORZ) max: 1.
	newValue := currentValue := self scrollOffset x.
	self isTrackingContinuous 
		ifTrue: [aScrollEvent thumbTrack ifTrue: [newValue := aScrollEvent pos]]
		ifFalse: [aScrollEvent thumbPosition ifTrue: [newValue := aScrollEvent pos]].
	aScrollEvent lineRight ifTrue: [newValue := currentValue + self lineExtent x].
	aScrollEvent lineLeft ifTrue: [newValue := currentValue - self lineExtent x].
	aScrollEvent pageRight ifTrue: [newValue := currentValue + pageSize].
	aScrollEvent pageLeft ifTrue: [newValue := currentValue - pageSize].
	aScrollEvent top ifTrue: [newValue := range start].
	aScrollEvent bottom ifTrue: [newValue := range stop].
	newValue := newValue max: range start.
	newValue := newValue min: range stop - pageSize + 1.
	newValue ~= currentValue ifFalse: [^self].
	self deferLayout: 
			[:context | 
			self scrollOffset: newValue @ self scrollOffset y context: context.
			self layoutManager positionScrolledViewOf: self context: context]!

onMouseWheeled: aMouseEvent
	"Handler for a mouse wheel movement event. Scroll the receiver vertically
	in the direction indicated, and as per the system configuration."

	| rotation config |
	self presenter trigger: #mouseWheeled: with: aMouseEvent.
	config := self wheelScrollLines.
	(config == 0 or: [(rotation := aMouseEvent wheelRotation) abs < 1])
		ifTrue: [^aMouseEvent defaultWindowProcessing].
	config = WHEEL_PAGESCROLL
		ifTrue: [self scrollPages: rotation sign * -1]
		ifFalse: 
			["N.B. In some rare configurations rotation might not be integral"
			self scrollLines: (rotation * config * -1) asInteger].
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

setScrollInfo: barInteger position: posInteger
	| scrollinfo |
	scrollinfo := (SCROLLINFO new)
				pos: posInteger;
				yourself.
	UserLibrary default
		setScrollInfo: handle
		fnBar: barInteger
		lpsi: scrollinfo
		fRedraw: true!

setScrollInfo: barInteger position: positionInteger range: rangeInterval page: pageInteger
	"Private - Set the position, range and page size of bar in one operation."

	| scrollinfo |
	scrollinfo := (SCROLLINFO new)
				range: rangeInterval;
				pos: positionInteger;
				page: pageInteger;
				yourself.
	UserLibrary default
		setScrollInfo: handle
		fnBar: barInteger
		lpsi: scrollinfo
		fRedraw: true!

updateScrollBarOffsets: aLayoutContext 
	"Private - Update the state of the receivers standard scroll bars to reflect the current
	relationship between the receiver and its subview."

	| clientExtent viewExtent |
	clientExtent := aLayoutContext clientExtentOf: self.
	viewExtent := self layoutManager preferredLayoutExtentOf: self context: aLayoutContext.
	viewExtent isZero ifTrue: [viewExtent := clientExtent].
	self setScrollInfo: SB_HORZ position: self scrollOffset x.
	self setScrollInfo: SB_VERT position: self scrollOffset y!

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

verticalScrollTo: desiredPos 
	| range newPos |
	range := self verticalRange.
	newPos := (desiredPos max: range start) 
				min: range stop - ((self getScrollPage: SB_VERT) max: 1) + 1.
	^newPos ~= self scrollOffset y 
		ifTrue: 
			[self deferLayout: 
					[:context | 
					self scrollOffset: self scrollOffset x @ newPos context: context.
					self layoutManager positionScrolledViewOf: self context: context].
			0]!

wheelScrollLines
	^SystemMetrics current getSysParamDword: SPI_GETWHEELSCROLLLINES! !
!ScrollingDecorator categoriesFor: #addSubView:!hierarchy!public!sub views! !
!ScrollingDecorator categoriesFor: #defaultLayoutManager!constants!private! !
!ScrollingDecorator categoriesFor: #defaultWindowStyle!constants!private! !
!ScrollingDecorator categoriesFor: #ensureSubView:rectangleVisible:!accessing!private! !
!ScrollingDecorator categoriesFor: #getScrollPage:!accessing!private! !
!ScrollingDecorator categoriesFor: #getScrollRange:!accessing!private! !
!ScrollingDecorator categoriesFor: #horizontalRange!accessing!private! !
!ScrollingDecorator categoriesFor: #initialize!initializing!private! !
!ScrollingDecorator categoriesFor: #isTrackingContinuous!accessing-styles!public! !
!ScrollingDecorator categoriesFor: #isTrackingContinuous:!accessing-styles!public! !
!ScrollingDecorator categoriesFor: #lineExtent!accessing!public! !
!ScrollingDecorator categoriesFor: #lineExtent:!accessing!public! !
!ScrollingDecorator categoriesFor: #onHScroll:!event handling!public! !
!ScrollingDecorator categoriesFor: #onMouseWheeled:!event handling!public! !
!ScrollingDecorator categoriesFor: #onVScroll:!event handling!public! !
!ScrollingDecorator categoriesFor: #placement:!geometry!public! !
!ScrollingDecorator categoriesFor: #preTranslateKeyboardInput:!dispatching!public! !
!ScrollingDecorator categoriesFor: #scrollLines:!operations!public! !
!ScrollingDecorator categoriesFor: #scrollOffset!accessing!public! !
!ScrollingDecorator categoriesFor: #scrollOffset:!public! !
!ScrollingDecorator categoriesFor: #scrollOffset:context:!public! !
!ScrollingDecorator categoriesFor: #scrollPage!accessing!private! !
!ScrollingDecorator categoriesFor: #scrollPages:!operations!public! !
!ScrollingDecorator categoriesFor: #setScrollInfo:position:!accessing!private! !
!ScrollingDecorator categoriesFor: #setScrollInfo:position:range:page:!accessing!private! !
!ScrollingDecorator categoriesFor: #updateScrollBarOffsets:!private!updating! !
!ScrollingDecorator categoriesFor: #updateScrollBars:!private!updating! !
!ScrollingDecorator categoriesFor: #verticalRange!accessing!private! !
!ScrollingDecorator categoriesFor: #verticalScrollTo:!operations!private! !
!ScrollingDecorator categoriesFor: #wheelScrollLines!constants!private! !

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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ScrollingDecorator)  98 18 0 0 98 2 8 1143996416 131073 416 0 0 0 5 0 0 0 416 1573190 1 ##(ScrollingDecoratorLayout)  16 234 256 98 0 0 328198 ##(Point)  1 1 16 562 17 17 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 562 1 1 562 701 501 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 0 562 193 193 0 27 )! !
!ScrollingDecorator class categoriesFor: #icon!constants!public! !
!ScrollingDecorator class categoriesFor: #resource_Default_view!public!resources-views! !

