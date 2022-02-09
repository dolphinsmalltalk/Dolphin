"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.ParseTreeSearcherTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ParseTreeSearcherTest guid: (Core.GUID fromString: '{5f577bcc-c4c0-4d78-9e71-bea473079bfe}')!
Refactory.Browser.Tests.ParseTreeSearcherTest comment: ''!
!Refactory.Browser.Tests.ParseTreeSearcherTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ParseTreeSearcherTest methodsFor!

testDynamicArrayStatements
	"match in context for arraynodes wrongly matched all array statements against the last variable, if all variables are pattern-list-variables"

	| searcher dict |
	searcher := ParseTreeSearcher new.
	searcher matches: '{`@first. `@second. `@third.}' do: [:aNode :answer | dict := searcher context].
	dict := searcher executeTree: (self parseExpression: '{ (1@2) . Color red . 3}').
	self assert: (dict at: (RBPatternVariableNode named: '`@first')) formattedCode equals: '1 @ 2'.
	self assert: (dict at: (RBPatternVariableNode named: '`@second')) formattedCode equals: 'Color red'.
	self assert: (dict at: (RBPatternVariableNode named: '`@third')) formattedCode equals: '3'!

testDynamicArrayWithStatementListPattern
	"pattern with statementlist in a dynamic array, to match all dynamic array expressions"

	| searcher dict |
	searcher := ParseTreeSearcher new.
	searcher matches: '{`.@stmts.}' do: [:aNode :answer | dict := searcher context].
	dict := searcher executeTree: (self parseExpression: '{ (1@2) . Color red . 3}').
	self assert: (dict at: (RBPatternVariableNode named: '`.@stmts')) size equals: 3!

testMatchMessageList
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matchesMethod: 'at: `object `put: `o1 ``@rcv `put: 1' do: [:aNode :answer | true].
	self assert: (searcher executeTree: (Parser parseMethod: 'at: a put: b self foo put: 1')
				initialAnswer: false)!

testSearching
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv `at: ``@arg1 `at: ``@arg2' do: [:aNode :answer | answer + 1].
	self
		assert: (searcher executeTree: (Parser
						parseExpression: 'self at: 1 at: 3; at: 1 put: 32; at: 2; foo; at: 1 at: 1 at: 2')
				initialAnswer: 0)
		equals: 1!

testSearchingComposedSelector
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg `sel: ``@arg1' do: [:aNode :answer | answer + 1].

	"the result is 2 because the parse tree searcher only finds at:x: messages like at:put: and at:ifAbsent:"
	self
		assert: (searcher executeTree: (self
						parseExpression: 'self at: 1 put: 2; at: 2 ifAbsent: []; ifAbsent: 2 at: 1; at: 4; foo')
				initialAnswer: 0)
		equals: 2!

testSearchingComposedSelector2
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg' do: [:aNode :answer | answer + 1].
	"the result is 1 because the parse tree searcher only finds at: messages like at: and not ifAbsent: at:"
	self assert: (searcher executeTree: (self parseExpression: 'self ifAbsent: 2 at: 1; at: 4; foo')
				initialAnswer: 0)
		equals: 1!

testSelectorPartialMatch
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg `sel: ``@arg1' do: [:aNode :answer | answer + 1].
	self
		assert: (searcher executeTree: (self
						parseExpression: 'self at: 1 put: 2; at: 2 ifAbsent: []; ifAbsent: 2 at: 1; at: 4; foo')
				initialAnswer: 0)
		equals: 2! !
!Refactory.Browser.Tests.ParseTreeSearcherTest categoriesForMethods!
testDynamicArrayStatements!public! !
testDynamicArrayWithStatementListPattern!public! !
testMatchMessageList!public! !
testSearching!public! !
testSearchingComposedSelector!public! !
testSearchingComposedSelector2!public! !
testSelectorPartialMatch!public! !
!

