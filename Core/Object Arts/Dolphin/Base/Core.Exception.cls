"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Exception'
	instanceVariableNames: 'tag messageText _activeHandler _process _signalFrame _environmentWhenRaised _continueBlock _resignalBlock _resignalException'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS.Win32Errors private} #{OS.MessageBoxConstants private})
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Exception guid: (Core.GUID fromString: '{87b4c483-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Exception isNonInstantiable: true!
Core.Exception comment: ''!
!Core.Exception categoriesForClass!Kernel-Exception Handling! !
!Core.Exception methodsFor!

_descriptionArguments
	"Answer a <sequencedReadableCollection> of the  arguments to be substitued 
	into the receiver's Win32 description format string when constructing the receiver's
	#description.
	By default the arguments to the message formatting are the message text and 
	the tag supplied by the exception signaller, but if additional fields are available,
	then this should be overridden.

	N.B. This is part of the implementation of the ANSI standard message 
	#description and therefore it requires an underscore prefix in order
	to avoid the fragile base class problem where subclasses may 
	inadvertantly override a superclass method."

	^{self messageText displayString. self tag displayString}	"...just in case the messageText is not a String"!

_descriptionFormat
	"Answer a <readableString> whose contents are a Win32 format string to be used 
	to construct the #description for the receiver.
	By default the format will display only the message text supplied by the signaller,
	but this can (and should) be overridden by subclasses to display something more specific.

	N.B. This is part of the implementation of the ANSI standard message 
	#description and therefore it requires an underscore prefix in order
	to avoid the fragile base class problem where subclasses may 
	inadvertantly override a superclass method."

	^'%1'!

_evaluateHandler: handlerBlock in: anExceptionHandler 
	"Private - The receiver has been identified as a handler for the argument exception. 
	Handle the exception by evaluating the exception handling block, handlerBlock, 
	establishing the continue block so that a non-local return to our sender is possible. 
	When the continue block is evaluated it causes a non-local return of its argument value 
	to the context from which the receiver was signalled, having the effect of ignoring the 
	signalling of the receiver."

	| myEnv procEnv answer myContinueBlock activeProc |
	activeProc := Processor activeProcess.
	procEnv := activeProc exceptionEnvironment.
	myEnv := _activeHandler.
	myContinueBlock := _continueBlock.
	answer := 
			["Handle the exception within the environment of its enclosing handlers (a 
			 handler can't handle its own exceptions!!)"

			activeProc exceptionEnvironment: anExceptionHandler outer.
			"Record the active handler so that we can use it to act on responses from 
			 handler block"
			_activeHandler := anExceptionHandler.
			"Create the continue block for use with #resume:"
			_continueBlock := [:continueWith | ^continueWith].
			handlerBlock value: self] 
					ensure: 
						["Be sure to restore the previous exception environment"

						_activeHandler := myEnv.
						_continueBlock := myContinueBlock.
						activeProc exceptionEnvironment: procEnv].

	"If the user supplied exception handling block terminates by dropping off its end,
	without specifying a particular action, then we default to continuing execution
	immediately after the try block, even if the exception is resumable. This change
	for compatibility with latest X3J20 proposal, Sept. 96, BSM."
	^anExceptionHandler return: answer!

_propagate
	"Private - Propagate the receiver up through the originating process' stack of
	ExceptionHandlers starting from the current one."

	| answer |
	answer := self _propagateFrom: Processor activeProcess exceptionEnvironment.
	^answer == _resignalBlock ifTrue: [_resignalException signal] ifFalse: [answer]!

_propagateFrom: anExceptionEnvironmentOrNil 
	"Private - Propagate the receiver up through the chain of handlers starting at anExceptionHandlerOrNil,
	looking for one willing to handle the receiver. Should their be no such handler, then the default
	action associated with the receiver is performed."

	"The resignal block answers itself to provide a unique mark to identify retry attempts to the #handle method"

	| env oldEnv answer activeProc |
	_resignalBlock isNil ifTrue: [_resignalBlock := [^_resignalBlock]].
	env := anExceptionEnvironmentOrNil.

	"Exceptions can only be raised and handled in the context of the current active process."
	activeProc := Processor activeProcess.

	"We must prevent any exceptions generated during the search for a handler from
	causing an infinitely recursive search, so we temporarily trick the process
	into thinking it hasn't got a chain of exception handlers"
	oldEnv := activeProc exceptionEnvironment.
	activeProc exceptionEnvironment: nil.
	[env isNil] whileFalse: 
			[| handlerBlock |
			(handlerBlock := env actionFor: self) isNil 
				ifFalse: 
					[activeProc exceptionEnvironment: oldEnv.
					^self _evaluateHandler: handlerBlock in: env].
			env := env outer].

	"No handler was found, perform the default action in the same exception environment as that in place
	when the receiver was raised"
	activeProc exceptionEnvironment: _environmentWhenRaised.
	answer := self defaultAction.
	activeProc exceptionEnvironment: oldEnv.
	^answer!

abort
	"Terminate the process in which the receiver was raised."

	Processor activeProcess terminate!

abortRetryIgnore
	"Throw up an Abort/Retry/Ignore Warning message box with the receiver's message: If the 
	user presses Ignore, then resume (continue execution as if the warning had not been raised), 
	if the user presses Abort, then return (continue execution after the handler), the answer is nil 
	in either case. Example usage:

	[ Warning signal: 'Aha!! Continue?'. Transcript show: 'Inside the try block'; cr ] 
		on: Warning do: [ :e |
			e abortRetryIgnore ]. Transcript show: 'After the try block'; cr.
	"

	self perform: self abortRetryOrIgnore
!

abortRetryOrIgnore
	"Throw up an Abort/Retry/Ignore Warning message box with the receiver's message and answer
	the symbolic name of the user's response."

	^self showMessage: self description style: ##(MB_ICONWARNING | MB_ABORTRETRYIGNORE | MB_DEFBUTTON3)!

beep
	"Sound an appropriate beep to draw the users attention."

	self class beep!

defaultAction
	"Perform the default action for the receiver if it is not handled

	This is an ANSI standard message, but the action to be taken is implementation
	defined. In the Dolphin development environment the default actions are
	as follows:
		Error		- Causes a walkback from the signal origin.
		Warning		- Displays an Abort/Retry/Ignore message box. 
		Notification	- Writes the description to the Transcript, and resumes.
	See those subclasses for further details."

	^self subclassResponsibility!

description
	"Answer a <readableString> describing the exception which the receiver represents. Note that
	if 'an explicit message text was provided by the signaler of the exception, that text should
	be incorporated into the description.' We don't enforce this (because we take the view that
	it is more important that exceptions carry all necessary details from the signalling point
	that will enable them to be handled correctly, and that presentation to the user is the
	exceptional case).

	N.B. This is an ANSI standard message in a class which is explicitly specified to be
	subclassable, and therefore it must not send any messages to self other than other ANSI
	standard messages, or those prefixed with an underscore. This is to avoid the fragile base
	class problem where subclasses may inadvertantly override a superclass method."

	| desc format |
	format := self _descriptionFormat.
	"An optimisation to speed up notifications - also avoids problem of limited string lengths
	supported by FormatMessage API"
	desc := format = '%1' 
				ifTrue: [self _descriptionArguments first]
				ifFalse: [format formatWithArguments: self _descriptionArguments].
	^desc isEmpty ifTrue: ['An unknown <1p> has occurred' expandMacrosWith: self class] ifFalse: [desc]!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| signallerText |
	aPuttableStream nextPutAll: ((signallerText := self messageText) notNil
				ifTrue: [signallerText]
				ifFalse: [self description])!

exit: anObject
	"Answer the argument as the value of the handler block, as if it were the value of the last 
	expression in the try block. For non-resumable exceptions, this is 
	equivalent to #return:, for resumable #resume:. This is no longer part of the ANSI
	standard set of handler responses."

	^self isResumable
		ifTrue: [self resume: anObject]
		ifFalse: [self return: anObject]!

hasTag
	"Answer whether a tag value with additional error details was supplied 
	when the receiver was signalled."

	^tag notNil!

hresult
	"Answer the <HRESULT> error code associated with the receiver.
	Overridden by subclasses to answer more specified HRESULT codes."

	^OS.HRESULT fail!

iconStyle
	"Answer an exception class describing the severity of the notification."

	^self severityClass iconStyle!

ignore
	"Perform the receiver's #resume action."

	self resume!

isNested
	"Answer whether the current exception currently being handled is within the scope of another
	handler for the same exception (i.e. if passed will be caught)."

	| env |
	env := Processor activeProcess exceptionEnvironment.
	[env isNil] whileFalse: [
		(env actionFor: self) isNil ifFalse: [^true].
		env := env outer].
	^false!

isResumable
	"Answer whether the receiver represents a resumable error. 
	Exceptions are, by default, NOT resumable."

	^false!

isSuppressible
	^false!

isUserResumable
	"Answer whether the user should be given the option of resuming when
	prompted with regard to this exception."

	^self isResumable!

messageText
	"Answer the <readableString> message text supplied when the receiver was signalled,
	or <nil> if none was provided."

	^messageText!

messageText: signalerText
	"Set the exceptions message text to the readableString argument, <signalerText>."

	messageText := signalerText!

okCancel
	"Throw up an OK/Cancel Warning message box with the receiver's message: If the user presses Ok, then resume
	(continue execution as if the warning had not been raised), if the user presses Cancel, then return (continue 
	execution after the handler), the answer is nil in either case. Example usage:

	[Warning signal: 'Aha!! Continue?'. Transcript show: 'Inside the try block'; cr ] on: Warning do: [ :e |
		e okCancel]. Transcript show: 'After the try block'; cr.
	"

	self okToContinue
		ifTrue: [self resume]
		ifFalse: [self return]!

okToContinue
	"Throw up an OK[Cancel] message box with the receiver's message, answering true if 
	it is ok to continue (the user pressed OK and the receiver is resumable)."

	^(self showMessage: self description
		style: (self isUserResumable
				ifTrue: [##(MB_OKCANCEL | MB_ICONWARNING)]
				ifFalse: [##(MB_OK | MB_ICONERROR)]))
			== #ok and: [self isUserResumable]!

outer
	"Answer the result of evaluating the next outermost exception handler for the 
	receiver, or the default action if none. The semantics of this handler response
	are quite subtle: Whether execution actually continues _in this message_ depends 
	on whether the receiver is resumable, and on the handler response invoked by the 
	outer handler, or the default action if there is no outer handler. If the exception
	is resumable, and the outer handler resumes then the answer from this 
	message will be the resumption value specified by that outer handler (or nil
	if non was specified), i.e. #resume(:) in the outer handler will resume in the
	handler which sent this message, not from the original point where the	
	exception was raised.  If the receiver is not a resumable exception, or if the
	outer handler does not resume, then control is not returned to this point and this
	message will not return. For exceptions that are not resumable, #outer is equivalent 
	to #pass."

	^self _propagate!

pass
	"Propagate the receiver to any enclosing handlers. The exact behavior depends on 
	whether the receiver is resumable or not.

	This selector is not particularly well chosen (it is an ANSI selector) so it may not be
	clear that this is the way one resignals a caught exception from inside a handler
	in order to propagate it to any enclosing handlers, i.e. it is the way one says,
	'There is nothing further I can do with this exception, you have it.'"

	^self exit: self _propagate!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of an Exception we assume it is being copied so that it may be re-raised, and
	therefore we nil the state associated with the context in which the original was raised."

	super postCopy.
	_environmentWhenRaised := _process := _signalFrame := _continueBlock := _resignalBlock := nil.
	^self!

printOn: aStream
	"Append a debug description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self description; nextPut: $)
!

printTraceOn: puttableStream
	"Write the receiver's description, and a stack trace from the point where the receiver was
	raised, to the <puttableStream> argument. This is intended for logging error details."

	self printTraceOn: puttableStream depth: -1!

printTraceOn: puttableStream depth: anInteger
	"Write the receiver's description, and a stack trace from the point where the receiver was
	raised, to the <puttableStream> argument. This is intended for logging error details."

	puttableStream
		print: self;
		cr;
		cr.
	self raisingFrame printStackOn: puttableStream depth: anInteger!

raisingFrame
	"Private - Answer the StackFrame from which the receiver was raised (approximate
	and for debugging purposes only)."

	| frame |
	frame := self signalFrame sender.
	"Skip the exception handling frames - a bit crap!!"
	
	[| receiver |
	receiver := frame receiver.
	(receiver isKindOf: Exception) or: [receiver isKindOf: Exception class]]
			whileTrue: [frame := frame sender].
	^frame!

resignalAs: anException
	"Signal the argument, anException, as if it had originally been raised in place of the
	receiver. The process state at the time the receiver was raised is restored by using
	the resignal block. This is powerful, but should be used with care!!"

	_resignalException := anException.
	_resignalBlock value!

resume
	"Answer <nil> as the value of the message that signaled this exception, 
	from whence execution continues, unless the current handler was activated
	as the result of a #outer action from an inner handler, in which case nil
	is returned to that handler, and execution continues there.
	Note that this message never returns to its sender.
	An error is signalled if the receiver is not resumable."

	self resume: nil!

resume: resumptionValue
	"Answer the <Object> resumptionValue as the result of the expression which 
	signalled this exception, from whence execution continues, unless the current 
	handler was activated as the result of a #outer action from an inner handler, 
	in which case resumptionValue is returned to that handler, and execution 
	continues there. Note that this message never returns to its sender.
	An error is signalled if the receiver is not resumable."

	self isResumable 
		ifTrue: [_continueBlock value: resumptionValue]
		ifFalse: [self error: 'non-continuable exception']!

retry
	"Abort the current exception handler and reattempt the evaluation of the try block.
	Note that this message does not return to its sender. Please use with care as it is
	easy to create an infinite loop by retrying a block indefinitely."

	_activeHandler retry!

retryUsing: alternativeBlock
	"Using the <niladicBlock>, alternativeBlock, in place of the try block from which the 
	receiver was raised, ignore the exception and retry in that context. This message does 
	not return to its sender.
	This should be used with particular care, as this is undoubtedly a most excellent 
	mechanism for the construction of excessively convoluted programs."

	_activeHandler retryUsing: alternativeBlock!

return
	"Answer <nil> as the value of the block guarded by the active exception handler.
	This message does not return to its sender."

	self return: nil!

return: returnValue
	"Answer the <Object> argument, returnValue, as the value of the block guarded by the 
	active exception handler. This message does not return to its sender."

	_activeHandler return: returnValue!

severityClass
	"Answer an exception class describing the severity of the notification."

	^self class severityClass!

showMessage: aString style: anInteger
	"Implementation Note: Avoid creating a dependency on MessageBox, as this class will always be required in an application even if MessageBox is not."

	^#(#ok #cancel #abort #retry #ignore #yes #no #close #help #retry #ignore) at: (OS.User32
				messageBox: nil
				text: aString
				caption: SessionManager current applicationName
				style: (Processor isActiveMain
						ifTrue: [anInteger maskSet: ##(MB_TASKMODAL | MB_SETFOREGROUND)]
						ifFalse: [anInteger])
				icon: nil
				instance: nil)
		ifAbsent: #abort!

signal
	"Raise (or re-raise) the receiver in the context of the current active process, causing its propagation 
	up through the handler chain."

	_environmentWhenRaised isNil
		ifTrue: 
			["Save info about the raising environment in case we want to resignal."
			_process := Processor activeProcess.
			_environmentWhenRaised := _process exceptionEnvironment.
			"If the signaller did not specify the context where the error was raised, make it this one"
			_signalFrame := thisContext].
	^self _propagate!

signal: signalText
	"Raise the receiver with the <readableString> error message text,
	signalText."

	self messageText: signalText.
	^self signal!

signal: signalText with: arg
	"Raise the receiver with the <readableString> error message text,
	signalText and the <Object> tag, arg."

	self messageText: signalText.
	self tag: arg.
	^self signal!

signalFrame
	"Private - Answer the StackFrame from which the receiver was signalled. This may be several 
	levels below the actual error detection frame on the stack."

	^_process frameAtAddress: _signalFrame!

signalType
	"Private - Answer the type of signal for which the receiver is representing
	an exceptional event."

	^self class!

signalWith: anObject
	"Raise the receiver with the <Object> tag."

	^self signal: nil with: anObject!

stackTrace: anInteger
	"Private - Answer a <readableString> containing a stack trace to the depth specified by the
	<integer> argument, or the entire stack below the raising frame if anInteger < 0. Assumes
	that the receiver is a signalled exception."

	^self raisingFrame stackTrace: anInteger!

tag
	"Answer the <Object> tag value with additional error details supplied 
	when the receiver was signalled. If the signaller has not provided a tag
	then answer the #messageText. 
	N.B. The tag should be used when examining exceptions, rather than the 
	message text, since the latter is intended only for human consumption, 
	and might, for example, vary between locales."

	^tag ifNil: [self messageText]!

tag: signalTag
	"Private - Set the receiver's tag object to be the <Object> argument, signalTag.
	Answer the receiver."

	tag := signalTag!

toTrace
	"Print details of the Exception to the session managers debug output device."
	
	self toTrace: 0!

toTrace: anInteger
	"Print details of the Exception to the session managers debug output device,
	along with a stack track of depth as specified by the <integer>, frames."

	| traceStream |
	traceStream := SessionManager current traceStream.
	traceStream
		nextPutAll: self description;
		cr.
	self raisingFrame printStackOn: traceStream depth: anInteger.
	traceStream flush! !
!Core.Exception categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
_evaluateHandler:in:!debugger-step through!handling!private! !
_propagate!debugger-step through!handling!private! !
_propagateFrom:!debugger-step through!handling!private! !
abort!handler responses!public! !
abortRetryIgnore!handler responses!public! !
abortRetryOrIgnore!handling!public! !
beep!parping!public! !
defaultAction!handling!public! !
description!displaying!public! !
displayOn:!printing!public! !
exit:!handler responses!public! !
hasTag!public!testing! !
hresult!accessing!public! !
iconStyle!constants!public! !
ignore!handler responses!public! !
isNested!public!testing! !
isResumable!public!testing! !
isSuppressible!accessing!public! !
isUserResumable!public!testing! !
messageText!accessing!public! !
messageText:!accessing!debugger-step over!public! !
okCancel!handler responses!public! !
okToContinue!public!testing! !
outer!handler responses!public! !
pass!debugger-step through!handler responses!public! !
postCopy!copying!public! !
printOn:!printing!public! !
printTraceOn:!printing!public! !
printTraceOn:depth:!printing!public! !
raisingFrame!accessing!private! !
resignalAs:!debugger-step through!handler responses!public! !
resume!debugger-step through!handler responses!public! !
resume:!debugger-step through!handler responses!public! !
retry!debugger-step through!handler responses!public! !
retryUsing:!debugger-step through!handler responses!public! !
return!debugger-step through!handler responses!public! !
return:!debugger-step through!handler responses!public! !
severityClass!constants!public! !
showMessage:style:!helpers!private! !
signal!debugger-step through!public!signalling! !
signal:!debugger-step through!public!signalling! !
signal:with:!public!signalling! !
signalFrame!accessing!private! !
signalType!accessing!private! !
signalWith:!public!signalling! !
stackTrace:!accessing!private! !
tag!accessing!public! !
tag:!accessing!private! !
toTrace!accessing!public! !
toTrace:!accessing!public! !
!

Core.Exception methodProtocol: #Exception attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!
Core.Exception methodProtocol: #exceptionBuilder attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isResumable #messageText #messageText: #signal #signal: #tag)!
Core.Exception methodProtocol: #exceptionDescription attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isResumable #messageText #signal #signal: #tag)!
Core.Exception methodProtocol: #exceptionSignaler attributes: #(#ansi #readOnly) selectors: #(#signal #signal:)!
Core.Exception methodProtocol: #signaledException attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Core.Exception class methodsFor!

, anotherException
	"Answer a new <exceptionSet> containing the receiver and the <exceptionSelector> 
	argument, anotherException. Note that the 'set' is a bit of a misnomer, as the result 
	does not conform to that protocol."

	^ExceptionSet selectors: {self. anotherException}!

beep
	"Sound an appropriate beep to draw the users attention."

	"Implementation Note: Use the MessageBeep() API directly to avoid creating a dependency on the Sound class."

	OS.User32 messageBeep: self mbIconId!

handles: exception
	"Answer whether the receiver matches the <exceptionDescription>, exception, and 
	any handler at this scope should be invoked.

	Implementation Note: The default is to handle exceptions which are instances or 
	subinstances of the receiver. This provides for an elegant type-based mechanism 
	for handling exceptions, similar to that of C++."

	^exception isKindOf: self!

matching: aMonadicValuable
	"Answer an <exceptionSelector> for catching subinstances of the receiver for which the <monadicValuable> argument evaluates to true."

	^ExceptionFilter select: self matching: aMonadicValuable!

mbIconId
	^0!

messageText: aString
	"Answer a new unraised instance of the receiver with the specified <readableString> message text."

	^self new
		messageText: aString;
		yourself!

new
	"Answer a new initialized instance of the receiver, conforming to 
	the <Exception> protocol."

	^super new initialize!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Error!

signal
	"Raise a new instance of the receiver conforming to <signaledException> with all <exceptionDescription>
	attributes set to default values. A search is initiated for an exception handler prepared to handle 
	instances of the receiver. This method will not return to its sender, unless the new instance is 
	resumable, and the handler which catches it directs that it should be resumed."

	^self new signal!

signal: signalerText
	"Raise a new instance of the receiver, with the <readableString> message text,
	signalerText, initiating a search for an <ExceptionHandler> prepared to handle 
	instances of the receiver. This method will not return to its sender, unless the new 
	instance is resumable, and the handler which catches it directs that it should 
	be resumed."

	^self new
		signal: signalerText!

signal: signallerText with: signallerTag
	"Raise a new instance of the receiver, with the error tag <Object>, signallerTag, 
	and the <readableString> message text, signallerText,  initiating a search for 
	an <ExceptionHandler> prepared to handle instances of the receiver. 
	his method will not return to its sender, unless the new instance is 
	resumable, and the handler which catches it directs that it should be resumed."

	^self new 
		signal: signallerText with: signallerTag!

signalWith: signallerTag
	"Raise a new instance of the receiver, with the error tag <Object>, signallerTag, 
	initiating a search for an <ExceptionHandler> prepared to handle instances of 
	the receiver. This method will not return to its sender, unless the new instance is 
	resumable, and the handler which catches it directs that it should be resumed."

	^self signal: nil with: signallerTag! !
!Core.Exception class categoriesForMethods!
,!filtering!public! !
beep!parping!public! !
handles:!filtering!public! !
matching:!filtering!public! !
mbIconId!constants!private! !
messageText:!instance creation!public! !
new!debugger-step through!instance creation!public! !
severityClass!constants!public! !
signal!instance creation!public! !
signal:!debugger-step through!instance creation!public! !
signal:with:!instance creation!public! !
signalWith:!instance creation!public! !
!

Core.Exception class methodProtocol: #'Exception class' attributes: #(#ansi #readOnly) selectors: #(#, #allSubclasses #allSuperclasses #handles: #name #new #signal #signal: #subclasses #superclass)!
Core.Exception class methodProtocol: #exceptionInstantiator attributes: #(#ansi #readOnly) selectors: #(#, #handles: #new #signal #signal:)!
Core.Exception class methodProtocol: #exceptionSelector attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!
Core.Exception class methodProtocol: #exceptionSignaler attributes: #(#ansi #readOnly) selectors: #(#signal #signal:)!

