"Filed out from Dolphin Smalltalk"!

UI.DoubleBufferedView
	subclass: #'UI.AnimatedImageView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.AnimatedImageView guid: (Core.GUID fromString: '{63997d2b-abca-455e-917b-8cf248b11e63}')!
UI.AnimatedImageView comment: ''!
!UI.AnimatedImageView methodsFor!

connectModel
	"Connect the receiver to its model, wiring events, etc.
	ValueConvertingControlViews expect to be connected to a model that obeys the
	ValueModel protocol; i.e. it must generate a #value event when the value it is wrapping 
	is replaced."

	self model ifNotNil: 
			[:m | 
			m 
				when: #valueChanged
				send: #onModelChanged
				to: self]!

initialize	
	super initialize.!

render
	"Private - Render the background image"

	| canvas image |
	canvas := self canvas.
	canvas backcolor: self backcolor; erase.
	image := self value.
	image notNil ifTrue: [image drawOn: canvas].
	canvas free.	"useful to avoid build up of finalizable garbage"
	super render!

value
	"Answer the receiver's model value"

	^self model value!

value: anObject
	"Set the receiver's model value to anObject"

	self model value: anObject! !
!UI.AnimatedImageView categoriesForMethods!
connectModel!models!public! !
initialize!private! !
render!operations!private! !
value!accessing!public! !
value:!accessing!public! !
!

!UI.AnimatedImageView class methodsFor!

defaultModel
	^nil asValue!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.AnimatedImageView} 34 14 nil nil 34 2 8 1409286144 1 416 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 917510 #{Graphics.Color} #white nil 5 nil nil nil 416 nil true 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 674 247 201 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 122 24 0 0 110 0 0 0] 8 #() 674 193 193 nil 27)! !
!UI.AnimatedImageView class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

