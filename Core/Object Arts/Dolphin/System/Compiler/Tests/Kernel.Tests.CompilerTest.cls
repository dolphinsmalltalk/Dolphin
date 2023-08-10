"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.CompilerTest'
	instanceVariableNames: 'defaultCompileFlags'
	classVariableNames: 'TempInstrs'
	imports: #(#{Kernel.CompilerFlags} #{Kernel.OpcodePool} #{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CompilerTest guid: (Core.GUID fromString: '{5aff22bd-5d99-4b24-9b1d-c8d1ede77213}')!
Kernel.Tests.CompilerTest comment: ''!
!Kernel.Tests.CompilerTest methodsFor!

assertBlocksOptimized: compiled
	| literals |
	self deny: compiled method needsContext.
	literals := compiled method literals.
	self deny: (literals anySatisfy: [:each | each isKindOf: BlockClosure]).
	self
		deny: (compiled method messages anySatisfy: [:each | StProgramNode optimizedSelectors includes: each])!

checkCompileError: ex range: anInterval code: anInteger line: lineInteger source: aString
	^ex errorCode = anInteger and: [ex range = anInterval]!

compilationErrorClass
	^Compiler errorClass!

compilationWarningClass
	^CompilerWarningNotification!

compileExpression: aString 
	^self compileExpression: aString in: nil!

compileExpression: aString in: aClass
	| result |
	self shouldnt: 
			[result := Compiler
						compileExpression: aString
						in: aClass
						environment: nil
						flags: defaultCompileFlags]
		raise: self compilationErrorClass.
	^result!

compileMethod: aString in: aClass
	^Compiler
		compile: aString
		in: aClass
		environment: nil
		flags: defaultCompileFlags!

debugCompileResultFor: aCompiledMethod
	^Compiler
		compile: aCompiledMethod getSource
		in: aCompiledMethod methodClass
		environment: aCompiledMethod environment
		flags: ##(CompilerFlags.DebugMethod | CompilerFlags.TextMap | CompilerFlags.TempsMap)!

defaultCompileFlags
	^defaultCompileFlags!

evalTestMethod: aCompiledMethod 
	^self evalTestMethod: aCompiledMethod withArgs: #()!

evalTestMethod: aCompiledMethod withArgs: anArray
	^aCompiledMethod value: DolphinCompilerTestMethods new withArguments: anArray!

evaluateExpression: aString 
	^Compiler evaluate: aString!

getTestMethod: aSymbol
	| oldMethod result method |
	oldMethod := DolphinCompilerTestMethods compiledMethodAt: aSymbol.
	self shouldnt: [result := self compileMethod: oldMethod getSource in: DolphinCompilerTestMethods]
		raise: self compilationErrorClass.
	method := result method.
	method selector: aSymbol.
	method
		sourceDescriptor: oldMethod sourceDescriptor;
		isPrivate: oldMethod isPrivate;
		beImmutableObject.	"The method has not actually changed, so it is inappropriate to issue a #methodUpdated: event"
	^method!

knownTempsMapIssues
	| env |
	env := Refactory.Browser.BrowserEnvironment new.
	"There are none"
	^env not!

knownTextMapIssues
	| bad |
	bad := OrderedCollection new.
	"These methods are all have optimisation where an unconditional jump is replaced with a
	return, and the text map for the optimised method then has an extra entry for that return
	statement as these get breaks inserted before them. The compiler needs to be fixed to mark
	these returns as optimised returns, and so it's never possible to break on them, or we need
	to put a text map entry in for the unconditional jump (wouldn't do any harm)."
	bad add: DolphinCompilerTestMethods >> #testWarningReadBeforeWrittenBlockTemp.
	"These case have an extra entry in the debug temps map, apparently due to the optimizatiom of ifNil:ifNotNil:. In the non-debug method the unecessary ifNotNil: branch is optimized away"
	{ Dictionary. OS.IniFileAbstract. Namespace class. DolphinCompilerTestMethods }
		do: [:each | bad add: each >> #associationAt:].
	^Refactory.Browser.BrowserEnvironment new forMethods: bad asArray!

messageFromError: ex
	^ex errorMessage!

scan: aString class: aNumberClass
	| expected result |
	expected := Number readFrom: aString readStream.
	result := self evaluateExpression: aString.
	self assert: result class identicalTo: aNumberClass.
	self assert: result equals: expected!

scanNonNumericEnd: aString class: aNumberClass
	| expected stream extra |
	stream := aString readStream.
	expected := Number readFrom: stream.
	extra := stream upToEnd.
	self
		should: [self evaluateExpression: aString]
		raise: MessageNotUnderstood
		matching: 
			[:ex |
			ex receiver class == aNumberClass and: [ex receiver = expected and: [extra beginsWith: ex selector]]]!

scanScaledDecimal: each
	| result1 expected |
	expected := Number readFrom: each readStream.
	result1 := self evaluateExpression: each.
	self assert: result1 class identicalTo: ScaledDecimal.
	self assert: result1 scale equals: expected scale.
	^self assert: result1 equals: expected!

scanSmallIntegerNonNumericEnd: aString 
	self scanNonNumericEnd: aString class: SmallInteger!

setInteractiveCompile
	defaultCompileFlags := defaultCompileFlags | Interactive!

setUp
	super setUp.
	defaultCompileFlags := Interactive!

shortPushOne
	| shortPushOne |
	shortPushOne := ShortPushImmediate + (1 - -1).
	^shortPushOne!

specialTempCases
	| specials |
	specials := OrderedCollection new.
	"Full block nested in optimized block"
	#{Tools.AXMethodName} ifDefinedDo: [:class | specials add: class >> #printSignatureOn:].
	"Inlined return in a whileFalse control structure"
	#{Base64Codec} ifDefinedDo: [:class | specials add: class >> #nextBase64From:].
	"Inlined returns in ifTrue/ifFalse optimised to ifNil"
	specials add: Behavior >> #whichClassIncludesSelector:.
	"Inlined returns in ifTrue/ifFalse stgructure"
	specials add: Boolean >> #&.
	"Full block nested in otherwise clean block"
	#{Refactory.Browser.BrowserEnvironment}
		ifDefinedDo: [:class | specials add: class >> #numberSelectors].
	"Full block nested in multiple levels of optimized blocks"
	specials add: CompiledCode >> #byteCodes:.
	"Clean and copying blocks as the values of optimized blocks"
	#{UI.ListViewColumn} ifDefinedDo: [:class | specials add: class >> #rowSortBlock].
	"Full block nested in multiple other blocks"
	specials add: TestResult >> #debugCase:.
	"Optimized blocks assigning temps inside full blocks"
	#{Date} ifDefinedDo: [:class | specials add: class >> #monthsSince:].
	"Test case for continuations"
	#{ContinuationTest} ifDefinedDo: [:class | specials add: class >> #testBlockVars].
	"Clean block in otherwise empty clean block"
	specials add: EventsCollection >> #triggerEvent:with:with:.
	^specials!

test1054
	| method |
	method := (self compileExpression: '1') method.
	self assert: method byteCodes equals: (ByteArray with: self shortPushOne with: ReturnFromMessage).
	method := (self compileMethod: 'a ^1' in: UndefinedObject) method.
	self assert: method byteCodes equals: (ByteArray with: self shortPushOne with: ReturnFromMessage)!

testBlockTempsMap
	"#1461"
	| result map max |
	result := Compiler 
				debugInfoForExpression: '[#(1 2 3) do: [:each | each = 2 ifTrue: [Error signal]]] on: Error do: [:ex | self halt]'
				in: Object
				environment: nil
				evaluationPools: #()
				debug: false.
	map := result tempsMap.
	max := result method byteCodes size.
	map do: 
			[:each | 
			| i |
			i := each key.
			i isInteger 
				ifFalse: 
					[self assert: (i start between: 1 and: max).
					i := i stop].
			self assert: (i between: 1 and: max)]!

testBlockWithAllTempTypes
	| method block1 value2 value1 |
	method := self getTestMethod: #testBlockWithAllTempTypes.
	self assert: method needsContext.
	self assert: method envTempCount equals: 2.
	self assert: method stackTempCount equals: 2.
	self assert: method tempsMap equals: {(1 to: 53) -> #(#('copied' 0 1) #('innerBlock' 1 2) #('local' 0 2) #('sharedOuter' 1 1)). (16 to: 52) -> #(#('arg1' 0 1) #('arg2' 0 2) #('copied' 0 3) #('innerBlock' 2 2) #('localBlock' 0 4) #('sharedBlock' 1 1) #('sharedOuter' 2 1)). (39 to: 49) -> #(#('innerBlock' 3 2) #('sharedBlock' 2 1) #('sharedOuter' 3 1))}.
	block1 := method value: DolphinCompilerTestMethods new withArguments: #().
	self assert: block1 isKindOf: BlockClosure.
	"Should only be one copied values, 0 temps and args"
	self assert: block1 argumentCount equals: 2.
	self assert: block1 stackTempCount equals: 1.
	self assert: block1 localCount equals: 4.
	self assert: block1 envTempCount equals: 1.
	self assert: block1 size equals: 1.
	self assert: (block1 outer at: 1) equals: 1.
	self assertIsNil: (block1 outer at: 2).
	value1 := block1 value: 3 value: 5.
	self assert: value1 equals: 160.
	self assert: (block1 outer at: 1) equals: 2.
	self assert: (block1 outer at: 2) isKindOf: BlockClosure.
	self assert: (block1 outer at: 2) value identicalTo: #abc.
	self assert: (block1 outer at: 2) outer isKindOf: self methodContextClass.
	self assert: (block1 outer at: 2) outer size equals: 1.
	self assert: ((block1 outer at: 2) outer at: 1) identicalTo: #abc.
	"Run it again. Because of the shared temps we should get a different result"
	value2 := block1 value: 3 value: 5.
	self assert: value2 equals: value1 * 20!

testBraceArrays
	| text array |
	self assert: (self evaluateExpression: '{}') equals: #().
	self assert: (self evaluateExpression: '{{{ {}. {{}. 1}. {2. {}} }}}')
		equals: #(#(#(#() #(#() 1) #(2 #())))).
	self assert: (self
				evaluateExpression: '| stringConst | stringConst := ''12345''. {SmallInteger maximum. stringConst.1.2345.{2 log. Object}}')
		equals: {SmallInteger maximum. '12345'. 1.2345. {2 log. Object}}.
	text := String writeStream.
	array := Array writeStream.
	text nextPut: ${.
	500 timesRepeat: 
			[| g |
			g := GUID newUnique.
			array nextPut: g.
			g storeOn: text.
			text nextPut: $.].
	text nextPut: $}.
	array := array contents.
	text := text contents.
	self assert: (Compiler evaluate: text) equals: array!

testByteArraysInLiteralArrays
	"#980"

	| compiled text |
	text := '#(#[])'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	self assert: (compiled method value: nil) equals: {#[]}.
	text := '#(1 #[0])'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	self assert: (compiled method value: nil) equals: {1. #[0]}.
	text := '#(1 #[0 255] 2)'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	self assert: (compiled method value: nil) equals: {1. #[0 255]. 2}!

testCharacterScanning
	| result |
	0 to: 127
		do: 
			[:i |
			| ch |
			ch := Character value: i.
			result := self evaluateExpression: ch printString.
			self assert: result identicalTo: ch.
			result := self evaluateExpression: '$\x' , (i printStringBase: 16).
			self assert: result identicalTo: ch].
	self assert: (self evaluateExpression: '$\x80') equals: (Character value: 128).
	self assert: (self evaluateExpression: '$\xA0') equals: (Character value: 160).
	161 to: 255
		do: 
			[:i |
			| ch |
			ch := Character value: i.
			result := self evaluateExpression: ch printString.
			self assert: result equals: ch.
			result := self evaluateExpression: '$\x' , (i printStringBase: 16).
			self assert: result equals: ch].
	result := self evaluateExpression: '$\x4E2D'.
	self assert: result isKindOf: Character.
	self assert: result codePoint equals: 16r4E2D.
	result := self evaluateExpression: '$\.'.
	self assert: result identicalTo: (Character value: 92).
	{'$\0'.
		Character null.
		'$\t'.
		Character tab.
		'$\n'.
		Character lf.
		'$\r'.
		Character cr.
		'$\a'.
		Character value: 7.
		'$\b'.
		Character value: 8.
		'$\v'.
		Character value: 11.
		'$\f'.
		Character value: 12} pairsDo: 
				[:each :char |
				result := self evaluateExpression: each.
				self assert: result identicalTo: char].
	result := self evaluateExpression: '$\t'.
	self assert: result identicalTo: Character tab.
	result := self evaluateExpression: '$\codePoint'.
	self assert: result identicalTo: 92.
	self
		should: [self evaluateExpression: '$\xAG']
		raise: MessageNotUnderstood
		matching: [:ex | ex tag = (Message selector: #G)]!

testCleanBlockInCopyingBlock
	| method block |
	method := self getTestMethod: #testCleanBlockInCopyingBlock.
	block := method value: DolphinCompilerTestMethods new withArguments: #().
	self assert: block isKindOf: BlockClosure.
	self assert: block value equals: #('1' '2' '3').

	"Note how the copying block is moved out of line (i.e. after the main method return) because it is part of the enclosing clean block. If it copied values from the method context, then the enclosing block would also have to be a copying block, but it only copies the arg to the clean block."
	self assert: method disassembly
		equals: 'Normal, 0 args, 1 stack temps, 4 literals

	1	Push Const[0]: #(1 2 3)
	2	Store Temp[0]
	3	Block Copy, 0 args, 1 copied values, skip +4 to 14
	10	Push Temp[0]
	11	Push Const[3]: [] in Kernel.Tests.DolphinCompilerTestMethods>>#testCleanBlo…
	12	Send[2]: #collect: with 1 args
	13	Return From Block
	14	Return
	15	Push Temp[0]; Send[1]: #printString with 0 args
	17	Return From Block'.

	"The temps map entry for the main method body must not include the clean block moved out of line. The copyingBlock temp is optimised out of the code, but remains allocated. This keeps the stack frame the same for debug and non-debug methods."
	self assert: method tempsMap
		equals: {
				(1 to: 14) -> #(#('a' 0 1)).
				(10 to: 13) -> #(#('a' 0 1)).
				(15 to: 17) -> #(#('each' 0 1))
			}!

testCompileTimeExpressions
	| result |
	self shouldnt: [result := self evaluateExpression: '##()'] raise: self compilationErrorClass.
	self assert: result equals: UndefinedObject.
	#('1' '1+2' 'nil' 'true' 'false' 'Smalltalk.Object') do: 
			[:each |
			| expected |
			expected := self evaluateExpression: each.
			self shouldnt: [result := self evaluateExpression: '##(' , each , ')']
				raise: self compilationErrorClass.
			self assert: result equals: expected].
	{self. self class} do: 
			[:each |
			result := (self compileExpression: '##(self)' in: each class) method value: each.
			self assert: result equals: each class instanceClass]!

testConstExpressionReferences
	"Test that references in a compile-time evaluated expression are retained in the literal frame 
	of the method (#1011)."

	| method |
	method := (self compileExpression: '##(#x , #y)') method.
	self assert: (method value: nil withArguments: #()) equals: 'xy'.
	self assert: (method refersToLiteral: #x).
	self assert: (method refersToLiteral: #y).
	self deny: (method refersToLiteral: #z)!

testCopyingBlockNestedInCleanBlock
	| method block |
	method := self getTestMethod: #testCopyingBlockNestedInCleanBlock.
	block := method literals at: 4.
	self assert: block isKindOf: BlockClosure.
	self assert: (block value: 'xyz') value equals: 'xyzzyx'.

	"Note how the copying block is moved out of line (i.e. after the main method return) because it is part of the enclosing clean block. If it copied values from the method context, then the enclosing block would also have to be a copying block, but it only copies the arg to the clean block."
	self assert: method disassembly
		equals: 'Normal, 0 args, 2 stack temps, 5 literals

	1	Push Const[0]: ''abc''
	2	Pop Temp[0]
	3	Push Const[3]: [] in Kernel.Tests.DolphinCompilerTestMethods>>#testCopyingB…
	4	Push Temp[0]
	5	Special Send #value:
	6	Return
	7	Push Temp[0]
	8	Block Copy, 0 args, 1 copied values, skip +4 to 19
	15	Push Temp[0]
	16	Push Temp[0]; Send[1]: #reverse with 0 args
	18	Send[2]: #, with 1 args
	19	Return From Block'.

	"The temps map entry for the main method body must not include the clean block moved out of line. The copyingBlock temp is optimised out of the code, but remains allocated. This keeps the stack frame the same for debug and non-debug methods."
	^self assert: method tempsMap
		equals: {
				(1 to: 6) -> #(#('a' 0 1) #('copyingBlock' 0 2)).
				(7 to: 19) -> #(#('arg' 0 1)).
				(15 to: 19) -> #(#('arg' 0 1))
			}!

testCopyingBlocks1
	| method |
	method := self getTestMethod: #testCopyingBlocks1.
	self assert: method stackTempCount equals: 1.
	self deny: method needsContext.
	self assert: (method value: DolphinCompilerTestMethods new withArguments: #())
		equals: Array new!

testCopyingBlocks2
	| method |
	method := self getTestMethod: #testCopyingBlocks2.
	self deny: method needsContext.
	self assert: method stackTempCount equals: 1.
	self assert: (method value: DolphinCompilerTestMethods new withArguments: #())
		equals: 'abc'!

testDecrementPushTempOptimisation
	| disasm expr expected |
	expr := (self compileExpression: '| j | 5 to: 1  by: -1 do: [:i | j := i]. j') method.
	self assert: expr literals single equals: #to:by:do:.
	disasm := expr disassembly.
	expected := 'Normal, 0 args, 2 stack temps, 1 literals

	1	Push 5
	3	Store Temp[1]
	4	Push 1
	5	Dup
	6	Push Temp[1]
	7	Jump +6 to 14
	8	Push Temp[1]
	9	Pop Temp[0]
	10	Dup
	11	Decrement & Push Temp[1]
	14	Special Send #>
	15	Jump If False -9 to 8
	17	Pop
	18	Pop; Push Temp[0]
	19	Return'.
	self assert: disasm equals: expected.
	self assert: (expr value: nil) equals: 1.
	expr := (self
				compileExpression: '| t1 t2 t3 t4 t5 t6 t7 j | t1 := t2 := t3 := t4 := t5 := t6 := t7 := 1. 5 to: 1 by: -1 do: [:i | j := i]. j')
					method.
	disasm := expr disassembly.
	expected := 'Normal, 0 args, 9 stack temps, <1d> literals

	1	Push 1
	2	Store Temp[6]
	4	Store Temp[5]
	6	Store Temp[4]
	8	Store Temp[3]
	9	Store Temp[2]
	10	Store Temp[1]
	11	Pop Temp[0]
	12	Push 5
	14	Store Temp[8]
	16	Push 1
	17	Dup
	18	Push Temp[8]
	20	Jump +7 to 28
	21	Push Temp[8]
	23	Pop Temp[7]
	24	Dup
	25	Decrement & Push Temp[8]
	28	Special Send #>
	29	Jump If False -10 to 21
	31	Pop
	32	Pop
	33	Push Temp[7]
	34	Return'
				expandMacrosWith: expr literalCount.
	self assert: disasm equals: expected.
	self assert: (expr value: nil) equals: 1.
	"Overflow"
	expr := (self compileExpression: '| i | i := SmallInteger minimum. i class. i := i - 1. i*1')
				method.
	self assert: (expr value: nil) equals: SmallInteger minimum - 1.
	"Non-small integer decremented"
	expr := (self compileExpression: '| i | i := 200 factorial. i class. i := i - 1. i*1') method.
	self assert: (expr value: nil) equals: 200 factorial - 1.
	"Non-integer decremented"
	expr := (self compileExpression: '| i | i := -1.0. i class. i := i - 1. i*1') method.
	self assert: (expr value: nil) equals: -1.0 - 1.
	"Non-number incremented"
	expr := (self compileExpression: '| i | i := ''a''. i class. i := i - 1. i*1') method.
	self should: [expr value: nil] raise: MessageNotUnderstood!

testDecrementTempOptimisation
	| disasm expr expected |
	expr := (self compileExpression: '| i | i := 5. [i < 1] whileFalse: [i := i - 1]. i') method.
	disasm := expr disassembly.
	expected := 'Normal, 0 args, 1 stack temps, <1d> literals

	1	Push 5
	3	Pop Temp[0]
	4	Push Temp[0]
	5	Push 1
	6	Special Send #%<
	7	Jump If True +5 to 14
	9	Decrement Temp[0]
	12	Jump -10 to 4
	14	Push Temp[0]
	15	Return'
				expandMacrosWith: expr literalCount.
	self assert: disasm equals: expected.
	self assert: (expr value: nil) equals: 0.
	expr := (self
				compileExpression: '| t1 t2 t3 t4 t5 t6 t7 t8 i | t1 := t2 := t3 := t4 := t5 := t6 := t7 := t8 := 1. i := 5. [i < 1] whileFalse: [i := i - 1]. i')
					method.
	disasm := expr disassembly.
	expected := 'Normal, 0 args, 9 stack temps, <1d> literals

	1	Push 1
	2	Store Temp[7]
	4	Store Temp[6]
	6	Store Temp[5]
	8	Store Temp[4]
	10	Store Temp[3]
	11	Store Temp[2]
	12	Store Temp[1]
	13	Pop Temp[0]
	14	Push 5
	16	Pop Temp[8]
	18	Push Temp[8]
	20	Push 1
	21	Special Send #%<
	22	Jump If True +5 to 29
	24	Decrement Temp[8]
	27	Jump -11 to 18
	29	Push Temp[8]
	31	Return'
				expandMacrosWith: expr literalCount.
	self assert: disasm equals: expected.
	"DiffBrowser  compare: disasm with: expected."
	self assert: (expr value: nil) equals: 0.
	"Overflow"
	expr := (self compileExpression: '| i | i := SmallInteger minimum. i class. i := i - 1. 5 class. i')
				method.
	self assert: (expr value: nil) equals: SmallInteger minimum - 1.
	"Non-small integer decremented"
	expr := (self compileExpression: '| i | i := 200 factorial. i class. i := i - 1. 5 class. i')
				method.
	self assert: (expr value: nil) equals: 200 factorial - 1.
	"Non-integer decremented"
	expr := (self compileExpression: '| i | i := -1.0. i class. i := i - 1. 5 class. i') method.
	self assert: (expr value: nil) equals: -1.0 - 1.
	"Non-number incremented"
	expr := (self compileExpression: '| i | i := ''a''. i class. i := i - 1. 5 class. i') method.
	self should: [expr value: nil] raise: MessageNotUnderstood!

testEmpty
	| method |
	method := (Compiler
				compile: 'nothing'
				in: UndefinedObject
				environment: nil
				flags: 0) method.
	self assert: method byteCodes equals: (ByteArray with: ReturnSelf)!

testEmptyIfInLoop
	"See #401. Due to an optimization bug, this gives an error in D5"

	self
		assert: ((self compileExpression: '1 to: 10 do: [:each | each = 1 ifTrue: []]') method value: nil
				withArguments: #())
		equals: 1!

testExtCallStructLiterals
	| method result |
	result := self
				compileMethod: 'x: a1 _: a2 _: a3 _: a4 <stdcall: FILETIME blah _FPIEEE_VALUE** MSG* UInt32* UInt64**>'
				in: KernelLibrary.
	method := result method.
	self assertNotNil: method.
	{FILETIME. _FPIEEE_VALUE. MSG} do: [:each | self assert: (method literals includes: each)].
	"Some classes have special type codes so are not added to the frame"
	{UInt32. UInt64} do: [:each | self deny: (method literals includes: each)]!

testFarReturnFromBlock
	| method block |
	method := (self compileExpression: '[^1]') method.
	self assert: method needsContext.
	block := method value: nil withArguments: #().
	self denyIsNil: block outer.
	"self assert: block receiver isNil"
	self
		should: [block value]
		raise: Error
		matching: [:ex | ex description beginsWith: 'Cannot return'].
	method := (self compileExpression: '[^self]' in: self class) method.
	self assert: method needsContext.
	block := method value: self withArguments: #().
	self denyIsNil: block outer.
	self assert: block receiver identicalTo: self.
	self
		should: [block value]
		raise: Error
		matching: [:ex | ex description beginsWith: 'Cannot return'].
	method := (self compileExpression: '[[^true] whileTrue]') method.
	self assert: method needsContext.
	block := method value: nil withArguments: #().
	self deny: block outer isNil.
	self
		should: [block value]
		raise: Error
		matching: [:ex | ex description beginsWith: 'Cannot return']!

testFloatScanning
	Float reset.
	#('5.1234' '0.0' '0.5' '1.2e1' '1.2d2' '1.2e-1' '1.2e+1' '1.2d-2' '1.2d+2' '1.0e308' '1.0e+308' '2.2250738585072014e-308' '1.7976931348623158e308' '1.7976931348623158e+308' '0.5e0' '0.5d0' '0.5q0' '0.5e+0' '0.5d+0' '0.5q+0' '0.5e-0' '0.5d-0' '0.5q-0')
		do: [:each | self scan: each class: Float].

	"Test termination on non-numeric character - these expressions are in error"
	#('5.1234a' '0.5e' '1.5e2e3' '1.5e2e-3' '1.5e-Integer zero')
		do: [:each | self scanNonNumericEnd: each class: Float].
	#('1.5e-' '1.5e+') do: 
			[:each |
			self
				should: [self evaluateExpression: each]
				raise: self compilationErrorClass
				matching: [:ex | (self messageFromError: ex) = 'invalid expression start']].

	"Integer terminated by a period, not a float"
	self scan: '5.' class: SmallInteger.

	"Period as statement separator with following statement an undeclared identifier"
	#(#('5.F' 'F') #('1.7976931348623158+e308' 'e308')) do: 
			[:each |
			self
				should: [self evaluateExpression: each first]
				raise: self compilationErrorClass
				matching: 
					[:ex |
					| start |
					start := each first indexOfSubCollection: each second.
					ex errorCode = CErrUndeclared and: [ex range = (start to: start + each second size - 1)]]].
	"#2219"
	self assert: 10.0 ** -316 equals: (self evaluateExpression: '1.0e-316')
	"308 to: -316
		by: -1
		do: [:each | self assert: (self evaluateExpression: ('1.0e<d>' expandMacrosWith: each)) - (10.0 ** each)]"!

testIdentical
	"Test that #== generates special send, but retained in literal frame"

	| result method disasm expected |
	result := self compileExpression: '1 == 2'.
	method := result method.
	self assert: method literals single equals: #==.
	disasm := method disassembly.
	expected := 'Normal, 0 args, 1 literals

	1	Push 1
	2	Push 2
	3	Special Send #==
	4	Return'.
	self assert: disasm equals: expected!

testIfNil
	| compiled method |
	compiled := self compileExpression: 'key ifNil: [value]' in: Association.
	method := compiled method.
	self assert: (method literals includes: #ifNil:).
	self assert: (method value: nil -> 2) equals: 2.
	self assert: (method value: 1 -> 2) equals: 1.
	self deny: (method messages includes: 'ifNil:' asSymbol).
	self assertBlocksOptimized: compiled!

testIfNilifNotNil
	| compiled method |
	compiled := self compileExpression: 'key ifNil: [value+1] ifNotNil: [:x | 1+x]' in: Association.
	method := compiled method.
	self assert: (method literals includes: #ifNil:ifNotNil:).
	self assert: (method value: nil -> 1 withArguments: #()) equals: 2.
	self assert: (method value: 5 -> nil withArguments: #()) equals: 6.
	self assertBlocksOptimized: compiled!

testIfNilifNotNilNoArg
	| compiled |
	compiled := self compileExpression: 'key ifNil: [value] ifNotNil: [key+2]' in: Association.
	self assert: (compiled method value: nil -> 4 withArguments: #()) equals: 4.
	self assert: (compiled method value: 1 -> 4 withArguments: #()) equals: 3.
	self assertBlocksOptimized: compiled!

testIfNilifNotNilNoArgUnused
	| compiled |
	compiled := self compileExpression: 'key ifNil: [value+3] ifNotNil: [value+2]. value'
				in: Association.
	self assert: (compiled method value: nil -> 4 withArguments: #()) equals: 4.
	self assert: (compiled method value: 1 -> 4 withArguments: #()) equals: 4.
	self assertBlocksOptimized: compiled!

testIfNilifNotNilUnused
	| compiled |
	compiled := self compileExpression: 'key ifNil: [value+1] ifNotNil: [:x | 1+x]. value'
				in: Association.
	self assert: (compiled method value: nil -> 1 withArguments: #()) equals: 1.
	self assert: (compiled method value: 5 -> 1 withArguments: #()) equals: 1.
	self assertBlocksOptimized: compiled!

testIfNilUnused
	| compiled |
	compiled := self compileExpression: 'key ifNil: [2]. value' in: Association.
	self assert: (compiled method value: nil -> 1) equals: 1.
	self assert: (compiled method value: 1 -> 2) equals: 2.
	self deny: (compiled method messages includes: 'ifNil:' asSymbol).
	self assertBlocksOptimized: compiled!

testIfNotNil
	| compiled method |
	compiled := self compileExpression: 'key ifNotNil: [:x | x + 2]' in: Association.
	method := compiled method.
	self assert: (method literals includes: #ifNotNil:).
	self assert: (method value: 1 -> nil) equals: 3.
	self assertIsNil: (method value: nil -> 1).
	self assertBlocksOptimized: compiled!

testIfNotNilifNil
	| compiled method |
	compiled := self compileExpression: 'key ifNotNil: [:x | x + 2] ifNil: [3]' in: Association.
	method := compiled method.
	self assert: (method literals includes: #ifNotNil:ifNil:).
	self assert: (method value: 5 -> nil) equals: 7.
	self assert: (method value: nil -> 5) equals: 3.
	self assertBlocksOptimized: compiled!

testIfNotNilifNilNoArg
	| compiled |
	compiled := self compileExpression: 'key ifNotNil: [key] ifNil: [value]' in: Association.
	self assert: (compiled method value: 1 -> 2) equals: 1.
	self assert: (compiled method value: nil -> 2) equals: 2.
	self assertBlocksOptimized: compiled!

testIfNotNilifNilNoArgUnused
	| compiled |
	compiled := self compileExpression: 'key ifNotNil: [key+1] ifNil: [value+1]. self' in: Association.
	self assert: (compiled method value: 1 -> 2) equals: 1 -> 2.
	self assert: (compiled method value: nil -> 2) equals: nil -> 2.
	self assertBlocksOptimized: compiled!

testIfNotNilifNilUnused
	| compiled |
	compiled := self compileExpression: 'key ifNotNil: [:x | x + 2] ifNil: [3]. value' in: Association.
	self assert: (compiled method value: 5 -> 8) equals: 8.
	self assert: (compiled method value: nil -> 5) equals: 5.
	self assertBlocksOptimized: compiled!

testIfNotNilNoArg
	| compiled |
	compiled := self compileExpression: 'key ifNotNil: [1+2]' in: Association.
	self assert: (compiled method value: 4 -> nil) equals: 3.
	self assertIsNil: (compiled method value: nil -> 1).
	self assertBlocksOptimized: compiled!

testIfNotNilNoArgUnused
	| compiled |
	compiled := self compileExpression: 'key ifNotNil: [key+1]. value' in: Association.
	self assert: (compiled method value: 1 -> 5) equals: 5.
	self assert: (compiled method value: nil -> 10) equals: 10.
	self assertBlocksOptimized: compiled!

testIfNotNilUnused
	| compiled |
	compiled := self compileExpression: 'key ifNotNil: [:x | x + 2]. value' in: Association.
	self assert: (compiled method value: 1 -> 10) equals: 10.
	self assert: (compiled method value: nil -> 11) equals: 11.
	self assertBlocksOptimized: compiled!

testImmutableLiterals
	| method |
	method := self getTestMethod: #testImmutableLiterals.
	method literalReferencesDo: [:each | self assert: each isImmutable]!

testIncrementDecrementOptimisation
	"See #1184"

	| method debugMap debugMethod map i |
	#('1 - 1' '1+-1') do: 
			[:each |
			method := (self compileExpression: each) method.
			self assert: (method value: nil withArguments: #()) equals: 0.
			self assert: method byteCodes
				equals: (ByteArray
						with: self shortPushOne
						with: Decrement
						with: ReturnFromMessage).
			debugMethod := method asDebugMethod.
			self assert: debugMethod byteCodes
				equals: (ByteArray
						with: self shortPushOne
						with: Break
						with: Decrement
						with: Break
						with: ReturnFromMessage).
			map := method debugInfo textMap.
			debugMap := debugMethod debugInfo textMap.
			self assert: map size equals: 2.
			self assert: debugMap size equals: map size.
			self assert: (map collect: [:e | e key]) asArray equals: #(2 3).
			self assert: (debugMap collect: [:e | e key]) asArray equals: #(3 5)].
	#('1 + 1' '1 - -1') do: 
			[:each |
			method := (self compileExpression: each) method.
			self assert: (method literals includes: each subStrings second asSymbol).
			self assert: (method value: nil withArguments: #()) equals: 2.
			self assert: method byteCodes
				equals: (ByteArray
						with: self shortPushOne
						with: Increment
						with: ReturnFromMessage).
			debugMethod := method asDebugMethod.
			self assert: debugMethod byteCodes
				equals: (ByteArray
						with: self shortPushOne
						with: Break
						with: Increment
						with: Break
						with: ReturnFromMessage).
			map := method debugInfo textMap.
			debugMap := debugMethod debugInfo textMap.
			self assert: map size equals: 2.
			self assert: debugMap size equals: map size.
			self assert: (map collect: [:e | e key]) asArray equals: #(2 3).
			self assert: (debugMap collect: [:e | e key]) asArray equals: #(3 5)].
	"Check correct optimisation in debug method, and also debug text mapping syncs up "
	method := self getTestMethod: #testIncrementOptimisationMNU.
	self assert: (method byteCodes at: 5) equals: Increment.
	self assert: (method byteCodes at: 6) equals: ShortPopTemp + 1.
	self should: [self evalTestMethod: method] raise: MessageNotUnderstood.
	"Check debug frame re-mapping for increments that result in actual Send+ (split instruction)"
	map := method debugInfo textMap.
	debugMethod := method asDebugMethod.
	debugMap := debugMethod debugInfo textMap.
	self assert: map size equals: debugMap size.
	i := CompiledCode findIp: 5 inTextMap: map.
	self assert: (map at: i) key equals: 5.
	self assert: (map at: i) value equals: (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) equals: Increment.
	i := CompiledCode findIp: 6 inTextMap: map.
	self assert: (map at: i) key equals: 6.
	self assert: (map at: i) value equals: (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) equals: ShortPopTemp + 1!

testIncrementPushTempOptimisation
	| disasm method map debugMethod debugMap i |
	method := self getTestMethod: #testIncrementPushTempOptimisation.
	"#+ should still be in literal frame as a reference, even though not used (same for special send of #class)"
	self assert: method literals equals: #(#class #+).
	disasm := method disassembly.
	self assert: disasm
		equals: 'Normal, 0 args, 2 stack temps, 2 literals

	1	Push 1
	2	Store Temp[0]
	3	Special Send #class
	4	Pop
	5	Increment & Push Temp[0]
	8	Store Temp[1]
	9	Special Send #class
	10	Pop; Push Temp[1]
	11	Return'.
	self assert: (self evalTestMethod: method) equals: 2.

	"Need to be careful that optimisations like this (which combine instructions) map correctly to debug methods. In this case the optimised instruction
	is composed of a prefix, followed by the Store instruction. The debug method does not have the optimisation, but the text map for the release version
	must have an entry for both parts of the instruction."
	debugMethod := method asDebugMethod.
	map := method debugInfo textMap.
	self assert: (method byteCodes at: 5) equals: IncPushTemp.
	self assert: (method byteCodes at: 6) equals: StoreTemp.
	self assert: (method byteCodes at: 7) equals: 0.	"temp 0"
	i := CompiledCode findIp: 5 inTextMap: map.
	self assert: (map at: i) key equals: 5.
	self assert: (method getSource copyFrom: (map at: i) value start to: (map at: i) value stop)
		equals: 'i + 1'.
	"Check debug frame re-mapping for increments that result in actual Send+ (split instruction)"
	debugMap := debugMethod debugInfo textMap.
	self assert: (map at: i) value equals: (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) equals: Increment.
	i := CompiledCode findIp: 6 inTextMap: map.
	self assert: (map at: i) key equals: 6.
	self assert: (map at: i) value equals: (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) equals: ShortStoreTemp + 0.

	"Longer temp offset"
	method := self getTestMethod: #testIncrementPushTempOptimisationLong.
	self assert: (method byteCodes at: 25) equals: IncPushTemp.
	self assert: (self evalTestMethod: method) equals: 5.
	"Overflow"
	method := self getTestMethod: #testIncrementPushTempOptimisationOverflow.
	self assert: (method byteCodes at: 6) equals: IncPushTemp.
	self assert: (self evalTestMethod: method) equals: SmallInteger maximum + 1.
	"Non-small integer incremented"
	method := self getTestMethod: #testIncrementPushTempOptimisationLargeInt.
	self assert: (method byteCodes at: 8) equals: IncPushTemp.
	self assert: (self evalTestMethod: method) equals: 200 factorial + 1.
	"Non-integer incremented"
	method := self getTestMethod: #testIncrementPushTempOptimisationFloat.
	self assert: (method byteCodes at: 5) equals: IncPushTemp.
	self assert: (self evalTestMethod: method) equals: 1.0 + 1.
	"Non-number incremented"
	method := self getTestMethod: #testIncrementPushTempOptimisationMNU.
	self assert: (method byteCodes at: 5) equals: IncPushTemp.
	self should: [method value: nil] raise: MessageNotUnderstood!

testIncrementTempOptimisation
	| disasm method map debugMethod debugMap i expected |
	method := self getTestMethod: #testIncrementTempOptimisation.
	self assert: method literals equals: #(#> #whileFalse: #+).
	disasm := method disassembly.
	expected := 'Normal, 0 args, 1 stack temps, <1d> literals

	1	Push 1
	2	Pop Temp[0]
	3	Push Temp[0]
	4	Push 5
	6	Special Send #>
	7	Jump If True +5 to 14
	9	Increment Temp[0]
	12	Jump -11 to 3
	14	Push Temp[0]
	15	Return'
				expandMacrosWith: method literalCount.
	self assert: disasm equals: expected.
	self assert: (self evalTestMethod: method) equals: 6.
	method := self getTestMethod: #testIncrementTempOptimisationLong.
	self assert: (method byteCodes at: 24) equals: IncTemp.
	self assert: (self evalTestMethod: method) equals: 6.
	"Overflow"
	method := self getTestMethod: #testIncrementTempOptimisationOverflow.
	self assert: (method byteCodes at: 6) equals: IncTemp.
	self assert: (self evalTestMethod: method) equals: SmallInteger maximum + 1.
	"Non-small integer incremented"
	method := self getTestMethod: #testIncrementTempOptimisationLargeInt.
	self assert: (method byteCodes at: 8) equals: IncTemp.
	self assert: (self evalTestMethod: method) equals: 200 factorial + 1.
	"Non-integer incremented"
	method := self getTestMethod: #testIncrementTempOptimisationFloat.
	self assert: (method byteCodes at: 5) equals: IncTemp.
	self assert: (self evalTestMethod: method) equals: 1.0 + 1.
	"Non-number incremented"
	method := self getTestMethod: #testIncrementTempOptimisationMNU.
	self assert: (method byteCodes at: 5) equals: IncTemp.
	self assert: (method byteCodes at: 6) equals: PopTemp.
	self assert: (method byteCodes at: 7) equals: 0.	"temp 0"
	self should: [self evalTestMethod: method] raise: MessageNotUnderstood.
	"Check debug frame re-mapping for increments that result in actual Send+ (split instruction)"
	map := method debugInfo textMap.
	debugMethod := method asDebugMethod.
	debugMap := debugMethod debugInfo textMap.
	i := CompiledCode findIp: 5 inTextMap: map.
	self assert: (map at: i) key equals: 5.
	self assert: (map at: i) value equals: (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) equals: Increment.
	i := CompiledCode findIp: 6 inTextMap: map.
	self assert: (map at: i) key equals: 6.
	self assert: (map at: i) value equals: (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) equals: ShortPopTemp + 0!

testIntegerScanning
	"Test Number>>readFrom: with Integers"

	| source |
	#('0' '-0' '1' '-1' '-1.' '123.' '123 ' '1073741823' '-1073741824' '1e1' '1e+1' '1073741823e0' '1073741823e-0' '-1073741823e-0')
		do: [:each | self scan: each class: SmallInteger].
	#('1e-1' '1e-307') do: 
			[:each |
			| result expected |
			expected := Number readFrom: each readStream.
			result := self evaluateExpression: each.
			self assert: result class identicalTo: Fraction.
			self assert: result equals: expected].
	#('1073741824' '-1073741825' '2147483647' '2147483649' '-2147483648' '-2147483649' '1e308')
		do: [:each | self scan: each class: LargeInteger].
	#('0A' '-0A' '123e' '1e1e2' '1e+-2') do: [:each | self scanNonNumericEnd: each class: SmallInteger].

	"Initially appears to be negative exponent"
	source := '123e-'.
	self
		should: [self evaluateExpression: source]
		raise: self compilationErrorClass
		matching: [:ex | (self messageFromError: ex) = 'invalid expression start']!

testIntegerScanningBoundaries
	#(0 1 15 16 31 32 63 64 65) do: 
			[:eachPower |
			| values x |
			values := OrderedCollection new: 6.
			x := 1 bitShift: eachPower.
			values
				add: (x + 1) negated;
				add: (x - 1) negated;
				add: x negated;
				add: x - 1;
				add: x;
				add: x + 1.
			values do: 
					[:eachVal |
					self assert: (self evaluateExpression: eachVal printString) equals: eachVal.
					"Now test again with a radix prefix"
					#(2 10 16 36)
						do: [:eachRadix | (self evaluateExpression: (eachVal printStringRadix: eachRadix)) = eachVal]]]!

testKeywordAnnotations
	| method |
	method := Compiler
				compile: 'test 
	<string: ''abc''> 
	<namespace: Smalltalk>
	<smallint: 123 largeint: 16r7FFFFFFFFFFFFFFF>
	<float: 4.56>
	<class: Core.Tests static: Processor>
	<expr: ##(Dictionary withAll: {''a'' -> 1. ''b'' -> 2})>'
				in: Object.
	self assert: method isAnnotated.
	self assert: method annotations isImmutable.
	self assert: method annotations asArray
		equals: {Message selector: #string: arguments: #('abc').
				Message selector: #namespace: arguments: {Smalltalk}.
				Message selector: #smallint:largeint: arguments: #(123 16r7FFFFFFFFFFFFFFF).
				Message selector: #float: arguments: #(4.56).
				Message selector: #class:static: arguments: {Core.Tests. Processor}.
				Message selector: #expr: arguments: {Dictionary withAll: {'a' -> 1. 'b' -> 2}}}.
	self assert: method annotations last arguments isImmutable.
	self assert: method customEnvironment identicalTo: Smalltalk!

testLiteralArray
	self assert: (Compiler evaluate: '#(-)') equals: {#-}.
	self assert: (Compiler evaluate: '#(-1)') equals: {-1}.
	self assert: (Compiler evaluate: '#(-a)') equals: {#-. #a}.
	self assert: (Compiler evaluate: '#(- 1)') equals: {#-. 1}!

testLiteralStringEncoding
	"The compiler should now always produce Utf8String instances for literals, whether they are entirely Ascii or not."

	{'abc' asAnsiString.
		'1234' asAnsiString.
		$£ asUtf8String.
		(Character codePoint: 128) asUtf8String.
		Character dolphin asUtf8String.
		Character byteCharacterSet copyFrom: 2 to: 128} do: 
				[:each |
				| actual array |
				actual := Compiler evaluate: each printString.
				self assert: actual equals: each.
				self assert: actual isKindOf: Utf8String.
				array := '#(' , each printString , ')'.
				actual := (Compiler evaluate: array) first.
				self assert: actual equals: each.
				self assert: actual isKindOf: Utf8String]!

testMapIpWithVoidedEntry
	| method debugMap textMap debugMethod |
	method := self getTestMethod: #performOn:.
	"If the bytecode generation changes, then this test will be inconclusive, so we need to detect that"
	self assert: method disassembly
		equals: 'Normal, 1 args, 1 stack temps, 8 literals

	1	Push Self; Send[0]: #context with 0 args
	2	Store Temp[1]
	3	Send[1]: #empty with 0 args
	4	Pop
	5	Push Inst Var[1]: iv2
	6	Push Temp[0]; Push Temp[1]
	8	Send[2]: #match:inContext: with 2 args
	9	Jump If False +9 to 20
	11	Push Self; Push Temp[0]
	12	Send[3]: #canMatch: with 1 args
	13	Jump If False +6 to 20
	14	Push Inst Var[0]: iv1
	15	Send[4]: #recusivelySearchInContext with 0 args
	16	Pop; Push Self
	17	Push Temp[0]
	18	Send[5]: #foundMatchFor: with 1 args
	19	Return
	20	Return nil'.
	textMap := method debugInfo textMap.
	self assert: textMap
		equals: {
				1 -> (168 to: 179).
				2 -> (161 to: 179).
				3 -> (184 to: 192).
				8 -> (200 to: 237).
				9 -> (240 to: 243).
				12 -> (246 to: 272).
				0 -> (279 to: 285).
				15 -> (293 to: 321).
				18 -> (328 to: 359).
				19 -> (197 to: 378).
				20 -> (197 to: 378)
			}.
	debugMethod := method asDebugMethod.
	"Note that the debug method is still 'optimised', as this is necessary so that the text maps (used by the debugger to remap normal frames to debug frames) align.
	There will be fewer optimisation opportunities due to the Break instructions, in particular macro instructions such as send-to-self, will be split"
	self assert: debugMethod disassembly
		equals: 'Normal, 1 args, 1 stack temps, 8 literals, debug

	1	Push Self
	2	*Break
	3	Send[0]: #context with 0 args
	4	*Break
	5	Store Temp[1]
	6	*Break
	7	Send[1]: #empty with 0 args
	8	Pop
	9	Push Inst Var[1]: iv2
	10	Push Temp[0]; Push Temp[1]
	12	*Break
	13	Send[2]: #match:inContext: with 2 args
	14	Jump If False +14 to 30
	16	Push Self; Push Temp[0]
	17	*Break
	18	Send[3]: #canMatch: with 1 args
	19	Jump If False +9 to 30
	21	Push Inst Var[0]: iv1
	22	*Break
	23	Send[4]: #recusivelySearchInContext with 0 args
	24	Pop; Push Self
	25	Push Temp[0]
	26	*Break
	27	Send[5]: #foundMatchFor: with 1 args
	28	*Break
	29	Return
	30	*Break
	31	Return nil'.
	debugMap := debugMethod debugInfo textMap.
	self assert: debugMap
		equals: {
				3 -> (168 to: 179).
				5 -> (161 to: 179).
				7 -> (184 to: 192).
				13 -> (200 to: 237).
				14 -> (240 to: 243).
				18 -> (246 to: 272).
				0 -> (279 to: 285).
				23 -> (293 to: 321).
				27 -> (328 to: 359).
				29 -> (197 to: 378).
				31 -> (197 to: 378)
			}.
	self skip. 'Work in progress - works with old mapIP:toDebug:, but not replacement yet as doesn''t skip voided entry'.
	"Verify that we can remap every ip in the method to the correct ip in the debug method, although in practice we only need to map bytecodes for the potential break points (mainly sends)."
	#(#(1 3) #(2 5) #(3 7) #(4 8) #(5 9) #(6 10) #(8 13) #(9 14) #(11 16) #(12 18) #(13 19) #(14 21) #(15 23) #(16 24) #(17 25) #(18 27) #(19 29) #(20 31))
		do: [:pair | self assert: (method mapIp: pair first toDebug: debugMethod) equals: pair second]!

testMutableAnnotation
	| class mutator inst |
	class := CompilerTestClasses current testClass.
	mutator := class compile: 'iv1_mutable: op <mutable> iv1 := op'.
	self assert: mutator isAnnotated.
	self assert: mutator annotations asArray equals: {Message selector: #mutable}.
	inst := class new.
	self assert: mutator extraIndex equals: 49.
	inst perform: mutator selector with: 123.
	self assert: (inst perform: #iv1) equals: 123!

testNestedCopyingBlocks
	| method value value2 |
	method := self getTestMethod: #testNestedCopyingBlocks.
	self deny: method needsContext.
	self assert: method stackTempCount equals: 1.
	value := method value: DolphinCompilerTestMethods new withArguments: #().
	self assert: value isKindOf: BlockClosure.
	"Should only be one copied values, 0 temps and args"
	self assert: value tempCount equals: 1.
	self assert: value argumentCount equals: 0.
	self assert: value stackTempCount equals: 0.
	self assert: value size equals: 1.
	value2 := value value.
	self assert: value2 isKindOf: BlockClosure.
	"Should only be one copied values, 0 temps and args"
	self assert: value2 tempCount equals: 1.
	self assert: value2 argumentCount equals: 0.
	self assert: value2 stackTempCount equals: 0.
	self assert: value2 size equals: 1.
	self assert: value2 value equals: 'abcabc'!

testNestedWhileTrueAtStartOfCleanBlock
	"Nested optimized blocks where the block occurs before the message are a tricky case
	for the compiler"

	| method block literals |
	method := self getTestMethod: #testNestedWhileTrueAtStartOfCleanBlock.
	block := method value: DolphinCompilerTestMethods new withArguments: #().
	literals := method literals.
	self assert: (literals identityIncludes: block).
	self assert: literals last equals: #whileTrue.
	self deny: block identicalTo: [].
	"Block should start immediately after a short push const and return stack top"
	self assert: block initialIP equals: 3.
	self assert: method disassembly
		equals: 'Normal, 0 args, 4 literals

	1	Push Const[2]: [] in Kernel.Tests.DolphinCompilerTestMethods>>#testNestedWh…
	2	Return
	3	Push Const[0]: #()
	4	Send[1]: #notEmpty with 0 args
	5	Jump If True -4 to 3
	7	Push nil
	8	Return From Block'.
	self assert: method tempsMap equals: { (1 to: 2) -> #(). (3 to: 8) -> #(). (3 to: 4) -> #() }!

testNotIdentical
	"Test that #~~ generates special send, but retained in literal frame"

	| result method disasm expected |
	result := self compileExpression: '1 ~~ 2'.
	method := result method.
	self assert: method literals single equals: #~~.
	disasm := method disassembly.
	expected := 'Normal, 0 args, 1 literals

	1	Push 1
	2	Push 2
	3	Special Send #~~
	4	Return'.
	self assert: disasm equals: expected!

testOptimizedLoopReadBeforeWritten
	| expected expr actual |
	expected := OrderedCollection new.
	(1 to: 5) do: 
			[:i | 
			| a |
			expected add: a displayString , i displayString.
			a := i].
	expr := (self 
				compileExpression: '| r | r := OrderedCollection new. 1 to: 5 do: [:i | | a | r add: a displayString, i displayString. a := i]. r') 
					method.
	actual := expr value.
	self skip: 'Results of actual block evaluation in a loop and optimized loop should be the same - any	read-before-written locals must be reinitialized to nil on each iteration'.
	self assert: actual equals: expected!

testPopReturn
	| method debugMap textMap debugMethod |
	method := self getTestMethod: #appendToStream:.
	"If the bytecode generation changes, then this test will be inconclusive, so we need to detect that"
	self assert: method disassembly
		equals: 'Normal, 1 args, 1 literals

	1	Push Temp[0]
	2	Push Self
	3	Send[0]: #nextPut: with 1 args
	4	Pop; Return self'.
	textMap := method debugInfo textMap.
	self assert: textMap equals: { 3 -> (90 to: 117). 4 -> (118 to: 117) }.
	debugMethod := method asDebugMethod.
	"Note that the debug method is still 'optimised', as this is necessary so that the text maps (used by the debugger to remap normal frames to debug frames) align.
	There will be fewer optimisation opportunities due to the Break instructions, in particular macro instructions such as send-to-self, will be split"
	self assert: debugMethod disassembly
		equals: 'Normal, 1 args, 1 literals, debug

	1	Push Temp[0]
	2	Push Self
	3	*Break
	4	Send[0]: #nextPut: with 1 args
	5	Pop
	6	*Break
	7	Return self'.
	debugMap := debugMethod debugInfo textMap.
	debugMap with: textMap do: [:debug :nondebug | self assert: debug value equals: nondebug value].

	"Verify that we can remap every ip in the method to the correct ip in the debug method, although in practice we only need to map bytecodes for the potential break points (mainly sends)."
	self skip: 'BUG: Debug IP remap incorrect because of Pop; Return optimisation'.
	#(#(1 1) #(2 2) #(3 4) #(4 5))
		do: [:pair | self assert: (method mapIp: pair first toDebug: debugMethod) equals: pair second]!

testQualifiedReference
	{Array. #(). nil. nil} pairsDo: 
			[:eachContext :eachReceiver |
			| compiled ref |
			compiled := self compileExpression: '#(#{Object} #{Object class})' in: eachContext.
			ref := BindingReference pathString: 'Object' scope: eachContext.
			self assert: (compiled method value: eachReceiver) equals: {ref. ref meta}]!

testRadixInteger
	2 to: 36
		do: 
			[:eachRadix |
			0 to: eachRadix * 2 - 1
				by: 3
				do: [:eachVal | (self evaluateExpression: (eachVal printStringRadix: eachRadix)) = eachVal]].
	0 to: 35
		do: 
			[:eachRadix |
			| suffix |
			"Test invalid radix integers cause an MNU of #rN"
			suffix := String with: $r with: (Character digitValue: eachRadix).
			self
				should: 
					[| expr |
					expr := eachRadix printString , suffix.
					self evaluateExpression: expr]
				raise: MessageNotUnderstood
				matching: [:ex | (ex receiver = eachRadix and: [ex selector = suffix]) ifFalse: [false] ifTrue: [true]]]!

testReturnFromOptimizedBlock
	| compiled lowerText upperText |
	compiled := self getTestMethod: #testReturnFromOptimizedBlock.
	self assert: compiled needsContext.
	"Note that the far returns in the optimized ifTrue: blocks can be replaced with normal returns"
	lowerText := compiled disassembly.
	upperText := 'Normal, 0 args, 0 env temps, <1d> literals, needs context

	1	Push 1
	2	Push 2
	3	Special Send #>
	4	Jump If False +2 to 7
	5	Push 1
	6	Return
	7	Block Copy, 0 args, needs self, needs outer, skip +2 to 16
	14	Push Self
	15	Far Return
	16	Pop
	17	Push 2
	18	Push 1
	19	Special Send #%<
	20	Jump If False +18 to 40
	22	Push 1
	23	Push 2
	24	Special Send #>
	25	Jump If False +1 to 27
	26	Return nil
	27	Block Copy, 0 args, needs self, needs outer, skip +2 to 36
	34	Push Self
	35	Far Return
	36	Special Send #value
	37	Pop
	38	Jump -39 to 1
	40	Return nil'
				expandMacrosWith: compiled literalCount.
	self assert: lowerText equals: upperText
	"
DiffBrowser show
	compare: lowerText id: 'Actual'
	and: upperText id: 'Expected'
"!

testReturnIfNotNil
	| method debugMap textMap debugMethod |
	method := self getTestMethod: #associationAt:.
	"If the bytecode generation changes, then this test will be inconclusive, so we need to detect that"
	self assert: method disassembly
		equals: 'Normal, 1 args, 1 stack temps, 3 literals

	1	Push Self; Push Temp[0]
	2	Push nil
	3	Send[0]: #associationAt:ifAbsent: with 2 args
	4	Return If Not Nil
	5	Push Self; Push Temp[0]
	6	Send[1]: #errorKeyNotFound: with 1 args
	7	Return'.
	textMap := method debugInfo textMap.
	self assert: textMap
		equals: { 3 -> (172 to: 212). 4 -> (171 to: 286). 6 -> (226 to: 255). 7 -> (170 to: 286) }.
	debugMethod := method asDebugMethod.
	"Note that the debug method is still 'optimised', as this is necessary so that the text maps (used by the debugger to remap normal frames to debug frames) align.
	There will be fewer optimisation opportunities due to the Break instructions, in particular macro instructions such as send-to-self, will be split"
	self assert: debugMethod disassembly
		equals: 'Normal, 1 args, 1 stack temps, 3 literals, debug

	1	Push Self; Push Temp[0]
	2	Push nil
	3	*Break
	4	Send[0]: #associationAt:ifAbsent: with 2 args
	5	Dup
	6	*Break
	7	Jump If Not Nil +6 to 15
	9	Pop; Push Self
	10	Push Temp[0]
	11	*Break
	12	Send[1]: #errorKeyNotFound: with 1 args
	13	*Break
	14	Return
	15	Store Temp[1]
	16	*Break
	17	Return'.

	"Verify that we can remap every ip in the method to the correct ip in the debug method, although in practice we only need to map bytecodes for the potential break points (mainly sends)."
	#(#(1 1) #(2 2) #(3 4) #(4 7) #(5 9) #(6 12) #(7 14))
		do: [:pair | self assert: (method mapIp: pair first toDebug: debugMethod) equals: pair second].

	self skip: 'BUG: Text maps are of different sizes. This should never be the case'.
	debugMap := debugMethod debugInfo textMap.
	debugMap with: textMap do: [:debug :nondebug | self assert: debug value equals: nondebug value].!

testReturnImmediate
	"#397"

	| method |
	#(-128 -2 3 127) do: 
			[:each |
			method := (self compileExpression: (each printStringRadix: 2)) method.
			self assert: method extraIndex equals: 5.
			self assert: method byteCodes
				equals: (ByteArray
						with: Nop
						with: PushImmediate
						with: (each bitAnd: 16rFF)
						with: ReturnFromMessage)].
	#(2r1111111111 2r11111111111 2r111111111111 2r1111111111111 2r11111111111111 2r111111111111111 -2r111111111111111 16r3FFFFFFF -16r40000000)
		do: 
			[:each |
			method := (self compileExpression: (each printStringRadix: 2)) method.
			self assert: method extraIndex equals: 5.
			self assert: method byteCodes equals: (ByteArray with: ShortPushConst + 0 with: ReturnFromMessage)]!

testReturnPseudoVar
	| method |
	#(true false nil) keysAndValuesDo: 
			[:eachKey :eachValue |
			| selector bytecodes retInstr |
			selector := ('testReturn' , eachValue printString capitalized) asSymbol.
			method := self getTestMethod: selector.
			retInstr := ReturnSelf + eachKey.
			bytecodes := retInstr odd
						ifTrue: [ByteArray with: retInstr]
						ifFalse: [ByteArray with: Nop with: retInstr].
			self assert: method byteCodes equals: bytecodes.
			self assert: (method value: DolphinCompilerTestMethods new withArguments: #())
				equals: eachValue]!

testScanningScaledDecimals
	"Test Number>>readFrom: with ScaledDecimals"

	| string result |
	#('123s' '123s2' '123.0s' '123.12s' '123.12s2' '123.12s3')
		do: [:each | self scanScaledDecimal: each].
	string := '123s-2'.
	result := self evaluateExpression: string.
	self assert: result class identicalTo: ScaledDecimal.
	self assert: result scale equals: 0.
	self assert: result equals: 121.
	#('123se' '123.0se' '123.0s2e') do: [:each | self scanNonNumericEnd: each class: ScaledDecimal].
	self
		should: [self evaluateExpression: '123.s']
		raise: self compilationErrorClass
		matching: [:ex | ex errorCode = CErrUndeclared and: [ex range = (5 to: 5)]]!

testScope
	| compiled text |
	text := '[ | a b |
	a := b := 1.
	a 
		ifNil: [b ifNotNil: [:arg | arg "do nothing"]]
		ifNotNil: [:arg | arg "do nothing"]]'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	"Temps cannot be reused"
	"	self assert: compiled method tempCount == 4."
	self assert: (compiled method value: nil withArguments: #()) tempCount identicalTo: 4.
	text := '[ | a |
	a := 1.
	a ifNotNil: [:arg | arg "do nothing"].
	a ifNotNil: [:arg | arg "do nothing"]]'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	"	self assert: compiled method tempCount == 3."
	self assert: (compiled method value: nil withArguments: #()) tempCount identicalTo: 3.
	compiled := nil.
	text := '[|a|
	a ifNotNil: [:arg | "do nothing" ].
	arg ifNil: [self halt]]'.
	self
		should: 
			[Compiler
				compileExpression: text
				in: UndefinedObject
				environment: nil
				flags: defaultCompileFlags]
		raise: self compilationErrorClass
		matching: [:ex | ex errorCode = CErrUndeclared]!

testSharedOuterTemps
	#(#testSharedOuterTemps1 #testSharedOuterTemps2) do: 
			[:selector |
			| value value2 method |
			method := self getTestMethod: selector.
			self assert: method needsContext.
			self assert: method envTempCount equals: 1.
			value := method value: DolphinCompilerTestMethods new withArguments: #().
			self assert: value isKindOf: BlockClosure.
			"Should only be 0 copied values, temps and args"
			self assert: value size equals: 0.
			self assert: value tempCount equals: 0.
			self assert: value argumentCount equals: 0.
			self assert: value stackTempCount equals: 0.
			value2 := value value.
			self assert: value2 isKindOf: BlockClosure.
			"Should only be 0 copied values, temps and args"
			self assert: value2 size equals: 0.
			self assert: value2 tempCount equals: 0.
			self assert: value2 argumentCount equals: 0.
			self assert: value2 stackTempCount equals: 0.
			self assert: value2 value equals: 2]!

testSpecialLiteralsAsUnarySelectors
	"nil, true and false should all be valid as method selectors"

	| method |
	#(nil true false) do: 
			[:each |
			method := [method := self compileMethod: ('<1p> ^super <1p>' expandMacrosWith: each) in: self class]
						on: CompilerNotification
						do: 
							[:ex |
							"Supersend generates a warning, since superclass doesn't implement"
							self assert: ex severityName equals: #Warning.
							ex resume].
			self denyIsNil: method]!

testStringLiteralFolding
	"String literals should be folded to a single immutable instance in the literal frame if they occur more than once."

	| expr literals |
	expr := (self
				compileExpression: '| a1 aa1 a2 aa2 | a1 := ##(''A'' asLowercase asUtf8String). #blah. aa1 := ''A''. #blah. a2 := ''a''. #blah. aa2 := ''A''. a1 == a2 and: [aa1 == aa2]')
					method.
	self assert: (expr value: nil withArguments: #()).
	self assert: expr literalCount equals: 7.
	literals := expr literals.
	self assert: literals asSortedArray equals: #(#== 'a' 'A' #and: #asLowercase #asUtf8String #blah).
	self assert: (literals allSatisfy: [:each | each isImmutable])!

testStringLiteralWithEmbeddedNulls
	"String literals should be able to contain with embedded nulls."

	| expr literals stringWithNull source |
	stringWithNull := String
				with: $a
				with: $\0
				with: $b.
	source := '''', stringWithNull, ''',  ''a'', ##(String with: $a with: $\0 with: $b)'.
	expr := (self compileExpression: source) method.
	self assert: (expr value: nil withArguments: #()) equals: stringWithNull , 'a' , stringWithNull.
	self assert: expr literalCount equals: 5.
	literals := expr literals.
	self assert: (literals noDifference: {stringWithNull. 'a'. #,. String binding. #with:with:with:})!

testSymbolScanning
	#('#a' '#a1' '#a:' '#a1:' '#a:b:' '#a_:_:' '#a1:b2:' '#|' '#||' '#|||' '#_' '#_a' '#-' '#--' '#''£''' '#''你好''' '#''🐬''')
		do: 
			[:each |
			| sym bracketed chars |
			sym := self evaluateExpression: each.
			self denyIsNil: sym.
			chars := (each copyFrom: 2) copyWithout: $'.
			self assert: sym equals: chars.
			bracketed := '(' , each , ')'.
			sym := self evaluateExpression: bracketed.
			self denyIsNil: sym.
			self assert: sym equals: chars].
	#('#2' '#;' '#:') do: 
			[:each |
			| errors |
			errors := OrderedCollection new.
			self assertIsNil: ([self evaluateExpression: each] on: self compilationErrorClass
						do: 
							[:ex |
							errors add: ex.
							ex resume]).
			self assert: errors single description equals: 'Error: nil>>(null) at line 1: constant expected'].
	#('#a:a' '#a:ab' '#ab:a' '#ab:ab') do: 
			[:each |
			self
				should: [self evaluateExpression: each]
				raise: MessageNotUnderstood
				matching: 
					[:ex |
					| colon |
					colon := each indexOf: $:.
					ex receiver == (each copyFrom: 2 to: colon) asSymbol
						and: [ex selector == (each copyFrom: colon + 1) asSymbol]]]!

testTempMapOuterDepthExhaustive
	"Check that the temp maps for all methods with env temps have the correct outer depth. Note
	that this is very long running as it compiles every method in the system and analyses the
	bytecodes for temp references and compares those against the debug info temps map."

	self skip: 'Failing on (at least) File class>>#shortenComponent:max:'.
	self knownTempsMapIssues not methodsDo: [:each | self verifyTempsMapOf: each]!

testTempMaps
	"Check that the temp maps for all the test methods are consistent with the bytecodes."

	DolphinCompilerTestMethods allMethodsDo: [:each | self verifyTempsMapOf: each]!

testTempMaps2
	"Check that the temp maps for some known special cases are consistent with the bytecodes."

	self specialTempCases do: [:each | self verifyTempsMapOf: each]!

testTempPairing
	| prefix method pairs pair |
	prefix := '
	| t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 | 
	t0 := 0. t1 := 1. t2 := 2. t3 := 3. t4 := 4. t5 := 5. t6 := 6. t7 := 7.
	t8 := 8. t9 := 9. t10 := 10. t11 := 11. t12 := 12. t13 := 13. t14 := 14. t15 := 15. t16 := 16. '.

	"short push + short push"
	method := (self compileExpression: prefix , ' t6 - t7') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs size equals: 1.
	pair := pairs first.
	self assert: pair last equals: (6 << 4) + 7.
	self assert: (method value: nil withArguments: #()) equals: 6 - 7.

	"short push + long push"
	method := (self compileExpression: prefix , ' t7 - t8') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs size equals: 1.
	pair := pairs first.
	self assert: pair last equals: (7 << 4) + 8.
	self assert: (method value: nil withArguments: #()) equals: 7 - 8.

	"long push + short push"
	method := (self compileExpression: prefix , ' t8 - t7') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs size equals: 1.
	pair := pairs first.
	self assert: pair last equals: (8 << 4) + 7.
	self assert: (method value: nil withArguments: #()) equals: 8 - 7.

	"long push + long push"
	method := (self compileExpression: prefix , ' t8 - t10') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs size equals: 1.
	pair := pairs first.
	self assert: pair last equals: (8 << 4) + 10.
	self assert: (method value: nil withArguments: #()) equals: 8 - 10.

	"short + long (out of range)"
	method := (self compileExpression: prefix , ' t7 - t16') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) equals: 7 - 16.

	"long + long (out of range)"
	method := (self compileExpression: prefix , ' t8 - t16') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) equals: 8 - 16.

	"long (out of range) + short"
	method := (self compileExpression: prefix , ' t16 - t7') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) equals: 16 - 7.

	"long (out of range) + long"
	method := (self compileExpression: prefix , ' t16 - t8') method.
	pairs := method byteCodeSegments select: [:each | each first = PushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) equals: 16 - 8!

testTextMapOfEmptyBlock
	| block method debugMethod |
	block := Compiler evaluate: '| x | x := []. x'.
	self assert: block identicalTo: VM emptyBlock.
	method := block method.
	self assert: method byteCodes
		equals: (ByteArray
				with: ShortPushConst + 0
				with: ReturnFromMessage
				with: ShortPushNil
				with: ReturnFromBlock).
	debugMethod := block method asDebugMethod.
	self assert: debugMethod byteCodes
		equals: (ByteArray
				with: ShortPushConst + 0
				with: Break
				with: ReturnFromMessage) , (ByteArray
							with: ShortPushNil
							with: Break
							with: ReturnFromBlock).
	self assert: debugMethod textMap size equals: method textMap size.
	2 to: 4
		do: 
			[:ip |
			| debugIp |
			debugIp := CompiledCode findIp: ip inTextMap: method textMap.
			self assert: (debugMethod byteCodes at: (debugMethod textMap at: debugIp) key)
				equals: (method byteCodes at: ip)]!

testTextMapsExhaustive
	"Check that the release and debug text maps match for every method in the system .... with a
	couple of exceptions... ahem"

	<knownSlowTest>
	"Take 20+ seconds to run, which add another 30% to the test runtime"
	<skipIf: #isCiBuild>
	self knownTextMapIssues not methodsDo: [:each | self verifyTextMapsOf: each]!

testTextMapsOfCleanBlocks
	#('[:a|a > 5 ifTrue: [''Many''] ifFalse: [a printString]]' '[1]' '[]')
		do: [:each | self verifyTextMapsOf: (self compileExpression: each) method]!

testTimesRepeat
	"This is erroneous, but compiler does not detect that, just looks for literal zero arg block, which is OK I think"

	| result method src warnings |
	result := self compileExpression: '5 timesRepeat: []'.
	method := result method.
	self assert: method literals last equals: #timesRepeat:.
	self denyIsNil: method.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) equals: 5.
	self
		shouldnt: [result := self compileExpression: '| a | a := 0. 10 + (5 timesRepeat: [a := a + 1]). a']
		raise: self compilationWarningClass.
	method := result method.
	self denyIsNil: method.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) equals: 5.

	"Test case which cannot be inlined"
	src := '| aBlock i | i := 0. aBlock := [i := i + 1]. 5 timesRepeat: aBlock. i.'.
	warnings := OrderedCollection new.
	[result := self compileExpression: src] on: self compilationWarningClass
		do: 
			[:ex |
			warnings add: ex.
			ex resume].
	self
		assert: (warnings anySatisfy: 
					[:each |
					each errorCode = CWarnExpectNiladicBlockArg
						and: [(src copyFrom: each range start to: each range stop) = 'timesRepeat:']]).
	method := result method.
	self denyIsNil: method.
	self assert: method needsContext.
	self assert: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) equals: 5.

	"Test 0 iterations, which compiler can remove (should come down to just a Return Zero, or at least return literal constant zero"
	self shouldnt: [result := self compileExpression: '0 timesRepeat: [Sound bell]']
		raise: self compilationWarningClass.
	method := result method.
	self denyIsNil: method.
	self assert: method isPacked.
	self assert: method byteCodes
		equals: (ByteArray
				with: Nop
				with: ShortPushZero
				with: ReturnFromMessage).
	self assert: (method value: nil withArguments: #()) equals: 0.

	"Test 0 iterations, which compiler can remove (should come down to just a Return Zero, or at least return literal constant zero"
	self shouldnt: [result := self compileExpression: '-1 timesRepeat: [Sound bell]']
		raise: self compilationWarningClass.
	method := result method.
	self denyIsNil: method.
	self assert: method isPacked.
	self assert: (method value: nil withArguments: #()) equals: -1!

testTimesRepeatResult
	#(0 1 2 127 16383 32767 32768) do: 
			[:each |
			self
				assert: ((self compileExpression: ('<1p> timesRepeat: []' expandMacrosWith: each)) method value: nil
						withArguments: #())
				equals: each.
			self
				assert: ((self
						compileExpression: ('| i | i := 0. <1p> timesRepeat: [i := i + 1]. i' expandMacrosWith: each))
							method value: nil withArguments: #())
				equals: each]!

testToByDo
	| result method src |
	#(0 1 2 3) do: 
			[:i |
			result := self
						compileExpression: ('| a | a := OrderedCollection new. <1d> to: 2 by: 1 do: [:i | a add: i]. a'
								expandMacrosWith: i).
			method := result method.
			self assert: method literals last equals: #to:by:do:.
			self denyIsNil: method.
			self deny: method needsContext.
			self assert: (method value: nil withArguments: #()) equals: (i to: 2) asOrderedCollection.
			result := self
						compileExpression: ('| a | a := OrderedCollection new. <1d> to: 1 by: -1 do: [:i | a add: i]. a'
								expandMacrosWith: i).
			method := result method.
			self denyIsNil: method.
			self deny: method needsContext.
			self assert: (method value: nil withArguments: #()) equals: (i to: 1 by: -1) asOrderedCollection].
	src := '| aBlock i | i := 0. aBlock := [:each | i := i + each]. 1 to: 5 by: 2 do: aBlock. i'.
	self
		should: [result := self compileExpression: src]
		raise: self compilationWarningClass
		matching: 
			[:ex |
			ex errorCode = CWarnExpectMonadicBlockArg
				and: [(src copyFrom: ex range start to: ex range stop) = 'aBlock']]!

testToByDoWithFloatSteps
	{ 1 to: 2 by: 0.5. 1 to: 0 by: -0.5 } do: 
			[:each |
			| result method text |
			text := String writeStream.
			text
				nextPutAll: '| a | a := OrderedCollection new. ';
				print: each start;
				nextPutAll: ' to: ';
				print: each stop;
				nextPutAll: ' by: ';
				print: each step;
				nextPutAll: ' do: [:i | a add: i]. a'.
			result := self compileExpression: text contents.
			method := result method.
			self assert: (method value: nil withArguments: #()) equals: each asOrderedCollection]!

testWhileFalse
	"Test #whileFalse."

	"Test for empty condition block removed as the compiler now treats this as an error."

	| result method |
	"Test a simple counting loop"
	result := self compileExpression: '| i | i := 0. [i := i + 1. i > 10] whileFalse. i'.
	method := result method.
	self assert: method literals asSortedArray equals: #(#+ #> #whileFalse).
	self denyIsNil: method.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) equals: 11.

	"Test case which cannot be inlined"
	result := 
			[self compileExpression: '| i block | i := 0. block := [i := i + 1. i > 10]. block whileFalse. i']
					on: self compilationWarningClass
					do: 
						[:ex |
						self assert: ex errorCode equals: CWarnExpectNiladicBlockReceiver.
						ex resume].
	method := result method.
	self denyIsNil: method.
	self assert: method needsContext.
	self assert: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) equals: 11!

testWhileTrue
	"Test for empty condition block removed as the compiler now treats this as an error."

	| result method |
	result := self compileExpression: '| i | i := 0. [i := i + 1. i <= 10] whileTrue. i'.
	method := result method.
	self assert: method literals asSortedArray equals: #(#+ #<= #whileTrue).
	self denyIsNil: method.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) equals: 11.

	"Test case which cannot be inlined"
	result := 
			[self compileExpression: '| i block | i := 0. block := [i := i + 1. i <= 10]. block whileTrue. i']
					on: self compilationWarningClass
					do: 
						[:ex |
						self assert: ex errorCode equals: CWarnExpectNiladicBlockReceiver.
						ex resume].
	method := result method.
	self denyIsNil: method.
	self assert: method needsContext.
	self assert: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) equals: 11!

testWriteAccessor
	| class inst |
	class := CompilerTestClasses current testClass.
	inst := class new.
	class instanceVariableNames do: 
			[:each |
			| accessor selector |
			selector := (each , ':') asSymbol.
			accessor := class compiledMethodAt: selector.
			self assert: accessor extraIndex equals: 7.
			inst perform: selector with: each.
			self assert: (inst perform: each asSymbol) equals: each]!

testYourself
	"Test that yourself is optimised away, although retained in literal frame"

	| result method disasm expected literals |
	result := self compileExpression: '^(Array new: 1) at: 1 put: 1234; yourself'.
	method := result method.
	literals := method literals.
	self assert: literals first equals: Array binding.
	self assert: literals asSet equals: { Array binding. #at:put:. #new:. #yourself } asSet.
	disasm := method disassembly.
	expected := 'Normal, 0 args, 4 literals

	1	Push Static[0]: #Array -> Array
	2	Push 1
	3	Special Send #new:
	4	Dup
	5	Push 1
	6	Push 1234
	9	Special Send #at:put:
	10	Pop
	11	Return'.
	self assert: disasm equals: expected!

verifyTempsMapOf: aCompiledMethod
	| dispatcher info ipRange tempsMap emptyBlock method parseTree textMap tempsAtIp refdTemps |
	self skip: 'Work in progress'.
	info := aCompiledMethod getDebugInfo.
	"Use the recompiled method as we want to check the current compiler, not what was compiled into the image"
	method := info method.
	"First check that all ip's are covered by the method scope"
	ipRange := 1 to: method byteCodes size.
	tempsMap := info tempsMap.
	"This is not necessarily true, as clean blocks are now moved after the rest of the bytecodes of the method."
	"self assert: tempsMap first key equals: ipRange."
	tempsAtIp := Array new: ipRange size.
	"All temps map entries should be for ip's that represent some subset of the method's ip's"
	tempsMap do: 
			[:each |
			| range temps |
			range := each key.
			temps := each value.
			range start to: range stop do: [:i | tempsAtIp at: i put: temps]].
	refdTemps := Array new: ipRange size.
	dispatcher := method byteCodeDispatcher.
	[dispatcher atEnd] whileFalse: 
			[| ip |
			ip := dispatcher ip.
			dispatcher nextInstructionDo: 
					[:instr :args |
					TempInstrs at: instr
						ifPresent: 
							[:val |
							| temps actual tempInfo |
							temps := tempsAtIp at: ip.
							self assert: (info tempsAtIp: ip) equals: temps.
							actual := val value: args.
							tempInfo := temps detect: [:ti | ti second == actual key and: [ti last == actual value]]
										ifNone: [self fail: 'No temps map entry found'].
							refdTemps at: ip put: tempInfo]]].
	"Check that each entry in the temps map corresponds to a visible temp"
	parseTree := aCompiledMethod parseTree.
	parseTree analyze.
	textMap := info textMap.
	tempsMap do: 
			[:each |
			| scopeNode scope tempName refs |
			ipRange := each key.
			scopeNode := (ipRange start == 1 and: [ipRange stop == method byteCodes size])
						ifTrue: [parseTree]
						ifFalse: 
							[| range1 range2 |
							range1 := (textMap at: (CompiledCode findIP: ipRange start inTextMap: textMap)) value.
							range2 := (textMap at: (CompiledCode findIP: ipRange stop inTextMap: textMap)) value.
							parseTree bestNodeFor: ((range1 start min: range2 start) to: (range1 stop max: range2 stop))].
			scope := scopeNode scope.
			self assert: (scope node == scopeNode or: [scope node == scopeNode outer]).
			refs := refdTemps copyFrom: each key start to: each key stop.
			each value do: 
					[:tempDetails |
					| depth declScope local |
					tempName := tempDetails at: 1.
					depth := tempDetails second.
					declScope := scope.
					"Walk out to the scope indicated by the outer depth in the temp map."
					
					[[declScope isInlined] whileTrue: [declScope := declScope outer].
					depth > 0] whileTrue: 
								[declScope := declScope outer.
								depth := depth - 1].
					local := scope resolveIdentifier: tempName.
					#todo.	"Enable when in-image analyzer does redeclaration of copied temps for copying blocks"
					"self assert: local scope identicalTo: declScope."
					local isConstant
						ifTrue: [self assert: tempDetails second equals: 0	"Arguments can be unreferenced"]
						ifFalse: 
							[self
								assert: (tempDetails second > 0 or: 
											[(refs includes: tempDetails) or: 
													["Temps may be visible but unreferenced in optimized block scopes, e.g. an ifTrue: block"
													scope class == StOptimizedBlockScope]])]]].
	"Check that there is a temps map entry for the initalIP of each clean block in the literal frame"
	emptyBlock := VM emptyBlock.
	method literalsDo: 
			[:each |
			((each isKindOf: BlockClosure) and: [each ~~ emptyBlock])
				ifTrue: 
					[each method == method
						ifTrue: 
							[| initialIP |
							initialIP := each initialIP.
							self assert: (tempsMap anySatisfy: [:temps | temps key start == initialIP])]
						ifFalse: 
							[Transcript
								nextPutAll: 'Ignoring literal block of ';
								print: method;
								nextPutAll: ' defined in ';
								print: each method;
								nextPutAll: ': ';
								print: each;
								cr]]]!

verifyTextMapsOf: aCompiledMethod
	| debugTextMap debugMethod textMap dispatcher initialIp debugInitialIp debugBytes debugDispatcher |
	debugMethod := aCompiledMethod asDebugMethod.
	"If fails then the method failed to compile"
	self denyIsNil: debugMethod.
	textMap := aCompiledMethod debugInfo textMap.
	debugTextMap := debugMethod textMap.
	"The optimized and debug text maps should contain exactly the same number of entries"
	self assert: debugTextMap size equals: textMap size.
	"The text range for each entry should be the same"
	textMap with: debugTextMap do: [:a :b | self assert: a value equals: b value].
	debugBytes := debugMethod byteCodes.
	debugTextMap do: 
			[:assoc |
			| ip |
			ip := assoc key.
			ip == 0 ifFalse: [self deny: (debugBytes at: ip) equals: 0]].
	"Verify that all the blocks' first instructions can be mapped"
	debugDispatcher := debugMethod byteCodeDispatcher.
	dispatcher := aCompiledMethod byteCodeDispatcher.
	dispatcher instructionsDo: 
			[:op :args |
			op == #blockCopy:stack:env:copy:offset1:offset2:
				ifTrue: 
					[| i |
					initialIp := dispatcher ip.
					i := BlockFrame findInitialIP: initialIp inTextMap: textMap.
					self assert: (textMap at: i) key equals: initialIp.
					debugInitialIp := (debugTextMap at: i) key.
					self assert: (debugBytes at: (debugDispatcher prevIP: debugInitialIp)) equals: OpcodePool.BlockCopy]]! !
!Kernel.Tests.CompilerTest categoriesForMethods!
assertBlocksOptimized:!helpers!private! !
checkCompileError:range:code:line:source:!helpers!private! !
compilationErrorClass!constants!private! !
compilationWarningClass!constants!private! !
compileExpression:!helpers!private! !
compileExpression:in:!helpers!private! !
compileMethod:in:!helpers!private! !
debugCompileResultFor:!helpers!private! !
defaultCompileFlags!helpers!private! !
evalTestMethod:!helpers!private! !
evalTestMethod:withArgs:!helpers!private! !
evaluateExpression:!helpers!private! !
getTestMethod:!private! !
knownTempsMapIssues!helpers!private! !
knownTextMapIssues!helpers!private! !
messageFromError:!helpers!private! !
scan:class:!helpers!private! !
scanNonNumericEnd:class:!helpers!private! !
scanScaledDecimal:!helpers!private! !
scanSmallIntegerNonNumericEnd:!helpers!private! !
setInteractiveCompile!helpers!private! !
setUp!helpers!private! !
shortPushOne!helpers!private! !
specialTempCases!constants!private! !
test1054!public!unit tests! !
testBlockTempsMap!public!unit tests! !
testBlockWithAllTempTypes!public!unit tests! !
testBraceArrays!public!unit tests! !
testByteArraysInLiteralArrays!public!unit tests! !
testCharacterScanning!public!unit tests! !
testCleanBlockInCopyingBlock!public!unit tests! !
testCompileTimeExpressions!public!unit tests! !
testConstExpressionReferences!public!unit tests! !
testCopyingBlockNestedInCleanBlock!public!unit tests! !
testCopyingBlocks1!public!unit tests! !
testCopyingBlocks2!public!unit tests! !
testDecrementPushTempOptimisation!public!unit tests! !
testDecrementTempOptimisation!public!unit tests! !
testEmpty!public!unit tests! !
testEmptyIfInLoop!public!unit tests! !
testExtCallStructLiterals!public!unit tests! !
testFarReturnFromBlock!public!unit tests! !
testFloatScanning!public!unit tests! !
testIdentical!public!unit tests! !
testIfNil!public!unit tests! !
testIfNilifNotNil!public!unit tests! !
testIfNilifNotNilNoArg!public!unit tests! !
testIfNilifNotNilNoArgUnused!public!unit tests! !
testIfNilifNotNilUnused!public!unit tests! !
testIfNilUnused!public!unit tests! !
testIfNotNil!public!unit tests! !
testIfNotNilifNil!public!unit tests! !
testIfNotNilifNilNoArg!public!unit tests! !
testIfNotNilifNilNoArgUnused!public!unit tests! !
testIfNotNilifNilUnused!public!unit tests! !
testIfNotNilNoArg!public!unit tests! !
testIfNotNilNoArgUnused!public!unit tests! !
testIfNotNilUnused!public! !
testImmutableLiterals!public!unit tests! !
testIncrementDecrementOptimisation!public!unit tests!unit tests-text maps! !
testIncrementPushTempOptimisation!public!unit tests!unit tests-text maps! !
testIncrementTempOptimisation!public!unit tests!unit tests-text maps! !
testIntegerScanning!public!unit tests! !
testIntegerScanningBoundaries!public!unit tests! !
testKeywordAnnotations!public!unit tests! !
testLiteralArray!public!unit tests! !
testLiteralStringEncoding!public!unit tests! !
testMapIpWithVoidedEntry!public!unit tests!unit tests-text maps! !
testMutableAnnotation!public!unit tests! !
testNestedCopyingBlocks!public!unit tests! !
testNestedWhileTrueAtStartOfCleanBlock!public!unit tests! !
testNotIdentical!public!unit tests! !
testOptimizedLoopReadBeforeWritten!public!unit tests! !
testPopReturn!public!unit tests!unit tests-text maps! !
testQualifiedReference!public!unit tests! !
testRadixInteger!public!unit tests! !
testReturnFromOptimizedBlock!public!unit tests! !
testReturnIfNotNil!public!unit tests!unit tests-text maps! !
testReturnImmediate!exceptions!public!unit tests! !
testReturnPseudoVar!public!unit tests! !
testScanningScaledDecimals!public!unit tests! !
testScope!public!unit tests! !
testSharedOuterTemps!public!unit tests! !
testSpecialLiteralsAsUnarySelectors!public! !
testStringLiteralFolding!public!unit tests! !
testStringLiteralWithEmbeddedNulls!public!unit tests! !
testSymbolScanning!public!unit tests! !
testTempMapOuterDepthExhaustive!public!unit tests-long running! !
testTempMaps!public!unit tests! !
testTempMaps2!public!unit tests! !
testTempPairing!public!unit tests! !
testTextMapOfEmptyBlock!public! !
testTextMapsExhaustive!public!unit tests-long running!unit tests-text maps! !
testTextMapsOfCleanBlocks!public!unit tests!unit tests-text maps! !
testTimesRepeat!public!unit tests! !
testTimesRepeatResult!public!unit tests! !
testToByDo!public!unit tests! !
testToByDoWithFloatSteps!public!unit tests! !
testWhileFalse!public!unit tests! !
testWhileTrue!public!unit tests! !
testWriteAccessor!public!unit tests! !
testYourself!public!unit tests! !
verifyTempsMapOf:!helpers!private! !
verifyTextMapsOf:!helpers!private! !
!

!Kernel.Tests.CompilerTest class methodsFor!

buildSuiteFromSelectors
	^super buildSuiteFromSelectors!

initialize
	| accessOuterTemp accessContextTemp accessStackTemp accessOuter1Temp |
	TempInstrs := IdentityDictionary new.
	accessStackTemp := [:args | 0 -> (args last + 1)].
	accessContextTemp := [:args | 1 -> (args last + 1)].
	accessOuter1Temp := [:args | 2 -> (args last + 1)].
	accessOuterTemp := [:args | 
		"Key: Top 3 bits are outer path distance -> Value: bottom 5 bits are temp index in outer"
		(args last bitShift: -5) + 1 -> ((args last bitAnd: 16r1F) + 1)].
	TempInstrs
		at: #decPushTemp:temp: put: accessStackTemp;
		at: #decTemp:temp: put: accessStackTemp;
		at: #incPushTemp:temp: put: accessStackTemp;
		at: #incTemp:temp: put: accessStackTemp;
		at: #popPushTemp: put: accessStackTemp;
		at: #pushSelfAndTemp: put: accessStackTemp;
		at: #popTemp: put: accessStackTemp;
		at: #pushTemp: put: accessStackTemp;
		at: #shortPopPushTemp: put: accessStackTemp;
		at: #shortPopTemp: put: accessStackTemp;
		at: #shortPushTemp: put: accessStackTemp;
		at: #pushTempPair: put: [:args | 0 -> ((args last bitAnd: 16rF) + 1)];
		at: #sendTempZeroArgs: put: [:args | 0 -> ((args last bitShift: -5) + 1)];
		at: #shortPushTemp: put: accessStackTemp;
		at: #shortPushSelfAndTemp: put: accessStackTemp;
		at: #shortStoreTemp: put: accessStackTemp;
		at: #popContextTemp: put: accessContextTemp;
		at: #shortPopOuterTemp: put: accessContextTemp;
		at: #pushContextTemp: put: accessContextTemp;
		at: #popOuterTemp: put: accessOuterTemp;
		at: #pushOuterTemp: put: accessOuterTemp;
		at: #storeOuterTemp: put: accessOuterTemp;
		at: #shortPopOuterTemp: put: accessOuter1Temp;
		at: #shortPushOuterTemp: put: accessOuter1Temp;
		yourself!

resources
	^{CompilerTestClasses}! !
!Kernel.Tests.CompilerTest class categoriesForMethods!
buildSuiteFromSelectors!Building Suites!public! !
initialize!class initialization!public! !
resources!Accessing!public! !
!

