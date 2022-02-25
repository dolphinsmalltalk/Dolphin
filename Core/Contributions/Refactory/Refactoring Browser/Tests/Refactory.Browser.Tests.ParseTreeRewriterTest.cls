"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.ParseTreeRewriterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ParseTreeRewriterTest guid: (Core.GUID fromString: '{ca6a12ce-5a10-46f6-8c49-6361db872eb6}')!
Refactory.Browser.Tests.ParseTreeRewriterTest comment: ''!
!Refactory.Browser.Tests.ParseTreeRewriterTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ParseTreeRewriterTest methodsFor!

compare: aParseTree to: anotherParseTree
	self assert: aParseTree hash equals: anotherParseTree hash.
	self assert: aParseTree equals: anotherParseTree!

parseRewriteExpression: aString
	^RBPatternParser parseExpression: aString!

parseRewriteMethod: aString
	^RBPatternParser parseMethod: aString!

testBlockRewrites
	"This test shows that several rules can be used to specify different rewrite actions: the location in the tree structure, simple expression (self foo) using the node of the expression itself, and depending on the node kinds."

	| rewriter tree |
	rewriter := ParseTreeRewriter new.
	tree := self treeToBeRewritten.
	"Here the rule says that we only replace in the rightmost children of the return node."
	rewriter
		replace: 'asdf'
		with: 'fdsa'
		when: [:aNode | aNode parent parent isReturn].
	"here we want the replace self foo by the value the selector of the self foo expression, i.e. foo"
	rewriter replace: 'self foo' withValueFrom: [:aNode | StVariableNode named: aNode selector asString].
	"here the condition is false so the rule is not executed."
	rewriter
		replaceArgument: 'asdf'
		withValueFrom: [:aNode | StVariableNode named: 'xxx']
		when: [:aNode | true].
	rewriter executeTree: tree.
	self compare: rewriter tree
		to: (self parseMethod: 'method: xxx
	<primitive: 1>
	<primitive: 2>
	^asdf +  foo + fdsa')!

testBlockRewritesAreNotChained
	"This test shows that rewrite rules are not chained sequentially. One is applied and this is it."

	| tree rewriter |
	rewriter := ParseTreeRewriter new.
	tree := self treeToBeRewritten.
	"asdf ->  fdsa but not fdsa -> grgrgrgrgr"
	rewriter
		replace: 'asdf'
		with: 'fdsa'
		when: [:aNode | true].
	rewriter
		replace: 'fdsa'
		with: 'grgrgrgrgr'
		when: [:aNode | true].
	rewriter executeTree: tree.
	self compare: rewriter tree
		to: (self parseMethod: 'method: asdf
	<primitive: 1>
	<primitive: 2>
	^fdsa +  self foo + fdsa')!

testBlockRewritesArguments
	"this test just shows that all the arguments are replaced. Check in contrast with testBlockRewritesArgumentsTakeIntoAccountConditions"

	| tree rewriter |
	rewriter := ParseTreeRewriter new.
	tree := self
				parseMethod: 'method: asdf bar: bar
	<primitive: 1>
	<primitive: 2>
	^asdf + self foo + asdf'.
	rewriter
		replaceArgument: 'asdf'
		withValueFrom: [:aNode | StVariableNode named: 'xxx']
		when: [:aNode | true].
	rewriter
		replaceArgument: 'bar'
		withValueFrom: [:aNode | StVariableNode named: 'yyy']
		when: [:aNode | true].
	rewriter executeTree: tree.
	self compare: rewriter tree
		to: (self
				parseMethod: 'method: xxx bar: yyy
	<primitive: 1>
	<primitive: 2>
	^asdf +  self foo + asdf')!

testBlockRewritesArgumentsTakeIntoAccountConditions
	"this test shows that the condition controls the rewriting on the terms: here the bar argument is not rewritten because the condition is set to false."

	| tree rewriter |
	rewriter := ParseTreeRewriter new.
	tree := self
				parseMethod: 'method: asdf bar: bar
	<primitive: 1>
	<primitive: 2>
	^asdf + self foo + asdf'.
	rewriter
		replaceArgument: 'asdf'
		withValueFrom: [:aNode | StVariableNode named: 'xxx']
		when: [:aNode | true].
	rewriter
		replaceArgument: 'bar'
		withValueFrom: [:aNode | StVariableNode named: 'yyy']
		when: [:aNode | false].
	rewriter executeTree: tree.
	self compare: rewriter tree
		to: (self
				parseMethod: 'method: xxx bar: bar
	<primitive: 1>
	<primitive: 2>
	^asdf +  self foo + asdf')!

testBlockRewritesFirstRuleTakePrecedence
	| tree rewriter |
	rewriter := ParseTreeRewriter new.
	tree := self treeToBeRewritten.
	"Here the rule says that we only replace in the rightmost children of the return node."
	rewriter
		replace: 'asdf'
		with: 'fdsa'
		when: [:aNode | true].
	rewriter
		replace: 'asdf'
		with: 'grgrgrgrgr'
		when: [:aNode | true].
	rewriter executeTree: tree.
	self compare: rewriter tree
		to: (self parseMethod: 'method: asdf
	<primitive: 1>
	<primitive: 2>
	^fdsa +  self foo + fdsa')!

testBlockRewritesWithTrueConditionIsNotExecutedWhenNotMatchingCorrectNode
	"This test shows that even if the condition of the rule is true, it will not be applied on inadequate nodes.
	Here, replaceArgument: is not for plain variable but only method arguments."

	| tree rewriter |
	rewriter := ParseTreeRewriter new.
	tree := self treeToBeRewritten.
	rewriter
		replaceArgument: 'asdf'
		withValueFrom: [:aNode | StVariableNode named: 'xxx']
		when: [:aNode | true].
	rewriter executeTree: tree.
	self compare: rewriter tree
		to: (self parseMethod: 'method: xxx
	<primitive: 1>
	<primitive: 2>
	^asdf +  self foo + asdf')!

testMultimatch
	| rewriter count |
	rewriter := ParseTreeRewriter new.
	count := 0.
	rewriter
		replace: '``@object at: ``@foo'
		with: '``@object foo: ``@foo'
		when: [:aNode | (count := count + 1) == 2].
	self compare: (rewriter
				executeTree: (self parseExpression: 'self at: (bar at: 3)');
				tree)
		to: (self parseExpression: 'self at: (bar foo: 3)')!

testPatternCascade
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replace: 'self `;messages; foo: 4; `;messages1'
		with: 'self `;messages1; bar: 4; `;messages'.
	self compare: (rewriter
				executeTree: (self parseExpression: 'self foo; printString; foo: 4; bar. self foo: 4');
				tree)
		to: (self parseExpression: 'self bar; bar: 4; foo; printString. self foo:4')!

testRewriteDoesNotReuseOriginalNodes
	"This test suggest that the ParseTreeRewriter never updates the original parse tree, whereas in fact it does and many of the refactorings rely on this behaviour.
	I've tried to modify it to make it answer a copy, but it is just too much work for little apparent value."

	"Due to a bug in RBPatternVariableNode>>#copyInContext method, creating a new astTree from the rewriter reused some nodes
	 of the original tree, this results in two trees sharing the identical nodes. The original AST now contained statement nodes
	that don't refer to the same parent (the method node) and that is wrong."

	| ast search replace rewriter statements |
	ast := self parseMethod: 'foo
self statement1.
self match.'.
	"all statement nodes have the same parent"
	statements := ast body statements.
	self assert: statements first parent equals: statements last parent.
	search := '`msg
`@.statements.
`object match.'.
	replace := '`msg
`@.statements.
`object class.'.
	rewriter := ParseTreeRewriter new.
	rewriter replaceMethod: search with: replace.
	rewriter executeTree: ast.
	"all statement nodes of the original AST still have the same parent"
	self assert: statements first parent equals: statements last parent!

testRewriteDynamicArray
	| newSource rewriter |
	rewriter := ParseTreeRewriter new replace: '
		{`@first. `@second. `@third}'
				with: 'Array with: `@first  with: `@second  with: `@third'.
	newSource := (rewriter
				executeTree: (self parseRewriteExpression: ' {(1 @ 255).	(Color lightMagenta). 3}'))
					ifTrue: [rewriter tree formattedCode].
	self assert: newSource equals: 'Array
	with: 1 @ 255
	with: Color lightMagenta
	with: 3'!

testRewriteMethods
	"#('source' 'target' 'source pattern' 'target pattern')"

	{{'arg1: a arg2: b | temp1 temp2 | self stmt1 ifTrue: [^a]. self arg1: a arg2: b'
				-> 'arg2: a arg1: b | temp1 temp2 | self stmt1 ifTrue: [^a]. self arg2: b arg2: a'.
			'`arg1: `var1 `arg2: `var2 | `@temps | ``@.stmts. self `arg1: `var1 `arg2: `var2. `@.stmts1'
				-> '`arg2: `var1 `arg1: `var2 | `@temps | ``@.stmts. self `arg2: `var2 `arg2: `var1. `@.stmts1'}.
		{'arg1: a arg2: b | temp1 temp2 | self stmt1. self arg1: a arg2: b'
				-> 'arg1: a arg2: b | temp1 temp2 | [self stmt1] repeat'.
			'`@args: `@vars | `@temps | `@.stmts. self `@args: `@vars'
				-> '`@args: `@vars | `@temps | [`@.stmts] repeat'}.
		{'+ a | temps | ^self primitiveValue' -> '- a | temps | ^self primitiveValue'.
			'+ `temp | `@tmps | `@.stmts' -> '- `temp | `@tmps | `@.stmts'}.
		{'a self stmt1. self stmt2' -> 'a self stmt1. self stmt2'.
			'b | `@temps | `@.stmts' -> 'c | `@temps | `@.stmts'}.
		{'a <foo: 1 bar: 2>' -> 'a <bar: 2 foo: 1>'.
			'a <`sel1: `#arg1 `sel2: `#arg2>' -> 'a <`sel2: `#arg2 `sel1: `#arg1>'}.
		{'a <foo> self foo' -> 'b <foo> self foo'. 'a `@.stmts' -> 'b `@.stmts'}} do: 
				[:each |
				| rewrite originalTree rewritten |
				rewrite := ParseTreeRewriter new.
				rewrite replaceMethod: each second key with: each second value.
				originalTree := self parseMethod: each first key.
				self verifyParentLinksInTree: originalTree.
				"Note that the tree will be updated in place. This is relied on by users of the rewriter such as the refactorings. If you make it immutable, you can see this happening"
				"originalTree makeTreeImmutable."
				rewritten := rewrite
							executeTree: originalTree;
							tree.
				self compare: (self parseMethod: rewritten formattedCode) to: (self parseMethod: each first value).
				self verifyParentLinksInTree: originalTree.
				self verifyParentLinksInTree: rewritten.
				rewrite := ParseTreeRewriter new.
				rewrite replaceTree: (self parseRewriteMethod: each second key)
					withTree: (self parseRewriteMethod: each second value).
				self compare: (self
							parseMethod: (rewrite
									executeTree: (self parseMethod: each first key);
									tree) formattedCode)
					to: (self parseMethod: each first value)]!

testRewriteNamespaceAnnotation
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter
		replace: '`identifier'
		withValueFrom: [:variableNode | StVariableNode named: 'Refactory.Browser']
		when: [:variableNode | variableNode parent isAnnotation].
	self compare: (self
				parseMethod: (rewriter
						executeTree: (self parseMethod: 'blah <namespace: Core> ^Object');
						tree) formattedCode)
		to: (self parseMethod: 'blah <namespace: Refactory.Browser> ^Object')!

testRewrites
	"{'source' -> 'target'. 'source pattern' -> 'target pattern'}"

	{{'[:c | |a| a foo1; foo2]' -> '[:c | |a| b foo1; foo2]'. 'a' -> 'b'}.
		{'self foo: 1. bar foo1 foo: 2. (self foo: a) foo: (b foo: c)'
				-> 'self bar: 1. bar foo1 bar: 2. (self bar: a) bar: (b bar: c)'.
			'``@rcvr foo: ``@arg1' -> '``@rcvr bar: ``@arg1'}.
		{'3 + 4' -> '4 + 4'. '3' -> '4'}.
		{'a := self a' -> 'b := self a'. 'a' -> 'b'}.
		{'^self at: 1 put: 2' -> '^self put: 1 put: 2'.
			'^`@rcvr `at: `@arg1 put: `@arg2' -> '^`@rcvr put: `@arg1 put: `@arg2'}.
		{'1 + 2 + 3' -> '0 + 0 + 0'. '`#literal' -> '0'}.
		{'1 + 2 + 3. 3 foo: 4' -> '3 + (2 + 1). 4 foo: 3'.
			'``@rcvr `msg: ``@arg' -> '``@arg `msg: ``@rcvr'}.
		{'self foo: a bar: b. 1 foo: a bar: b' -> '2 foo: a bar: b. 1 foo: a bar: b'.
			'self `@msg: `@args' -> '2 `@msg: `@args'}.
		{'a := b. a := c + d' -> 'b := a. a := c + d'. '`var1 := `var2' -> '`var2 := `var1'}.
		{'^self foo value: 1' -> 'self return: (self foo value: 1)'.
			'^`@anything' -> 'self return: `@anything'}.
		{'self first; second. self first; second. self a. self b'
				-> '2 timesRepeat: [self first; second]. self a. self b'.
			'`.Stmt1. `.Stmt1. `@.stmts' -> '2 timesRepeat: [`.Stmt1]. `@.stmts'}.
		{'[:a | self a: 1 c: 2; b]' -> '[:a | self d: 2 e: 1; f. self halt]'.
			'`@rcvr `msg1: `@arg1 `msg2: `@arg2; `msg' -> '`@rcvr d: `@arg2 e: `@arg1; f. self halt'}}
			do: 
				[:each |
				| rewrite |
				rewrite := ParseTreeRewriter new.
				rewrite replace: each second key with: each second value.
				self compare: (self
							parseExpression: (rewrite
									executeTree: (self parseExpression: each first key);
									tree) formattedCode)
					to: (self parseExpression: each first value)]!

treeToBeRewritten
	^self parseMethod: 'method: asdf
	<primitive: 1>
	<primitive: 2>
	^asdf + self foo + asdf'!

verifyParentLinksInTree: aProgramNode
	| grandParent |
	grandParent := aProgramNode parent.
	(grandParent notNil and: [grandParent isCascade])
		ifTrue: 
			[aProgramNode childrenDo: 
					[:each |
					self assert: each parent parent identicalTo: grandParent.
					self verifyParentLinksInTree: each]]
		ifFalse: 
			[aProgramNode childrenDo: 
					[:each |
					self assert: each parent identicalTo: aProgramNode.
					self verifyParentLinksInTree: each]]!

verifyTree: copiedNode sharesNoNodesWith: originalNode
	| originalNodes shared copiedNodes |
	self deny: copiedNode identicalTo: originalNode.
	originalNodes := originalNode allSubNodes asIdentitySet.
	copiedNodes := copiedNode allSubNodes.
	shared := copiedNodes select: [:each | originalNodes includes: each].
	self assert: shared asArray equals: #()! !
!Refactory.Browser.Tests.ParseTreeRewriterTest categoriesForMethods!
compare:to:!helpers!private! !
parseRewriteExpression:!helpers!private! !
parseRewriteMethod:!helpers!private! !
testBlockRewrites!public!unit tests! !
testBlockRewritesAreNotChained!public!unit tests! !
testBlockRewritesArguments!public!unit tests! !
testBlockRewritesArgumentsTakeIntoAccountConditions!public!unit tests! !
testBlockRewritesFirstRuleTakePrecedence!public!unit tests! !
testBlockRewritesWithTrueConditionIsNotExecutedWhenNotMatchingCorrectNode!public!unit tests! !
testMultimatch!public!unit tests! !
testPatternCascade!public!unit tests! !
testRewriteDoesNotReuseOriginalNodes!public!unit tests! !
testRewriteDynamicArray!public!unit tests! !
testRewriteMethods!public!unit tests! !
testRewriteNamespaceAnnotation!public!unit tests! !
testRewrites!public!unit tests! !
treeToBeRewritten!constants!private! !
verifyParentLinksInTree:!helpers!private! !
verifyTree:sharesNoNodesWith:!helpers!private! !
!

