"Filed out from Dolphin Smalltalk"!

Core.ArithmeticError
	subclass: #'Core.FloatingPointException'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.FloatingPointException guid: (Core.GUID fromString: '{87b4c562-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.FloatingPointException comment: '`FloatingPointException` is the class of `ArithmeticError` raised when a floating point operation in a primitive or external library call encounters an unmasked error condition. Each such exception carries information as to the operands involved, the operation that faulted, and the error cause(s). The possible error causes are:
	`#Inexact`			- the operation resulted in a loss of precision (quite likely with FP arithmetic)
	`#Underflow` 			- the operation underflowed the normal representable range (i.e. the absolute value was less than `Float fminNormalized`)
	`#Overflow` 			- the operation overflowed the representable range (i.e. the absolute value was greater than `Float fmax`)
	`#ZeroDivide` 			- a divide operation with a divisor of positive or negative zero was attempted. Note, however, that `#ZeroDivide` exceptions are translated to instances of `ZeroDivide` for consistency with integer division-by-zero.
	`#InvalidOperation`		- the operation was invalid for the operand or operands, e.g. taking the square root of a negative number.

Multiple error causes may be associated with a raised `FloatingPointException`, depending on the CPU floating point status flags at the time the exception is detected and raised.

The `tag` associated with a `FloatingPointException` will be an instance of the structure `_FPIEEE_RECORD`. This can be queried to determine details of the faulting operation and its operands.

The classes of floating-point error that will results in a `FloatingPointException` being raised depends on the floating-point exception mask that is active at the time of the operation. The mask is set by `Float class>>#exceptionMask`, but stored on a per-`Process` basis, i.e. each Smalltak `Process` can have an independent exception mask, which the VM switches when scheduling processes. By default, the Inexact, Overflow and Underflow exceptions will be ''masked'' (i.e. not raised).

As specified by ISO 10967, clause 6, a compliant implementation can support a number of alternate means for applications to detect FP errors:
  1. Notification by recording in indicators (see clause 6.2.1).
  1. Notification by alteration of control flow (see clause 6.2.2).
  1. Notification by termination with message (see clause 6.2.3). 

These alternates are supported in Dolphin as follows:
  1. Indicators are accessed via Float class>>statusFlags, e.g. after detecting an infinite result.
  1. Implemented by raising of exceptions, depending on the Float class>>exceptionMask setting.
  1. A special case of (2), depending on how the application handles exceptions.

Note that alternative (1), is ''required'', and is ''expected to be the default''. In order to support this it is necessary to provide a means for an application to examine ''indicators'' after performing floating point operations, which most Smalltalk implementations do not. The Dolphin VM ensures that isolated FP state is maintained for each running `Process`, and the CRT `_statusfp` function can be called to retrieve the current status indicators after FP operations are performed, either in primitives, or external library calls. The default exception mask is set to mask out the continuable error cases in order to comply with the expectation that notification through indicators be the default notification mechanism. For example, should an FP operation cause overflow, then the result will be `Float.Infinity` (or `Float.NegativeInfinity`), and the `CRTConstants._EM_OVERFLOW` mask will be set in `Float statusFlags`. The status flags should be read immediately after an operation as any subsequent floating point operation may clear them.

We still provide notification through alteration of control flow (i.e. the raising of exceptions) for division by zero, and invalid operations such as taking the square root of a negative number. We''ve chosen to unmask these error cases because they generally indicate logic errors in a program, and so exceptions are raised for these errors by default. This can be overridden in any individual process (or for a block of computation) by setting the FP exception mask appropriately. When these conditions are also masked, `Float.NaN` values will be returned from the FP operation as continuation values. Operations on continuations values (i.e. Float.NaN, Float.NegativeInfinity and Float.Infinity) will generally result in a further continuation value without an exception being raised, even when the operation would normally have generated an exception. For example `Float.Infinity / 0.0` evalutes to `Float.Infinity` without raising an exception. This is a direct reflection of the way the CPU behaves with these values when using SSE2 instructions.

`FloatingPointException`s are resumable. If you catch and resume them, then the operation that faulted can be expected to complete with an appropriate continuation value. For example:
```
	-1.0 sqrt.  	"=> Floating point error: InvalidOperation in SquareRoot"
	[-1.0 sqrt] on: FloatingPointException do: [:ex | ex resume]	"=> Float.NaN"
```
'!

!Core.FloatingPointException categoriesForClass!Kernel-Exception Handling! !

!Core.FloatingPointException methodsFor!

_descriptionArguments
	"Answer the arguments to be subsituted into the receiver's description 
	format string."

	| record |
	record := self _ieeeRecord.
	^super _descriptionArguments , {record causeDescription. record operationName}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'Floating point error: %3 in %4'!

_ieeeRecord
	"Private - Answer the IEEE exception record associated with the receiver."

	^self tag!

isOverflow
	"Answer whether receiver represents a floating point overflow error."

	^self tag isOverflow
!

isUnderflow
	"Answer whether receiver represents a floating point underflow error."

	^self tag isUnderflow
! !

!Core.FloatingPointException categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
_ieeeRecord!accessing!private! !
isOverflow!public!testing! !
isUnderflow!public!testing! !
!

