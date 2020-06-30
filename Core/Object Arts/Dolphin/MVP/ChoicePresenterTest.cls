"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #ChoicePresenterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChoicePresenterTest guid: (GUID fromString: '{f39cda5e-17b7-48ee-ae77-57c882174716}')!
ChoicePresenterTest comment: ''!
!ChoicePresenterTest categoriesForClass!Unclassified! !
!ChoicePresenterTest methodsFor!

classToTest
	^ChoicePresenter!

testChangeChoices
	presenter choices: #(0 1 2 3).
	self deny: presenter view hasSelection.
	self assertIsNil: presenter value.
	presenter view selectionByIndex: 2.
	self assert: presenter view hasSelection.
	self assert: presenter value equals: 1.

	"Selection should be maintained if choice is still in the list"
	presenter choices: #(1 2 4).
	self assert: presenter view hasSelection.
	self assert: presenter value equals: 1.

	"Selection lost if choice removed"
	presenter choices: #(2 3 4).
	self deny: presenter view hasSelection.
	self assertIsNil: presenter value!

testChangeMultiChoices
	presenter view isMultiSelect: true.
	presenter choices: #(0 1 2 3).
	self deny: presenter view hasSelection.
	self assert: presenter value isEmpty.
	presenter value: #(1 3).
	self assert: presenter view hasSelection.
	self assert: presenter value equals: #(1 3).

	"Selection should be maintained if choice is still in the list"
	presenter choices: #(1 2 4).
	self assert: presenter view hasSelection.
	self assert: presenter value equals: #(1).

	"Selection lost if choice removed"
	presenter choices: #(2 3 4).
	self deny: presenter view hasSelection.
	self assert: presenter value isEmpty!

testNilChoice
	presenter
		nilChoice: 0;
		choices: #(0 1 2 3).
	self assert: presenter view hasSelection.
	self assertIsNil: presenter value.
	presenter view selectionByIndex: 2.
	self assert: presenter view hasSelection.
	self assert: presenter value equals: 1.
	presenter view selectionByIndex: 1.
	self assert: presenter view hasSelection.
	self assertIsNil: presenter value.
	presenter value: 2.
	self assert: presenter view hasSelection.
	self assert: presenter view selectionByIndex equals: 3.
	self assert: presenter value equals: 2!

testNilMultiChoice
	presenter view isMultiSelect: true.
	presenter
		nilChoice: #(0);
		choices: #(0 1 2 3).
	self assert: presenter view hasSelection.
	self assert: presenter value isEmpty.
	presenter view selectionByIndex: 2.
	self assert: presenter view hasSelection.
	self assert: presenter value equals: #(1).
	presenter view selectionByIndex: 1.
	self assert: presenter view hasSelection.
	self assert: presenter value isEmpty.
	presenter value: #(2 3).
	self assert: presenter view hasSelection.
	self assert: presenter view selectionsByIndex equals: #(3 4).
	self assert: presenter value equals: #(2 3)! !
!ChoicePresenterTest categoriesFor: #classToTest!helpers!private! !
!ChoicePresenterTest categoriesFor: #testChangeChoices!public!unit tests! !
!ChoicePresenterTest categoriesFor: #testChangeMultiChoices!public!unit tests! !
!ChoicePresenterTest categoriesFor: #testNilChoice!public!unit tests! !
!ChoicePresenterTest categoriesFor: #testNilMultiChoice!public!unit tests! !

