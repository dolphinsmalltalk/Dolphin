"Filed out from Dolphin Smalltalk 7"!

Interactor subclass: #CapturingInteractor
	instanceVariableNames: 'oldInteractor stateFlags'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'HotMask' -> 16r1.
		'LeftDownMask' -> 16r4.
		'MiddleDownMask' -> 16r8.
		'RightDownMask' -> 16r10
	}!
CapturingInteractor guid: (GUID fromString: '{d6b9eec9-b8fc-41a9-abc6-1df89013c95e}')!
CapturingInteractor isAbstract: true!
CapturingInteractor comment: '`CapturingInteractor` is an abstract class of `<interactor>`s that intercept user input events and potentially absorbs them so that they do not reach the presenter. i.e. if a <CapturingInteractor> is installed into a view then it may appear to ignore all user input. Subclasses may use the input for other purposes, or selectively forward it on to the `<presenter>`.

## Instance Variables:
  `oldInteractor`		`<interactor>`. The <interactor> installed in the <presenter> before this one.
  `stateFlags`		`<integer>`. Various flags.

## Class Variables:
  `RightDownMask`		`<integer>` flags mask to record right-button down.
  `HotMask`			`<integer>` flags mask to record hot (mouse over) state.
  `MiddleDownMask`		`<integer>` flags mask to record middle-button down.
  `LeftDownMask`		`<integer>` flags mask to record left-button down.

'!
!CapturingInteractor categoriesForClass!Unclassified! !
!CapturingInteractor methodsFor!

buttonsReleased
	stateFlags := stateFlags maskClear: ##(LeftDownMask | MiddleDownMask | RightDownMask)!

captureMouse
	self setCapture.
	"Don't return until capture is released"
	SessionManager inputState loopWhile: [View capture == self view]!

captureReleased
	self buttonsReleased.
	self view interactor: oldInteractor!

changeHotState: aBoolean
	aBoolean ifTrue: [self view trackMouseLeave].
	stateFlags := stateFlags mask: HotMask set: aBoolean!

initialize
	"Private - Initialize the receiver"

	super initialize.
	stateFlags := 0!

isHot
	^stateFlags allMask: HotMask!

isHot: aBoolean
	aBoolean == self isHot ifTrue: [^self].
	self changeHotState: aBoolean!

isLeftButtonDown
	"Answer whether the left mouse button has been pressed and not released."

	^stateFlags allMask: LeftDownMask!

isLeftButtonDown: aBoolean
	stateFlags := stateFlags mask: LeftDownMask set: aBoolean!

isMiddleButtonDown
	"Answer whether the middle mouse button has been pressed and not released."

	^stateFlags allMask: MiddleDownMask!

isMiddleButtonDown: aBoolean
	stateFlags := stateFlags mask: MiddleDownMask set: aBoolean!

isRightButtonDown
	"Answer whether the right mouse button has been pressed and not released."

	^stateFlags allMask: RightDownMask!

isRightButtonDown: aBoolean
	stateFlags := stateFlags mask: RightDownMask set: aBoolean!

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

	self isLeftButtonDown: true.
	^false!

onLeftButtonReleased: aMouseEvent
	"The event source received a mouse left button up event,
	gobble it up."

	self isLeftButtonDown: false.
	^false!

onMiddleButtonDoubleClicked: aMouseEvent 
	"The event source received a mouse middle button double-click event
	gobble it up."

	^false!

onMiddleButtonPressed: aMouseEvent 
	"The event source received a mouse middle button down event,
	gobble it up."

	self isMiddleButtonDown: true.
	^false!

onMiddleButtonReleased: aMouseEvent
	"The event source received a mouse middle button up event,
	gobble it up."

	self isMiddleButtonDown: false.
	^false!

onMouseLeave: aMouseEvent 
	"Default handler for a mouse leave event over the receiver's view."

	self buttonsReleased.
	self isHot: false.
	^super onMouseLeave: aMouseEvent!

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

	self isRightButtonDown: true.
	^false!

onRightButtonReleased: aMouseEvent
	"The event source received a mouse right button up event,
	gobble it up."


	self isRightButtonDown: false.
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
!CapturingInteractor categoriesFor: #buttonsReleased!event handling!private! !
!CapturingInteractor categoriesFor: #captureMouse!initializing!public! !
!CapturingInteractor categoriesFor: #captureReleased!event handling!private! !
!CapturingInteractor categoriesFor: #changeHotState:!helpers!private! !
!CapturingInteractor categoriesFor: #initialize!initializing!public! !
!CapturingInteractor categoriesFor: #isHot!public!testing! !
!CapturingInteractor categoriesFor: #isHot:!accessing!public! !
!CapturingInteractor categoriesFor: #isLeftButtonDown!public!testing! !
!CapturingInteractor categoriesFor: #isLeftButtonDown:!accessing!public! !
!CapturingInteractor categoriesFor: #isMiddleButtonDown!public!testing! !
!CapturingInteractor categoriesFor: #isMiddleButtonDown:!accessing!public! !
!CapturingInteractor categoriesFor: #isRightButtonDown!public!testing! !
!CapturingInteractor categoriesFor: #isRightButtonDown:!accessing!public! !
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
!CapturingInteractor categoriesFor: #onMouseLeave:!event handling!public! !
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
!CapturingInteractor categoriesFor: #releaseCapture!helpers!private! !
!CapturingInteractor categoriesFor: #setCapture!helpers!private! !

!CapturingInteractor class methodsFor!

stbConvertToVersion1: instVars 
	| converted |
	converted := Array new: instVars size + 1.
	converted at: 1 put: (instVars at: 1);
		at: 2 put: (instVars at: 2);
		at: 3 put: 0.
	converted replaceFrom: 4 to: converted size with: instVars startingAt: 3.
	^converted! !
!CapturingInteractor class categoriesFor: #stbConvertToVersion1:!binary filing!private! !

