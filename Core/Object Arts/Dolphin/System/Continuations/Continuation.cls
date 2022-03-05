"Filed out from Dolphin Smalltalk"!

Object subclass: #Continuation
	instanceVariableNames: 'stack'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Continuation guid: (GUID fromString: '{04fb1134-b5e1-4651-b95b-aee8814a0ec6}')!
Continuation comment: 'Dolphin implementation of the Call Continuation class inspired by that implemented for Seaside in Squeak by Avi Bryant.

A Continuation represents the pending execution stack of a partially completed computation (or process), captured at some particular point. The Contination can be resumed by restarting it with a particular value (Continuation supports the <monadicValuable> protocol), at which point the computation takes off again from the point at which it was captured. A Continuation may be continued in this way as many times as desired, and because it can be continued with different values the end result of each computation can be different.

In effect a Continuation reifies the dynamic execution state of a Process at a particular point in time as a first-class object. This is achieved by making an independent copy of the execution stack (which in Dolphin equates to copying the <Process>). The copy shares no temporary variable (or stack) slots with the source, and so is not affected by the activity of the source after the copy is taken. It is worth bearing in mind, however, that any side effects of operations performed during the compuation (for example the manipulation of global counters) may introduce undesirable interdependencies between the continuations.

We believe the implementation of this class to be largely portable with the exception of #continue:with:, which restarts the copied stack in a Dolphin specific manner, terminating the calling process too (though note that this is delegated off to the Process). The means by which the stack is actually copied is very Dolphin specific, see the <ProcessCopier> class for more details.
'!
!Continuation categoriesForClass!System-Continuations! !
!Continuation methodsFor!

argumentCount
	"Answer the <integer> number of arguments expected by the receiver."

	^1!

continue: aProcess with: anObject
	aProcess continueWith: anObject!

oneShotValue
	"Escape to the original process with the nil as the return value to the 
	suspended frame. The currently active process is terminated."

	self oneShotValue: nil!

oneShotValue: anObject
	"Escape to the original process with the argument as the return value to the 
	suspended frame. The currently active process is terminated."

	self continue: stack with: anObject!

stack
	^stack!

stack: aProcess
	stack := aProcess!

value
	self value: nil!

value: anObject
	"Continue a copy of the original process with the specified as the return value
	to the suspended frame. The currently active process is terminated."

	self continue: stack copy with: anObject!

valueWithArguments: anArray
	^anArray size == 1 
		ifTrue: [self value: anArray first]
		ifFalse: [self error: 'Continuation is only possible with a single argument']! !
!Continuation categoriesForMethods!
argumentCount!accessing!public! !
continue:with:!helpers!private! !
oneShotValue!evaluating!public! !
oneShotValue:!evaluating!public! !
stack!accessing!private! !
stack:!accessing!private! !
value!evaluating!public! !
value:!evaluating!public! !
valueWithArguments:!evaluating!public! !
!

Continuation methodProtocol: #monadicValuable attributes: #(#readOnly) selectors: #(#argumentCount #value: #valueWithArguments:)!

!Continuation class methodsFor!

factorialExample: x
	"Modified from the example given in Dybvig p. 81 (the example is 
	explained adequately there). Evaluate each of the following expressions 
	in turn (and be prepared for a slight surprise in the current selection, 
	especially if you used 'Display-it' to evaluate the first expression!!).

	Transcript cr; show: (Continuation factorialExample: 4) printString; cr

	(Smalltalk at: #RetryCC) value: 2

	(Smalltalk at: #RetryCC) value: 5

	Smalltalk removeKey: #RetryCC
	"

	^x == 0 
		ifTrue: [
			[:continuation | 
			Smalltalk at: #RetryCC put: continuation.
			1] callCC]
		ifFalse: [x * (self factorialExample: x - 1)]!

fromContext: aStackFrame
	^self new stack: aStackFrame copyStack! !
!Continuation class categoriesForMethods!
factorialExample:!examples!public! !
fromContext:!instance creation!public! !
!

