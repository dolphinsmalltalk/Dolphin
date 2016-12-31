"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #RadioButtonSetPresenterTest
	instanceVariableNames: 'radioSet'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RadioButtonSetPresenterTest guid: (GUID fromString: '{0B5F0660-FF27-42A8-A388-E35B1B76B3E4}')!
RadioButtonSetPresenterTest comment: ''!
!RadioButtonSetPresenterTest categoriesForClass!Unclassified! !
!RadioButtonSetPresenterTest methodsFor!

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
	self assert: radioSet value = #option1.
	self assert: self selectedButton = #option1!

testValueSelection
	radioSet value: #option2.
	self assert: radioSet value = #option2.
	self assert: self selectedButton = #option2.
	radioSet value: #option1.
	self assert: radioSet value = #option1.
	self assert: self selectedButton = #option1.
	radioSet value: nil.
	self assert: radioSet value isNil.
	self assert: self selectedButton isNil! !
!RadioButtonSetPresenterTest categoriesFor: #selectedButton!private!unit tests! !
!RadioButtonSetPresenterTest categoriesFor: #selectedButtons!private!unit tests! !
!RadioButtonSetPresenterTest categoriesFor: #setUp!public!running! !
!RadioButtonSetPresenterTest categoriesFor: #tearDown!public!running! !
!RadioButtonSetPresenterTest categoriesFor: #testDisableEnableAll!public!unit tests! !
!RadioButtonSetPresenterTest categoriesFor: #testEvents!public!unit tests! !
!RadioButtonSetPresenterTest categoriesFor: #testInitialValue!public!unit tests! !
!RadioButtonSetPresenterTest categoriesFor: #testValueSelection!public!unit tests! !

