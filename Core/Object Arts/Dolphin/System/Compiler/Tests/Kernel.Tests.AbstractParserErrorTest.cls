"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.AbstractParserErrorTest'
	instanceVariableNames: 'errors'
	classVariableNames: ''
	imports: #(#{Kernel.ParseErrorCodes} #{External})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.AbstractParserErrorTest guid: (Core.GUID fromString: '{5f42cbdc-9ab6-40b0-826d-b9cb9dd30c78}')!
Kernel.Tests.AbstractParserErrorTest isNonInstantiable: true!
Kernel.Tests.AbstractParserErrorTest comment: ''!
!Kernel.Tests.AbstractParserErrorTest methodsFor!

buildNestedBlocks: nesting 
	| source |
	source := String writeStream.
	source nextPutAll: '| t0 | t0 := 1. '.
	"We'll need to skip a few levels, or there will be too many temps"
	1 to: nesting
		do: 
			[:each | 
			source
				nextPutAll: '[|t';
				display: each;
				nextPutAll: '| t';
				display: each;
				nextPutAll: ' := ';
				display: each;
				nextPutAll: '. t0 := t';
				display: each;
				nextPutAll: ' := '].
	"Note that the optimized block itself is not counted in the depth"
	source
		display: nesting + 1;
		nextPutAll: ' ifNotNil: [:t';
		display: nesting + 1;
		nextPutAll: ' | t0*'.
	1 to: nesting
		do: 
			[:each | 
			"Must assign to each temp, otherwise it will just be copied"
			source
				nextPutAll: '(t';
				print: each;
				nextPutAll: ':= ';
				nextPut: $t;
				print: each;
				nextPutAll: '*1)';
				nextPut: $*].
	source
		nextPut: $t;
		display: nesting + 1;
		nextPutAll: ']'.
	nesting timesRepeat: [source nextPutAll: '] value'].
	^source contents!

checkCompileError: ex range: anInterval code: anInteger line: lineInteger source: aString
	^ex errorCode = anInteger and: 
			[((anInterval stop isNil and: [ex range start = anInterval start]) or: [ex range = anInterval]) and: 
					[(lineInteger < 0 or: [ex line < 0 or: [ex line = lineInteger]]) and: 
							[| msgString |
							msgString := (self errorFormats at: anInteger)
										expandMacrosWithArguments: {aString copyFrom: ex range start to: ex range stop} , ex extras
										locale: Locale smalltalk.
							ex errorMessage = msgString]]]!

compilationErrorClass
	^self parserClass errorClass!

compilationWarningClass
	^self parserClass warningClass!

compileMethod: aString in: aClass
	^Compiler
		compile: aString
		in: aClass
		environment: nil
		flags: 0!

errorFormats
	^Compiler notificationClass errorFormats!

evaluateExpression: aString 
	^Compiler evaluate: aString!

getTestMethod: aSymbol
	| oldMethod result method |
	oldMethod := DolphinCompilerTestMethods compiledMethodAt: aSymbol.
	self shouldnt: 
			[result := self compileMethod: oldMethod getSource in: DolphinCompilerTestMethods]
		raise: Compiler errorClass.
	method := result method.
	method selector: aSymbol.
	method
		sourceDescriptor: oldMethod sourceDescriptor;
		isPrivate: oldMethod isPrivate;
		isImmutable: true.	"The method has not actually changed, so it is inappropriate to issue a #methodUpdated: event"
	^method!

lexicalError: aString range: anInterval line: lineInteger code: codeInteger
	self
		parseExprError: aString
		in: UndefinedObject
		range: anInterval
		line: lineInteger
		code: codeInteger!

maxLiterals
	^VMConstants.MaxLiterals!

parseError: each
	self parserClass parseExpression: each first
		onError: [:string :pos | ^self assert: pos equals: each last].
	self error: 'Parser didn''t fail'!

parseExprError: aString in: aClass range: anInterval line: lineInteger code: anInteger
	self
		should: 
			[[self parseExpression: aString in: aClass] on: self compilationWarningClass do: [:ex | ex resume]]
		raise: self compilationErrorClass
		matching: 
			[:ex |
			(self
				checkCompileError: ex
				range: anInterval
				code: anInteger
				line: lineInteger
				source: aString) or: 
						["Trace the actual error to help with diagnosis"
						self traceException: ex source: aString.
                        false]]!

parseExprError: aString range: anInterval line: lineInteger code: anInteger
	| ast |
	"The parser errors/warnings are caught and suppressed here to avoid dumping loads of stuff to the transcript while the test runs."
	ast := [self parseExpression: aString in: self class]
				on: self compilationWarningClass , self compilationErrorClass
				do: [:ex | ex resume].
	self
		assert: (errors anySatisfy: 
					[:each |
					self
						checkCompileError: each
						range: anInterval
						code: anInteger
						line: lineInteger
						source: aString]).
	^ast!

parseExpression: aString 
	^self parseExpression: aString in: self class!

parseExpression: aString in: aClass
	^self subclassResponsibility!

parseMethod: aString in: aClass 
	^self subclassResponsibility!

parseMethod: aString notificationClass: notificationClass in: aClass range: anInterval code: anInteger
	self
		should: [self parseMethod: aString in: aClass]
		raise: notificationClass
		matching: 
			[:ex |
			(self
				checkCompileError: ex
				range: anInterval
				code: anInteger
				line: -1
				source: aString) or: 
						[((ex isKindOf: CompilerNotification) not or: [ex class severity >= notificationClass severity])
							ifTrue: 
								["Useful for debugging to know what the notification actually was"
								self traceException: ex source: aString].
						false]]!

parseMethodError: aString code: anInteger range: anInterval 
	^self 
		parseMethodError: aString
		in: self class
		range: anInterval
		code: anInteger!

parseMethodError: aString in: aClass range: anInterval code: anInteger
	self
		parseMethod: aString
		notificationClass: CompilerErrorNotification
		in: aClass
		range: anInterval
		code: anInteger!

parseMethodInfo: aString in: aClass range: anInterval code: anInteger
	self
		parseMethod: aString
		notificationClass: CompilerInfoNotification
		in: aClass
		range: anInterval
		code: anInteger!

parseMethodInfo: aSymbol rangeBlock: aMonadicValuable code: anInteger
	| text method range |
	method := DolphinCompilerTestMethods compiledMethodAt: aSymbol.
	text := method getSource.
	range := aMonadicValuable value: text.
	self
		parseMethodInfo: text
		in: method methodClass
		range: range
		code: anInteger!

parseMethodWarning: aString in: aClass range: anInterval code: anInteger
	self
		parseMethod: aString
		notificationClass: CompilerWarningNotification
		in: aClass
		range: anInterval
		code: anInteger!

parseMethodWarning: source in: aClass range: anInterval code: anInteger extra: anObject
	^self
		parseMethod: source
		notificationClass: CompilerWarningNotification
		in: aClass
		range: anInterval
		code: anInteger!

parseMethodWarning: aString range: anInterval code: anInteger 
	^self 
		parseMethodWarning: aString
		in: self class
		range: anInterval
		code: anInteger!

parseMethodWarning: aSymbol rangeBlock: aMonadicValuable code: anInteger
	| text method range |
	method := DolphinCompilerTestMethods compiledMethodAt: aSymbol.
	text := method getSource.
	range := aMonadicValuable value: text.
	self
		parseMethodWarning: text
		in: method methodClass
		range: range
		code: anInteger!

parserClass
	^self subclassResponsibility!

restrictedSelectors
	^##(#(#== #and: #or: #ifTrue: #ifTrue:ifFalse: #ifFalse: #ifFalse:ifTrue: #timesRepeat: #to:do: #to:by:do: #yourself #basicAt: #basicAt:put: #basicNew: #basicClass #basicSize #ifNil: #ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: #??)
		asIdentitySet)!

tempWarningRangeIn: aString
	| mark |
	mark := aString indexOf: $@.
	self assert: mark >= 1
		description: 'Inconclusive: Test method source does not contain expected marker'.
	^mark + 2 to: (aString lastIndexOf: $@) - 2!

testByteArraysInLiteralArrays
	"#980"

	| text |
	text := '#(1 2 #[-1 255])'.
	self should: [self parseExpression: text] raise: self compilationErrorClass.
	text := '#(#[1 256] 1 2)'.
	self should: [self parseExpression: text] raise: self compilationErrorClass!

testCompileTimeExpressions
	#(' ##( ' ' ##(1 ') do: 
			[:each | 
			self 
				parseExprError: each
				range: (2 to: each size)
				line: 1
				code: CErrStaticExprNotClosed]!

testErrorsAnnotationBadArg
	| source mark |
	source := 'blah <blah: void>'.
	mark := source indexOf: $v.
	self
		parseMethodError: source
		code: CErrUndeclared
		range: (mark to: mark + 3).
	"For a unary tag (a mispelling in this case), no argument is expected so there should be a close tag"
	source := 'blah <overlaped cdecl: void blah>'.
	mark := source indexOf: $c.
	self
		parseMethodError: source
		code: CErrExpectCloseTag
		range: (mark to: mark + 5)!

testErrorsAnnotationBadNamespace
	| source mark |
	source := 'blah <namespace: #s>'.
	mark := source indexOf: $#.
	self
		parseMethodError: source
		code: CErrExpectNamespace
		range: (mark to: mark + 1)!

testErrorsAnnotationBadSelector
	"Annotations must have unary or keyword selectors. Note that literal symbols are not valid."

	#(12 '''s''' #+ '#mutable') do: 
			[:each |
			| source |
			source := 'blah %< <1d> %>' << each.
			self
				parseMethodError: source
				code: CErrBadSelector
				range: ((source indexOf: $<) + 2 to: (source indexOf: $>) - 2)]!

testErrorsAnnotationInvalidArg
	| source mark |
	source := 'blah <blah: void>'.
	mark := source indexOf: $:.
	self
		parseMethodError: source
		code: CErrUndeclared
		range: (mark + 2 to: (source indexOf: $>) - 1).
	#('self' 'super' 'thisContext' 'arg') do: 
			[:each |
			source := 'blah: arg %<z: <1s>%>' << each.
			mark := source indexOf: $z.
			self
				parseMethodError: source
				code: CErrExpectAnnotationArg
				range: (mark + 3 to: (source indexOf: $>) - 1)].
	"For a unary tag, no argument is expected so there should be a close tag"
	source := 'blah <overlaped cdecl: void blah>'.
	mark := source indexOf: $c.
	self
		parseMethodError: source
		code: CErrExpectCloseTag
		range: (mark to: mark + 5)!

testErrorsAnnotationInvalidSelector
	| source mark |
	"Not a keyword"
	source := 'blah < 12 cdecl: void blah>'.
	mark := source indexOf: $1.
	self
		parseMethodError: source
		code: CErrBadSelector
		range: (mark to: mark + 1)!

testErrorsAnnotationMissingArg
	| source mark |
	source := 'blah <blah:>'.
	mark := source indexOf: $>.
	self
		parseMethodError: source
		code: CErrExpectAnnotationArg
		range: (mark to: mark).
	source := 'blah <blah: 1 wibble:>'.
	mark := source indexOf: $>.
	self
		parseMethodError: source
		code: CErrExpectAnnotationArg
		range: (mark to: mark)!

testErrorsArrayNotClosed
	| text start |
	self
		parseExprError: '#(() 1 a ''a'' 1.0 &'
		range: (1 to: 18)
		line: 1
		code: CErrArrayNotClosed.
	text := '#(() -
		1
		 (a ''a'' 1.0 &'.
	start := text lastIndexOf: $(.
	self
		parseExprError: text
		range: (start to: text size)
		line: 3
		code: CErrArrayNotClosed!

testErrorsAssignBlockArgument
	| text i |
	text := '[:a | 
			a := 100]'.
	i := text lastIndexOf: $a.
	self 
		parseExprError: text
		range: (i to: text size - 1)
		line: 2
		code: CErrAssignmentToArgument!

testErrorsAssignClass
	| source |
	source := ' Object := nil '.
	self
		parseExprError: source
		range: (2 to: source size - 1)
		line: 1
		code: CErrAssignConstant.

	"Make sure can assign to other globals, even if they are aliasing classes"
	
	[Smalltalk at: #CompilerTestGlobal put: Object.
	self shouldnt: [self evaluateExpression: 'CompilerTestGlobal := 1']
		raise: Compiler notificationClass.
	self assert: #{Smalltalk.CompilerTestGlobal} value equals: 1.
	self shouldnt: [self evaluateExpression: 'CompilerTestGlobal := ''2''']
		raise: Compiler notificationClass.
	self assert: #{Smalltalk.CompilerTestGlobal} value equals: '2']
			ensure: [Smalltalk removeKey: #CompilerTestGlobal ifAbsent: nil]!

testErrorsAssignConstant
	| source |
	source := 'x CErrAssignConstant := 100'.
	self
		parseMethodError: source
		in: self class
		range: (3 to: source size)
		code: CErrAssignConstant!

testErrorsAssignMethodArgument
	| source start |
	source := 'x: abc abc := 1'.
	start := source lastIndexOf: $a.
	self 
		parseMethodError: source
		code: CErrAssignmentToArgument
		range: (start to: source size).
	source := 'x: abc abc + 1. abc := 1'.
	start := source lastIndexOf: $a.
	self 
		parseMethodError: source
		code: CErrAssignmentToArgument
		range: (start to: source size)!

testErrorsBadCascade
	| source mark |
	source := 'self parserClass; 1;'.
	mark := source indexOf: $1.
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrExpectMessage.
	source := 'self parserClass; 12;'.
	mark := source indexOf: $1.
	self 
		parseExprError: source
		range: (mark to: mark + 1)
		line: 1
		code: CErrExpectMessage.
	source := 'self parserClass ; '.
	mark := source size.
	self 
		parseExprError: source
		range: (mark + 1 to: mark)
		line: 1
		code: CErrExpectMessage!

testErrorsBadMessagePattern
	| source mark |
	source := '1.0'.
	self 
		parseMethodError: source
		code: CErrBadSelector
		range: (1 to: source size).
	source := ': a'.
	self 
		parseMethodError: source
		code: CErrBadSelector
		range: (1 to: 1).
	source := ':: a'.
	self 
		parseMethodError: source
		code: CErrBadSelector
		range: (1 to: 1).
	source := 'a: a : size'.
	mark := source lastIndexOf: $:.
	self 
		parseMethodError: source
		code: CErrInvalExprStart
		range: (mark to: mark).
	""
	source := 'a:: a size'.
	mark := source lastIndexOf: $:.
	self 
		parseMethodError: source
		code: CErrExpectVariable
		range: (mark to: mark)!

testErrorsBadSuper
	"#1334"

	| source mark |
	source := 'super'.
	self 
		parseExprError: source
		range: (source size + 1 to: source size)
		line: 1
		code: CErrExpectMessage.
	source := '(super)'.
	self 
		parseExprError: source
		range: (source size to: source size)
		line: 1
		code: CErrExpectMessage.
	source := '(super) class'.
	mark := source indexOf: $).
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrExpectMessage.
	source := 'super; class'.
	mark := source indexOf: $;.
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrExpectMessage!

testErrorsBadTokenInArray
	"Bad token in array"

	| text start |
	text := '
		"Newline in ...
		... comment" #(() 1 a ''a'' 1.0 :)'.
	start := text indexOf: $:.
	self
		parseExprError: text
		range: (start to: start)
		line: 3
		code: CErrBadTokenInArray!

testErrorsBlockArgNameMissing
	| source mark |
	source := '[: ] '.
	mark := source indexOf: $].
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrExpectVariable.
	source := '[: | a |] '.
	mark := source indexOf: $|.
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrExpectVariable.
	source := '[: 12 ] '.
	mark := source indexOf: $1.
	self 
		parseExprError: source
		range: (mark to: mark + 1)
		line: 1
		code: CErrExpectVariable!

testErrorsBlockNestingTooDeep
	"Small test of the test first"

	| mark expected nesting source maxNest |
	nesting := 10.
	source := self buildNestedBlocks: nesting.
	expected := (nesting + 1) factorial.
	self assert: (self evaluateExpression: source) = expected.
	"Now 2 under max"
	maxNest := VMConstants.MaxBlockNesting.
	nesting := maxNest - 2.
	source := self buildNestedBlocks: nesting.
	expected := (nesting + 1) factorial.
	self assert: (self evaluateExpression: source) = expected.
	"Now 1 under max"
	nesting := maxNest - 1.
	source := self buildNestedBlocks: nesting.
	expected := (nesting + 1) factorial.
	self assert: (self evaluateExpression: source) = expected.
	"max nesting"
	maxNest := VMConstants.MaxBlockNesting.
	nesting := maxNest.
	source := self buildNestedBlocks: nesting.
	expected := (nesting + 1) factorial.
	self assert: (self evaluateExpression: source) = expected.
	"1 over max - should fail"
	nesting := maxNest + 1.
	source := self buildNestedBlocks: nesting.
	mark := (source indexOfSubCollection: nesting displayString) - 3.
	self
		parseExprError: source
		range: (mark to: nil)
		line: 1
		code: CErrBlockNestingTooDeep!

testErrorsBlockNotClosed
	"Test zero arg form now accepted by D6 compiler"

	"Each expression must have one trailing character for the test to work"

	#(' [ ' ' [)' '[1+2 ' '1 ifTrue: [ 1+2 ' '1 ifNotNil: [:x | x * 2 ' '1+2. [:a | ' '([:a |)' '##([1+2)') 
		do: 
			[:each | 
			self 
				parseExprError: each
				range: ((each indexOf: $[) to: each size - 1)
				line: 1
				code: CErrBlockNotClosed]!

testErrorsBlockTempsNotClosed
	"Unterminated statement"

	"Non-binary appears before close block temps"

	| source mark |
	source := '[:a ]'.
	self
		parseExprError: source
		range: (1 to: 3)
		line: 1
		code: CErrBlockArgListNotClosed.
	source := '[:a 1]'.
	self
		parseExprError: source
		range: (1 to: 3)
		line: 1
		code: CErrBlockArgListNotClosed.
	source := '[:arg1 :arg2 1]'.
	mark := source indexOf: $2.
	self
		parseExprError: source
		range: ((source indexOf: $[) to: mark)
		line: 1
		code: CErrBlockArgListNotClosed.
	"Binary symbol appears before close block temps"
	source := '[:a >]'.
	self
		parseExprError: source
		range: (1 to: 3)
		line: 1
		code: CErrBlockArgListNotClosed.
	"eof occurs before close block temps (or block)"
	source := ' [:a'.
	self
		parseExprError: source
		range: (2 to: source size)
		line: 1
		code: CErrBlockArgListNotClosed.
	source := ' [:a '.
	self
		parseExprError: ' [:a '
		range: (2 to: 4)
		line: 1
		code: CErrBlockArgListNotClosed.
	"Issue #299 - a case tested above, but not in an optimized block"
	source := '1 to: 10 do: [:index 2 | index2]'.
	self
		parseExprError: source
		range: ((source indexOf: $[) to: (source indexOf: $2) - 2)
		line: 1
		code: CErrBlockArgListNotClosed!

testErrorsBraceArrayNotClosed
	| text start |
	text := '| a | {#() .1. a. ''a''. 1.0 .'.
	self
		parseExprError: text
		range: ((text indexOf: ${) to: text size)
		line: 1
		code: CErrBraceNotClosed.
	text := '{#().
		1.
		 {''a''. 1.0. '.
	start := text lastIndexOf: ${.
	self
		parseExprError: text
		range: (start to: text size)
		line: 3
		code: CErrBraceNotClosed!

testErrorsDuplicateArg
	| source start |
	source := '[:arg1 :arg1 | ^arg1]'.
	start := (source lastIndexOf: $:) + 1.
	self
		parseExprError: source
		range: (start to: start + 3)
		line: 1
		code: CErrDuplicateArgName.
	source := 'a: arg1 b: arg2 c: arg1 ^arg1'.
	start := (source lastIndexOf: $:) + 2.
	self
		parseMethodError: source
		code: CErrDuplicateArgName
		range: (start to: start + 3)!

testErrorsDuplicateTemp
	| source start |
	source := '[ | arg1 arg1 | ]'.
	start := source lastIndexOf: $a.
	self
		parseExprError: source
		range: (start to: start + 3)
		line: 1
		code: CErrDuplicateTempName.
	source := 'a | arg1 arg2 arg1 |'.
	start := source lastIndexOf: $a.
	self
		parseMethodError: source
		code: CErrDuplicateTempName
		range: (start to: start + 3)!

testErrorsExpectFnName
	| source |
	source := 'blah <cdecl: void 1.5>'.
	self
		parseMethodError: source
		code: CErrExpectFnName
		range: ((source indexOf: $1) to: (source lastIndexOf: $>) - 1)!

testErrorsExpectMessage
	| source |
	source := 'super 1'.
	self 
		parseExprError: source
		range: (source size to: source size)
		line: 1
		code: CErrExpectMessage!

testErrorsExpectVariableName
	| source mark |
	source := 'blah:'.
	self 
		parseMethodError: source
		code: CErrExpectVariable
		range: (source size + 1 to: source size).
	source := 'blah: 1'.
	self 
		parseMethodError: source
		code: CErrExpectVariable
		range: (source size to: source size).
	source := 'blah: : '.
	mark := source lastIndexOf: $:.
	self 
		parseMethodError: source
		code: CErrExpectVariable
		range: (mark to: mark).
	source := '>>1.0'.
	self 
		parseMethodError: source
		code: CErrExpectVariable
		range: (3 to: source size)!

testErrorsExtArgCountMismatch
	| source mark |
	source := 'blah <cdecl: void blah sdword> ^self invalidCall'.
	mark := source indexOfSubCollection: 'sdword>'.
	self 
		parseMethodError: source
		code: CErrTooManyArgTypes
		range: (mark to: (source lastIndexOf: $>) - 1).
	source := 'blah: x _: y _: z <cdecl: void blah dword lpstr>'.
	mark := source indexOfSubCollection: 'dword'.
	self 
		parseMethodError: source
		code: CErrInsufficientArgTypes
		range: (mark to: (source lastIndexOf: $>) - 1).
	source := 'blah: x <cdecl: void blah>'.
	mark := source indexOf: $>.
	self 
		parseMethodError: source
		code: CErrInsufficientArgTypes
		range: (mark to: (source lastIndexOf: $>) - 1)!

testErrorsExtTypeIndirections
	#(#('blah %<cdecl: <1s> blah%>' 'lppvoid*') #('blah %<cdecl: <1s> blah%>' 'lppvoid**') #('blah %<cdecl: <1s> blah%>' 'lpvoid**') #('blah %<cdecl: sdword blah <1s>%>' 'LPVOID**') #('blah %<cdecl: sdword blah UInt32** Address* <1s>%>' 'Address**') #('blah %<cdecl: sdword blah BSTR* <1s>%>' 'BSTR**') #('blah: a _: b _: c _d: d %<cdecl: sdword blah GUID** REFGUID* GUID* <1s>%>' 'REFGUID**'))
		do: 
			[:each |
			| mark source |
			source := each first expandMacrosWith: each second.
			mark := source indexOfSubCollection: each second.
			self
				parseMethodError: source
				code: CErrNotIndirectable
				range: (mark to: mark + each second size - 1)].
	#(#('blah %<cdecl: dword<1s> blah%>' '***') #('blah %<cdecl: UInt32<1s> blah%>' '***')) do: 
			[:each |
			| mark source |
			source := each first expandMacrosWith: each second.
			mark := source indexOfSubCollection: each second.
			self
				parseMethodError: source
				code: CErrBadExtTypeQualifier
				range: (mark to: mark + each second size - 1)]!

testErrorsExtTypes
	"External types can be any of a number of built in type names, such as 'dword', or the name of an External.Structure class."

	| source mark |
	"identifier, but unrecognised so looks up as a class name"
	source := 'blah <cdecl: voide blah>'.
	mark := source indexOf: $v.
	self
		parseMethodError: source
		code: CErrUndeclared
		range: (mark to: mark + 4).
	"Non-global (mispelling)"
	source := 'blah <cdecl: Uint32 blah>'.
	mark := source indexOf: $U.
	self
		parseMethodError: source
		code: CErrUndeclared
		range: (mark to: mark + 5).
	"Fixed pointer class with zero inst. vars (must be at least one)"
	source := 'blah <cdecl: Object blah>'.
	mark := source indexOf: $O.
	self
		parseMethodError: source
		code: CErrInvalidStructArg
		range: (mark to: mark + 5).
	"Indexable pointer class with zero inst. vars (must be at least one)"
	source := 'blah: x _: y <cdecl: void blah ByteArray Array>'.
	mark := source lastIndexOf: $A.
	self
		parseMethodError: source
		code: CErrInvalidStructArg
		range: (mark to: mark + 4).
	"Non-class global"
	source := 'blah: x _: y <cdecl: void blah Transcript sdword>'.
	mark := source lastIndexOf: $T.
	self
		parseMethodError: source
		code: CErrInvalidStructArg
		range: (mark to: mark + #Transcript size - 1).

	"Not an identifier"
	source := 'blah <cdecl: 12 blah>'.
	mark := source indexOf: $1.
	self
		parseMethodError: source
		code: CErrExpectExtType
		range: (mark to: mark + 1).
	source := 'blah: x <cdecl: sdword blah void>'.
	mark := source lastIndexOf: $v.
	self
		parseMethodError: source
		code: CErrArgTypeCannotBeVoid
		range: (mark to: mark + 3).
	source := 'blah: x <cdecl: & blah dword>'.
	mark := source lastIndexOf: $&.
	self
		parseMethodError: source
		code: CErrExpectExtType
		range: (mark to: mark).
	source := 'blah: x _: y <cdecl: UInt32 func * handle>'.
	mark := source indexOf: $*.
	self
		parseMethodError: source
		code: CErrExpectExtType
		range: (mark to: mark).
	source := 'blah: x _: y <cdecl: UInt32 func 1 handle>'.
	mark := source indexOf: $1.
	self
		parseMethodError: source
		code: CErrExpectExtType
		range: (mark to: mark).

	"parser will only read binary selectors of up to two characters, and therefore '***' is treated as two tokens"
	source := 'blah: x _: y <cdecl: UInt32 blah dword*** handle>'.
	mark := source indexOf: $*.
	self
		parseMethodError: source
		code: CErrBadExtTypeQualifier
		range: (mark to: mark + 2).
	source := 'blah: x _: y <cdecl: UInt32& blah dword* handle>'.
	mark := source indexOf: $&.
	self
		parseMethodError: source
		code: CErrBadExtTypeQualifier
		range: (mark to: mark).
	source := 'blah: x _: y <cdecl: UInt32 blah dword& handle>'.
	mark := source indexOf: $&.
	self
		parseMethodError: source
		code: CErrBadExtTypeQualifier
		range: (mark to: mark)!

testErrorsIfNotNil
	"Test zero arg form now accepted by D6 compiler"

	| source |
	source := '1 ifNotNil: [:x :y |]'.
	self 
		parseExprError: source
		range: ((source indexOf: $[) to: (source indexOf: $|))
		line: 1
		code: CErrTooManyIfNotNilBlockArgs!

testErrorsIllegalByteArrays
	#(#('#[1 1234 4]' 5 8) #('#[1 1.0]' 5 7) #('#[1 a]' 5 5) #('#[1 10000000000 2]' 5 15) #('#[0 -1 1]' 5 6) #('#[0 1 256 255]' 7 9))
		do: 
			[:each |
			self
				parseExprError: each first
				range: (each second to: each third)
				line: 1
				code: CErrBadValueInByteArray].
	self
		parseExprError: '#[1 2'
		range: (1 to: 5)
		line: 1
		code: CErrByteArrayNotClosed!

testErrorsIncorrectNumberOfNotNilBlockArgs
	| source |
	source := '1 ifNotNil: [:x :y | x + y]'.
	self 
		parseExprError: source
		range: ((source indexOf: $[) to: (source indexOf: $|))
		line: 1
		code: CErrTooManyIfNotNilBlockArgs.
	source := '1 ifNil: [2] ifNotNil: [:x :y | x + y]'.
	self 
		parseExprError: source
		range: ((source lastIndexOf: $[) to: (source indexOf: $|))
		line: 1
		code: CErrTooManyIfNotNilBlockArgs.
	source := '1 ifNotNil: [:x :y | x + y] ifNil: [2]'.
	self 
		parseExprError: source
		range: ((source indexOf: $[) to: (source indexOf: $|))
		line: 1
		code: CErrTooManyIfNotNilBlockArgs!

testErrorsInvalidExpressionStart
	| source |
	source := ' := '.
	self 
		parseExprError: source
		range: (2 to: 3)
		line: 1
		code: CErrInvalExprStart.
	source := '1 - - 1'.
	self 
		parseExprError: source
		range: (5 to: 5)
		line: 1
		code: CErrInvalExprStart!

testErrorsLexicalBadChar
	"Non-ascii letters"

	{$\x80. Character dolphin} , ((Character byteCharacterSet select: [:each | each isLetter])
				difference: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')
		do: 
			[:each |
			self
				lexicalError: '#(' , each asString
				range: (3 to: 3)
				line: 1
				code: LErrBadChar].
	self
		lexicalError: (Character dolphin asUtf8String
				basicAt: 4 put: 16rC0;
				yourself)
		range: (1 to: 1)
		line: 1
		code: LErrBadChar!

testErrorsLexicalBadCodePoint
	#('$\x110000' '$\xFFFFFFFF') do: 
			[:each |
			| delimited end |
			end := each size.
			self
				parseExprError: each
				range: (1 to: end)
				line: 1
				code: LErrBadCodePoint.
			delimited := String lineDelimiter , each , String lineDelimiter.
			end := end + String lineDelimiter size.
			self
				parseExprError: delimited
				range: (String lineDelimiter size + 1 to: end)
				line: 2
				code: LErrBadCodePoint]!

testErrorsLexicalCommentNotClosed
	self
		lexicalError: '"blah blah ...'
		range: (1 to: 14)
		line: 1
		code: LErrCommentNotClosed!

testErrorsLexicalExpectChar
	"Incomplete literal character at end of file."

	self
		parseExprError: '$'
		range: (1 to: 1)
		line: 1
		code: LErrExpectChar.
	self
		parseExprError: String lineDelimiter , '$'
		range: (3 to: 3)
		line: 2
		code: LErrExpectChar!

testErrorsLexicalExpectCodePoint
	#('$\x' '$\x ' '$\xG') do: 
			[:each |
			| delimited end |
			end := each size.
			self
				parseExprError: each
				range: (1 to: end)
				line: 1
				code: LErrExpectCodePoint.
			delimited := String lineDelimiter , each.
			end := delimited size.
			"eof in the middle of the token is a special test case"
			each last = $x ifFalse: [delimited := delimited , String lineDelimiter].
			self
				parseExprError: delimited
				range: (String lineDelimiter size + 1 to: end)
				line: 2
				code: LErrExpectCodePoint]!

testErrorsLexicalExpectConst
	"Invalid symbol"

	self
		lexicalError: '1 + #23'
		range: (5 to: 6)
		line: 1
		code: LErrExpectConst!

testErrorsLexicalIncompleteLiteralCharacter
	| source |
	source := '$' , Character dolphin asUtf8String.
	2 to: 4
		do: 
			[:i |
			self
				parseExprError: (source copyFrom: 1 to: i)
				range: (1 to: i)
				line: 1
				code: LErrBadCodePoint]!

testErrorsLexicalStringNotClosed
	self
		lexicalError: '''blah blah ...'
		range: (1 to: 14)
		line: 1
		code: LErrStringNotClosed!

testErrorsLiteralArray
	| text start mark |
	text := '#('.
	self 
		parseExprError: text
		range: (1 to: text size)
		line: 1
		code: CErrArrayNotClosed.
	text := '#(:='.
	mark := text indexOf: $:.
	self 
		parseExprError: text
		range: (mark to: mark + 1)
		line: 1
		code: CErrBadTokenInArray.
	text := '
		"Newline in ...
		... comment" #(() 1 a ''a'' 1.0 :)'.
	mark := text indexOf: $:.
	self 
		parseExprError: text
		range: (mark to: mark)
		line: 3
		code: CErrBadTokenInArray.
	self 
		parseExprError: '#(() 1 a ''a'' 1.0 &'
		range: (1 to: 18)
		line: 1
		code: CErrArrayNotClosed.
	"Deliberately have a couple of newlines in the array to check line counting works when newlines appear in literal arrays"
	text := '#(() -
		1
		 (a ''a'' 1.0 &'.
	start := text lastIndexOf: $(.
	self 
		parseExprError: text
		range: (start to: text size)
		line: 3
		code: CErrArrayNotClosed!

testErrorsLiteralByteArray
	self 
		parseExprError: '#[1 1234 4]'
		range: (5 to: 8)
		line: 1
		code: CErrBadValueInByteArray.
	self 
		parseExprError: '#[1 1.0]'
		range: (5 to: 7)
		line: 1
		code: CErrBadValueInByteArray.
	self 
		parseExprError: '#[1 a]'
		range: (5 to: 5)
		line: 1
		code: CErrBadValueInByteArray.
	#(' #[ ' ' #[1 2 ' ' #[1 ') do: 
			[:each | 
			self 
				parseExprError: each
				range: ((each indexOf: $#) to: each size - 1)
				line: 1
				code: CErrByteArrayNotClosed]!

testErrorsMutableAnnotationNotClosed
	| source mark |
	source := 'blah: a 
	<mutable
	x:=a'.
	mark := source indexOf: $x.
	self
		parseMethodError: source
		code: CErrExpectCloseTag
		range: (mark to: mark)!

testErrorsNegateNonNumber
	| source mark |
	source := '1 + -a'.
	mark := source lastIndexOf: $-.
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrInvalExprStart.
	source := '1 + -:='.
	mark := source lastIndexOf: $-.
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrInvalExprStart!

testErrorsNonsenseAtEndOfExpression
	^self subclassResponsibility!

testErrorsNonsenseAtEndOfMethod
	^self subclassResponsibility!

testErrorsOptimizedExpressionNotClosed
	"Not terminated at eof"

	| source |
	source := ' ##(1 + 2'.
	self 
		parseExprError: source
		range: (2 to: source size)
		line: 1
		code: CErrStaticExprNotClosed!

testErrorsPrimitiveBadIndex
	| source mark |
	source := 'blah <primitive: 256>'.
	mark := source lastIndexOf: $2.
	self
		parseMethodError: source
		code: CErrBadPrimIdx
		range: (mark to: mark + 2).
	source := 'blah <primitive: ' , (VMConstants.MaxPrimitive + 1) displayString , '>'.
	mark := source lastIndexOf: $:.
	self
		parseMethodError: source
		code: CErrBadPrimIdx
		range: (mark + 2 to: mark + 4)!

testErrorsPrimitiveExpectIndex
	| source mark |
	source := 'blah <primitive: a>'.
	mark := source lastIndexOf: $a.
	self
		parseMethodError: source
		code: CErrExpectPrimIdx
		range: (mark to: mark).
	source := 'blah <primitive:>'.
	mark := source lastIndexOf: $>.
	self
		parseMethodError: source
		code: CErrExpectPrimIdx
		range: (mark to: mark).
	source := 'blah <primitive: 1.0>'.
	mark := source lastIndexOf: $1.
	self
		parseMethodError: source
		code: CErrExpectPrimIdx
		range: (mark to: mark + 2)!

testErrorsPrimitiveTagNotClosed
	| source mark |
	source := 'blah <primitive: 1'.
	self
		parseMethodError: source
		code: CErrExpectCloseTag
		range: (source size + 1 to: source size).
	source := ' blah <primitive: 1<'.
	mark := source lastIndexOf: $<.
	self
		parseMethodError: source
		code: CErrExpectCloseTag
		range: (mark to: mark).
	source := 'blah <primitive: 1 a'.
	mark := source lastIndexOf: $a.
	self
		parseMethodError: source
		code: CErrExpectCloseTag
		range: (mark to: mark).
	source := 'blah <stdcall: void a '.
	mark := source lastIndexOf: $a.
	self
		parseMethodError: source
		code: CErrExpectCloseTag
		range: (source size + 1 to: source size)!

testErrorsQualifiedReferenceBadExtension
	| source |
	source := ' #{A.B.C class2}'.
	^self
		parseExprError: source
		range: ((source indexOf: $c) to: (source indexOf: $2))
		line: 1
		code: CErrBadQualifiedRefModifier!

testErrorsQualifiedReferenceExtraDot
	| source extraDotAt |
	source := ' #{A.B.}'.
	extraDotAt := source lastIndexOf: $..
	^self
		parseExprError: source
		range: (extraDotAt to: extraDotAt)
		line: 1
		code: CErrBadQualifiedRefModifier!

testErrorsQualifiedReferenceInvalidName
	| source result |
	source := ' #{ nil  '.
	result := self
				parseExprError: source
				range: ((source indexOf: $n) to: (source indexOf: $l))
				line: 1
				code: CErrExpectVariable.
	self
		checkCompileError: errors last
		range: (source size to: source size)
		code: CErrQualifiedRefNotClosed
		line: 1
		source: source.
	^result!

testErrorsQualifiedReferenceMetaNotClosed
	| source |
	source := ' #{A.B.C class name'.
	^self
		parseExprError: source
		range: ((source indexOf: $#) to: (source lastIndexOf: $s))
		line: 1
		code: CErrQualifiedRefNotClosed!

testErrorsQualifiedReferenceNotClosed
	| source |
	source := ' #{A.B.C .'.
	^self
		parseExprError: source
		range: ((source indexOf: $#) to: (source indexOf: $C))
		line: 1
		code: CErrQualifiedRefNotClosed!

testErrorsQualifierReferenceEmpty
	| source |
	source := ' #{} '.
	^self
		parseExprError: source
		range: ((source indexOf: $}) to: (source indexOf: $}))
		line: 1
		code: CErrExpectVariable!

testErrorsRedefiningPseudo
	#('self' 'super' 'thisContext') do: 
			[:each |
			| source |
			source := '|<1s> | ' expandMacrosWith: each.
			self
				parseExprError: source
				range: (2 to: 2 + each size - 1)
				line: 1
				code: CErrRedefiningPseudoVar.
			"#2201."
			#('[:<1s> | ]' '1 ifNotNil: [:<1s> | ]' '1 to: 2 do: [:<1s> |]' '1 to: 2 by: 1 do: [:<1s> |]') do: 
					[:eachExpr |
					| start |
					source := eachExpr expandMacrosWith: each.
					start := source lastIndexOf: $:.
					self
						parseExprError: source
						range: (start + 1 to: start + each size)
						line: 1
						code: CErrRedefiningPseudoVar]]!

testErrorsRedefiningSpecialLiterals
	#('nil' 'true' 'false') do: 
			[:each |
			| source |
			source := '|<1s> | ' expandMacrosWith: each.
			self
				parseExprError: source
				range: (1 to: 1)
				line: 1
				code: CErrTempListNotClosed.
			"#2201."
			#('[:<1s> | ]' '1 ifNotNil: [:<1s> | ]' '1 to: 2 do: [:<1s> |]' '1 to: 2 by: 1 do: [:<1s> |]') do: 
					[:eachExpr |
					| start |
					source := eachExpr expandMacrosWith: each.
					start := source lastIndexOf: $:.
					self
						parseExprError: source
						range: (start + 1 to: start + each size)
						line: 1
						code: CErrExpectVariable]]!

testErrorsStringNotClosed
	#(#(' ''' 2 2) #('''' 1 1) #('''a' 1 2) #(' ''a' 2 3) #(' ''blah blah ...' 2 15)) do: 
			[:each | 
			self 
				lexicalError: each first
				range: (each second to: each third)
				line: 1
				code: LErrStringNotClosed]!

testErrorsSupersendFromObject
	"Test that super send in root class is detected as an error"

	| source mark |
	source := 'blah ^super blah'.
	mark := source indexOf: $^.
	{Object. ProtoObject} do: 
			[:each |
			self
				parseMethodError: source
				in: each
				range: (mark + 1 to: mark + 5)
				code: CErrUndeclared	"
				format: 'undeclared ''super'''"]!

testErrorsTempsNotClosed
	| source mark |
	source := 'blah | 1+2 ^3'.
	mark := source indexOf: $|.
	self 
		parseMethodError: source
		code: CErrTempListNotClosed
		range: (mark to: mark + 1).
	source := 'blah |'.
	mark := source indexOf: $|.
	self 
		parseMethodError: source
		code: CErrTempListNotClosed
		range: (mark to: mark).
	source := 'blah | '.
	mark := source indexOf: $|.
	self 
		parseMethodError: source
		code: CErrTempListNotClosed
		range: (mark to: mark + 1).
	source := 'blah | a b'.
	mark := source indexOf: $|.
	self 
		parseMethodError: source
		code: CErrTempListNotClosed
		range: (mark to: source size).
	source := '[:a | | b ]'.
	mark := source lastIndexOf: $|.
	self 
		parseExprError: source
		range: (mark to: source size - 1)
		line: 1
		code: CErrTempListNotClosed.
	source := '[:a | |]'.
	mark := source lastIndexOf: $|.
	self 
		parseExprError: source
		range: (mark to: source size - 1)
		line: 1
		code: CErrTempListNotClosed.
	source := '[:a ||'.
	mark := source lastIndexOf: $|.
	self 
		parseExprError: source
		range: (mark to: source size)
		line: 1
		code: CErrTempListNotClosed.
	source := '[:a ||]'.
	mark := source lastIndexOf: $|.
	self 
		parseExprError: source
		range: (mark to: source size - 1)
		line: 1
		code: CErrTempListNotClosed!

testErrorsTooManyArgs
	"This is testing for too many args in a message send, not in a method signature. That error
	is shared with CErrTooManyTemps, since the space available is shared."

	| source max last |
	source := String writeStream.
	source
		cr;
		nextPutAll: ' self '.
	max := VMConstants.MaxMessageArgs.
	1 to: max + 1
		do: 
			[:i | 
			source
				nextPutAll: 'x: ';
				print: i;
				space].
	source
		nextPut: $.;
		cr;
		nextPutAll: '1+2';
		cr.
	source := source contents.
	last := (max + 1) displayString.
	self 
		parseExprError: source
		range: ((source indexOfSubCollection: 'self') 
				to: (source indexOfSubCollection: last) + last size - 1)
		line: 2
		code: CErrTooManyArgs!

testErrorsTooManyTemps
	| source mark |
	source := String writeStream.
	source nextPutAll: '| '.
	1 to: VMConstants.MaxTemps + 1
		do: 
			[:i |
			source
				nextPut: $x;
				print: i;
				space].
	source nextPut: $|.
	source nextPutAll: ' [ | t1 | [t1] repeat]'.
	source := source contents.
	mark := source lastIndexOf: $x.
	self
		parseExprError: source
		range: (mark to: mark + 3)
		line: 1
		code: CErrTooManyTemps!

testErrorsTooManyTempsInOptimizedBlock
	| source mark |
	source := String writeStream.
	source nextPutAll: '| '.
	1 to: VMConstants.MaxTemps - 1
		do: 
			[:i | 
			source
				nextPut: $a;
				print: i;
				space].
	source nextPut: $|.
	source
		cr;
		nextPutAll: '1 ifNotNil: [:x | | z | z := x]'.
	source := source contents.
	mark := source indexOf: $z.
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 2
		code: CErrTooManyTemps!

testErrorsUnclosedParenthesis
	| source mark |
	source := '1 + (5*6'.
	mark := source indexOf: $(.
	self 
		parseExprError: source
		range: (mark to: source size)
		line: 1
		code: CErrParenNotClosed.
	source := '1 + (5*6.'.
	mark := source indexOf: $(.
	self 
		parseExprError: source
		range: (mark to: source size - 1)
		line: 1
		code: CErrParenNotClosed.
	source := '(1 + (5*6).'.
	mark := source indexOf: $(.
	self 
		parseExprError: source
		range: (mark to: source size - 1)
		line: 1
		code: CErrParenNotClosed!

testErrorsUnspportedCallConv
	| source mark |
	source := 'blah <fastcall: void blah>'.
	mark := source indexOf: $<.
	self 
		parseMethodError: source
		code: CErrUnsupportedCallConv
		range: (mark + 1 to: mark + 9).
	source := 'blah <overlap thiscall: void blah>'.
	mark := source indexOf: $t.
	self 
		parseMethodError: source
		code: CErrUnsupportedCallConv
		range: (mark to: mark + 8)!

testErrorsUnterminatedStatement
	"Unterminated statement"

	self 
		parseMethodError: 'blah 1+2 ^3'
		code: CErrUnterminatedStatement
		range: (6 to: 8)!

testErrorsVirtualCalls
	| source mark idx |
	source := 'blah <virtual cdecl: void blah>'.
	mark := source lastIndexOf: $b.
	self
		parseMethodError: source
		code: CErrExpectVfn
		range: (mark to: mark + 3).
	source := 'blah <virtual cdecl: void -1>'.
	mark := source lastIndexOf: $-.
	self
		parseMethodError: source
		code: CErrBadVfn
		range: (mark to: mark + 1).
	source := 'blah <virtual cdecl: void 0>'.
	mark := source lastIndexOf: $0.
	self
		parseMethodError: source
		code: CErrBadVfn
		range: (mark to: mark).
	idx := (VMConstants.MaxVirtualFunction + 1) displayString.
	source := 'blah <virtual cdecl: void ' , idx , '>'.
	mark := source lastIndexOf: $\x20.
	self
		parseMethodError: source
		code: CErrBadVfn
		range: (mark + 1 to: mark + idx size)!

testErrorsZeroArgOptimisedBlock
	"Test expects zero args."

	#('1 ifNil: [:x |]' 'true ifTrue: [:x |]' 'false ifFalse: [:x |]') do: 
			[:source |
			self
				parseExprError: source
				range: ((source indexOf: $[) to: (source indexOf: $|))
				line: 1
				code: CErrIncorrectBlockArgCount]!

testOverriddenBlockArgumentError
	| source |
	source := '[:a | | a | a := 2. [a]'.
	self 
		parseExprError: source
		range: (9 to: 9)
		line: 1
		code: CErrRedefiningArg!

testOverriddenBlockArgumentWarning
	| method block block3 block2 |
	method := self getTestMethod: #testOverriddenBlockArgumentWarning.
	self assert: method tempCount equals: 0.
	self deny: method needsContext.
	block := method value: DolphinCompilerTestMethods new withArguments: #().
	block2 := block value: 1.
	self assert: block2 tempCount equals: 1.
	self assert: block2 argumentCount equals: 0.
	self assert: block2 stackTempCount equals: 1.
	block3 := block2 value.
	self assert: block3 tempCount equals: 1.
	self assert: block3 argumentCount equals: 0.
	self assert: block3 size equals: 1.
	self assert: (block3 at: 1) equals: 2.
	self assert: block3 value equals: 2!

testOverriddenMethodArgumentError
	| source start |
	source := 'x: a 
	| a array |
	a := 2.
	array := Array with: a with: nil.
	^a = 2 
		ifTrue: 
			[| a |
			a := 3.
			[a]]'.
	start := source indexOfSubCollection: '| a'.
	self 
		parseMethodError: source
		code: CErrRedefiningArg
		range: (start + 2 to: start + 2)!

testOverriddenMethodArgumentWarning
	| block2 method block1 |
	method := self getTestMethod: #testOverriddenMethodArgumentWarning:.
	self assert: method tempCount equals: 1.
	self deny: method needsContext.
	block1 := method value: DolphinCompilerTestMethods new withArguments: #(1).
	block2 := block1 value.
	self assert: block2 tempCount equals: 1.
	self assert: block2 argumentCount equals: 0.
	self assert: block2 size equals: 1.
	self assert: (block2 at: 1) equals: 2.
	self assert: block2 value equals: 2!

testRestrictedSelectors
	self restrictedSelectors do: 
			[:each |
			| source argc |
			source := String writeStream.
			argc := each argumentCount.
			argc = 0
				ifTrue: [source nextPutAll: each]
				ifFalse: 
					[each isInfix
						ifTrue: 
							[self assert: argc equals: 1.
							source
								nextPutAll: each;
								space;
								nextPutAll: 'operand']
						ifFalse: 
							[| i |
							i := 1.
							each keywords do: 
									[:eachKeyword |
									source
										nextPutAll: eachKeyword;
										nextPutAll: ' operand';
										display: i]
								separatedBy: 
									[source space.
									i := i + 1]]].
			source
				crtab;
				nextPutAll: '^1 + 2'.
			source := source contents.
			self
				parseMethodWarning: source
				in: self class
				range: (1 to: (source indexOf: Character cr) - 1)
				code: CWarnRestrictedSelector
				extra: each]!

testUnoptimizedLoopsNonMonadicArg
	"An error is actually generated in the case where the block arg of a #to:[by:]do: is not
	monadic, because this is simpler given the compiler's single-pass design. If the code
	generation were a separate pass, then it could produce unoptimized code and a warning."

	#('1 to: 2' '1 to: 2 by: 1') do: 
			[:each |
			| source mark |
			"Non-block literal - in this case a SmallInteger"
			source := 'x <1s> do: [1]' expandMacrosWith: each.
			mark := source indexOf: $[.
			self
				parseMethodError: source
				code: CErrIncorrectBlockArgCount
				range: (mark to: mark + 2).
			source := 'x | tmp | tmp := [:e | e]. <1s> do: tmp ' expandMacrosWith: each.
			self
				parseMethodWarning: source
				range: (source size - 3 to: source size - 1)
				code: CWarnExpectMonadicBlockArg.

			"Too many args"
			source := 'x <1s> do: [:x :y | x + y]' expandMacrosWith: each.
			self
				parseMethodError: source
				code: CErrIncorrectBlockArgCount
				range: ((source indexOf: $[) to: (source indexOf: $|)).
			self]!

testWarningMutableIgnored
	#(#testWarningMutableIgnored) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: [:source | 1 to: source size]
				code: CWarnMutableIgnored]!

testWarningReadBeforeWritten
	#(#testWarningReadBeforeWrittenMethodTemp #testWarningReadBeforeWrittenBlockTemp #testWarningReadBeforeWrittenFullBlock)
		do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: [:source | (source indexOf: $@) + 2 to: (source lastIndexOf: $@) - 2]
				code: CWarnReadBeforeWritten].
	^self!

testWarningReadNotWritten
	#(#testWarningReadNotWrittenMethodTemp #testWarningReadNotWrittenBlockTemp #testWarningReadNotWrittenOptimizedBlockTemp)
		do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: [:source | self tempWarningRangeIn: source]
				code: CWarnReadNotWritten].
	^self!

testWarningRedefiningArg
	#(#testWarningRedefiningArgInOptimizedBlock: #testWarningRedefiningMethodArgInBlock: #testWarningRedefiningBlockArgInBlock) 
		do: 
			[:each | 
			self 
				parseMethodWarning: each
				rangeBlock: 
					[:source | 
					| start |
					start := (source findString: '| a |') + 2.
					start to: start]
				code: CWarnRedefiningArg]!

testWarningRedefiningInstVar
	#(#testWarningRedefiningInstVarAsArg: #testWarningRedefiningInstVarAsTemp #testWarningRedefiningInstVarAsOptimizedBlockArg #testWarningRedefiningInstVarAsOptimizedBlockTemp #testWarningRedefiningInstVarAsBlockTemp #testWarningRedefiningInstVarAsBlockArg) 
		do: 
			[:each | 
			self 
				parseMethodWarning: each
				rangeBlock: 
					[:source | 
					| start |
					start := source findString: 'iv1'.
					start to: start + 2]
				code: CWarnRedefiningInstVar].
	^self!

testWarningRedefiningStatic
	#(#testWarningRedefiningStaticAsArg: #testWarningRedefiningStaticAsTemp #testWarningRedefiningStaticAsBlockArg #testWarningRedefiningStaticAsBlockTemp) 
		do: 
			[:each | 
			self 
				parseMethodWarning: each
				rangeBlock: 
					[:source | 
					| start |
					start := source findString: 'Object'.
					start to: start + 5]
				code: CWarnRedefiningStatic]!

testWarningRedefiningTemp
	| source start range |
	source := 'x | a | a := 1. [|a | a := 2. a] value. a'.
	start := (source findString: '|a') + 1.
	range := start to: start.
	self 
		parseMethodWarning: source
		in: self class
		range: range
		code: CWarnRedefiningTemp!

testWarningSelfSendNotImplemented
	| source range |
	source := 'x ^self blah'.
	range := (source findString: 'self') to: source size.
	self
		parseMethodWarning: source
		in: self class
		range: range
		code: CWarnMsgUnimplemented.
	self
		parseMethodWarning: source
		in: self class class
		range: range
		code: CWarnMsgUnimplemented.

	"Now compile some sends which are implemented"

	"Self referential - shouldn't get a warning"
	self shouldnt: [self parseMethod: 'blah ^self blah' in: self class]
		raise: self compilationWarningClass.

	"Pre-existing method that we know will exist"
	self shouldnt: [self parseMethod: 'x ^self isAbstract' in: self class class]
		raise: self compilationWarningClass!

testWarningSupersendNotImplemented
	| source range |
	source := 'blah ^super blah'.
	range := (source findString: 'super') to: source size.
	self
		parseMethodWarning: source
		in: self class
		range: range
		code: CWarnMsgUnimplemented.
	self
		parseMethodWarning: source
		in: self class class
		range: range
		code: CWarnMsgUnimplemented.
	"Now compile some supersends which are implemented"
	self shouldnt: 
			[self parseMethod: 'run ^super run' in: self class]
		raise: self compilationWarningClass.
	self shouldnt: 
			[self parseMethod: 'isAbstract ^super isAbstract' in: self class class]
		raise: self compilationWarningClass.
	"Finally a class side supersend that is a send to the instance side"
	self shouldnt: 
			[self parseMethod: 'class ^super class' in: self class class]
		raise: self compilationWarningClass!

testWarningUnoptimizedConditionNonEmptyBlock
	| source |
	#(#and: #or:) do: 
			[:each |
			| format |
			"Non-block literal - in this case a SmallInteger"
			format := 'x true <1s> [ ] '.
			source := format expandMacrosWith: each.
			self
				parseMethodError: source
				code: CErrEmptyConditionBlock
				range: ((source lastIndexOf: $[) to: (source lastIndexOf: $]))]!

testWarningUnoptimizedConditionNonNiladicArg
	| source |
	#(#and: #or: #ifTrue: #ifFalse: #ifNil:) do: 
			[:each |
			| stem format |
			"Non-block literal - in this case a SmallInteger"
			stem := 'x [1] '.
			format := stem , '<1s> 1 '.
			source := format expandMacrosWith: each.
			self
				parseMethodWarning: source
				range: (source size - 1 to: source size - 1)
				code: CWarnExpectNiladicBlockArg.
			"Variable ref"
			stem := 'x | a | a := [false]. [1] '.
			format := stem , '<1s> a'.
			source := format expandMacrosWith: each.
			self
				parseMethodWarning: source
				range: (source size to: source size)
				code: CWarnExpectNiladicBlockArg.

			"Because of the single-pass way in which the compiler works, this is currently an error. 
			It could more easily be made a warning if the code generation phase was separate."
			stem := 'x [1] '.
			format := stem , '<1s> [:a|]'.
			source := format expandMacrosWith: each.
			self
				parseMethodError: source
				code: CErrIncorrectBlockArgCount
				range: ((source lastIndexOf: $[) to: (source lastIndexOf: $|)).
			self]!

testWarningUnoptimizedIfNil
	#('x 1 ifNil: 1' 'x | a | a := []. 1 ifNil: a' 'x 1 ifNil: 1 ifNotNil: []' 'x | a | a := [:x|]. 1 ifNil: a ifNotNil: []') 
		do: 
			[:each | 
			| start keyword end |
			keyword := 'ifNil:'.
			start := (each findString: keyword) + keyword size + 1.
			end := (each 
						nextIndexOf: Character space
						from: start
						to: each size) - 1.
			end <= 0 ifTrue: [end := each size].
			self 
				parseMethodWarning: each
				range: (start to: end)
				code: CWarnExpectNiladicBlockArg].
	"These cases should really be warnings, but generate errors because it is too difficult in a
	single pass compiler to detect the unoptimised case in advance when it is the second arg
	that is not a literal block."
	#('x 1 ifNotNil: [] ifNil: 1' 'x | a | a := [:x|]. 1 ifNotNil: [] ifNil: a' 'x 1 ifNil: [] ifNotNil: 1' 'x | a | a := []. 1 ifNil: [] ifNotNil: a') 
		do: 
			[:each | 
			| start end |
			start := (each lastIndexOf: $:) + 2.
			end := (each 
						nextIndexOf: Character space
						from: start
						to: each size) - 1.
			end <= 0 ifTrue: [end := each size].
			self 
				parseMethodError: each
				code: CErrExpectLiteralBlock
				range: (start to: end).
			self]!

testWarningUnoptimizedIfNotNilNonMonadicArg
	| start keyword end |
	#('x 1 ifNotNil: 1' 'x | a | a := [:x|]. 1 ifNotNil: a' 'x 1 ifNotNil: 1 ifNil: []' 'x | a | a := [:x|]. 1 ifNotNil: a ifNil: []') 
		do: 
			[:each | 
			keyword := 'ifNotNil:'.
			start := (each findString: keyword) + keyword size + 1.
			end := (each 
						nextIndexOf: Character space
						from: start
						to: each size) - 1.
			end <= 0 ifTrue: [end := each size].
			self 
				parseMethodWarning: each
				range: (start to: end)
				code: CWarnExpectMonadicOrNiladicBlockArg].
	"These cases should really be warnings, but generate errors because it is too difficult in a
	single pass compiler to detect the unoptimised case in advance when it is the second arg
	that is not a literal block."
	#('x 1 ifNil: [] ifNotNil: 1' 'x | a | a := [:x|]. 1 ifNil: [] ifNotNil: a' 'x 1 ifNotNil: [] ifNil: 1' 'x | a | a := []. 1 ifNotNil: [] ifNil: a') 
		do: 
			[:each | 
			| mark |
			mark := (each lastIndexOf: $:) + 2.
			self 
				parseMethodError: each
				code: CErrExpectLiteralBlock
				range: (mark to: mark).
			self]!

testWarningUnoptimizedLoopsNonNiladicArg
	| source |
	#(#whileTrue: #whileFalse:) do: 
			[:each |
			| stem format |
			"Non-block literal - in this case a SmallInteger"
			stem := 'x [1] '.
			format := stem , '<1s> 1 '.
			source := format expandMacrosWith: each.
			self
				parseMethodWarning: source
				range: (source size - 1 to: source size - 1)
				code: CWarnExpectNiladicBlockArg.
			"Variable ref"
			stem := 'x | a | a := [false]. [1] '.
			format := stem , '<1s> a'.
			source := format expandMacrosWith: each.
			self
				parseMethodWarning: source
				range: (source size to: source size)
				code: CWarnExpectNiladicBlockArg.

			"Because of the single-pass way in which the compiler works, this is currently an error. 
			It could more easily be made a warning if the code generation phase was separate."
			format := stem , '<1s> [:a|]'.
			source := format expandMacrosWith: each.
			self
				parseMethodError: source
				code: CErrIncorrectBlockArgCount
				range: ((source lastIndexOf: $[) to: (source lastIndexOf: $|)).
			self]!

testWarningUnoptimizedLoopsNonNiladicReceiver
	| source |
	#('whileTrue' 'whileFalse' 'repeat' 'whileTrue: []' 'whileFalse: []') do: 
			[:each |
			| stem |
			stem := 'x self '.
			source := stem , each.
			self
				parseMethodWarning: source
				in: BlockClosure
				range: (3 to: stem size - 1)
				code: CWarnExpectNiladicBlockReceiver.
			"Variable as receiver - the expression is valid, but can't be optimized"
			stem := 'x | a | a := [true]. a '.
			source := stem , each.
			self
				parseMethodWarning: source
				in: Object
				range: (stem size - 1 to: stem size - 1)
				code: CWarnExpectNiladicBlockReceiver.
			"Monadic literal block instead of niladic"
			stem := 'x [:a | a] '.
			source := stem , each.
			self
				parseMethodWarning: source
				in: Object
				range: (3 to: stem size - 1)
				code: CWarnExpectNiladicBlockReceiver.
			"Empty block cannot be used for loop condition"
			each = 'repeat'
				ifFalse: 
					[stem := 'x [ | a | ] '.
					source := stem , each.
					self
						parseMethodError: source
						in: Object
						range: (3 to: stem size - 1)
						code: CErrEmptyConditionBlock]]!

testWarningUnreferencedTemp
	#(#testWarningUnreferencedTempBlock #testWarningUnreferencedTempMethod #testWarningUnreferencedTempOptimizedBlock #testWarningUnreferencedTempBraceArray)
		do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| start |
					start := source lastIndexOf: $a.
					start to: start]
				code: CWarnUnreferencedTemp]!

testWarningWrittenNotRead
	#(#testWarningWrittenNotReadMethodTemp #testWarningWrittenNotReadBlockTemp #testWarningWrittenNotReadFullBlock #testWarningWrittenNotReadBraceArray)
		do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: [:source | self writtenNotReadRange: source]
				code: CWarnWrittenNotRead]!

traceException: ex source: aString
	Transcript
		print: self;
		nextPutAll: ': code ';
		print: ex errorCode;
		nextPutAll: ', range ';
		print: ex range;
		space;
		display: ex description;
		nextPutAll: ': ';
		print: (aString copyFrom: ex range start to: ex range stop);
		cr!

writtenNotReadRange: aString
	"The Dolphin compiler and the SmalltalkParser report written-not-read differently; the
	compiler on the temp decl, the parser on the first dead store."

	^self subclassResponsibility! !
!Kernel.Tests.AbstractParserErrorTest categoriesForMethods!
buildNestedBlocks:!helpers!private! !
checkCompileError:range:code:line:source:!helpers!private! !
compilationErrorClass!constants!private! !
compilationWarningClass!constants!private! !
compileMethod:in:!helpers!private! !
errorFormats!constants!private! !
evaluateExpression:!helpers!private! !
getTestMethod:!helpers!private! !
lexicalError:range:line:code:!helpers!private! !
maxLiterals!constants!private! !
parseError:!helpers!private! !
parseExprError:in:range:line:code:!helpers!private! !
parseExprError:range:line:code:!helpers!private! !
parseExpression:!helpers!private! !
parseExpression:in:!parsing!private! !
parseMethod:in:!helpers!private! !
parseMethod:notificationClass:in:range:code:!helpers!private! !
parseMethodError:code:range:!helpers!private! !
parseMethodError:in:range:code:!helpers!private! !
parseMethodInfo:in:range:code:!helpers!private! !
parseMethodInfo:rangeBlock:code:!helpers!private! !
parseMethodWarning:in:range:code:!helpers!private! !
parseMethodWarning:in:range:code:extra:!helpers!private! !
parseMethodWarning:range:code:!helpers!private! !
parseMethodWarning:rangeBlock:code:!helpers!private! !
parserClass!constants!private! !
restrictedSelectors!constants!private! !
tempWarningRangeIn:!helpers!private! !
testByteArraysInLiteralArrays!public!unit tests! !
testCompileTimeExpressions!public!unit tests! !
testErrorsAnnotationBadArg!public!unit tests! !
testErrorsAnnotationBadNamespace!public!unit tests! !
testErrorsAnnotationBadSelector!public! !
testErrorsAnnotationInvalidArg!public!unit tests! !
testErrorsAnnotationInvalidSelector!public! !
testErrorsAnnotationMissingArg!public!unit tests! !
testErrorsArrayNotClosed!public!unit tests! !
testErrorsAssignBlockArgument!public!unit tests! !
testErrorsAssignClass!public!unit tests! !
testErrorsAssignConstant!public!unit tests! !
testErrorsAssignMethodArgument!public!unit tests! !
testErrorsBadCascade!public!unit tests! !
testErrorsBadMessagePattern!public!unit tests! !
testErrorsBadSuper!public!unit tests! !
testErrorsBadTokenInArray!public!unit tests! !
testErrorsBlockArgNameMissing!public!unit tests! !
testErrorsBlockNestingTooDeep!public!unit tests! !
testErrorsBlockNotClosed!public!unit tests! !
testErrorsBlockTempsNotClosed!public!unit tests! !
testErrorsBraceArrayNotClosed!public!unit tests! !
testErrorsDuplicateArg!public!unit tests! !
testErrorsDuplicateTemp!public!unit tests! !
testErrorsExpectFnName!public!unit tests! !
testErrorsExpectMessage!public!unit tests! !
testErrorsExpectVariableName!public!unit tests! !
testErrorsExtArgCountMismatch!public!unit tests! !
testErrorsExtTypeIndirections!public!unit tests! !
testErrorsExtTypes!public!unit tests! !
testErrorsIfNotNil!public!unit tests! !
testErrorsIllegalByteArrays!public!unit tests! !
testErrorsIncorrectNumberOfNotNilBlockArgs!public!unit tests! !
testErrorsInvalidExpressionStart!public!unit tests! !
testErrorsLexicalBadChar!public!unit tests! !
testErrorsLexicalBadCodePoint!public!unit tests! !
testErrorsLexicalCommentNotClosed!public!unit tests! !
testErrorsLexicalExpectChar!public!unit tests! !
testErrorsLexicalExpectCodePoint!public!unit tests! !
testErrorsLexicalExpectConst!public!unit tests! !
testErrorsLexicalIncompleteLiteralCharacter!public!unit tests! !
testErrorsLexicalStringNotClosed!public!unit tests! !
testErrorsLiteralArray!public!unit tests! !
testErrorsLiteralByteArray!public!unit tests! !
testErrorsMutableAnnotationNotClosed!public!unit tests! !
testErrorsNegateNonNumber!public!unit tests! !
testErrorsNonsenseAtEndOfExpression!public!unit tests! !
testErrorsNonsenseAtEndOfMethod!public!unit tests! !
testErrorsOptimizedExpressionNotClosed!public!unit tests! !
testErrorsPrimitiveBadIndex!public!unit tests! !
testErrorsPrimitiveExpectIndex!public!unit tests! !
testErrorsPrimitiveTagNotClosed!public!unit tests! !
testErrorsQualifiedReferenceBadExtension!public!unit tests! !
testErrorsQualifiedReferenceExtraDot!public!unit tests! !
testErrorsQualifiedReferenceInvalidName!public!unit tests! !
testErrorsQualifiedReferenceMetaNotClosed!public!unit tests! !
testErrorsQualifiedReferenceNotClosed!public!unit tests! !
testErrorsQualifierReferenceEmpty!public!unit tests! !
testErrorsRedefiningPseudo!public!unit tests! !
testErrorsRedefiningSpecialLiterals!public!unit tests! !
testErrorsStringNotClosed!public!unit tests! !
testErrorsSupersendFromObject!public!unit tests! !
testErrorsTempsNotClosed!public!unit tests! !
testErrorsTooManyArgs!public!unit tests! !
testErrorsTooManyTemps!public!unit tests! !
testErrorsTooManyTempsInOptimizedBlock!public!unit tests! !
testErrorsUnclosedParenthesis!public!unit tests! !
testErrorsUnspportedCallConv!public!unit tests! !
testErrorsUnterminatedStatement!public!unit tests! !
testErrorsVirtualCalls!public!unit tests! !
testErrorsZeroArgOptimisedBlock!public!unit tests! !
testOverriddenBlockArgumentError!public!unit tests! !
testOverriddenBlockArgumentWarning!public!unit tests! !
testOverriddenMethodArgumentError!public!unit tests! !
testOverriddenMethodArgumentWarning!public!unit tests! !
testRestrictedSelectors!public!unit tests! !
testUnoptimizedLoopsNonMonadicArg!public!unit tests! !
testWarningMutableIgnored!public!unit tests! !
testWarningReadBeforeWritten!public!unit tests! !
testWarningReadNotWritten!public!unit tests! !
testWarningRedefiningArg!public!unit tests! !
testWarningRedefiningInstVar!public!unit tests! !
testWarningRedefiningStatic!public!unit tests! !
testWarningRedefiningTemp!public!unit tests! !
testWarningSelfSendNotImplemented!public!unit tests! !
testWarningSupersendNotImplemented!public!unit tests! !
testWarningUnoptimizedConditionNonEmptyBlock!public!unit tests! !
testWarningUnoptimizedConditionNonNiladicArg!public!unit tests! !
testWarningUnoptimizedIfNil!public!unit tests! !
testWarningUnoptimizedIfNotNilNonMonadicArg!public!unit tests! !
testWarningUnoptimizedLoopsNonNiladicArg!public!unit tests! !
testWarningUnoptimizedLoopsNonNiladicReceiver!public!unit tests! !
testWarningUnreferencedTemp!public!unit tests! !
testWarningWrittenNotRead!public!unit tests! !
traceException:source:!helpers!private! !
writtenNotReadRange:!helpers!private! !
!

