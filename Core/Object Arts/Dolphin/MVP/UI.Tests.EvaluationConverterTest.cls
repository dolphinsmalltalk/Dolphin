"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'UI.Tests.EvaluationConverterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.EvaluationConverterTest guid: (Core.GUID fromString: '{e4302154-42e4-4d4f-acbd-3e3aa6f78982}')!
UI.Tests.EvaluationConverterTest comment: ''!
!UI.Tests.EvaluationConverterTest categoriesForClass!Unclassified! !
!UI.Tests.EvaluationConverterTest methodsFor!

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
!UI.Tests.EvaluationConverterTest categoriesFor: #checkWith:!private! !
!UI.Tests.EvaluationConverterTest categoriesFor: #converter!private! !
!UI.Tests.EvaluationConverterTest categoriesFor: #testWithArrays!public! !
!UI.Tests.EvaluationConverterTest categoriesFor: #testWithDates!public! !
!UI.Tests.EvaluationConverterTest categoriesFor: #testWithTimes!public! !

