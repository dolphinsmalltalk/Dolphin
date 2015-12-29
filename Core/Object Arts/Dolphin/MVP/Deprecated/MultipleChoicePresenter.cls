"Filed out from Dolphin Smalltalk XP"!

ChoicePresenter subclass: #MultipleChoicePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultipleChoicePresenter guid: (GUID fromString: '{9E0E464E-134C-42D9-8536-CC4D364A9DAA}')!
MultipleChoicePresenter comment: ''!
!MultipleChoicePresenter categoriesForClass!Unclassified! !
!MultipleChoicePresenter methodsFor!

initialize
	"Private - Initialize the receiver"

	super initialize.
	nilChoice := #()!

onChoiceChanged
	"Handler for a choice change in the receiver's view"

	| choices |
	choices := view selections.
	self value: (choices isEmpty ifTrue: [nilChoice] ifFalse: [choices])!

updateChoice
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the list view's selection."

	| choices |
	choices := self value.
	self view selections: (choices = nilChoice ifTrue: [#()] ifFalse: [choices])! !
!MultipleChoicePresenter categoriesFor: #initialize!private! !
!MultipleChoicePresenter categoriesFor: #onChoiceChanged!public! !
!MultipleChoicePresenter categoriesFor: #updateChoice!private! !

!MultipleChoicePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^#() asValue comparisonPolicy: SearchPolicy equality! !
!MultipleChoicePresenter class categoriesFor: #defaultModel!public! !

