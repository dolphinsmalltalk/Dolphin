"Filed out from Dolphin Smalltalk X6"!

CapturingInteractor subclass: #ButtonInteractor
	instanceVariableNames: 'buttonRect flags commandDescription'
	classVariableNames: 'HotMask PressedMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ButtonInteractor guid: (GUID fromString: '{28D6227F-7753-4595-B98A-7B363D34E90F}')!
ButtonInteractor comment: 'ButtonInteractor is a <CapturingInteractor> for use with button "gadgets" (i.e. buttons that are drawn in the owner''s client area, rather than being windows in their own right). It is not for use with <PushButton> themselves, but simulates the interactive behaviour of buttons. It requires that the owner inform it of the button rectangle (in the parent''s client co-ordinates), and that the parent initiates interaction when it detects that the user has moved the mouse into that rectangle (i.e. the owner must do initial hit-testing) by sending a #startCaptureOn: message with the relevant <MouseEvent> as the argument.  Following initiation the ButtonInteractor captures the mouse and sets the hot/pressed states as appropriate. As the button state changes the interactor invalidates the button rectangle, allowing the owner to redraw the button in the appropriate state. The owner can query the button state using the #isHot and #isPressed messages. While the user remains within the button rectangle, #isHot is true. While the user holds down the left mouse button #isPressed is true. When the user moves out of the button rectangle, if the left button is not down then the mouse capture is released. If the left button is down when the user moves out of the rectangle then the capture is not released, #isPressed remains true, but #isHot is true. The user can then either release the mouse, in which case the capture is released and #isPressed becomes false, or move back into the button rectangle in which case #isHot becomes true again. Should the user press and release the left mouse button within the button rectangle (not necessarily in once click action - the cursor can be moved out and back into the button rectangle as long as the button is held down), then the command installed in the ButtonInteractor is routed from the parent. This is essentially the same as the interaction behaviour of native windows button controls (and the toolbar buttons), and is natural and intuitive in use.

Instance Variables:
	buttonRect			<Rectangle>
	flags					<integer>
	commandDescription	<CommandDescription>

Class Variables:
	PressedMask			<integer>
	HotMask				<integer>

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
	^flags bitAnd: self buttonStateMask!

buttonState: anInteger 
	| mask |
	self buttonState = anInteger ifTrue: [^self].
	mask := self buttonStateMask.
	flags := (flags maskClear: mask) maskSet: anInteger.
	self invalidateUIState!

buttonStateMask
	^HotMask | PressedMask!

commandDescription
	^commandDescription!

commandDescription: aCommandDescription 
	commandDescription := aCommandDescription!

fireCommand
	self view onCommand: commandDescription!

hitTest: aMouseEvent 
	^buttonRect containsPoint: aMouseEvent position!

initialize
	"Private - Initialize the receiver"

	super initialize.
	flags := 0.!

invalidateUIState
	self view invalidateRect: self buttonRectangle erase: false!

isHot
	^flags allMask: HotMask!

isHot: aBoolean 
	self buttonState: (self buttonState mask: HotMask set: aBoolean)!

isPressed
	^flags allMask: PressedMask!

isPressed: aBoolean 
	self buttonState: (self buttonState mask: PressedMask set: aBoolean)!

onLeftButtonPressed: aMouseEvent 
	| hot |
	hot := self hitTest: aMouseEvent.
	hot 
		ifTrue: 
			[self buttonState: (aMouseEvent isLButtonDown ifTrue: [HotMask | PressedMask] ifFalse: [HotMask])]
		ifFalse: [self isHot: false].
	^false!

onLeftButtonReleased: aMouseEvent 
	"Private - The left mouse button has been released so if this is the drag button then end the tracking operation."

	| fire |
	self isHot: (self hitTest: aMouseEvent).
	fire := self buttonState == self buttonStateMask.
	self isPressed: false.
	fire ifTrue: [self fireCommand].
	^false!

onMouseMoved: aMouseEvent 
	"Private - Track the mouse movement to aMouseEvent"

	self isHot: (self hitTest: aMouseEvent).
	(self isHot not and: [self isPressed not]) ifTrue: [self releaseCapture].
	^false	"Don't perform default processing"!

setPresenter: aPresenter 
	"Private - Initialise the receiver's instance variables. Answer the receiver."

	super setPresenter: aPresenter.
	flags := 0!

startCaptureOn: aMouseEvent 
	"Start tracking the mouse on behalf of the <mouseTrackerTarget> argument.
	The mouse is captured and will remain so until the button is released or capture
	is lost for some other reason."

	aMouseEvent message = WM_MOUSEMOVE 
		ifTrue: [self onMouseMoved: aMouseEvent]
		ifFalse: [self onLeftButtonPressed: aMouseEvent].
	self captureMouse! !
!ButtonInteractor categoriesFor: #buttonRectangle!accessing!public! !
!ButtonInteractor categoriesFor: #buttonRectangle:!accessing!public! !
!ButtonInteractor categoriesFor: #buttonState!accessing!private! !
!ButtonInteractor categoriesFor: #buttonState:!accessing!private! !
!ButtonInteractor categoriesFor: #buttonStateMask!constants!private! !
!ButtonInteractor categoriesFor: #commandDescription!accessing!public! !
!ButtonInteractor categoriesFor: #commandDescription:!accessing!public! !
!ButtonInteractor categoriesFor: #fireCommand!event handling!private! !
!ButtonInteractor categoriesFor: #hitTest:!helpers!private! !
!ButtonInteractor categoriesFor: #initialize!initializing!private! !
!ButtonInteractor categoriesFor: #invalidateUIState!helpers!private! !
!ButtonInteractor categoriesFor: #isHot!public!testing! !
!ButtonInteractor categoriesFor: #isHot:!accessing!public! !
!ButtonInteractor categoriesFor: #isPressed!public!testing! !
!ButtonInteractor categoriesFor: #isPressed:!accessing!public! !
!ButtonInteractor categoriesFor: #onLeftButtonPressed:!initializing!private! !
!ButtonInteractor categoriesFor: #onLeftButtonReleased:!event handling!private! !
!ButtonInteractor categoriesFor: #onMouseMoved:!event handling!private! !
!ButtonInteractor categoriesFor: #setPresenter:!accessing!private! !
!ButtonInteractor categoriesFor: #startCaptureOn:!initializing!public! !

!ButtonInteractor class methodsFor!

initialize
	HotMask := 1.
	PressedMask := 2.! !
!ButtonInteractor class categoriesFor: #initialize!public! !

