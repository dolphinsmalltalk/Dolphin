"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.SmalltalkStylerTest'
	instanceVariableNames: 'mock scintilla'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.SmalltalkStylerTest guid: (Core.GUID fromString: '{a4d5d58a-e2a3-4f2b-8877-0c480d6f3b01}')!
Tools.Tests.SmalltalkStylerTest comment: ''!
!Tools.Tests.SmalltalkStylerTest categoriesForClass!Unclassified! !
!Tools.Tests.SmalltalkStylerTest methodsFor!

restyleFromEachPosition: anObject resumeable: aBoolean
	| t1 size |
	size := scintilla textLength.
	t1 := scintilla styledTextFrom: 1 to: size.
	2 to: size
		do: 
			[:i |
			| t2 |
			scintilla restyleFrom: i to: 0.
			t2 := scintilla styledTextFrom: 1 to: size.
			self
				assert: t1 = t2
				description: ('<1d> mismatch styling from <2d>' expandMacrosWith: anObject with: i)
				resumable: aBoolean]
	"
toks1 := scintilla decodeStyledText: t1.
toks2 := scintilla decodeStyledText: t2.
text1 := String writeStream. toks1 do: [:each | text1 print: each; cr]. text1 := text1 contents.
text2 := String writeStream. toks2 do: [:each | text2 print: each; cr]. text2 := text2 contents.
DiffBrowser compare: text1 with:  text2
"!

scannerClass
	^SmalltalkStylingScanner!

scanNumeric: aString class: aClass
	| result1 expected scanner token stream trailing |
	stream := aString readStream.
	expected := Number readFrom: stream.
	trailing := stream upToEnd.
	scanner := self scannerClass on: (stream
						reset;
						yourself).
	token := scanner next.
	self assert: (token valueClass includesBehavior: aClass).
	result1 := token value.
	self assert: (result1 class == expected class or: [result1 isInteger and: [expected isInteger]]).
	self assert: result1 sign equals: expected sign.
	trailing isEmpty
		ifTrue: [self assert: scanner atEnd]
		ifFalse: 
			[| trailing2 |
			stream pop.
			trailing2 := stream upToEnd.
			self assert: trailing equals: trailing2]!

setUp
	super setUp.
	mock := MockScintillaView new.
	mock textStyles: SmalltalkWorkspace defaultTextStyles!

tearDown
	scintilla
		ifNotNil: 
			[scintilla topView destroy.
			scintilla := nil].
	super tearDown!

testArrayNoSpace
	| text |
	scintilla := MethodWorkspace show view.
	scintilla topView hide.
	text := 'a self x:#(1)'.
	scintilla text: text.
	scintilla restyleFrom: 1 to: 0.
	self restyleFromEachPosition: text resumeable: false!

testBinaryMethodSignature
	"The scanner treats a double vertical bar as a binary selector, yet it can be the close of block arg decls and the open of block temp decls"

	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '||x x'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #binarySelector '||') #(##(3 to: 3) #argDecl 'x') #(##(4 to: 4) #whitespace ' ') #(##(5
				to: 5) #identifier 'x')).
	text := '||x||'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #binarySelector '||') #(##(3 to: 3) #argDecl 'x') #(##(4 to: 4) #tempOpenBar '|') #(##(5
				to: 5) #tempCloseBar '|'))!

testEmptyTemps
	"The scanner treats a double vertical bar as a binary selector, yet it could be an empty temporary declarations list in a method."

	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := 'a||x||y'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #unarySelector 'a') #(##(2 to: 2) #tempOpenBar '|') #(##(3 to: 3) #tempCloseBar '|') #(##(4
				to: 4) #identifier 'x') #(##(5 to: 6) #binaryMessage '||') #(##(7 to: 7) #identifier 'y'))!

testLegacyLiteralArray
	"Smalltalk-80 supported optional # prefix on symbols and embedded literal arrays - we still need to recognise these as literals."

	| styler text tokens |
	styler := SmalltalkExpressionStyler new.
	text := '(#(a b c: | (1)))'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #specialCharacter '(') #(##(2 to: 3) #literalArray '#(') #(##(4 to: 4) #literalSymbol 'a') #(##(5
				to: 5) #whitespace ' ') #(##(6 to: 6) #literalSymbol 'b') #(##(7 to: 7) #whitespace ' ') #(##(8
				to: 9) #literalSymbol 'c:') #(##(10 to: 10) #whitespace ' ') #(##(11 to: 11) #literalSymbol '|') #(##(12
				to: 12) #whitespace ' ') #(##(13 to: 13) #literalArray '(') #(##(14 to: 14) #literalNumber '1') #(##(15
				to: 16) #literalArray '))') #(##(17 to: 17) #specialCharacter ')'))!

testLiteralArray
	| styler text tokens |
	styler := SmalltalkExpressionStyler new.
	text := '#(nil true false #a 1 1.2 ''a'' #[1] 2)'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #literalArray '#(') #(##(3 to: 5) #literalPseudo 'nil') #(##(6 to: 6) #whitespace ' ') #(##(7
				to: 10) #literalPseudo 'true') #(##(11 to: 11) #whitespace ' ') #(##(12 to: 16) #literalPseudo 'false') #(##(17
				to: 17) #whitespace ' ') #(##(18 to: 19) #literalSymbol '#a') #(##(20 to: 20) #whitespace ' ') #(##(21
				to: 21) #literalNumber '1') #(##(22 to: 22) #whitespace ' ') #(##(23 to: 25) #literalNumber '1.2') #(##(26
				to: 26) #whitespace ' ') #(##(27 to: 29) #literalString '''a''') #(##(30 to: 30) #whitespace ' ') #(##(31
				to: 34) #literalBytes '#[1]') #(##(35 to: 35) #whitespace ' ') #(##(36 to: 36) #literalNumber '2') #(##(37
				to: 37) #literalArray ')'))!

testLiteralBytes
	| styler text tokens |
	styler := SmalltalkExpressionStyler new.
	text := '[#[1 2]] 1 #(#[1 2]3)'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #specialCharacter '[') #(##(2 to: 4) #literalBytes '#[1') #(##(5 to: 5) #whitespace ' ') #(##(6
				to: 7) #literalBytes '2]') #(##(8 to: 8) #specialCharacter ']') #(##(9 to: 9) #whitespace ' ') #(##(10
				to: 10) #literalNumber '1') #(##(11 to: 11) #whitespace ' ') #(##(12 to: 13) #literalArray '#(') #(##(14
				to: 16) #literalBytes '#[1') #(##(17 to: 17) #whitespace ' ') #(##(18 to: 19) #literalBytes '2]') #(##(20
				to: 20) #literalNumber '3') #(##(21 to: 21) #literalArray ')'))!

testNegativeOrSubtract
	"The - operator can be ambiguous if used in an expression without spaces, e.g. x-1."

	| styler text tokens |
	styler := SmalltalkExpressionStyler new.
	text := 'x-1'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #identifier 'x') #(##(2 to: 2) #binaryMessage '-') #(##(3 to: 3) #literalNumber '1')).
	#('''a''-1' '1.0-1' 'nil-1' 'true-1' 'false-1' '#x-1' '$x-1' 'self-1' '(x)-1' 'self x-1' '[] -1')
		do: 
			[:each |
			| tok |
			mock text: each.
			styler
				colorTextFrom: 1
				to: each size
				in: mock.
			tokens := mock tokens asArray.
			tok := tokens last.
			self assert: tok last equals: '1'.
			self assert: tok second equals: #literalNumber.
			tok := tokens at: tokens size - 1.
			self assert: tok last equals: '-'.
			self assert: tok second equals: #binaryMessage].
	#('self x:-1' '1.-1' '^-1' 'x:=-1' '1--1' '1+-1' '|x|-1') do: 
			[:each |
			| tok |
			mock text: each.
			styler
				colorTextFrom: 1
				to: each size
				in: mock.
			tokens := mock tokens asArray.
			tok := tokens last.
			self assert: tok last equals: '-1'.
			self assert: tok second equals: #literalNumber].
	styler := SmalltalkMethodStyler new.
	#('x:a-1' 'a-1') do: 
			[:each |
			| tok |
			mock text: each.
			styler
				colorTextFrom: 1
				to: each size
				in: mock.
			tokens := mock tokens asArray.
			tok := tokens last.
			self assert: tok last equals: '-1'.
			self assert: tok second equals: #literalNumber]!

testOptimizedExpressionInArray
	| styler text tokens |
	styler := SmalltalkExpressionStyler new.
	"The Object ref inside the ##() expression should be treated as an identifier, whilst that in the literal array is a symbol."
	text := '#(##(Object)Object)'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #literalArray '#(') #(##(3 to: 5) #specialCharacter '##(') #(##(6 to: 11) #identifier 'Object') #(##(12
				to: 12) #specialCharacter ')') #(##(13 to: 18) #literalSymbol 'Object') #(##(19 to: 19) #literalArray ')')).
	"This one has some nested parens to confuse matters"
	text := '#(##(1+(2*3)))'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #literalArray '#(') #(##(3 to: 5) #specialCharacter '##(') #(##(6 to: 6) #literalNumber '1') #(##(7
				to: 7) #binaryMessage '+') #(##(8 to: 8) #specialCharacter '(') #(##(9 to: 9) #literalNumber '2') #(##(10
				to: 10) #binaryMessage '*') #(##(11 to: 11) #literalNumber '3') #(##(12 to: 13) #specialCharacter '))') #(##(14
				to: 14) #literalArray ')'))!

testPrimitiveTag
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := 'x<primitive:1>self'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #unarySelector 'x') #(##(2 to: 14) #tag '<primitive:1>') #(##(15 to: 18) #identifier 'self')).
	text := 'x:y<primitive:1>y'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #keywordSelector 'x:') #(##(3 to: 3) #argDecl 'y') #(##(4 to: 16) #tag '<primitive:1>') #(##(17
				to: 17) #identifier 'y')).
	text := '|y<primitive: 1>self|y'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #binarySelector '|') #(##(2 to: 2) #argDecl 'y') #(##(3 to: 13) #tag '<primitive:') #(##(14
				to: 14) #whitespace ' ') #(##(15 to: 16) #tag '1>') #(##(17 to: 20) #identifier 'self') #(##(21
				to: 21) #binaryMessage '|') #(##(22 to: 22) #identifier 'y')).
	text := 'x|| <primitive:1>self'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #unarySelector 'x') #(##(2 to: 2) #tempOpenBar '|') #(##(3 to: 3) #tempCloseBar '|') #(##(4
				to: 4) #whitespace ' ') #(##(5 to: 17) #tag '<primitive:1>') #(##(18 to: 21) #identifier 'self'))!

testPseudoSignature
	"The pseudo variables are valid as unary selectors too."

	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	"Each of the identical identifiers will be coloured differently, except that the last two will be the same"
	text := 'nil nil'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 3) #unarySelector 'nil') #(##(4 to: 4) #whitespace ' ') #(##(5 to: 7) #literalPseudo 'nil'))!

testQualifiedReferenceIncompleteIdentifier
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '#{_'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens equals: {{1 to: 3. #literalBindingReference. '#{_'}}!

testQualifiedReferenceIncompleteQualifiedIdentifier
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '#{A.}'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	"Note that although the '.}' sequence will be scanned as separate special character tokens, they'll get merged into one styling token"
	self assert: tokens
		equals: {{1 to: 3. #literalBindingReference. '#{A'}. {4 to: 5. #specialCharacter. '.}'}}!

testQualifiedReferenceInvalidIdentifier
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '#{1}'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: {{1 to: 2. #literalBindingReference. '#{'}.
				{3 to: 3. #literalNumber. '1'}.
				{4 to: 4. #specialCharacter. '}'}}!

testQualifiedReferenceUnterminated
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '#{Object+'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: {{1 to: 8. #literalBindingReference. '#{Object'}. {9 to: 9. #binaryMessage. '+'}}!

testScanningFloats
	#('5.1234' '0.0' '0.5' '1.2e1' '1.2d2' '1.2e-1' '1.2e+1' '1.2d-2' '1.2d+2' '1.0e308' '1.0e+308' '2.2250738585072014e-308' '1.7976931348623158e308' '1.7976931348623158e+308' '0.5e0' '0.5d0' '0.5q0' '0.5e+0' '0.5d+0' '0.5q+0' '0.5e-0' '0.5d-0' '0.5q-0') 
		do: [:each | self scanNumeric: each class: Float].

	"Test termination on non-numeric character - these expressions are in error"
	#('5.1234a' '0.5e' '1.5e2e3' '1.5e2e-3' '1.5e-Integer zero' '1.5e-' '1.5e+' '1.5e+i' '1.7976931348623158+e308') 
		do: [:each | self scanNumeric: each class: Float].

	"Integer terminated by a period, not a float"
	self scanNumeric: '5.' class: Integer!

testScanningIntegers
	#('0' '-0' '1' '-1' '123.' '123 ' '1073741823' '-1073741824' '1e1' '1e+1' '1073741823e0' '1073741823e-0' '-1073741823e-0') 
		do: [:each | self scanNumeric: each class: Integer].
	#('1e-1' '1e-307') do: [:each | self scanNumeric: each class: Fraction].
	"Large integers"
	#('1073741824' '-1073741825' '2147483647' '2147483649' '-2147483648' '-2147483649' '1e308') 
		do: [:each | self scanNumeric: each class: Integer].
	"More small integers with trailing stuff"
	#('0A' '-0A' '123e' '1e1e2' '1e+-2' '123e-') do: [:each | self scanNumeric: each class: Integer]!

testScanningRadixIntegers
	0 to: 35
		do: 
			[:i | 
			| src |
			src := '36r' , (Character digitValue: i) asString.
			self scanNumeric: src class: Integer].
	#('2r30' '2r12' '-2r1' '-16rFF' '-16rFFG') do: [:each | self scanNumeric: each class: Integer].

	"Some cases where the radix spec is invalid"
	#('1r0' '0r0' '37r12') do: [:each | self scanNumeric: each class: Integer].

	"Leading zeroes on the radix (ok or not?)"
	#('02r11' '002r101' '016rFF') do: [:each | self scanNumeric: each class: Integer].

	"With exponents, valid and invalid"
	#('10r99e2' '10r99e+2' '10r99e+' '10r99e 2' '10r99e' '16rFFeA') 
		do: [:each | self scanNumeric: each class: Integer].

	"Negative exponents."
	#('10r99e-2' '16rABe-1') do: [:each | self scanNumeric: each class: Fraction].

	"Zero exponents"
	#('10r99e-0' '10r99e+0' '10r99e0' '16rFFe00') do: [:each | self scanNumeric: each class: Integer]!

testScanningScaledDecimals
	#('123s' '123s2' '123.0s' '123.12s' '123.12s2' '123.12s3' '123s-2' '123se' '123.0se' '123.0s2e') 
		do: [:each | self scanNumeric: each class: ScaledDecimal]!

testTempBarsAtExpressionStart
	"The scanner treats a double vertical bar as a binary selector, yet it can be the close of block arg decls and the open of block temp decls"

	| styler text tokens |
	styler := SmalltalkExpressionStyler new.
	text := '|a|a a'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #tempOpenBar '|') #(##(2 to: 2) #tempDecl 'a') #(##(3 to: 3) #tempCloseBar '|') #(##(4
				to: 4) #identifier 'a') #(##(5 to: 5) #whitespace ' ') #(##(6 to: 6) #unaryMessage 'a')).
	text := '||'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens equals: #(#(##(1 to: 1) #tempOpenBar '|') #(##(2 to: 2) #tempCloseBar '|')).
	text := '##(|a|)'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 3) #specialCharacter '##(') #(##(4 to: 4) #tempOpenBar '|') #(##(5 to: 5) #tempDecl 'a') #(##(6
				to: 6) #tempCloseBar '|') #(##(7 to: 7) #specialCharacter ')')).
	text := '##(||)'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 3) #specialCharacter '##(') #(##(4 to: 4) #tempOpenBar '|') #(##(5 to: 5) #tempCloseBar '|') #(##(6
				to: 6) #specialCharacter ')'))!

testTempBarsOrBinarySelector
	"The scanner treats a double vertical bar as a binary selector, yet it can be the close of block arg decls and the open of block temp decls"

	| styler text tokens |
	styler := SmalltalkExpressionStyler new.
	text := '[:a||b|a||b]'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #specialCharacter '[:') #(##(3 to: 3) #blockArgDecl 'a') #(##(4 to: 4) #tempCloseBar '|') #(##(5
				to: 5) #tempOpenBar '|') #(##(6 to: 6) #tempDecl 'b') #(##(7 to: 7) #tempCloseBar '|') #(##(8 to: 8) #identifier 'a') #(##(9
				to: 10) #binaryMessage '||') #(##(11 to: 11) #identifier 'b') #(##(12 to: 12) #specialCharacter ']')).
	text := '[:a| ||a||a]'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #specialCharacter '[:') #(##(3 to: 3) #blockArgDecl 'a') #(##(4 to: 4) #tempCloseBar '|') #(##(5
				to: 5) #whitespace ' ') #(##(6 to: 6) #tempOpenBar '|') #(##(7 to: 7) #tempCloseBar '|') #(##(8
				to: 8) #identifier 'a') #(##(9 to: 10) #binaryMessage '||') #(##(11 to: 11) #identifier 'a') #(##(12
				to: 12) #specialCharacter ']')).
	text := '[:a|||a|||a]'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #specialCharacter '[:') #(##(3 to: 3) #blockArgDecl 'a') #(##(4 to: 4) #tempCloseBar '|') #(##(5
				to: 5) #tempOpenBar '|') #(##(6 to: 6) #tempCloseBar '|') #(##(7 to: 7) #identifier 'a') #(##(8
				to: 10) #binaryMessage '|||') #(##(11 to: 11) #identifier 'a') #(##(12 to: 12) #specialCharacter ']')).
	styler := SmalltalkMethodStyler new.
	text := 'x| |'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #unarySelector 'x') #(##(2 to: 2) #tempOpenBar '|') #(##(3 to: 3) #whitespace ' ') #(##(4
				to: 4) #tempCloseBar '|'))!

testUnaryMessageSequence
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	"Each of the identical identifiers will be coloured differently, except that the last two will be the same"
	text := 'a a a a'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 1) #unarySelector 'a') #(##(2 to: 2) #whitespace ' ') #(##(3 to: 3) #identifier 'a') #(##(4
				to: 4) #whitespace ' ') #(##(5 to: 5) #unaryMessage 'a') #(##(6 to: 6) #whitespace ' ') #(##(7 to: 7) #unaryMessage 'a'))!

testUnaryMessageToArray
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '#(1 2)reverse'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #literalArray '#(') #(##(3 to: 3) #literalNumber '1') #(##(4 to: 4) #whitespace ' ') #(##(5
				to: 5) #literalNumber '2') #(##(6 to: 6) #literalArray ')') #(##(7 to: 13) #unaryMessage 'reverse'))!

testUnaryMessageToBlock
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '[]x'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: #(#(##(1 to: 2) #specialCharacter '[]') #(##(3 to: 3) #unaryMessage 'x'))!

testUnaryMessageToBraceArray
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '{1. 2}reverse'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: {{1 to: 1. #specialCharacter. '{'}.
				{2 to: 2. #literalNumber. '1'}.
				{3 to: 3. #specialCharacter. '.'}.
				{4 to: 4. #whitespace. ' '}.
				{5 to: 5. #literalNumber. '2'}.
				{6 to: 6. #specialCharacter. '}'}.
				{7 to: 13. #unaryMessage. 'reverse'}}!

testUnaryMessageToByteArray
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '#[1]x'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens equals: #(#(##(1 to: 4) #literalBytes '#[1]') #(##(5 to: 5) #unaryMessage 'x'))!

testUnaryMessageToQualifiedReference
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '#{Core.Object}x'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens
		equals: {{1 to: 14. #literalBindingReference. '#{Core.Object}'}.
				{15 to: 15. #unaryMessage. 'x'}}!

testUnaryMessageToString
	| styler text tokens |
	styler := SmalltalkMethodStyler new.
	text := '''s''x'.
	mock text: text.
	styler
		colorTextFrom: 1
		to: text size
		in: mock.
	tokens := mock tokens asArray.
	self assert: tokens equals: {{1 to: 3. #literalString. '''s'''}. {4 to: 4. #unaryMessage. 'x'}}! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #restyleFromEachPosition:resumeable:!private!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #scannerClass!private!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #scanNumeric:class:!private!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #setUp!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #tearDown!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testArrayNoSpace!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testBinaryMethodSignature!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testEmptyTemps!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testLegacyLiteralArray!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testLiteralArray!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testLiteralBytes!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testNegativeOrSubtract!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testOptimizedExpressionInArray!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testPrimitiveTag!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testPseudoSignature!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testQualifiedReferenceIncompleteIdentifier!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testQualifiedReferenceIncompleteQualifiedIdentifier!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testQualifiedReferenceInvalidIdentifier!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testQualifiedReferenceUnterminated!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testScanningFloats!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testScanningIntegers!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testScanningRadixIntegers!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testScanningScaledDecimals!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testTempBarsAtExpressionStart!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testTempBarsOrBinarySelector!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testUnaryMessageSequence!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testUnaryMessageToArray!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testUnaryMessageToBlock!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testUnaryMessageToBraceArray!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testUnaryMessageToByteArray!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testUnaryMessageToQualifiedReference!public!unit tests! !
!Tools.Tests.SmalltalkStylerTest categoriesFor: #testUnaryMessageToString!public!unit tests! !

