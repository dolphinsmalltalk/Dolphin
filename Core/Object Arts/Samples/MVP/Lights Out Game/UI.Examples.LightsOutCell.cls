"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #LightsOutCell
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LightsOutCell guid: (GUID fromString: '{09C1F382-0D93-462C-8872-297C9F4B641A}')!
LightsOutCell comment: ''!
!LightsOutCell categoriesForClass!Unclassified! !
!LightsOutCell methodsFor!

toggle
	^self model value: self model value not! !
!LightsOutCell categoriesFor: #toggle!public! !

!LightsOutCell class methodsFor!

defaultModel
	^true asValue!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.LightsOutCellView)  98 12 0 0 98 2 8 1409286144 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 32 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #equality 32 0 0 5 0 0 0 416 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  3839 21 722 201 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 227 7 0 0 110 0 0 0] 98 0 722 193 193 0 27 )! !
!LightsOutCell class categoriesFor: #defaultModel!public! !
!LightsOutCell class categoriesFor: #resource_Default_view!public!resources-views! !

