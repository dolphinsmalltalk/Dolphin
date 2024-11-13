"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.ExceptionSet'
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.ExceptionSet guid: (Core.GUID fromString: '{87b4c485-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.ExceptionSet comment: 'ExceptionSet is a system class forming part of the Dolphin exception handling system''s implementation. It is used to collect together multiple <exceptionSelector>s specified in a comma separated list as the first argument to a #on:do: message to a <niladicBlock>.'!

!Kernel.ExceptionSet categoriesForClass!Kernel-Exception Handling! !

!Kernel.ExceptionSet methodsFor!

, anotherException
	"Add the <exceptionSelector>, anotherException, to the group of 
	<exceptionSelectors> recognised by the receiver.
	The ANSI standard does not specify whether the answer is a new
	exceptionSet, or the receiver - we answer the receiver."

	selectors := selectors copyWith: anotherException.
	^self!

handles: exception
	"Answer whether the receiver contains an <exceptionSelector> which
	matches the <exceptionDescription>, exception."

	^selectors anySatisfy: [:es | es handles: exception]!

initialize
	"Initialize the receiver."

	selectors := #()!

matching: aMonadicValuable
	"Answer an <exceptionSelector> for catching subinstances of the receiver for which the <monadicValuable> argument evaluates to true."

	^ExceptionFilter select: self matching: aMonadicValuable!

selectors
	"Answer the value of the receiver's instance variable 'selectors'.
	This method was automatically generated, but may be modified."

	^selectors!

selectors: anObject
	"Set the value of the receiver's instance variable 'selectors' to anObject.
	This method was automatically generated, but may be modified."

	selectors := anObject! !

!Kernel.ExceptionSet categoriesForMethods!
,!adding!public! !
handles:!accessing!public! !
initialize!initializing!public! !
matching:!filtering!public! !
selectors!accessing!public! !
selectors:!accessing!public! !
!

Kernel.ExceptionSet methodProtocol: #exceptionSelector attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!
Kernel.ExceptionSet methodProtocol: #exceptionSet attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!

!Kernel.ExceptionSet class methodsFor!

new
	"Answer a new instance of the receiver."

	^super new initialize!

selectors: anArray
	"Private - Answer a new instance of the receiver containing representing a set of the <exceptionSelector>s in the <Array> argument."

	<primitive: 157>
	^self basicNew
		selectors: anArray;
		yourself! !

!Kernel.ExceptionSet class categoriesForMethods!
new!instance creation!public! !
selectors:!instance creation!private! !
!

