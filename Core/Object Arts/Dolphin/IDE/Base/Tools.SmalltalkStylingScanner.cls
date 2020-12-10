"Filed out from Dolphin Smalltalk 7"!

Kernel.Scanner subclass: #'Tools.SmalltalkStylingScanner'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkStylingScanner guid: (Core.GUID fromString: '{70ef9a14-3293-4d33-968e-87e0a406b952}')!
Tools.SmalltalkStylingScanner comment: 'SmalltalkStylingScanner is a <SmalltalkScanner> specialized for the purpose of real-time syntax colouring. It differs from its superclass in two ways:
- It is tolerant of lexical errors, and returns error tokens rather than raising exceptions. This is appropriate for scanning source text that is being edited, since at any time it may be in an incomplete state.
- When scanning numbers it does not convert them from a string to a numberical value unless required. This avoids a perf issue should someone enter a number literal that takes a long time to compute, e.g. 1e30000'!
!Tools.SmalltalkStylingScanner categoriesForClass!System-Compiler! !
!Tools.SmalltalkStylingScanner methodsFor!

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

	!

scanQualifiedReference
	"Private - For styling purposes it makes sense to scan binding references in their entirety, as opposed to parsing them, as this makes them easier to style and auto-complete. It doesn't make for an elegant code solution, however, especially in the handling of error cases. Fortunately we don't need sophisticated error reporting in the styling scanner - we just want to terminate parsing the QR as soon as we detect an error so that the colouring stops at the point the QR becomes invalid."

	| bindingRef type |
	self step.	"{"
	self stripSeparators.
	characterType == #alphabetic
		ifFalse: [^self literalErrorToken: (BindingReference pathString: '') stop: self previousStepPosition].
	self scanName.
	[currentCharacter == $. and: [(self classify: stream peek) == #alphabetic]] whileTrue: 
			[buffer nextPut: $..
			self step.
			self scanName].
	bindingRef := BindingReference pathString: buffer contents.
	self stripSeparators.
	characterType == #alphabetic
		ifFalse: 
			["Avoid name validation done by BindingReference class>>path:, as we don't want this to error."
			^currentCharacter == $}
				ifTrue: 
					[self step.
					self literalTokenClass
						start: tokenStart
						comments: nil
						value: bindingRef
						stop: self previousStepPosition]
				ifFalse: [self literalErrorToken: bindingRef stop: self previousStepPosition]].
	
	[buffer reset.
	self scanName.
	type := buffer contents.
	type = 'class'
		ifTrue: [bindingRef := bindingRef meta]
		ifFalse: 
			[type = 'private'
				ifTrue: [bindingRef isPrivate: true]
				ifFalse: [^self literalErrorToken: bindingRef stop: self previousStepPosition]].
	self stripSeparators.
	characterType == #alphabetic]
			whileTrue.
	currentCharacter == $}
		ifFalse: [^self literalErrorToken: bindingRef stop: self previousStepPosition].
	self step.	"}"
	^self literalTokenClass
		start: tokenStart
		comments: nil
		value: bindingRef
		stop: self previousStepPosition! !
!Tools.SmalltalkStylingScanner categoriesFor: #newFloatToken:precision:exponent:!helpers!private! !
!Tools.SmalltalkStylingScanner categoriesFor: #newIntegerToken:exponent:!helpers!private! !
!Tools.SmalltalkStylingScanner categoriesFor: #newScaledDecimalToken:precision:scale:!helpers!private! !
!Tools.SmalltalkStylingScanner categoriesFor: #reportError:at:line:range:extras:!error handling!private! !
!Tools.SmalltalkStylingScanner categoriesFor: #scanQualifiedReference!private!scanning! !

