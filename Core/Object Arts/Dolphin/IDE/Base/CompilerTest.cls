"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #CompilerTest
	instanceVariableNames: 'defaultCompileFlags'
	classVariableNames: ''
	poolDictionaries: 'CompilerFlags OpcodePool SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
CompilerTest guid: (GUID fromString: '{5AFF22BD-5D99-4B24-9B1D-C8D1EDE77213}')!
CompilerTest comment: ''!
!CompilerTest categoriesForClass!Unclassified! !
!CompilerTest methodsFor!

checkCompileError: ex range: anInterval code: anInteger message: msgFormat line: lineInteger source: aString 
	^ex errorCode = anInteger and: [ex range = anInterval]!

compilationErrorClass
	^Compiler errorClass!

compilationWarningClass
	^CompilerWarningNotification!

compileExpression: aString 
	^self compileExpression: aString in: UndefinedObject!

compileExpression: aString in: class 
	| result |
	self shouldnt: 
			[result := Compiler 
						compileExpression: aString
						in: class
						flags: defaultCompileFlags]
		raise: self compilationErrorClass.
	^result!

compileMethod: aString in: aClass 
	^Compiler 
		compile: aString
		in: aClass
		flags: defaultCompileFlags!

defaultCompileFlags
	^defaultCompileFlags!

evalTestMethod: aCompiledMethod 
	^self evalTestMethod: aCompiledMethod withArgs: #()!

evalTestMethod: aCompiledMethod withArgs: anArray 
	^aCompiledMethod value: DolphinCompilerTestMethods new withArguments: anArray!

evaluateExpression: aString 
	^Compiler evaluate: aString!

findIP: anInteger inTextMap: aTextMap 
    	"Private - Answer the index of the source map entry corresponding to the
    	specified <integer> ip. The key of each text map entry identifies the first IP of the code generated for the range
	of source which is held as the <interval> value."
    
    	| i size |
    	i := 1.
    	size := aTextMap size.
	[i < size and: [anInteger > (aTextMap at: i) key]] whileTrue: [i := i + 1].
	^i!

getDebugInfoFor: aCompiledMethod debug: debugBoolean 
	| methodClass compiler flags optimizeBoolean |
	optimizeBoolean := true.
	methodClass := aCompiledMethod methodClass.
	compiler := aCompiledMethod compilerClass.
	flags := methodClass defaultCompilationFlags | (compiler debugInfoFlags: debugBoolean).
	flags := flags mask: NoOptimize set: optimizeBoolean not.
	^compiler 
		compile: aCompiledMethod getSource
		in: methodClass
		flags: flags!

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
		isImmutable: true.	"The method has not actually changed, so it is inappropriate to issue a #methodUpdated: event"
	^method!

knownTextMapIssues
	"There are a couple of methods in the system for which the release and debug text maps do
	not match. This is because of the compiler is able to optimise out redundant stores into
	temps in a release method, but obviously this would be undesirable in a debug method (where
	you expect to see the correct values in temps). However the effort to correct this issue (or
	alternatively the cost of removing the redundant store operation on the efficiency of the
	generated code) is not considered worthwhile for now, so we will live with two failures.
	These have been examined, and there would be no debugging issue anyway.."

	| bad |
	bad := OrderedCollection new.
	"These methods are all have optimisation where an unconditional jump is replaced with a
	return, and the text map for the optimised method then has an extra entry for that return
	statement as these get breaks inserted before them. The compiler needs to be fixed to mark
	these returns as optimised returns, and so it's never possible to break on them, or we need
	to put a text map entry in for the unconditional jump (wouldn't do any harm)."
	bad add: AddPoolVariableChange >> #changeObject.
	bad add: RemovePoolVariableChange >> #changeObject.
	Smalltalk at: #ItcSystemManager ifPresent: [:class | bad add: class class >> #imageFilename].
	Smalltalk at: #WikiDocImageSelectorServlet ifPresent: [:class | bad add: class >> #searchImages:].
	^BrowserEnvironment new forMethods: bad asArray!

messageFromError: ex 
	^self hasFullClosures ifTrue: [ex errorMessage] ifFalse: [ex text]!

pushTempPair
	^233!

scan: aString class: aNumberClass 
	| expected result |
	expected := Number readFrom: aString readStream.
	result := self evaluateExpression: aString.
	self assert: result class == aNumberClass.
	self assert: result = expected!

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
			ex receiver class == aNumberClass 
				and: [ex receiver = expected and: [extra beginsWith: ex selector]]]!

scanScaledDecimal: each 
	| result1 expected |
	expected := Number readFrom: each readStream.
	result1 := self evaluateExpression: each.
	self assert: result1 class == ScaledDecimal.
	self assert: result1 scale = expected scale.
	^self assert: result1 = expected!

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

test1054
	| method |
	method := (self compileExpression: '1') method.
	self 
		assert: method byteCodes = (ByteArray with: self shortPushOne with: ReturnFromMessage).
	method := (self compileMethod: 'a ^1' in: UndefinedObject) method.
	self 
		assert: method byteCodes = (ByteArray with: self shortPushOne with: ReturnFromMessage)!

testBlockTempsMap
	"#1461"
	| result map max |
	result := Compiler 
				debugInfoForExpression: '[#(1 2 3) do: [:each | each = 2 ifTrue: [Error signal]]] on: Error do: [:ex | self halt]'
				in: Object
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
	self assert: method envTempCount = 2.
	self assert: method stackTempCount = 2.
	block1 := method value: DolphinCompilerTestMethods new withArguments: #().
	self assert: (block1 isKindOf: BlockClosure).
	"Should only be one copied values, 0 temps and args"
	self assert: block1 argumentCount = 2.
	self assert: block1 stackTempCount = 1.
	self assert: block1 localCount = 4.
	self assert: block1 envTempCount = 1.
	self assert: block1 size = 1.
	self assert: (block1 outer at: 1) = 1.
	self assert: (block1 outer at: 2) isNil.
	value1 := block1 value: 3 value: 5.
	self assert: value1 = 160.
	self assert: (block1 outer at: 1) = 2.
	self assert: ((block1 outer at: 2) isKindOf: BlockClosure).
	self assert: (block1 outer at: 2) value == #abc.
	self assert: ((block1 outer at: 2) outer isKindOf: self methodContextClass).
	self assert: (block1 outer at: 2) outer size = 1.
	self assert: ((block1 outer at: 2) outer at: 1) == #abc.
	"Run it again. Because of the shared temps we should get a different result"
	value2 := block1 value: 3 value: 5.
	self assert: value2 = (value1 * 20)!

testByteArraysInLiteralArrays
	"#980"

	| compiled text |
	text := '#(#[])'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	self assert: (compiled method value: nil) = (Array with: #[]).
	text := '#(1 #[0])'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	self assert: (compiled method value: nil) = (Array with: 1 with: #[0]).
	text := '#(1 #[0 255] 2)'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	self 
		assert: (compiled method value: nil) = (Array 
						with: 1
						with: #[0 255]
						with: 2)!

testCompileTimeExpressions
	| result |
	self shouldnt: [result := self evaluateExpression: '##()'] raise: self compilationErrorClass.
	self assert: result = UndefinedObject.
	#('1' '1+2') do: 
			[:each | 
			| expected |
			expected := self evaluateExpression: each.
			self shouldnt: [result := self evaluateExpression: '##(' , each , ')']
				raise: self compilationErrorClass.
			self assert: result = expected]!

testConstExpressionReferences
	"Test that references in a compile-time evaluated expression are retained in the literal frame 
	of the method (#1011)."

	| method |
	method := (self compileExpression: '##(#x , #y)') method.
	self assert: (method value: nil withArguments: #()) = 'xy'.
	self assert: (method refersToLiteral: #x).
	self assert: (method refersToLiteral: #y).
	self deny: (method refersToLiteral: #z).
!

testCopyingBlocks1
	| method |
	method := self getTestMethod: #testCopyingBlocks1.
	self assert: method stackTempCount = 1.
	self deny: method needsContext.
	self assert: (method value: DolphinCompilerTestMethods new withArguments: #()) = Array new!

testCopyingBlocks2
	| method |
	method := self getTestMethod: #testCopyingBlocks2.
	self deny: method needsContext.
	self assert: method stackTempCount = 1.
	self assert: (method value: DolphinCompilerTestMethods new withArguments: #()) = 'abc'!

testDecrementPushTempOptimisation
	| disasm expr |
	expr := (self compileExpression: '| j | 5 to: 1  by: -1 do: [:i | j := i]. j') method.
	disasm := expr disassembly.
	self assert: disasm 
				= 'Normal, 0 args, 2 stack temps, 0 literals

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
	19	Return '.
	self assert: (expr value: nil) = 1.
	expr := (self 
				compileExpression: '| t1 t2 t3 t4 t5 t6 t7 j | t1 := t2 := t3 := t4 := t5 := t6 := t7 := 1. 5 to: 1 by: -1 do: [:i | j := i]. j') 
					method.
	disasm := expr disassembly.
	self assert: disasm 
				= 'Normal, 0 args, 9 stack temps, 0 literals

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
	34	Return '.
	self assert: (expr value: nil) = 1.
	"Overflow"
	expr := (self compileExpression: '| i | i := SmallInteger minimum. i class. i := i - 1. i*1') 
				method.
	self assert: (expr value: nil) = (SmallInteger minimum - 1).
	"Non-small integer decremented"
	expr := (self compileExpression: '| i | i := 200 factorial. i class. i := i - 1. i*1') method.
	self assert: (expr value: nil) = (200 factorial - 1).
	"Non-integer decremented"
	expr := (self compileExpression: '| i | i := -1.0. i class. i := i - 1. i*1') method.
	self assert: (expr value: nil) = (-1.0 - 1).
	"Non-number incremented"
	expr := (self compileExpression: '| i | i := ''a''. i class. i := i - 1. i*1') method.
	self should: [expr value: nil] raise: MessageNotUnderstood!

testDecrementTempOptimisation
	| disasm expr expected |
	expr := (self compileExpression: '| i | i := 5. [i < 1] whileFalse: [i := i - 1]. i') method.
	disasm := expr disassembly.
	self assert: disasm 
				= 'Normal, 0 args, 1 stack temps, 0 literals

	1	Push 5
	3	Pop Temp[0]
	4	Push Temp[0]
	5	Push 1
	6	Special Send #<
	7	Jump If True +5 to 14
	9	Decrement Temp[0]
	12	Jump -10 to 4
	14	Push Temp[0]
	15	Return '.
	self assert: (expr value: nil) = 0.
	expr := (self 
				compileExpression: '| t1 t2 t3 t4 t5 t6 t7 t8 i | t1 := t2 := t3 := t4 := t5 := t6 := t7 := t8 := 1. i := 5. [i < 1] whileFalse: [i := i - 1]. i') 
					method.
	disasm := expr disassembly.
	expected := 'Normal, 0 args, 9 stack temps, 0 literals

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
	21	Special Send #<
	22	Jump If True +5 to 29
	24	Decrement Temp[8]
	27	Jump -11 to 18
	29	Push Temp[8]
	31	Return '.
	self assert: disasm = expected.
	"DiffBrowser  compare: disasm with: expected."
	self assert: (expr value: nil) = 0.
	"Overflow"
	expr := (self compileExpression: '| i | i := SmallInteger minimum. i class. i := i - 1. 5 class. i') 
				method.
	self assert: (expr value: nil) = (SmallInteger minimum - 1).
	"Non-small integer decremented"
	expr := (self compileExpression: '| i | i := 200 factorial. i class. i := i - 1. 5 class. i') 
				method.
	self assert: (expr value: nil) = (200 factorial - 1).
	"Non-integer decremented"
	expr := (self compileExpression: '| i | i := -1.0. i class. i := i - 1. 5 class. i') method.
	self assert: (expr value: nil) = (-1.0 - 1).
	"Non-number incremented"
	expr := (self compileExpression: '| i | i := ''a''. i class. i := i - 1. 5 class. i') method.
	self should: [expr value: nil] raise: MessageNotUnderstood!

testEmpty
	| method |
	method := (Compiler compile: 'nothing' in: UndefinedObject flags: 0) method.
	self assert: method byteCodes = (ByteArray with: ReturnSelf)!

testEmptyIfInLoop
	"See #401. Due to an optimization bug, this gives an error in D5"

	self 
		assert: ((self compileExpression: '1 to: 10 do: [:each | each = 1 ifTrue: []]') method 
				value: nil
				withArguments: #()) = 1!

testFarReturnFromBlock
	| method block |
	method := (self compileExpression: '[^1]') method.
	self assert: method needsContext.
	block := method value: nil withArguments: #().
	self assert: block outer notNil.
	"self assert: block receiver isNil"
	self 
		should: [block value]
		raise: Error
		matching: [:ex | ex messageText beginsWith: 'Cannot return'].
	method := (self compileExpression: '[^self]' in: self class) method.
	self assert: method needsContext.
	block := method value: self withArguments: #().
	self assert: block outer notNil.
	self assert: block receiver == self.
	self 
		should: [block value]
		raise: Error
		matching: [:ex | ex messageText beginsWith: 'Cannot return'].
	method := (self compileExpression: '[[^true] whileTrue]') method.
	self assert: method needsContext.
	block := method value: nil withArguments: #().
	self deny: block outer isNil.
	self 
		should: [block value]
		raise: Error
		matching: [:ex | ex messageText beginsWith: 'Cannot return']!

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
					self isD6OrLater 
						ifTrue: 
							[| start |
							start := each first indexOfSubCollection: each second.
							ex errorCode = CErrUndeclared and: [ex range = (start to: start + each second size - 1)]]
						ifFalse: [(self messageFromError: ex) = ('undeclared ' , each second printString)]]].
	"#2219"
	self assert: 10.0 ** -316 = (self evaluateExpression: '1.0e-316')
	"308 to: -316
		by: -1
		do: [:each | self assert: (self evaluateExpression: ('1.0e<d>' expandMacrosWith: each)) - (10.0 ** each)]"!

testIfNil
	| compiled expected |
	compiled := self compileExpression: '1 ifNil: [2]'.
	self deny: (compiled method literals includes: 'ifNil:' asSymbol).
	expected := 'Normal, 0 args, 0 literals

	1	Push 1
	2	Dup
	3	Jump If Not Nil +2 to 7
	5	Pop
	6	Push 2
	7	Return '.
	self assert: compiled method disassembly = expected!

testIfNilifNotNil
	| compiled expected |
	compiled := self compileExpression: '1 ifNil: [ | x | x := 2. 1+x] ifNotNil: [:x | 1+x]'.
	self assert: (compiled method value: nil withArguments: #()) = 2.
	expected := 'Normal, 0 args, 2 stack temps, 0 literals

	1	Push 1
	2	Dup
	3	Jump If Not Nil +7 to 12
	5	Pop
	6	Push 2
	7	Pop Temp[0]
	8	Push 1
	9	Push Temp[0]
	10	Special Send #+
	11	Return 
	12	Pop Temp[1]
	13	Push 1
	14	Push Temp[1]
	15	Special Send #+
	16	Return '.
	self assert: compiled method disassembly = expected

	"
DiffBrowser compare: compiled method disassembly with: expecteda DiffBrowser
"!

testIfNilifNotNilNoArg
	| compiled expected |
	compiled := self compileExpression: '1 ifNil: [3] ifNotNil: [2]'.
	self assert: (compiled method value: nil withArguments: #()) = 2.
	expected := 'Normal, 0 args, 0 literals

	1	Push 1
	2	Jump If Not Nil +3 to 7
	4	Push 3
	6	Return 
	7	Push 2
	8	Return '.
	self assert: compiled method disassembly = expected

	"
DiffBrowser compare: compiled method disassembly with: expected
"!

testIfNotNil
	| compiled expected result |
	compiled := self compileExpression: '1 ifNotNil: [:x | x + 2]'.
	expected := 'Normal, 0 args, 1 stack temps, 0 literals

	1	Push 1
	2	Dup
	3	Jump If Nil +3 to 8
	5	Store Temp[0]
	6	Push 2
	7	Special Send #+
	8	Return '.
	result := compiled method disassembly.
	self assert: result = expected.
	"
DiffBrowser compare: result with: expected
"

	compiled := self compileExpression: '1 ifNotNil: [1+2]'.
	expected := 'Normal, 0 args, 0 literals

	1	Push 1
	2	Dup
	3	Jump If Nil +4 to 9
	5	Pop
	6	Push 1
	7	Push 2
	8	Special Send #+
	9	Return '.
	result := compiled method disassembly.
	self assert: result = expected
	"
DiffBrowser compare: result with: expected
"!

testIfNotNilifNil
	| compiled expected |
	compiled := self compileExpression: '1 ifNotNil: [:x | 2] ifNil: [3]'.
	expected := 'Normal, 0 args, 1 stack temps, 0 literals

	1	Push 1
	2	Dup
	3	Jump If Nil +3 to 8
	5	Pop Temp[0]
	6	Push 2
	7	Return 
	8	Pop
	9	Push 3
	11	Return '.
	self assert: compiled method disassembly = expected!

testIfNotNilifNilNoArg
	| compiled expected |
	compiled := self compileExpression: '1 ifNotNil: [2] ifNil: [3]'.
	expected := 'Normal, 0 args, 0 literals

	1	Push 1
	2	Jump If Nil +2 to 6
	4	Push 2
	5	Return 
	6	Push 3
	8	Return '.
	self assert: compiled method disassembly = expected


	"
DiffBrowser compare: compiled method disassembly with: expected
"!

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
			self assert: (method value: nil withArguments: #()) = 0.
			self 
				assert: method byteCodes = (ByteArray 
								with: self shortPushOne
								with: Decrement
								with: ReturnFromMessage).
			debugMethod := method asDebugMethod.
			self 
				assert: debugMethod byteCodes = (ByteArray 
								with: self shortPushOne
								with: Break
								with: Decrement
								with: Break
								with: ReturnFromMessage).
			map := method debugInfo textMap.
			debugMap := debugMethod debugInfo textMap.
			self assert: map size = 2.
			self assert: debugMap size = map size.
			self assert: (map collect: [:e | e key]) asArray = #(2 3).
			self assert: (debugMap collect: [:e | e key]) asArray = #(3 5)].
	#('1 + 1' '1 - -1') do: 
			[:each | 
			method := (self compileExpression: each) method.
			self assert: (method value: nil withArguments: #()) = 2.
			self 
				assert: method byteCodes = (ByteArray 
								with: self shortPushOne
								with: Increment
								with: ReturnFromMessage).
			debugMethod := method asDebugMethod.
			self 
				assert: debugMethod byteCodes = (ByteArray 
								with: self shortPushOne
								with: Break
								with: Increment
								with: Break
								with: ReturnFromMessage).
			map := method debugInfo textMap.
			debugMap := debugMethod debugInfo textMap.
			self assert: map size = 2.
			self assert: debugMap size = map size.
			self assert: (map collect: [:e | e key]) asArray = #(2 3).
			self assert: (debugMap collect: [:e | e key]) asArray = #(3 5)].
	"Check correct optimisation in debug method, and also debug text mapping syncs up "
	method := self getTestMethod: #testIncrementOptimisationMNU.
	self assert: (method byteCodes at: 5) = Increment.
	self assert: (method byteCodes at: 6) = (ShortPopTemp + 1).
	self should: [self evalTestMethod: method] raise: MessageNotUnderstood.
	"Check debug frame re-mapping for increments that result in actual Send+ (split instruction)"
	map := method debugInfo textMap.
	debugMethod := method asDebugMethod.
	debugMap := debugMethod debugInfo textMap.
	self assert: map size = debugMap size.
	i := self findIP: 5 inTextMap: map.
	self assert: (map at: i) key = 5.
	self assert: (map at: i) value = (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) = Increment.
	i := self findIP: 6 inTextMap: map.
	self assert: (map at: i) key = 6.
	self assert: (map at: i) value = (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) = (ShortPopTemp + 1)!

testIncrementPushTempOptimisation
	| disasm method map debugMethod debugMap i |
	method := self getTestMethod: #testIncrementPushTempOptimisation.
	disasm := method disassembly.
	self assert: disasm 
				= 'Normal, 0 args, 2 stack temps, 0 literals

	1	Push 1
	2	Store Temp[0]
	3	Special Send #class
	4	Pop
	5	Increment & Push Temp[0]
	8	Store Temp[1]
	9	Special Send #class
	10	Pop; Push Temp[1]
	11	Return '.
	self assert: (self evalTestMethod: method) = 2.

	"Need to be careful that optimisations like this (which combine instructions) map correctly to debug methods. In this case the optimised instruction
	is composed of a prefix, followed by the Store instruction. The debug method does not have the optimisation, but the text map for the release version
	must have an entry for both parts of the instruction."
	debugMethod := method asDebugMethod.
	map := method debugInfo textMap.
	self assert: (method byteCodes at: 5) = IncPushTemp.
	self assert: (method byteCodes at: 6) = StoreTemp.
	self assert: (method byteCodes at: 7) = 0.	"temp 0"
	i := self findIP: 5 inTextMap: map.
	self assert: (map at: i) key = 5.
	self 
		assert: (method getSource copyFrom: (map at: i) value start to: (map at: i) value stop) = 'i + 1'.
	"Check debug frame re-mapping for increments that result in actual Send+ (split instruction)"
	debugMap := debugMethod debugInfo textMap.
	self assert: (map at: i) value = (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) = Increment.
	i := self findIP: 6 inTextMap: map.
	self assert: (map at: i) key = 6.
	self assert: (map at: i) value = (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) = (ShortStoreTemp + 0).

	"Longer temp offset"
	method := self getTestMethod: #testIncrementPushTempOptimisationLong.
	self assert: (method byteCodes at: 25) = IncPushTemp.
	self assert: (self evalTestMethod: method) = 5.
	"Overflow"
	method := self getTestMethod: #testIncrementPushTempOptimisationOverflow.
	self assert: (method byteCodes at: 6) = IncPushTemp.
	self assert: (self evalTestMethod: method) = (SmallInteger maximum + 1).
	"Non-small integer incremented"
	method := self getTestMethod: #testIncrementPushTempOptimisationLargeInt.
	self assert: (method byteCodes at: 8) = IncPushTemp.
	self assert: (self evalTestMethod: method) = (200 factorial + 1).
	"Non-integer incremented"
	method := self getTestMethod: #testIncrementPushTempOptimisationFloat.
	self assert: (method byteCodes at: 5) = IncPushTemp.
	self assert: (self evalTestMethod: method) = (1.0 + 1).
	"Non-number incremented"
	method := self getTestMethod: #testIncrementPushTempOptimisationMNU.
	self assert: (method byteCodes at: 5) = IncPushTemp.
	self should: [method value: nil] raise: MessageNotUnderstood!

testIncrementTempOptimisation
	| disasm method map debugMethod debugMap i |
	method := self getTestMethod: #testIncrementTempOptimisation.
	disasm := method disassembly.
	self assert: disasm 
				= 'Normal, 0 args, 1 stack temps, 0 literals

	1	Push 1
	2	Pop Temp[0]
	3	Push Temp[0]
	4	Push 5
	6	Special Send #>
	7	Jump If True +5 to 14
	9	Increment Temp[0]
	12	Jump -11 to 3
	14	Push Temp[0]
	15	Return '.
	self assert: (self evalTestMethod: method) = 6.
	method := self getTestMethod: #testIncrementTempOptimisationLong.
	self assert: (method byteCodes at: 24) = IncTemp.
	self assert: (self evalTestMethod: method) = 6.
	"Overflow"
	method := self getTestMethod: #testIncrementTempOptimisationOverflow.
	self assert: (method byteCodes at: 6) = IncTemp.
	self assert: (self evalTestMethod: method) = (SmallInteger maximum + 1).
	"Non-small integer incremented"
	method := self getTestMethod: #testIncrementTempOptimisationLargeInt.
	self assert: (method byteCodes at: 8) = IncTemp.
	self assert: (self evalTestMethod: method) = (200 factorial + 1).
	"Non-integer incremented"
	method := self getTestMethod: #testIncrementTempOptimisationFloat.
	self assert: (method byteCodes at: 5) = IncTemp.
	self assert: (self evalTestMethod: method) = (1.0 + 1).
	"Non-number incremented"
	method := self getTestMethod: #testIncrementTempOptimisationMNU.
	self assert: (method byteCodes at: 5) = IncTemp.
	self assert: (method byteCodes at: 6) = PopTemp.
	self assert: (method byteCodes at: 7) = 0.	"temp 0"
	self should: [self evalTestMethod: method] raise: MessageNotUnderstood.
	"Check debug frame re-mapping for increments that result in actual Send+ (split instruction)"
	map := method debugInfo textMap.
	debugMethod := method asDebugMethod.
	debugMap := debugMethod debugInfo textMap.
	i := self findIP: 5 inTextMap: map.
	self assert: (map at: i) key = 5.
	self assert: (map at: i) value = (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) = Increment.
	i := self findIP: 6 inTextMap: map.
	self assert: (map at: i) key = 6.
	self assert: (map at: i) value = (debugMap at: i) value.
	self assert: (debugMethod byteCodes at: (debugMap at: i) key) = (ShortPopTemp + 0)!

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
			self assert: result class == Fraction.
			self assert: result = expected].
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
	#(0 1 2 15 16 31 32 63 64 65) do: 
			[:eachPower | 
			| values |
			values := OrderedCollection new.
			values
				add: (2 ** eachPower + 1) negated;
				add: (2 ** eachPower - 1) negated;
				add: (2 ** eachPower) negated;
				add: 2 ** eachPower - 1;
				add: 2 ** eachPower;
				add: 2 ** eachPower + 1.
			values do: 
					[:eachVal | 
					self assert: (self evaluateExpression: eachVal printString) = eachVal.
					"Now test again with a radix prefix"
					2 to: 36
						do: [:eachRadix | (self evaluateExpression: (eachVal printStringRadix: eachRadix)) = eachVal]]]!

testLiteralArray
	self assert: ((Compiler evaluate: '#(-)') = (Array with: #-)).
	self assert: ((Compiler evaluate: '#(-1)') = (Array with: -1)).
	self assert: ((Compiler evaluate: '#(-a)') = (Array with: #- with: #a)).
	self assert: ((Compiler evaluate: '#(- 1)') = (Array with: #- with: 1))!

testNestedCopyingBlocks
	| method value value2 |
	method := self getTestMethod: #testNestedCopyingBlocks.
	self deny: method needsContext.
	self assert: method stackTempCount = 1.
	value := method value: DolphinCompilerTestMethods new withArguments: #().
	self assert: (value isKindOf: BlockClosure).
	"Should only be one copied values, 0 temps and args"
	self assert: value tempCount = 1.
	self assert: value argumentCount = 0.
	self assert: value stackTempCount = 0.
	self assert: value size = 1.
	value2 := value value.
	self assert: (value2 isKindOf: BlockClosure).
	"Should only be one copied values, 0 temps and args"
	self assert: value2 tempCount = 1.
	self assert: value2 argumentCount = 0.
	self assert: value2 stackTempCount = 0.
	self assert: value2 size = 1.
	self assert: value2 value = 'abcabc'!

testNestedWhileTrueAtStartOfCleanBlock
	"Nested optimized blocks where the block occurs before the message are a tricky case
	for the compiler"

	| method block |
	method := self getTestMethod: #testNestedWhileTrueAtStartOfCleanBlock.
	block := method value: DolphinCompilerTestMethods new withArguments: #().
	self assert: block == (method literals at: 3).
	"Block should start immediately after a short push const and return stack top"
	self assert: block initialIP = 3!

testRadixInteger
	0 to: 72
		do: 
			[:eachVal | 
			2 to: 36
				do: [:eachRadix | (self evaluateExpression: (eachVal printStringRadix: eachRadix)) = eachVal]].
	0 to: 35
		do: 
			[:eachRadix | 
			"Test invalid radix integers cause an MNU of #rN"

			| suffix |
			suffix := String with: $r with: (Character digitValue: eachRadix).
			self 
				should: 
					[| expr |
					expr := eachRadix printString , suffix.
					self evaluateExpression: expr]
				raise: MessageNotUnderstood
				matching: 
					[:ex | 
					(ex receiver = eachRadix and: [ex selector equals: suffix]) 
						ifFalse: 
							[self halt.
							false]
						ifTrue: [true]]]!

testReturnFromOptimizedBlock
	| compiled lowerText upperText |
	compiled := self getTestMethod: #testReturnFromOptimizedBlock.
	self assert: compiled needsContext.
	"Note that the far returns in the optimized ifTrue: blocks can replaced with a normal returns"
	lowerText := compiled disassembly.
	upperText := 'Normal, 0 args, 0 env temps, 0 literals, needs context

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
	19	Special Send #<
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
	40	Return nil'.
	self assert: lowerText = upperText
	"
DiffBrowser show
	compare: lowerText id: 'Actual'
	and: upperText id: 'Expected'
"!

testReturnImmediate
	"#397"
	| method |
	#(-128 -2 3 127) do: 
			[:each | 
			method := (self compileExpression: (each printStringRadix: 2)) method.
			self assert: method extraIndex = 5.
			self 
				assert: method byteCodes = (ByteArray 
								with: Nop
								with: PushImmediate
								with: (each bitAnd: 16rFF)
								with: ReturnFromMessage)].
	#(2r1111111111 2r11111111111 2r111111111111 2r1111111111111 2r11111111111111 2r111111111111111 -2r111111111111111) do: 
			[:each | 
			method := (self compileExpression: (each printStringRadix: 2)) method.
			self assert: method extraIndex = 5.
			self 
				assert: method byteCodes = (ByteArray 
								with: LongPushImmediate
								with: ((each % 256) bitAnd: 16rFF)
								with: ((each // 256) bitAnd: 16rFF)
								with: ReturnFromMessage)].
!

testScanningScaledDecimals
	"Test Number>>readFrom: with ScaledDecimals"

	| string result expected |
	#('123s' '123s2' '123.0s' '123.12s' '123.12s2' '123.12s3') 
		do: [:each | self scanScaledDecimal: each].
	string := '123s-2'.
	expected := Number readFrom: string readStream.
	result := self evaluateExpression: string.
	self assert: result class == ScaledDecimal.
	self assert: result scale = 0.
	self assert: result = 121.
	#('123se' '123.0se' '123.0s2e') do: [:each | self scanNonNumericEnd: each class: ScaledDecimal].
	self 
		should: [self evaluateExpression: '123.s']
		raise: self compilationErrorClass
		matching: 
			[:ex | 
			self isD6OrLater 
				ifTrue: [ex errorCode = CErrUndeclared and: [ex range = (5 to: 5)]]
				ifFalse: [(self messageFromError: ex) = 'undeclared ''s''']]!

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
	self assert: (compiled method value: nil withArguments: #()) tempCount == 4.
	text := '[ | a |
	a := 1.
	a ifNotNil: [:arg | arg "do nothing"].
	a ifNotNil: [:arg | arg "do nothing"]]'.
	self shouldnt: [compiled := self compileExpression: text] raise: Compiler notificationClass.
	"	self assert: compiled method tempCount == 3."
	self assert: (compiled method value: nil withArguments: #()) tempCount == 3.
	compiled := nil.
	text := '[|a|
	a ifNotNil: [:arg | "do nothing" ].
	arg ifNil: [self halt]]'.
	self 
		should: 
			[Compiler 
				compileExpression: text
				in: UndefinedObject
				flags: defaultCompileFlags]
		raise: self compilationErrorClass
		matching: 
			[:ex | 
			self isD6OrLater 
				ifTrue: [ex errorCode = CErrUndeclared]
				ifFalse: [ex errorMessage = 'undeclared ''arg''']]!

testSharedOuterTemps
	#('| a | a := [[a := 2]]' '| a b | b := [[a]]. a := 2. b') do: 
			[:text | 
			| value value2 method |
			method := (Compiler compileExpression: text in: Object) method.
			self assert: method needsContext.
			self assert: method envTempCount = 1.
			value := method value: nil withArguments: #().
			self assert: (value isKindOf: BlockClosure).
			"Should only be one copied values, 0 temps and args"
			self assert: value tempCount = 0.
			self assert: value argumentCount = 0.
			self assert: value stackTempCount = 0.
			self assert: value size = 0.
			value2 := value value.
			self assert: (value2 isKindOf: BlockClosure).
			"Should only be one copied values, 0 temps and args"
			self assert: value2 tempCount = 0.
			self assert: value2 argumentCount = 0.
			self assert: value2 stackTempCount = 0.
			self assert: value2 size = 0.
			self assert: value2 value = 2]
!

testSpecialLiteralsAsUnarySelectors
	"nil, true and false should all be valid as method selectors"

	| method |
	#(nil true false) do: 
			[:each | 
			self 
				shouldnt: [method := self compileMethod: ('<1p> ^super <1p>' expandMacrosWith: each) in: self class]
				raise: self compilationErrorClass.
			self assert: method notNil]!

testSymbolScanning
	#('#a' '#a1' '#a:' '#a1:' '#a:b:' '#a_:_:' '#a1:b2:' '#|' '#||' '#|||' '#_' '#_a' '#-' '#--') do: 
			[:each | 
			| sym bracketed chars |
			sym := self evaluateExpression: each.
			self assert: sym notNil.
			chars := each copyFrom: 2.
			self assert: (sym equals: chars).
			bracketed := '(' , each , ')'.
			sym := self evaluateExpression: bracketed.
			self assert: sym notNil.
			self assert: (sym equals: chars)].
	#('#2' '#;' '#:') do: 
			[:each | 
			self should: [self evaluateExpression: each] raise: self compilationErrorClass.
			self assert: (self evaluateExpression: each) isNil].
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

testTempPairing
	| prefix method pairs pair |
	prefix := '
	| t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 | 
	t0 := 0. t1 := 1. t2 := 2. t3 := 3. t4 := 4. t5 := 5. t6 := 6. t7 := 7.
	t8 := 8. t9 := 9. t10 := 10. t11 := 11. t12 := 12. t13 := 13. t14 := 14. t15 := 15. t16 := 16. '.

	"short push + short push"
	method := (self compileExpression: prefix , ' t6 - t7') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs size = 1.
	pair := pairs first.
	self assert: pair last = ((6 << 4) + 7).
	self assert: (method value: nil withArguments: #()) = (6 - 7).

	"short push + long push"
	method := (self compileExpression: prefix , ' t7 - t8') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs size = 1.
	pair := pairs first.
	self assert: pair last = ((7 << 4) + 8).
	self assert: (method value: nil withArguments: #()) = (7 - 8).

	"long push + short push"
	method := (self compileExpression: prefix , ' t8 - t7') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs size = 1.
	pair := pairs first.
	self assert: pair last = ((8 << 4) + 7).
	self assert: (method value: nil withArguments: #()) = (8 - 7).

	"long push + long push"
	method := (self compileExpression: prefix , ' t8 - t10') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs size = 1.
	pair := pairs first.
	self assert: pair last = ((8 << 4) + 10).
	self assert: (method value: nil withArguments: #()) = (8 - 10).

	"short + long (out of range)"
	method := (self compileExpression: prefix , ' t7 - t16') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) = (7 - 16).

	"long + long (out of range)"
	method := (self compileExpression: prefix , ' t8 - t16') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) = (8 - 16).

	"long (out of range) + short"
	method := (self compileExpression: prefix , ' t16 - t7') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) = (16 - 7).

	"long (out of range) + long"
	method := (self compileExpression: prefix , ' t16 - t8') method.
	pairs := method byteCodeSegments select: [:each | each first = self pushTempPair].
	self assert: pairs isEmpty.
	self assert: (method value: nil withArguments: #()) = (16 - 8)!

testTimesRepeat
	"This is erroneous, but compiler does not detect that, just looks for literal zero arg block, which is OK I think"

	| result method src |
	result := self compileExpression: '5 timesRepeat: []'.
	method := result method.
	self assert: method notNil.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) = 5.
	self 
		shouldnt: [result := self compileExpression: '| a | a := 0. 10 + (5 timesRepeat: [a := a + 1]). a']
		raise: self compilationWarningClass.
	method := result method.
	self assert: method notNil.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) = 5.

	"Test case which cannot be inlined"
	src := '| aBlock i | i := 0. aBlock := [i := i + 1]. 5 timesRepeat: aBlock. i.'.
	self 
		should: [result := self compileExpression: src]
		raise: self compilationWarningClass
		matching: 
			[:ex | 
			self isD6OrLater 
				ifTrue: 
					[ex errorCode = CWarnExpectNiladicBlockArg 
						and: [(src copyFrom: ex range start to: ex range stop) = 'timesRepeat:']]
				ifFalse: 
					[ex errorMessage = 'can''t optimize #timesRepeat: (requires niladic block as the argument)' 
						and: [(src copyFrom: ex range start to: ex range stop) = 'aBlock']]].
	method := result method.
	self assert: method notNil.
	self assert: method needsContext.
	self assert: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) = 5.

	"Test 0 iterations, which compiler can remove (should come down to just a Return Zero, or at least return literal constant zero"
	self shouldnt: [result := self compileExpression: '0 timesRepeat: [Sound bell]']
		raise: self compilationWarningClass.
	method := result method.
	self assert: method notNil.
	self assert: method isPacked.
	"	self assert: method byteCodes = (ByteArray with: Nop with: ShortPushZero with: ReturnFromMessage)."
	self assert: (method value: nil withArguments: #()) = 0.

	"Test 0 iterations, which compiler can remove (should come down to just a Return Zero, or at least return literal constant zero"
	self shouldnt: [result := self compileExpression: '-1 timesRepeat: [Sound bell]']
		raise: self compilationWarningClass.
	method := result method.
	self assert: method notNil.
	self assert: method isPacked.
	self assert: (method value: nil withArguments: #()) = -1!

testTimesRepeatResult
	#(0 1 2 100) do: 
			[:each | 
			self 
				assert: ((self compileExpression: ('<1p> timesRepeat: []' 
								expandMacrosWith: each)) 
						method value: nil withArguments: #()) 
						= each.
			self 
				assert: ((self compileExpression: ('| i | i := 0. <1p> timesRepeat: [i := i + 1]. i' 
								expandMacrosWith: each)) 
						method value: nil withArguments: #()) 
						= each]
"
[1000000 timesRepeat: []] method disassembly
"!

testToByDo
	| result method src |
	#(0 1 2 3) do: 
			[:i | 
			result := self 
						compileExpression: ('| a | a := OrderedCollection new. <1d> to: 2 by: 1 do: [:i | a add: i]. a' 
								expandMacrosWith: i).
			method := result method.
			self assert: method notNil.
			self deny: method needsContext.
			self assert: (method value: nil withArguments: #()) = (i to: 2) asOrderedCollection.
			result := self 
						compileExpression: ('| a | a := OrderedCollection new. <1d> to: 1 by: -1 do: [:i | a add: i]. a' 
								expandMacrosWith: i).
			method := result method.
			self assert: method notNil.
			self deny: method needsContext.
			self assert: (method value: nil withArguments: #()) = (i to: 1 by: -1) asOrderedCollection].
	src := '| aBlock i | i := 0. aBlock := [:each | i := i + each]. 1 to: 5 by: 2 do: aBlock. i'.
	self 
		should: [result := self compileExpression: src]
		raise: self compilationWarningClass
		matching: 
			[:ex | 
			ex errorCode = CWarnExpectMonadicBlockArg 
				and: [(src copyFrom: ex range start to: ex range stop) = 'aBlock']]!

testToByDoWithFloatSteps
	(Array with: (1 to: 2 by: 0.5) with: (1 to: 0 by: -0.5)) do: 
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
			self assert: (method value: nil withArguments: #()) = each asOrderedCollection]!

testWhileFalse
	"Test #whileFalse"

	"This is erroneous, but compiler does not detect that, just looks for literal zero arg block, which is OK I think"

	| result method |
	result := self compileExpression: '[] whileFalse'.
	method := result method.
	self assert: method notNil.
	self deny: method needsContext.
	"	self 
		assert: method byteCodes = (ByteArray 
						with: ShortPushNil
						with: NearJumpIfFalse
						with: 255 - 1 - 1
						with: ReturnNil).
"
	"Test a simple counting loop"
	result := self compileExpression: '| i | i := 0. [i := i + 1. i > 10] whileFalse. i'.
	method := result method.
	self assert: method notNil.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) = 11.

	"Test case which cannot be inlined"
	result := self 
				compileExpression: '| i block | i := 0. block := [i := i + 1. i > 10]. block whileFalse. i'.
	method := result method.
	self assert: method notNil.
	self assert: method needsContext.
	self assert: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) = 11!

testWhileTrue
	"This is erroneous, but compiler does not detect that, just looks for literal zero arg block, which is OK I think"

	| result method |
	result := self compileExpression: '[] whileTrue'.
	method := result method.
	self assert: method notNil.
	self deny: method needsContext.
	"	self 
		assert: method byteCodes = (ByteArray 
						with: ShortPushNil
						with: NearJumpIfTrue
						with: 255 - 1 - 1
						with: ReturnNil).
"
	result := self compileExpression: '| i | i := 0. [i := i + 1. i <= 10] whileTrue. i'.
	method := result method.
	self assert: method notNil.
	self deny: method needsContext.
	self deny: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) = 11.

	"Test case which cannot be inlined"
	result := self 
				compileExpression: '| i block | i := 0. block := [i := i + 1. i <= 10]. block whileTrue. i'.
	method := result method.
	self assert: method notNil.
	self assert: method needsContext.
	self assert: (method byteCodeSegments anySatisfy: [:each | each first = BlockCopy]).
	self assert: (method value: nil withArguments: #()) = 11!

testWriteAccessor
	| class inst |
	class := CompilerTestClasses current testClass.
	inst := class new.
	class instVarNames do: 
			[:each | 
			| accessor selector |
			selector := (each , ':') asSymbol.
			accessor := class compiledMethodAt: selector.
			self assert: accessor extraIndex = 7.
			inst perform: selector with: each.
			self assert: (inst perform: each asSymbol) = each]! !
!CompilerTest categoriesFor: #checkCompileError:range:code:message:line:source:!helpers!private! !
!CompilerTest categoriesFor: #compilationErrorClass!constants!private! !
!CompilerTest categoriesFor: #compilationWarningClass!constants!public! !
!CompilerTest categoriesFor: #compileExpression:!helpers!private! !
!CompilerTest categoriesFor: #compileExpression:in:!helpers!private! !
!CompilerTest categoriesFor: #compileMethod:in:!helpers!private! !
!CompilerTest categoriesFor: #defaultCompileFlags!helpers!private! !
!CompilerTest categoriesFor: #evalTestMethod:!helpers!public! !
!CompilerTest categoriesFor: #evalTestMethod:withArgs:!helpers!public! !
!CompilerTest categoriesFor: #evaluateExpression:!helpers!private! !
!CompilerTest categoriesFor: #findIP:inTextMap:!development!private! !
!CompilerTest categoriesFor: #getDebugInfoFor:debug:!private! !
!CompilerTest categoriesFor: #getTestMethod:!private! !
!CompilerTest categoriesFor: #knownTextMapIssues!private! !
!CompilerTest categoriesFor: #messageFromError:!helpers!private! !
!CompilerTest categoriesFor: #pushTempPair!constants!private! !
!CompilerTest categoriesFor: #scan:class:!helpers!private! !
!CompilerTest categoriesFor: #scanNonNumericEnd:class:!helpers!private! !
!CompilerTest categoriesFor: #scanScaledDecimal:!helpers!private! !
!CompilerTest categoriesFor: #scanSmallIntegerNonNumericEnd:!helpers!private! !
!CompilerTest categoriesFor: #setInteractiveCompile!helpers!public! !
!CompilerTest categoriesFor: #setUp!helpers!private! !
!CompilerTest categoriesFor: #shortPushOne!helpers!private! !
!CompilerTest categoriesFor: #test1054!public!unit tests! !
!CompilerTest categoriesFor: #testBlockTempsMap!public!unit tests! !
!CompilerTest categoriesFor: #testBlockWithAllTempTypes!public!unit tests! !
!CompilerTest categoriesFor: #testByteArraysInLiteralArrays!public!unit tests! !
!CompilerTest categoriesFor: #testCompileTimeExpressions!public!unit tests! !
!CompilerTest categoriesFor: #testConstExpressionReferences!public!unit tests! !
!CompilerTest categoriesFor: #testCopyingBlocks1!public!unit tests! !
!CompilerTest categoriesFor: #testCopyingBlocks2!public!unit tests! !
!CompilerTest categoriesFor: #testDecrementPushTempOptimisation!public!unit tests! !
!CompilerTest categoriesFor: #testDecrementTempOptimisation!public!unit tests! !
!CompilerTest categoriesFor: #testEmpty!public!unit tests! !
!CompilerTest categoriesFor: #testEmptyIfInLoop!public!unit tests! !
!CompilerTest categoriesFor: #testFarReturnFromBlock!public!unit tests! !
!CompilerTest categoriesFor: #testFloatScanning!public!unit tests! !
!CompilerTest categoriesFor: #testIfNil!public!unit tests! !
!CompilerTest categoriesFor: #testIfNilifNotNil!public!unit tests! !
!CompilerTest categoriesFor: #testIfNilifNotNilNoArg!public!unit tests! !
!CompilerTest categoriesFor: #testIfNotNil!public!unit tests! !
!CompilerTest categoriesFor: #testIfNotNilifNil!public!unit tests! !
!CompilerTest categoriesFor: #testIfNotNilifNilNoArg!public!unit tests! !
!CompilerTest categoriesFor: #testImmutableLiterals!public!unit tests! !
!CompilerTest categoriesFor: #testIncrementDecrementOptimisation!public!unit tests! !
!CompilerTest categoriesFor: #testIncrementPushTempOptimisation!public!unit tests! !
!CompilerTest categoriesFor: #testIncrementTempOptimisation!public!unit tests! !
!CompilerTest categoriesFor: #testIntegerScanning!public!unit tests! !
!CompilerTest categoriesFor: #testIntegerScanningBoundaries!public!unit tests! !
!CompilerTest categoriesFor: #testLiteralArray!public!unit tests! !
!CompilerTest categoriesFor: #testNestedCopyingBlocks!public!unit tests! !
!CompilerTest categoriesFor: #testNestedWhileTrueAtStartOfCleanBlock!public!unit tests! !
!CompilerTest categoriesFor: #testRadixInteger!public!unit tests! !
!CompilerTest categoriesFor: #testReturnFromOptimizedBlock!public!unit tests! !
!CompilerTest categoriesFor: #testReturnImmediate!exceptions!public!unit tests! !
!CompilerTest categoriesFor: #testScanningScaledDecimals!public!unit tests! !
!CompilerTest categoriesFor: #testScope!public!unit tests! !
!CompilerTest categoriesFor: #testSharedOuterTemps!public!unit tests! !
!CompilerTest categoriesFor: #testSpecialLiteralsAsUnarySelectors!public! !
!CompilerTest categoriesFor: #testSymbolScanning!public!unit tests! !
!CompilerTest categoriesFor: #testTempPairing!public!unit tests! !
!CompilerTest categoriesFor: #testTimesRepeat!public!unit tests! !
!CompilerTest categoriesFor: #testTimesRepeatResult!public!unit tests! !
!CompilerTest categoriesFor: #testToByDo!public!unit tests! !
!CompilerTest categoriesFor: #testToByDoWithFloatSteps!public!unit tests! !
!CompilerTest categoriesFor: #testWhileFalse!public!unit tests! !
!CompilerTest categoriesFor: #testWhileTrue!public!unit tests! !
!CompilerTest categoriesFor: #testWriteAccessor!public!unit tests!unit tests-known failures! !

!CompilerTest class methodsFor!

buildSuiteFromSelectors
	^self hasFullClosures 
		ifTrue: [super buildSuiteFromSelectors]
		ifFalse: [self buildSuiteFromMethods: #()]!

resources
	^Array with: CompilerTestClasses! !
!CompilerTest class categoriesFor: #buildSuiteFromSelectors!Building Suites!public! !
!CompilerTest class categoriesFor: #resources!Accessing!public! !

