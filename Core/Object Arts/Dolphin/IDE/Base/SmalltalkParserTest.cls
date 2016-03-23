"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SmalltalkParserTest
	instanceVariableNames: 'currentSelector classSearches rewrites'
	classVariableNames: ''
	poolDictionaries: 'ExtCallArgTypes SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
SmalltalkParserTest guid: (GUID fromString: '{947B6D13-1A2A-43C0-8053-BDE0FCCFBD44}')!
SmalltalkParserTest comment: 'SUnitBrowser openOnTestCase: self'!
!SmalltalkParserTest categoriesForClass!Refactory-Testing! !
!SmalltalkParserTest methodsFor!

buildArgumentSearch
	self 
		createArgumentSearchWith: 'aNode'
		selectors: #(#parseBinaryMessageWith: #parseUnaryMessageWith: #addCommentsTo: #parseStatementsOf:allowTag: #validateTemp:of:temps: #parseTempsOf:)
		inClass: SmalltalkParser!

buildMessageSearch
	self 
		createSearchWith: '``@receiver -> ``@arg'
		selectors: #(valueFromObject: valueFromObject: valueFromObject: valueFromObject: valueFromObject: valueFromObject:)
		inClass: RegKeyAbstract!

buildMethodArgumentSearch
	"Private - Two argument methods"

	self 
		createMethodSearchWith: '`arg1: `arg1 `arg2: `arg2 | `@temps | `@.Stmts'
		selectors: #(#validateClassVars:againstSuperclass: #validateInstanceVars:againstSuperclass: #renameClass:to: #moveClass:toSuperclass: #validateInstVarName:using: #validateClassVarName:using: #removeClass:ignoreInstances:)
		inClass: ClassBuilder class!

buildMethodSearch
	"Private - Simple forwarders"

	self 
		createMethodSearchWith: '`@methodName: `@args ^`@object `@methodName: `@args'
		selectors: #(#forwarded1 #forwarded2)
		inClass: SmalltalkParserTest!

buildMethodTitleSearch
	self 
		createMethodSearchWith: 'initialize | `@temps | `@.Stmts'
		selectors: #(#initialize)
		inClass: LookupTable!

buildSimpleLiteralSearch
	| search |
	search := ParseTreeSearcher new.
	search 
		matchesAnyTreeOf: (Array with: (self parserClass 
						parseExpression: '#(''bugs'' ''possible bugs'' ''unnecessary code'' ''intention revealing'' ''miscellaneous'')'))
		do: 
			[:aNode :answer | 
			answer
				remove: self currentSelector ifAbsent: [self error: 'failed'];
				yourself].
	search answer: #(#lintProtocols) asBag.
	(classSearches at: SmalltalkParserTest ifAbsentPut: [Set new]) add: search!

buildSimpleVariableSearch
	self 
		createSearchWith: 'key'
		selectors: (Association whichSelectorsAccess: 'key') asArray
		inClass: Association!

buildStatementSearch
	"Private - Two or more statements"

	self 
		createSearchWith: '| `@temps | ``@.Stmts1. ``.Stmt1. ``@.Stmts2. ``.Stmt2. ``@.Stmts3'
		selectors: #(schedule terminateProcess initialize calcResumptionTime hasExpired signal wait wait)
		inClass: Delay!

compare: anObject to: anotherObject 
	self assert: anObject hash = anotherObject hash.
	self assert: anObject = anotherObject!

createArgumentSearchWith: aCodeString selectors: selectorCollection inClass: aClass 
	| search |
	search := ParseTreeSearcher new.
	search matchesAnyArgumentOf: (Array with: aCodeString)
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
	search matchesAnyMethodOf: (Array with: aCodeString)
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

forwarded1
	^testSelector forwarded1!

forwarded2
	^testSelector x forwarded2!

lintProtocols
	#rbFix. "from protocols, clashes with that in ClassDescription"
	^#('bugs' 'possible bugs' 'unnecessary code' 'intention revealing' 'miscellaneous')!

nodeVisitorClass
	^StParseNodeVisitor!

parserClass
	^SmalltalkParser!

scannerClass
	^SmalltalkScanner!

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
	tree := self parserClass 
				parseMethod: 'method: asdf
	<primitive: 1>
	^asdf + self foo + asdf'.
	rewriter := ParseTreeRewriter new.
	rewriter 
		replace: 'asdf'
		with: 'fdsa'
		when: [:aNode | aNode parent parent isReturn].
	rewriter replace: 'self foo'
		withValueFrom: [:aNode | StVariableNode named: aNode selector asString].
	rewriter 
		replaceArgument: 'asdf'
		withValueFrom: [:aNode | StVariableNode named: 'xxx']
		when: [:aNode | false].
	rewriter executeTree: tree.
	self compare: tree
		to: (self parserClass 
				parseMethod: 'method: asdf
	<primitive: 1>
	^asdf +  foo + fdsa')!

testComparingTrees
	| class |
	class := ClassBuilder class.
	class selectors
		do: [:each | self compare: (class parseTreeFor: each) to: (class parseTreeFor: each)]!

testCopy
	| tree |
	tree := self treeWithEverything.
	self compare: tree to: tree copy!

testCreationProtocol
	| messageNode |
	self compare: (StMessageNode 
				receiver: (StVariableNode named: 'self')
				selector: #+
				arguments: (Array with: (StLiteralNode value: 0)))
		to: (self parserClass parseExpression: 'self + 0').
	messageNode := StMessageNode receiver: (StVariableNode named: 'self')
				selector: #foo.
	self compare: (StMethodNode selector: #bar
				body: (StSequenceNode statements: (Array 
								with: (StCascadeNode messages: (Array with: messageNode with: messageNode)))))
		to: (self parserClass parseMethod: 'bar self foo; foo')!

testEquality
	| strings |
	strings := #('test test1; test2; test3: arg1' 'test test1; test2; test3: arg2' '[:arg1 | stmt1. stmt2. stmt3]' '[:arg2 | stmt1. stmt2. stmt3]' '[:arg1 | stmt1. stmt2. stmt3. stmt4]' 'a' 'b' '#literal' '''literal''' '##(Array new)' '##(Array new: 0)' '#(1 2 3)' '#[1 2 3]' '$a' '#''literal string''').
	1 to: strings size
		do: 
			[:i | 
			1 to: strings size
				do: 
					[:j | 
					self 
						deny: ((self parserClass parseExpression: (strings at: i)) 
								= (self parserClass parseExpression: (strings at: j)) xor: i = j)]]!

testEquivalentExceptRenaming
	#(#('a 3-4' 'a 4-3' false) #('a #[3 4]' 'a #(3 4)' false) #('a variable1 ~~ "comment" variable2' 'a variable1 ~~ variable2' true) #('a variable1' 'a variable2' false) #('a [:a :b | a + b]' 'a [:b :a | a + b]' false) #('a | a b | a + b' 'a | b a | a + b' true) #('a | a | a msg1; msg2' 'a | b | b msg2; msg2' false) #('a c' 'a d' true) #('a | a b | a := b. ^b msg1' 'a | a b | b := a. ^a msg1' true) #('a | a b | a := b. ^b msg1: a' 'a | a b | b := a. ^b msg1: a' false) #('a: b b + 4' 'a: e e + 4' true) #('a: b b + 4' 'b: b b + 4' false) #('a: b b: c b + c' 'a: c b: b c + b' true) #('a: a b: b a + b' 'a: b b: a a + b' false)) 
		do: 
			[:each | 
			self 
				assert: ((self parserClass parseMethod: each first) 
						equalTo: (self parserClass parseMethod: (each at: 2))
						exceptForVariables: #('c')) == each last]!

testExtendedLiterals
	| tree searcher |
	tree := self parserClass 
				parseMethod: 'test ##(Array with: 1 with: 2 with: #literal) at: ##esatom'.
	searcher := ParseTreeRewriter new.
	searcher 
		replace: '##(`@object with: `#literal1 with: `#literal2 with: `#literal3)'
		with: '##(`@object with: `#literal3 with: `#literal2 with: `#literal1)'.
	searcher executeTree: tree.
	tree := searcher tree.
	searcher := ParseTreeRewriter new.
	searcher replace: '2' with: '2.5'.
	searcher executeTree: tree.
	self assert: (self parserClass parseMethod: searcher tree formattedCode) 
				= (self parserClass 
						parseMethod: 'test ##(Array with: #literal with: 2.5 with: 1) at: ##esatom')!

testExternalCallEquality
	| strings |
	strings := #('test <stdcall: void Test>' 'test <overlap stdcall: void Test>' 'test: a <stdcall: void Test dword>').
	1 to: strings size
		do: 
			[:i | 
			1 to: strings size
				do: 
					[:j | 
					self 
						deny: ((self parserClass parseMethod: (strings at: i)) 
								= (self parserClass parseMethod: (strings at: j)) xor: i = j)]]!

testExternalCalls
	| ffiCall tree src types |
	self assert: (KernelLibrary parseTreeFor: #loadLibraryEx:hFile:dwFlags:) isPrimitive.
	"Zero args"
	tree := SmalltalkParser parseMethod: 'blah <stdcall: void blah>'.
	self assert: tree formattedCode trimBlanks = 'blah
	<stdcall: void blah>'.
	ffiCall := tree tag.
	self assert: ffiCall argumentTypes isEmpty.
	self assert: ffiCall returnType typeOrdinal = ExtCallArgVOID.
	self assert: ffiCall returnType indirections = 0.
	self assert: ffiCall returnType structClass isNil.

	"One simple arg"
	tree := SmalltalkParser parseMethod: 'blah: x <stdcall: dword blah sdword>'.
	self assert: tree formattedCode trimBlanks = 'blah: x
	<stdcall: dword blah sdword>'.
	ffiCall := tree tag.
	self assert: ffiCall returnType typeOrdinal = ExtCallArgDWORD.
	self assert: ffiCall returnType indirections = 0.
	self assert: ffiCall returnType structClass isNil.
	self assert: ffiCall argumentTypes size = 1.
	ffiCall argumentTypes with: (Array with: ExtCallArgSDWORD)
		do: 
			[:eachArg :eachType |
			self assert: eachArg typeOrdinal = eachType.
			self assert: eachArg indirections = 0.
			self assert: eachArg structClass isNil].

	"Void is not a valid argument type (can only be used for return)"
	self
		should: [SmalltalkParser parseMethod: 'blah: x <stdcall: void blah void>']
		raise: SmalltalkParser errorClass
		matching: [:err | err errorCode = CErrArgTypeCannotBeVoid].

	"Mismatch between Smalltalk arguments and external argument types."
	self should: [SmalltalkParser parseMethod: 'blah: x _: y <stdcall: void blah void>']
		raise: SmalltalkParser errorClass.


	"Many simple args"
	src := String writeStream.
	types := #('lpvoid' 'char' 'byte' 'sbyte' 'word' 'sword' 'dword' 'sdword' 'bool' 'handle' 'double' 'lpstr' 'oop' 'float' 'lppvoid' 'hresult' 'lpwstr' 'qword' 'sqword' 'ote' 'bstr' 'variant' 'date' 'varbool' 'guid').
	types do: 
			[:each |
			src
				nextPutAll: each;
				nextPutAll: ': ';
				nextPutAll: each]
		separatedBy: [src space].
	src
		crtab;
		nextPutAll: '<stdcall: void fn'.
	types do: 
			[:each |
			src
				space;
				nextPutAll: each].
	src nextPut: $>.
	src := src contents.
	tree := SmalltalkParser parseMethod: src.
	self assert: tree formattedCode trimBlanks = src.
	ffiCall := tree tag.
	self assert: ffiCall argumentTypes size = types size.
	ffiCall argumentTypes with: (1 to: types size)
		do: 
			[:eachArg :eachType |
			self assert: eachArg typeOrdinal = eachType.
			self assert: eachArg indirections = 0.
			self assert: eachArg structClass isNil]!

testFormatter
	| class |
	class := ClassBuilder class.
	class selectors do: 
			[:each | 
			self compare: (class parseTreeFor: each)
				to: (self parserClass 
						parseMethod: (class parseTreeFor: each) printString)]!

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
								ifTrue: [self parserClass parseMethod: source]
								ifFalse: [self parserClass parseExpression: source].
					self compare: each to: newNode]]!

testIsA
	| nodes types |
	nodes := Bag new.
	types := Set new.
	#(#(#isAssignment 1) #(#isBlock 1) #(#isCascade 1) #(#isLiteralNode 2) #(#isMessage 3) #(#isMethod 1) #(#isReturn 1) #(#isSequence 2) #(#isValue 15) #(#isVariable 7) #(#isUsed 10) #(#isDirectlyUsed 9) #(#hasParentheses 1) #(#isBinary 0) #(#isPrimitive 0) #(#isImmediateNode 10)) 
		do: 
			[:each | 
			each last timesRepeat: [nodes add: each first].
			types add: each first].
	self treeWithEverything nodesDo: 
			[:each | 
			types do: 
					[:sel | 
					((each respondsTo: sel) and: [each perform: sel]) 
						ifTrue: [nodes remove: sel]]].
	self assert: nodes isEmpty!

testLiteralIntevals
	| tree |
	tree := self parserClass parseExpression: '#(#a b #( c ))'.
	self assert: tree contents first start = 3.
	self assert: tree contents first stop = 4.
	self assert: tree contents last contents first start = 11!

testLiterals
	self assert: (StLiteralNode value: #(1 2 #(#asdf))) formattedCode 
				= '#(1 2 #(#asdf))'!

testMethodPatterns
	#(#('+ a ^self + a' #+) #('foo ^self foo' #foo) #('foo: a bar: b ^a + b' #foo:bar:)) 
		do: 
			[:each | 
			self assert: (self parserClass parseMethodPattern: each first) 
						== each last]!

testMultimatch
	| rewriter count |
	count := 0.
	rewriter := ParseTreeRewriter new.
	rewriter 
		replace: '``@object at: ``@foo'
		with: '``@object foo: ``@foo'
		when: [:aNode | (count := count + 1) == 2].
	self compare: (rewriter
				executeTree: (self parserClass parseExpression: 'self at: (bar at: 3)');
				tree)
		to: (self parserClass parseExpression: 'self at: (bar foo: 3)')!

testNodesDo
	| size |
	size := 0.
	self treeWithEverything nodesDo: [:e | size := size + 1].
	self assert: size = 19!

testNumberParsing
	2 to: 32
		do: 
			[:radix | 
			0 to: 72
				do: 
					[:i | 
					self 
						assert: (self parserClass 
								parseExpression: (i printStringRadix: radix)) value 
								= i]]!

testParsingLiteralMessages
	self 
		assert: (self parserClass parseExpression: 'self nil') isMessage.
	self 
		assert: (self parserClass parseExpression: 'self true') isMessage.
	self 
		assert: (self parserClass parseExpression: 'self false') isMessage.
	self assert: (self parserClass parseExpression: 'self -1') isMessage!

testPatternCascade
	| rewriter |
	rewriter := ParseTreeRewriter new.
	rewriter replace: 'self `;messages; foo: 4; `;messages1'
		with: 'self `;messages1; bar: 4; `;messages'.
	self compare: (rewriter
				executeTree: (self parserClass 
							parseExpression: 'self foo; printString; foo: 4; bar. self foo: 4');
				tree)
		to: (self parserClass 
				parseExpression: 'self bar; bar: 4; foo; printString. self foo:4')!

testPositions
	| blockNode optimized |
	blockNode := self parserClass parseExpression: '[:a :b | ]'.
	self assert: blockNode left = 1.
	self assert: blockNode right = 10.
	self assert: blockNode bar = 8.
	self assert: blockNode sourceInterval = (1 to: 10).
	self assert: blockNode size = 1.	"test dummy collection protocol"
	blockNode printString.	"coverage"
	self deny: (blockNode isLast: (StVariableNode named: 'b')).
	self compare: blockNode
		to: (StBlockNode 
				arguments: (OrderedCollection with: (StVariableNode named: 'a')
						with: (StVariableNode named: 'b'))
				body: (StSequenceNode statements: #())).
	optimized := self parserClass parseExpression: '(##(| a | a := 5. a * a))'.
	self assert: optimized startWithoutParentheses = 2.
	self assert: optimized stopWithoutParentheses = 24.
	self assert: (optimized 
				equalTo: (self parserClass parseExpression: '##(| b | b := 5. b * b)')
				exceptForVariables: #()).
	self assert: optimized isImmediateNode.
	self nodeVisitorClass new visitNode: optimized.
!

testPrimitives
	self assert: (Object parseTreeFor: #basicAt:) isPrimitive.
	#(#('foo ^true' false) #('foo <stdcall: void sleep> ^true' true) #('foo <overlap stdcall: void sleep> ^true' true) #('foo <virtual stdcall: void 6> ^true' true) #(' foo <primitive: 123> ^true' true)) 
		do: [:each | self assert: (RBParser parseMethod: each first) isPrimitive = each last].
	self should: [RBParser parseMethod: 'foo <some tag> ^true'] raise: SmalltalkParser errorClass!

testQuerying
	| tree aNode arg1Node bNode |
	tree := self parserClass 
				parseMethod: ('test: a`	| b |`	b := (self foo: a; bar) baz.`	b := super test: b.`	^[:arg1 | self foa1 + (super foo: arg1 foo: a foo: b)]' 
						copyReplaceAll: '`'
						with: (String with: (Character value: 13))).
	self 
		assert: tree selfMessages asSortedCollection asArray = #(#bar #foa1 #foo:).
	self assert: tree superMessages asSortedCollection asArray 
				= #(#foo:foo:foo: #test:).
	aNode := tree whichNodeIsContainedBy: (112 to: 112).
	self assert: aNode name = 'a'.
	bNode := tree whichNodeIsContainedBy: (119 to: 119).
	self assert: bNode name = 'b'.
	arg1Node := tree whichNodeIsContainedBy: (102 to: 105).
	self assert: arg1Node name = 'arg1'.
	self assert: (arg1Node statementNode isMessage 
				and: [arg1Node statementNode selector = #+]).
	self assert: (arg1Node whoDefines: 'arg1') isBlock.
	self assert: (aNode whoDefines: 'a') isMethod.
	self assert: (aNode whoDefines: 'b') isSequence.
	self assert: (tree whichNodeIsContainedBy: (91 to: 119)) selector 
				= #foo:foo:foo:.
	self assert: (tree whichNodeIsContainedBy: (69 to: 121)) isBlock.
	self assert: (tree whichNodeIsContainedBy: (69 to: 118)) isNil.
	self assert: aNode blockVariables asSortedCollection asArray = #('arg1').
	self assert: aNode temporaryVariables asSortedCollection asArray = #('b').
	self assert: tree allDefinedVariables asSortedCollection asArray 
				= #('a' 'arg1' 'b').
	self assert: tree allArgumentVariables asSortedCollection asArray 
				= #('a' 'arg1').
	self 
		assert: tree allTemporaryVariables asSortedCollection asArray = #('b')!

testRewrites
	"#('#{Object}' 'Object' '#{Object}' 'Object') #('Smalltalk.Object' 'Smalltalk.Object printString' '`var' '`var printString') #('Smalltalk. Object' 'Smalltalk printString. Object printString' '`var' '`var printString')"

	#(#('[:c | |a| a foo1; foo2]' '[:c | |a| b foo1; foo2]' 'a' 'b') #('self foo: 1. bar foo1 foo: 2. (self foo: a) foo: (b foo: c)' 'self bar: 1. bar foo1 bar: 2. (self bar: a) bar: (b bar: c)' '``@rcvr foo: ``@arg1' '``@rcvr bar: ``@arg1') #('3 + 4' '4 + 4' '3' '4') #('a := self a' 'b := self a' 'a' 'b') #('^self at: 1 put: 2' '^self put: 1 put: 2' '^`@rcvr `at: `@arg1 put: `@arg2' '^`@rcvr put: `@arg1 put: `@arg2') #('1 + 2 + 3' '0 + 0 + 0' '`#literal' '0') #('1 + 2 + 3. 3 foo: 4' '3 + (2 + 1). 4 foo: 3' '``@rcvr `msg: ``@arg' '``@arg `msg: ``@rcvr') #('self foo: a bar: b. 1 foo: a bar: b' '2 foo: a bar: b. 1 foo: a bar: b' 'self `@msg: `@args' '2 `@msg: `@args') #('a := b. a := c + d' 'b := a. a := c + d' '`var1 := `var2' '`var2 := `var1') #('^self foo value: 1' 'self return: (self foo value: 1)' '^`@anything' 'self return: `@anything') #('self first; second. self first; second. self a. self b' '2 timesRepeat: [self first; second]. self a. self b' '`.Stmt1. `.Stmt1. `@.stmts' '2 timesRepeat: [`.Stmt1]. `@.stmts') #('[:a | self a: 1 c: 2; b]' '[:a | self d: 2 e: 1; f. self halt]' '`@rcvr `msg1: `@arg1 `msg2: `@arg2; `msg' '`@rcvr d: `@arg2 e: `@arg1; f. self halt')) 
		do: 
			[:each | 
			| rewrite |
			rewrite := ParseTreeRewriter new.
			rewrite replace: (each at: 3) with: each last.
			self compare: (self parserClass 
						parseExpression: (rewrite
								executeTree: (self parserClass parseExpression: each first);
								tree) formattedCode)
				to: (self parserClass parseExpression: (each at: 2))]!

testSearching
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv at: ``@arg `sel: ``@arg1'
		do: [:aNode :answer | answer + 1].
	self 
		assert: (searcher executeTree: (self parserClass 
						parseExpression: 'self at: 1 put: 2; at: 2 ifAbsent: []; ifAbsent: 2 at: 1; at: 4; foo')
				initialAnswer: 0) = 2.
	searcher := ParseTreeSearcher new.
	searcher matches: '``@rcv `at: ``@arg1 `at: ``@arg2'
		do: [:aNode :answer | answer + 1].
	self 
		assert: (searcher executeTree: (self parserClass 
						parseExpression: 'self at: 1 at: 3; at: 1 put: 32; at: 2; foo; at: 1 at: 1 at: 2')
				initialAnswer: 0) = 1.
	searcher := ParseTreeSearcher new.
	searcher matchesMethod: 'at: `object `put: `o1 ``@rcv `put: 1'
		do: [:aNode :answer | true].
	self assert: (searcher 
				executeTree: (self parserClass parseMethod: 'at: a put: b self foo put: 1')
				initialAnswer: false)!

testTokens
	| tokens scanner |
	scanner := self scannerClass on: '#foo foo: bar := [ ##( + foo::bar::baz' readStream. 
	scanner namespaceCharacter: $:.
	tokens := scanner contents.
	tokens printString.
	tokens with: #(4 4 3 2 1 3 1 13)
		do: [:token :length | self assert: token length = length]!

treeWithEverything
	^self parserClass 
		parseMethod: 'method: arg1 | temps | temps := #(10). temps foo; foo. ^(temps collect: [:e | ])'!

verifyParser
	"
	self new verifyParser
	"

	Smalltalk allBehaviorsDo: 
			[:each | 
			each compilerClass = Compiler 
				ifTrue: [each selectors do: [:sel | self verifySelector: sel inClass: each]]]!

verifySelector: aSelector inClass: aClass 
	| myTree source |
	source := aClass sourceCodeAt: aSelector.
	source isNil ifTrue: [^self].
	myTree := aClass parseTreeFor: aSelector.
	self assert: myTree notNil.
	self assert: ((Compiler 
		compile: myTree formattedCode
		in: aClass) 
			isEqualTo: (Compiler 
				compile: source
				in: aClass))
! !
!SmalltalkParserTest categoriesFor: #buildArgumentSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #buildMessageSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #buildMethodArgumentSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #buildMethodSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #buildMethodTitleSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #buildSimpleLiteralSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #buildSimpleVariableSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #buildStatementSearch!accessing!private! !
!SmalltalkParserTest categoriesFor: #compare:to:!accessing!private! !
!SmalltalkParserTest categoriesFor: #createArgumentSearchWith:selectors:inClass:!accessing!private! !
!SmalltalkParserTest categoriesFor: #createMethodSearchWith:selectors:inClass:!accessing!private! !
!SmalltalkParserTest categoriesFor: #createSearchWith:selectors:inClass:!accessing!private! !
!SmalltalkParserTest categoriesFor: #currentSelector!accessing!private! !
!SmalltalkParserTest categoriesFor: #errorSignal!constants!private! !
!SmalltalkParserTest categoriesFor: #forwarded1!helpers!private! !
!SmalltalkParserTest categoriesFor: #forwarded2!helpers!private! !
!SmalltalkParserTest categoriesFor: #lintProtocols!accessing!private! !
!SmalltalkParserTest categoriesFor: #nodeVisitorClass!constants!private! !
!SmalltalkParserTest categoriesFor: #parserClass!constants!private! !
!SmalltalkParserTest categoriesFor: #scannerClass!constants!private! !
!SmalltalkParserTest categoriesFor: #setUp!accessing!public! !
!SmalltalkParserTest categoriesFor: #testAllSearches!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testBestNodeFor!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testBlockRewrites!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testComparingTrees!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testCopy!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testCreationProtocol!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testEquality!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testEquivalentExceptRenaming!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testExtendedLiterals!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testExternalCallEquality!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testExternalCalls!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testFormatter!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testIntervals!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testIsA!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testLiteralIntevals!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testLiterals!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testMethodPatterns!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testMultimatch!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testNodesDo!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testNumberParsing!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testParsingLiteralMessages!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testPatternCascade!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testPositions!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testPrimitives!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testQuerying!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testRewrites!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testSearching!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testTokens!public!unit tests! !
!SmalltalkParserTest categoriesFor: #treeWithEverything!helpers!private! !
!SmalltalkParserTest categoriesFor: #verifyParser!long running!public! !
!SmalltalkParserTest categoriesFor: #verifySelector:inClass:!helpers!private! !

!SmalltalkParserTest class methodsFor!

parserClass
	^SmalltalkParser! !
!SmalltalkParserTest class categoriesFor: #parserClass!accessing!public! !

