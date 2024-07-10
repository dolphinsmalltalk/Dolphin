"Filed out from Dolphin Smalltalk"!

UI.ImageView
	subclass: #'Tools.ViewComposerArena'
	instanceVariableNames: 'composer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'AdornmentHiddenMask' -> 16r1000 }!

Tools.ViewComposerArena guid: (Core.GUID fromString: '{1cb40e20-1cef-4edd-8012-223620292a00}')!

Tools.ViewComposerArena comment: 'ViewComposerArena is used by the ViewComposer to contain the view being edited. It''s main function is to pass a #drawAdornment
message to the associated ViewComposer each time a paint message is received.'!

!Tools.ViewComposerArena categoriesForClass!MVP-Views! !

!Tools.ViewComposerArena methodsFor!

adornmentRectanglesFor: aView
	"Private - Evaluate the monadic valuable argument for a collection of rectangles that mark the edges of the secondary
	selection adornments of aView. Note may vary depending on the DPI awareness context of the caller."

	| viewRect |
	viewRect := self mapRectangle: (aView getRect expandBy: Grabber.DefaultExtent // 2) fromView: aView.
	^#(#topLeft #bottomRight #topRight #bottomLeft #topCenter #bottomCenter #leftCenter #rightCenter)
		collect: [:eachAspect | Rectangle center: (viewRect perform: eachAspect) extent: Grabber.DefaultExtent]!

assertInNativeDpiContext
	self assert: [self isInNativeDpiAwarenessContext]!

borderRectanglesFor: aView
	"Private - Answer a collection of rectangles that mark the borders of aView"

	| rect grabberWidth grabberHeight width height |
	rect := self mapRectangle: aView getRect fromView: aView.
	grabberWidth := Grabber.DefaultExtent x.
	grabberHeight := Grabber.DefaultExtent y.
	width := rect width.
	height := rect height.
	^{rect topLeft extent: grabberWidth @ height.
		rect topLeft extent: width @ grabberHeight.
		rect topRight - (grabberWidth @ 0) extent: grabberWidth @ height.
		rect bottomLeft - (0 @ grabberHeight) extent: width @ grabberHeight}!

borderRegionFor: aView
	"Private - Answers a Region occupied by the selection borders for aView"

	^(self borderRectanglesFor: aView) inject: Region empty
		into: 
			[:region1 :each |
			| region2 union |
			region2 := Region rectangle: (each insetBy: -1).
			union := region1 union: region2.
			region1 free.
			region2 free.
			union]!

calculatePositionOf: aView offsetBy: pointOffset
	"Private - Answers the constrained position in the arena of aView when offset by pointOffset."

	| newPosition arenaPosition constrainedPosition parent parentArenaRect |
	parent := aView parentView.
	newPosition := aView position + pointOffset.
	constrainedPosition := self constrainPoint: newPosition.
	arenaPosition := self mapPoint: constrainedPosition fromView: aView.

	"Ensure aView stays within its parent rectangle."
	parentArenaRect := (self mapPoint: 0 @ 0 fromView: aView) extent: parent clientExtent.
	arenaPosition := arenaPosition max: parentArenaRect origin.
	arenaPosition := arenaPosition min: parentArenaRect bottomRight - aView extent.
	^arenaPosition!

cancelTrackingAt: aPoint
	self eraseTrackingAt: aPoint.
	self showAdornment!

childLayoutInvalidated
	"Private - The arena does not change its layout because of a change in a child"

	self shouldNotImplement!

composer: aViewComposer2 
	composer := aViewComposer2!

constrainPoint: aPoint
	"Private - Answers the position for aPoint after any view constraints have been taken 
	into consideration"

	^self grid constrainPoint: aPoint!

continueTrackingAt: pointOffset from: previousPointOffset
	"Private - Continue selection tracking at pointOffset when the previous tracking 
	was at previousPointOffset. Part of the <MouseTracker> target protocol. 
	Answers the actual position achieved after any view constraints
	have been applied"

	self eraseTrackingAt: previousPointOffset.
	self drawTrackingAt: pointOffset.
	^pointOffset!

creationFunction: aRectangle dpi: anInteger
	"Private - Answer a function object that encapsulates a CreateWindow API call to create or recreate a window for the receiver, with the specified position and extent, measured at the specified DPI."

	"To support an editing experience that is consistent between system and yet reasonably aesthetically pleasing, we create the VC arena in the unaware-gdi-scaled DPI awareness context. This provides us with device-independent pixel measurements so that all pixel measurements in view resources are at 96-dpi regardless of the OS and monitor setup. The GDI-scaled mode results in much clearer text than the standard unaware mode. See ViewComposer class>>#loadViewResource:inContext: for further commentary."

	self assert: [anInteger = USER_DEFAULT_SCREEN_DPI].
	^CreateInDpiAwarenessContext
		decorating: (super creationFunction: aRectangle dpi: USER_DEFAULT_SCREEN_DPI)
		withDpiAwareness: #gdiScaled!

cursor
	"Answers the cursor to be used.
	If the mouse position is over a Grabber, then
	answer the appropriate cursor."

	^self cursorAt: self cursorPosition!

cursorAt: aPoint
	| primary |
	(self grabberHitBy: aPoint) ifNotNil: [:pair | ^(composer grabbers at: pair key) cursor].
	primary := composer primarySelection.
	(primary isNil or: [composer selections includes: composer composingView]) ifTrue: [^nil].
	^((self borderRegionFor: primary) containsPoint: aPoint) ifTrue: [Cursor sizeAll]!

defaultComposingPosition
	"Private - Answer aPoint used to offset the composing view within the arena when first shown"

	^self insets origin!

displayValue: anImage
	"Private - Set the displayable contents of the receiver to anImage"

	"Override because the VC arena does not change its layout just because the image is changed."

	image := anImage.
	self invalidate!

drawSelectionFor: aView
	"Private - Paint the selection border for aView."

	| canvas |
	canvas := self canvas.
	canvas pen: Color highlight pen.
	(self adornmentRectanglesFor: aView) do: [:each | canvas rectangle: each].
	canvas free!

drawTrackingAt: pointOffset
	"Private - Draws the tracking for the current selections when offset by pointOffset."

	composer moveableSelections do: 
			[:each |
			| newPosition focusRect |
			newPosition := self calculatePositionOf: each offsetBy: pointOffset.
			focusRect := Rectangle origin: newPosition extent: each extent.
			self drawFocusRect: focusRect.

			"For the primary selection, we show the position and size in the statusbar."
			each == composer primarySelection
				ifTrue: 
					[| positionInParent rect |
					positionInParent := self mapPoint: newPosition toView: each parentView.
					rect := Rectangle origin: positionInParent extent: focusRect extent.
					composer statusValue: rect]]!

dropTargetFromScreenPoint: aPoint
	"Private - Determine where the view should be dropped."

	| viewHit arenaPoint |
	arenaPoint := self mapScreenToClient: aPoint.
	viewHit := self viewHitBy: arenaPoint.
	
	[viewHit isNil ifTrue: [^self].
	viewHit canAcceptSubViews]
			whileFalse: [viewHit := viewHit parentView].
	^viewHit!

endTrackingAt: pointOffset
	"Private - End selection tracking at aPoint."

	self eraseTrackingAt: pointOffset.
	composer moveableSelections do: 
			[:each |
			| newPosition screenPosition positionInParent |
			"Don't think this should be necessary - reposition:to: should already do this"
			newPosition := self calculatePositionOf: each offsetBy: pointOffset.
			screenPosition := newPosition - self insets origin + self hidingOffset.
			positionInParent := each parentView mapScreenToClient: screenPosition.
			composer repositionView: each to: positionInParent].
	self showAdornment!

eraseTrackingAt: aPoint
	"Private - Erases the tracking for the current selection when the primary selection is
	moved to aPoint. Since tracking is drawn with an Xor pen mode we can redraw
	it once more to erase it"

	self drawTrackingAt: aPoint	
!

grabberHitBy: aPoint
	| primary hitIndex rectangles |
	self assertInNativeDpiContext.
	primary := composer primarySelection.
	primary ifNil: [^nil].
	rectangles := self adornmentRectanglesFor: primary.
	hitIndex := rectangles findFirst: [:each | each containsPoint: aPoint].
	^hitIndex == 0 ifFalse: [hitIndex -> (rectangles at: hitIndex)]!

grid
	"Answers the grid which the receiver should snap to."

	^composer grid!

hideAdornment
	self isAdornmentHidden ifTrue: [^self].
	self isAdornmentHidden: true.
	self invalidateAdornment!

hidingOffset
	^composer composingView position!

invalidateAdornment
	composer ifNil: [^self].
	composer selections do: [:each | self invalidateAdornmentFor: each]!

invalidateAdornmentFor: aView
	(self adornmentRectanglesFor: aView)
		do: [:rect | self invalidateRect: (rect expandBy: 1) erase: true]!

isAdornmentHidden
	^self ivFlags allMask: AdornmentHiddenMask!

isAdornmentHidden: aBoolean
	ivFlags := self ivFlags mask: AdornmentHiddenMask set: aBoolean!

mapPoint: aPoint fromView: aView
	^(aView parentView mapPointToScreen: aPoint) - self hidingOffset + self insets origin!

mapPoint: aPoint toView: aView
	^aView mapScreenToClient: aPoint - self defaultComposingPosition + self hidingOffset!

mapRectangle: aRectangle fromView: aView
	| offset |
	offset := self insets origin - self hidingOffset.
	^(aView parentView mapRectangle: aRectangle to: View desktop) moveBy: offset!

mapRectangle: aRectangle toView: aView
	| offset |
	offset := self insets origin - self hidingOffset.
	^(View desktop mapRectangle: aRectangle to: aView parentView) moveBy: offset negated!

onLeftButtonPressed: aMouseEvent
	| position viewHit screenPosition mouseTracker |
	screenPosition := aMouseEvent screenPosition.
	mouseTracker := MouseTracker forPresenter: self startingAt: screenPosition.
	"Has the mouse hit a Grabber ?"
	position := aMouseEvent position - 1.
	(self grabberHitBy: position)
		ifNotNil: 
			[:pair |
			| grabber |
			grabber := composer grabbers at: pair key.
			grabber isDisabled
				ifFalse: 
					[self
						trackGrabber: grabber
						from: screenPosition
						origin: pair value center.
					^nil]].
	"Has the mouse hit a selection border ?"
	viewHit := nil.
	composer primarySelection
		ifNotNil: 
			[:primary |
			| region |
			region := self borderRegionFor: primary.
			(region containsPoint: position) ifTrue: [viewHit := primary].
			region free].
	viewHit
		ifNil: 
			["Has the mouse hit a view ?"
			viewHit := self viewHitBy: position.
			viewHit
				ifNil: 
					[mouseTracker := nil.
					viewHit := composer composingView]].
	viewHit ifNil: [^nil].
	"A view has been hit, so update selection if there is any change required."
	composer isMouseClick: true.
	aMouseEvent isCtrlDown
		ifTrue: 
			[(composer selections includes: viewHit) ifTrue: [mouseTracker := nil].
			composer toggleSelectionFor: viewHit]
		ifFalse: 
			[aMouseEvent isShiftDown
				ifTrue: [composer addSelectionFor: viewHit]
				ifFalse: [composer primarySelection == viewHit ifFalse: [composer selection: viewHit]]].
	"The composing view cannot be moved"
	(composer selections includes: composer composingView) ifTrue: [mouseTracker := nil].
	composer isMouseClick: false.
	"If no change of selection, start tracking"
	mouseTracker
		ifNotNil: 
			[mouseTracker startTracking: self.
			viewHit == composer composingView ifTrue: [[composer adjustScroll] postToInputQueue]].
	^nil!

onMouseMoved: aMouseEvent
	| cursor |
	composer isNil ifTrue: [^nil].
	cursor := self cursor.
	cursor notNil ifTrue: [cursor setCursor].
	^nil!

onPaintRequired: aPaintEvent
	"Private - Handle the paint event. We try and do this with as little overhead as possible because the mixed DPI hosting does seem to have a visible perf impact."

	| canvas origin extent |
	canvas := aPaintEvent canvas.
	image
		ifNil: 
			[canvas fillRectangle: self getClientRect color: self actualBackcolor.
			^self].
	origin := insets origin.
	extent := image extent.
	canvas
		bitBlt: image canvas
			rectangle: (Point.Zero corner: extent)
			to: origin
			rop: SRCCOPY;
		excludeClipRectangle: (origin extent: extent);
		fillRectangle: self getClientRect color: self actualBackcolor.
	(self isAdornmentHidden or: [composer hasSelection not]) ifTrue: [^self].
	canvas selectClipRegion: nil.
	self paintAdornments: canvas!

onViewClosed
	composer := nil.
	^super onViewClosed!

paintAdornments: aCanvas
	| primary |
	primary := composer primarySelection.
	primary ifNil: [^self].
	aCanvas
		pen: Color highlight pen;
		brush: Brush white.
	composer selections do: 
			[:each |
			each == primary
				ifFalse: [(self adornmentRectanglesFor: each) do: [:rect | aCanvas rectangle: rect]]].
	composer grabbers with: (self adornmentRectanglesFor: primary)
		do: [:each :rectangle | each drawOn: aCanvas rectangle: rectangle]!

showAdornment
	self isAdornmentHidden ifFalse: [^self].
	self isAdornmentHidden: false.
	self invalidateAdornment!

snapPoint: aPoint context: contextView
	"Private - Answers an instance of Point which is aPoint snapped to the grid. Both the argument aPoint and the answer are in the coordinate space of the argument contextView."

	^self mapPoint: (self constrainPoint: (contextView mapPoint: aPoint to: self)) to: contextView!

startTrackingAt: pointOffset
	"Private - Start selection tracking at pointOffset. Part of the <MouseTracker> 
	target protocol. Answers the actual position achieved after any  
	constraints have been applied"

	self hideAdornment; update.
	Cursor sizeAll setCursor.
	self drawTrackingAt: pointOffset.
	^pointOffset!

trackGrabber: aGrabber from: aScreenPoint origin: aPoint
	"Private - Track aGrabber which has been hit with the mouse at aScreenPoint."

	self hideAdornment.
	aGrabber cursor setCursor.
	aGrabber trackMouseFrom: aScreenPoint origin: aPoint.
	aGrabber view == composer composingView ifTrue: [composer adjustScroll].
	self showAdornment.
	composer setModified!

viewHitBy: aPoint
	"Private - Answers the view that can be hit by a mouse action at aPoint. "

	| viewHit composingView |
	self assertInNativeDpiContext.
	composingView := composer composingView.
	composingView ifNil: [^nil].
	composer primarySelection
		ifNotNil: 
			[:primary |
			| lookInView |
			lookInView := primary.
			
			[| position |
			position := self mapPoint: aPoint toView: lookInView.
			viewHit := lookInView subViewFromPoint: position.
			lookInView := lookInView parentView.
			viewHit isNil and: [lookInView isDesktop not]]
					whileTrue].
	(viewHit isNil and: [(0 @ 0 corner: composingView extent) containsPoint: aPoint])
		ifTrue: [viewHit := composingView].
	^viewHit! !

!Tools.ViewComposerArena categoriesForMethods!
adornmentRectanglesFor:!private! !
assertInNativeDpiContext!helpers!private! !
borderRectanglesFor:!adornments!private! !
borderRegionFor:!adornments!private! !
calculatePositionOf:offsetBy:!adornments!private! !
cancelTrackingAt:!private!tracking! !
childLayoutInvalidated!geometry!private! !
composer:!public! !
constrainPoint:!geometry!private! !
continueTrackingAt:from:!private!tracking! !
creationFunction:dpi:!private!realizing/unrealizing! !
cursor!accessing!public! !
cursorAt:!helpers!private! !
defaultComposingPosition!constants!private! !
displayValue:!private!updating! !
drawSelectionFor:!adornments!private! !
drawTrackingAt:!private!tracking! !
dropTargetFromScreenPoint:!drag & drop!private! !
endTrackingAt:!private!tracking! !
eraseTrackingAt:!private!tracking! !
grabberHitBy:!helpers!private! !
grid!accessing!public! !
hideAdornment!adornments!private! !
hidingOffset!accessing!private! !
invalidateAdornment!operations!private! !
invalidateAdornmentFor:!operations!public! !
isAdornmentHidden!adornments!private! !
isAdornmentHidden:!adornments!private! !
mapPoint:fromView:!helpers!private! !
mapPoint:toView:!helpers!private! !
mapRectangle:fromView:!private! !
mapRectangle:toView:!private! !
onLeftButtonPressed:!event handling!private! !
onMouseMoved:!event handling!private! !
onPaintRequired:!event handling!private! !
onViewClosed!event handling!public! !
paintAdornments:!operations!private! !
showAdornment!adornments!private! !
snapPoint:context:!geometry!private! !
startTrackingAt:!private!tracking! !
trackGrabber:from:origin:!adornments!private! !
viewHitBy:!accessing!private! !
!

Tools.ViewComposerArena methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

