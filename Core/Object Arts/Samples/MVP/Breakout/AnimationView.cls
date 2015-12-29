"Filed out from Dolphin Smalltalk 2002 release 5.00"!

View subclass: #AnimationView
	instanceVariableNames: 'frontSurface backSurface'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AnimationView guid: (GUID fromString: '{EC44CB00-A8FD-11D3-B206-00900002B6ED}')!
AnimationView comment: 'An AnimationView is suitable for double-buffered animation. A drawing can be composed on the back surface and then rapidly flipped to be the visible front surface.

'!
!AnimationView categoriesForClass!Unclassified! !
!AnimationView methodsFor!

backCanvas
	"Answer a <Canvas> onto the back surface"

	^backSurface canvas
		setBkColor: self backcolor;
		yourself
		!

flip
	"Flip the current back surface to the front and paint it. The new backsurface is cleared."

	| tempSurface |
	tempSurface := frontSurface.
	frontSurface := backSurface.
	frontSurface drawOn: self canvas at: 0@0 extent: frontSurface extent.
	backSurface := tempSurface.
	self backCanvas erase.

	!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self setModel: (ListModel with: OrderedCollection new).
	!

initializeSurfacesFor: aPointExtent
	"Private - Initialize the front and back surfaces for a view size of aPointExtent"

	| canvas |

	frontSurface notNil ifTrue: [ frontSurface free ].
	backSurface notNil ifTrue: [ backSurface free ].

	canvas := self canvas.
	frontSurface := Bitmap compatible: canvas extent: aPointExtent.
	backSurface := Bitmap compatible: canvas extent: aPointExtent.
	self backCanvas erase.
	self flip.

!

onCreated: anEvent
	"Handler for view created "

	super onCreated: anEvent.
	self initializeSurfacesFor: self extent.
!

onPaintRequired: aPaintEvent
	"Handler for aPaintEvent. Draws the current front surface to the screen"

	| canvas |
	frontSurface notNil ifTrue: [
		canvas := aPaintEvent canvas.
		frontSurface drawOn: canvas at: 0@0 extent: frontSurface extent ]!

onPositionChanged: aPositionEvent
	"Handle a window position change event (move or resize). In the case of a resize
	we allocate correct size bitmaps for the front and back surfaces"

	aPositionEvent isResize ifTrue: [
		self initializeSurfacesFor: aPositionEvent extent ].
	^super onPositionChanged: aPositionEvent!

render
	"Render the background image"

	| canvas |
	canvas := self backCanvas.
	self model do: [:each | each drawOn: canvas ].
	canvas free.
	! !
!AnimationView categoriesFor: #backCanvas!accessing!public! !
!AnimationView categoriesFor: #flip!operations!public! !
!AnimationView categoriesFor: #initialize!initializing!private! !
!AnimationView categoriesFor: #initializeSurfacesFor:!initializing!private! !
!AnimationView categoriesFor: #onCreated:!event handling!public! !
!AnimationView categoriesFor: #onPaintRequired:!event handling!public! !
!AnimationView categoriesFor: #onPositionChanged:!event handling!public! !
!AnimationView categoriesFor: #render!operations!public! !

