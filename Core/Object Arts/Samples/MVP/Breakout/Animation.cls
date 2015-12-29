"Filed out from Dolphin Smalltalk 2002 release 5.00"!

Presenter subclass: #Animation
	instanceVariableNames: 'animationProcess ball leftWall rightWall topWall bottomWall'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Animation guid: (GUID fromString: '{A70ED65D-EF06-4FB1-8BD4-9FCB29BE113D}')!
Animation comment: ''!
!Animation categoriesForClass!Unclassified! !
!Animation methodsFor!

alignWalls
	"Private - Align the walls with the edges of the receiver's view"

	| rect |
	rect := self view rectangle.
	leftWall position: rect leftCenter; extent: leftWall extent x @ rect height.
	rightWall position: rect rightCenter; extent:  rightWall extent x @ rect height.
	topWall position: rect topCenter; extent: rect width @ topWall extent y.
	bottomWall position: rect bottomCenter; extent: rect width @ bottomWall extent y.
!

animate
	"Animate the model the background image"

	self objects do: [:each | each animateOver: (Time fromMilliseconds: self frameTime) in: self ]

	!

ball
	"Private - Answer the value of the receiver's ''ball'' instance variable."

	^ball!

frameTime
	"Answer the number of milliseconds to wait between each frame"

	^50!

initialize
	"Private - Initialize the receiver"

	super initialize.

	ball := BreakOutBall new.
	leftWall := BreakOutWall new.
	rightWall := BreakOutWall new.
	topWall := BreakOutWall new.
	bottomWall := BreakOutWall new.


!

objects
	"Answers the collection of <AnimationObjects> within the receiver"

	^self model!

onPositionChanged: aPositionEvent
	"Handler for a change in position (resize or move) of the receiver's view."

	super onPositionChanged: aPositionEvent.
	aPositionEvent isResize ifTrue: [
		self alignWalls.
		self view render; flip ]
!

onViewClosed
	"Handler for view closed"

	self stopAnimation.
	super onViewClosed.
!

onViewOpened
	"Handler for view opened "

	super onViewOpened.

	self objects 
		add: ball;
		add: leftWall;
		add: rightWall;
		add: topWall;
		add: bottomWall.

	self startAnimation.
!

startAnimation
	"Start the animation process"

	self stopAnimation.
	animationProcess := [ [self animate.
		self view render; flip.
		Processor sleep: self frameTime] repeat ] forkAt: Processor userBackgroundPriority!

stopAnimation
	"Stop the animation process"

	animationProcess notNil ifTrue: [
		animationProcess terminate.
		animationProcess := nil ]! !
!Animation categoriesFor: #alignWalls!private! !
!Animation categoriesFor: #animate!operations!public! !
!Animation categoriesFor: #ball!accessing!private! !
!Animation categoriesFor: #frameTime!constants!public! !
!Animation categoriesFor: #initialize!initializing!private! !
!Animation categoriesFor: #objects!public! !
!Animation categoriesFor: #onPositionChanged:!event handling!public! !
!Animation categoriesFor: #onViewClosed!event handling!public! !
!Animation categoriesFor: #onViewOpened!event handling!public! !
!Animation categoriesFor: #startAnimation!operations!public! !
!Animation categoriesFor: #stopAnimation!operations!public! !

!Animation class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel with: OrderedCollection new! !
!Animation class categoriesFor: #defaultModel!models!public! !

