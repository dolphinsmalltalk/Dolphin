"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.FormatterTest'
	instanceVariableNames: 'settings'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.FormatterTest guid: (Core.GUID fromString: '{9edc9b30-32ca-4970-8068-dd559bb18608}')!
Refactory.Browser.Tests.FormatterTest comment: ''!
!Refactory.Browser.Tests.FormatterTest categoriesForClass!Browser-Testing! !
!Refactory.Browser.Tests.FormatterTest methodsFor!

runMethodTestFor: method
	| result tree |
	tree := RBParser parseMethod: method.
	result := RBFormatter1 new format: tree.
	self assert: result equals: method!

runTestForPairs: pairs
	pairs do: 
			[:each |
			| result tree |
			tree := RBParser parseExpression: each first.
			result := RBFormatter1 format: tree.
			self assert: result equals: each last]!

setUp
	settings := Dictionary new.
	{RBConfigurableFormatter. RBSourceFormatter}
		do: [:each | each classPool keysAndValuesDo: [:key :value | settings at: key put: value]].
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

smokeTestAllMethodsOfHierarchy: baseClass
	baseClass allMethodsDo: 
			[:each |
			| tree |
			tree := each parseTree.
			self assert: tree equals: (RBParser parseMethod: (RBFormatter1 format: tree))]!

smokeTestForMethodsOfClasses: aCollectionOfClasses
	aCollectionOfClasses do: 
			[:class |
			class selectors do: 
					[:sel |
					| tree |
					tree := class parseTreeFor: sel.
					self assert: tree equals: (RBParser parseMethod: (RBFormatter1 format: tree))]]!

tearDown
	settings 
		keysAndValuesDo: [:key :value | (RBFormatter1 bindingFor: key) value: value]!

testAllSettingsInitialized
	settings keysAndValuesDo: [:eachKey :eachValue | self denyIsNil: eachValue]!

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
	self assert: result equals: method!

testBinaryMessage
	self 
		runTestForPairs: #(#('x + y') #('x + (y + z)') #('self foo + self bar') #('x + y + z') #('(x == y) -> (a ++ b)') #('(foo , bar) baz'))!

testBlock
	self 
		runTestForPairs: #(#('[]') #('[x := 3 + 4]') #('[x foo.
b := y + z]') #('[| x y |
x := y]') #('[:x :y | x := y]') #('[:x :y | 
x := y.
y := z]')).
	RBFormatter1 lineUpBlockBrackets: true.
	self 
		runTestForPairs: #(#('[x := 3 + 4]') #('[
x foo.
b := y + z
]') #('[
| x y |
x := y
]') #('[:x :y | x := y]') #('[
:x :y | 
x := y.
y := z
]')).!

testBlockArguments
	RBFormatter1 indentString: (String with: Character tab).
	RBFormatter1 numberOfArgumentsForMultiLine: 2.
	self
		runTestForPairs: #(#('self
	at: 1
	put:
		[self foo: 2.
		z := q]') #('self
	at: 1
	put: [self foo]'))!

testCascadeKeywordMessages
	RBFormatter1 indentString: '	'.
	RBFormatter1 numberOfArgumentsForMultiLine: 2.
	self 
		runTestForPairs: #(#('self foo;
	at: 3
		put: 4;
	baz;
	yourself') #('self bar;
	with: 1
		with: 2
		with: 3'))!

testCascadeMessages
	RBFormatter1 indentString: '	'.
	self 
		runTestForPairs: #(#('self foo;
	bar;
	baz;
	yourself') #('self at: 1;
	bar;
	+ 3') #('(self at: 1) bar;
	foo') #('self at: 1 bar;
	baz')).
	RBFormatter1 newLineBeforeFirstCascade: true.
	self runTestForPairs: #(#('self
	foo;
	bar;
	baz;
	yourself'))!

testFormatVariable
	#rbFix.	"Remove namespaced static variable test, which is VW specific"
	self runTestForPairs: #(#('foo') #('x'))	" #('Core.Object'))"!

testIndent
	| result tree method |
	method := 'test
	^self size'.
	tree := RBParser parseMethod: method.
	RBFormatter1 indentString: (String with: Character tab).
	result := RBFormatter1 new format: tree.
	self assert: result equals: method!

testKeywordMessage
	self 
		runTestForPairs: #(#('self at: x') #('self at: x put: y') #('self at: x + y put: z with: self foo') #('self at: (self at: foo)') #('(self at: foo) at: foo') #('(self at: foo) + z') #('(self at: foo) size'))!

testLiterals
	self runTestForPairs: #(#('3') #('#foo') #('#(1 #b ''c'' #[12] #())') #('3.0s + 3.0 = 6.0') #('$\x20'))!

testLongSelectors
	RBFormatter1 numberOfArgumentsForMultiLine: 2.
	RBFormatter1 indentString: '	'.
	self runMethodTestFor: 'test
	self
		with: #zlogar
		with: 3'.
	RBFormatter1 numberOfArgumentsForMultiLine: 0.
	self runMethodTestFor: 'test
	self
		new'.
	RBFormatter1 newLineBeforeFirstKeyword: false.
	self runMethodTestFor: 'test
	self with: #zlogar
		with: 3'.
	RBFormatter1 indentsForKeywords: 2.
	self runMethodTestFor: 'test
	self with: #zlogar
			with: 3'.!

testMethod
	RBFormatter1 methodSignatureOnMultipleLines: true.
	#(#('test
^self size') #('+ anInteger
^self + anInteger') #('at: anInteger
^5') #('at: anInteger
| x |
^x + 1') #('foo
<primitive: 1>
^self error') #('foo: x
bar: y
baz: z
^self'))
		do: 
			[:each |
			| result tree |
			tree := RBParser parseMethod: each first.
			result := RBFormatter1 format: tree.
			self assert: result equals: each last]!

testMethodComment
	RBFormatter1 indentString: (String with: Character tab).
	RBFormatter1 newLinesAfterMethodComment: 2.
	#(#('test
	"Test Comment"

	^self size') #('test
	self foo.	"Comment 1"
	self bar	"Comment 2"'))
		do: 
			[:each |
			| result tree |
			tree := RBParser parseMethod: each first.
			result := RBFormatter1 format: tree.
			self assert: result equals: each last]!

testNoNewlineCascadeMessages
	RBFormatter1 newLineAfterCascade: false.
	self 
		runTestForPairs: #(#('self foo; bar; baz; yourself') #('self at: 1; bar; + 3') #('(self at: 1) bar; foo') #('self at: 1 bar; baz'))!

testPeriodTerminators
	RBConfigurableFormatter indentString: (String with: Character tab).
	RBConfigurableFormatter numberOfArgumentsForMultiLine: 2.
	RBConfigurableFormatter periodsAsTerminators: true.
	self
		runTestForPairs: #(#('self foo.
self
	at: 1
	put:
		[self foo: 2.
		z := q.].') #('self yourself.
^self
	at: 1
	put: [self foo.].')).
	RBConfigurableFormatter
		periodsAsTerminators: false;
		periodsAtEndOfBlock: true.
	self
		runTestForPairs: #(#('self foo.
self
	at: 1
	put:
		[self foo: 2.
		z := q.]') #('self yourself.
^self
	at: 1
	put: [self foo.]')).
	RBConfigurableFormatter
		periodsAsTerminators: false;
		periodsAtEndOfMethod: true.
	self
		runTestForPairs: #(#('self foo.
self
	at: 1
	put:
		[self foo: 2.
		z := q].') #('self yourself.
^self
	at: 1
	put: [self foo].'))!

testReturn
	self runTestForPairs: #(('^5'))!

testSequence
	self 
		runTestForPairs: #(#('self foo.
self at: 1.
x := 3 + 4') #('| x y |
x := y + 3.
^x'))!

testSmokeTest
	self smokeTestAllMethodsOfHierarchy: Refactoring!

testUnaryMessage
	self runTestForPairs: #(#('self halt') #('self halt halt'))! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #runMethodTestFor:!private! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #runTestForPairs:!private! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #setUp!public!running! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #smokeTestAllMethodsOfHierarchy:!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #smokeTestForMethodsOfClasses:!helpers!private! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #tearDown!public!running! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testAllSettingsInitialized!public!unit tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testAssignments!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testBeginningNewLines!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testBinaryMessage!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testBlock!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testBlockArguments!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testCascadeKeywordMessages!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testCascadeMessages!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testFormatVariable!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testIndent!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testKeywordMessage!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testLiterals!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testLongSelectors!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testMethod!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testMethodComment!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testNoNewlineCascadeMessages!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testPeriodTerminators!public! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testReturn!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testSequence!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testSmokeTest!public!tests! !
!Refactory.Browser.Tests.FormatterTest categoriesFor: #testUnaryMessage!public!tests! !

