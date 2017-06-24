"Filed out from Dolphin Smalltalk 7"!

Interactor subclass: #CapturingInteractor
	instanceVariableNames: 'oldInteractor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CapturingInteractor guid: (GUID fromString: '{d6b9eec9-b8fc-41a9-abc6-1df89013c95e}')!
CapturingInteractor comment: '<CapturingInteractor> is the class of interactors that intercept user input events and absorb them so that they do not reach the presenter. i.e. if a <CapturingInteractor> is installed into a view then it will appear to ignore all user input. Subclasses may use the input for other purposes, or selectively forward it on to the presenter.'!
!CapturingInteractor categoriesForClass!Unclassified! !
!CapturingInteractor methodsFor!

captureMouse
	self setCapture.
	"Don't return until capture is released"
	SessionManager inputState loopWhile: [View capture == self view]!

captureReleased
	self view interactor: oldInteractor!

onCaptureChanged: aViewOrNil 
	self view == aViewOrNil ifFalse: [self captureReleased].
	^nil!

onKeyPressed: aKeyEvent
	"The event source received a key press event, gobble it up."

	^false!

onKeyReleased: aKeyEvent
	"The event source received a key upevent, gobble it up."

	^false!

onKeyTyped: aKeyEvent
	"The event source received a key entry event, gobble it up.
	Implementation Note: These should not actually occur since
	key/up and down events are consumed and not passed on for
	default processing."

	^false!

onLeftButtonDoubleClicked: aMouseEvent
	"The event source received a mouse left button double-click event
	gobble it up."

	^false!

onLeftButtonPressed: aMouseEvent
	"The event source received a mouse left button down event,
	gobble it up."

	^false!

onLeftButtonReleased: aMouseEvent
	"The event source received a mouse left button up event,
	gobble it up."

	^false!

onMiddleButtonDoubleClicked: aMouseEvent 
	"The event source received a mouse middle button double-click event
	gobble it up."

	^false!

onMiddleButtonPressed: aMouseEvent 
	"The event source received a mouse middle button down event,
	gobble it up."

	^false!

onMiddleButtonReleased: aMouseEvent 
	"The event source received a mouse middle button up event,
	gobble it up."

	^false!

onMouseMoved: aMouseEvent
	"The event source received a mouse move event,
	gobble it up."

	^false!

onMouseWheeled: aMouseWheelEvent
	"The event source received a mouse wheel event,
	gobble it up."

	^false!

onRightButtonDoubleClicked: aMouseEvent
	"The event source received a mouse right button double-click event,
	gobble it up."

	^false!

onRightButtonPressed: aMouseEvent
	"The event source received a mouse right button down event,
	gobble it up."

	^false!

onRightButtonReleased: aMouseEvent
	"The event source received a mouse right button up event,
	gobble it up."

	^false!

onSysKeyPressed: aKeyEvent
	"The event source received a sys key press event, gobble it up."

	^false!

onSysKeyReleased: aKeyEvent 
	"The event source received a sys key upevent, gobble it up."

	^false!

onSysKeyTyped: aKeyEvent 
	"The event source received a sys key entry event, gobble it up. Implementation Note: These
	should not actually occur since key/up and down events are consumed and not passed on for
	default processing."

	^false!

onXButtonDoubleClicked: aMouseEvent 
	"The event source received a mouse X button double-click event gobble it up."

	^false!

onXButtonPressed: aMouseEvent 
	"The event source received a mouse X button down event, gobble it up."

	^false!

onXButtonReleased: aMouseEvent 
	"The event source received a mouse X button up event, gobble it up."

	^false!

releaseCapture
	"Private - Release mouse capture."

	View releaseCapture.!

setCapture
	"Private - Sets mouse capture to the receiver's event source, replacing
	its current interactor so that all input events come here for the duration
	of the capture."

	| source |
	source := self view.
	oldInteractor := source interactor: self.
	source setCapture! !
!CapturingInteractor categoriesFor: #captureMouse!initializing!public! !
!CapturingInteractor categoriesFor: #captureReleased!event handling!private! !
!CapturingInteractor categoriesFor: #onCaptureChanged:!event handling!public! !
!CapturingInteractor categoriesFor: #onKeyPressed:!event handling!public! !
!CapturingInteractor categoriesFor: #onKeyReleased:!event handling!public! !
!CapturingInteractor categoriesFor: #onKeyTyped:!event handling!public! !
!CapturingInteractor categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!CapturingInteractor categoriesFor: #onLeftButtonPressed:!event handling!public! !
!CapturingInteractor categoriesFor: #onLeftButtonReleased:!event handling!public! !
!CapturingInteractor categoriesFor: #onMiddleButtonDoubleClicked:!event handling!public! !
!CapturingInteractor categoriesFor: #onMiddleButtonPressed:!event handling!public! !
!CapturingInteractor categoriesFor: #onMiddleButtonReleased:!event handling!public! !
!CapturingInteractor categoriesFor: #onMouseMoved:!event handling!public! !
!CapturingInteractor categoriesFor: #onMouseWheeled:!event handling!public! !
!CapturingInteractor categoriesFor: #onRightButtonDoubleClicked:!event handling!public! !
!CapturingInteractor categoriesFor: #onRightButtonPressed:!event handling!public! !
!CapturingInteractor categoriesFor: #onRightButtonReleased:!event handling!public! !
!CapturingInteractor categoriesFor: #onSysKeyPressed:!event handling!public! !
!CapturingInteractor categoriesFor: #onSysKeyReleased:!event handling!public! !
!CapturingInteractor categoriesFor: #onSysKeyTyped:!event handling!public! !
!CapturingInteractor categoriesFor: #onXButtonDoubleClicked:!event handling!public! !
!CapturingInteractor categoriesFor: #onXButtonPressed:!event handling!public! !
!CapturingInteractor categoriesFor: #onXButtonReleased:!event handling!public! !
!CapturingInteractor categoriesFor: #releaseCapture!private!testing! !
!CapturingInteractor categoriesFor: #setCapture!private!testing! !

