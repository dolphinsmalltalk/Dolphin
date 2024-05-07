"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #EvaluationConverterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EvaluationConverterTest guid: (GUID fromString: '{e4302154-42e4-4d4f-acbd-3e3aa6f78982}')!

EvaluationConverterTest comment: ''!

!EvaluationConverterTest categoriesForClass!Unclassified! !

!EvaluationConverterTest methodsFor!

checkWith: string
	| eval2 text eval |
	eval := self converter leftToRight: string.
	self denyIsNil: eval.
	text := self converter rightToLeft: eval.
	eval2 := self converter leftToRight: text.
	self assert: eval equals: eval2!

converter
	^EvaluationConverter new!

testWithArrays
	self checkWith: 'Array with: 4 with: 5 with: 6'!

testWithDates
	self checkWith: 'Date newDay: 12 monthIndex: 8 year: 1958'.
	self checkWith: 'Date today'!

testWithTimes
	self checkWith: 'Time fromString: ''11:55:56'''! !

!EvaluationConverterTest categoriesForMethods!
checkWith:!helpers!private! !
converter!private! !
testWithArrays!public!unit tests! !
testWithDates!public!unit tests! !
testWithTimes!public!unit tests! !
!

