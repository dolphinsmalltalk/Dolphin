"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #NumberTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NumberTest guid: (GUID fromString: '{12458306-5b30-4c48-8c24-aed051baabd0}')!
NumberTest comment: 'SUnitBrowser openOnTestCase: self'!
!NumberTest categoriesForClass!Unclassified! !
!NumberTest methodsFor!

scan: aString value: anInteger class: aClass 
	| source result |
	source := aString readStream.
	result := Number readFrom: source.
	self assert: result class == aClass.
	self assert: result = anInteger.
	self assert: source atEnd!

scanNoSeparator: aString value: anInteger next: remainderString 
	| source result actualRemainder |
	source := aString readStream.
	result := Number readFrom: source.
	self assert: result == anInteger.
	actualRemainder := source upToEnd.
	self assert: actualRemainder = remainderString.
	^result!

testClassReadFromColonFloats
	"Test Number>>readFrom: with Floats"

	| source result |
	source := '5.1234' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: (result equals: 5.1234).
	self assert: source atEnd.
	source := '5.1234A' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: (result equals: 5.1234).
	self assert: source next = $A.

	"Test that incomplete exponent ignored"
	source := '0.5e' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: (result equals: 0.5).
	self assert: source next = $e.

	"Zero exponent"
	#('0.5e0' '0.5d0' '0.5q0') do: 
			[:each |
			source := each readStream.
			result := Number readFrom: source.
			self assert: result class == Float.
			self assert: (result equals: 0.5).
			self assert: source atEnd].
	"Zeros"
	source := '0.0' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: result isZero.
	self assert: source atEnd.
	source := '-0.0' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: result isZero.
	self assert: source atEnd.
	self assert: result sign = -1.
	self assert: result = Float negativeZero.

	"Simple fraction"
	source := '0.5' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: (result equals: 1 / 2).
	self assert: source atEnd.

	"Read only integer with trailing full stop"
	source := '5.' readStream.
	result := Number readFrom: source.
	self assert: result class == SmallInteger.
	self assert: result = 5.
	self assert: source next = $..
	source := '5.F' readStream.
	result := Number readFrom: source.
	self assert: result class == SmallInteger.
	self assert: result = 5.
	self assert: source next = $..
	source := '1.0e308' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: result = 1.0e308.
	self assert: source atEnd.
	source := Float fmin printString readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: source atEnd.
	self assert: result printString = source contents.
	source := '1.7976931348623158e308' readStream.
	result := Number readFrom: source.
	self assert: result class == Float.
	self assert: result = Float fmax.
	self assert: source atEnd!

testClassReadFromColonFractions
	"Test Number>>readFrom: with Fractions"

	| source result |

	"A valid fraction"
	source := '1/2' readStream.
	result := Number readFrom: source.
	self assert: (result class == Fraction).
	self assert: (result = (1/2)).
	self assert: (source atEnd).

	"And another larger one"
	source := '18446744073709551616/18446744073709551615' readStream.
	result := Number readFrom: source.
	self assert: (result class == Fraction).
	self assert: (result = (2**64/(2**64-1))).
	self assert: (source atEnd).

	"Fraction with trailing junk"
	source := '1/2A' readStream.
	result := Number readFrom: source.
	self assert: (result class == Fraction).
	self assert: (result = (1/2)).
	self assert: (source next = $A).

	"Initially appears to be a Fraction"
	source := '1//2' readStream.
	result := Number readFrom: source.
	self assert: (result class == SmallInteger).
	self assert: (result = 1).
	self assert: (source upToEnd = '//2').

	"Initially appears to be a Fraction"
	source := '1/A' readStream.
	result := Number readFrom: source.
	self assert: (result class == SmallInteger).
	self assert: (result = 1).
	self assert: (source next = $/).

	"Initially appears to be a Fraction"
	source := '123/' readStream.
	result := Number readFrom: source.
	self assert: (result class == SmallInteger).
	self assert: (result = 123).
	self assert: (source next = $/).
!

testClassReadFromColonIntegers
	"Test Number>>readFrom: with Integers"

	| source result |
	#('0' '-0' '0e1' '1' '1e0' '-1' '123' '-123' '123e0' '123e1' '123e5' '1073741823' '-1073741824' '16rF' '16r3FFFFFFF' '36rZ' '-16r40000000') 
		with: #(0 0 0 1 1 -1 123 -123 123 1230 12300000 1073741823 -1073741824 15 16r3FFFFFFF 35 -16r40000000)
		do: 
			[:eachString :eachInt | 
			self 
				scan: eachString
				value: eachInt
				class: SmallInteger].
	#('1073741824' '-1073741825' '-16r7FFFFFFF' '16r40000000') 
		with: #(1073741824 -1073741825 -16r7FFFFFFF 16r40000000)
		do: 
			[:eachString :eachInt | 
			self 
				scan: eachString
				value: eachInt
				class: LargeInteger].
	#(#('0A' 0 'A') #('-0A' 0 'A') #('123 ' 123 ' ') #('123e' 123 'e') #('123e-' 123 'e-') #('123e+' 123 'e+') #('1r111' 1 'r111') #('37rZZZ' 37 'rZZZ') #('9e+-5' 9 'e+-5')) 
		do: 
			[:each | 
			self 
				scanNoSeparator: each first
				value: each second
				next: each third].
	"Expect Fraction - not ANSI standard syntax, but accepted by St-80"
	source := '123e-5' readStream.
	result := Number readFrom: source.
	self assert: result class == Fraction.
	self assert: result = (123 / 100000).
	self assert: source atEnd!

testClassReadFromColonScaledDecimals
	"Test Number>>readFrom: with ScaledDecimals"

	| source result |

	"ScaledDecimal with decimalInteger mantissa and implied scale of zero"
	source := '123s' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 0).
	self assert: (result = 123).
	self assert: (source atEnd).

	source := '123se' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 0).
	self assert: (result = 123).
	self assert: (source next = $e).

	"ScaledDecimal with decimalInteger mantissa and explicit scale"
	source := '123s2' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 2).
	self assert: (result = 123.0).
	self assert: (source atEnd).

	"Negative scale is not valid"
	source := '123s-2' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 0).
	self assert: (result = 123).
	self assert: (source upToEnd = '-2').

	"ScaledDecimals with Float mantissa and implicit scale"
	source := '123.0s' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 1).
	self assert: (result = 123.0).
	self assert: (source atEnd).

	source := '123.12s' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 2).
	self assert: (result = 123.12).
	self assert: (source atEnd).

	source := '123.12s3' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 3).
	self assert: (result = 123.12).
	self assert: (source atEnd).

	"ScaledDecimals with Float mantissa and explicit scale"
	source := '123.0s' readStream.
	result := Number readFrom: source.
	self assert: (result class == ScaledDecimal).
	self assert: (result scale = 1).
	self assert: (result = 123.0).
	self assert: (source atEnd).

	"Not valid (parsed as Integer)"
	source := '123.s' readStream.
	result := Number readFrom: source.
	self assert: (result == 123).
	self assert: (source upToEnd = '.s').

!

testRoundUpTo
	self should: [1 roundUpTo: 0] raise: ZeroDivide.
	self assert: (1 roundUpTo: 1) = 1.
	self assert: (1 roundUpTo: 2) = 2.
	
	self assert: (21.5 roundUpTo: 1) = 22.
	self assert: (21.5 roundUpTo: 2) = 22.
	self assert: (21.5 roundUpTo: 3) = 24.
	self assert: (21.5 roundUpTo: 5) = 25.
	self assert: (21.5 roundUpTo: 6) = 24.
	self assert: (21.5 roundUpTo: 7) = 28.
	self assert: (21.5 roundUpTo: 8) = 24.
	self assert: (21.5 roundUpTo: 9) = 27.
	self assert: (21.5 roundUpTo: 10) = 30.

	self assert: ((1.4@2.6) roundUpTo: (1@2)) = (2@4).
! !
!NumberTest categoriesFor: #scan:value:class:!helpers!private! !
!NumberTest categoriesFor: #scanNoSeparator:value:next:!private!unit tests! !
!NumberTest categoriesFor: #testClassReadFromColonFloats!public!unit tests! !
!NumberTest categoriesFor: #testClassReadFromColonFractions!public!unit tests! !
!NumberTest categoriesFor: #testClassReadFromColonIntegers!public!unit tests! !
!NumberTest categoriesFor: #testClassReadFromColonScaledDecimals!public!unit tests! !
!NumberTest categoriesFor: #testRoundUpTo!public!unit tests! !

