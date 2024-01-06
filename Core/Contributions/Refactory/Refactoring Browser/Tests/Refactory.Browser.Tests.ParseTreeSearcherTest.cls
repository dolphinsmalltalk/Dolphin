"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.ParseTreeSearcherTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ParseTreeSearcherTest guid: (Core.GUID fromString: '{5f577bcc-c4c0-4d78-9e71-bea473079bfe}')!
Refactory.Browser.Tests.ParseTreeSearcherTest comment: ''!
!Refactory.Browser.Tests.ParseTreeSearcherTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ParseTreeSearcherTest methodsFor!

assertCodeForSymbolAt: aSymbol in: myContextDictionary equals: expectedCode
	^self assert: (myContextDictionary at: aSymbol asSymbol) equals: expectedCode!

assertCodeForVariableNodeNamed: aString in: aDictionary equals: codeString
	self assert: (aDictionary at: (RBPatternVariableNode named: aString)) formattedCode
		equals: codeString!

testAListDoesNotMatchComposedMessagesBecauseOfTreeMismatch
	"Using `@arg, we looking for multiple lists in one match pattern at the same time.
	Lists can be any receiver or args."

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `@arg equals: true'
		do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self
				parseExpression: 'self assert: reader storedSettings first realValue equals: false.')!

testAListDoesNotMatchComposedMessagesBecauseOfTreeMismatch2
	"Using `@arg, we looking for multiple lists in one match pattern at the same time.
	Lists can be any receiver or args."

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `@arg equals: true'
		do: [:aNode :answer | self fail: 'Unexpected match'].

	"so in below example, there is no match with the suggested pattern. That is why, dict is nil "
	searcher executeTree: (self parseExpression: 'self assert: token isLiteralToken.')!

testAListMatchesComposedMessages
	"Using `@arg, we looking for multiple lists in one match pattern at the same time.
	Lists can be any receiver or args."

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `@arg equals: true'
		do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self
				parseExpression: 'self assert: reader storedSettings first realValue equals: true.').
	self
		assertCodeForVariableNodeNamed: '`@receiver'
		in: contextDictionary
		equals: 'self'.
	self
		assertCodeForVariableNodeNamed: '`@arg'
		in: contextDictionary
		equals: 'reader storedSettings first realValue'!

testDoesNotMultipleKeywordsWithoutAList
	"this test shows that to match a multi keyword message, you need to have a list (@) in the pattern"

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv `sel: 2' do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self parseExpression: 'self newRequestTo: 2 with: 55')!

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

testMatchesArgumentToTestImplicitAddArgument
	"Here we can see the difference between matchesArgument: and matches:.
	 We can see that the matchContextArgList is filled with the all a arguments in the code by calling matchesArgument:do: instead of matches:do:
	 matches:do: is matching all a that exists in our tree except arguments "

	| tree search block blockArg matchContextList matchContextArgList |
	matchContextList := OrderedCollection new.
	matchContextArgList := OrderedCollection new.
	search := ParseTreeSearcher new.
	tree := self
				parseMethod: '+ a
									| a b |
									self
										ifTrue: [a]
										ifFalse: [b := c].
									a := b.
									[:b :c :a | a foo: a; foo1: a; foo2: a foo: b].
									{a. b}.
									^a'.
	block := [:aNode :answer | matchContextList add: aNode].
	blockArg := [:aNode :answer | matchContextArgList add: aNode].
	search
		matches: 'a' do: block;
		matchesArgument: 'a' do: blockArg.
	search executeTree: tree!

testMatchesDoDoesNotMatchAllElementsOfDynamicArray
	"Matches in context for arraynodes wrongly matched all array statements against the last variable, if all variables are pattern-list-variables"

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '{`@first. `@second. `@third.}'
		do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self parseExpression: '1 + 2').
	searcher matches: '{`@first. `@second. `@third.}'
		do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self parseExpression: '{ (1@2) . Color red . 3 . 4}')!

testMatchesDoIsMatchingAllElementsOfDynamicArray
	"Matches in context for arraynodes wrongly matched all array statements against the last variable, if all variables are pattern-list-variables"

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '{`@first. `@second. `@third.}' do: [:aNode :answer | searcher context].
	contextDictionary := searcher executeTree: (self parseExpression: '{ 1@2. Color red. 3}').
	self deny: contextDictionary isNil.
	"since the pattern matched, the block was executed and the value of the dictionary changed"
	self
		assertCodeForVariableNodeNamed: '`@first'
		in: contextDictionary
		equals: '1 @ 2'.
	self
		assertCodeForVariableNodeNamed: '`@second'
		in: contextDictionary
		equals: 'Color red'.
	self
		assertCodeForVariableNodeNamed: '`@third'
		in: contextDictionary
		equals: '3'!

testMatchesDoIsMatchingPatternedExpressionWithLiterals
	""

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `@arg equals: true'
		do: [:aNode :answer | contextDictionary := searcher context].
	searcher
		executeTree: (self parseExpression: 'self
					assert: each isReadOnlyObject equals: true.').
	self
		assertCodeForVariableNodeNamed: '`@receiver'
		in: contextDictionary
		equals: 'self'.
	self
		assertCodeForVariableNodeNamed: '`@arg'
		in: contextDictionary
		equals: 'each isReadOnlyObject'!

testMatchesDoisMatchingStatementsInDynamicArray
	"pattern with statementlist in a dynamic array, to match all dynamic array expressions"

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '{`.@stmts.}' do: [:aNode :answer | searcher context].
	contextDictionary := searcher executeTree: (self parseExpression: '{ (1@2) . Color red . 3 }').
	self assert: (contextDictionary at: (RBPatternVariableNode named: '`.@stmts')) size equals: 3!

testMatchesDoIsNotMatchingPatternedExpressionWithLiterals
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `@arg equals: true'
		do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher
		executeTree: (self parseExpression: 'self
					assert: each isReadOnlyObject equals: false.')!

testMatchingAnyNodeWithoutConstrainingThePattern
	"A receiver list can be: a simple receiver like self, or a complex receiver like (self newRequestTo: aString)."

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: '(self + 1) put').

	"this is because `@rcv means match a tree"
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: '(self + 1) put'!

testMatchingReceiver
	"A receiver list can be: a simple receiver like self, or a complex receiver like (self newRequestTo: aString). So here we are looking for any receiver followed by put."

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv put' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: 'self put').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'self'!

testMatchingReceiver2
	"A receiver list can be: a simple receiver like self, or a complex receiver like (self newRequestTo: aString). So here we are looking for any receiver followed by put."

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv put' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: '(self + 1) put').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: '(self + 1)'!

testMatchingReceiverAndMultiKeywordSelector
	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv `@sel: 2' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: 'self newRequestTo: 2 with: 55').
	self
		assertCodeForSymbolAt: '`@sel:'
		in: contextDictionary
		equals: 'newRequestTo:with:'!

testMatchingReceiverAndMultiKeywordSelector2
	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: 'self `@sel: `@args' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: 'self newRequestTo: 2 with: 55').
	self
		assertCodeForSymbolAt: '`@sel:'
		in: contextDictionary
		equals: 'newRequestTo:with:'.

	"The below is not working: something wrong with the assertion type"
	self
		assert: ((contextDictionary at: (RBPatternVariableNode named: '`@args'))
				collect: [:each | each value]) asArray
		equals: #(2 55)!

testMatchingReceiverAndSelector
	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv `sel: 2' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: 'self newRequestTo: 2').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'self'.
	self assert: (contextDictionary at: '`sel:' asSymbol) equals: 'newRequestTo:'!

testMatchingReceiverAndSelector2
	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '(`@rcv `sel: 2) put' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: '(self newRequestTo: 2) put').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'self'.
	self
		assertCodeForSymbolAt: '`sel:'
		in: contextDictionary
		equals: 'newRequestTo:'!

testMatchingReceiverComposite
	"A receiver list can be: a simple receiver like self, or a complex receiver like (self newRequestTo: aString). So here we are looking for any receiver followed by put."

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv put' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: '(self newRequestTo: aString) put').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: '(self newRequestTo: aString)'.

	"Ex 2: "
	searcher executeTree: (self parseExpression: 'self httpClient put').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'self httpClient'!

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

testSearchingComposedMessage
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg' do: [:aNode :answer | answer + 1].
	"the match is recursing into receiver and arguments."
	self assert: (searcher executeTree: (self parseExpression: '(self at: 1) at: (self at: 4); foo')
				initialAnswer: 0)
		equals: 3!

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

testSearchingComposedSelectorWithCascade
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg `sel: ``@arg1' do: [:aNode :answer | answer + 1].

	"the result is 2 because the parse tree searcher only finds at:x: messages
	like at:put: and at:ifAbsent:"
	self
		assert: (searcher executeTree: (self
						parseExpression: 'self
								at: 1 put: 2;
								at: 2 ifAbsent: [];
								ifAbsent: 2 at: 1;
								at: 4; foo')
				initialAnswer: 0)
		equals: 2!

testSearchingComposedSelectorwithinCascade
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg' do: [:aNode :answer | answer + 1].
	"the result is 1 because the parse tree searcher only finds at: messages like at: and not ifAbsent: at:"
	self
		assert: (searcher executeTree: (self parseExpression: 'self ifAbsent: 2 at: 1; at: 4; at: 5; foo')
				initialAnswer: 0)
		equals: 2!

testSearchingComposedSelectorWithListIsNotWorking
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg `@sel: ``@arg1' do: [:aNode :answer | answer + 1].

	"the result is 2 because the parse tree searcher only finds at:x: messages
	like at:put: and at:ifAbsent:"
	self assert: (searcher executeTree: (self parseExpression: 'self
								at: 1') initialAnswer: 0)
		equals: 0!

testSearchingKeywordsPartWithOptionInTheMiddleIsBogus
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: 'self at: 3 `@sel2: `@arg2 put: self ' do: [:aNode :answer | answer + 1].

	"the result is 2 because the parse tree searcher only finds at:x: messages
	like at:put: and at:ifAbsent:"
	self assert: (searcher executeTree: (self parseExpression: 'self  at: 3 foo: 1 put: self')
				initialAnswer: 0)
		equals: 1.
	self assert: (searcher executeTree: (self parseExpression: 'self  at: 3 foo: 1 bar: 3 put: self')
				initialAnswer: 0)
		equals: 0
	"The previous assert should pass with 1 sel should be foo:bar:"!

testSearchingOptionKeywordsPartComposedSelector
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv `@sel: ``@arg' do: [:aNode :answer | answer + 1].

	"the result is 2 because the parse tree searcher only finds at:x: messages
	like at:put: and at:ifAbsent:"
	self assert: (searcher executeTree: (self parseExpression: 'self  at: 1') initialAnswer: 0)
		equals: 1.
	self assert: (searcher executeTree: (self parseExpression: 'self  at: 1 put: 2') initialAnswer: 0)
		equals: 1!

testSearchingOptionKeywordsPartComposedSelector2
	"This test appears to be based on an assumption that selector lists can consist of a list patterns intermingled with keywords, but this doesn't really work. In fact what happens is that the initial selector and argument lists are matching the whole expression in the first example, and give a partial match in the 2nd. Everything after `@arg in the search is effectively ignored. "

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv `@sel: `@arg at: 3 `@sel2: `@arg2'
		do: 
			[:aNode :answer |
			contextDictionary := searcher context.
			answer + 1].

	"the result is 2 because the parse tree searcher only finds at:x: messages
	like at:put: and at:ifAbsent:"
	self
		assert: (searcher executeTree: (self parseExpression: 'self foo: 1 at: 3 put: 5') initialAnswer: 0)
		equals: 1.
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'self'.
	"Note that the selector match in the context dictionary has the string name as a key rather than a pattern variable, and the value is a Symbol."
	self assert: (contextDictionary at: '`@sel:') equals: #foo:at:put:.
	self
		assert: ((contextDictionary at: (RBPatternVariableNode named: '`@arg')) collect: [:each | each value])
				asArray
		equals: #(1 3 5).
	self assert: (searcher executeTree: (self parseExpression: 'self  foo: 1 put: 2') initialAnswer: 0)
		equals: 1.
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'self'.
	self assert: (contextDictionary at: '`@sel:') equals: #foo:put:.
	self
		assert: ((contextDictionary at: (RBPatternVariableNode named: '`@arg')) collect: [:each | each value])
				asArray
		equals: #(1 2)!

testSearchListComplex
	"Here we are looking for multiple lists in one match pattern at the same time.
	Lists can be any receiver or arguments"

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `@arg equals: true'
		do: [:aNode :answer | contextDictionary := searcher context].
	searcher
		executeTree: (self parseExpression: 'self
					assert: each isReadOnlyObject equals: true.').
	self
		assertCodeForVariableNodeNamed: '`@receiver'
		in: contextDictionary
		equals: 'self'.
	self
		assertCodeForVariableNodeNamed: '`@arg'
		in: contextDictionary
		equals: 'each isReadOnlyObject'!

testSearchListComplexNotMatching
	"Here we are looking for multiple lists in one match pattern at the same time.
	Lists can be any receiver or argument"

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `@arg equals: true'
		do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self parseExpression: 'self assert: token isLiteralToken.')!

testSearchListReceiverNotMatching
	"A receiver list can be: a simple receiver like self, or a complex receiver like (self newRequestTo: aString). So here we are looking for any receiver followed by put. "

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv put' do: [:aNode :answer | self fail: 'Unexpected match'].

	"The below example is not matching because the message is different than put."
	searcher executeTree: (self parseExpression: '1 at')!

testSearchListTempVars
	"Here we are looking for a method that contains a list of temporary vars followed by myVar1 and then a receiver followed by message messageTofind"

	"The below example is correct, matching with our pattern even if we have multiple variables"

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`sel |`@temps `temp| `rcv messageTofind'
		do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self
				parseExpression: 'example
								|aTempVar aTempVar2 aTempVar3 myTempVar|
								self messageTofind.').
	self
		assertCodeForVariableNodeNamed: '`sel'
		in: contextDictionary
		equals: 'example'.
	self
		assertCodeForVariableNodeNamed: '`@temps'
		in: contextDictionary
		equals: 'aTempVar aTempVar2 aTempVar3'.

	"Here the engine stores a symbol "
	self
		assertCodeForSymbolAt: '`temp'
		in: contextDictionary
		equals: 'myTempVar'.
	self
		assertCodeForVariableNodeNamed: '`rcv'
		in: contextDictionary
		equals: 'self'!

testSearchListTempVarsNotMatching
	"here we are looking for a method that containns a list of temporary vars followed by myVar1 and then a receiver followed by message messageTofind"

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`sel |`@temps `temp| `rcv messageTofind'
		do: [:aNode :answer | self fail: 'Unexpected match'].

	"The second example is incorrect, NOT matching with our pattern bcz even we have one variable defined, but it is not followed by temp var which name cannot change"
	searcher executeTree: (self parseExpression: 'example2 |aTempVar| self messageTofind. ')!

testSearchLiteralArray
	"so here we are looking for any literal with message size
	Literal can be an array."

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`#lit size' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: '#(1 2 3) size').
	self
		assertCodeForVariableNodeNamed: '`#lit'
		in: contextDictionary
		equals: '#(1 2 3)'!

testSearchLiteralCollectNotWorking
	"so here we are looking for any literal with message size; Ordered Collection is not a literal. "

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`#lit size' do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self parseExpression: 'OrderedCollection new size')!

testSearchLiteralNumber
	"so here we are looking for any literal with message size; Litteral can be a number."

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`#lit size' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: '3 size').
	self
		assertCodeForVariableNodeNamed: '`#lit'
		in: contextDictionary
		equals: '3'!

testSearchLiteralString
	"so here we are looking for any literal with message size; Litteral can be a string"

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`#lit size' do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: ' ''foo'' size').
	self
		assertCodeForVariableNodeNamed: '`#lit'
		in: contextDictionary
		equals: '''foo'''!

testSearchRecurseInto
	"Here we are testing the recurse into, which looks inside @vars for pattern that matches @vars + 1"

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@vars + 1' do: [:aNode :answer | answer + 1].
	"So here: we have 3 message nodes. The one we are looking recursevily into is the first message node: myNum + 1 which is matching with the original pattern."

	"Match 1: (myNum + 1) + 1; Match 2: (myNum + 1)"
	self assert: (searcher executeTree: (self parseExpression: '(myNum + 1) + 1 + 5') initialAnswer: 0)
		equals: 2!

testSearchRecurseIntoNotMatching
	"Here we are testing the recurse into, which looks inside @vars for pattern that matches @vars + 1"

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@vars + 1' do: [:aNode :answer | answer + 1].
	self deny: (searcher executeTree: (self parseExpression: '(myNum + 1) + 1 + 5 + (myNum + 1)')
				initialAnswer: 0)
		equals: 1!

testSearchSelectors
	"So here we are looking for an expression that starts with a receiver followed by at: message , then a list of arguments, then another selector that could be any selector ... followed by a second list of args"

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv at: `@arg `sel: `@arg1'
		do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: 'cache at: each ifAbsentPut: [ each ].').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'cache'.
	self
		assertCodeForVariableNodeNamed: '`@arg'
		in: contextDictionary
		equals: 'each'.
	self
		assertCodeForVariableNodeNamed: '`@arg1'
		in: contextDictionary
		equals: '[each]'!

testSearchSelectorsMultiArgs
	"So here we are looking for an expression that starts with a receiver followed by at: message , then a list of arguments, then another selector that could be any selector ... followed by a second list of args"

	| searcher contextDictionary |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv at: `@arg `sel: `@arg1'
		do: [:aNode :answer | contextDictionary := searcher context].
	searcher executeTree: (self parseExpression: 'collection at: offset + count put: object.').
	self
		assertCodeForVariableNodeNamed: '`@rcv'
		in: contextDictionary
		equals: 'collection'.
	self
		assertCodeForVariableNodeNamed: '`@arg'
		in: contextDictionary
		equals: 'offset + count'.
	self
		assertCodeForVariableNodeNamed: '`@arg1'
		in: contextDictionary
		equals: 'object'!

testSearchSelectorsNotMatching
	"So here we are looking for an expression that starts with a receiver followed by at: message , then a list of arguments, then another selector that could be any selector ... followed by a second list of args"

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@rcv at: `@arg `sel: `@arg1'
		do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self parseExpression: 'self assert: preferences exists.')!

testSearchStatements
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`.Statements.' do: [:aNode :answer | answer + 1].
	self
		assert: (searcher executeTree: (self
						parseExpression: 'myArray := OrderedCollection new.
													myPoint := Point new setX: 1 setY: 2')
				initialAnswer: 0)
		equals: 2!

testSelectorPartialMatch
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg `sel: ``@arg1' do: [:aNode :answer | answer + 1].
	self
		assert: (searcher executeTree: (self
						parseExpression: 'self at: 1 put: 2; at: 2 ifAbsent: []; ifAbsent: 2 at: 1; at: 4; foo')
				initialAnswer: 0)
		equals: 2!

testSimpleAddSearch
	| searcher res |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@Super << `#ASymbol' do: [:aNode :anAnswer | res := #class].
	searcher executeTree: (RBParser parseExpression: ' Object << #Point').
	self assert: res equals: #class!

testWithoutAListDoesNotMatchComposedMessages
	"Using `arg, and not `@arg, we looking for multiple lists in one match pattern at the same time.
	Lists can be any receiver or args."

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '`@receiver assert: `arg equals: true'
		do: [:aNode :answer | self fail: 'Unexpected match'].
	searcher executeTree: (self
				parseExpression: 'self assert: reader storedSettings first realValue equals: true.')! !
!Refactory.Browser.Tests.ParseTreeSearcherTest categoriesForMethods!
assertCodeForSymbolAt:in:equals:!helpers!private! !
assertCodeForVariableNodeNamed:in:equals:!helpers!private! !
testAListDoesNotMatchComposedMessagesBecauseOfTreeMismatch!public!unit tests! !
testAListDoesNotMatchComposedMessagesBecauseOfTreeMismatch2!public!unit tests! !
testAListMatchesComposedMessages!public!unit tests! !
testDoesNotMultipleKeywordsWithoutAList!public!unit tests! !
testDynamicArrayStatements!public!unit tests! !
testDynamicArrayWithStatementListPattern!public!unit tests! !
testMatchesArgumentToTestImplicitAddArgument!public!unit tests! !
testMatchesDoDoesNotMatchAllElementsOfDynamicArray!public!unit tests! !
testMatchesDoIsMatchingAllElementsOfDynamicArray!public!unit tests! !
testMatchesDoIsMatchingPatternedExpressionWithLiterals!public!unit tests! !
testMatchesDoisMatchingStatementsInDynamicArray!public!unit tests! !
testMatchesDoIsNotMatchingPatternedExpressionWithLiterals!public!unit tests! !
testMatchingAnyNodeWithoutConstrainingThePattern!public!unit tests! !
testMatchingReceiver!public!unit tests! !
testMatchingReceiver2!public!unit tests! !
testMatchingReceiverAndMultiKeywordSelector!public!unit tests! !
testMatchingReceiverAndMultiKeywordSelector2!public!unit tests! !
testMatchingReceiverAndSelector!public!unit tests! !
testMatchingReceiverAndSelector2!public!unit tests! !
testMatchingReceiverComposite!public!unit tests! !
testMatchMessageList!public!unit tests! !
testSearching!public!unit tests! !
testSearchingComposedMessage!public!unit tests! !
testSearchingComposedSelector!public!unit tests! !
testSearchingComposedSelector2!public!unit tests! !
testSearchingComposedSelectorWithCascade!public!unit tests! !
testSearchingComposedSelectorwithinCascade!public!unit tests! !
testSearchingComposedSelectorWithListIsNotWorking!public!unit tests! !
testSearchingKeywordsPartWithOptionInTheMiddleIsBogus!public!unit tests! !
testSearchingOptionKeywordsPartComposedSelector!public!unit tests! !
testSearchingOptionKeywordsPartComposedSelector2!public!unit tests! !
testSearchListComplex!public!unit tests! !
testSearchListComplexNotMatching!public!unit tests! !
testSearchListReceiverNotMatching!public! !
testSearchListTempVars!public! !
testSearchListTempVarsNotMatching!public! !
testSearchLiteralArray!public! !
testSearchLiteralCollectNotWorking!public! !
testSearchLiteralNumber!public! !
testSearchLiteralString!public! !
testSearchRecurseInto!public! !
testSearchRecurseIntoNotMatching!public! !
testSearchSelectors!public! !
testSearchSelectorsMultiArgs!public! !
testSearchSelectorsNotMatching!public! !
testSearchStatements!public! !
testSelectorPartialMatch!public!unit tests! !
testSimpleAddSearch!public!unit tests! !
testWithoutAListDoesNotMatchComposedMessages!public!unit tests! !
!

