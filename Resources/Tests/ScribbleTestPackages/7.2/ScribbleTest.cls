"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #ScribbleTest
	instanceVariableNames: 'scribblePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScribbleTest guid: (GUID fromString: '{fb773b56-8ed4-480a-820b-c1a43f6013ea}')!
ScribbleTest comment: ''!
!ScribbleTest categoriesForClass!No category! !
!ScribbleTest methodsFor!

a
	^'A'!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents. 
	scribblePresenter := self add: Scribble new name: 'scribble'.
!

model: aListModel
	"Connects the receiver to aListModel. Since the receiver has the same model as the
	sketch pad (Scribble) component that it holds we pass this down to it."

	super model: aListModel.
	scribblePresenter model: aListModel.! !
!ScribbleTest categoriesFor: #a!public! !
!ScribbleTest categoriesFor: #createComponents!initializing!public! !
!ScribbleTest categoriesFor: #model:!accessing!public! !

!ScribbleTest class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel with: OrderedCollection new!

defaultView
	^'Default scribble test view'!

resource_Default_scribble_test_view
	"Answer the literal data from which the 'Default scribble test view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self name name: 'Default scribble test view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ContainerView)  98 15 0 0 98 2 8 1140850688 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 416 788230 ##(BorderLayout)  1 1 0 0 0 0 410 8 ##(ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 576 0 0 0 7 0 0 0 576 1638918 ##(ResourceIdentifier)  8 ##(Scribble)  8 #resource_Scribble_test 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  1 1 850 881 681 576 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 184 1 0 0 84 1 0 0] 98 0 850 193 193 0 27 234 256 944 0 722 202 208 98 1 786 816 98 2 850 20001 20001 850 881 681 416 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 200 40 0 0 100 40 0 0] 98 1 576 960 0 27 )! !
!ScribbleTest class categoriesFor: #defaultModel!models!public! !
!ScribbleTest class categoriesFor: #defaultView!public! !
!ScribbleTest class categoriesFor: #resource_Default_scribble_test_view!public!resources-views! !

