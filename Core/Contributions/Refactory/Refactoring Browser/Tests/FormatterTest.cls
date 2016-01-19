"Filed out from Dolphin Smalltalk 7"!

RefactoringBrowserTest subclass: #FormatterTest
	instanceVariableNames: 'settings'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FormatterTest guid: (GUID fromString: '{9EDC9B30-32CA-4970-8068-DD559BB18608}')!
FormatterTest comment: ''!
!FormatterTest categoriesForClass!Browser-Testing! !
!FormatterTest methodsFor!

runMethodTestFor: method 
	| result tree |
	tree := RBParser parseMethod: method.
	result := RBFormatter1 new format: tree.
	self assert: result = method!

runTestForPairs: pairs 
	pairs do: 
			[:each | 
			| result tree |
			tree := RBParser parseExpression: each first.
			result := RBFormatter1 format: tree.
			self assert: result = each last]!

setUp
	settings := Dictionary new.
	RBConfigurableFormatter classPool 
		keysAndValuesDo: [:key :value | settings at: key put: value].
	RBConfigurableFormatter indentString: ''.
	RBConfigurableFormatter newLinesAfterMethodPattern: 1.
	RBConfigurableFormatter newLinesAfterMethodComment: 1.
	RBConfigurableFormatter newLinesAfterTemporaries: 1.
	RBConfigurableFormatter numberOfArgumentsForMultiLine: 12.
	RBConfigurableFormatter newLineAfterCascade: true.
	RBConfigurableFormatter newLineBeforeFirstKeyword: true.
	RBConfigurableFormatter indentsForKeywords: 1.
	RBConfigurableFormatter newLineBeforeFirstCascade: false.
	RBConfigurableFormatter useTraditionalBinaryPrecedenceForParentheses: true.
	RBConfigurableFormatter maxLineLength: 10000.
	RBConfigurableFormatter periodsAsTerminators: false!

tearDown
	settings 
		keysAndValuesDo: [:key :value | (RBFormatter1 bindingFor: key) value: value]!

testAllSettingsInitialized
	settings keysAndValuesDo: [:eachKey :eachValue | self assert: eachValue notNil]!

testAssignments
	self runTestForPairs: #(#('x := 3') #('x := y := z') #('(x := y) size'))!

testBeginningNewLines
	| result tree method |
	method := 'test\\| x |\\\^self size' withCRs.
	tree := RBParser parseMethod: method.
	RBFormatter1 newLinesAfterMethodPattern: 2.
	RBFormatter1 newLinesAfterTemporaries: 3.
	RBFormatter1 indentString: ''.
	result := RBFormatter1 new format: tree.
	self assert: result = method!

testBinaryMessage
	self 
		runTestForPairs: #(#('x + y') #('x + (y + z)') #('self foo + self bar') #('x + y + z') #('(x == y) -> (a ++ b)') #('(foo , bar) baz'))!

testFormatVariable
	#rbFix.	"Remove namespaced static variable test, which is VW specific"
	self runTestForPairs: #(#('foo') #('x'))	" #('Core.Object'))"!

testKeywordMessage
	self 
		runTestForPairs: #(#('self at: x') #('self at: x put: y') #('self at: x + y put: z with: self foo') #('self at: (self at: foo)') #('(self at: foo) at: foo') #('(self at: foo) + z') #('(self at: foo) size'))!

testLiterals
	self 
		runTestForPairs: #(#('3') #('#foo') #('#(1 #b ''c'' #[12] #())') #('3.0s + 3.0 = 6.0') #('$ '))!

testNoNewlineCascadeMessages
	RBFormatter1 newLineAfterCascade: false.
	self 
		runTestForPairs: #(#('self foo; bar; baz; yourself') #('self at: 1; bar; + 3') #('(self at: 1) bar; foo') #('self at: 1 bar; baz'))!

testReturn
	self runTestForPairs: #(('^5'))!

testSmokeTest
	Refactoring withAllSubclasses do: 
			[:class | 
			class selectors do: 
					[:sel | 
					| tree |
					tree := class parseTreeFor: sel.
					self assert: tree = (RBParser parseMethod: (RBFormatter1 format: tree))]]!

testUnaryMessage
	self runTestForPairs: #(#('self halt') #('self halt halt'))! !
!FormatterTest categoriesFor: #runMethodTestFor:!private! !
!FormatterTest categoriesFor: #runTestForPairs:!private! !
!FormatterTest categoriesFor: #setUp!public!running! !
!FormatterTest categoriesFor: #tearDown!public!running! !
!FormatterTest categoriesFor: #testAllSettingsInitialized!public!unit tests! !
!FormatterTest categoriesFor: #testAssignments!public!tests! !
!FormatterTest categoriesFor: #testBeginningNewLines!public!tests! !
!FormatterTest categoriesFor: #testBinaryMessage!public!tests! !
!FormatterTest categoriesFor: #testFormatVariable!public!tests! !
!FormatterTest categoriesFor: #testKeywordMessage!public!tests! !
!FormatterTest categoriesFor: #testLiterals!public!tests! !
!FormatterTest categoriesFor: #testNoNewlineCascadeMessages!public!tests! !
!FormatterTest categoriesFor: #testReturn!public!tests! !
!FormatterTest categoriesFor: #testSmokeTest!public!tests! !
!FormatterTest categoriesFor: #testUnaryMessage!public!tests! !

