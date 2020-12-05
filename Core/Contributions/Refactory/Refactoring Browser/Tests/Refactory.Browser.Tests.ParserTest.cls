"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.ParserTest'
	instanceVariableNames: 'currentSelector classSearches rewrites'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ParserTest guid: (Core.GUID fromString: '{947b6d13-1a2a-43c0-8053-bde0fccfbd44}')!
Refactory.Browser.Tests.ParserTest comment: ''!
!Refactory.Browser.Tests.ParserTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ParserTest methodsFor!

buildArgumentSearch
	self
		createArgumentSearchWith: 'aSmalllintContext'
		selectors: #(#checkMethod: #checkClass:)
		inClass: BasicLintRuleTest!

buildMessageSearch
	self
		createSearchWith: '``@receiver -> ``@arg'
		selectors: #(#superSends #superSends)
		inClass: TransformationRuleTest!

buildMethodArgumentSearch
	"Two argument methods"

	self
		createMethodSearchWith: '`arg1: `arg1 `arg2: `arg2 | `@temps | `@.Stmts'
		selectors: #(#subclassOf:overrides: #createMatcherFor:method: #createParseTreeRule:name:)
		inClass: BasicLintRuleTest class!

buildMethodSearch
	"Simple forwarders"

	self
		createMethodSearchWith: '`@methodName: `@args ^`@object `@methodName: `@args'
		selectors: #(#problemCount #isEmpty)
		inClass: TransformationRuleTest!

buildMethodTitleSearch
	self
		createMethodSearchWith: 'initialize | `@temps | `@.Stmts'
		selectors: #(#initialize)
		inClass: BasicLintRuleTest!

buildSimpleLiteralSearch
	| search |
	search := ParseTreeSearcher new.
	search
		matchesAnyTreeOf: {RBParser
					parseExpression: '#(''bugs'' ''possible bugs'' ''unnecessary code'' ''intention revealing'' ''miscellaneous'')'}
		do: 
			[:aNode :answer |
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: #(#lintProtocols) asBag.
	(classSearches at: BasicLintRuleTest class ifAbsentPut: [Set new]) add: search!

buildSimpleVariableSearch
	self
		createSearchWith: 'result'
		selectors: #(#checkClass: #checkMethod: #isEmpty #problemCount #resetResult #resetResult #resetResult #result #result: #resultClass: #viewResults)
		inClass: BasicLintRuleTest!

buildStatementSearch
	"Two or more statements"

	self
		createSearchWith: '| `@temps | ``@.Stmts1. ``.Stmt1. ``@.Stmts2. ``.Stmt2. ``@.Stmts3'
		selectors: #(#checkMethod: #rewriteUsing: #viewResults #superSends)
		inClass: TransformationRuleTest!

compare: anObject to: anotherObject
	self assert: anObject hash equals: anotherObject hash.
	self assert: anObject equals: anotherObject!

createArgumentSearchWith: aCodeString selectors: selectorCollection inClass: aClass
	| search |
	search := ParseTreeSearcher new.
	search matchesAnyArgumentOf: {aCodeString}
		do: 
			[:aNode :answer |
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: selectorCollection asBag.
	(classSearches at: aClass ifAbsentPut: [Set new]) add: search!

createMethodSearchWith: aCodeString selectors: selectorCollection inClass: aClass
	| search |
	search := ParseTreeSearcher new.
	search matchesAnyMethodOf: {aCodeString}
		do: 
			[:aNode :answer |
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: selectorCollection asBag.
	(classSearches at: aClass ifAbsentPut: [Set new]) add: search!

createSearchWith: aCodeString selectors: selectorCollection inClass: aClass
	| search |
	search := ParseTreeSearcher new.
	search matches: aCodeString
		do: 
			[:aNode :answer |
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: selectorCollection asBag.
	(classSearches at: aClass ifAbsentPut: [Set new]) add: search!

currentSelector
	^currentSelector!

errorSignal
	#rbFix. "Dolphin does not implement this VW message on Object"
	^Error!

parseAll
	"
	self new parseAll
	"

	| progress errorsPresenter errors |
	errorsPresenter := UI.ListPresenter show.
	errors := errorsPresenter model.
	progress := UI.ProgressDialog create: UI.ProgressDialog defaultView
				operation: 
					[:progressIndicator |
					| count i |
					i := 0.
					count := Smalltalk allClasses size * 2.
					Smalltalk allBehaviorsDo: 
							[:each |
							i := i + 1.
							each compilerClass = Compiler
								ifTrue: 
									[progress text: each name.
									progressIndicator value: i / count * 100.
									each selectors do: 
											[:sel |
											| tree method |
											method := each compiledMethodAt: sel.
											[tree := method parseTree] on: Kernel.Parser errorClass do: [:ex | errors add: method -> ex].
											tree isNil
												ifFalse: 
													[((Compiler compile: tree formattedCode in: each)
														isEqualTo: (Compiler compile: method getSource in: each))
															ifFalse: [errors add: method -> 'Mismatched parse trees']]]]].
					errors].
	^progress showModal!

parseError: each
	RBParser parseExpression: each first onError: [:string :pos | ^self assert: pos equals: each last].
	self error: 'Parser didn''t fail'!

setUp
	super setUp.
	classSearches := Dictionary new.
	self
		buildMethodSearch;
		buildSimpleVariableSearch;
		buildSimpleLiteralSearch;
		buildMessageSearch;
		buildStatementSearch;
		buildArgumentSearch;
		buildMethodTitleSearch;
		buildMethodArgumentSearch!

testAllSearches
	classSearches keysAndValuesDo: 
			[:class :searches | 
			class selectors do: 
					[:sel | 
					currentSelector := sel.
					searches 
						do: [:each | each executeTree: (class parseTreeFor: sel) initialAnswer: each answer]]].
	classSearches 
		do: [:searches | searches do: [:each | self assert: each answer isEmpty]]!

testArray
	| tree allowEmpty |
	allowEmpty := RBParser allowEmptyStatements.
	RBParser allowEmptyStatements: true.
	
	[#(#('{}' 0 0) #('{.}' 0 1) #('{..}' 0 2) #('{foo. bar}' 2 1) #('{foo. bar.}' 2 2) #('{foo. bar. .}' 2 3) #('{. foo. bar}' 2 2) #('{foo.. bar}' 2 2))
		do: 
			[:each |
			tree := RBParser parseExpression: each first.
			self assert: tree statements size equals: each second.
			self assert: tree periods size equals: each last.
			self assert: tree left equals: 1.
			self assert: tree right equals: each first size]]
			ensure: [RBParser allowEmptyStatements: allowEmpty]!

testBestNodeFor
	| tree |
	tree := self treeWithEverything.
	tree nodesDo: 
			[:each | 
			each sourceInterval notEmpty 
				ifTrue: 
					[self assert: ((tree bestNodeFor: each sourceInterval) = each 
								or: [each parent isCascade and: [each parent messages last = each]])]]!

testBlockRewrites
	| rewriter tree |
	tree := RBParser parseMethod: 'method: asdf
	<primitive: 1>
	^asdf + self foo + asdf'.
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: 'asdf'
		with: 'fdsa'
		when: [:aNode | aNode parent parent isReturn].
	rewriter replace: 'self foo' withValueFrom: [:aNode | RBVariableNode named: aNode selector asString].
	rewriter
		replaceArgument: 'asdf'
		withValueFrom: [:aNode | RBVariableNode named: 'xxx']
		when: [:aNode | false].
	rewriter executeTree: tree.
	self compare: tree to: (RBParser parseMethod: 'method: asdf
	<primitive: 1>
	^asdf +  foo + fdsa')!

testCascadeReplacement
	| cascade |
	cascade := RBParser parseExpression: 'self foo; bar; baz'.
	(cascade messages at: 2) 
		replaceWith: (RBParser parseExpression: 'self bar: 2').
	self compare: cascade
		to: (RBParser parseExpression: 'self foo; bar: 2; baz')!

testComparingTrees
	| class |
	class := BasicLintRuleTest class.
	class selectors
		do: [:each | self compare: (class parseTreeFor: each) to: (class parseTreeFor: each)]!

testCopy
	| tree copy |
	tree := self treeWithEverything.
	copy := tree copy.
	self compare: tree to: copy.
	self verifyTree: copy isDeepCopyOf: tree!

testCreationProtocol
	| messageNode |
	self compare: (RBMessageNode
				receiver: (RBVariableNode named: 'self')
				selector: #+
				arguments: {RBLiteralNode value: 0})
		to: (RBParser parseExpression: 'self + 0').
	messageNode := RBMessageNode receiver: (RBVariableNode named: 'self') selector: #foo.
	self compare: (RBMethodNode selector: #bar
				body: (RBSequenceNode statements: {RBCascadeNode messages: {messageNode. messageNode}}))
		to: (RBParser parseMethod: 'bar self foo; foo')!

testEquality
	| strings |
	strings := #('test test1; test2; test3: arg1' 'test test1; test2; test3: arg2' '[:arg1 | stmt1. stmt2. stmt3]' '[:arg2 | stmt1. stmt2. stmt3]' '[:arg1 | stmt1. stmt2. stmt3. stmt4]' 'a' 'b' '#symbol' '''literal''' '##(Array new)' '##(Array new: 0)' '#(1 2 3)' '#[1 2 3]' '$a' '#''literal string''').
	1 to: strings size
		do: 
			[:i | 
			1 to: strings size
				do: 
					[:j | 
					self 
						deny: ((RBParser parseExpression: (strings at: i)) 
								= (RBParser parseExpression: (strings at: j)) xor: i = j)]]!

testEqualToWithMappingAfterRewrite
	"#965 -- when replacing the argument of a method (or block),
	you end up with an RBVariableNode where there would normally be an RBParameterNode.
	This has no effect on formatting or equality comparison, but equalTo:withMapping:
	*was* being picky about it, and it shouldn't be"

	| pattern tree1 tree2 context |
	pattern := RBParser parseRewriteMethod: 'foo: `arg ^`arg baz'.
	context := RBSmallDictionary new
				at: '-source-' put: nil;
				at: (RBPatternVariableNode named: '`arg') put: (RBVariableNode named: 'bar');
				yourself.
	tree1 := pattern copyInContext: context.
	tree2 := RBParser parseMethod: 'foo: abc ^abc baz'.
	self assert: (tree1 equalTo: tree2 withMapping: LookupTable new).
	self assert: (tree1 equalTo: tree2 withMapping: (LookupTable with: 'bar' -> 'abc')).
	self deny: (tree1 equalTo: tree2 withMapping: (LookupTable with: 'bar' -> 'def')).
	"The base case is the following:"
	self assert: ((RBVariableNode named: 'foo') equalTo: (Kernel.StParameterNode named: 'foo')
				withMapping: LookupTable new)!

testEqualToWithMappingRename
	| tree1 tree2 |
	tree1 := RBParser parseMethod: 'foo: bar ^bar baz'.
	tree2 := RBParser parseMethod: 'foo: abc ^abc baz'.
	self assert: (tree1 equalTo: tree2 withMapping: LookupTable new).
	self assert: (tree1 equalTo: tree2 withMapping: (LookupTable with: 'bar' -> 'abc')).
	self deny: (tree1 equalTo: tree2 withMapping: (LookupTable with: 'bar' -> 'def'))!

testEquivalentExceptRenaming
	#(#('a 3-4' 'a 4-3' false) #('a #[3 4]' 'a #(3 4)' false) #('a variable1 ~~ "comment" variable2' 'a variable1 ~~ variable2' true) #('a variable1' 'a variable2' false) #('a [:a :b | a + b]' 'a [:b :a | a + b]' false) #('a | a b | a + b' 'a | b a | a + b' true) #('a | a | a msg1; msg2' 'a | b | b msg2; msg2' false) #('a c' 'a d' true) #('a | a b | a := b. ^b msg1' 'a | a b | b := a. ^a msg1' true) #('a | a b | a := b. ^b msg1: a' 'a | a b | b := a. ^b msg1: a' false) #('a: b b + 4' 'a: e e + 4' true) #('a: b b + 4' 'b: b b + 4' false) #('a: b b: c b + c' 'a: c b: b c + b' true) #('a: a b: b a + b' 'a: b b: a a + b' false) #('a ^#()' 'a ^#(a)' false))
		do: 
			[:each |
			self assert: ((RBParser parseMethod: each first) equalTo: (RBParser parseMethod: (each at: 2))
						exceptForVariables: #('c'))
				identicalTo: each last]!

testExtendedLiterals
	| tree searcher |
	tree := RBParser parseMethod: 'test ##(Array with: 1 with: 2 with: #literal) at: ##esatom'.
	searcher := ParseTreeRewriter new.
	searcher replace: '##(`@object with: `#literal1 with: `#literal2 with: `#literal3)'
		with: '##(`@object with: `#literal3 with: `#literal2 with: `#literal1)'.
	searcher executeTree: tree.
	tree := searcher tree.
	searcher := ParseTreeRewriter new.
	searcher replace: '2' with: '2.5'.
	searcher executeTree: tree.
	self assert: (RBParser parseMethod: searcher tree formattedCode)
		equals: (RBParser parseMethod: 'test ##(Array with: #literal with: 2.5 with: 1) at: ##esatom')!

testFormatter
	| class |
	class := BasicLintRuleTest class.
	class selectors do: 
			[:each |
			self compare: (class parseTreeFor: each)
				to: (RBParser parseMethod: (class parseTreeFor: each) printString)]!

testIntervals
	| tree |
	tree := self treeWithEverything.
	tree nodesDo: 
			[:each | 
			(each parent isNil or: [each parent isCascade not]) 
				ifTrue: 
					[| newNode source |
					source := tree source copyFrom: each start to: each stop.
					newNode := each isMethod 
								ifTrue: [RBParser parseMethod: source]
								ifFalse: [RBParser parseExpression: source].
					self compare: each to: newNode]]!

testIsA
	| nodes types |
	nodes := Bag new.
	types := Set new.
	#(#(#isAssignment 1) #(#isBlock 1) #(#isCascade 1) #(#isLiteralNode 6) #(#isMessage 5) #(#isMethod 1) #(#isReturn 1) #(#isSequence 3) #(#isValue 22) #(#isVariable 7) #(#isUsed 17) #(#isDirectlyUsed 15) #(#hasParentheses 1) #(#isBinary 2) #(#isPrimitive 0) #(#isImmediateNode 15))
		do: 
			[:each |
			each last timesRepeat: [nodes add: each first].
			types add: each first].
	self treeWithEverything nodesDo: 
			[:each |
			types do: [:sel | ((each respondsTo: sel) and: [each perform: sel]) ifTrue: [nodes remove: sel]]].
	self assert: nodes isEmpty!

testLiteralIntevals
	| tree |
	tree := RBParser parseExpression: '#(#a b #( c ))'.
	self assert: tree contents first start equals: 3.
	self assert: tree contents first stop equals: 4.
	self assert: tree contents last contents first start equals: 11!

testLiteralMessages
	#('true' 'false' 'nil') with: #(true false nil)
		do: 
			[:string :literal |
			self assert: (RBParser parseMethod: ('<1s> ^<1s>
<1s>' expandMacrosWith: string))
				equals: (RBMethodNode selector: string asSymbol
						body: (RBSequenceNode
								statements: {RBReturnNode
											value: (RBMessageNode receiver: (RBLiteralNode value: literal) selector: string asSymbol)}))]!

testLiterals
	self assert: (RBLiteralNode value: #(1 2 #(#asdf))) formattedCode equals: '#(1 2 #(#asdf))'!

testMethodPatterns
	#(#('+ a ^self + a' #+) #('foo ^self foo' #foo) #('foo: a bar: b ^a + b' #foo:bar:))
		do: [:each | self assert: (RBParser parseMethodPattern: each first) identicalTo: each last]!

testModifying
	| tree |
	tree := RBParser 
				parseMethod: 'foo: a bar: b | c | self first. self second. a + b + c'.
	self deny: tree lastIsReturn.
	self deny: (tree body statements at: 2) isUsed.
	self assert: tree body statements last arguments first isUsed.
	self assert: (tree isLast: tree body statements last).
	self deny: (tree isLast: tree body statements first).
	self assert: (tree defines: 'a').
	self deny: (tree defines: 'c').
	self assert: (tree body defines: 'c').
	self deny: (tree body defines: 'a').
	tree
		addReturn;
		selector: #bar:foo:.
	(tree body)
		addTemporaryNamed: 'd';
		removeTemporaryNamed: 'c'.
	self compare: tree
		to: (RBParser 
				parseMethod: 'bar: a foo: b | d | self first. self second. ^a + b + c').
	self 
		assert: ((tree argumentNames asSet)
				removeAll: #('a' 'b');
				yourself) isEmpty.
	self 
		assert: ((tree allDefinedVariables asSet)
				removeAll: #('a' 'b' 'd');
				yourself) isEmpty.
	tree := RBParser parseExpression: 'self foo: 0'.
	tree selector: #+.
	self compare: tree to: (RBParser parseExpression: 'self + 0').
	self should: [tree selector: #foo] raise: self errorSignal!

testMultimatch
	| rewriter count |
	count := 0.
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '``@object at: ``@foo'
		with: '``@object foo: ``@foo'
		when: [:aNode | (count := count + 1) == 2].
	self compare: (rewriter
				executeTree: (RBParser parseExpression: 'self at: (bar at: 3)');
				tree)
		to: (RBParser parseExpression: 'self at: (bar foo: 3)')!

testNodesDo
	| size |
	size := 0.
	self treeWithEverything nodesDo: [:e | size := size + 1].
	self assert: size equals: 27!

testNumberParsing
	2 to: 32
		do: 
			[:radix |
			0 to: 72
				do: [:i | self assert: (RBParser parseExpression: (i printStringRadix: radix)) value equals: i]]!

testParserErrors
	#(#('self foo. + 3' 11) #('#(' 3) #('self 0' 6) #('self asdf;;asfd' 11)) 
		do: [:each | self parseError: each]!

testParsingLiteralMessages
	self assert: (RBParser parseExpression: 'self nil') isMessage.
	self assert: (RBParser parseExpression: 'self true') isMessage.
	self assert: (RBParser parseExpression: 'self false') isMessage.
	self assert: (RBParser parseExpression: 'self -1') isMessage!

testPatternCascade
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replace: 'self `;messages; foo: 4; `;messages1'
		with: 'self `;messages1; bar: 4; `;messages'.
	self compare: (rewriter
				executeTree: (RBParser parseExpression: 'self foo; printString; foo: 4; bar. self foo: 4');
				tree)
		to: (RBParser parseExpression: 'self bar; bar: 4; foo; printString. self foo:4')!

testPatternNodeCopy
	| tree copy |
	tree := RBParser
				parseRewriteMethod: 'method: arg1 | temps | temps := #(10 ##(#sequence -> true. #optimized -> true)). temps foo; foo. `@patternVar bar. ^(temps collect: [:e | e `patternMsg `{:msgNode | ''*pattern*'' match: msgNode selector}])'.
	copy := tree copy.
	self compare: copy to: tree.
	self verifyTree: copy isDeepCopyOf: tree!

testPositions
	| blockNode optimized |
	blockNode := RBParser parseExpression: '[:a :b | ]'.
	self assert: blockNode left equals: 1.
	self assert: blockNode right equals: 10.
	self assert: blockNode bar equals: 8.
	self assert: blockNode sourceInterval equals: (1 to: 10).
	self assert: blockNode size equals: 1.	"test dummy collection protocol"
	blockNode printString.	"coverage"
	self deny: (blockNode isLast: (RBVariableNode named: 'b')).
	self compare: blockNode
		to: (RBBlockNode
				arguments: (OrderedCollection with: (RBVariableNode named: 'a') with: (RBVariableNode named: 'b'))
				body: (RBSequenceNode statements: #())).
	optimized := RBParser parseExpression: '(##(| a | a := 5. a * a))'.
	self assert: optimized startWithoutParentheses equals: 2.
	self assert: optimized stopWithoutParentheses equals: 24.
	self assert: (optimized equalTo: (RBParser parseExpression: '##(| b | b := 5. b * b)')
				exceptForVariables: #()).
	self assert: optimized isImmediateNode.
	RBProgramNodeVisitor new visitNode: optimized.
	optimized body replaceWith: (RBParser parseExpression: '| c | c := 5. c * 45').
	self compare: optimized to: (RBParser parseExpression: '##(| c | c := 5. c * 45)')!

testPrimitives
	self assert: (Object parseTreeFor: #basicAt:) isPrimitive.
	#(#('foo ^true' false) #('foo <stdcall: void sleep> ^true' true) #('foo <overlap stdcall: void sleep> ^true' true) #('foo <virtual stdcall: void 1> ^true' true) #(' foo <primitive: 123> ^true' true))
		do: [:each | self assert: (RBParser parseMethod: each first) isPrimitive equals: each last].
	self should: [RBParser parseMethod: 'foo <some tag> ^true'] raise: Kernel.Parser errorClass!

testQuerying
	| tree aNode arg1Node bNode |
	tree := RBParser
				parseMethod: ('test: a`	| b |`	b := (self foo: a; bar) baz.`	b := super test: b.`	^[:arg1 | self foa1 + (super foo: arg1 foo: a foo: b)]'
						copyReplaceAll: '`'
						with: (String with: (Character value: 13))).
	self assert: tree selfMessages asSortedCollection asArray equals: #(#bar #foa1 #foo:).
	self assert: tree superMessages asSortedCollection asArray equals: #(#foo:foo:foo: #test:).
	aNode := tree whichNodeIsContainedBy: (112 to: 112).
	self assert: aNode name equals: 'a'.
	bNode := tree whichNodeIsContainedBy: (119 to: 119).
	self assert: bNode name equals: 'b'.
	arg1Node := tree whichNodeIsContainedBy: (102 to: 105).
	self assert: arg1Node name equals: 'arg1'.
	self assert: (arg1Node statementNode isMessage and: [arg1Node statementNode selector = #+]).
	self assert: (arg1Node whoDefines: 'arg1') isBlock.
	self assert: (aNode whoDefines: 'a') isMethod.
	self assert: (aNode whoDefines: 'b') isSequence.
	self assert: (tree whichNodeIsContainedBy: (91 to: 119)) selector equals: #foo:foo:foo:.
	self assert: (tree whichNodeIsContainedBy: (69 to: 121)) isBlock.
	self assertIsNil: (tree whichNodeIsContainedBy: (69 to: 118)).
	self assert: aNode blockVariables asSortedCollection asArray equals: #('arg1').
	self assert: aNode temporaryVariables asSortedCollection asArray equals: #('b').
	self assert: tree allDefinedVariables asSortedCollection asArray equals: #('a' 'arg1' 'b').
	self assert: tree allArgumentVariables asSortedCollection asArray equals: #('a' 'arg1').
	self assert: tree allTemporaryVariables asSortedCollection asArray equals: #('b')!

testReadBeforeWritten
	#(#('a ifTrue: [^self]' true) #('self foo. a := b' false) #('condition ifTrue: [a := b] ifFalse: [self foo: a]' true) #('condition ifTrue: [a := b] ifFalse: [self foo]. a isNil' true) #('condition ifTrue: [a := b]. a := c' false) #('[a := b] whileFalse: [a isNil]' false) #('self foo: b' false))
		do: 
			[:each |
			self
				assert: ((RBReadBeforeWrittenTester readBeforeWritten: #('a')
						in: (RBParser parseExpression: each first)) includes: 'a')
				identicalTo: each last.
			self assert: (RBReadBeforeWrittenTester isVariable: 'a'
						readBeforeWrittenIn: (RBParser parseExpression: each first))
				equals: each last].
	#('| temp read written written1 |
			read ifTrue: [^self].
			written1 := self foo ifFalse: [written := true] ifTrue: [written := false].
			[temp := true] whileTrue: [temp notNil & written].
			^temp' '| read written |
			self foo ifTrue: [written := true] ifFalse: [written := false].
			self foo ifTrue: [read := true].
			^read' '| read written |
			self foo do: [:i | i].
			[| i | i := 1. i == 1] whileFalse: [read notNil]' '| written |
			[written := 2] whileFalse.
			self do: [:each | | read | each & read]' '| read |
			self do: [:each | read := each].
			self do: [:each | each & read]')
		do: 
			[:each |
			| read |
			read := RBReadBeforeWrittenTester variablesReadBeforeWrittenIn: (RBParser parseExpression: each).
			self assert: (read size = 1 and: [read includes: 'read'])]!

testReadBeforeWritten1
	self
		assert: (RBReadBeforeWrittenTester variablesReadBeforeWrittenIn: (RBParser
						parseMethod: 'addAll: aCollection 
	"Answer aCollection, having added all elements
	 of aCollection to the receiver.

	 Fail if aCollection is not a kind of
	 Collection."

	| newSize elementsSize growSize |
	(newSize := aCollection size * 2) > elements size ifTrue: [self rehash: newSize].
	elementsSize := elements size.
	growSize := elementsSize // 2.
	aCollection do: 
			[:newObject | 
			| hashIndex element |
			newObject == nil ifFalse: 
					[hashIndex := self hashIndexFor: newObject.
					
					[(element := elements at: hashIndex) == nil
						ifTrue: 
							[elements at: hashIndex put: newObject.
							(elementCount := elementCount + 1) > growSize ifTrue: 
									[self expand.
									elementsSize := elements size.
									growSize := elementsSize // 2].
							true]
						ifFalse: [element == newObject]]
							whileFalse: 
								[(hashIndex := hashIndex + 1) > elementsSize ifTrue: [hashIndex := 1]]]].
	^aCollection'))
				isEmpty!

testReplacingNodes
	| tree search block |
	tree := RBParser
				parseMethod: '+ a | a b | self ifTrue: [a] ifFalse: [b := c]. a := b. [:b :c :a | a foo: a; foo1: a; foo2: a foo: b]. ^a'.
	search := ParseTreeSearcher new.
	block := [:aNode :answer | aNode replaceWith: (RBVariableNode named: 'q')].
	search
		matches: 'a' do: block;
		matchesArgument: 'a' do: block.
	search executeTree: tree.
	self assert: tree
		equals: (RBParser
				parseMethod: '+ q | q b | self ifTrue: [q] ifFalse: [b := c]. q := b. [:b :c :q | q foo: q; foo1: q; foo2: q foo: b]. ^q').
	self assert: tree removeDeadCode
		equals: (RBParser parseMethod: '+ q | q b | self ifTrue: [] ifFalse: [b := c]. q := b. ^q')!

testRewriteMethods
	#(#('arg1: a arg2: b | temp1 temp2 | self stmt1 ifTrue: [^a]. self arg1: a arg2: b' 'arg2: a arg1: b | temp1 temp2 | self stmt1 ifTrue: [^a]. self arg2: b arg2: a' '`arg1: `var1 `arg2: `var2 | `@temps | ``@.stmts. self `arg1: `var1 `arg2: `var2. `@.stmts1' '`arg2: `var1 `arg1: `var2 | `@temps | ``@.stmts. self `arg2: `var2 `arg2: `var1. `@.stmts1') #('arg1: a arg2: b | temp1 temp2 | self stmt1. self arg1: a arg2: b' 'arg1: a arg2: b | temp1 temp2 | [self stmt1] repeat' '`@args: `@vars | `@temps | `@.stmts. self `@args: `@vars' '`@args: `@vars | `@temps | [`@.stmts] repeat') #('+ a | temps | ^self primitiveValue' '- a | temps | ^self primitiveValue' '+ `temp | `@tmps | `@.stmts' '- `temp | `@tmps | `@.stmts') #('a self stmt1. self stmt2' 'a self stmt1. self stmt2' 'b | `@temps | `@.stmts' 'c | `@temps | `@.stmts'))
		do: 
			[:each |
			| rewrite |
			rewrite := ParseTreeRewriter new.
			rewrite replaceMethod: (each at: 3) with: each last.
			self compare: (RBParser
						parseMethod: (rewrite
								executeTree: (RBParser parseMethod: each first);
								tree) formattedCode)
				to: (RBParser parseMethod: (each at: 2)).
			rewrite := ParseTreeRewriter new.
			rewrite replaceTree: (RBParser parseRewriteMethod: (each at: 3))
				withTree: (RBParser parseRewriteMethod: each last).
			self compare: (RBParser
						parseMethod: (rewrite
								executeTree: (RBParser parseMethod: each first);
								tree) formattedCode)
				to: (RBParser parseMethod: (each at: 2))]!

testRewrites
	#(#('[:c | |a| a foo1; foo2]' '[:c | |a| b foo1; foo2]' 'a' 'b') #('self foo: 1. bar foo1 foo: 2. (self foo: a) foo: (b foo: c)' 'self bar: 1. bar foo1 bar: 2. (self bar: a) bar: (b bar: c)' '``@rcvr foo: ``@arg1' '``@rcvr bar: ``@arg1') #('3 + 4' '4 + 4' '3' '4') #('a := self a' 'b := self a' 'a' 'b') #('^self at: 1 put: 2' '^self put: 1 put: 2' '^`@rcvr `at: `@arg1 put: `@arg2' '^`@rcvr put: `@arg1 put: `@arg2') #('1 + 2 + 3' '0 + 0 + 0' '`#literal' '0') #('1 + 2 + 3. 3 foo: 4' '3 + (2 + 1). 4 foo: 3' '``@rcvr `msg: ``@arg' '``@arg `msg: ``@rcvr') #('self foo: a bar: b. 1 foo: a bar: b' '2 foo: a bar: b. 1 foo: a bar: b' 'self `@msg: `@args' '2 `@msg: `@args') #('a := b. a := c + d' 'b := a. a := c + d' '`var1 := `var2' '`var2 := `var1') #('^self foo value: 1' 'self return: (self foo value: 1)' '^`@anything' 'self return: `@anything') #('self first; second. self first; second. self a. self b' '2 timesRepeat: [self first; second]. self a. self b' '`.Stmt1. `.Stmt1. `@.stmts' '2 timesRepeat: [`.Stmt1]. `@.stmts') #('[:a | self a: 1 c: 2; b]' '[:a | self d: 2 e: 1; f. self halt]' '`@rcvr `msg1: `@arg1 `msg2: `@arg2; `msg' '`@rcvr d: `@arg2 e: `@arg1; f. self halt'))
		do: 
			[:each |
			| rewrite |
			rewrite := ParseTreeRewriter new.
			rewrite replace: (each at: 3) with: each last.
			self compare: (RBParser
						parseExpression: (rewrite
								executeTree: (RBParser parseExpression: each first);
								tree) formattedCode)
				to: (RBParser parseExpression: (each at: 2))]
	"#('#{Object}' 'Object' '#{Object}' 'Object') #('Smalltalk.Object' 'Smalltalk.Object printString' '`var' '`var printString') #('Smalltalk. Object' 'Smalltalk printString. Object printString' '`var' '`var printString')"!

testSearching
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg `sel: ``@arg1' do: [:aNode :answer | answer + 1].
	self
		assert: (searcher executeTree: (RBParser
						parseExpression: 'self at: 1 put: 2; at: 2 ifAbsent: []; ifAbsent: 2 at: 1; at: 4; foo')
				initialAnswer: 0)
		equals: 2.
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv `at: ``@arg1 `at: ``@arg2' do: [:aNode :answer | answer + 1].
	self
		assert: (searcher executeTree: (RBParser
						parseExpression: 'self at: 1 at: 3; at: 1 put: 32; at: 2; foo; at: 1 at: 1 at: 2')
				initialAnswer: 0)
		equals: 1.
	searcher := ParseTreeSearcher new.
	searcher matchesMethod: 'at: `object `put: `o1 ``@rcv `put: 1' do: [:aNode :answer | true].
	self assert: (searcher executeTree: (RBParser parseMethod: 'at: a put: b self foo put: 1')
				initialAnswer: false)!

testSmallDictionary
	| dictionary total |
	dictionary := RBSmallDictionary new: 100.
	dictionary
		add: 1 -> 3;
		at: 2 put: 4;
		at: 1 put: 4.
	self assert: dictionary size equals: 2.
	self assert: (dictionary inject: 0 into: [:sum :each | sum + each]) equals: 8.
	self assert: (dictionary includesKey: 1).
	self deny: (dictionary includesKey: 3).
	total := 0.
	dictionary keysDo: [:each | total := total + each].
	self assert: total equals: 3.
	dictionary removeKey: 2.
	dictionary copy associationsDo: [:each | dictionary remove: each].
	self assert: dictionary size equals: 0!

testTokens
	| tokens scanner |
	scanner := RBScanner on: '#foo foo: bar := [ ##( + foo.bar.baz' readStream.
	tokens := scanner contents.
	tokens printString.
	tokens with: #(4 4 3 2 1 3 1 11) do: [:token :length | self assert: token length equals: length]!

treeWithEverything
	^RBParser
		parseMethod: 'method: arg1 | temps | temps := #(10 ##(#sequence -> true. #optimized -> true)). temps foo; foo. ^(temps collect: [:e | ])'!

verifyParser
	Smalltalk allBehaviorsDo: 
			[:each |
			each compilerClass = Compiler
				ifTrue: [each selectors do: [:sel | self verifySelector: sel inClass: each]]]!

verifySelector: aSelector inClass: aClass
	"
	ParserTest new verifySelector: #testEqualsColon inClass: FloatTest
	"

	| myTree source |
	source := aClass sourceCodeAt: aSelector.
	source isNil ifTrue: [^self].
	myTree := aClass parseTreeFor: aSelector.
	self denyIsNil: myTree.
	self assert: ((Compiler compile: myTree formattedCode in: aClass)
				isEqualTo: (Compiler compile: source in: aClass))!

verifyTree: copiedNode isDeepCopyOf: originalNode
	self assert: originalNode class identicalTo: copiedNode class.
	self deny: originalNode identicalTo: copiedNode.
	self assert: originalNode equals: copiedNode.
	originalNode children with: copiedNode children
		do: 
			[:originalChild :copiedChild |
			"Messages in a cascade share their receiver coming out of the parser, but #copy gives them each a separate copy."
			(originalNode parent notNil and: [originalNode parent isCascade])
				ifTrue: 
					[| isLastMessage |
					isLastMessage := originalNode == originalNode parent messages last.
					self assert: isLastMessage identicalTo: originalChild parent == originalNode]
				ifFalse: [self assert: originalChild parent identicalTo: originalNode].
			self assert: copiedChild parent identicalTo: copiedNode.
			"
			(Array with: originalNode with: originalChild parent with: copiedNode with: copiedChild parent) collect: #identityHash.
			"
			self verifyTree: copiedChild isDeepCopyOf: originalChild]! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildArgumentSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildMessageSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildMethodArgumentSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildMethodSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildMethodTitleSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildSimpleLiteralSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildSimpleVariableSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #buildStatementSearch!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #compare:to:!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #createArgumentSearchWith:selectors:inClass:!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #createMethodSearchWith:selectors:inClass:!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #createSearchWith:selectors:inClass:!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #currentSelector!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #errorSignal!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #parseAll!long running!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #parseError:!private! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #setUp!accessing!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testAllSearches!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testArray!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testBestNodeFor!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testBlockRewrites!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testCascadeReplacement!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testComparingTrees!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testCopy!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testCreationProtocol!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testEquality!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testEqualToWithMappingAfterRewrite!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testEqualToWithMappingRename!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testEquivalentExceptRenaming!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testExtendedLiterals!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testFormatter!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testIntervals!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testIsA!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testLiteralIntevals!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testLiteralMessages!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testLiterals!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testMethodPatterns!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testModifying!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testMultimatch!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testNodesDo!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testNumberParsing!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testParserErrors!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testParsingLiteralMessages!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testPatternCascade!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testPatternNodeCopy!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testPositions!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testPrimitives!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testQuerying!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testReadBeforeWritten!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testReadBeforeWritten1!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testReplacingNodes!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testRewriteMethods!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testRewrites!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testSearching!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testSmallDictionary!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #testTokens!public!unit tests! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #treeWithEverything!private! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #verifyParser!long running!public! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #verifySelector:inClass:!private! !
!Refactory.Browser.Tests.ParserTest categoriesFor: #verifyTree:isDeepCopyOf:!private! !

