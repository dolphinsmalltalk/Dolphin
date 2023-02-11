"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Core.DeferredValue'
	instanceVariableNames: 'valueAvailable value exception'
	classVariableNames: 'ValuePending'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.DeferredValue guid: (Core.GUID fromString: '{b2986be9-3666-4cd8-8d87-c7e456f6dd95}')!
Core.DeferredValue comment: 'A DeferredValue is a <niladicValuable> which is evaluated asynchronously in a background process, but which supplies its value synchronously on request, i.e. it blocks any sender of #value until the value is available.

Instances of DeferredValue are typically created by sending the #deferredValue (calculate in background process forked at same priority as active process) and #deferredValueAt: (calculate in a background process at the specified priority) messages, but there is a class side instance creation protocol (#evaluate:[|with|#with:with:|withArguments:]at: which can be used to defer the calculation of other valuables.

Note that if an exception occurs in the deferred operation it is raised in both the asynchronous process calculating the deferred value, AND any client processes (senders of #value). This is the default behaviour because the deferred value may never be requested, in which case the error would go undetected.

To suppress exceptions in the asynchronous process wrap the deferred operation in an exception trap which catches any <Error>s and answers them as the value of the operation. Any such suppressed <Error> will still be raised in the client process(es) requesting the deferred value, and of course these can be handled (or ignored) as normal. For example:

	[["...operation which might raise an error..."]
		on: Error do: [:e | e]] deferredValue

Alternatively create a subclass which overrides #_evaluate:withArguments: which includes such a generic error trap.'!
!Core.DeferredValue methodsFor!

_evaluate: operation withArguments: args
	"Private - Evaluate the <valuable>, operation with the <Array> of arguments, args.
	The receiver becomes signalled when either the calculation completes, is terminated,
	or an exception occurs. This method can be overridden by subclasses if desired."
	
	^operation valueWithArguments: args!

deferredValue
	"Answer a <niladicValuable> that is evaluated asynchronously (i.e. the receiver)."

	^self!

deferredValueAt: priority
	"Answer a <niladicValuable> that is evaluated asynchronously at the specified priority.
	Implementation Note: The priority argument is ignored."

	^self!

evaluate: operation withArguments: args at: priority
	"Private - Answer a <niladicValuable> that begins evaluating the <valuable>, 
	operation with the <Array> of arguments, args, asynchronously at the specified 
	<integer> priority, and which when evaluated will synchronously supply the result. 
	This message must only be sent when the deferred value is first created."

	self initialize.
	
	[[self setValue: (self _evaluate: operation withArguments: args)]
		on: Error
		do: 
			[:e |
			self exception: e.
			e pass]
		on: ProcessTermination
		do: 
			[:e |
			self exception: (Error new
						tag: self;
						messageText: 'DeferredValue terminated prematurely')]]
			forkAt: priority!

exception: anError
	"Private - Record the <Error>, anError, as the unhandled exception which
	occurred when attempting to calculate the value of the receiver, but only
	if an exception has not already been recorded. This message must not be
	sent if #setValue: has been sent."

	exception isNil ifTrue: [
		self assert: [value == ValuePending].
		exception := anError. 
		value := nil.
		valueAvailable signal]!

hasValue
	"Answer whether the deferred value has been calculated yet."

	^value ~~ ValuePending!

initialize
	"Private - Initialize the receiver's instance variables."

	value := ValuePending.
	valueAvailable := Semaphore new!

setValue: result
	"Private - Set the deferred value, releasing any processes which are waiting
	for it.
	Implementation Note: An #isKindOf: test allows the deferred value block to 
	trap an exception to prevent  it being raised in the async. process, if desired, 
	and return it as the value so that it can be re-raised in client processes. We
	store the exception in a separate instance variable to avoid the necessity for
	an isKindOf test on every access to the value."

	(result isKindOf: Error)
		ifTrue: 
			[exception := result.
			value := nil]
		ifFalse: [value := result].
	valueAvailable signal!

value
	"Answer the deferred value, blocking until it is available if necessary.
	If an exception occurred during the calculation of the value, or if it
	resulted in an <Error>, then that exception is re-raised now in the context
	of the calling process."

	valueAvailable
		wait;
		signal.
	exception isNil ifFalse: [exception copy signal].
	^value! !
!Core.DeferredValue categoriesForMethods!
_evaluate:withArguments:!evaluating!private! !
deferredValue!evaluating!public! !
deferredValueAt:!evaluating!public! !
evaluate:withArguments:at:!evaluating!private! !
exception:!accessing!private! !
hasValue!public!testing! !
initialize!initializing!private! !
setValue:!accessing!private! !
value!evaluating!public! !
!

!Core.DeferredValue class methodsFor!

evaluate: operation at: priority
	"Answer a <niladicValuable> that begins evaluating the <niladicValuable>, operation,
	asynchronously at the specified <integer> priority, and which when evaluated will 
	synchronously supply the result."

	^self	evaluate: operation withArguments: #() at: priority!

evaluate: operation with: arg1 at: priority
	"Answer a <niladicValuable> that begins evaluating the <monadicValuable>, operation,
	asynchronously at the specified <integer> priority, and which when evaluated will 
	synchronously supply the result."

	^self
		evaluate: operation
		withArguments: {arg1}
		at: priority!

evaluate: operation with: arg1 with: arg2 at: priority
	"Answer a <niladicValuable> that begins evaluating the <dyadicValuable>, operation,
	asynchronously at the specified <integer> priority, and which when evaluated will 
	synchronously supply the result."

	^self
		evaluate: operation
		withArguments: {arg1. arg2}
		at: priority!

evaluate: operation withArguments: args at: priority
	"Answer a <niladicValuable> that begins evaluating the <valuable>, operation,
	asynchronously at the specified <integer> priority, and which when evaluated will 
	synchronously supply the result."

	^super new
		evaluate: operation withArguments: args at: priority!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	ValuePending := Object new!

new
	"Answer a instance of the receiver."

	^self shouldNotImplement! !
!Core.DeferredValue class categoriesForMethods!
evaluate:at:!instance creation!public! !
evaluate:with:at:!instance creation!public! !
evaluate:with:with:at:!instance creation!public! !
evaluate:withArguments:at:!instance creation!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
!

