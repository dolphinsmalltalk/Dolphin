"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ValueConverterTest
	instanceVariableNames: 'converter value startTime newTime changed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ValueConverterTest guid: (GUID fromString: '{FD184D86-16E0-422A-A2C7-0084D567972C}')!
ValueConverterTest comment: 'Tests the ValueConverter class.'!
!ValueConverterTest categoriesForClass!Unclassified! !
!ValueConverterTest methodsFor!

onValueChanged
	changed := true!

setUp
	startTime := Time fromString: '01:01:01'.
	newTime := Time fromString: '23:59:59'.
	value := ValueHolder new.
	value value: startTime.
	converter := ValueConverter subject: value typeConverter: TimeToText new.
	converter when: #valueChanged send: #onValueChanged to: self.
	changed := false.
	!

testValue
	self assert: value value = startTime.
	self assert: converter value = startTime displayString.
	self should: [value value: newTime] trigger: #valueChanged against: converter.
	self assert: converter value = newTime displayString.!

testValueColon
	self assert: value value = startTime.
	changed := false.
	"The underlying ValueModel should also trigger a change event"
	self 
		should: [converter value: newTime displayString]
		trigger: #valueChanged
		against: value.
	self assert: changed.
	self assert: converter value = newTime displayString.
	self assert: value value = newTime! !
!ValueConverterTest categoriesFor: #onValueChanged!helpers!public! !
!ValueConverterTest categoriesFor: #setUp!public!Running! !
!ValueConverterTest categoriesFor: #testValue!public!unit tests! !
!ValueConverterTest categoriesFor: #testValueColon!public!unit tests! !

