"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.ParserTest'
	instanceVariableNames: 'allowEmptyStatements'
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

foo <foo: 1 bar: 2>|t| t := 5. ^t!

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

parseMethod: aString
	^self parserClass parseMethod: aString!

parserClass
	^Parser!

setUp
	super setUp.
	allowEmptyStatements := self parserClass allowEmptyStatements!

tearDown
	self parserClass allowEmptyStatements: allowEmptyStatements.
	^super tearDown!

testAnnotationAndTempsNoSpace
	| method tag source body |
	source := 'foo<foo: 1 bar: 2>|t1 t2|'.
	method := self parserClass parseMethod: source.
	tag := method tags single.
	self assert: (source at: tag start) equals: $<.
	self assert: (source at: tag stop) equals: $>.
	self assert: tag sourceCode equals: (source copyFrom: (source indexOf: $<) to: (source indexOf: $>)).
	body := method body.
	self assert: body leftBar equals: (source indexOf: $|).
	self assert: body rightBar equals: source size.
	self assert: body temporaryNames asArray equals: #('t1' 't2')!

testAnnotationAndTempsNoSpace2
	| method source body |
	source := 'foo<foo: 1 bar: 2><foo>|t1 t2|'.
	method := self parserClass parseMethod: source.
	method tags inject: 1
		into: 
			[:i :tag |
			| start stop |
			start := source
						nextIndexOf: $<
						from: i
						to: source size.
			self assert: tag start equals: start.
			stop := source
						nextIndexOf: $>
						from: start
						to: source size.
			self assert: tag stop equals: stop.
			self assert: tag sourceCode equals: (source copyFrom: start to: stop).
			stop].
	body := method body.
	self assert: body leftBar equals: (source indexOf: $|).
	self assert: body rightBar equals: source size.
	self assert: body temporaryNames asArray equals: #('t1' 't2')!

testAnnotationEquality
	| tags parseTree |
	parseTree := self parseMethod: 'test <namespace: XProgramming> <mutable> <namespace: Core>'.
	tags := parseTree tags.
	1 to: tags size
		do: [:i | 1 to: tags size do: [:j | self deny: ((tags at: i) = (tags at: j) xor: i = j)]]!

testAnnotationParents
	| ast |
	ast := self parseMethod: 'test <namespace: XProgramming><foo: bar>'.
	ast tags do: 
			[:annotation |
			| annotationArg |
			self assert: annotation parent identicalTo: ast.
			self assert: annotation methodNode identicalTo: ast.
			annotationArg := annotation arguments first.
			self assert: annotationArg parent identicalTo: annotation.
			self assert: annotationArg methodNode identicalTo: ast]!

testArray
	Parser allowEmptyStatements: true.
	#(#('{}' 0 0) #('{.}' 0 1) #('{..}' 0 2) #('{foo. bar}' 2 1) #('{foo. bar.}' 2 2) #('{foo. bar. .}' 2 3) #('{. foo. bar}' 2 2) #('{foo.. bar}' 2 2))
		do: 
			[:each |
			| tree |
			tree := self parseExpression: each first.
			self assert: tree statements size equals: each second.
			self assert: tree periods size equals: each last.
			self assert: tree left equals: 1.
			self assert: tree right equals: each first size]!

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

testBlockWithArgsAndEmptyTemps
	| block source message |
	source := '[:a :b|||a+b]'.
	block := self parseExpression: source.
	self assert: block isBlock.
	self assert: block argumentNames asArray equals: #('a' 'b').
	self assert: block temporaryVariables equals: #().
	message := block body statements single.
	self assert: message selector equals: #+.
	self assert: message receiver isVariable.
	self assert: message receiver name equals: 'a'.
	self assert: message argument isVariable.
	self assert: message argument name equals: 'b'!

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

testCreationBlockNodeWithExpression
	self compare: (self parserClass parseExpression: '[:a :b | a messaged. b messaged.]')
		to: (StBlockNode
				arguments: (OrderedCollection with: (StVariableNode named: 'a') with: (StVariableNode named: 'b'))
				body: (StSequenceNode statements: (OrderedCollection
								with: (StMessageNode receiver: (StVariableNode named: #a) selector: #messaged)
								with: (StMessageNode receiver: (StVariableNode named: #b) selector: #messaged))))!

testCreationCascadeNodeFromExpression
	self compare: (self parserClass parseExpression: 'cascade firstMessage; secondMessage; lastMessage')
		to: (StCascadeNode messages: (OrderedCollection
						with: (StMessageNode receiver: (StVariableNode named: 'cascade') selector: #firstMessage)
						with: (StMessageNode receiver: (StVariableNode named: 'cascade') selector: #secondMessage)
						with: (StMessageNode receiver: (StVariableNode named: 'cascade') selector: #lastMessage))
				semicolons: (OrderedCollection with: 21 with: 37))!

testCreationLiteralArrayNodeWithExpression
	self compare: (self parserClass parseExpression: '#(literal1 literal2)')
		to: (StLiteralArrayNode
				startPosition: 1
				contents: (Array with: (StLiteralValueNode value: #literal1)
						with: (StLiteralValueNode value: #literal2))
				stopPosition: 20)!

testCreationLiteralValueNodeWithExpression
	self compare: (self parserClass parseExpression: '#literal')
		to: (StLiteralValueNode
				value: #literal
				start: 1
				stop: 8)!

testCreationLiteralValueNodeWithExpressionForNumber
	self compare: (self parserClass parseExpression: '2r10100')
		to: (StLiteralValueNode
				value: 20
				start: 1
				stop: 7)!

testCreationMessageNodeFromExpression
	"Verify the good parsing of an expression."

	self compare: (self parserClass parseExpression: 'self + 0')
		to: (StMessageNode
				receiver: (StVariableNode named: 'self')
				selector: #+
				arguments: { StLiteralNode value: 0 })!

testCreationProtocol
	| messageNode |
	self compare: (StMessageNode
				receiver: StVariableNode selfNode
				selector: #+
				arguments: (Array with: (StLiteralNode value: 0)))
		to: (self parserClass parseExpression: 'self + 0').
	messageNode := StMessageNode receiver: StVariableNode selfNode selector: #foo.
	self compare: (StMethodNode selector: #bar
				body: (StSequenceNode statements: (OrderedCollection
								with: (StCascadeNode messages: (OrderedCollection with: messageNode with: messageNode)))))
		to: (self parserClass parseMethod: 'bar self foo; foo')!

testCreationSelfNodeWithExpression
	self compare: (self parserClass parseExpression: 'self') to: StVariableNode selfNode!

testCreationSuperNodeWithExpression
	self compare: (self parserClass parseExpression: 'super') to: StVariableNode superNode!

testCreationThisContexNodeWithExpression
	self compare: (self parserClass parseExpression: 'thisContext')
		  to: StVariableNode thisContextNode!

testCreationVariableNodeWithExpression
	self compare: (self parserClass parseExpression: 'variable')
		to: (StVariableNode named: #variable start: 1)!

testDelimitationsOfArrayNodesAreBrackets
	Parser allowEmptyStatements: true.
	#('{}' '{.}' '{..}' '{foo. bar}' '{foo. bar.}' '{foo. bar. .}' '{. foo. bar}' '{foo.. bar}') do: 
			[:each |
			| tree |
			tree := self parserClass parseExpression: each.
			self assert: tree left equals: 1.
			self assert: tree right equals: each size]!

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

testEqualToWithMapping
	| tree |
	tree := self treeWithEverything.
	self assert: (tree equalTo: tree withMapping: Dictionary new).
	tree := self treeWithAllNodeTypes.
	self assert: (tree equalTo: tree withMapping: Dictionary new).
	self exampleClasses do: 
			[:class |
			class methodsDo: 
					[:each |
					tree := each parseTree.
					self assert: (tree equalTo: tree withMapping: Dictionary new)]]!

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

testGeneralBlockIntervalsArray
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := '{array node}'.
	self assert: (tree body statements at: 4) start equals: (tree source findString: str).
	self assert: (tree body statements at: 4) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralBlockIntervalsAssignement
	"This tests that assignement nodes inside a block node correspond the right interval in the source code."

	| tree str assignementNode position |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := 'assignement := node'.
	assignementNode := tree body statements at: 7.
	position := tree source findString: str.
	self assert: assignementNode start equals: position.
	self assert: assignementNode stop equals: position + (str size - 1)!

testGeneralBlockIntervalsBlock
	"This tests that block nodes inside a block node correspond the right interval in the source code."

	| tree str blockNode position |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := '[block node]'.
	blockNode := tree body statements at: 5.
	position := tree source findString: str.
	self assert: blockNode start equals: position.
	self assert: blockNode stop equals: position + (str size - 1)!

testGeneralBlockIntervalsCascade
	"This tests that cascade nodes inside a block node correspond the right interval in the source code."

	| tree str cascadeNode position |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := 'cascade node; cascaded'.
	cascadeNode := tree body statements at: 6.
	position := tree source findString: str.
	self assert: cascadeNode start equals: position.
	self assert: cascadeNode stop equals: position + (str size - 1)!

testGeneralBlockIntervalsLiteralArray
	"This tests that literal array nodes inside a block node correspond the right interval in the source code."

	| tree str literalArrayNode position |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := '#(literal array node)'.
	literalArrayNode := tree body statements at: 3.
	position := tree source findString: str.
	self assert: literalArrayNode start equals: position.
	self assert: literalArrayNode stop equals: position + (str size - 1)!

testGeneralBlockIntervalsLiteralValue
	"This tests that literal value nodes inside a block node correspond the right interval in the source code."

	| tree str literalValueNode position |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := '#literalNode'.
	literalValueNode := tree body statements at: 2.
	position := tree source findString: str.
	self assert: literalValueNode start equals: position.
	self assert: literalValueNode stop equals: position + (str size - 1)!

testGeneralBlockIntervalsMessage
	"This tests that message nodes inside a block node correspond the right interval in the source code."

	| tree str messageNode position |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := 'message node'.
	messageNode := tree body statements at: 1.
	position := tree source findString: str.
	self assert: messageNode start equals: position.
	self assert: messageNode stop equals: position + (str size - 1)!

testGeneralBlockIntervalsReturn
	"This tests that return nodes inside a block node correspond the right interval in the source code."

	| tree str returnNode position |
	tree := self
				parseExpression: '["comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node]'.
	str := '^return node'.
	returnNode := tree body statements at: 8.
	position := tree source findString: str.
	self assert: returnNode start equals: position.
	self assert: returnNode stop equals: position + (str size - 1)!

testGeneralMethodIntervalsArray
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := '{array node}'.
	self assert: (tree body statements at: 4) start equals: (tree source findString: str).
	self assert: (tree body statements at: 4) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsAssignement
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := 'assignement := node'.
	self assert: (tree body statements at: 7) start equals: (tree source findString: str).
	self assert: (tree body statements at: 7) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsBlock
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := '[block node]'.
	self assert: (tree body statements at: 5) start equals: (tree source findString: str).
	self assert: (tree body statements at: 5) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsCascade
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := 'cascade node; cascaded'.
	self assert: (tree body statements at: 6) start equals: (tree source findString: str).
	self assert: (tree body statements at: 6) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsComment
	"This tests that comment nodes inside a method node correspond the right interval in the source code."

	| tree str commentNode position |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := '"comment node"'.
	commentNode := tree comments at: 1.
	position := tree source findString: str.
	self assert: commentNode start equals: position.
	self assert: commentNode stop equals: position + (str size - 1)!

testGeneralMethodIntervalsLiteralArray
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := '#(literal array node)'.
	self assert: (tree body statements at: 3) start equals: (tree source findString: str).
	self assert: (tree body statements at: 3) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsLiteralValue
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := '#literalNode'.
	self assert: (tree body statements at: 2) start equals: (tree source findString: str).
	self assert: (tree body statements at: 2) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsMessage
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := 'message node'.
	self assert: (tree body statements at: 1) start equals: (tree source findString: str).
	self assert: (tree body statements at: 1) stop
		equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsPragma
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := '<pragmanode>'.
	self assert: tree tags first start equals: (tree source findString: str).
	self assert: tree tags first stop equals: (tree source findString: str) + (str size - 1)!

testGeneralMethodIntervalsReturn
	"This tests that all types of nodes in a method are well made."

	| tree str |
	tree := self
				parseMethod: 'Selector <pragmanode> "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	str := '^return node'.
	self assert: (tree body statements at: 8) start equals: (tree source findString: str).
	self assert: (tree body statements at: 8) stop
		equals: (tree source findString: str) + (str size - 1)!

testIdentificationOfPrimitiveMethods
	"Verify if there is the pragma primitive in the parsed method."

	"The string is the element to be parsed.
	 The boolean is the expected result. true : is primitive
													false : is not primitive."

	#(#('foo ^true' false) #('foo <some: #tag> ^true' false) #(' foo <some: #tag> <primitive: 123> ^self' true) #('foo primitive:= 123. ^self' false))
		do: [:each | self assert: (self parserClass parseMethod: each first) isPrimitive equals: each last]!

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

testInvalidPragmaPosition
	#('foo self. <foo: $a>' '<foo: $a>' 'foo [:x | <foo: $a> ] value' 'foo ^ <foo: $a>')
		do: [:each | self should: [self parserClass parseMethod: each] raise: CompilerErrorNotification]!

testInvalidSelectorRaisesSyntaxError
	"Could propose multiple reparations like assignement, period, array..."

	self should: [self parserClass parseExpression: 'temp 1 + 3'] raise: CompilerErrorNotification!

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

testLiteralArray
	"Test the good parsing of the elements of a literal array which means treating each as a literal."

	| tree collection |
	tree := self parserClass
				parseExpression: '#( a #b #''c'' . + - 1 -2 3.4 #true true #false false #nil nil "comment" ''string'' #[ 1 2 3 ] #(1 2 3))'.
	collection := OrderedCollection new.
	"Create a collection with the expected values contained in the literal array."
	collection
		add: #a;
		add: #b;
		add: #c;
		add: #'.';
		add: #+;
		add: #-;
		add: 1;
		add: -2;
		add: 3.4;
		add: #true;
		add: true;
		add: #false;
		add: false;
		add: #nil;
		add: nil;
		add: 'string';
		add: #[1 2 3];
		add: #(1 2 3).
	self assert: tree isLiteralArray.
	tree value with: collection do: [:node :value | self assert: node value equals: value]!

testLiteralArrayContainsLiteralValues
	"Test the good parsing of the elements of a literal array which means treating each as a literal."

	| tree collection |
	tree := self parserClass
				parseExpression: '#( a #b #''c'' . + - 1 -2 3.4 #true true #false false #nil nil "comment" ''string'' #[ 1 2 3 ] #(1 2 3))'.
	collection := OrderedCollection new.
	"Create a collection with the expected values contained in the literal array."
	collection
		add: #a;
		add: #b;
		add: #c;
		add: #'.';
		add: #+;
		add: #-;
		add: 1;
		add: -2;
		add: 3.4;
		add: #true;
		add: true;
		add: #false;
		add: false;
		add: #nil;
		add: nil;
		add: 'string';
		add: #[1 2 3];
		add: #(1 2 3).
	self assert: tree isLiteralArray.
	tree value with: collection do: [:node :value | self assert: node value equals: value]!

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

testMethodNodeEndAtTheEndOfTheString
	| tree |
	tree := self parserClass parseExpression: 'foo kung foo. 1+2+3. #''alabama''.  '.
	self assert: tree parent source equals: 'foo kung foo. 1+2+3. #''alabama''.  '.
	self assert: tree parent stop equals: tree parent sourceCode size.
	tree := self parserClass parseMethod: 'foo kung foo. 1+2+3. #''alabama''.  '.
	self assert: tree source equals: 'foo kung foo. 1+2+3. #''alabama''.  '.
	self assert: tree stop equals: tree newSource size!

testMethodNodeStartAtOne
	| tree |
	"When there are multiple statements, the node returned is the Sequence node (child of the method node)."
	tree := self parserClass parseExpression: 'foo koong. ^foo'.
	self assert: tree parent start equals: 1.

	"In Dolphin leading whitespace before an expression is skipped, so even these start at 1"
	tree := self parserClass parseExpression: '  foo koong. ^foo'.
	self assert: tree parent start equals: 1.

	"parseMethod always return a method node."
	tree := self parserClass parseMethod: 'foo koong. ^foo'.
	self assert: tree start equals: 1.
	tree := self parserClass parseMethod: '  foo koong. ^foo'.
	self assert: tree start equals: 1!

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

testNegativeNumberError
	self should: [self parserClass parseExpression: '- 2'] raise: CompilerErrorNotification!

testNodesDo
	| size |
	size := 0.
	self treeWithEverything nodesDo: [:e | size := size + 1].
	self assert: size equals: 27!

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

testNodeWithMissingArgumentHasSameSourceAsOriginal
	| tree source errorNode |
	source := '1+'.
	tree := [self parseExpression: source] on: self parseErrorClass do: [:ex | ex resume].
	errorNode := tree arguments first.
	self assert: errorNode value isEmpty.
	self assert: errorNode sourceInterval isEmpty!

testNumberParsing
	| numbers node |
	self skip: 'Compiler does not parse radix integers with exponent. RBParser does.'.
	numbers := #(#('1' 1) #('-1' -1) #('123' 123) #('123' 123) #('-123' -123) #('1.1' 1.1) #('-1.1' -1.1) #('1.23' 1.23) #('-1.23' -1.23) #('1e3' 1e3) #('-1e3' -1e3) #('1e-3' 1e-3) #('-1e-3' -1e-3) #('2r1e8' 2r1e8) #('-2r1e8' -2r1e8) #('2r1e-8' 2r1e-8) #('-2r1e-8' -2r1e-8) #('0.50s2' 0.50s2) #('0.500s3' 0.500s3) #('0.050s3' 0.050s3)).
	numbers do: 
			[:spec |
			node := self parserClass parseExpression: spec first.
			self assert: node source equals: spec first.
			self assert: node value equals: spec second]!

testNumberRadixParsing
	2 to: 32
		do: 
			[:radix |
			0 to: 72 do: [:i | self assert: (self parseExpression: (i printStringRadix: radix)) value equals: i]]!

testParentOfArgumentNodeIsMethodNode
	| tree |
	tree := self parseMethod: 'Selector: argument ^return something.'.
	self assert: tree arguments first isVariable.
	self assert: tree arguments first parent equals: tree!

testParentOfMethodNodeIsNil
	| tree |
	tree := self parseMethod: 'Selector ^return something.'.
	self assert: tree parent isNil!

testParentOfSequenceNodeIsMethodNode
	| tree |
	tree := self parseMethod: 'Selector ^return something.'.
	self assert: tree body isSequence.
	self assert: tree body parent equals: tree!

testParentOfStatementsIsSequenceNode
	| tree |
	tree := self parseMethod: 'Selector: argument "comment node" | temporaries | message node. #literalNode . #(literal array node). {array node}. [block node]. cascade node; cascaded. assignement := node. ^return node'.
	(tree body statements) do: [ :each | self assert: each parent equals: tree body]!

testParents
	(Array with: self treeWithEverything with: self treeWithAllNodeTypes) do: 
			[:tree |
			(Array with: tree with: tree copy) do: 
					[:root |
					root nodesDo: 
							[:node |
							node children do: 
									[:each |
									(each parent isMessage and: [each parent isCascaded])
										ifFalse: 
											[self assert: each parent identicalTo: node.
											self assert: each methodNode identicalTo: root]]]]]!

testParseExpressionGivesTheWriteAmountOfStatements
	"Testing with a list of triplets.
	 1. The string parsed.
	 2. The number of statements expected in parsed string.
	 3. The number of dots marking a period expected in parsed string."

	Parser allowEmptyStatements: true.
	#(#('' 0 0) #('.' 0 1) #('| bar |' 0 0) #('| bar | .' 0 1) #('| bar | ..' 0 2) #('foo. bar' 2 1) #('foo. bar.' 2 2) #('foo. bar. .' 2 3) #('. foo. bar' 2 2) #('foo. bar. foo bar.' 3 3))
		do: 
			[:each |
			| tree |
			tree := self parserClass parseExpression: each first.
			self assert: tree statements size equals: each second.
			self assert: tree periods size equals: each last]!

testParseGivesMethod
	"The parsing of an expression or a method gives a method node.
	 For an expression we expect the selector to be #noMethod.
	 For a method we expect the selector to be the first identifier.
	 In the method node, we expect the original string (source) to be stored."

	| tree |
	"When there are multiple statements, the node returned is the Sequence node (child of the method node)."
	tree := self parserClass parseExpression: 'foo koong. ^foo'.
	self assert: tree parent isMethod.

	"When there is a single statement, the node returned is the overarching node of the statement (child of the sequence node)."
	tree := self parserClass parseExpression: 'foo koong foo'.
	self assert: tree parent parent isMethod.

	"parseMethod always return a method node."
	tree := self parserClass parseMethod: 'foo koong. ^foo'.
	self assert: tree isMethod.
	tree := self parserClass parseMethod: 'foo koong foo'.
	self assert: tree isMethod!

testParseRegistersTheSourceInMethodNode
	"The parsing of an expression or a method gives a method node.
	 For an expression we expect the selector to be #noMethod.
	 For a method we expect the selector to be the first identifier.
	 In the method node, we expect the original string (source) to be stored."

	| tree |
	"When there are multiple statements, the node returned is the Sequence node (child of the method node)."
	tree := self parserClass parseExpression: 'foo koong. ^foo'.
	self assert: tree parent source equals: 'foo koong. ^foo'.

	"When there is a single statement, the node returned is the overarching node of the statement (child of the sequence node)."
	tree := self parserClass parseExpression: 'foo koong foo'.
	self assert: tree parent parent source equals: 'foo koong foo'.

	"parseMethod always return a method node."
	tree := self parserClass parseMethod: 'foo koong. ^foo'.
	self assert: tree source equals: 'foo koong. ^foo'.
	tree := self parserClass parseMethod: 'foo koong foo'.
	self assert: tree source equals: 'foo koong foo'!

testParsingArrayGivesArrayNode
	| tree |
	#('{}' '{foo}' '{foo. bar.}') do: 
			[:each |
			tree := self parserClass parseExpression: each.
			self assert: tree isDynamicArray]!

testParsingLiteralMessages
	self assert: (self parserClass parseExpression: 'nil self nil') isMessage.
	self assert: (self parserClass parseExpression: 'self true') isMessage.
	self assert: (self parserClass parseExpression: 'self false') isMessage.
	self assert: (self parserClass parseExpression: 'self -1') isMessage.

	self assert: (self parserClass parseMethod: 'nil') isMethod.
	self assert: (self parserClass parseMethod: 'true') isMethod.
	self assert: (self parserClass parseMethod: 'false') isMethod!

testParsingPragmaRecogniseAndStorePragmas
	"Tests that the pragmas are correctly interpreted.
	 1. The string to be parsed.
	 2. The selector in parsed pragma.
	 3. The selector arguments."

	| tree |
	#('foo <foo>' 'foo <foo: 1>' 'foo <foo: 1.2>' 'foo <foo: -3>' 'foo <foo: #a>' 'foo <foo: #< >' 'foo <foo: #> >' 'foo <foo: $a>' 'foo <foo: ''bar''>' 'foo <foo: true>' 'foo <foo: false>' 'foo <foo: nil>' 'foo <foo: #(1 2)>' 'foo <foo: 1 bar: 2>' 'foo <foo: 1.2> |t| ' 'foo <foo: 1 bar: 2> |t|')
		do: 
			[:each |
			tree := self parserClass parseMethod: each.
			self assert: tree tags size equals: 1].
	self assert: (self parserClass parseMethod: 'foo <pragma1> <pragma2> |t|') tags size equals: 2!

testParsingPragmaRecogniseArguments
	"Tests that the pragmas are correctly interpreted.
	 1. The string to be parsed.
	 2. The selector in parsed pragma.
	 3. The selector arguments."

	| tree node |
	#(#('foo <foo>' #foo #()) #('foo <foo: 1>' #foo: #(1)) #('foo <foo: 1.2>' #foo: #(1.2)) #('foo <foo: -3>' #foo: #(-3)) #('foo <foo: #a>' #foo: #(#a)) #('foo <foo: #< >' #foo: #(#<)) #('foo <foo: #> >' #foo: #(#>)) #('foo <foo: $a>' #foo: #($a)) #('foo <foo: ''bar''>' #foo: #('bar')) #('foo <foo: true>' #foo: #(true)) #('foo <foo: false>' #foo: #(false)) #('foo <foo: nil>' #foo: #(nil)) #('foo <foo: #(1 2)>' #foo: #(#(1 2))) #('foo <foo: 1 bar: 2>' #foo:bar: #(1 2)) #('foo <foo: 1.2> |t|' #foo: #(1.2)) #('foo <foo: 1 bar: 2> |t|' #foo:bar: #(1 2)))
		do: 
			[:each |
			tree := self parserClass parseMethod: each first.
			self assert: tree tags size equals: 1.
			node := tree tags first.
			1 to: node arguments size
				do: [:i | self assert: (node arguments at: i) value equals: (each last at: i)]]!

testParsingPragmaRecogniseSelector
	"Tests that the pragmas are correctly interpreted.
	 1. The string to be parsed.
	 2. The selector in parsed pragma.
	 3. The selector arguments."
	| tree node |
	#(('foo <foo>' 				#foo ())
	('foo <foo: 1>' 				#foo: (1))
	('foo <foo: 1.2>' 			#foo: (1.2))
	('foo <foo: -3>' 			#foo: (-3))
	('foo <foo: #a>' 			#foo: (a))
	('foo <foo: #< >' 			#foo: (<))
	('foo <foo: #> >' 			#foo: (>))
	('foo <foo: $a>' 			#foo: ($a))
	('foo <foo: ''bar''>' 		#foo: ('bar'))
	('foo <foo: true>' 			#foo: (true))
	('foo <foo: false>' 			#foo: (false))
	('foo <foo: nil>' 			#foo: (nil))
	('foo <foo: #(1 2)>' 		#foo: ((1 2)))
	('foo <foo: 1 bar: 2>' 		#foo:bar: (1 2))
	('foo <foo: 1.2> |t|' 		#foo: (1.2))
	('foo <foo: 1 bar: 2> |t|' #foo:bar: (1 2))
	) do: [ :each |
		tree := self parserClass parseMethod: each first.
		node := tree tags first.
		self assert: node selector equals: each second.]!

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

testPragmaConstantLiteralArgument
	| primitiveDeclartion validPragma validPragmaInDolphin |
	"primitive declarations with variable (code) are allowed"
	primitiveDeclartion := 'foo <primitive: 123 error: code> ^ nil'.
	"#Point as argument is allowed"
	validPragma := 'foo <return: #Point> ^ 0@0'.
	"Point as argument is also allowed (in Dolphin)"
	validPragmaInDolphin := 'foo <return: Point> ^ 0@0'.
	self shouldnt: [self parserClass parseMethod: primitiveDeclartion] raise: CompilerErrorNotification.
	self shouldnt: [self parserClass parseMethod: validPragma] raise: CompilerErrorNotification.
	self shouldnt: [self parserClass parseMethod: validPragmaInDolphin] raise: CompilerErrorNotification!

testPragmaImplicitLiteralArrayIsInvalid
	| pragmaWithExpressionAsArgument pragmaWithLiteralArrayAsArgument pragmaWithStringAsArgument |
	"a pragma with arguments that look like code
	(3+4) were implicitly converted to a literal array
	#(3+4), this is not allowed anymore"
	pragmaWithExpressionAsArgument := 'foo
	<func: (3+4) res: 7>
	^ self'.
	self should:[self parserClass parseMethod: pragmaWithExpressionAsArgument] raise: CompilerErrorNotification.

	"an explicit literal array is allowed"
	pragmaWithLiteralArrayAsArgument := 'foo
	<func: #(3+4) res: 7>
	^ self'.
	"Should work"
	self shouldnt: [self parserClass parseMethod: pragmaWithLiteralArrayAsArgument] raise: CompilerErrorNotification.

	"and of course a string literal"
	pragmaWithStringAsArgument := 'foo
	<func: ''(3+4)'' res: 7>
	^ self'.
	"should work"
	self shouldnt: [self parserClass parseMethod: pragmaWithStringAsArgument] raise: CompilerErrorNotification!

testPragmaInExpression
	"Test if a working pragma in a method is faulty in an expression."

	self should: [self parserClass parseExpression: '<some: #tag> | token |  true']
		raise: CompilerErrorNotification!

testPragmaPrimitiveError
	| tree pragma |
	tree := self parserClass parseMethod: 'veryBasicAt: index
	<primitive: 123 error: code>
	^ code'.
	self assert: tree tags size equals: 1.
	pragma := tree tags first.
	self assert: pragma selector equals: #primitive:error:!

testPragmas
	| tree node |
	#(#('foo <foo>' #foo #()) #('foo <foo: 1>' #foo: #(1)) #('foo <foo: 1.2>' #foo: #(1.2)) #('foo <foo: -3>' #foo: #(-3)) #('foo <foo: #a>' #foo: #(#a)) #('foo <foo: #< >' #foo: #(#<)) #('foo <foo: #> >' #foo: #(#>)) #('foo <foo: $a>' #foo: #($a)) #('foo <foo: ''bar''>' #foo: #('bar')) #('foo <foo: true>' #foo: #(true)) #('foo <foo: false>' #foo: #(false)) #('foo <foo: nil>' #foo: #(nil)) #('foo <foo: #(1 2)>' #foo: #(#(1 2))) #('foo <foo: 1 bar: 2>' #foo:bar: #(1 2)) #('foo <foo: 1.2> |t|' #foo: #(1.2)) #('foo <foo: 1 bar: 2>|t|' #foo:bar: #(1 2)))
		do: 
			[:each |
			tree := self parserClass parseMethod: each first.
			self assert: tree tags size equals: 1.
			node := tree tags first.
			self assert: node selector equals: each second.
			1 to: node arguments size
				do: [:i | self assert: (node arguments at: i) value equals: (each last at: i)].
			self assert: (each first at: node start) equals: $<.
			self assert: (each first at: node stop) equals: $>].
	self assert: (self parserClass parseMethod: 'selector <a>') isMethod.
	self
		assert: (self parserClass
				parseMethod: '
	selector
		"comment1"
		|temp|
		"comment2"
		<a>
		#<.
		^1') isMethod.
	self should: 
			[self parserClass parseMethod: '
	selector
		"comment1"
		|temp|
		"comment2"
		<a>
		<.
		^1']
		raise: CompilerErrorNotification!

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
foo!public!unit tests! !
isEquivalentMethod:to:!helpers!private! !
parseAll!long running!public! !
parseExpression:!helpers!private! !
parseMethod:!helpers!private! !
parserClass!constants!private! !
setUp!public!running! !
tearDown!public!running! !
testAnnotationAndTempsNoSpace!public!unit tests! !
testAnnotationAndTempsNoSpace2!public!unit tests! !
testAnnotationEquality!public!unit tests! !
testAnnotationParents!public!unit tests! !
testArray!public!unit tests! !
testBestNodeFor!public!unit tests! !
testBinarySelectors!public!unit tests! !
testBlockNodeIsUsed!public!unit tests! !
testBlockReturnNode!public!unit tests! !
testBlockWithArgsAndEmptyTemps!public!unit tests! !
testCascade!public!unit tests! !
testCascadeReplacement!public!unit tests! !
testComparingTrees!public!unit tests! !
testCopy!public!unit tests! !
testCreationBlockNodeWithExpression!public!unit tests! !
testCreationCascadeNodeFromExpression!public!unit tests! !
testCreationLiteralArrayNodeWithExpression!public! !
testCreationLiteralValueNodeWithExpression!public! !
testCreationLiteralValueNodeWithExpressionForNumber!public! !
testCreationMessageNodeFromExpression!public! !
testCreationProtocol!public! !
testCreationSelfNodeWithExpression!public! !
testCreationSuperNodeWithExpression!public! !
testCreationThisContexNodeWithExpression!public! !
testCreationVariableNodeWithExpression!public! !
testDelimitationsOfArrayNodesAreBrackets!public! !
testEquality!public!unit tests! !
testEqualToWithMapping!public! !
testEquivalentExceptRenaming!public!unit tests! !
testExpressionSolver!public!unit tests! !
testExternalCallChildren!public! !
testExternalCallEquality!public!unit tests! !
testExternalCalls!public!unit tests! !
testGeneralBlockIntervalsArray!public! !
testGeneralBlockIntervalsAssignement!public! !
testGeneralBlockIntervalsBlock!public! !
testGeneralBlockIntervalsCascade!public! !
testGeneralBlockIntervalsLiteralArray!public! !
testGeneralBlockIntervalsLiteralValue!public! !
testGeneralBlockIntervalsMessage!public! !
testGeneralBlockIntervalsReturn!public! !
testGeneralMethodIntervalsArray!public! !
testGeneralMethodIntervalsAssignement!public! !
testGeneralMethodIntervalsBlock!public! !
testGeneralMethodIntervalsCascade!public! !
testGeneralMethodIntervalsComment!public! !
testGeneralMethodIntervalsLiteralArray!public! !
testGeneralMethodIntervalsLiteralValue!public! !
testGeneralMethodIntervalsMessage!public! !
testGeneralMethodIntervalsPragma!public! !
testGeneralMethodIntervalsReturn!public! !
testIdentificationOfPrimitiveMethods!public! !
testIntervals!public!unit tests! !
testInvalidPragmaPosition!public!unit tests! !
testInvalidSelectorRaisesSyntaxError!public!unit tests! !
testIsA!public!unit tests! !
testKeywordAnnotationChildren!public! !
testLiteralArray!public! !
testLiteralArrayContainsLiteralValues!public! !
testLiteralIntevals!public!unit tests! !
testLiteralMessages!public!unit tests! !
testMethodNodeEndAtTheEndOfTheString!public!unit tests! !
testMethodNodeStartAtOne!public!unit tests! !
testMethodPatterns!public!unit tests! !
testModifying!public!unit tests! !
testNegativeNumberError!public!unit tests! !
testNodesDo!public!unit tests! !
testNodesDoAll!public!unit tests! !
testNodeWithMissingArgumentHasSameSourceAsOriginal!public!unit tests! !
testNumberParsing!public!unit tests! !
testNumberRadixParsing!public!unit tests! !
testParentOfArgumentNodeIsMethodNode!public!unit tests! !
testParentOfMethodNodeIsNil!public!unit tests! !
testParentOfSequenceNodeIsMethodNode!public!unit tests! !
testParentOfStatementsIsSequenceNode!public!unit tests! !
testParents!public!unit tests! !
testParseExpressionGivesTheWriteAmountOfStatements!public!unit tests! !
testParseGivesMethod!public!unit tests! !
testParseRegistersTheSourceInMethodNode!public! !
testParsingArrayGivesArrayNode!public! !
testParsingLiteralMessages!public!unit tests! !
testParsingPragmaRecogniseAndStorePragmas!public!unit tests! !
testParsingPragmaRecogniseArguments!public!unit tests! !
testParsingPragmaRecogniseSelector!public!unit tests! !
testPositions!public!unit tests! !
testPragmaConstantLiteralArgument!public!unit tests! !
testPragmaImplicitLiteralArrayIsInvalid!public!unit tests! !
testPragmaInExpression!public!unit tests! !
testPragmaPrimitiveError!public!unit tests! !
testPragmas!public!unit tests! !
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

