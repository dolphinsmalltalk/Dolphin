"Filed out from Dolphin Smalltalk"!

MouseTracker subclass: #DraggableViewInteractor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DraggableViewInteractor guid: (GUID fromString: '{17db18df-6991-4fe4-b6f7-ebe986ea3281}')!

DraggableViewInteractor comment: '`DraggableViewInteractor` is a `CapturingInteractor` that tracks hot state as the mouse moves over (hot) and out (cold) of the associated view. If the left mouse button is pressed down when hot, then the interactor initiates a "drag", sending tracking events to the its `Presenter` in the same way as a `MouseTracker` does.

An example use is with `Splitter`s. When the mouse moves over the `Splitter`, the interactor moves into the "hot" state and invalidates the view. The view can choose to take account of the "hot" state when repainting, which the `Splitter` does by including some subtle adornment to indicate its presence to the user. Initiating a drag results in the interactor turning off the hot state, before sending the `Splitter` the normal `MouseTracker` tracking events, which it responds to by drawing its hypothetical new position, etc.'!

!DraggableViewInteractor categoriesForClass!MVP-Interactors! !

!DraggableViewInteractor methodsFor!

changeHotState: aBoolean
	"Note the assumption that the view has visual indication of its hot state (i.e. when the mouse is over it)."

	self view invalidate.
	super changeHotState: aBoolean!

onLeftButtonPressed: aMouseEvent
	"The user has pressed down the mouse left button over the receiver's view. Capture the mouse
	and start sending tracking events to the view once the mouse is moved out of the hysteresis
	zone with the button still down, and continue sending such events even if the mouse is
	subsequently moved outside the view with the button still down."

	super onLeftButtonPressed: aMouseEvent.
	self isHot: false.
	self view setFocus.
	self
		startPoint: aMouseEvent screenPosition;
		origin: aMouseEvent position + self view position;
		startTracking: self view.
	^false!

onMouseMoved: aMouseEvent
	"Track the mouse movement to aMouseEvent"

	self isLeftButtonDown
		ifTrue: [super onMouseMoved: aMouseEvent]
		ifFalse: 
			["If the mouse button is up and we receive a move event, then we are hot."
			self
				isTracking: false;
				isHot: true].
	^false	"Suppress perform default processing"! !

!DraggableViewInteractor categoriesForMethods!
changeHotState:!accessing!private! !
onLeftButtonPressed:!event handling!public! !
onMouseMoved:!event handling!public! !
!

