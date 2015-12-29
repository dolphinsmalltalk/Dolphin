"Filed out from Dolphin Smalltalk X6"!

ArithmeticError subclass: #ZeroDivide
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ZeroDivide guid: (GUID fromString: '{87B4C563-026E-11D3-9FD7-00A0CC3E4A32}')!
ZeroDivide comment: 'ZeroDivide is the class of <Error> for representing attempts at integer division by zero.
Floating point division by zero exceptions are raised as instances of <FloatingPointException>.

For an example of ZeroDivide in action, evaluate the following:
	1/0'!
!ZeroDivide categoriesForClass!Kernel-Exception Handling! !
!ZeroDivide methodsFor!

_descriptionFormat
	"Answer the description format string for the receiver."

	^'Division by zero of %2'!

dividend
	"Answer the <number> that was divided by zero."

	^self tag!

isResumable
	"Answer whether the receiver represents a resumable error. 
	Division by zero is not considered fatal, so allow resumption."

	^true! !
!ZeroDivide categoriesFor: #_descriptionFormat!displaying!public! !
!ZeroDivide categoriesFor: #dividend!accessing!public! !
!ZeroDivide categoriesFor: #isResumable!public!testing! !

ZeroDivide methodProtocol: #ZeroDivide attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #dividend #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!ZeroDivide class methodsFor!

dividend: argument
	"Signal the occurrence of an integer division by zero."

	^self signalWith: argument! !
!ZeroDivide class categoriesFor: #dividend:!instance creation!public! !

ZeroDivide class methodProtocol: #'ZeroDivide factory' attributes: #(#ansi #readOnly) selectors: #(#, #dividend: #handles: #new #signal #signal:)!

