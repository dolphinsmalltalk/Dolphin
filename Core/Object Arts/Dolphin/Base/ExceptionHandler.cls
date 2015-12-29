"Filed out from Dolphin Smalltalk X6"!

ExceptionHandlerAbstract subclass: #ExceptionHandler
	instanceVariableNames: 'selector handler'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExceptionHandler guid: (GUID fromString: '{87B4C575-026E-11D3-9FD7-00A0CC3E4A32}')!
ExceptionHandler comment: ''!
!ExceptionHandler categoriesForClass!Kernel-Exception Handling! !
!ExceptionHandler methodsFor!

actionFor: exception
	"Private - Answer a <monadicBlock> handler for the <exceptionDescription> 
	argument, exception or nil if the receiver has no appropriate handler."

	^(selector handles: exception) ifTrue: [handler]!

on: exceptionSelector do: monadicBlock
	"Private - Record the <exceptionSelector> and <monadicBlock> to be
	used as the receivers exception selector and handler block respectively."

	selector := exceptionSelector.
	handler := monadicBlock
! !
!ExceptionHandler categoriesFor: #actionFor:!debugger-step over!helpers!private! !
!ExceptionHandler categoriesFor: #on:do:!debugger-step over!initializing!private! !

