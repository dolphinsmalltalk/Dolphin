"Filed out from Dolphin Smalltalk 7"!

View subclass: #LightsOutCellView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LightsOutCellView guid: (GUID fromString: '{DDBF090C-0742-4E46-AAA6-4408D36250F1}')!
LightsOutCellView comment: ''!
!LightsOutCellView categoriesForClass!Unclassified! !
!LightsOutCellView methodsFor!

colorWhenOn
	 ^(RGB red: 237 green: 242 blue: 13)!

connectModel	
	self model when: #valueChanged send: #invalidate to: self!

onLeftButtonReleased: aMouseEvent
	self presenter trigger: #cellAction!

onPaintRequired: aPaintEvent 
	self model value 
		ifTrue: 
			[| cellRect canvas |
			cellRect := self clientRectangle insetBy: 5.
			canvas := aPaintEvent canvas.
			canvas fillRectangle: cellRect color: self colorWhenOn]! !
!LightsOutCellView categoriesFor: #colorWhenOn!private! !
!LightsOutCellView categoriesFor: #connectModel!private! !
!LightsOutCellView categoriesFor: #onLeftButtonReleased:!private! !
!LightsOutCellView categoriesFor: #onPaintRequired:!private! !

!LightsOutCellView class methodsFor!

defaultModel
	^false asValue!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.LightsOutCellView)  98 12 0 0 98 2 8 1409286144 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 32 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #equality 32 196934 1 ##(Smalltalk.RGB)  15682047 0 5 0 0 0 416 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  3839 21 754 201 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 227 7 0 0 110 0 0 0] 98 0 754 193 193 0 27 )! !
!LightsOutCellView class categoriesFor: #defaultModel!public! !
!LightsOutCellView class categoriesFor: #resource_Default_view!public!resources-views! !

