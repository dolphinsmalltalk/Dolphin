"Filed out from Dolphin Smalltalk 7"!

UI.CapturingInteractor subclass: #'UI.MouseTracker'
	instanceVariableNames: 'dragButton target startPoint startPointLocal origin hysteresis _unused10 trackPosition constrain'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'TrackingMask' -> 16r400
	}!
UI.MouseTracker guid: (Core.GUID fromString: '{87b4c711-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.MouseTracker comment: '`MouseTracker` is an `<Interactor`> that is used to manage the visual dragging of objects using the mouse. An instance should be created as the result of a mouse down event and once started using `#startTracking:` it captures the mouse and relays the drag messages that are part of the `<mouseTrackerTarget>` protocol to the target that is assigned to it. Once the drag has completed, and the originating button has been released, the mouse capture is also dropped. Tracking will also be cancelled if the user Alt+Tab''s to another application, or presses the ESC (escape) key (assuming the originating view still has focus).

## Instance Variables:
  `dragButton`		`Symbol` identifying the button (either #left or #right) that started the drag
  `target`			`<mouseTrackerTarget>` that receives tracking messages.
  `startPoint`		`Point` at which the drag started.
  `startPointLocal`	`Point` at which the drag started in local co-ordinates.
  `origin`			`Point` that identifies the origin of an object being dragged.
  `hysteresis`		`Point` extent of rectangle outside of which the mouse must move before a drag is started.
  `trackPosition`		`Point` holding the last drag position.
  `constrain`		`Symbol` or `nil`, identifying any drag constraint (either `#horizontal` or `#vertical`).

## Class Variables:
  `TrackingMask`	`<integer>` flags mask for flag indicating tracking is active.



'!
!UI.MouseTracker categoriesForClass!MVP-Interactors! !
!UI.MouseTracker methodsFor!

beHorizontalOnly
	"Set the receiver for horizontal dragging only"

	constrain := #horizontal.!

beVerticalOnly
	"Set the receiver for vertical dragging only"

	constrain := #vertical.!

cancelTracking
	self isTracking: false.
	self target cancelTrackingAt: self trackPosition!

captureReleased
	super captureReleased.
	self isTracking ifTrue: [self cancelTracking]!

constrainPositionFromDelta: aPoint
	"Private - Answers a target position constrained from a delta mouse movement.
	Applies vertical or horizontal constraints"

	| delta |
	delta := aPoint.
	self isHorizontalOnly ifTrue: [ delta y: 0 ].
	self isVerticalOnly ifTrue: [ delta x: 0 ].
	^self origin + delta!

dragButton
	"Answer the receiver's dragButton inst var. This is one of #left or #right and identifies which mouse
	button up event will signal the end of the tracking operation."

	^dragButton!

dragButton: buttonSymbol
	"Set the receiver's dragButton inst var to buttonSymbol. This is one of #left or #right and identifies which mouse
	button up event will signal the end of the tracking operation."

	dragButton := buttonSymbol!

dragButtonUp: aMouseEvent 
	"Private - The mouse has been released so end the current target tracking operation if,
	in fact, it had started"

	
	| delta wasTracking |
	delta := aMouseEvent position - self startPointLocal.
	wasTracking := self isTracking.
	self isTracking: false.
	"Release mouse capture before informing target in case target pops up a message box
	 which confuses Windows such that the drag cursor is only partially turned off.
	 Note that a WM_CAPTURECHANGED will be sent."
	self releaseCapture.
	^wasTracking 
		ifTrue: [self target endTrackingAt: (self constrainPositionFromDelta: delta). false]!

hysteresis
	"Private - Answer the hysteresis value; the radius by which the mouse must
	move away from the start point before position tracking begins"

	^hysteresis!

hysteresis: anInteger
	"Sets the hysteresis value of the receiver to anInteger. This is the radius 
	by which the mouse must	move away from the start point before position 
	tracking begins"

	hysteresis := anInteger!

isHorizontalOnly
	"Private - Answer true if the receiver is constrained for horizontal dragging only"

	^constrain == #horizontal!

isTracking
	"Private - Answer true if the receiver is currently tracking for the target. This implies
	that the mouse has moved outside the hysteresis radius, or that the tracker was set up to
	start tracking immediately."

	^stateFlags allMask: TrackingMask!

isTracking: aBoolean
	stateFlags := stateFlags mask: TrackingMask set: aBoolean!

isVerticalOnly
	"Private - Answer true if the receiver is constrained for vertical dragging only"

	^constrain == #vertical!

onKeyPressed: aKeyEvent 
	aKeyEvent code = VK_ESCAPE ifTrue: [self releaseCapture].
	self onKeyTransition: aKeyEvent.
	^super onKeyPressed: aKeyEvent!

onKeyReleased: aKeyEvent 
	self onKeyTransition: aKeyEvent.
	^super onKeyReleased: aKeyEvent!

onKeyTransition: aKeyEvent 
	| key |
	key := aKeyEvent code.
	(key = VK_CONTROL or: [key = VK_SHIFT]) ifTrue: [self simulateMouseMouse: aKeyEvent]!

onLeftButtonReleased: aMouseEvent
	"The left mouse button has been released so if this is the drag button then end the tracking operation."

	super onLeftButtonReleased: aMouseEvent.
	dragButton == #left
		ifTrue: [^self dragButtonUp: aMouseEvent].
	^nil


!

onMouseHovering: aMouseEvent 
	^self presenter onMouseHovering: aMouseEvent!

onMouseMoved: aMouseEvent
	"Track the mouse movement to aMouseEvent"

	| constrainedPosition |
	constrainedPosition := self constrainPositionFromDelta: aMouseEvent position - self startPointLocal.
	self isTracking
		ifTrue: 
			[self trackPosition: (self target continueTrackingAt: constrainedPosition from: self trackPosition)]
		ifFalse: 
			["We have not yet moved outside the hysteresis zone"
			((Rectangle center: self startPoint extent: self hysteresis)
				containsPoint: aMouseEvent screenPosition)
					ifFalse: 
						[self isTracking: true.
						self trackPosition: (self target startTrackingAt: constrainedPosition)]].
	^false	"Don't perform default processing"!

onRightButtonReleased: aMouseEvent
	"The right mouse button has been released so if this is the drag button then end the tracking operation."

	dragButton == #right
		ifTrue: [^self dragButtonUp: aMouseEvent].
	^nil


!

onSysKeyPressed: aKeyEvent 
	self onSysKeyTransition: aKeyEvent.
	^super onSysKeyPressed: aKeyEvent!

onSysKeyReleased: aKeyEvent 
	self onSysKeyTransition: aKeyEvent.
	^super onKeyReleased: aKeyEvent!

onSysKeyTransition: aKeyEvent
	| key |
	key := aKeyEvent code.
	key = VK_MENU ifTrue: [self simulateMouseMouse: aKeyEvent]!

origin
	"Answer the coordinates of the target's origin to aPoint. This is effectively the point
	being dragged, and is used as the origin for all coordiantes sent to the target during
	the tracking dialogue"

	^origin!

origin: aPoint
	"Set the coordinates of the target's origin to aPoint. This is effectively the point
	being dragged, and is used as the origin for all coordiantes sent to the target during
	the tracking dialogue"

	trackPosition := origin := aPoint!

setPresenter: aPresenter
	super setPresenter: aPresenter.
	self origin: Point new.
	hysteresis := self class defaultHysteresis.
	stateFlags := 0.
	dragButton := #left!

simulateMouseMouse: aKeyEvent
	| pos event wParam |
	pos := Cursor position.
	wParam := 0.
	##({VK_LBUTTON -> MK_LBUTTON.
		VK_MBUTTON -> MK_MBUTTON.
		VK_RBUTTON -> MK_RBUTTON.
		VK_CONTROL -> MK_CONTROL.
		VK_SHIFT -> MK_SHIFT.
		VK_XBUTTON1 -> MK_XBUTTON1.
		VK_XBUTTON2 -> MK_XBUTTON2})
			do: [:each | (Keyboard default isKeyDown: each key) ifTrue: [wParam := wParam bitOr: each value]].
	event := MouseEvent
				window: self view
				message: WM_MOUSEMOVE
				wParam: wParam
				lParam: (View desktop mapPoint: pos to: self view) asUIntPtr.
	self onMouseMoved: event.
	^false!

startPoint
	startPoint isNil ifTrue: [self startPoint: Cursor position].
	^startPoint!

startPoint: aPoint
	"Private - Set the starting mouse position when the receiver was instantiated.
	to aPoint in screen coordinates."

	startPoint := aPoint.	
	startPointLocal := nil.!

startPointLocal
	"Private - Answer the starting mouse position when the receiver was instantiated
	in the coordinate system of the receiver's source."

	startPointLocal isNil
		ifTrue: [startPointLocal := View desktop mapPoint: self startPoint to: self view].
	^startPointLocal!

startTracking: aMouseTrackerTarget 
	"Start tracking the mouse on behalf of the <mouseTrackerTarget> argument.
	The mouse is captured and will remain so until the button is released or capture
	is lost for some other reason."

	target := aMouseTrackerTarget.
	self captureMouse!

target
	"Private - Answer the target object to be tracked by the receiver"

	^target!

trackPosition
	"Private - Answer the latest tracking position of the target"

	^trackPosition!

trackPosition: aPoint
	"Private - Set the latest tracking position of the target to aPoint.
	If the argument is nil, then stop tracking."

	(trackPosition := aPoint) isNil ifTrue: [self releaseCapture]!

trackPositionDelta: aPointDelta
	"Private - Set the latest tracking position of the target based on
	a delta value from the origin"

	trackPosition := self origin + aPointDelta! !
!UI.MouseTracker categoriesFor: #beHorizontalOnly!modes!public! !
!UI.MouseTracker categoriesFor: #beVerticalOnly!modes!public! !
!UI.MouseTracker categoriesFor: #cancelTracking!accessing!private! !
!UI.MouseTracker categoriesFor: #captureReleased!event handling!private! !
!UI.MouseTracker categoriesFor: #constrainPositionFromDelta:!helpers!private! !
!UI.MouseTracker categoriesFor: #dragButton!accessing!public! !
!UI.MouseTracker categoriesFor: #dragButton:!accessing!public! !
!UI.MouseTracker categoriesFor: #dragButtonUp:!drag & drop!private! !
!UI.MouseTracker categoriesFor: #hysteresis!accessing!private! !
!UI.MouseTracker categoriesFor: #hysteresis:!initializing!public! !
!UI.MouseTracker categoriesFor: #isHorizontalOnly!private!testing! !
!UI.MouseTracker categoriesFor: #isTracking!private!testing! !
!UI.MouseTracker categoriesFor: #isTracking:!private!testing! !
!UI.MouseTracker categoriesFor: #isVerticalOnly!private!testing! !
!UI.MouseTracker categoriesFor: #onKeyPressed:!event handling!public! !
!UI.MouseTracker categoriesFor: #onKeyReleased:!event handling!public! !
!UI.MouseTracker categoriesFor: #onKeyTransition:!event handling!private! !
!UI.MouseTracker categoriesFor: #onLeftButtonReleased:!event handling!public! !
!UI.MouseTracker categoriesFor: #onMouseHovering:!event handling!public! !
!UI.MouseTracker categoriesFor: #onMouseMoved:!event handling!public! !
!UI.MouseTracker categoriesFor: #onRightButtonReleased:!event handling!public! !
!UI.MouseTracker categoriesFor: #onSysKeyPressed:!event handling!public! !
!UI.MouseTracker categoriesFor: #onSysKeyReleased:!event handling!public! !
!UI.MouseTracker categoriesFor: #onSysKeyTransition:!helpers!private! !
!UI.MouseTracker categoriesFor: #origin!accessing!public! !
!UI.MouseTracker categoriesFor: #origin:!accessing!public! !
!UI.MouseTracker categoriesFor: #setPresenter:!accessing!private! !
!UI.MouseTracker categoriesFor: #simulateMouseMouse:!helpers!private! !
!UI.MouseTracker categoriesFor: #startPoint!accessing!private! !
!UI.MouseTracker categoriesFor: #startPoint:!accessing!private! !
!UI.MouseTracker categoriesFor: #startPointLocal!accessing!private! !
!UI.MouseTracker categoriesFor: #startTracking:!initializing!public! !
!UI.MouseTracker categoriesFor: #target!accessing!private! !
!UI.MouseTracker categoriesFor: #trackPosition!accessing!private! !
!UI.MouseTracker categoriesFor: #trackPosition:!accessing!private! !
!UI.MouseTracker categoriesFor: #trackPositionDelta:!accessing!private! !

!UI.MouseTracker class methodsFor!

defaultHysteresis
	"Answer the default distance in pixels that the mouse must move before 
	a tracking operation is actually started"

	^SystemMetrics current dragHysteresis!

forPresenter: aPresenter startingAt: aPoint 
	"Answers an instance of the receiver for tracking the mouse from aPoint
	in screen coordinates"

	^(self forPresenter: aPresenter)
		startPoint: aPoint;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!UI.MouseTracker class categoriesFor: #defaultHysteresis!constants!public! !
!UI.MouseTracker class categoriesFor: #forPresenter:startingAt:!instance creation!public! !
!UI.MouseTracker class categoriesFor: #icon!constants!public! !

