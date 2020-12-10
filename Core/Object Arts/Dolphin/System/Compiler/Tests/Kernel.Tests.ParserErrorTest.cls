"Filed out from Dolphin Smalltalk 7"!

Kernel.Tests.AbstractParserErrorTest subclass: #'Kernel.Tests.ParserErrorTest'
	instanceVariableNames: 'semanticAnalyserClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.ParserErrorTest guid: (Core.GUID fromString: '{67c4b011-40fa-43b7-83a4-cd8d616c16d0}')!
Kernel.Tests.ParserErrorTest comment: ''!
!Kernel.Tests.ParserErrorTest categoriesForClass!Unclassified! !
!Kernel.Tests.ParserErrorTest methodsFor!

ifNil: aBlock
	^nil!

ifNotNil: notNilBlock ifNil: nilBlock 
	^notNilBlock value: self!

lexicalError: aString range: anInterval line: lineInteger code: anInteger
	self
		lexicalErrorFrom: [self scannerClass on: aString readStream]
		range: anInterval
		line: lineInteger
		code: anInteger!

lexicalErrorFrom: aBlockClosure range: anInterval line: lineInteger code: anInteger
	self
		should: [aBlockClosure value contents]
		raise: self parserClass errorClass
		matching: [:ex | ex errorCode = anInteger and: [ex range = anInterval and: [ex line = lineInteger]]]!

parseExpression: aString in: aClass
	| ast errorBlock |
	errors := OrderedCollection new.
	errorBlock := [:err | errors addLast: err].
	ast := Parser
				parseExpression: aString
				in: aClass
				onError: errorBlock.
	^errors isEmpty
		ifTrue: 
			[semanticAnalyserClass
				analyzeParseTree: ast
				for: aClass
				context: nil
				pools: #()
				onError: errorBlock]
		ifFalse: [ast]!

parseMethod: aString in: aClass
	| ast syntaxErrors |
	syntaxErrors := OrderedCollection new.
	ast := self parserClass
				parseMethod: aString
				in: aClass
				onError: [:err | syntaxErrors addLast: err].
	"Don't perform semantic analysis if there are syntax errors"
	^syntaxErrors isEmpty
		ifTrue: 
			[semanticAnalyserClass
				analyzeParseTree: ast
				for: aClass
				context: nil
				pools: #()
				onError: nil]
		ifFalse: [ast]!

parserClass
	^Parser!

scannerClass
	^Scanner!

setUp
	super setUp.
	semanticAnalyserClass := StSemanticAnalyser!

testErrorsBadCodePoint
	#('$\x110000' '$\xFFFFFFFF') do: 
			[:each |
			self
				parseExprError: each
				range: (1 to: each size)
				line: 1
				code: LErrBadCodePoint]!

testErrorsExpectCodePoint
	#('$\x ' '$\x!! ' '$\xG') do: 
			[:each |
			self
				parseExprError: each
				range: (1 to: 4)
				line: 1
				code: LErrExpectCodePoint]!

testErrorsLexicalBadNumber
	self
		lexicalError: ' 1.0e309'
		range: (2 to: 8)
		line: 1
		code: LErrBadNumber.
	self
		lexicalError: '0.1e310'
		range: (1 to: 7)
		line: 1
		code: LErrBadNumber.
	"Exponent too large in literal integer"
	self
		lexicalError: ' 1e1000000 '
		range: (2 to: 10)
		line: 1
		code: LErrBadNumber.
	"Scale too large in literal ScaledDecimal"
	self
		lexicalError: '  1s999999 '
		range: (3 to: 10)
		line: 1
		code: LErrBadNumber.
	"Scale too large in literal ScaledDecimal with fraction"
	self
		lexicalError: '
1.2s999999 '
		range: (3 to: 12)
		line: 2
		code: LErrBadNumber!

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

testErrorsPrimitivesCloseTagRecovery
	| source ast |
	source := 'blah <primitive: 10 ^self invalidCall: _failureCode'.
	ast := [self parserClass parseMethod: source] on: self parserClass errorClass do: [:ex | ex resume].
	self assert: ast formattedCode equals: 'blah
	<primitive: 10>
	^self invalidCall: _failureCode'!

testErrorsQualifiedReferenceInvalidName
	| ast qr |
	ast := super testErrorsQualifiedReferenceInvalidName.
	"Looks like sending #nil to a malformed QR"
	self assert: ast isMessage.
	qr := ast receiver.
	self assert: qr isQualifiedReference.
	self assert: qr pathString isEmpty!

testErrorsQualifiedReferenceMetaNotClosed
	| ast qr |
	ast := super testErrorsQualifiedReferenceMetaNotClosed.
	self assert: ast isMessage.
	self assert: ast selector equals: #name.
	qr := ast receiver.
	self assert: qr isQualifiedReference.
	self assert: qr value isMeta.
	self assert: qr value asString equals: 'A.B.C class'!

testErrorsQualifiedReferenceNotClosed
	| qr |
	qr := super testErrorsQualifiedReferenceNotClosed.
	self assert: qr isQualifiedReference.
	self assert: qr pathString equals: 'A.B.C'!

testErrorsQualifierReferenceEmpty
	| ast |
	ast := super testErrorsQualifierReferenceEmpty.
	self assert: errors size equals: 1.
	self assert: ast isQualifiedReference.
	self assert: ast pathString isEmpty!

testErrorsTempsNotClosedRecovery
	| source ast |
	source := 'blah | 1+2 ^3'.
	ast := [self parserClass parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode equals: 'blah
	1 + 2.
	^3'.
	source := 'blah | a 1 + 2. a := 3'.
	ast := [self parserClass parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode equals: 'blah
	| a |
	1 + 2.
	a := 3'.
	source := 'blah |'.
	ast := [self parserClass parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode equals: 'blah
	'.
	source := 'blah | '.
	ast := [self parserClass parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode equals: 'blah
	'.
	source := 'blah | a b'.
	ast := [self parserClass parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode equals: 'blah
	| a b |
	'.
	source := 'blah | a a := 1. ^a'.
	ast := [self parserClass parseMethod: source] on: self compilationErrorClass do: [:ex | ex resume].
	self assert: ast formattedCode equals: 'blah
	| a |
	'':=''.
	1.
	^a'.
	self assert: ast argumentNames isEmpty.
	self assert: ast allTemporaryVariables asArray equals: #('a').
	source := '[:a | | b ]'.
	ast := [self parserClass parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast isBlock.
	self assert: ast argumentNames asArray equals: #('a').
	self assert: ast allTemporaryVariables asArray equals: #('b').
	source := '[:a | |]'.
	ast := [self parserClass parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast formattedCode equals: '[:a | ]'.
	self assert: ast isBlock.
	self assert: ast argumentNames asArray equals: #('a').
	self assert: ast allTemporaryVariables isEmpty.
	source := '[:a ||'.
	ast := [self parserClass parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast formattedCode equals: '[:a | ]'.
	self assert: ast isBlock.
	self assert: ast argumentNames asArray equals: #('a').
	self assert: ast allTemporaryVariables isEmpty.
	source := '[:a ||]'.
	ast := [self parserClass parseExpression: source] on: self compilationErrorClass
				do: [:ex | ex resume].
	self assert: ast formattedCode equals: '[:a | ]'.
	self assert: ast isBlock.
	self assert: ast argumentNames asArray equals: #('a').
	self assert: ast allTemporaryVariables isEmpty!

testParserErrors
	#(#('self foo. + 3' 11) #('#(' 3) #('self 0' 6) #('self asdf;;asfd' 11)) 
		do: [:each | self parseError: each]!

testWarningSelfSendNotImplemented
	#{Tools.BrowserSemanticAnalyser} ifDefined: 
			[:class |
			semanticAnalyserClass := class.
			super testWarningSelfSendNotImplemented]
		ifNotDefined: [self skip]!

testWarningSupersendNotImplemented
	#{Tools.BrowserSemanticAnalyser} ifDefined: 
			[:class |
			semanticAnalyserClass := class.
			super testWarningSupersendNotImplemented]
		ifNotDefined: [self skip]!

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
					| start stop |
					start := (source findString: '">"' startingAt: (source lastIndexOf: $.))+3.
					stop := (source findString: '"<"' startingAt: start) - 1.
					start to: stop]
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

writtenNotReadRange: aString
	| start |
	start := aString lastIndexOf: $_.
	^start to: start + 3! !
!Kernel.Tests.ParserErrorTest categoriesFor: #ifNil:!control flow!public! !
!Kernel.Tests.ParserErrorTest categoriesFor: #ifNotNil:ifNil:!control flow!public! !
!Kernel.Tests.ParserErrorTest categoriesFor: #lexicalError:range:line:code:!helpers!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #lexicalErrorFrom:range:line:code:!helpers!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #parseExpression:in:!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #parseMethod:in:!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #parserClass!constants!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #scannerClass!constants!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #setUp!public!running! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsBadCodePoint!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsExpectCodePoint!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsLexicalBadNumber!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsNonsenseAtEndOfExpression!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsNonsenseAtEndOfMethod!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsPrimitivesCloseTagRecovery!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsQualifiedReferenceInvalidName!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsQualifiedReferenceMetaNotClosed!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsQualifiedReferenceNotClosed!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsQualifierReferenceEmpty!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testErrorsTempsNotClosedRecovery!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testParserErrors!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testWarningSelfSendNotImplemented!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testWarningSupersendNotImplemented!private! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testWarningUnreachable!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testWarnNiladicExceptionHandler!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testWarnNonNiladicGuardedBlock!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #testWarnRestrictedSelector!public!unit tests! !
!Kernel.Tests.ParserErrorTest categoriesFor: #writtenNotReadRange:!helpers!private! !

