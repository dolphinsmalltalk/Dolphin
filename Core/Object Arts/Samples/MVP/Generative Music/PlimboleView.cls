"Filed out from Dolphin Smalltalk"!

View subclass: #PlimboleView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PlimboleView guid: (GUID fromString: '{9ebcb7d0-abc8-43c8-855e-be819f2e55ae}')!

PlimboleView comment: 'This is the View class for the Plimbole Generative Music Sequencer. It''s purpose is to draw the contents of the Plimbole model that it holds withing a window and to keep this view up to date with changes in the model. It is an output only class and does not handle any user input.'!

!PlimboleView categoriesForClass!MVP-Views! !

!PlimboleView methodsFor!

arrowPen
	| extent arrowCap |
	extent := self cellExtent.
	arrowCap := GdiplusAdjustableArrowCap
				height: extent y / 16.0
				width: extent x / 9.0
				isFilled: false.
	"arrowCap strokeJoin: Gdiplus.LineJoinRound."
	^(GdiplusPen color: Color white width: 3.0 * self dpi / USER_DEFAULT_SCREEN_DPI)
		customEndCap: arrowCap;
		yourself!

brushes
	^presenter brushes!

cellExtent
	^self extent / self model gridExtent!

connectModel
	"Private - Connect the receiver to its model, wiring events, etc."

	self model notNil 
		ifTrue: 
			[self model 
				when: #updated
				send: #invalidate
				to: self]!

onPaintRequired: aPaintEvent
	"Private - Handler for paint event. Show the scribble"

	| canvas graphics cellExtent pen |
	self model ifNil: [^self].
	canvas := aPaintEvent canvas.
	graphics := GdiplusGraphics fromCanvas: canvas.
	graphics smoothingMode: GdiplusConstants.SmoothingModeHighQuality.
	cellExtent := self cellExtent.
	pen := self arrowPen.
	self model cells do: 
			[:each |
			each
				drawOn: graphics
				inView: self
				extent: cellExtent
				pen: pen].
	pen free.
	graphics free!

onPositionChanged: aPositionEvent 
	"Private - Handle a window position change event (move or resize)."

	aPositionEvent isResize ifTrue: [self invalidate].
	^super onPositionChanged: aPositionEvent!

palette
	^presenter palette! !

!PlimboleView categoriesForMethods!
arrowPen!accessing!private! !
brushes!accessing!private! !
cellExtent!accessing!private! !
connectModel!models!private! !
onPaintRequired:!event handling!private! !
onPositionChanged:!event handling!private! !
palette!accessing!private! !
!

!PlimboleView class methodsFor!

icon
	^PlimbolePresenter icon! !

!PlimboleView class categoriesForMethods!
icon!public! !
!

