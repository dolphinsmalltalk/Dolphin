"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.ScannerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.ScannerTest guid: (Core.GUID fromString: '{f7b5ab2e-148e-4a76-acbc-60ae422b54ef}')!

Kernel.Tests.ScannerTest comment: ''!

!Kernel.Tests.ScannerTest methodsFor!

assertToken: aStToken isChar: aCharacter
	self assert: aStToken isLiteralToken.
	aCharacter codePoint < 16r80
		ifTrue: [self assert: aStToken value identicalTo: aCharacter]
		ifFalse: [self assert: aStToken value equals: aCharacter]!

scan: aString tokenClass: tokenClass valueClass: valueClass
	| token subject |
	subject := self scannerClass on: aString readStream.
	token := subject next.
	self assert: token class equals: tokenClass.
	self assert: token value isKindOf: valueClass.
	^token!

scannerClass
	^Scanner!

scanNonNumericEnd: aString class: valueClass
	| expected stream extra scanner actual next |
	stream := aString readStream.
	expected := Number readSmalltalkSyntaxFrom: stream.
	extra := stream upToEnd.
	stream reset.
	scanner := self scannerClass on: stream.
	actual := scanner next.
	self assert: actual isKindOf: StNumberLiteralToken.
	self assert: actual value class equals: valueClass.
	self assert: actual value equals: expected.
	next := scanner next.
	self assert: (extra beginsWith: next value)!

scanNumber: aString valueClass: valueClass
	| expected token |
	token := self
				scan: aString
				tokenClass: StNumberLiteralToken
				valueClass: valueClass.
	expected := Number readFrom: aString readStream.
	self assert: token value equals: expected.
	^token!

testCharacterScanning
	| subject tok |
	subject := self scannerClass on: '$a$b$\t$\$  $c' readStream.
	tok := subject next.
	self assertToken: tok isChar: $a.
	self assert: tok sourceInterval equals: (1 to: 2).
	tok := subject next.
	self assertToken: tok isChar: $b.
	self assert: tok sourceInterval equals: (3 to: 4).
	tok := subject next.
	self assertToken: tok isChar: Character tab.
	self assert: tok sourceInterval equals: (5 to: 7).
	tok := subject next.
	self assertToken: tok isChar: $\.
	self assert: tok sourceInterval equals: (8 to: 9).
	tok := subject next.
	self assertToken: tok isChar: Character space.
	self assert: tok sourceInterval equals: (10 to: 11).
	tok := subject next.
	self assertToken: tok isChar: $c.
	self assert: tok sourceInterval equals: (13 to: 14).
	0 to: 255
		do: 
			[:i |
			| char ch source interval |
			ch := Character value: i.
			subject := self scannerClass on: ch printString readStream.
			char := subject next.
			self assertToken: char isChar: ch.
			self assert: subject next isEof.
			source := ' $\x<1s> ' expandMacrosWith: (i printStringBase: 16).
			subject := self scannerClass on: source readStream.
			char := subject next.
			self assertToken: char isChar: ch.
			interval := char sourceInterval.
			self assert: interval equals: (2 to: source size - 1).
			self assert: subject next isEof].
	subject := self scannerClass on: ' $\. ' readStream.
	tok := subject next.
	self assertToken: tok isChar: (Character value: 92).
	self assert: tok sourceInterval equals: (2 to: 3).
	self assert: (subject next isSpecial: $.).
	subject := self scannerClass on: '$\c' readStream.
	tok := subject next.
	self assertToken: tok isChar: (Character value: 92).
	self assert: tok sourceInterval equals: (1 to: 2).
	tok := subject next.
	self assert: tok isIdentifier.
	self assert: tok value equals: 'c'.
	subject := self scannerClass on: '$\xAG' readStream.
	tok := subject next.
	self assertToken: tok isChar: (Character value: 16rA).
	self assert: tok sourceInterval equals: (1 to: 4).
	tok := subject next.
	self assert: tok isIdentifier.
	self assert: tok value equals: 'G'!

testFloatScanning
	Float reset.
	#('-5.1234' '0.0' '0.5' '1.2e1' '1.2d2' '1.2e-1' '1.2e+1' '1.2d-2' '1.2d+2' '1.0e308' '1.0e+308' '2.2250738585072014e-308' '1.7976931348623158e308' '1.7976931348623158e+308' '0.5e0' '0.5d0' '0.5q0' '0.5e+0' '0.5d+0' '0.5q+0' '0.5e-0' '0.5d-0' '0.5q-0')
		do: 
			[:each |
			self
				scanNumber: each
				valueClass: Float].

	"Integer terminated by a period, not a float"
	self assert: (self scannerClass on: '5.' readStream) next value identicalTo: 5.
	self assert: (self scannerClass on: '1.0e-316' readStream) next value equals: 10.0 ** -316.

	"Test termination on non-numeric character - these expressions are in error"
	#('5.1234a' '0.5e' '1.5e2e3' '1.5e2e-3' '1.5e-Integer zero' '1.5e-' '1.5e+' '1.7976931348623158+e308')
		do: [:each | self scanNonNumericEnd: each class: Float].
	self scanNonNumericEnd: '5.F' class: SmallInteger!

testIntegerScanning
	"Test Number>>readFrom: with Integers"

	| source subject token |
	#('0' '-0' '1' '-1' '-1.' '123.' '123 ' '1073741823' '-1073741824' '1e1' '1e+1' '1073741823e0' '1073741823e-0' '-1073741823e-0')
		do: [:each | self scanNumber: each valueClass: SmallInteger].
	#('1e-1' '1e-307') do: [:each | self scanNumber: each valueClass: Fraction].
	#('1073741824' '-1073741825' '2147483647' '2147483649' '-2147483648' '-2147483649' '1e308')
		do: [:each | self scanNumber: each valueClass: LargeInteger].
	#('0A' '-0A' '123e' '1e1e2' '1e+-2' '2r2' '1eA')
		do: [:each | self scanNonNumericEnd: each class: SmallInteger].

	"Radix integer terminated by digit that is out of range of the radix"
	subject := self scannerClass on: '2r1012' readStream.
	token := subject next.
	self assert: token value identicalTo: 5.
	token := subject next.
	self assert: token value identicalTo: 2.
	self assert: subject atEnd.

	"Initially appears to be negative exponent"
	source := '123e-'.
	subject := self scannerClass on: source readStream.
	token := subject next.
	self assert: token class equals: StNumberLiteralToken.
	self assert: token value identicalTo: 123.
	token := subject next.
	self assert: token class equals: StIdentifierToken.
	self assert: token value equals: 'e'.
	token := subject next.
	self assert: token class equals: StBinarySelectorToken.
	self assert: token value equals: '-'!

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
					self scanNumber: eachVal printString valueClass: Integer.
					"Now test again with a radix prefix"
					#(2 10 16 36) do: 
							[:eachRadix |
							self assert: (self scanNumber: (eachVal printStringRadix: eachRadix) valueClass: Integer) value
								equals: eachVal]]]!

testIsSelector
	#(#a #ab #a: #ab: #a:b: #< #<= '*' '~~' #- #+ '_' '_:' '_:_:' '@' ',' #\ #/ '?')
		do: [:each | self assert: (Scanner isSelector: each)].
	#(':' '::' '' ' ' '$' '.' '#' '(' ')' '£' '🐬' '`' '"' '''' '1' 'a:b' 'a::' ';' '{' '[' '}' ']' 'ınteresting' 'camión')
		do: [:each | self deny: (Scanner isSelector: each)].
	self deny: (Scanner isSelector: String lineDelimiter)!

testIsStaticVariable
	#('_a' '_' '_A' 'A' 'Abc' 'A1' '_1' 'A_b')
		do: [:each | self assert: (Scanner isStaticVariable: each)].
	#(' ' 'a' 'a_' 'abc' '123' ':' '::' '' ' ' '$' '.' '#' '(' ')' '£' '🐬' '`' '"' '''' '1' 'a:b' 'a::' ';' '{' '[' '}' ']' 'ınteresting' 'camión')
		do: [:each | self deny: (Scanner isStaticVariable: each)]!

testScanningScaledDecimals
	"Test Number>>readFrom: with ScaledDecimals"

	| subject token |
	#('123s' '123s2' '123.0s' '123.12s' '123.12s2' '123.12s3')
		do: [:each | self scanNumber: each valueClass: ScaledDecimal].
	subject := self scannerClass on: '123s-2' readStream.
	token := subject next.
	self assert: token isKindOf: StNumberLiteralToken.
	self assert: token value class identicalTo: ScaledDecimal.
	self assert: token value scale equals: 0.
	self assert: token value equals: 123.
	token := subject next.
	self assert: token isKindOf: StNumberLiteralToken.
	self assert: token value identicalTo: -2.
	#('123se' '123.0se' '123.0s2e') do: [:each | self scanNonNumericEnd: each class: ScaledDecimal].
	subject := self scannerClass on: '123.s' readStream.
	token := subject next.
	self assert: token isKindOf: StNumberLiteralToken.
	self assert: token value identicalTo: 123.
	token := subject next.
	self assert: token isKindOf: StSpecialCharacterToken.
	self assert: token value equals: $.!

testScanQualifiedNames
	| subject token |
	subject := Scanner on: 'Ab.' readStream.
	token := subject next.
	self assert: token isKindOf: StIdentifierToken.
	self assert: token value equals: 'Ab'.
	self assert: token sourceInterval equals: (1 to: 2).
	token := subject next.
	self assert: token isKindOf: StSpecialCharacterToken.
	self assert: token value identicalTo: $..
	self assert: token sourceInterval equals: (3 to: 3).
	self assert: subject atEnd.
	subject := Scanner on: 'A.9' readStream.
	token := subject next.
	self assert: token isKindOf: StIdentifierToken.
	self assert: token value equals: 'A'.
	self assert: token sourceInterval equals: (1 to: 1).
	token := subject next.
	self assert: token isKindOf: StSpecialCharacterToken.
	self assert: token value identicalTo: $..
	self assert: token sourceInterval equals: (2 to: 2).
	token := subject next.
	self assert: token isKindOf: StNumberLiteralToken.
	self assert: token value identicalTo: 9.
	self assert: token sourceInterval equals: (3 to: 3).
	self assert: subject atEnd.
	subject := Scanner on: 'Abc.D.9' readStream.
	token := subject next.
	self assert: token isKindOf: StIdentifierToken.
	self assert: token value equals: 'Abc.D'.
	self assert: token sourceInterval equals: (1 to: 5).
	token := subject next.
	self assert: token isKindOf: StSpecialCharacterToken.
	self assert: token value identicalTo: $..
	self assert: token sourceInterval equals: (6 to: 6).
	token := subject next.
	self assert: token isKindOf: StNumberLiteralToken.
	self assert: token value identicalTo: 9.
	self assert: token sourceInterval equals: (7 to: 7).
	self assert: subject atEnd!

testSpecialLiterals
	| subject token |
	subject := Scanner on: 'nil.true false nil:Nil' readStream.
	token := subject next.
	self assert: token isKindOf: StLiteralToken.
	self assertIsNil: token value.
	self assert: token sourceInterval equals: (1 to: 3).
	token := subject next.
	self assert: token isKindOf: StSpecialCharacterToken.
	self assert: token value identicalTo: $..
	self assert: token sourceInterval equals: (4 to: 4).
	token := subject next.
	self assert: token isKindOf: StLiteralToken.
	self assert: token value.
	self assert: token sourceInterval equals: (5 to: 8).
	token := subject next.
	self assert: token isKindOf: StLiteralToken.
	self deny: token value.
	self assert: token sourceInterval equals: (10 to: 14).
	token := subject next.
	self assert: token isKindOf: StKeywordToken.
	self assert: token value equals: 'nil:'.
	self assert: token sourceInterval equals: (16 to: 19).
	token := subject next.
	self assert: token isKindOf: StIdentifierToken.
	self assert: token value equals: 'Nil'.
	self assert: token sourceInterval equals: (20 to: 22)!

testStringLiteralWithEmbeddedNulls
	"String literals should be able to contain with embedded nulls."

	| stringWithNull token subject |
	stringWithNull := String
				with: $a
				with: $\0
				with: $b.
	subject := self scannerClass on: ('''' , stringWithNull , '''') readStream.
	token := subject next.
	self assert: token isKindOf: StLiteralToken.
	self assert: token value equals: stringWithNull!

testSymbolScanning
	#('#a' '#a1' '#a:' '#a1:' '#a:b:' '#a_:_:' '#a1:b2:' '#|' '#||' '#|||' '#_' '#_a' '#-' '#''£''' '#''你好''' '#''🐬''')
		do: 
			[:each |
			| token chars |
			token := self
						scan: each
						tokenClass: StLiteralSymbolToken
						valueClass: Symbol.
			self denyIsNil: token value.
			chars := (each copyFrom: 2) copyWithout: $'.
			self assert: token sourceInterval equals: (1 to: each size).
			self assert: token value equals: chars].
	'#--'.
	#('#2' '#;' '#:') do: 
			[:each |
			| subject token err |
			subject := self scannerClass on: each readStream.
			token := [subject next] on: CompilerErrorNotification
						do: 
							[:ex |
							err := ex.
							ex resume].
			self assert: err tag equals: Kernel.ParseErrorCodes.LErrExpectConst.
			self assert: err position = 2.
			self assert: token isKindOf: StLiteralToken.
			self assert: token value equals: ''.
			self assert: token sourceInterval equals: (1 to: 1).
			self deny: subject atEnd].
	#('#a:a' '#a:ab' '#ab:a' '#ab:ab') do: 
			[:each |
			| subject token stop |
			subject := self scannerClass on: each readStream.
			token := subject next.
			self assert: token isKindOf: StLiteralToken.
			stop := each indexOf: $:.
			self assert: token value identicalTo: (each copyFrom: 2 to: stop) asSymbol.
			self assert: token sourceInterval equals: (1 to: stop).
			self deny: subject atEnd].
	'#--'! !

!Kernel.Tests.ScannerTest categoriesForMethods!
assertToken:isChar:!helpers!private! !
scan:tokenClass:valueClass:!helpers!private! !
scannerClass!constants!private! !
scanNonNumericEnd:class:!helpers!private! !
scanNumber:valueClass:!helpers!private! !
testCharacterScanning!public!unit tests! !
testFloatScanning!public!unit tests! !
testIntegerScanning!public!unit tests! !
testIntegerScanningBoundaries!public!unit tests! !
testIsSelector!public!unit tests! !
testIsStaticVariable!public!unit tests! !
testScanningScaledDecimals!public!unit tests! !
testScanQualifiedNames!public!unit tests! !
testSpecialLiterals!public!unit tests! !
testStringLiteralWithEmbeddedNulls!public!unit tests! !
testSymbolScanning!public!unit tests! !
!

