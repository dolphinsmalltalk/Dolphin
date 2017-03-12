"Filed out from Dolphin Smalltalk 7"!

AbstractParserErrorTest subclass: #SmalltalkParserErrorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
SmalltalkParserErrorTest guid: (GUID fromString: '{67c4b011-40fa-43b7-83a4-cd8d616c16d0}')!
SmalltalkParserErrorTest comment: ''!
!SmalltalkParserErrorTest categoriesForClass!Unclassified! !
!SmalltalkParserErrorTest methodsFor!

compilationErrorClass
	^self parserClass errorClass!

compilationWarningClass
	^self parserClass warningClass!

ifNil: aBlock
	^nil!

ifNotNil: notNilBlock ifNil: nilBlock 
	^notNilBlock value: self!

lexicalError: aString range: anInterval line: lineInteger code: anInteger
	self
		lexicalErrorFrom: [SmalltalkScanner on: aString readStream]
		range: anInterval
		line: lineInteger
		code: anInteger!

lexicalErrorFrom: aBlockClosure range: anInterval line: lineInteger code: anInteger
	self
		should: [aBlockClosure value contents]
		raise: SmalltalkParser errorClass
		matching: [:ex | ex errorCode = anInteger and: [ex range = anInterval and: [ex line = lineInteger]]]!

lexicalQualifiedRefError: aString code: anInteger range: anInterval
	| mockEnv |
	mockEnv := Dictionary new.
	mockEnv at: #BindingReference put: Object new.
	self
		lexicalErrorFrom: 
			[(SmalltalkScanner on: aString readStream)
				environment: mockEnv;
				separatorsInLiterals: true;
				yourself]
		range: anInterval
		line: 1
		code: anInteger!

parseExpression: aString in: aClass 
	^StSemanticAnalyser 
		checkParseTree: (SmalltalkParser parseExpression: aString in: aClass)
		for: aClass
		context: nil
		pools: #()!

parseMethod: aString in: aClass 
	^StSemanticAnalyser 
		checkParseTree: (self parserClass parseMethod: aString in: aClass)
		for: aClass
		context: nil
		pools: #()!

parserClass
	^SmalltalkParser!

scannerClass
	^SmalltalkScanner!

testErrorsLexicalBadNumber
	self
		lexicalError: ' 1.0e500 '
		range: (2 to: 8)
		line: 1
		code: LErrBadNumber!

testErrorsLexicalInvalidQualifier
	| source |
	source := ' #{nil} '.
	self
		lexicalQualifiedRefError: source
		code: LErrInvalidQualifier
		range: ((source indexOf: $#) to: (source indexOf: $}))!

testErrorsLexicalUnterminatedQualifier
	| source |
	source := ' #{abc '.
	self
		lexicalQualifiedRefError: source
		code: LErrQualifiedRefNotClosed
		range: ((source indexOf: $#) to: source size)!

testErrorsNonsenseAtEndOfExpression
	| source mark |
	source := ' 1+2]3 '.
	mark := source indexOf: $].
	self 
		parseExprError: source
		range: (mark to: source size)
		line: 1
		code: CErrNonsenseAtExprEnd.
	source := ' ##( 1+2]3 ) '.
	mark := source indexOf: $#.
	self 
		parseExprError: source
		range: (mark to: (source indexOf: $]))
		line: 1
		code: CErrStaticExprNotClosed!

testErrorsNonsenseAtEndOfMethod
	"Nonense at end of method"

	| source mark |
	source := 'blah ^1+2]'.
	self 
		parseMethodError: source
		code: CErrNonsenseAtMethodEnd
		range: (source size to: source size).
	"Nonsense at end of expression"
	source := '1+2]. 3+4'.
	mark := source indexOf: $].
	self 
		parseExprError: source
		range: (mark to: source size)
		line: 1
		code: CErrNonsenseAtExprEnd.
	source := '1+2.] 3+4'.
	mark := source indexOf: $].
	self 
		parseExprError: source
		range: (mark to: source size)
		line: 1
		code: CErrNonsenseAtExprEnd!

testErrorsTempsNotClosedRecovery
	| source ast |
	source := 'blah | 1+2 ^3'.
	ast := [SmalltalkParser parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode = 'blah
	1 + 2.
	^3'.
	source := 'blah | a 1 + 2. a := 3'.
	ast := [SmalltalkParser parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode = 'blah
	| a |
	1 + 2.
	a := 3'.
	source := 'blah |'.
	ast := [SmalltalkParser parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode = 'blah
	'.
	source := 'blah | '.
	ast := [SmalltalkParser parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode = 'blah
	'.
	source := 'blah | a b'.
	ast := [SmalltalkParser parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode = 'blah
	| a b |
	'.
	source := 'blah | a a := 1. ^a'.
	ast := [SmalltalkParser parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode = 'blah
	| a |
	'':=''.
	1.
	^a'.
	self assert: ast argumentNames isEmpty.
	self assert: ast allTemporaryVariables asArray = #('a').
	source := '[:a | | b ]'.
	ast := [SmalltalkParser parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast isBlock.
	self assert: ast argumentNames asArray = #('a').
	self assert: ast allTemporaryVariables asArray = #('b').
	source := '[:a | |]'.
	ast := [SmalltalkParser parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast formattedCode = '[:a | ]'.
	self assert: ast isBlock.
	self assert: ast argumentNames asArray = #('a').
	self assert: ast allTemporaryVariables isEmpty.
	source := '[:a ||'.
	ast := [SmalltalkParser parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast formattedCode = '[:a | ]'.
	self assert: ast isBlock.
	self assert: ast argumentNames asArray = #('a').
	self assert: ast allTemporaryVariables isEmpty.
	source := '[:a ||]'.
	ast := [SmalltalkParser parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast formattedCode = '[:a | ]'.
	self assert: ast isBlock.
	self assert: ast argumentNames asArray = #('a').
	self assert: ast allTemporaryVariables isEmpty!

testInfoHardBreakpoint
	#(#testInfoHardBreakpoint #testInfoHardBreakpointInBlock) do: 
			[:each | 
			self 
				parseMethodInfo: each
				rangeBlock: 
					[:source | 
					| start |
					start := source indexOfSubCollection: 'self halt'.
					start to: start + 8]
				code: CInfoHardBreakpoint]!

testInfoSupersendsOther
	#(#testInfoSupersendsOther) do: 
			[:each | 
			self 
				parseMethodInfo: each
				rangeBlock: 
					[:source | 
					| start |
					start := source indexOfSubCollection: 'super'.
					start 
						to: (source 
								nextIndexOf: Character cr
								from: start
								to: source size) - 1]
				code: CInfoSupersendsOther]!

testInfoUnreferencedArg
	#(#testInfoUnreferencedArgBlock #testInfoUnreferencedArgMethod: #testInfoUnreferencedArgOptimizedBlock) 
		do: 
			[:each | 
			self 
				parseMethodInfo: each
				rangeBlock: 
					[:source | 
					| start |
					start := source lastIndexOf: $a.
					start to: start]
				code: CInfoUnreferencedArg]!

testParserErrors
	#(#('self foo. + 3' 11) #('#(' 3) #('self 0' 6) #('self asdf;;asfd' 11)) 
		do: [:each | self parseError: each]!

testWarningUnreachable
	#(#testWarningUnreachable) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| start |
					start := source indexOf: $1.
					start to: source size]
				code: CWarnUnreachable]!

testWarningUsesBooleanClass
	#(#testWarningUsesTrue #testWarningUsesFalse) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| start name |
					name := each asPhrase subStrings last.
					start := source indexOfSubCollection: name startingAt: each size + 1.
					start to: start + name size - 1]
				code: CWarnUsesBooleanClass]!

testWarnMsgUnimplemented
	#(#testWarnMsgUnimplementedBySelf #testWarnMsgUnimplementedBySuper #testWarnMsgUnimplementedByNil)
		do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| start name |
					name := each asPhrase subStrings last asLowercase.
					start := source indexOfSubCollection: name startingAt: each size + 1.
					start to: (source
								nextIndexOf: $.
								from: start
								to: source size) - 1]
				code: CWarnMsgUnimplemented]!

testWarnNiladicExceptionHandler
	#(#testWarnNiladicExceptionHandler) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: [:source | (source lastIndexOf: $[) to: (source lastIndexOf: $])]
				code: CWarnExpectMonadicBlockArg]!

testWarnNonNiladicGuardedBlock
	#(#testWarnNonNiladicGuardedBlock) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| start |
					start := source findString: 'on:' startingAt: (source lastIndexOf: $.).
					start to: start + 2]
				code: CWarnExpectNiladicBlockReceiver]!

testWarnRestrictedSelector
	"Test one of each of binary selector, unary, keyword one arg, keyword more than one arg. In each case the entire method signature should be included in the error range"

	#(#== #basicSize #ifNil: #ifNil:ifNotNil: #~~) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| signature |
					signature := source copyFrom: 1 to: (source indexOf: Character cr) - 1.
					1 to: signature trimBlanks size]
				code: CWarnRestrictedSelector]!

testWarnUndefinedSelector
	#(#testWarnUndefinedSelector) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| start |
					start := source indexOfSubCollection: 'self'.
					start to: (source
								nextIndexOf: $.
								from: start
								to: source size) - 1]
				code: CWarnUndefinedSelector]!

testWarnUnimplementedAbstractMethod
	#(#testWarnUnimplementedAbstractMethod) do: 
			[:each |
			self
				parseMethodWarning: each
				rangeBlock: 
					[:source |
					| start msg |
					msg := 'self subclassResponsibility'.
					start := source indexOfSubCollection: msg.
					start to: start + msg size - 1]
				code: CWarnUnimplementedAbstractMethod]!

writtenNotReadRange: aString
	| start |
	start := aString lastIndexOf: $_.
	^start to: start + 3! !
!SmalltalkParserErrorTest categoriesFor: #compilationErrorClass!helpers!private! !
!SmalltalkParserErrorTest categoriesFor: #compilationWarningClass!helpers!private! !
!SmalltalkParserErrorTest categoriesFor: #ifNil:!control flow!public! !
!SmalltalkParserErrorTest categoriesFor: #ifNotNil:ifNil:!control flow!public! !
!SmalltalkParserErrorTest categoriesFor: #lexicalError:range:line:code:!helpers!private! !
!SmalltalkParserErrorTest categoriesFor: #lexicalErrorFrom:range:line:code:!helpers!private! !
!SmalltalkParserErrorTest categoriesFor: #lexicalQualifiedRefError:code:range:!helpers!private! !
!SmalltalkParserErrorTest categoriesFor: #parseExpression:in:!private! !
!SmalltalkParserErrorTest categoriesFor: #parseMethod:in:!private! !
!SmalltalkParserErrorTest categoriesFor: #parserClass!constants!private! !
!SmalltalkParserErrorTest categoriesFor: #scannerClass!constants!private! !
!SmalltalkParserErrorTest categoriesFor: #testErrorsLexicalBadNumber!exceptions!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testErrorsLexicalInvalidQualifier!exceptions!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testErrorsLexicalUnterminatedQualifier!exceptions!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testErrorsNonsenseAtEndOfExpression!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testErrorsNonsenseAtEndOfMethod!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testErrorsTempsNotClosedRecovery!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testInfoHardBreakpoint!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testInfoSupersendsOther!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testInfoUnreferencedArg!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testParserErrors!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarningUnreachable!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarningUsesBooleanClass!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarnMsgUnimplemented!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarnNiladicExceptionHandler!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarnNonNiladicGuardedBlock!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarnRestrictedSelector!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarnUndefinedSelector!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #testWarnUnimplementedAbstractMethod!public!unit tests! !
!SmalltalkParserErrorTest categoriesFor: #writtenNotReadRange:!helpers!private! !

