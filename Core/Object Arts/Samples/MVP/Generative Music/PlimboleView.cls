"Filed out from Dolphin Smalltalk 7"!

View subclass: #PlimboleView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PlimboleView guid: (GUID fromString: '{9EBCB7D0-ABC8-43C8-855E-BE819F2E55AE}')!
PlimboleView comment: ''!
!PlimboleView categoriesForClass!MVP-Views! !
!PlimboleView methodsFor!

connectModel
	"Connect the receiver to its model, wiring events, etc."

	self model 
		when: #listChanged send: #refreshContents to: self;
		when: #item:addedAtIndex: send: #onItem:addedAtIndex: to: self;
		when: #item:removedAtIndex: send: #refreshContents to: self;
		when: #item:updatedAtIndex: send: #refreshContents to: self.!

onItem: aPlimboleCell addedAtIndex: anIntegerIndex 
	"Event received when anInkStroke has been added to the receiver's
	model at anIntegerIndex. In this case we just need to draw the stroke rather
	than the whole model"

	aPlimboleCell drawOn: self canvas inView: self!

onPaintRequired: aPaintEvent 
	"Private - Handler for paint event. Show the scribble"

	| canvas |
	canvas := aPaintEvent canvas.
	self model do: [:each | each drawOn: canvas inView: self]!

onPositionChanged: aPositionEvent 
	"Private - Handle a window position change event (move or resize)."

	aPositionEvent isResize ifTrue: [self invalidate].
	^super onPositionChanged: aPositionEvent! !
!PlimboleView categoriesFor: #connectModel!models!public! !
!PlimboleView categoriesFor: #onItem:addedAtIndex:!event handling!public! !
!PlimboleView categoriesFor: #onPaintRequired:!event handling!private! !
!PlimboleView categoriesFor: #onPositionChanged:!event handling!private! !

!PlimboleView class methodsFor!

defaultModel
	^ListModel new!

icon
	^Plimbole icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.PlimboleView)  98 12 0 0 98 2 8 1140850688 1 416 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 770 201 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 100 0 0 0] 98 0 770 193 193 0 27 )! !
!PlimboleView class categoriesFor: #defaultModel!public! !
!PlimboleView class categoriesFor: #icon!public! !
!PlimboleView class categoriesFor: #resource_Default_view!public!resources-views! !

