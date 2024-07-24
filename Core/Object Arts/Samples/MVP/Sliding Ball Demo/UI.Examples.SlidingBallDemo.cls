"Filed out from Dolphin Smalltalk"!

UI.DoubleBufferedView
	subclass: #'UI.Examples.SlidingBallDemo'
	instanceVariableNames: 'start end circle stepProcess'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.SlidingBallDemo guid: (Core.GUID fromString: '{e5ba81f2-42e7-43ee-832f-3a24fadebfee}')!

UI.Examples.SlidingBallDemo comment: 'I would like the example to have two rectangles connected by a line.
One button (called "start") that when presssed will show a small
circle travel along the line from one rectangle to the other. Upon
reaching the second rectangle the circle disappears and a dialog box
appears stating the "The package has arrived"...this would then
display for 5 seconds and then disappear.
At any time after the "start" button has been pressed the user can
pause the circle''s movement by clicking anywhere in the workspace and
start it again from where it was stopped by also clicking anywhere in
the work space (I would consider another button that would be where
the user is required to pause and restart the movement)

SlidingBallDemo new show'!

!UI.Examples.SlidingBallDemo methodsFor!

circleExtent
	^20@20!

circleVelocity
	^6.5!

creationFunction: aRectangle dpi: anInteger
	"Private - Answer a function object that encapsulates a CreateWindow API call to create or recreate a window for the receiver, with the specified position and extent, measured at the specified DPI."

	"The geometry is hard-coded, so create in a DPI unaware context to minimize code changes (and as an example)."

	self assert: [anInteger == 96].
	^CreateInDpiAwarenessContext decorating: (super creationFunction: aRectangle dpi: anInteger)
		withDpiAwareness: DpiAwareness gdiScaled!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^400 @ 400!

defaultWindowStyle
	"Private - Answer the default basic window creation style"

	^##(WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)!

frameRate
	^30!

initialize
	super initialize.
	start := 120@70.
	end := 300@190.
	circle := start.
	self text: 'Sliding Ball Demonstration'.
	creationParent := View desktop
!

isCompleted
	| endBox |
	endBox := Rectangle center: end extent: self rectangleExtent.
	^endBox containsPoint: circle
!

isRunning
	^stepProcess notNil!

onDestroyed
	self stopStepProcess.
	^super onDestroyed!

onLeftButtonDoubleClicked: aMouseEvent
	super onLeftButtonDoubleClicked: aMouseEvent.
	self isRunning 
		ifTrue: [self stopStepProcess]
		ifFalse: [self startStepProcess].
	self invalidate
!

paintCircleOn: aCanvas 
	aCanvas
		pen: (Pen color: Color magenta);
		brush: Color magenta brush;
		ellipse: (Rectangle center: circle rounded extent: self circleExtent)!

paintEndOn: aCanvas 
	| aRectangle aColor |
	aRectangle := Rectangle center: end extent: self rectangleExtent.
	aColor := Color red.
	aCanvas fillRectangle: aRectangle color: aColor!

paintLineOn: aCanvas
	aCanvas
		pen: (Pen blue width: 3);
		moveTo: start;
		lineTo: end
!

paintStartOn: aCanvas 
	aCanvas fillRectangle: (Rectangle center: start extent: self rectangleExtent)
		color: Color green!

rectangleExtent
	^50@50!

render
	"Private - Render the background image"

	| canvas |

	canvas := self canvas.
	canvas erase.
	self paintLineOn: canvas.
	self paintStartOn: canvas.
	self paintEndOn: canvas.
	self paintCircleOn: canvas.
	self isRunning 
		ifFalse: [ self showStartMessageOn: canvas ].

	canvas free. "useful to avoid build up of finalizable garbage"
	super render
!

show
	super show.
	self beActive!

showCompletedMessage
	"It is not straightforward to automatically terminate a standard MessageBox after a timeout so use a MessageBubble instead."

	MessageBubble new
		willFade: true;
		timeout: 5000 milliseconds;
		position: (self mapPointToScreen: circle * self displayMonitor effectiveDpi // 96);
		caption: '';
		font: (Font name: 'Segoe UI' pointSize: 12);
		text: 'The package has arrived';
		open!

showStartMessageOn: aCanvas
	aCanvas 
		font: (Font name: 'Arial' pointSize: 12);
		text: 'Double click to start' at: 100@250!

startStepProcess
	stepProcess := [[Processor sleep: (1000 // self frameRate). self step] repeat ] fork!

step
	self isCompleted
		ifTrue: 
			[self showCompletedMessage.
			self stopStepProcess]
		ifFalse: 
			[| unitStep |
			self invalidate.
			unitStep := (end - start) / 1000.
			circle := circle + (unitStep * self circleVelocity)]!

stepProcess
	"Private - Answer the value of the receiver's ''stepProcess'' instance variable."

	^stepProcess!

stopStepProcess
	self isRunning ifTrue: [
		self stepProcess terminate.
		stepProcess := nil ]! !

!UI.Examples.SlidingBallDemo categoriesForMethods!
circleExtent!constants!public! !
circleVelocity!constants!public! !
creationFunction:dpi:!private!realizing/unrealizing! !
defaultExtent!constants!private! !
defaultWindowStyle!constants!private! !
frameRate!constants!public! !
initialize!event handling!private! !
isCompleted!private!testing! !
isRunning!private!testing! !
onDestroyed!event handling!private! !
onLeftButtonDoubleClicked:!event handling!private! !
paintCircleOn:!displaying!public! !
paintEndOn:!displaying!private! !
paintLineOn:!displaying!private! !
paintStartOn:!displaying!private! !
rectangleExtent!constants!public! !
render!operations!private! !
show!operations!public! !
showCompletedMessage!operations!private! !
showStartMessageOn:!displaying!private! !
startStepProcess!initializing!private! !
step!operations!private! !
stepProcess!accessing!private! !
stopStepProcess!initializing!private! !
!

