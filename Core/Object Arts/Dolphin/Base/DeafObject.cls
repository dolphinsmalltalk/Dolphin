"Filed out from Dolphin Smalltalk"!

Object subclass: #DeafObject
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DeafObject guid: (GUID fromString: '{87b4c47a-026e-11d3-9fd7-00a0cc3e4a32}')!

DeafObject comment: 'DeafObject is a singleton class whose sole instance is deaf to all requests - i.e. it appears to understand all messages, but takes no action except to answer itself. This ensures that the results of all message sends to the DeafObject are also deaf. DeafObject can be useful for avoiding a proliferation of #isNil tests.

N.B. DeafObject cannot be used to substitute for any object which has special significance to either the Compiler or the VM, a good example being <Boolean>s. The following expression will raise a ''Must be boolean'' error because it is not a true message send:

DeafObject current ifTrue: []

Class Variables:
	Current		<DeafObject>. Singleton instance.


'!

!DeafObject categoriesForClass!System-Support! !

!DeafObject methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent (in whatever respect is appropriate for 
	the class of the receiver). All DeafObjects are considered equal."

	^self class = comparand class!

asParameter
	^nil!

doesNotUnderstand: aMessage
	"The receiver is deaf to all requests. Answer self to ensure that
	our answers are also deaf."

	^self!

mustBeBoolean
	"Private - Sent to the receiver by the VM when an attempt was made to test it
	for its boolean status by a CompiledMethod.
	Note that it is normally necessary for implementors of #mustBeBoolean to return a
	boolean value, or not return at all. If a non-boolean value is returned, then it
	in turn will be sent a #mustBeBoolean message too. This could potentially continue 
	indefinitely, causing an unbreakable loop."

	^true! !

!DeafObject categoriesForMethods!
=!comparing!public! !
asParameter!converting!public! !
doesNotUnderstand:!exceptions!public! !
mustBeBoolean!exceptions!not restartable!private!vm entry points! !
!

!DeafObject class methodsFor!

current
	"Answer the singleton <DeafObject>."

	^Current!

initialize
	"Private - Initialize the receiver's class variables."

	Current isNil ifTrue: [Current := self new]! !

!DeafObject class categoriesForMethods!
current!accessing!public! !
initialize!development!initializing!private! !
!

