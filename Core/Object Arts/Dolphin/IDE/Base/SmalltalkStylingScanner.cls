"Filed out from Dolphin Smalltalk 7"!

SmalltalkScanner subclass: #SmalltalkStylingScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkStylingScanner guid: (GUID fromString: '{70EF9A14-3293-4D33-968E-87E0A406B952}')!
SmalltalkStylingScanner comment: 'SmalltalkStylingScanner is a <SmalltalkScanner> specialized for the purpose of real-time syntax colouring. It differs from its superclass in two ways:
- It is tolerant of lexical errors, and returns error tokens rather than raising exceptions. This is appropriate for scanning source text that is being edited, since at any time it may be in an incomplete state.
- When scanning numbers it does not convert them from a string to a numberical value unless required. This avoids a perf issue should someone enter a number literal that takes a long time to compute, e.g. 1e30000'!
!SmalltalkStylingScanner categoriesForClass!Development! !
!SmalltalkStylingScanner methodsFor!

constantExpected
	^self literalErrorToken: #'' start: self previousStepPosition!

lexicalError: anInteger range: anInterval 
	"Private - Evaluate the error block passing it an appropriately initialised <exception>.
	If the block returns, signal the exception."

	"Implementation Note: The error is ignored, and recovered from."

	!

newNumberToken: numberClass 
	| stop |
	stop := self previousStepPosition.
	^(self numberTokenClass 
		value: nil
		start: tokenStart
		stop: stop
		source: (stream copyFrom: tokenStart to: stop))
		numberClass: numberClass;
		yourself!

numberTokenClass
	^StNumberStylingToken!

scanExponentInteger
	"Allow plus prefix on exponent, e.g. 2e+16, although not strictly Smalltalk syntax."

	| pos isNegative |
	pos := stream position.
	self step.
	((isNegative := currentCharacter == $-) or: [currentCharacter == $+]) ifTrue: [self step].
	(self skipIntegerOfRadix: 10) 
		ifTrue: 
			[isNegative 
				ifTrue: 
					[| exp |
					exp := stream copyFrom: pos+2 to: self previousStepPosition.
					(exp allSatisfy: [:each | each == $0]) ifFalse: [^Fraction]]]
		ifFalse: [self stepBackTo: pos].
	^Integer!

scanNumber
	| numberClass start |
	currentCharacter == $- 
		ifTrue: 
			["isNegative := true."
			self step].
	start := stream position.
	(self skipIntegerOfRadix: 10) 
		ifFalse: 
			["This should not happen since we have previously detected a digit"
			^self error: 'internal error'].
	self atEnd ifTrue: [^self newNumberToken: Integer].
	"The type of number is determined by what we find next"
	numberClass := Integer.
	currentCharacter == $. 
		ifTrue: [numberClass := self scanSmalltalkReal]
		ifFalse: 
			[currentCharacter == $r 
				ifTrue: 
					[| radix |
					radix := Integer 
								readPositiveFrom: (stream copyFrom: start to: self previousStepPosition) readStream
								radix: 10.
					(radix between: 2 and: 36) 
						ifTrue: 
							[| pos |
							pos := stream position.
							self step.
							(self skipIntegerOfRadix: radix) 
								ifTrue: [currentCharacter == $e ifTrue: [numberClass := self scanExponentInteger]]
								ifFalse: [self stepBackTo: pos]]]
				ifFalse: 
					[currentCharacter == $s 
						ifTrue: 
							[self step.	"s will always be part of token, regardless if there is a scale value"
							self skipIntegerOfRadix: 10.
							numberClass := ScaledDecimal]
						ifFalse: 
							["Also support St-80 format integer of the form 1e5, not valid ANSI syntax though"
							currentCharacter == $e ifTrue: [numberClass := self scanExponentInteger]]]].
	^self newNumberToken: numberClass!

scanSmalltalkReal
	(self classify: stream peek) == #digit 
		ifFalse: 
			["Trailing full stop on integer"
			^Integer].
	self step.
	self skipIntegerOfRadix: 10.

	"Process any exponent..."
	(currentCharacter == $e or: [currentCharacter == $d or: [currentCharacter == $q]]) 
		ifTrue: 
			[| exponentStart |
			exponentStart := stream position.
			self step.	"Skip the exponent character"
			"Allow plus prefix on the exponent, although not ANSI Smalltalk syntax"
			(currentCharacter == $- or: [currentCharacter == $+]) ifTrue: [self step].
			(self skipIntegerOfRadix: 10) 
				ifFalse: 
					["Found Float with trailing exponent character which is not
					 part of the number, e.g. 1.5e From ANSI standard p 28: 'An
					 exponentLetter must be followed by an explicit exponent'"
					self stepBackTo: exponentStart]]
		ifFalse: 
			[currentCharacter == $s 
				ifTrue: 
					[self step.	"Skip the $s"
					self skipIntegerOfRadix: 10.
					^ScaledDecimal]].
	^Float!

skipIntegerOfRadix: radix 
	| found |
	found := false.
	[self atEnd] whileFalse: 
			[| digit |
			((digit := currentCharacter digitValue) < radix and: [digit >= 0]) 
				ifTrue: 
					[self step.
					found := true]
				ifFalse: [^found]].
	^found!

stepBackTo: exponentStart 
	stream position: exponentStart - 1.
	self step! !
!SmalltalkStylingScanner categoriesFor: #constantExpected!public! !
!SmalltalkStylingScanner categoriesFor: #lexicalError:range:!error handling!private! !
!SmalltalkStylingScanner categoriesFor: #newNumberToken:!private! !
!SmalltalkStylingScanner categoriesFor: #numberTokenClass!public! !
!SmalltalkStylingScanner categoriesFor: #scanExponentInteger!public!scanning! !
!SmalltalkStylingScanner categoriesFor: #scanNumber!public!scanning! !
!SmalltalkStylingScanner categoriesFor: #scanSmalltalkReal!public!scanning! !
!SmalltalkStylingScanner categoriesFor: #skipIntegerOfRadix:!public!scanning! !
!SmalltalkStylingScanner categoriesFor: #stepBackTo:!private! !

