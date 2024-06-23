"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.ValueConverterTest'
	instanceVariableNames: 'converter value startTime newTime changed'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.ValueConverterTest guid: (Core.GUID fromString: '{fd184d86-16e0-422a-a2c7-0084d567972c}')!

UI.Tests.ValueConverterTest comment: 'Tests the ValueConverter class.'!

!UI.Tests.ValueConverterTest methodsFor!

onValueChanged
	changed := true!

setUp
	super setUp.
	startTime := Time fromString: '01:01:01'.
	newTime := Time fromString: '23:59:59'.
	value := ValueHolder new.
	value value: startTime.
	converter := ValueConverter subject: value typeConverter: TimeToText new.
	converter
		when: #valueChanged
		send: #onValueChanged
		to: self.
	changed := false!

testValue
	self assert: value value equals: startTime.
	self assert: converter value equals: startTime displayString.
	self
		should: [value value: newTime]
		trigger: #valueChanged
		against: converter.
	self assert: converter value equals: newTime displayString!

testValueColon
	self assert: value value equals: startTime.
	changed := false.
	"The underlying ValueModel should also trigger a change event"
	self
		should: [converter value: newTime displayString]
		trigger: #valueChanged
		against: value.
	self assert: changed.
	self assert: converter value equals: newTime displayString.
	self assert: value value equals: newTime! !

!UI.Tests.ValueConverterTest categoriesForMethods!
onValueChanged!helpers!public! !
setUp!public!Running! !
testValue!public!unit tests! !
testValueColon!public!unit tests! !
!

