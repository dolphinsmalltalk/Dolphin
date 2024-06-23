"Filed out from Dolphin Smalltalk"!

Kernel.ExceptionHandlerAbstract
	subclass: #'Kernel.ExceptionHandler'
	instanceVariableNames: 'selector handler'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.ExceptionHandler guid: (Core.GUID fromString: '{87b4c575-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.ExceptionHandler comment: ''!

!Kernel.ExceptionHandler categoriesForClass!Kernel-Exception Handling! !

!Kernel.ExceptionHandler methodsFor!

actionFor: exception
	"Private - Answer a <monadicBlock> handler for the <exceptionDescription> 
	argument, exception or nil if the receiver has no appropriate handler."

	^(selector handles: exception) ifTrue: [handler]!

setHandler: monadicBlock
	handler := monadicBlock!

setSelector: exceptionSelector
	selector := exceptionSelector
! !

!Kernel.ExceptionHandler categoriesForMethods!
actionFor:!debugger-step over!helpers!private! !
setHandler:!debugger-step over!initializing!private! !
setSelector:!debugger-step over!initializing!private! !
!

!Kernel.ExceptionHandler class methodsFor!

on: selector do: action
	"Private - Answer a new instance of the receiver with the <exceptionSelector>, 
	selector, and <monadicBlock> exception handler, action."

	^self new
		setSelector: selector;
		setHandler: action;
		yourself! !

!Kernel.ExceptionHandler class categoriesForMethods!
on:do:!debugger-step through!instance creation!private! !
!

