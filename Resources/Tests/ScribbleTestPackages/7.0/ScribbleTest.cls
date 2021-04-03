"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #ScribbleTest
	instanceVariableNames: 'scribblePresenter'
	classVariableNames: ''
	poolDictionaries: 'ScribbleTestSourceGlobal'
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
	scribblePresenter model: aListModel.!

one
	^Constant1!

string
	^ConstantString! !
!ScribbleTest categoriesFor: #a!public! !
!ScribbleTest categoriesFor: #createComponents!initializing!public! !
!ScribbleTest categoriesFor: #model:!accessing!public! !
!ScribbleTest categoriesFor: #one!public! !
!ScribbleTest categoriesFor: #string!public! !

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_scribble_test_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1140850688 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 544 nil nil nil 7 nil nil nil 544 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Scribble) #resource_Scribble_test nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 754 881 681 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 184 1 0 0 84 1 0 0] 8 #() 754 193 193 nil 27 170 192 848 nil 642 138 144 34 1 706 #createAt:extent: 34 2 754 6143 21 754 881 681 416 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 183 13 0 0 94 1 0 0] 34 1 544 864 nil 27 )! !
!ScribbleTest class categoriesFor: #defaultModel!models!public! !
!ScribbleTest class categoriesFor: #defaultView!public! !
!ScribbleTest class categoriesFor: #resource_Default_scribble_test_view!public!resources-views! !

