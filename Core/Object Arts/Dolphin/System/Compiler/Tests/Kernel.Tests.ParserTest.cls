"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.ParserTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{External.ExtCallArgTypes} #{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.ParserTest guid: (Core.GUID fromString: '{947b6d13-1a2a-43c0-8053-bde0fccfbd44}')!
Kernel.Tests.ParserTest comment: 'SUnitBrowser openOnTestCase: self'!
!Kernel.Tests.ParserTest categoriesForClass!Refactory-Testing! !
!Kernel.Tests.ParserTest methodsFor!

assertToken: aStToken isChar: aCharacter
	self assert: aStToken isLiteralToken.
	aCharacter codePoint < 16r80
		ifTrue: [self assert: aStToken value identicalTo: aCharacter]
		ifFalse: [self assert: aStToken value equals: aCharacter]!

assertTree: anObject equals: anotherObject
	self assert: anObject hash equals: anotherObject hash.
	self assert: anObject equals: anotherObject!

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
									[tree := method parseTree] on: Kernel.Parser errorClass do: [:ex | errors add: method -> ex].
									tree isNil
										ifFalse: 
											[((Compiler compile: tree formattedCode in: each)
												isEqualTo: (Compiler compile: method getSource in: each))
													ifFalse: [errors add: method -> 'Mismatched parse trees']]]]].
			errors].
	^progress showModal!

parseExpression: aString
	^self parserClass parseExpression: aString!

parseMethod: aString
	^self parserClass parseMethod: aString!

parserClass
	^Parser!

scannerClass
	^Scanner!

scanNonNumericEnd: aString class: tokenClass
	| expected stream extra scanner actual next |
	stream := aString readStream.
	expected := Number readSmalltalkSyntaxFrom: stream.
	extra := stream upToEnd.
	stream reset.
	scanner := self scannerClass on: stream.
	actual := scanner next.
	self assert: actual isKindOf: tokenClass.
	self assert: actual value equals: expected.
	next := scanner next.
	self assert: (extra beginsWith: next value)!

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

testCharacterScanning
	| subject tok |
	subject := self scannerClass on: '$a$b$\t$\$  $c' readStream.
	tok := subject next.
	self assertToken: tok isChar: $a.
	self assert: tok sourceInterval equals: (1 to: 2).
	tok := subject next.
	self assertToken: tok isChar: $b.
	self assert: tok sourceInterval equals: (3 to: 4).
	tok := subject next.
	self assertToken: tok isChar: Character tab.
	self assert: tok sourceInterval equals: (5 to: 7).
	tok := subject next.
	self assertToken: tok isChar: $\.
	self assert: tok sourceInterval equals: (8 to: 9).
	tok := subject next.
	self assertToken: tok isChar: Character space.
	self assert: tok sourceInterval equals: (10 to: 11).
	tok := subject next.
	self assertToken: tok isChar: $c.
	self assert: tok sourceInterval equals: (13 to: 14).
	0 to: 255
		do: 
			[:i |
			| char ch source interval |
			ch := Character value: i.
			subject := self scannerClass on: ch printString readStream.
			char := subject next.
			self assertToken: char isChar: ch.
			self assert: subject next isEof.
			source := ' $\x<1s> ' expandMacrosWith: (i printStringBase: 16).
			subject := self scannerClass on: source readStream.
			char := subject next.
			self assertToken: char isChar: ch.
			interval := char sourceInterval.
			self assert: interval equals: (2 to: source size - 1).
			self assert: subject next isEof].
	subject := self scannerClass on: ' $\. ' readStream.
	tok := subject next.
	self assertToken: tok isChar: (Character value: 92).
	self assert: tok sourceInterval equals: (2 to: 3).
	self assert: (subject next isSpecial: $.).
	subject := self scannerClass on: '$\c' readStream.
	tok := subject next.
	self assertToken: tok isChar: (Character value: 92).
	self assert: tok sourceInterval equals: (1 to: 2).
	tok := subject next.
	self assert: tok isIdentifier.
	self assert: tok value equals: 'c'.
	subject := self scannerClass on: '$\xAG' readStream.
	tok := subject next.
	self assertToken: tok isChar: (Character value: 16rA).
	self assert: tok sourceInterval equals: (1 to: 4).
	tok := subject next.
	self assert: tok isIdentifier.
	self assert: tok value equals: 'G'!

testCopy
	| tree copy |
	tree := self treeWithAllNodeTypes.
	copy := tree copy.
	self assertTree: tree equals: copy.
	"This does rely on the implementation of #childrenDo: on each node being correct. It is easy to define a new node type with chilren and forget to ensure it enumerates its children."
	self verifyTree: copy isDeepCopyOf: tree!

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
	self assert: grandChild isKindOf: StVariableNode.
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
	| ffiCall tree src types |
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
	<cdecl: dword blah sdword>'.
	ffiCall := tree tags first.
	self assert: ffiCall returnType typeOrdinal equals: ExtCallArgDWORD.
	self assert: ffiCall returnType indirections equals: 0.
	self assertIsNil: ffiCall returnType structClass.
	self assert: ffiCall argumentTypes size equals: 1.
	self assert: ffiCall selector identicalTo: #cdecl:.
	ffiCall argumentTypes with: {ExtCallArgSDWORD}
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
	tree := self parseMethod: src.
	self assert: tree formattedCode trimBlanks equals: src.
	ffiCall := tree tags first.
	self assert: ffiCall argumentTypes size equals: types size.
	ffiCall argumentTypes with: (1 to: types size)
		do: 
			[:eachArg :eachType |
			self assert: eachArg typeOrdinal equals: eachType.
			self assert: eachArg indirections equals: 0.
			self assertIsNil: eachArg structClass]!

testFloatScanning
	Float reset.
	#('5.1234' '0.0' '0.5' '1.2e1' '1.2d2' '1.2e-1' '1.2e+1' '1.2d-2' '1.2d+2' '1.0e308' '1.0e+308' '2.2250738585072014e-308' '1.7976931348623158e308' '1.7976931348623158e+308' '0.5e0' '0.5d0' '0.5q0' '0.5e+0' '0.5d+0' '0.5q+0' '0.5e-0' '0.5d-0' '0.5q-0')
		do: 
			[:each |
			| token expected actual |
			expected := Number readFrom: each readStream.
			token := (self scannerClass on: each readStream) next.
			actual := token value.
			self assert: actual isKindOf: Float.
			self assert: actual equals: expected].

	"Integer terminated by a period, not a float"
	self assert: (self scannerClass on: '5.' readStream) next value identicalTo: 5.
	self assert: (self scannerClass on: '1.0e-316' readStream) next value equals: 10.0 ** -316.

	"Test termination on non-numeric character - these expressions are in error"
	#('5.1234a' '0.5e' '1.5e2e3' '1.5e2e-3' '1.5e-Integer zero' '1.5e-' '1.5e+' '1.7976931348623158+e308')
		do: [:each | self scanNonNumericEnd: each class: StNumberLiteralToken].
	self scanNonNumericEnd: '5.F' class: StNumberLiteralToken!

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
	self assert: child isKindOf: StVariableNode.
	self assert: child name equals: 'XProgramming'.
	self assert: child parent identicalTo: annotation.!

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
	<stdcall: UIntPtr blah POINTL* > 
	| temps | 
	super method: arg1. 
	thisContext. 
	temps := #(10 ##(#sequence -> true. #{Core.Object})). 
	self foo; foo. 
	^(temps collect: [:e | {e. #[127]} ])'!

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
!Kernel.Tests.ParserTest categoriesForMethods!
assertToken:isChar:!helpers!private! !
assertTree:equals:!helpers!private! !
parseAll!long running!public! !
parseExpression:!helpers!private! !
parseMethod:!helpers!private! !
parserClass!constants!private! !
scannerClass!constants!private! !
scanNonNumericEnd:class:!helpers!private! !
testAnnotationEquality!public!unit tests! !
testAnnotationParents!public!unit tests! !
testBestNodeFor!public!unit tests! !
testCharacterScanning!public!unit tests! !
testCopy!public!unit tests! !
testExpressionSolver!public!unit tests! !
testExternalCallChildren!public! !
testExternalCallEquality!public!unit tests! !
testExternalCalls!public!unit tests! !
testFloatScanning!public!unit tests! !
testKeywordAnnotationChildren!public! !
testNodesDoAll!public!unit tests! !
testPrimitiveTagChildren!public!unit tests! !
testUnaryAnnotationChildren!public!unit tests! !
treeWithAllNodeTypes!constants!private! !
verifyTree:isDeepCopyOf:!helpers!private! !
!

