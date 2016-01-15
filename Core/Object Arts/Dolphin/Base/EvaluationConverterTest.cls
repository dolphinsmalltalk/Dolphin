"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #EvaluationConverterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EvaluationConverterTest guid: (GUID fromString: '{E4302154-42E4-4D4F-ACBD-3E3AA6F78982}')!
EvaluationConverterTest comment: ''!
!EvaluationConverterTest categoriesForClass!Unclassified! !
!EvaluationConverterTest methodsFor!

checkWith: string 
	| eval2 text eval |
	eval := self converter leftToRight: string.
	self assert: eval notNil.
	text := self converter rightToLeft: eval.
	eval2 := self converter leftToRight: text.
	self assert: eval = eval2!

converter
	^EvaluationConverter new!

testWithArrays
	self checkWith: 'Array with: 4 with: 5 with: 6'!

testWithDates
	self checkWith: 'Date fromString: ''12 August 1958'''.
	self checkWith: 'Date today'!

testWithTimes
	self checkWith: 'Time fromString: ''11:55:56'''! !
!EvaluationConverterTest categoriesFor: #checkWith:!private! !
!EvaluationConverterTest categoriesFor: #converter!private! !
!EvaluationConverterTest categoriesFor: #testWithArrays!public! !
!EvaluationConverterTest categoriesFor: #testWithDates!public! !
!EvaluationConverterTest categoriesFor: #testWithTimes!public! !

