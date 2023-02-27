"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.Scanner'
	instanceVariableNames: 'stream buffer tokenStart currentCharacter characterType comments line errorHandler environment'
	classVariableNames: ''
	imports: #(#{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {
			'ClassificationTable'
				-> #(#separator nil nil nil nil nil nil nil nil #separator #separator #separator #separator #separator nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #separator #binary nil nil nil #binary #binary nil #special #special #binary #binary #binary #binary #special #binary #digit #digit #digit #digit #digit #digit #digit #digit #digit #digit #special #special #binary #binary #binary #binary #binary #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #special #binary #special #special #alphabetic nil #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #special #binary #special #binary nil).
			'EscapeChars' -> (IdentityDictionary
						withAll: { $0 -> $\0. $a -> $\a. $b -> $\b. $f -> $\f. $n -> $\n. $r -> $\r. $t -> $\t. $v -> $\v })
		}!
Kernel.Scanner guid: (Core.GUID fromString: '{f76f2335-9125-488e-a570-5a759a6e67b7}')!
Kernel.Scanner comment: 'SmalltalkScanner is the Smalltalk lexical analyzer. It converts source text to a stream of <StToken>''s.

Note that SmalltalkScanner is based on the RBScanner class written by John Brant and Don Roberts for their Refactoring Browser. It has been extended for Dolphin to incorporate additional error reporting capabilities (such as the line number on which the error occurred), and the ability to parse Dolphin''s FFI call syntax.

Instance Variables:
	stream				<ReadStream> Input stream (method/expression source)
	buffer				<WriteStream> Token building buffer.
	tokenStart			<integer> position in stream at which current token starts.
	currentCharacter		<Character> last character read from stream.
	characterType		<Symbol>. Symbolic type of last character read from stream.
	classificationTable	<Array> of <Symbol>. Symbolic types of each possible character (one slot per code point).
	separatorsInLiterals	<boolean>. Whether to allow whitespace in literal constants.
	extendedLiterals		<boolean>. Whether extended literal constants (prefixed with ##) are parsed.
	comments			<OrderedCollection> of <Interval>. Ranges of the source occupied by comments.
	errorBlock			<dyadicValuable> evaluated on encountering lexical errors
	nameSpaceCharacter	<Character>. Namespace separator character (not currently used on Dolphin)
	line					<integer> line number of current token.

Class Instance Variables:
	classificationTable	<Array>. Used to classify characters into types.

'!
!Kernel.Scanner categoriesForClass!System-Compiler! !
!Kernel.Scanner methodsFor!

addComment: anInterval
	(comments ifNil: [comments := OrderedCollection new: 1]) addLast: anInterval!

atEnd
	^characterType == #eof!

classify: aCharacter
	"May be asked to classify nil if peek at end of stream"

	^aCharacter ifNil: [#eof] ifNotNil: [ClassificationTable lookup: aCharacter codePoint + 1]!

constantExpected
	self lexicalError: LErrExpectConst.
	^self literalErrorToken: buffer contents stop: self previousStepPosition!

contents
	| contentsStream |
	contentsStream := WriteStream on: (Array new: 50).
	self do: [:each | contentsStream nextPut: each].
	^contentsStream contents!

do: aBlock
	"Evaluate the argument, aBlock, for each of the remaining elements that can be accessed by 
	the receiver."

	[self atEnd] whileFalse: [aBlock value: self next]
!

environment
	"Answer the <Namespace> in who's scope the receiver is scanning."

	^environment!

environment: anObject
	"Set the environment for which the receiver is scanning."

	environment := anObject!

errorHandler: parseErrorHandler 
	errorHandler := parseErrorHandler!

errorPosition
	^stream position!

extendedLiteralExpected
	self lexicalError: LErrExpectExtendedLiteral.
	^self literalErrorToken: buffer contents stop: self previousStepPosition!

getComments
	| oldComments |
	oldComments := comments.
	comments := nil.
	^oldComments!

illegalCharacter
	| start badChar |
	badChar := currentCharacter.
	start := tokenStart - (buffer collection encodedSizeOf: badChar) + 1.
	errorHandler
		reportError: LErrBadChar
		at: self errorPosition
		line: self line
		range: (start to: start)
		extras: {badChar}.
	"Skip over the bad character"
	self step.
	^StIllegalCharacterToken
		start: start
		comments: nil
		value: badChar!

illegalNumber
	self lexicalError: LErrBadNumber range: (tokenStart to: self previousStepPosition)!

lexicalError: anInteger
	^self lexicalError: anInteger range: (tokenStart to: self errorPosition)!

lexicalError: anInteger range: anInterval
	^errorHandler
		reportError: anInteger
		at: self errorPosition
		line: self line
		range: anInterval
		extras: #()!

line
	"Answer the one-based <integer> line number of the receiver's current position in the source
	text."

	^line!

literalCharacterTokenClass
	^StLiteralToken!

literalErrorToken: anObject stop: anInteger
	^StLiteralToken
		start: tokenStart
		comments: nil
		value: anObject
		stop: anInteger!

metaVariableExpected
	^self lexicalError: LErrExpectMetaVariable!

newFloatToken: significandInteger precision: precisionInteger exponent: exponentInteger
	| floatValue |
	#todo.	"Do a better job of detecting and report illegal floating point numbers that are out of range."
	floatValue := exponentInteger - precisionInteger <= Float maxExponent
				ifTrue: 
					[exponentInteger >= precisionInteger
						ifTrue: 
							["integral value"
							(significandInteger * (exponentInteger - precisionInteger) exp10) asFloat]
						ifFalse: 
							["Note that the fraction does not need to be normalized before #asFloat conversion,
							 which will be faster than Integer>>gcd: "
							(Fraction numerator: significandInteger
								denominator: (exponentInteger negated + precisionInteger) exp10) asFloat]]
				ifFalse: 
					[self illegalNumber.
					Float infinity * significandInteger sign].
	^StNumberLiteralToken
		start: tokenStart
		comments: nil
		value: floatValue
		stop: self previousStepPosition
		source: buffer contents!

newIntegerToken: significandInteger exponent: exponentInteger
	"Private - Return a new literal integer token. To avoid lengthy exponentiation calculation
	for accidentally large exponents, impose an arbitrary limit."

	| intValue |
	intValue := exponentInteger <= Number.MaxLiteralIntegerExponent
				ifTrue: [significandInteger * exponentInteger exp10]
				ifFalse: 
					[self illegalNumber.
					0].
	^StNumberLiteralToken
		start: tokenStart
		comments: nil
		value: intValue
		stop: self previousStepPosition
		source: buffer contents!

newScaledDecimalToken: significandInteger precision: precisionInteger scale: scaleInteger
	| decimalValue |
	decimalValue := scaleInteger <= ScaledDecimal maxPrecision
				ifTrue: [ScaledDecimal newFromNumber: significandInteger / precisionInteger exp10 scale: scaleInteger]
				ifFalse: 
					[self illegalNumber.
					0s].
	^StNumberLiteralToken
		start: tokenStart
		comments: nil
		value: decimalValue
		stop: self previousStepPosition
		source: buffer contents!

next
	| token |
	buffer reset.
	tokenStart := stream position.
	characterType == #eof
		ifTrue: [token := StEofToken start: tokenStart + 1	"The EOF token should occur after the end of input"]
		ifFalse: 
			[token := self scanToken.
			self stripSeparators].
	token comments: comments.
	comments := nil.
	^token!

notificationClass
	^Parser notificationClass!

on: aStream
	buffer := WriteStream on: (Utf8String new: 60).
	stream := aStream.
	errorHandler := self.
	line := 1.
	environment := Smalltalk!

previousStepPosition
	^characterType == #eof 
		ifTrue: [stream position]
		ifFalse: [stream position - 1]!

readIntegerOfRadix: anInteger
	| value |
	value := nil.
	[currentCharacter isNil] whileFalse: 
			[| digit |
			((digit := #[127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 0 1 2 3 4 5 6 7 8 9 127 127 127 127 127 127 127 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127 127]
						lookup: currentCharacter code) ?? 127)
				< anInteger
					ifTrue: 
						[buffer nextPut: currentCharacter.
						self step.
						value := (value ?? 0) * anInteger + digit]
					ifFalse: [^value]].
	^value!

recoverFromUnterminatedComment: anInteger 
	characterType := #eof.
	currentCharacter := nil.
	self addComment: (anInteger to: stream position)!

reportError: anInteger at: posInteger line: lineInteger range: anInterval extras: anArray
	^(self notificationClass
		code: anInteger
		in: stream contents
		for: Object
		selector: #unknown
		position: posInteger
		line: lineInteger
		range: anInterval
		extras: anArray) signal!

scanAnySymbol
	characterType == #alphabetic ifTrue: [^self scanSymbol].
	characterType == #binary ifTrue: [^self scanBinary: StLiteralToken].
	^StEofToken new!

scanBinary: aClass
	"Private - Although this does now permit binary selectors to be any length, as mandated by the ANSI
	standard, it still deliberately excludes '-' to avoid the ambiguity in expressions such as: '1--2'. The ANSI
	standard requires that this expression should be treated as a single send of the binary selector #-- to
	1 with 2 as its argument, however Smalltalk has traditionally treated this as '1 - -2', one subtract minus two."

	| val |
	buffer nextPut: currentCharacter.
	self step.
	[characterType == #binary and: [currentCharacter ~~ $-]] whileTrue: 
			[buffer nextPut: currentCharacter.
			self step].
	val := buffer contents.
	val := val asSymbol.
	^aClass
		start: tokenStart
		comments: nil
		value: val!

scanExponentInteger: significandInteger
	"Private - Dolphin supports a literal format for integers with exponents. These are not translated to Floats."

	| pos sign |
	pos := stream position.
	buffer nextPut: currentCharacter.
	self step.
	sign := self scanSign.
	^self newIntegerToken: significandInteger
		exponent: ((self readIntegerOfRadix: 10)
				ifNotNil: [:exp | exp * sign]
				ifNil: 
					[self stepBackTo: pos.
					0])!

scanExtendedLiterals
	| token |
	token := self step == #alphabetic
				ifTrue: [self scanSymbol]
				ifFalse: 
					[characterType == #binary
						ifTrue: [(self scanBinary: StLiteralToken) stop: self previousStepPosition]
						ifFalse: 
							[currentCharacter == $'
								ifTrue: [self scanStringSymbol]
								ifFalse: [currentCharacter == $( ifTrue: [^self scanOptimized]]]].
	token isNil ifTrue: [^self extendedLiteralExpected].
	token value: (Symbol intern: token value asString).
	^token!

scanIdentifierOrKeyword
	| name |
	self scanName.
	currentCharacter == $. ifTrue: [self scanNameSpaceName ifNotNil: [:token | ^token]].
	(currentCharacter == $: and: [stream peek ~~ $=]) ifTrue: [^self scanKeyword].
	name := buffer contents.
	"LookupTable would be neater, but is slower and this method is one of the top hot-spots of the scanner"
	name size <= 5
		ifTrue: 
			[name = 'nil'
				ifTrue: 
					[^StLiteralToken
						start: tokenStart
						comments: nil
						value: nil
						stop: self previousStepPosition].
			name = 'true'
				ifTrue: 
					[^StLiteralToken
						start: tokenStart
						comments: nil
						value: true
						stop: self previousStepPosition].
			name = 'false'
				ifTrue: 
					[^StLiteralToken
						start: tokenStart
						comments: nil
						value: false
						stop: self previousStepPosition]].
	^StIdentifierToken
		start: tokenStart
		comments: nil
		value: name!

scanKeyword
	| words outputPosition inputPosition  |
	words := 0.
	
	[words := words + 1.
	buffer nextPut: currentCharacter.
	outputPosition := buffer position.
	inputPosition := stream position.
	self step == #alphabetic and: 
			[self scanName.
			currentCharacter == $:]]
			whileTrue.
	"Restore to position immediately after last colon"
	buffer position: outputPosition.
	stream position: inputPosition.
	self step.
	^words == 1
		ifTrue: 
			[StKeywordToken
				start: tokenStart
				comments: nil
				value: buffer contents]
		ifFalse: 
			[| name |
			name := buffer contents.
			StMultiKeywordLiteralToken
				start: tokenStart
				comments: nil
				value: name asSymbol
				stop: tokenStart + name size - 1]!

scanLiteral
	self step == #alphabetic ifTrue: [^self scanSymbol].
	characterType == #binary
		ifTrue: [^(self scanBinary: StLiteralToken) stop: self previousStepPosition].
	currentCharacter == $' ifTrue: [^self scanStringSymbol].
	currentCharacter == $( ifTrue: [^self scanLiteralArrayToken].
	currentCharacter == $[ ifTrue: [^self scanLiteralByteArrayToken].
	currentCharacter == ${ ifTrue: [^self scanQualifiedReference].
	currentCharacter == $# ifTrue: [^self scanExtendedLiterals].
	^self constantExpected!

scanLiteralArrayToken
	| token |
	token := StLiteralArrayToken
				start: tokenStart
				comments: nil
				value: '#('.
	self step.
	^token!

scanLiteralByteArrayToken
	| token |
	token := StLiteralByteArrayToken
				start: tokenStart
				comments: nil
				value: '#['.
	self step.
	^token!

scanLiteralCharacter
	| value stop |
	self step.	"$"
	stop := stream position.
	currentCharacter
		ifNil: 
			[value := $\0.
			self lexicalError: LErrExpectChar]
		ifNotNil: 
			[value := currentCharacter.
			self step.	"char"
			"Extended syntax for special characters?"
			value == $\
				ifTrue: 
					[(EscapeChars lookup: currentCharacter)
						ifNil: 
							[currentCharacter == $x
								ifTrue: 
									["Explicit hex code point, e.g. $\x20"
									self step.
									value := (self readIntegerOfRadix: 16)
												ifNil: 
													["eof or non-hex digit"
													stop := stream position.
													self lexicalError: LErrExpectCodePoint.
													$\0]
												ifNotNil: 
													[:codePoint |
													stop := self previousStepPosition.
													"Maximum Unicode code point is U+10FFFF, but last valid char is U+10FFFD"
													(codePoint >= ICUConstants.UCHAR_MIN_VALUE and: [codePoint <= ICUConstants.UCHAR_MAX_VALUE])
														ifTrue: 
															[(Character isNonCharCodePoint: codePoint)
																ifTrue: [self lexicalError: CWarnNonCharCodePoint range: (tokenStart to: stop)].
															Character basicCodePoint: codePoint]
														ifFalse: 
															["Code point out of range"
															self lexicalError: LErrBadCodePoint range: (tokenStart to: stop).
															$\0]]]]
						ifNotNil: 
							[:char |
							"One of the special chars such as $\t for tab"
							value := char.
							stop := stream position.
							self step]]
				ifFalse: 
					[value == Character.Replacement
						ifTrue: [self lexicalError: LErrBadCodePoint range: (tokenStart to: stop)]]].
	^self literalCharacterTokenClass
		start: tokenStart
		comments: nil
		value: value
		stop: stop!

scanLiteralString
	self step.
	
	[currentCharacter ifNil: [^self unterminatedString].
	currentCharacter == $' and: 
			[self step.
			currentCharacter ~~ $']]
			whileFalse: 
				[buffer nextPut: currentCharacter.
				self step].
	^StLiteralToken
		start: tokenStart
		comments: nil
		value: buffer contents
		stop: self previousStepPosition!

scanName
	
	[buffer nextPut: currentCharacter.
	self step == #alphabetic or: [characterType == #digit]]
			whileTrue!

scanNameSpaceName
	(self classify: stream peek) ~~ #alphabetic ifTrue: [^nil].
	buffer nextPut: $..
	self step.
	self scanName.
	currentCharacter == $. ifTrue: [^self scanNameSpaceName].
	^StIdentifierToken
		start: tokenStart
		comments: nil
		value: buffer contents!

scanNumber: signInteger
	| integerPart |
	(integerPart := self readIntegerOfRadix: 10)
		ifNil: 
			["This should not happen since we have previously detected a digit"
			^self error: 'internal error'].
	"The type of number is determined by what we find next"
	currentCharacter == $.
		ifTrue: [^self scanSmalltalkReal: integerPart sign: signInteger]
		ifFalse: 
			[currentCharacter == $r
				ifTrue: 
					[(integerPart between: 2 and: 36)
						ifTrue: 
							[| pos |
							pos := stream position.
							buffer nextPut: $r.
							self step.
							(self readIntegerOfRadix: integerPart)
								ifNotNil: 
									[:significand |
									currentCharacter == $e
										ifTrue: [^self scanExponentInteger: significand * signInteger]
										ifFalse: [integerPart := significand]]
								ifNil: 
									["ungobble the 'r', as this appears not to be a radix prefix"
									self stepBackTo: pos]]]
				ifFalse: 
					[currentCharacter == $s
						ifTrue: 
							["s will always be part of token, regardless if there is a scale value"
							buffer nextPut: $s.
							self step.
							^self
								newScaledDecimalToken: integerPart * signInteger
								precision: 0
								scale: (self readIntegerOfRadix: 10) ?? 0]
						ifFalse: 
							["Also support St-80 format integer of the form 1e5, not valid ANSI syntax though"
							currentCharacter == $e ifTrue: [^self scanExponentInteger: integerPart * signInteger]]]].
	^StNumberLiteralToken
		start: tokenStart
		comments: nil
		value: integerPart * signInteger
		stop: self previousStepPosition
		source: buffer contents!

scanOptimized
	self step.
	^StOptimizedToken
		start: tokenStart
		comments: nil
		stop: self previousStepPosition!

scanQualifiedReference
	"Scan the opening quote of literal qualified reference, i.e. the #{ of e.g. #{Root.Smalltalk}."

	"In the original RBScanner, qualified references were scanned in their entirety as a literal token with no special token or node type to represent them. That design has a couple of issues:
		i) Error reporting and recovery is better if the QR scanned as 3 components (open, identifier, close) and the composite is parsed
		ii) QRs are 'homed' in the namespace of the method in which they are sited. This information is not available until semantic analysis, so it isn't possible to construct a valid literal value at scanning or parsing time, and the semantic analyser/code generator needs a specific node type to recognise when it is required to generate a BindingReference."

	| token |
	token := StQualifiedReferenceToken start: tokenStart.
	self step.
	^token!

scanSign
	^currentCharacter == $-
		ifTrue: 
			[buffer nextPut: $-.
			self step.
			-1]
		ifFalse: 
			["Allow plus sign, e.g. 2e+16, although not strictly Smalltalk syntax,
			 because Dolphin has historically used C library functions for
			 printing/scanning floats."
			currentCharacter == $+
				ifTrue: 
					[buffer nextPut: $+.
					self step].
			1]!

scanSmalltalkReal: anInteger sign: signInteger
	| fractionStart fractionalPart scale significand precision exponent |
	(self classify: stream peek) == #digit
		ifFalse: 
			["Trailing full stop after an integer"
			^StNumberLiteralToken
				start: tokenStart
				comments: nil
				value: anInteger * signInteger
				stop: self previousStepPosition
				source: buffer contents].
	"Step over the decimal point"
	buffer nextPut: $..
	self step.
	fractionStart := stream position.
	fractionalPart := self readIntegerOfRadix: 10.
	scale := self previousStepPosition - fractionStart + 1.
	significand := fractionalPart == 0
				ifTrue: 
					[precision := 0.
					anInteger]
				ifFalse: 
					[precision := scale.
					anInteger * precision exp10 + fractionalPart].

	"Process any exponent..."
	(currentCharacter == $e or: [currentCharacter == $d or: [currentCharacter == $q]])
		ifTrue: 
			[| exponentStart exponentSign |
			exponentStart := stream position.
			"Step over the exponent character"
			buffer nextPut: currentCharacter.
			self step.
			"Allow plus prefix on the exponent, although not ANSI Smalltalk syntax"
			exponentSign := self scanSign.
			exponent := self readIntegerOfRadix: 10.
			exponent
				ifNil: 
					["Found Float with trailing exponent character which is not
					 part of the number, e.g. 1.5e From ANSI standard p 28: 'An
					 exponentLetter must be followed by an explicit exponent'"
					self stepBackTo: exponentStart.
					exponent := 0]
				ifNotNil: [exponent := exponent * exponentSign]]
		ifFalse: 
			[currentCharacter == $s
				ifTrue: 
					[buffer nextPut: $s.
					self step.	"Skip the $s"
					^self
						newScaledDecimalToken: significand * signInteger
						precision: precision
						scale: (self readIntegerOfRadix: 10) ?? scale].
			exponent := 0].
	^self
		newFloatToken: significand
		precision: precision
		exponent: exponent!

scanSpecialCharacter
	| character |
	currentCharacter == $:
		ifTrue: 
			[self step.
			^currentCharacter == $=
				ifTrue: 
					[self step.
					StAssignmentToken start: tokenStart]
				ifFalse: 
					[StSpecialCharacterToken
						start: tokenStart
						comments: nil
						value: $:]].
	character := currentCharacter.
	self step.
	^StSpecialCharacterToken
		start: tokenStart
		comments: nil
		value: character!

scanStringSymbol
	| literalToken |
	literalToken := self scanLiteralString.
	literalToken value: literalToken value asSymbol.
	^literalToken!

scanSymbol
	| lastColon value startPosition |
	startPosition := stream position.
	[characterType == #alphabetic] whileTrue: 
			[self scanName.
			currentCharacter == $:
				ifTrue: 
					[buffer nextPut: $:.
					lastColon := stream position.
					self step]].
	value := buffer contents.
	(lastColon notNil and: [value lastCodeUnit ~~ $:])
		ifTrue: 
			[stream position: lastColon.
			self step.
			value := value first: lastColon - startPosition + 1].
	^StLiteralToken
		start: tokenStart
		comments: nil
		value: value asSymbol
		stop: self previousStepPosition!

scanToken
	"fast-n-ugly. Don't write stuff like this. Has been found to cause cancer in laboratory rats. Basically a 
	case statement. Didn't use Dictionary because lookup is pretty slow."

	characterType == #alphabetic ifTrue: [^self scanIdentifierOrKeyword].
	characterType == #digit ifTrue: [^self scanNumber: 1].
	(currentCharacter == $- and: [(self classify: stream peek) == #digit])
		ifTrue: 
			[buffer nextPut: $-.
			self step.
			^self scanNumber: -1].
	characterType == #binary ifTrue: [^self scanBinary: StBinarySelectorToken].
	characterType == #special ifTrue: [^self scanSpecialCharacter].
	currentCharacter == $' ifTrue: [^self scanLiteralString].
	currentCharacter == $# ifTrue: [^self scanLiteral].
	currentCharacter == $$ ifTrue: [^self scanLiteralCharacter].
	^self illegalCharacter!

step
	^(currentCharacter := stream nextAvailable)
		ifNotNil: 
			[| index |
			(index := currentCharacter code) == 10 ifTrue: [line := line + 1].
			characterType := ClassificationTable lookup: index + 1]
		ifNil: [characterType := #eof]!

stepBackTo: anInteger
	| offset |
	offset := anInteger - 1.
	buffer skip: offset - self previousStepPosition.
	stream position: offset.
	self step!

stripSeparators
	
	[[characterType == #separator] whileTrue: [self step].
	currentCharacter == $"] whileTrue: 
				[| start stop |
				start := stream position.
				
				[| ch |
				stream atEnd ifTrue: [^self unterminatedComment: start].
				ch := stream next.
				ch == $\n ifTrue: [line := line + 1].
				ch == $"]
						whileFalse.
				stop := stream position.
				self step.
				self addComment: (start to: stop)]!

unterminatedComment: anInteger 
	self lexicalError: LErrCommentNotClosed range: (anInteger to: self errorPosition).
	^self recoverFromUnterminatedComment: anInteger!

unterminatedString
	self lexicalError: LErrStringNotClosed.
	^self literalErrorToken: buffer contents stop: self previousStepPosition! !
!Kernel.Scanner categoriesForMethods!
addComment:!private!scanning! !
atEnd!public!testing! !
classify:!private!scanning! !
constantExpected!error handling!private! !
contents!accessing!public! !
do:!enumerating!public! !
environment!accessing!public! !
environment:!accessing!public! !
errorHandler:!initializing!private! !
errorPosition!accessing!error handling!public! !
extendedLiteralExpected!error handling!private! !
getComments!accessing!public! !
illegalCharacter!error handling!private! !
illegalNumber!error handling!private! !
lexicalError:!error handling!private! !
lexicalError:range:!error handling!private! !
line!accessing!public! !
literalCharacterTokenClass!public!scanning! !
literalErrorToken:stop:!error handling!private! !
metaVariableExpected!error handling!private! !
newFloatToken:precision:exponent:!helpers!private! !
newIntegerToken:exponent:!helpers!private! !
newScaledDecimalToken:precision:scale:!helpers!private! !
next!accessing!public! !
notificationClass!constants!error handling!private! !
on:!initializing!private! !
previousStepPosition!accessing!private! !
readIntegerOfRadix:!private!scanning! !
recoverFromUnterminatedComment:!error handling!private! !
reportError:at:line:range:extras:!error handling!private! !
scanAnySymbol!private!scanning! !
scanBinary:!private!scanning! !
scanExponentInteger:!private!scanning! !
scanExtendedLiterals!private!scanning! !
scanIdentifierOrKeyword!private!scanning! !
scanKeyword!private!scanning! !
scanLiteral!private!scanning! !
scanLiteralArrayToken!private!scanning! !
scanLiteralByteArrayToken!private!scanning! !
scanLiteralCharacter!private!scanning! !
scanLiteralString!private!scanning! !
scanName!private!scanning! !
scanNameSpaceName!private!scanning! !
scanNumber:!private!scanning! !
scanOptimized!private!scanning! !
scanQualifiedReference!private!scanning! !
scanSign!private!scanning! !
scanSmalltalkReal:sign:!private!scanning! !
scanSpecialCharacter!private!scanning! !
scanStringSymbol!private!scanning! !
scanSymbol!private!scanning! !
scanToken!accessing!public! !
step!operations!private! !
stepBackTo:!helpers!private! !
stripSeparators!private!scanning! !
unterminatedComment:!error handling!private! !
unterminatedString!error handling!private! !
!

Kernel.Scanner methodProtocol: #parseErrorHandler attributes: #(#readOnly) selectors: #(#reportError:at:line:range:extras:)!

!Kernel.Scanner class methodsFor!

classify: aCharacter
	"May be asked to classify nil if peek at end of stream"

	^aCharacter ifNil: [#eof] ifNotNil: [ClassificationTable lookup: aCharacter code + 1]!

initialize
	| escapeChars |
	self initializeClassificationTable.
	escapeChars := IdentityDictionary new.
	Character.EscapeChars
		keysAndValuesDo: [:i :c | c ifNotNil: [escapeChars at: c put: (Character value: i - 1)]].
	self addClassConstant: 'EscapeChars'
		value: (escapeChars
				shrink;
				isImmutable: true;
				yourself)!

initializeClassificationTable
	| classificationTable |
	classificationTable := Array new: 128.
	"#2130 ANSI Smalltalk allows only the English alphabet and underscore as letters in identifiers"
	'_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
		do: [:alpha | classificationTable at: alpha codePoint + 1 put: #alphabetic].
	'01234567890' do: [:digit | classificationTable at: digit codePoint + 1 put: #digit].
	'!!%&*+,-/<=>?@\~|' do: [:binary | classificationTable at: binary codePoint + 1 put: #binary].
	'().:;[]{}^' do: [:special | classificationTable at: special codePoint + 1 put: #special].
	(Character byteCharacterSet select: [:each | each isSeparator])
		do: [:separator | classificationTable at: separator codePoint + 1 put: #separator].
	classificationTable at: $\0 codePoint + 1 put: #separator.
	classificationTable isImmutable: true.
	self addClassConstant: 'ClassificationTable' value: classificationTable!

isSelector: aSymbol
	| scanner token |
	scanner := self basicNew.
	scanner on: (ReadStream on: aSymbol).
	scanner step.
	token := scanner scanAnySymbol.
	token isLiteralToken ifFalse: [^false].
	token value isEmpty ifTrue: [^false].
	^scanner atEnd!

isVariable: aString
	| scanner token |
	aString isString ifFalse: [^false].
	aString isEmpty ifTrue: [^false].
	(ClassificationTable lookup: aString first codePoint + 1) == #alphabetic ifFalse: [^false].
	scanner := self basicNew.
	scanner on: (ReadStream on: aString asString).
	scanner step.
	token := scanner next.
	^token isIdentifier and: [token stop = aString size]!

on: aStream 
	| scanner |
	scanner := self basicNew on: aStream.
	scanner
		step;
		stripSeparators.
	^scanner!

on: aStream errorHandler: parseErrorHandler 
	| scanner |
	scanner := self basicNew on: aStream.
	scanner
		errorHandler: parseErrorHandler;
		step;
		stripSeparators.
	^scanner! !
!Kernel.Scanner class categoriesForMethods!
classify:!public!scanning! !
initialize!development!initializing!public! !
initializeClassificationTable!initializing!private! !
isSelector:!public!testing! !
isVariable:!public!testing! !
on:!instance creation!public! !
on:errorHandler:!instance creation!public! !
!

