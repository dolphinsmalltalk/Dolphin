"Filed out from Dolphin Smalltalk 7"!

View subclass: #PlimboleView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PlimboleView guid: (GUID fromString: '{9EBCB7D0-ABC8-43C8-855E-BE819F2E55AE}')!
PlimboleView comment: 'This is the View class for the Plimbole Generative Music Sequencer. It''s purpose is to draw the contents of the Plimbole model that it holds withing a window and to keep this view up to date with changes in the model. It is an output only class and does not handle any user input.'!
!PlimboleView categoriesForClass!MVP-Views! !
!PlimboleView methodsFor!

cellExtent
	^(self extent / self model gridExtent) rounded!

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

	| canvas |
	self model notNil 
		ifTrue: 
			[canvas := aPaintEvent canvas.
			self model cells do: [:each | each drawOn: canvas inView: self]]!

onPositionChanged: aPositionEvent 
	"Private - Handle a window position change event (move or resize)."

	aPositionEvent isResize ifTrue: [self invalidate].
	^super onPositionChanged: aPositionEvent! !
!PlimboleView categoriesFor: #cellExtent!private! !
!PlimboleView categoriesFor: #connectModel!models!private! !
!PlimboleView categoriesFor: #onPaintRequired:!event handling!private! !
!PlimboleView categoriesFor: #onPositionChanged:!event handling!private! !

!PlimboleView class methodsFor!

icon
	^PlimbolePresenter icon! !
!PlimboleView class categoriesFor: #icon!public! !

