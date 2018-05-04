"Filed out from Dolphin Smalltalk 7"!

ExceptionHandlerAbstract subclass: #ExceptionHandlerSet
	instanceVariableNames: 'handlers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExceptionHandlerSet guid: (GUID fromString: '{87b4c576-026e-11d3-9fd7-00a0cc3e4a32}')!
ExceptionHandlerSet comment: ''!
!ExceptionHandlerSet categoriesForClass!Kernel-Exception Handling! !
!ExceptionHandlerSet methodsFor!

actionFor: exception
	"Private - Answer a <monadicBlock> handler for the <exceptionDescription> 
	argument, exception or nil if the receiver has no appropriate handler."

	^(handlers detect: [:h | h key handles: exception] ifNone: [^nil]) value!

initialize
	"Private - Initialize the instance variables of the receiver."

	handlers := OrderedCollection new!

on: exceptionSelector do: monadicBlock
	"Private - Record the <exceptionSelector> and <monadicBlock> to be
	used as the receivers exception selector and handler block respectively."

	handlers addLast: (exceptionSelector -> monadicBlock)
! !
!ExceptionHandlerSet categoriesFor: #actionFor:!debugger-step over!helpers!private! !
!ExceptionHandlerSet categoriesFor: #initialize!initializing!private! !
!ExceptionHandlerSet categoriesFor: #on:do:!debugger-step over!initializing!private! !

!ExceptionHandlerSet class methodsFor!

new
	"Answer a new, initialized, instance of the receiver."

	^super new initialize! !
!ExceptionHandlerSet class categoriesFor: #new!debugger-step over!instance creation!public! !

