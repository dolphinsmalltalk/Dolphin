"Filed out from Dolphin Smalltalk 7"!

Core.ArithmeticError subclass: #'Core.ZeroDivide'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ZeroDivide guid: (Core.GUID fromString: '{87b4c563-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.ZeroDivide comment: '`ZeroDivide` is the class of `ArithmeticError` for representing attempts at division by zero.

`ZeroDivide` is resumable when triggered by floating point division by zero (i.e. either operand is a floating point number). When resumed the result should be a continuation value (generally ∞ or -∞, but may also be NaN if a NaN was being divided by zero). Integer division by zero (i.e. both operands are integers) is not resumable, because there is no suitable continuation value (i.e., no representation of infinity).

Examples:

Evaluate the following to cause `ZeroDivide` exceptions to be raised.
```
	1 / 0.
	1.23 / 0.0.
	[1.2 / -0.0] on: ZeroDivide do: [:e | e resume]. 	"=> Float.NegativeInfinity"
```'!
!Core.ZeroDivide categoriesForClass!Kernel-Exception Handling! !
!Core.ZeroDivide methodsFor!

_descriptionFormat
	"Answer the description format string for the receiver."

	^'Division by zero of %2'!

dividend
	"Answer the <number> that was divided by zero."

	^self tag!

isResumable
	"Answer whether the receiver represents a resumable error. 
		- Floating point division by zero is continuable as there is a suitable resumption value (∞ or -∞). 
		- Integer division by zero is not continuable, so resumption is disallowed."

	^self dividend isInteger not! !
!Core.ZeroDivide categoriesFor: #_descriptionFormat!displaying!public! !
!Core.ZeroDivide categoriesFor: #dividend!accessing!public! !
!Core.ZeroDivide categoriesFor: #isResumable!public!testing! !

Core.ZeroDivide methodProtocol: #ZeroDivide attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #dividend #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Core.ZeroDivide class methodsFor!

dividend: argument
	"Signal the occurrence of an integer division by zero."

	^self signalWith: argument! !
!Core.ZeroDivide class categoriesFor: #dividend:!instance creation!public! !

Core.ZeroDivide class methodProtocol: #'ZeroDivide factory' attributes: #(#ansi #readOnly) selectors: #(#, #dividend: #handles: #new #signal #signal:)!

