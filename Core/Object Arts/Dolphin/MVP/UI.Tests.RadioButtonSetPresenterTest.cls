"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'UI.Tests.RadioButtonSetPresenterTest'
	instanceVariableNames: 'radioSet'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.RadioButtonSetPresenterTest guid: (Core.GUID fromString: '{0b5f0660-ff27-42a8-a388-e35b1b76b3e4}')!
UI.Tests.RadioButtonSetPresenterTest comment: ''!
!UI.Tests.RadioButtonSetPresenterTest methodsFor!

selectedButton
	| selected |
	selected := self selectedButtons.
	self assert: selected size<=1.
	selected size =0 ifTrue: [^nil].
	^selected first name asSymbol!

selectedButtons
	^radioSet radioButtons select: [:each | each value]!

setUp
	super setUp.
	radioSet := RadioButtonSetPresenter showOn: #option1!

tearDown
	radioSet topShell destroy.
	radioSet := nil!

testDisableEnableAll
	radioSet radioButtons do: [:each | self assert: each isEnabled].
	radioSet disableAll.
	radioSet radioButtons do: [:each | self assert: each isEnabled not].
	radioSet enableAll.
	radioSet radioButtons do: [:each | self assert: each isEnabled]!

testEvents
	self 
		should: [radioSet value: #option2]
		triggerAllOf: #(#valueChanged "#radioButtonSelection:")
		against: radioSet.
	self 
		shouldnt: [radioSet value: #option2]
		triggerAnyOf: #(#valueChanged "#radioButtonSelection:")
		against: radioSet.
	self 
		should: [radioSet value: #option1]
		triggerAllOf: #(#valueChanged "#radioButtonSelection:")
		against: radioSet.
	self 
		shouldnt: [radioSet value: #option1]
		triggerAnyOf: #(#valueChanged "#radioButtonSelection:")
		against: radioSet.
	self 
		should: [radioSet value: nil]
		trigger: #valueChanged
"		butNot: #radioButtonSelection:"
		against: radioSet.
	self 
		shouldnt: [radioSet value: nil]
		triggerAnyOf: #(#valueChanged "#radioButtonSelection:")
		against: radioSet!

testInitialValue
	self assert: radioSet value equals: #option1.
	self assert: self selectedButton equals: #option1!

testValueSelection
	radioSet value: #option2.
	self assert: radioSet value equals: #option2.
	self assert: self selectedButton equals: #option2.
	radioSet value: #option1.
	self assert: radioSet value equals: #option1.
	self assert: self selectedButton equals: #option1.
	radioSet value: nil.
	self assertIsNil: radioSet value.
	self assertIsNil: self selectedButton! !
!UI.Tests.RadioButtonSetPresenterTest categoriesForMethods!
selectedButton!private!unit tests! !
selectedButtons!private!unit tests! !
setUp!public!running! !
tearDown!public!running! !
testDisableEnableAll!public!unit tests! !
testEvents!public!unit tests! !
testInitialValue!public!unit tests! !
testValueSelection!public!unit tests! !
!

