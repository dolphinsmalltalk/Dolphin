"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.ParserTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{External.ExtCallArgTypes} #{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.ParserTest guid: (Core.GUID fromString: '{947b6d13-1a2a-43c0-8053-bde0fccfbd44}')!
Kernel.Tests.ParserTest comment: 'SUnitBrowser openOnTestCase: self'!
!Kernel.Tests.ParserTest categoriesForClass!Refactory-Testing! !
!Kernel.Tests.ParserTest methodsFor!

assertTree: anObject equals: anotherObject
	self assert: anObject hash equals: anotherObject hash.
	self assert: anObject equals: anotherObject!

compare: anObject to: anotherObject
	self assert: anObject hash equals: anotherObject hash.
	self assert: anObject equals: anotherObject!

exampleClasses
	^{Parser. Scanner. StProgramNode}!

isEquivalentMethod: method1 to: method2
	| count |
	method1 == method2 ifTrue: [^true].
	method1 class = method2 class ifFalse: [^false].
	method1 byteCodes = method2 byteCodes ifFalse: [^false].
	count := method1 literalCount.
	method2 literalCount = count ifFalse: [^false].
	^method1 disassembly = method2 disassembly!

parseAll
	"
	self new parseAll
	"

	| progress errorsPresenter errors |
	errorsPresenter := UI.ListPresenter show.
	errors := errorsPresenter model.
	progress := UI.ProgressDialog create.
	progress operation: 
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
									[tree := method parseTree] on: Parser errorClass do: [:ex | errors add: method -> ex].
									tree isNil
										ifFalse: 
											[| namespace |
											namespace := method customEnvironment.
											(self isEquivalentMethod: (Compiler
														compile: tree formattedCode
														in: each
														environment: namespace)
												to: (Compiler
														compile: method getSource
														in: each
														environment: namespace))
													ifFalse: [errors add: method -> 'Mismatched parse trees']]]]].
			errors].
	^progress showModal!

parseExpression: aString
	^self parserClass parseExpression: aString!

parseFaultyExpression: aString
	^[self parserClass parseExpression: aString] on: CompilerErrorNotification do: [:ex | ex resume]!

parseMethod: aString
	^self parserClass parseMethod: aString!

parserClass
	^Parser!

testAnnotationEquality
	| tags parseTree |
	parseTree := self parseMethod: 'test <namespace: XProgramming> <mutable> <namespace: Core>'.
	tags := parseTree tags.
	1 to: tags size
		do: [:i | 1 to: tags size do: [:j | self deny: ((tags at: i) = (tags at: j) xor: i = j)]]!

testAnnotationParents
	| ast annotation annotationArg |
	ast := self parseMethod: 'test <namespace: XProgramming>'.
	annotation := ast tags first.
	self assert: annotation parent identicalTo: ast.
	self assert: annotation methodNode identicalTo: ast.
	annotationArg := annotation arguments first.
	self assert: annotationArg parent identicalTo: annotation.
	self assert: annotationArg methodNode identicalTo: ast!

testArray
	| tree allowEmpty |
	allowEmpty := Parser allowEmptyStatements.
	Parser allowEmptyStatements: true.
	
	[#(#('{}' 0 0) #('{.}' 0 1) #('{..}' 0 2) #('{foo. bar}' 2 1) #('{foo. bar.}' 2 2) #('{foo. bar. .}' 2 3) #('{. foo. bar}' 2 2) #('{foo.. bar}' 2 2))
		do: 
			[:each |
			tree := self parseExpression: each first.
			self assert: tree statements size equals: each second.
			self assert: tree periods size equals: each last.
			self assert: tree left equals: 1.
			self assert: tree right equals: each first size]]
			ensure: [Parser allowEmptyStatements: allowEmpty]!

testBestNodeFor
	| tree |
	tree := self treeWithAllNodeTypes.
	tree nodesDo: 
			[:each |
			each sourceInterval notEmpty
				ifTrue: 
					[| bestNode |
					bestNode := tree bestNodeFor: each sourceInterval.
					self
						assert: (bestNode == each or: 
									[(bestNode parent == each and: [bestNode sourceInterval = each sourceInterval])
										or: [each parent isCascade and: [each parent messages last = each]]])]]!

testBinarySelectors
	"ANSI Smalltalk Standard Draft, page 32:
		binaryCharacter ::=
			'!!' | '%' | '&' | '*' | '+' | ','' | '/' | '<' | '=' | '>' | '?' | '@' | '\' | '~' | '|' | '-'
		binarySelector ::= binaryCharacter+"

	| binaryCharacters selectorStrings binaryCharacters2 |
	"Create a collection of strings to parse.
	 The collection is made of every possible string sized from 1 to 3 selectors."
	binaryCharacters := '!!%&*+,/<=>?@\~-'.
	#todo.	"However, we deliberately excluded $- other than as the first char. This was done for backwards compatibility with the historical treatment of expressions such as 1--2, but perhaps it is time to remove this."
	binaryCharacters2 := binaryCharacters copyWithout: $-.
	selectorStrings := OrderedCollection new.
	binaryCharacters do: 
			[:first |
			selectorStrings addLast: (String with: first).
			binaryCharacters2 do: 
					[:second |
					selectorStrings addLast: (String with: first with: second).
					binaryCharacters2 do: 
							[:third |
							selectorStrings addLast: (String
										with: first
										with: second
										with: third)]]].

	""
	selectorStrings do: 
			[:each |
			| methodNode messageNode |
			methodNode := self parseMethod: each , 'anObject
	^self' , each , 'anObject'.
			self assert: methodNode selector equals: each asSymbol.
			self assert: methodNode argumentNames asArray equals: #(#anObject).
			self assert: methodNode statements size equals: 1.
			messageNode := methodNode statements first value.
			self assert: messageNode isMessage.
			self assert: messageNode receiver name equals: #self.
			self assert: messageNode selector equals: each asSymbol.
			self assert: messageNode arguments size equals: 1.
			self assert: messageNode arguments first isValue.
			self assert: messageNode arguments first name equals: #anObject]!

testBlockNodeIsUsed
	| tree |
	" block node is not a used-node"
	tree := self parserClass parseMethod: 'tmp [ 3+4 ]'.
	self deny: tree body statements last isUsed.
	" even a block node with non-local return is not *used* "
	tree := self parserClass parseMethod: 'tmp [^ 3+4 ]'.
	self deny: tree body statements last isUsed.

	"an explicit return node is *used*"
	tree := self parserClass parseMethod: 'tmp ^[ 3+4 ]'.
	self assert: tree body statements last isUsed!

testBlockReturnNode
	| tree |
	" no explicit return"
	tree := self parserClass parseMethod: 'tmp [ 3+4 ]'.
	self deny: tree lastIsReturn.
	" no explicit return the block local return should not count as method return "
	tree := self parserClass parseMethod: 'tmp [^ 3+4 ]'.
	self deny: tree lastIsReturn.

	" explicit return"
	tree := self parserClass parseMethod: 'tmp ^ [ 3+4 ]'.
	self assert: tree lastIsReturn!

testCascade
	self assert: (self parserClass parseExpression: ' self msg; yourself') isCascade.
	self assert: (self parserClass parseExpression: ' self msg:(arg msg:arg); yourself') isCascade.
	self assert: (self parserClass parseExpression: ' (self msg); yourself') isCascade.
	self should: [self parserClass parseExpression: ' self ; yourself'] raise: CompilerErrorNotification.
	self should: [self parserClass parseExpression: ' (self) ; yourself']
		raise: CompilerErrorNotification.
	self should: [self parseExpression: ' self msg ;  ; yourself'] raise: CompilerErrorNotification!

testCascadeReplacement
	"Cascade is composed of an ordered collection of messages, each with the same receiver."

	| cascade |
	cascade := self parserClass parseExpression: 'self foo; bar; baz'.
	"The replacement is made on the collection."
	(cascade messages at: 2) replaceWith: (self parserClass parseExpression: 'self bar: 2').
	self assert: cascade equals: (self parserClass parseExpression: 'self foo; bar: 2; baz').

	"The replacement can be a message with another receiver"
	(cascade messages at: 3) replaceWith: (self parserClass parseExpression: 'notself barataba').
	self assert: (cascade messages at: 3) receiver equals: (self parserClass parseExpression: 'notself')!

testComparingTrees
	self compare: self treeWithAllNodeTypes to: self treeWithAllNodeTypes.
	self exampleClasses do: 
			[:class |
			class methodsDo: 
					[:method |
					| src |
					src := method getSource.
					self compare: (self parseMethod: src) to: (self parseMethod: src)]]!

testCopy
	| tree copy |
	tree := self treeWithAllNodeTypes.
	self verifyParentLinksInTree: tree.
	copy := tree copy.
	self assertTree: tree equals: copy.
	"This does rely on the implementation of #childrenDo: on each node being correct. It is easy to define a new node type with chilren and forget to ensure it enumerates its children."
	self verifyTree: copy isDeepCopyOf: tree.
	{Parser. Scanner. StProgramNode} do: 
			[:class |
			class selectors do: 
					[:each |
					| copy |
					tree := class parseTreeFor: each.
					copy := tree copy.
					self verifyTree: copy isDeepCopyOf: tree]]!

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
						deny: ((self parseExpression: (strings at: i)) = (self parseExpression: (strings at: j)) xor: i = j)]]!

testEquivalentExceptRenaming
	#(#('a 3-4' 'a 4-3' false) #('a #[3 4]' 'a #(3 4)' false) #('a variable1 ~~ "comment" variable2' 'a variable1 ~~ variable2' true) #('a variable1' 'a variable2' false) #('a [:a :b | a + b]' 'a [:b :a | a + b]' false) #('a | a b | a + b' 'a | b a | a + b' true) #('a | a | a msg1; msg2' 'a | b | b msg2; msg2' false) #('a c' 'a d' true) #('a | a b | a := b. ^b msg1' 'a | a b | b := a. ^a msg1' true) #('a | a b | a := b. ^b msg1: a' 'a | a b | b := a. ^b msg1: a' false) #('a: b b + 4' 'a: e e + 4' true) #('a: b b + 4' 'b: b b + 4' false) #('a: b b: c b + c' 'a: c b: b c + b' true) #('a: a b: b a + b' 'a: b b: a a + b' false) #('a ^#()' 'a ^#(a)' false))
		do: 
			[:each |
			self assert: ((self parseMethod: each first) equalTo: (self parseMethod: (each at: 2))
						exceptForVariables: #('c'))
				identicalTo: each last]!

testExpressionSolver
	#(#('y := 3' nil) #('x := 3' 'x := 3') #('y := x' 'x := y') #('y := x + 1' 'x := y - 1') #('y := x >> 2 - 1' 'x := y + 1 << 2') #('y := 1+z/x' 'x := (1 + z) / y') #('y := a - ((b / x) * c)' 'x := b / ((a - y) / c)') #('y := (m*x)+b' 'x := (y - b) / m') #('y := (m/x)-b' 'x := m / (y + b)' #('y:=a-c*x/(d-e)-f')))
		do: 
			[:pair |
			| expr solution case |
			case := pair first.
			expr := self parseExpression: case.
			(case includes: 'y')
				ifTrue: 
					[solution := expr solveFor: 'y'.
					self assert: solution identicalTo: expr].
			solution := expr solveFor: 'x'.
			pair second
				ifNil: [self assertIsNil: solution]
				ifNotNil: [:expected | self assert: solution formattedCode equals: expected]]!

testExternalCallChildren
	| parseTree children child tag grandChild |
	parseTree := self parseMethod: 'test: a test: b <stdcall: void blah POINTL dword>'.
	tag := parseTree tags first.
	self assert: tag parent identicalTo: parseTree.
	self assert: tag isKindOf: StExternalCallNode.
	self assert: tag selector identicalTo: #stdcall:.
	children := tag children.
	self assert: children size equals: 3.
	child := children first.
	self assert: child isKindOf: StExternalArgTypeNode.
	self assert: child children isEmpty.
	self assert: child parent identicalTo: tag.
	child := children second.
	self assert: child isKindOf: StExternalArgTypeNode.
	self assert: child children size equals: 1.
	self assert: child parent identicalTo: tag.
	grandChild := child children first.
	self assert: grandChild isKindOf: StBasicVariableNode.
	self assert: grandChild name equals: 'POINTL'.
	self assert: grandChild parent identicalTo: child.
	child := children third.
	self assert: child isKindOf: StExternalArgTypeNode.
	self assert: child children isEmpty.
	self assert: child parent identicalTo: tag!

testExternalCallEquality
	| strings |
	strings := #('test <stdcall: void Test>' 'test <overlap stdcall: void Test>' 'test: a <stdcall: void Test dword>').
	1 to: strings size
		do: 
			[:i |
			1 to: strings size
				do: [:j | self deny: ((self parseMethod: (strings at: i)) = (self parseMethod: (strings at: j)) xor: i = j)]]!

testExternalCalls
	| ffiCall tree src types reformatted |
	self assert: (KernelLibrary parseTreeFor: #loadLibraryEx:hFile:dwFlags:) isPrimitive.
	"Zero args"
	tree := self parseMethod: 'blah <stdcall: void blah>'.
	self assert: tree formattedCode trimBlanks equals: 'blah
	<stdcall: void blah>'.
	ffiCall := tree tags first.
	self assert: ffiCall methodNode identicalTo: tree.
	self assert: ffiCall argumentTypes isEmpty.
	self assert: ffiCall returnType typeOrdinal equals: ExtCallArgVOID.
	self assert: ffiCall returnType indirections equals: 0.
	self assertIsNil: ffiCall returnType structClass.
	self assert: ffiCall selector identicalTo: #stdcall:.
	self assert: (ffiCall defines: '_failureCode').

	"One simple arg"
	tree := self parseMethod: 'blah: x <cdecl: dword blah sdword>'.
	self assert: tree formattedCode trimBlanks equals: 'blah: x
	<cdecl: uint32 blah int32>'.
	ffiCall := tree tags first.
	self assert: ffiCall returnType typeOrdinal equals: ExtCallArgUInt32.
	self assert: ffiCall returnType indirections equals: 0.
	self assertIsNil: ffiCall returnType structClass.
	self assert: ffiCall argumentTypes size equals: 1.
	self assert: ffiCall selector identicalTo: #cdecl:.
	ffiCall argumentTypes with: { ExtCallArgInt32 }
		do: 
			[:eachArg :eachType |
			self assert: eachArg typeOrdinal equals: eachType.
			self assert: eachArg indirections equals: 0.
			self assertIsNil: eachArg structClass].

	"Void is not a valid argument type (can only be used for return)"
	self
		should: [self parseMethod: 'blah: x <stdcall: void blah void>']
		raise: self parserClass errorClass
		matching: [:err | err errorCode = CErrArgTypeCannotBeVoid].

	"Mismatch between Smalltalk arguments and external argument types."
	self should: [self parseMethod: 'blah: x _: y <stdcall: void blah void>']
		raise: self parserClass errorClass.


	"Many simple args"
	src := String writeStream.
	types := #('lpvoid' 'char' 'uint8' 'int8' 'uint16' 'int16' 'uint32' 'int32' 'bool' 'handle' 'double' 'lpstr' 'oop' 'float' 'lppvoid' 'hresult' 'lpwstr' 'uint64' 'int64' 'ote' 'bstr' 'variant' 'date' 'varbool' 'guid' 'uintptr' 'intptr' 'ntstatus' 'errno' 'bool8' 'char32' 'char16' 'char8' 'lpstr8').
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
	tree := self parseMethod: src.
	reformatted := tree formattedCode trimBlanks.
	self assert: reformatted equals: src.
	ffiCall := tree tags first.
	self assert: ffiCall argumentTypes size equals: types size.
	ffiCall argumentTypes with: (1 to: types size)
		do: 
			[:eachArg :eachType |
			self assert: eachArg typeOrdinal equals: eachType.
			self assert: eachArg indirections equals: 0.
			self assertIsNil: eachArg structClass]!

testIntervals
	| tree |
	"treeWithEverything no longer contains everything. It is missing tags and brace array nodes. Tags are not parsable as expressions though."
	tree := self treeWithEverything.
	tree nodesDo: 
			[:each |
			(each parent isNil or: [each parent isCascade not])
				ifTrue: 
					[| newNode source |
					source := tree source copyFrom: each start to: each stop.
					newNode := each isMethod ifTrue: [self parseMethod: source] ifFalse: [self parseExpression: source].
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

testKeywordAnnotationChildren
	| parseTree children child annotation |
	parseTree := self parseMethod: 'test <namespace: XProgramming>'.
	annotation := parseTree tags first.
	self assert: annotation parent identicalTo: parseTree.
	self assert: annotation isKindOf: StAnnotationNode.
	self assert: annotation selector identicalTo: #namespace:.
	children := annotation children.
	self assert: children size equals: 1.
	child := children first.
	self assert: child isKindOf: StBasicVariableNode.
	self assert: child name equals: 'XProgramming'.
	self assert: child parent identicalTo: annotation.!

testLiteralIntevals
	| tree |
	tree := self parseExpression: '#(#a b #( c ))'.
	self assert: tree contents first start equals: 3.
	self assert: tree contents first stop equals: 4.
	self assert: tree contents last contents first start equals: 11!

testLiteralMessages
	#('true' 'false' 'nil') with: #(true false nil)
		do: 
			[:string :literal |
			self assert: (self parseMethod: ('<1s> ^<1s>
<1s>' expandMacrosWith: string))
				equals: (StMethodNode selector: string asSymbol
						body: (StSequenceNode
								statements: {StReturnNode
											value: (StMessageNode receiver: (StLiteralNode value: literal) selector: string asSymbol)}))]!

testMethodPatterns
	#(#('+ a ^self + a' #+) #('foo ^self foo' #foo) #('foo: a bar: b ^a + b' #foo:bar:))
		do: [:each | self assert: (Parser parseMethodPattern: each first) identicalTo: each last]!

testModifying
	| tree |
	tree := self parseMethod: 'foo: a bar: b | c | self first. self second. a + b + c'.
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
	tree body
		addTemporaryNamed: 'd';
		removeTemporaryNamed: 'c'.
	self compare: tree to: (self parseMethod: 'bar: a foo: b | d | self first. self second. ^a + b + c').
	self assert: (tree argumentNames asSet
				removeAll: #('a' 'b');
				yourself) isEmpty.
	self assert: (tree allDefinedVariables asSet
				removeAll: #('a' 'b' 'd');
				yourself) isEmpty.
	tree := self parseExpression: 'self foo: 0'.
	tree selector: #+.
	self compare: tree to: (self parseExpression: 'self + 0').
	self
		should: [tree selector: #foo]
		raise: Error
		matching: [:ex | ex messageText = 'Attempting to assign selector with wrong number of arguments.']!

testNodesDoAll
	| size parseTree nodeTypes concreteNodeTypes |
	size := 0.
	parseTree := self treeWithAllNodeTypes.
	nodeTypes := Bag new.
	parseTree nodesDo: 
			[:each |
			"Test the parent chain while we are here"
			self assert: each methodNode identicalTo: parseTree.
			nodeTypes add: each class.
			size := size + 1].
	"Check that we've really covered all the node types (except pattern nodes)"
	concreteNodeTypes := StProgramNode withAllSubclasses
				select: [:each | each isAbstract not and: [each owningPackage == StProgramNode owningPackage]].
	self assert: (concreteNodeTypes difference: nodeTypes) asArray equals: #().
	self assert: size equals: 42!

testNumberParsing
	2 to: 32
		do: 
			[:radix |
			0 to: 72 do: [:i | self assert: (self parseExpression: (i printStringRadix: radix)) value equals: i]]!

testParsingLiteralMessages
	self assert: (self parseExpression: 'self nil') isMessage.
	self assert: (self parseExpression: 'self true') isMessage.
	self assert: (self parseExpression: 'self false') isMessage.
	self assert: (self parseExpression: 'self -1') isMessage!

testPositions
	| blockNode optimized |
	blockNode := self parseExpression: '[:a :b | ]'.
	self assert: blockNode left equals: 1.
	self assert: blockNode right equals: 10.
	self assert: blockNode bar equals: 8.
	self assert: blockNode sourceInterval equals: (1 to: 10).
	self assert: blockNode size equals: 1.	"test dummy collection protocol"
	blockNode printString.	"coverage"
	self deny: (blockNode isLast: (StBasicVariableNode named: 'b')).
	self compare: blockNode
		to: (StBlockNode
				arguments: (OrderedCollection with: (StParameterNode named: 'a') with: (StParameterNode named: 'b'))
				body: (StSequenceNode statements: #())).
	optimized := self parseExpression: '(##(| a | a := 5. a * a))'.
	self assert: optimized startWithoutParentheses equals: 2.
	self assert: optimized stopWithoutParentheses equals: 24.
	self
		assert: (optimized equalTo: (self parseExpression: '##(| b | b := 5. b * b)') exceptForVariables: #()).
	self assert: optimized isImmediateNode.
	ParseNodeVisitor new visitNode: optimized.
	optimized body replaceWith: (self parseExpression: '| c | c := 5. c * 45').
	self compare: optimized to: (self parseExpression: '##(| c | c := 5. c * 45)')!

testPrimitives
	self assert: (Object parseTreeFor: #basicAt:) isPrimitive.
	#(#('foo ^true' false) #('foo <stdcall: void sleep> ^true' true) #('foo <overlap stdcall: void sleep> ^true' true) #('foo <virtual stdcall: void 1> ^true' true) #(' foo <primitive: 123> ^true' true))
		do: [:each | self assert: (self parseMethod: each first) isPrimitive equals: each last].
	self should: [self parseMethod: 'foo <some tag> ^true'] raise: Parser errorClass!

testPrimitiveTagChildren
	| parseTree tag errorTempDecl |
	parseTree := self parseMethod: 'test <primitive: 123>'.
	tag := parseTree tags first.
	self assert: tag parent identicalTo: parseTree.
	self assert: tag isKindOf: StPrimitiveNode.
	self assert: tag selector identicalTo: #primitive:.
	self assert: tag children size equals: 0.
	self assert: (tag defines: '_failureCode').
	parseTree := self parseMethod: 'test <primitive: 123 error: ec>'.
	tag := parseTree tags first.
	self assert: tag isKindOf: StPrimitiveNode.
	self assert: tag selector identicalTo: #primitive:error:.
	self assert: tag children size equals: 1.
	self assert: (tag defines: 'ec').
	errorTempDecl := tag children first.
	self assert: errorTempDecl parent identicalTo: tag.
	self assert: errorTempDecl isKindOf: StTempDeclNode.
	self assert: errorTempDecl name equals: 'ec'!

testQuerying
	| tree aNode arg1Node bNode |
	tree := self
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

testTokens
	| tokens scanner |
	scanner := Scanner on: '#foo foo: bar := [ ##( + foo.bar.baz' readStream.
	tokens := scanner upToEnd.
	tokens printString.
	tokens with: #(4 4 3 2 1 3 1 11) do: [:token :length | self assert: token length equals: length]!

testUnaryAnnotationChildren
	| parseTree annotation |
	parseTree := self parseMethod: 'test <mutable>'.
	annotation := parseTree tags first.
	self assert: annotation parent identicalTo: parseTree.
	self assert: annotation isKindOf: StAnnotationNode.
	self assert: annotation selector identicalTo: #mutable.
	self assert: annotation children size equals: 0!

treeWithAllNodeTypes
	^self
		parseMethod: 'method: arg1 
	<namespace: Core> 
	<primitive: 123 error: ec>
	<stdcall: SIZE blah POINTL* > 
	| temps | 
	super method: arg1. 
	thisContext. 
	temps := #(10 ##(#sequence -> true. #{Core.Object})). 
	self foo; foo. 
	^(temps collect: [:e | {e. #[127]} ])'!

treeWithEverything
	^self
		parseMethod: 'method: arg1 | temps | temps := #(10 ##(#sequence -> true. #optimized -> true)). temps foo; foo. ^(temps collect: [:e | ])'!

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

verifyTree: copiedNode isDeepCopyOf: originalNode
	self assert: originalNode class identicalTo: copiedNode class.
	self deny: originalNode identicalTo: copiedNode.
	self assert: originalNode equals: copiedNode.
	originalNode children with: copiedNode children
		do: 
			[:originalChild :copiedChild |
			self assert: copiedChild parent identicalTo: copiedNode.
			self verifyTree: copiedChild isDeepCopyOf: originalChild]! !
!Kernel.Tests.ParserTest categoriesForMethods!
assertTree:equals:!helpers!private! !
compare:to:!helpers!private! !
exampleClasses!private! !
isEquivalentMethod:to:!helpers!private! !
parseAll!long running!public! !
parseExpression:!helpers!private! !
parseFaultyExpression:!helpers!private! !
parseMethod:!helpers!private! !
parserClass!constants!private! !
testAnnotationEquality!public!unit tests! !
testAnnotationParents!public!unit tests! !
testArray!public!unit tests! !
testBestNodeFor!public!unit tests! !
testBinarySelectors!public!unit tests! !
testBlockNodeIsUsed!public!unit tests! !
testBlockReturnNode!public!unit tests! !
testCascade!public!unit tests! !
testCascadeReplacement!public!unit tests! !
testComparingTrees!public!unit tests! !
testCopy!public!unit tests! !
testEquality!public!unit tests! !
testEquivalentExceptRenaming!public!unit tests! !
testExpressionSolver!public!unit tests! !
testExternalCallChildren!public! !
testExternalCallEquality!public!unit tests! !
testExternalCalls!public!unit tests! !
testIntervals!public!unit tests! !
testIsA!public!unit tests! !
testKeywordAnnotationChildren!public! !
testLiteralIntevals!public!unit tests! !
testLiteralMessages!public!unit tests! !
testMethodPatterns!public!unit tests! !
testModifying!public!unit tests! !
testNodesDoAll!public!unit tests! !
testNumberParsing!public!unit tests! !
testParsingLiteralMessages!public!unit tests! !
testPositions!public!unit tests! !
testPrimitives!public!unit tests! !
testPrimitiveTagChildren!public!unit tests! !
testQuerying!public!unit tests! !
testTokens!public!unit tests! !
testUnaryAnnotationChildren!public!unit tests! !
treeWithAllNodeTypes!constants!private! !
treeWithEverything!private! !
verifyParentLinksInTree:!helpers!private! !
verifyTree:isDeepCopyOf:!helpers!private! !
!

