"Filed out from Dolphin Smalltalk"!

SmalltalkScanner subclass: #SmalltalkStylingScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkStylingScanner guid: (GUID fromString: '{70ef9a14-3293-4d33-968e-87e0a406b952}')!
SmalltalkStylingScanner comment: 'SmalltalkStylingScanner is a <SmalltalkScanner> specialized for the purpose of real-time syntax colouring. It differs from its superclass in two ways:
- It is tolerant of lexical errors, and returns error tokens rather than raising exceptions. This is appropriate for scanning source text that is being edited, since at any time it may be in an incomplete state.
- When scanning numbers it does not convert them from a string to a numberical value unless required. This avoids a perf issue should someone enter a number literal that takes a long time to compute, e.g. 1e30000'!
!SmalltalkStylingScanner categoriesForClass!System-Compiler! !
!SmalltalkStylingScanner methodsFor!

newFloatToken: significandInteger precision: precisionInteger exponent: exponentInteger
	"Private -Return a new literal number token with a <Float> value. We don't need the actual
	<Float> value for styling purposes, so can avoid the final cost of computing it, which may
	not be cheap if the exponent is large."

	^self numberTokenClass
		start: tokenStart
		comments: nil
		value: significandInteger sign asFloat
		stop: self previousStepPosition!

newIntegerToken: significandInteger exponent: exponentInteger
	"Private -Return a new literal number token with an integer value. We don't need the actual
	<Integer> value for styling purposes, so can avoid the final cost of computing it by largely 
	ignoring the exponent (if any)."

	^StNumberLiteralToken
		start: tokenStart
		comments: nil
		value: (exponentInteger negative ifTrue: [significandInteger sign / 2] ifFalse: [significandInteger])
		stop: self previousStepPosition!

newScaledDecimalToken: significandInteger precision: precisionInteger scale: scaleInteger
	"Private -Return a new literal number token with a <ScaledDecimal> value. We don't need the
	actual value for styling purposes, so can avoid the final cost of computing it, which may
	not be insignificant since this involves exponentiation and fractional arithmetic."

	^self numberTokenClass
		start: tokenStart
		comments: nil
		value: (significandInteger negative ifTrue: [-1s] ifFalse: [1s])
		stop: self previousStepPosition!

reportError: anInteger at: posInteger line: lineInteger range: anInterval extras: anArray
	"Private - Report a lexical error."

	"Implementation Note: The error is effectively ignored, and the scanner will recover by
	creating an appropriate 'error' token which is of the correct type (if possible) so that the
	styling/auto-completion remain as useful as possible."

	! !
!SmalltalkStylingScanner categoriesForMethods!
newFloatToken:precision:exponent:!helpers!private! !
newIntegerToken:exponent:!helpers!private! !
newScaledDecimalToken:precision:scale:!helpers!private! !
reportError:at:line:range:extras:!error handling!private! !
!

