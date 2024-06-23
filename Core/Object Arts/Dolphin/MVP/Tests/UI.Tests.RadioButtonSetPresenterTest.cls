"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.RadioButtonSetPresenterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.RadioButtonSetPresenterTest guid: (Core.GUID fromString: '{0b5f0660-ff27-42a8-a388-e35b1b76b3e4}')!

UI.Tests.RadioButtonSetPresenterTest comment: ''!

!UI.Tests.RadioButtonSetPresenterTest methodsFor!

classToTest
	^RadioButtonSetPresenter!

initializePresenter
	presenter := RadioButtonSetPresenter showOn: #option1!

selectedButton
	| selected |
	selected := self selectedButtons.
	self assert: selected size<=1.
	selected size =0 ifTrue: [^nil].
	^selected first name asSymbol!

selectedButtons
	^presenter radioButtons select: [:each | each value]!

testDisableEnableAll
	presenter radioButtons do: [:each | self assert: each isEnabled].
	presenter disableAll.
	presenter radioButtons do: [:each | self assert: each isEnabled not].
	presenter enableAll.
	presenter radioButtons do: [:each | self assert: each isEnabled]!

testEvents
	self 
		should: [presenter value: #option2]
		triggerAllOf: #(#valueChanged "#radioButtonSelection:")
		against: presenter.
	self 
		shouldnt: [presenter value: #option2]
		triggerAnyOf: #(#valueChanged "#radioButtonSelection:")
		against: presenter.
	self 
		should: [presenter value: #option1]
		triggerAllOf: #(#valueChanged "#radioButtonSelection:")
		against: presenter.
	self 
		shouldnt: [presenter value: #option1]
		triggerAnyOf: #(#valueChanged "#radioButtonSelection:")
		against: presenter.
	self 
		should: [presenter value: nil]
		trigger: #valueChanged
"		butNot: #radioButtonSelection:"
		against: presenter.
	self 
		shouldnt: [presenter value: nil]
		triggerAnyOf: #(#valueChanged "#radioButtonSelection:")
		against: presenter!

testInitialValue
	self assert: presenter value equals: #option1.
	self assert: self selectedButton equals: #option1!

testValueSelection
	presenter value: #option2.
	self assert: presenter value equals: #option2.
	self assert: self selectedButton equals: #option2.
	presenter value: #option1.
	self assert: presenter value equals: #option1.
	self assert: self selectedButton equals: #option1.
	presenter value: nil.
	self assertIsNil: presenter value.
	self assertIsNil: self selectedButton! !

!UI.Tests.RadioButtonSetPresenterTest categoriesForMethods!
classToTest!constants!private! !
initializePresenter!public!running! !
selectedButton!private!unit tests! !
selectedButtons!private!unit tests! !
testDisableEnableAll!public!unit tests! !
testEvents!public!unit tests! !
testInitialValue!public!unit tests! !
testValueSelection!public!unit tests! !
!

