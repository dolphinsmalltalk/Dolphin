"Filed out from Dolphin Smalltalk 7"!

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
		flags: self defaultCompileFlags!

parserClass
	^Compiler!

printLiterals: anInteger on: aPuttableStream
	| i |
	i := 0.
	Symbol allInstancesDo: 
			[:each |
			aPuttableStream
				print: each;
				nextPut: $.;
				crtab.
			(i := i + 1) = anInteger ifTrue: [^self]].
	Smalltalk keysDo: 
			[:each |
			aPuttableStream
				nextPutAll: each;
				nextPut: $.;
				crtab.
			(i := i + 1) = anInteger ifTrue: [^self]].
	Win32Constants keysDo: 
			[:each |
			aPuttableStream
				display: Win32Constants;
				nextPut: $.;
				nextPutAll: each;
				nextPut: $.;
				crtab.
			(i := i + 1) = anInteger ifTrue: [^self]].
	self halt!

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
!Kernel.Tests.CompilerErrorTest categoriesFor: #defaultCompileFlags!constants!private! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #parseExpression:in:!helpers!private! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #parseMethod:in:!helpers!private! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #parserClass!constants!private! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #printLiterals:on:!helpers!private! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #skipUnlessCompilerSupportsCodePointErrors!private!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #tempWarningRangeIn:!helpers!private! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #testErrorsBadContext!public!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #testErrorsBadPools!public!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #testErrorsLexicalBadCodePoint!public!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #testErrorsLexicalExpectCodePoint!public!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #testErrorsLexicalExpectExtendedLiteral!public!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #testErrorsNonsenseAtEndOfExpression!public!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #testErrorsNonsenseAtEndOfMethod!public!unit tests! !
!Kernel.Tests.CompilerErrorTest categoriesFor: #writtenNotReadRange:!helpers!private! !

