"Filed out from Dolphin Smalltalk XP"!

Presenter subclass: #ScribbleTest
	instanceVariableNames: 'scribblePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScribbleTest guid: (GUID fromString: '{FB773B56-8ED4-480A-820B-C1A43F6013EA}')!
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
	^'Default scribble test view'! !
!ScribbleTest class categoriesFor: #defaultModel!models!public! !
!ScribbleTest class categoriesFor: #defaultView!public! !

