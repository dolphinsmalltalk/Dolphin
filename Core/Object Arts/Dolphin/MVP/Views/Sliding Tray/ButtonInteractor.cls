"Filed out from Dolphin Smalltalk"!

CapturingInteractor subclass: #ButtonInteractor
	instanceVariableNames: 'buttonRect _unused5 commandDescription'
	classVariableNames: 'ButtonStateMask PressedMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ButtonInteractor guid: (GUID fromString: '{28d6227f-7753-4595-b98a-7b363d34e90f}')!
ButtonInteractor addClassConstant: 'ButtonStateMask' value: 16r3!
ButtonInteractor addClassConstant: 'PressedMask' value: 16r2!
ButtonInteractor comment: '`ButtonInteractor` is a `CapturingInteractor` for use with button "gadgets" (i.e. buttons that are drawn in the owner''s client area, rather than being windows in their own right). It is not for use with `PushButton` themselves, but simulates the interactive behaviour of buttons. It requires that the owner inform it of the button rectangle (in the parent''s client co-ordinates), and that the parent initiates interaction when it detects that the user has moved the mouse into that rectangle (i.e. the owner must do initial hit-testing) by sending a `#startCaptureOn:` message with the relevant `MouseEvent` as the argument.  Following initiation the `ButtonInteractor` captures the mouse and sets the hot/pressed states as appropriate. As the button state changes the interactor invalidates the button rectangle, allowing the owner to redraw the button in the appropriate state. The owner can query the button state using the `#isHot` and `#isPressed` messages. While the user remains within the button rectangle, `#isHot` is true. While the user holds down the left mouse button `#isPressed` is true. When the user moves out of the button rectangle, if the left button is not down then the mouse capture is released. If the left button is down when the user moves out of the rectangle then the capture is not released, `#isPressed` remains true, but `#isHot` is true. The user can then either release the mouse, in which case the capture is released and `#isPressed` becomes false, or move back into the button rectangle in which case `#isHot` becomes true again. Should the user press and release the left mouse button within the button rectangle (not necessarily in once click action - the cursor can be moved out and back into the button rectangle as long as the button is held down), then the command installed in the `ButtonInteractor` is routed from the parent. This is essentially the same as the interaction behaviour of native windows button controls (and the toolbar buttons), and is natural and intuitive in use.

An example use of a `ButtonInteractor` is with the `SlidingCardTray` pin.

## Instance Variables:
  `buttonRect`			`Rectangle` describing the area occuppied by the button
  `commandDescription`	`CommandDescription` to be fired when the button is clicked.

## Class Variables:
  `PressedMask`		`<integer>` flags mask for recording pressed state.
  `ButtonStateMask`	`<integer>` flags mask for all button state flags.

'!
!ButtonInteractor categoriesForClass!Unclassified! !
!ButtonInteractor methodsFor!

buttonRectangle
	^buttonRect."View desktop mapRectangle: buttonRect to: self presenter view"!

buttonRectangle: aRectangle 
	"Set the button rectangle to be the <Rectangle> argument, expected to be expressed in the
	co-ordinate system of the associated presenter."

	buttonRect := aRectangle "self presenter view mapRectangle: aRectangle to: nil"!

buttonState
	^stateFlags bitAnd: ButtonStateMask!

buttonState: anInteger
	| newState |
	newState := anInteger bitAnd: ButtonStateMask.
	self buttonState = newState ifTrue: [^self].
	stateFlags := (stateFlags maskClear: ButtonStateMask) bitOr: newState.
	self invalidateUIState!

changeHotState: aBoolean 
	self buttonState: (self buttonState mask: HotMask set: aBoolean)!

commandDescription
	^commandDescription!

commandDescription: aCommandDescription 
	commandDescription := aCommandDescription!

fireCommand
	commandDescription ifNotNil: [self view onCommand: commandDescription]!

hitTest: aMouseEvent
	^buttonRect isNil or: [buttonRect containsPoint: aMouseEvent position]!

invalidateUIState
	self view invalidateRect: (self buttonRectangle ifNil: [self view clientRectangle]) erase: false!

isHot: aBoolean 
	self buttonState: (self buttonState mask: HotMask set: aBoolean)!

isPressed
	^stateFlags allMask: PressedMask!

isPressed: aBoolean 
	self buttonState: (self buttonState mask: PressedMask set: aBoolean)!

onLeftButtonPressed: aMouseEvent
	| hot |
	super onLeftButtonPressed: aMouseEvent.
	hot := self hitTest: aMouseEvent.
	hot
		ifTrue: [self buttonState: (aMouseEvent isLButtonDown ifTrue: [ButtonStateMask] ifFalse: [HotMask])]
		ifFalse: [self isHot: false].
	^false!

onLeftButtonReleased: aMouseEvent
	"Private - The left mouse button has been released so if this is the drag button then end the tracking operation."

	| fire |
	super onLeftButtonReleased: aMouseEvent.
	self isHot: (self hitTest: aMouseEvent).
	fire := self buttonState == ButtonStateMask.
	self isPressed: false.
	fire ifTrue: [self fireCommand].
	^false!

onMouseMoved: aMouseEvent 
	"Private - Track the mouse movement to aMouseEvent"

	self isHot: (self hitTest: aMouseEvent).
	self buttonState == 0 ifTrue: [self releaseCapture].
	^false	"Don't perform default processing"!

setPresenter: aPresenter
	"Private - Initialise the receiver's instance variables. Answer the receiver."

	super setPresenter: aPresenter.
	stateFlags := 0!

startCaptureOn: aMouseEvent 
	"Start tracking the mouse on behalf of the <mouseTrackerTarget> argument.
	The mouse is captured and will remain so until the button is released or capture
	is lost for some other reason."

	aMouseEvent message = Win32Constants.WM_MOUSEMOVE 
		ifTrue: [self onMouseMoved: aMouseEvent]
		ifFalse: [self onLeftButtonPressed: aMouseEvent].
	self captureMouse! !
!ButtonInteractor categoriesForMethods!
buttonRectangle!accessing!public! !
buttonRectangle:!accessing!public! !
buttonState!public! !
buttonState:!public! !
changeHotState:!helpers!private! !
commandDescription!accessing!public! !
commandDescription:!accessing!public! !
fireCommand!event handling!private! !
hitTest:!helpers!private! !
invalidateUIState!helpers!private! !
isHot:!public! !
isPressed!public! !
isPressed:!public! !
onLeftButtonPressed:!initializing!private! !
onLeftButtonReleased:!event handling!private! !
onMouseMoved:!event handling!private! !
setPresenter:!accessing!private! !
startCaptureOn:!initializing!public! !
!

!ButtonInteractor class methodsFor!

stbConvertToVersion1: anArray
	"At version 1 the old flags inst var is subsumed by superclass stateFlags inst var."

	^(super stbConvertToVersion1: anArray)
		at: 3 put: (anArray at: 4);
		at: 5 put: nil;
		yourself! !
!ButtonInteractor class categoriesForMethods!
stbConvertToVersion1:!binary filing!private! !
!

