"Filed out from Dolphin Smalltalk"!

Object subclass: #ExceptionHandlerAbstract
	instanceVariableNames: 'outer protectedBlock returnContinuation'
	classVariableNames: 'RetryCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExceptionHandlerAbstract guid: (GUID fromString: '{87b4c484-026e-11d3-9fd7-00a0cc3e4a32}')!

ExceptionHandlerAbstract isAbstract: true!

ExceptionHandlerAbstract comment: ''!

!ExceptionHandlerAbstract categoriesForClass!Kernel-Exception Handling! !

!ExceptionHandlerAbstract methodsFor!

actionFor: exception
	"Private - Answer a <monadicBlock> handler for the <exceptionDescription> 
	argument, exception or nil if the receiver has no appropriate handler."

	^self subclassResponsibility!

markAndTry
	"Private - Evaluate the receiver's tryBlock, having first created the block used to return 
	to the context which originated the receiver (i.e. the sender of #on:do:). The returnBlock, 
	when evaluated, will cause a non-local return to the context where the receiver was instantiated, 
	and is used to implement returning from (or dropping off the end of) exception handlers."

	returnContinuation := [:answer | ^answer].
	^protectedBlock value!

on: exceptionSelector do: monadicBlock 
	"Private - Record the <exceptionSelector> and <monadicBlock> to be
	used as the receivers exception selector and handler block respectively."

	^self subclassResponsibility!

outer
	"Private - Answer the receiver's outer handler."
	
	^outer!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: protectedBlock;
		nextPut: $)!

retry
	"Private - Attempt the receiver's try block again. The user supplied handler block could 
	have modified the try block, so this may not mean re-evaluating the same block. If not, 
	then the user-supplied handler block should have taken some other remedial action so that 
	the same exception is not regenerated, as otherwise an infinite loop may result. Use with care.
	Implementation Note: Return the unique Retry cookie which to distinguish from any other
	return value."

	self return: RetryCookie!

retryUsing: newProtectedBlock
	"Private - Restart the expression (#on:do:) from which the receiver originated, but 
	with the different try Block, newProtectedBlock. Use sparingly, and with care as the 
	results may be difficult to predict."

	protectedBlock := newProtectedBlock.
	self retry!

return: anObject
	"Private - Answer the argument as the value of the receiver's try block (which must have generated an exception caught
	by the receiver). The returnBlock contains a non-local return, so it will unwind the stack back to the
	context which was trying to evaluate the guarded block."

	returnContinuation value: anObject!

try: niladicBlock
	"Private - Answer the result of evaluating niladicBlock within an exception environment
	established by pushing the receiver onto the active processes exception environment.
	Should an exception be generated, directly or indirectly, by niladicBlock, which is 
	caught by the receiver, then the corresponding handler block in the receiver will be 
	will be evaluated to handle it. If the receiver does not handle a raised exception then 
	that exception will propagate up the handler chain in the process' exception environment."

	| old answer process |
	protectedBlock := niladicBlock.
	process := Processor activeProcess.
	outer := old := process exceptionEnvironment.
	
	[process exceptionEnvironment: self.
	[(answer := self markAndTry) == RetryCookie] whileTrue] 
			ensure: [process exceptionEnvironment: old].
	returnContinuation := nil.
	^answer! !

!ExceptionHandlerAbstract categoriesForMethods!
actionFor:!helpers!private! !
markAndTry!debugger-step through!evaluating!private! !
on:do:!initializing!private! !
outer!debugger-step over!private! !
printOn:!development!printing!public! !
retry!debugger-step through!handler responses!private! !
retryUsing:!debugger-step through!handler responses!private! !
return:!debugger-step through!handler responses!private! !
try:!debugger-step through!evaluating!private! !
!

!ExceptionHandlerAbstract class methodsFor!

initialize
	"Initialize the receiver's class instance variable."

	RetryCookie := Object new!

on: selector do: action
	"Private - Answer a new instance of the receiver with the <exceptionSelector>, 
	selector, and <monadicBlock> exception handler, action."

	^self new on: selector do: action! !

!ExceptionHandlerAbstract class categoriesForMethods!
initialize!development!initializing!public! !
on:do:!debugger-step through!instance creation!private! !
!

