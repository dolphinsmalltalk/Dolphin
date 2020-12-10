"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Grabber
	instanceVariableNames: 'rectangle aspect constrain view composer'
	classVariableNames: 'Cursors'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Grabber guid: (GUID fromString: '{7024e3c5-a46a-47fb-a7c0-e17bcf414e66}')!
Grabber comment: ''!
!Grabber categoriesForClass!Unclassified! !
!Grabber methodsFor!

alignWithView
	"Private - Computes the boundary rectangle for the receiver to align with
	the grab aspect of the associated view"

	| point rect |
	rect := self view rectangle insetBy: self defaultExtent // 2 negated.
	point := rect perform: self aspect.
	point := composer mapPoint: point toArenaFromView: view.
	rectangle := Rectangle center: point extent: self defaultExtent!

arena
	"Answers the view where the receiver will be drawn."
	
	^composer arena!

aspect
	"Answers the aspect symbol (i.e. #topLeft, #bottomRight) for the receiver"
	
	^aspect!

beHorizontalOnly
	"Set the receiver for horizontal dragging only"

	constrain := #horizontal.!

beVerticalOnly
	"Set the receiver for vertical dragging only"

	constrain := #vertical.!

calculateViewRectangleFor: pointOffset 
	"Private - Calculates boundary rectangle for the associated view if the
	receiver were allowed to modify its aspect to pointOffset. The rectangle is
	in the coordinate system of the arena"

	| rect parentArenaRect |
	rect := composer mapRectangle: self view rectangle toArenaFromView: self view.
	rect perform: self setAspect with: pointOffset.
	rect := Rectangle origin: (self constrainPoint: rect origin)
				corner: (self constrainPoint: rect corner).
	parentArenaRect := composer mapRectangle: self view parentView clientRectangle
				toArenaFromView: self view.
	composer composingView = self view 
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

containsPoint: aPoint
	"Answer true if aPoint (in the coordinate system of our associated shell)
	is within the boundary of the receiver"

	^self rectangle containsPoint: aPoint
!

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

	^self class defaultExtent!

draw
	"Draws the receiver in its arena"

	| canvas |
	self alignWithView.
	canvas := self arena canvas.
	canvas fillRectangle: self rectangle color: self defaultColor.
	canvas free!

drawTrackingAt: pointOffset 
	"Private - Draws the tracking for the aspect of the view associated with the receiver when 
	offset by pointOffset."

	| rect |
	rect := self calculateViewRectangleFor: pointOffset.
	self arena drawFocusRect: rect.
	self status value: (self arena mapRectangle: rect to: self view parentView)!

endTrackingAt: pointOffset 
	"Private - End position tracking for the associated view at aPoint.
	Part of the <MouseTracker> target protocol."

	"If the view that the receiver is associated with has its own
	layout manager, then this will cause it to be validated."

	| rect |
	self eraseTrackingAt: pointOffset.
	rect := self calculateViewRectangleFor: pointOffset.
	rect := composer mapRectangle: rect toViewFromArena: self view.
	self view requestLayoutRectangle: rect.

	"After moving the receiver to its new location trigger a notification."
	self
		alignWithView;
		trigger: #aspectChanged!

eraseTrackingAt: pointOffset
	"Private - Erases the tracking for the aspect of the view associated with the receiver when offset
	by pointOffset. Since the tracking is drawn using an Xored pen we can erase it simply by redrawing 
	it once more"

	self drawTrackingAt: pointOffset!

grid
	"Answers the grid which the receiver should snap to."

	^composer grid!

invalidate
	"Private - Invalidates the areas occupied by the receiver in the Shell associated with the receiver's view"

	self arena invalidateRect: self rectangle

	!

isHorizontalOnly
	"Answer true if the receiver is constrained for horizontal dragging only"

	^constrain == #horizontal!

isVerticalOnly
	"Answer true if the receiver is constrained for vertical dragging only"

	^constrain == #vertical!

rectangle
	"Private - Answers the boundary rectangle for the receiver in the coordinate
	system of our associated view"

	^rectangle!

setAspect
	"Private - Answers the symbol for setting the aspect (i.e. #topLeft:, #bottomRight:)"
	
	^(aspect , ':') asSymbol!

startTrackingAt: pointOffset
	"Private - Start aspect tracking for the associated view at pointOffset. Part of the 
	<MouseTracker> target protocol. Answers the actual position achieved after any view 
	constraints have been applied"

	self drawTrackingAt: pointOffset.
	^pointOffset!

status
	^composer status!

trackMouseFrom: aScreenPoint 
	"The mouse went down within the receiver. Start tracking its movement"

	| tracker |
	(tracker := MouseTracker forPresenter: self view presenter
				startingAt: aScreenPoint) origin: self rectangle center.
	self isHorizontalOnly ifTrue: [tracker beHorizontalOnly].
	self isVerticalOnly ifTrue: [tracker beVerticalOnly].
	tracker startTracking: self!

view
	"Answers the view for the receiver"
	
	^view!

view: aView aspect: anAspectSymbol composer: aViewComposer 
	"Private - Sets the receiver's details."

	view := aView.
	aspect := anAspectSymbol.
	composer := aViewComposer.
	self alignWithView! !
!Grabber categoriesFor: #alignWithView!operations!public! !
!Grabber categoriesFor: #arena!accessing!public! !
!Grabber categoriesFor: #aspect!accessing!public! !
!Grabber categoriesFor: #beHorizontalOnly!accessing!public! !
!Grabber categoriesFor: #beVerticalOnly!accessing!public! !
!Grabber categoriesFor: #calculateViewRectangleFor:!operations!public! !
!Grabber categoriesFor: #cancelTrackingAt:!private!tracking! !
!Grabber categoriesFor: #constrainPoint:!geometry!private! !
!Grabber categoriesFor: #containsPoint:!public!testing! !
!Grabber categoriesFor: #continueTrackingAt:from:!private!tracking! !
!Grabber categoriesFor: #cursor!accessing!public! !
!Grabber categoriesFor: #cursors!accessing!private! !
!Grabber categoriesFor: #defaultColor!constants!private! !
!Grabber categoriesFor: #defaultExtent!constants!private! !
!Grabber categoriesFor: #draw!drawing!public! !
!Grabber categoriesFor: #drawTrackingAt:!private!tracking! !
!Grabber categoriesFor: #endTrackingAt:!private!tracking! !
!Grabber categoriesFor: #eraseTrackingAt:!private!tracking! !
!Grabber categoriesFor: #grid!accessing!public! !
!Grabber categoriesFor: #invalidate!drawing!private! !
!Grabber categoriesFor: #isHorizontalOnly!accessing!public! !
!Grabber categoriesFor: #isVerticalOnly!accessing!public! !
!Grabber categoriesFor: #rectangle!accessing!private! !
!Grabber categoriesFor: #setAspect!accessing!private! !
!Grabber categoriesFor: #startTrackingAt:!private!tracking! !
!Grabber categoriesFor: #status!public! !
!Grabber categoriesFor: #trackMouseFrom:!public!tracking! !
!Grabber categoriesFor: #view!accessing!public! !
!Grabber categoriesFor: #view:aspect:composer:!initializing!private! !

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
	"Private - Answers the default extent to be used for the receiver"

	^6 @ 6!

initialize
	"Private - Register the receiver with the #onStartup event"

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

	^super new
		view: aView aspect: anAspectSymbol arena: arenaView grid: aGrid status: statusModel;
		yourself!

view: aView aspect: anAspectSymbol composer: aViewComposer 
	"Answers an instance of the receiver for anAspectSymbol of aView. The new instance will be
	drawn within aView."

	^(super new)
		view: aView
			aspect: anAspectSymbol
			composer: aViewComposer;
		yourself! !
!Grabber class categoriesFor: #cursors!accessing!private! !
!Grabber class categoriesFor: #defaultExtent!constants!private! !
!Grabber class categoriesFor: #initialize!initializing!private! !
!Grabber class categoriesFor: #new!instance creation!private! !
!Grabber class categoriesFor: #onStartup!event handling!private! !
!Grabber class categoriesFor: #publishedEventsOfInstances!events!private! !
!Grabber class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Grabber class categoriesFor: #view:aspect:arena:grid:status:!instance creation!public! !
!Grabber class categoriesFor: #view:aspect:composer:!instance creation!public! !

