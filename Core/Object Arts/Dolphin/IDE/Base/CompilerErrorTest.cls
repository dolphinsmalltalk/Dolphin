"Filed out from Dolphin Smalltalk 7"!

AbstractParserErrorTest subclass: #CompilerErrorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CompilerFlags'
	classInstanceVariableNames: ''!
CompilerErrorTest guid: (GUID fromString: '{46595911-e729-41d5-92f4-57241cf25eac}')!
CompilerErrorTest comment: ''!
!CompilerErrorTest categoriesForClass!Unclassified! !
!CompilerErrorTest methodsFor!

defaultCompileFlags
	^Interactive "| SyntaxCheckOnly"

 

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
		code: CErrBadContext!

testErrorsBadPools
	| source |
	source := 'xyz'.
	self
		should: 
			[Compiler
				compileForEvaluation: source
				in: UndefinedObject
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
				code: CErrBadPools
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
		code: LErrExpectExtendedLiteral!

testErrorsNonsenseAtEndOfExpression
	self 
		parseExprError: '1+2]3'
		range: (1 to: 3)
		line: 1
		code: CErrUnterminatedStatement.
	self 
		parseExprError: ' ##(1+2]3)'
		range: (5 to: 7)
		line: 1
		code: CErrUnterminatedStatement!

testErrorsNonsenseAtEndOfMethod
	"Nonense at end of method - not sure how to get this error to emerge - can do it with the Smalltalk Parser with an expression like.
		x 1 ]
	i..e with an extraneous close square bracket, but this yields an unterminated statement or invalid expression start from the C++ compiler."

	| source mark |
	source := 'blah ^1+2]'.
	self 
		parseMethodError: source
		code: CErrUnterminatedStatement
		range: ((source indexOf: $^) to: (source indexOf: $]) - 1).
	source := '1+2]. 3+4'.
	self 
		parseExprError: source
		range: (1 to: 3)
		line: 1
		code: CErrUnterminatedStatement.
	source := '1+2.] 3+4'.
	mark := source indexOf: $].
	self 
		parseExprError: source
		range: (mark to: mark)
		line: 1
		code: CErrInvalExprStart!

writtenNotReadRange: aString
	"The Dolphin Compiler reports written-not-read temps against the temp declaration."

	| start |
	start := aString indexOf: $_.
	^start to: start + 3! !
!CompilerErrorTest categoriesFor: #defaultCompileFlags!constants!private! !
!CompilerErrorTest categoriesFor: #parseExpression:in:!helpers!private! !
!CompilerErrorTest categoriesFor: #parseMethod:in:!helpers!private! !
!CompilerErrorTest categoriesFor: #parserClass!constants!private! !
!CompilerErrorTest categoriesFor: #printLiterals:on:!helpers!private! !
!CompilerErrorTest categoriesFor: #skipUnlessCompilerSupportsCodePointErrors!private!unit tests! !
!CompilerErrorTest categoriesFor: #tempWarningRangeIn:!helpers!private! !
!CompilerErrorTest categoriesFor: #testErrorsBadContext!public!unit tests! !
!CompilerErrorTest categoriesFor: #testErrorsBadPools!public!unit tests! !
!CompilerErrorTest categoriesFor: #testErrorsLexicalBadCodePoint!public!unit tests! !
!CompilerErrorTest categoriesFor: #testErrorsLexicalExpectCodePoint!public!unit tests! !
!CompilerErrorTest categoriesFor: #testErrorsLexicalExpectExtendedLiteral!public!unit tests! !
!CompilerErrorTest categoriesFor: #testErrorsNonsenseAtEndOfExpression!public!unit tests! !
!CompilerErrorTest categoriesFor: #testErrorsNonsenseAtEndOfMethod!public!unit tests! !
!CompilerErrorTest categoriesFor: #writtenNotReadRange:!helpers!private! !

