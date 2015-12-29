"Filed out from Dolphin Smalltalk 2002 release 5.00"!

Object subclass: #AnimationObject
	instanceVariableNames: 'position velocity acceleration'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AnimationObject guid: (GUID fromString: '{046EE9BE-47C5-4D84-BBAC-7FBEB88F550D}')!
AnimationObject comment: ''!
!AnimationObject categoriesForClass!Unclassified! !
!AnimationObject methodsFor!

acceleration
	"Answer the value of the receiver's ''acceleration'' instance variable."

	^acceleration!

acceleration: anObject
	"Set the value of the receiver's ''acceleration'' instance variable to the argument, anObject."

	acceleration := anObject!

adjustCollisionWith: anAnimationObject in: anAnimation from: aLastPositionPoint
	"Adjust a collision of the receiver with anAnimationObject to move it back to
	a point where it is just colliding with the object"

	| p1 p2 dif chop hit |

	"If the object is just touching then our job is done"
	(self isJustCollidingWith: anAnimationObject) ifTrue: [^self].

	"Otherwise binary chop and recurse"
	p1 := aLastPositionPoint.
	p2 := self position.
	dif := p2-p1.
	(dif r < 0.01) ifTrue: [^self ].
	chop := p1 + (dif / 2).
	
	self position: chop.
	(self isCollidingWith: anAnimationObject) 
		ifTrue: [ chop := p2 ]
		ifFalse: [ chop := p1 ].

	self collisionWith: anAnimationObject in: anAnimation from: chop.

	

	


!

animateOver: aTime in: anAnimation
	"Animates the receiver over aTime period"

	| time lastPosition |
	time := aTime asMilliseconds / 1000.
	self velocity: (self velocity+(self acceleration*time)).
	lastPosition := self position.
	self position: (lastPosition+(self velocity*time)).
	self collisionDetectIn: anAnimation from: lastPosition!

collisionDetectIn: anAnimation from: aLastPositionPoint
	"Handle any possible collision of the receiver with any of the other objects
	in anAnimation"

	anAnimation objects do: [:each | (each ~= self and: [self isCollidingWith: each]) ifTrue: [
		self collisionWith: each in: anAnimation from: aLastPositionPoint ]].
!

collisionWith: anAnimationObject in: anAnimation from: aLastPositionPoint
	"Handle a collision of the receiver with anAnimationObject" 

	Sound bell.
	self adjustCollisionWith: anAnimationObject in: anAnimation from: aLastPositionPoint.
	self velocity: self velocity negated.
	"self velocity: 0@0"


	

	


!

drawOn: aCanvas
	"Draws the receiver on aCanvas"

	self subclassResponsibility!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self 
		position: 0@0; 
		velocity: 0@0; 
		acceleration: 0@0!

isCollidingWith: anAnimationObject
	"Answer true if the receiver is in collision with anAnimationObject"

	^self rectangle intersects: anAnimationObject rectangle

	!

isJustCollidingWith: anAnimationObject
	"Answer true if the receiver is in just collision with anAnimationObject"

	^((self isCollidingWith: anAnimationObject) not) and: [
		(self rectangle intersect: anAnimationObject rectangle) area < self justCollisionVolume]

	!

justCollisionVolume
	"Answer the area of overlap that indicates that the receiver is just touching another object"

	^50!

position
	"Answer the value of the receiver's ''position'' instance variable."

	^position!

position: anObject
	"Set the value of the receiver's ''position'' instance variable to the argument, anObject."

	position := anObject!

rectangle
	"Answer the bounding rectangle of the receiver"
	
	^self subclassResponsibility!

velocity
	"Answer the value of the receiver's ''velocity'' instance variable."

	^velocity!

velocity: anObject
	"Set the value of the receiver's ''velocity'' instance variable to the argument, anObject."

	velocity := anObject! !
!AnimationObject categoriesFor: #acceleration!accessing!public! !
!AnimationObject categoriesFor: #acceleration:!accessing!public! !
!AnimationObject categoriesFor: #adjustCollisionWith:in:from:!operations!public! !
!AnimationObject categoriesFor: #animateOver:in:!operations!public! !
!AnimationObject categoriesFor: #collisionDetectIn:from:!operations!public! !
!AnimationObject categoriesFor: #collisionWith:in:from:!operations!public! !
!AnimationObject categoriesFor: #drawOn:!drawing!operations!public! !
!AnimationObject categoriesFor: #initialize!private! !
!AnimationObject categoriesFor: #isCollidingWith:!public!testing! !
!AnimationObject categoriesFor: #isJustCollidingWith:!public!testing! !
!AnimationObject categoriesFor: #justCollisionVolume!constants!public! !
!AnimationObject categoriesFor: #position!accessing!public! !
!AnimationObject categoriesFor: #position:!accessing!public! !
!AnimationObject categoriesFor: #rectangle!accessing!public! !
!AnimationObject categoriesFor: #velocity!accessing!public! !
!AnimationObject categoriesFor: #velocity:!accessing!public! !

!AnimationObject class methodsFor!

new
	"Answer a new, initialized, instance of the receiver."

	^super new initialize! !
!AnimationObject class categoriesFor: #new!instance creation!public! !

