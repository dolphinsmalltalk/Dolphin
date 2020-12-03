"Filed out from Dolphin Smalltalk 7"!

Kernel.ExceptionHandlerAbstract subclass: #'Kernel.ExceptionHandler'
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

handler: monadicBlock
	handler := monadicBlock
!

selector: exceptionSelector
	selector := exceptionSelector
! !
!Kernel.ExceptionHandler categoriesFor: #actionFor:!debugger-step over!helpers!private! !
!Kernel.ExceptionHandler categoriesFor: #handler:!debugger-step over!initializing!private! !
!Kernel.ExceptionHandler categoriesFor: #selector:!debugger-step over!initializing!private! !

!Kernel.ExceptionHandler class methodsFor!

on: selector do: action
	"Private - Answer a new instance of the receiver with the <exceptionSelector>, 
	selector, and <monadicBlock> exception handler, action."

	^self new
		selector: selector;
		handler: action;
		yourself! !
!Kernel.ExceptionHandler class categoriesFor: #on:do:!debugger-step through!instance creation!private! !

