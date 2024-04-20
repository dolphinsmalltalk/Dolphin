"Filed out from Dolphin Smalltalk"!

Object subclass: #Grabber
	instanceVariableNames: 'aspect flags view composer'
	classVariableNames: 'ConstrainedMask ConstrainHorizontalMask ConstrainVerticalMask Cursors DefaultExtent'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

Grabber guid: (GUID fromString: '{7024e3c5-a46a-47fb-a7c0-e17bcf414e66}')!

Grabber addClassConstant: 'ConstrainedMask' value: 16r3!
Grabber addClassConstant: 'ConstrainHorizontalMask' value: 16r2!
Grabber addClassConstant: 'ConstrainVerticalMask' value: 16r1!

Grabber comment: ''!

!Grabber categoriesForClass!Unclassified! !

!Grabber methodsFor!

arena
	"Answers the view where the receiver will be drawn."
	
	^composer arena!

aspect
	"Answers the aspect symbol (i.e. #topLeft, #bottomRight) for the receiver"
	
	^aspect!

beDisabled
	"Disable dragging of the receiver."

	flags := flags bitOr: ##(ConstrainHorizontalMask | ConstrainVerticalMask)!

beHorizontalOnly
	"Set the receiver for horizontal dragging only"

	flags := (flags bitAnd: ##(ConstrainedMask bitInvert)) bitOr: ConstrainHorizontalMask!

beVerticalOnly
	"Set the receiver for vertical dragging only"

	flags := (flags bitAnd: ##(ConstrainedMask bitInvert)) bitOr: ConstrainVerticalMask!

calculateViewRectangleFor: pointOffset
	"Private - Calculates boundary rectangle for the associated view if the
	receiver were allowed to modify its aspect to pointOffset. The rectangle is
	in the coordinate system of the arena"

	| rect parentArenaRect isComposingView arena |
	composer assertInArenaDpiContext.
	arena := self arena.
	rect := arena mapRectangle: view rectangle fromView: view.
	rect perform: self setAspect with: pointOffset.
	isComposingView := composer composingView = view.
	rect := Rectangle
				origin: (isComposingView ifTrue: [rect origin] ifFalse: [self constrainPoint: rect origin])
				corner: (self constrainPoint: rect corner).
	parentArenaRect := arena mapRectangle: view parentView getClientRect fromView: view.
	isComposingView
		ifFalse: 
			["Constrain any view that is not top level to the size of it's parent"
			rect topLeft: (rect topLeft max: parentArenaRect topLeft).
			rect bottomRight: (rect bottomRight min: parentArenaRect bottomRight)].
	^rect!

cancelTrackingAt: aPoint 
	self eraseTrackingAt: aPoint!

constrainPoint: aPoint
	"Private - Answers the position for aPoint after any view constraints have been taken 
	into consideration"

	^self grid constrainPoint: aPoint!

continueTrackingAt: pointOffset from: previousPointOffset
	"Private - Continue position tracking for the associated view at pointOffset when
	the previous tracking position was at previousPointOffset. Part of the <MouseTracker>
	target protocol. Answers the actual position achieved after any view constraints
	have been applied"

	self eraseTrackingAt: previousPointOffset.
	self drawTrackingAt: pointOffset.
	^pointOffset!

cursor
	"Answers the instance of Cursor which should be used to
	indicate that the mouse pointer is over the receiver."

	self isDisabled ifTrue: [^nil].
	self isHorizontalOnly ifTrue: [^Cursor sizeWE].
	self isVerticalOnly ifTrue: [^Cursor sizeNS].
	^self cursors at: self aspect!

cursors
	"Private - Answer the Cursors class variable."

	^self class cursors!

defaultColor
	"Private - Answers the default colour to be used for a grab location in the
	receiver. Use the higlight colour from the system colours"

	^Color highlight!

defaultExtent
	"Private - Answers the default extent to be used for the receiver"

	^DefaultExtent * view dpi // USER_DEFAULT_SCREEN_DPI!

drawOn: aCanvas rectangle: aRectangle
	self isDisabled
		ifTrue: 
			[aCanvas
				brush: Brush white;
				pen: Color highlight pen;
				rectangle: aRectangle]
		ifFalse: [aCanvas fillRectangle: aRectangle color: Color highlight]!

drawTrackingAt: pointOffset
	"Private - Draws the tracking for the geometry aspect of the view associated with the receiver when offset by pointOffset."

	| rect arenaRect |
	"We expect to be tracking in the arena DPI awareness context, i.e. in DIPs"
	self arena assertInOwnDpiContext.
	rect := self calculateViewRectangleFor: pointOffset.
	self arena drawFocusRect: rect.
	arenaRect := self arena mapRectangle: rect to: view parentView.
	composer statusValue: arenaRect!

endTrackingAt: pointOffset
	"Private - End position tracking for the associated view at aPoint.
	Part of the <MouseTracker> target protocol."

	"If the view that the receiver is associated with has its own
	layout manager, then this will cause it to be validated."

	| rect |
	self eraseTrackingAt: pointOffset.
	rect := self calculateViewRectangleFor: pointOffset.
	rect := self arena mapRectangle: rect toView: view.
	view requestLayoutRectangle: rect.

	"After moving the receiver to its new location trigger a notification."
	self trigger: #aspectChanged!

eraseTrackingAt: pointOffset
	"Private - Erases the tracking for the aspect of the view associated with the receiver when offset
	by pointOffset. Since the tracking is drawn using an Xored pen we can erase it simply by redrawing 
	it once more"

	self drawTrackingAt: pointOffset!

grid
	"Answers the grid which the receiver should snap to."

	^composer grid!

isDisabled
	"Answer true if the receiver is constrained for horizontal dragging only"

	^flags allMask: ConstrainedMask!

isHorizontalOnly
	"Answer true if the receiver is constrained for horizontal dragging only"

	^flags allMask: ConstrainHorizontalMask!

isVerticalOnly
	"Answer true if the receiver is constrained for vertical dragging only"

	^flags allMask: ConstrainVerticalMask!

setAspect
	"Private - Answers the symbol for setting the aspect (i.e. #topLeft:, #bottomRight:)"
	
	^(aspect , ':') asSymbol!

startTrackingAt: pointOffset
	"Private - Start aspect tracking for the associated view at pointOffset. Part of the 
	<MouseTracker> target protocol. Answers the actual position achieved after any view 
	constraints have been applied"

	self drawTrackingAt: pointOffset.
	^pointOffset!

trackMouseFrom: aScreenPoint origin: aPoint
	"The mouse went down within the receiver. Start tracking its movement"

	| tracker |
	(tracker := MouseTracker forPresenter: view presenter startingAt: aScreenPoint) origin: aPoint.
	self isHorizontalOnly ifTrue: [tracker beHorizontalOnly].
	self isVerticalOnly ifTrue: [tracker beVerticalOnly].
	tracker startTracking: self!

view
	"Answers the view for the receiver"
	
	^view!

view: aView aspect: anAspectSymbol composer: aViewComposer
	view := aView.
	aspect := anAspectSymbol.
	composer := aViewComposer.
	flags := 0.
	^self! !

!Grabber categoriesForMethods!
arena!accessing!public! !
aspect!accessing!public! !
beDisabled!accessing!public! !
beHorizontalOnly!accessing!public! !
beVerticalOnly!accessing!public! !
calculateViewRectangleFor:!operations!private! !
cancelTrackingAt:!private!tracking! !
constrainPoint:!geometry!private! !
continueTrackingAt:from:!private!tracking! !
cursor!accessing!public! !
cursors!accessing!private! !
defaultColor!constants!private! !
defaultExtent!constants!private! !
drawOn:rectangle:!accessing!public! !
drawTrackingAt:!private!tracking! !
endTrackingAt:!private!tracking! !
eraseTrackingAt:!private!tracking! !
grid!accessing!public! !
isDisabled!accessing!public! !
isHorizontalOnly!accessing!public! !
isVerticalOnly!accessing!public! !
setAspect!accessing!private! !
startTrackingAt:!private!tracking! !
trackMouseFrom:origin:!public!tracking! !
view!accessing!public! !
view:aspect:composer:!initializing!private! !
!

Grabber methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!Grabber class methodsFor!

cursors
	"Private - Answer the Cursors class variable."

	Cursors isNil ifTrue: [
		Cursors := IdentityDictionary new
			at: #bottomRight put: Cursor sizeNWSE;
			at: #topLeft put: Cursor sizeNWSE;
			at: #topRight put: Cursor sizeNESW;
			at: #bottomLeft put: Cursor sizeNESW;
			at: #leftCenter put: Cursor sizeWE;
			at: #rightCenter put: Cursor sizeWE;
			at: #topCenter put: Cursor sizeNS;
			at: #bottomCenter put: Cursor sizeNS;
			shrink;
			yourself ].
	^Cursors
!

defaultExtent
	"Private - Answers the default extent to be used for the receiver, measured in device-independent (96 dpi) pixels."

	^DefaultExtent!

initialize
	"Private - Register the receiver with the #onStartup event"

	self addClassConstant: 'DefaultExtent' value: 6@6.
	SessionManager current when: #sessionStarted send: #onStartup to: self!

new
	"Private - Use #view:aspect:"

	self shouldNotImplement!

onStartup
	"Private - Clear the Cursors class variable."

	Cursors := nil!

publishedEventsOfInstances
	"Private - Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #aspectChanged;
		yourself.
!

uninitialize
	SessionManager current removeEventsTriggeredFor: self!

view: aView aspect: anAspectSymbol arena: arenaView grid: aGrid status: statusModel
	"Answers an instance of the receiver for anAspectSymbol of aView. The new instance will be
	drawn within aView."

	^self basicNew
		view: aView aspect: anAspectSymbol arena: arenaView grid: aGrid status: statusModel;
		yourself!

view: aView aspect: anAspectSymbol composer: aViewComposer
	"Answers an instance of the receiver for anAspectSymbol of aView."

	^self basicNew
		view: aView
		aspect: anAspectSymbol
		composer: aViewComposer! !

!Grabber class categoriesForMethods!
cursors!accessing!private! !
defaultExtent!constants!private! !
initialize!initializing!private! !
new!instance creation!private! !
onStartup!event handling!private! !
publishedEventsOfInstances!events!private! !
uninitialize!class hierarchy-removing!private! !
view:aspect:arena:grid:status:!instance creation!public! !
view:aspect:composer:!instance creation!public! !
!

