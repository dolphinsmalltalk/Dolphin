"Filed out from Dolphin Smalltalk"!

Kernel.Tests.AbstractParserErrorTest subclass: #'Kernel.Tests.CompilerErrorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CompilerErrorTest guid: (Core.GUID fromString: '{46595911-e729-41d5-92f4-57241cf25eac}')!
Kernel.Tests.CompilerErrorTest comment: ''!
!Kernel.Tests.CompilerErrorTest categoriesForClass!Unclassified! !
!Kernel.Tests.CompilerErrorTest methodsFor!

defaultCompileFlags
	^CompilerFlags.Interactive "| CompilerFlags.SyntaxCheckOnly"

 

!

parseExpression: aString in: aClass
	errors := OrderedCollection new.
	^
	[Compiler
		compileForEvaluation: aString
		in: aClass
		environment: nil
		evaluationPools: #()
		flags: self defaultCompileFlags]
			on: self compilationErrorClass
			do: 
				[:ex |
				errors addLast: ex.
				ex pass]!

parseMethod: aString in: aClass
	^Compiler
		compile: aString
		in: aClass
		environment: nil
		flags: self defaultCompileFlags!

parserClass
	^Compiler!

skipUnlessCompilerSupportsCodePointErrors
	self skipUnless: [self isAtLeastVmVersion: #(2016 7 0 49)]!

tempWarningRangeIn: aString
	| start |
	start := aString indexOf: $$.
	^start <= 0
		ifTrue: [super tempWarningRangeIn: aString]
		ifFalse: [^start + 2 to: (aString lastIndexOf: $$) - 2]!

testErrorsBadContext
	"Compiler requires that allInstVarNames returns an array of strings. If it doesn't it reports CErrBadContext."

	| anon source |
	anon := self class newAnonymousSubclass.
	anon class basicCompile: 'allInstVarNames ^#bad'.
	source := 'wibble: arg'.
	self
		parseMethodError: source
		in: anon
		range: (1 to: source size)
		code: ParseErrorCodes.CErrBadContext!

testErrorsBadPools
	| source |
	source := 'xyz'.
	self
		should: 
			[Compiler
				compileForEvaluation: source
				in: nil
				environment: nil
				evaluationPools: 'Bad pools'
				flags: self defaultCompileFlags]
		raise: self compilationErrorClass
		matching: 
			[:ex |
			| range |
			range := 1 to: source size.
			self
				checkCompileError: ex
				range: range
				code: ParseErrorCodes.CErrBadPools
				line: 1
				source: source]!

testErrorsLexicalBadCodePoint
	self skipUnlessCompilerSupportsCodePointErrors.
	super testErrorsLexicalBadCodePoint!

testErrorsLexicalExpectCodePoint
	self skipUnlessCompilerSupportsCodePointErrors.
	super testErrorsLexicalExpectCodePoint!

testErrorsLexicalExpectExtendedLiteral
	"Invalid const"

	self
		parseExprError: '###'
		range: (3 to: 3)
		line: 1
		code: ParseErrorCodes.LErrExpectExtendedLiteral!

testErrorsNonsenseAtEndOfExpression
	self 
		parseExprError: '1+2]3'
		range: (1 to: 3)
		line: 1
		code: ParseErrorCodes.CErrUnterminatedStatement.
	self 
		parseExprError: ' ##(1+2]3)'
		range: (5 to: 7)
		line: 1
		code: ParseErrorCodes.CErrUnterminatedStatement!

testErrorsNonsenseAtEndOfMethod
	"Nonense at end of method - not sure how to get this error to emerge - can do it with the Smalltalk Parser with an expression like.
		x 1 ]
	i..e with an extraneous close square bracket, but this yields an unterminated statement or invalid expression start from the C++ compiler."

	| source mark |
	source := 'blah ^1+2]'.
	self 
		parseMethodError: source
		code: ParseErrorCodes.CErrUnterminatedStatement
		range: ((source indexOf: $^) to: (source indexOf: $]) - 1).
	source := '1+2]. 3+4'.
	self 
		parseExprError: source
		range: (1 to: 3)
		line: 1
		code: ParseErrorCodes.CErrUnterminatedStatement.
	source := '1+2.] 3+4'.
	mark := source indexOf: $].
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: ParseErrorCodes.CErrInvalExprStart!

writtenNotReadRange: aString
	"The Dolphin Compiler reports written-not-read temps against the temp declaration."

	| start |
	start := aString indexOf: $_.
	^start to: start + 3! !
!Kernel.Tests.CompilerErrorTest categoriesForMethods!
defaultCompileFlags!constants!private! !
parseExpression:in:!helpers!private! !
parseMethod:in:!helpers!private! !
parserClass!constants!private! !
skipUnlessCompilerSupportsCodePointErrors!private!unit tests! !
tempWarningRangeIn:!helpers!private! !
testErrorsBadContext!public!unit tests! !
testErrorsBadPools!public!unit tests! !
testErrorsLexicalBadCodePoint!public!unit tests! !
testErrorsLexicalExpectCodePoint!public!unit tests! !
testErrorsLexicalExpectExtendedLiteral!public!unit tests! !
testErrorsNonsenseAtEndOfExpression!public!unit tests! !
testErrorsNonsenseAtEndOfMethod!public!unit tests! !
writtenNotReadRange:!helpers!private! !
!

