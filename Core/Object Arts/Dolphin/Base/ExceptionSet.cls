"Filed out from Dolphin Smalltalk"!

Object subclass: #ExceptionSet
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExceptionSet guid: (GUID fromString: '{87b4c485-026e-11d3-9fd7-00a0cc3e4a32}')!
ExceptionSet comment: 'ExceptionSet is a system class forming part of the Dolphin exception handling system''s implementation. It is used to collect together multiple <exceptionSelector>s specified in a comma separated list as the first argument to a #on:do: message to a <niladicBlock>.'!
!ExceptionSet categoriesForClass!Kernel-Exception Handling! !
!ExceptionSet methodsFor!

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

selectors
	"Answer the value of the receiver's instance variable 'selectors'.
	This method was automatically generated, but may be modified."

	^selectors!

selectors: anObject
	"Set the value of the receiver's instance variable 'selectors' to anObject.
	This method was automatically generated, but may be modified."

	selectors := anObject! !
!ExceptionSet categoriesForMethods!
,!adding!public! !
handles:!accessing!public! !
initialize!initializing!public! !
selectors!accessing!public! !
selectors:!accessing!public! !
!

ExceptionSet methodProtocol: #exceptionSelector attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!
ExceptionSet methodProtocol: #exceptionSet attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!

!ExceptionSet class methodsFor!

new
	"Answer a new instance of the receiver."

	^super new initialize!

selectors: anArray
	"Private - Answer a new instance of the receiver containing representing a set of the <exceptionSelector>s in the <Array> argument."

	^super new selectors: anArray! !
!ExceptionSet class categoriesForMethods!
new!instance creation!public! !
selectors:!instance creation!private! !
!

