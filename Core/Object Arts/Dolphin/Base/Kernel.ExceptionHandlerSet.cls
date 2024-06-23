"Filed out from Dolphin Smalltalk"!

Kernel.ExceptionHandlerAbstract
	subclass: #'Kernel.ExceptionHandlerSet'
	instanceVariableNames: 'handlers'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.ExceptionHandlerSet guid: (Core.GUID fromString: '{87b4c576-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.ExceptionHandlerSet comment: 'ExceptionHandlerSet is a private class that is part of the implementation of ANSI Smalltalk Exceptions in Dolphin. It is used to represent a collection of exception filters and handler blocks. The implementation is subject to change and should not be instantiated directly.'!

!Kernel.ExceptionHandlerSet categoriesForClass!Kernel-Exception Handling! !

!Kernel.ExceptionHandlerSet methodsFor!

actionFor: exception
	"Private - Answer a <monadicBlock> handler for the <exceptionDescription> 
	argument, exception or nil if the receiver has no appropriate handler."

	1 to: handlers size
		by: 2
		do: [:i | ((handlers at: i) handles: exception) ifTrue: [^handlers at: i + 1]].
	^nil!

setHandlers: aSequenceableCollection
	handlers := aSequenceableCollection! !

!Kernel.ExceptionHandlerSet categoriesForMethods!
actionFor:!debugger-step over!helpers!private! !
setHandlers:!initializing!private! !
!

!Kernel.ExceptionHandlerSet class methodsFor!

handlers: aSequencedReadableCollectionOfAssociations
	^self basicNew setHandlers: aSequencedReadableCollectionOfAssociations! !

!Kernel.ExceptionHandlerSet class categoriesForMethods!
handlers:!debugger-step over!instance creation!private! !
!

