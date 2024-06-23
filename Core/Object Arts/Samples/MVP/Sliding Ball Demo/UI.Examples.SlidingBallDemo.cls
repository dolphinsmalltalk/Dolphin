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

defaultExtent
	^400@400!

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

showCompletedMessage
	"It is not straightforward to automatically terminate a standard MessgaeBox so for 
	expendiency we use a custom Splash screen"

	| bm |
	bm := DIBSection width: 200 height: 100.
	(bm canvas)
		forecolor: Color white;
		backgroundMode: TRANSPARENT;
		text: 'The package has arrived' at: 20 @ 40.
	(Splash new)
		bitmap: bm;
		showTimed: (Delay forSeconds: 5)!

showStartMessageOn: aCanvas
	aCanvas 
		font: (Font name: 'Arial' pointSize: 12);
		text: 'Double click to start' at: 100@250!

startStepProcess
	stepProcess := [[Processor sleep: (1000 // self frameRate). self step] repeat ] fork!

step
	| unitStep |
	unitStep := (end-start) / 1000.
	circle := circle + (unitStep*self circleVelocity).
	self invalidate.
	self isCompleted ifTrue: [
		self showCompletedMessage.
		self stopStepProcess ].
!

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
defaultExtent!constants!public! !
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
showCompletedMessage!operations!private! !
showStartMessageOn:!displaying!private! !
startStepProcess!initializing!private! !
step!operations!private! !
stepProcess!accessing!private! !
stopStepProcess!initializing!private! !
!

