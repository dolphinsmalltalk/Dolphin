"Filed out from Dolphin Smalltalk"!

nil
	subclass: #'Kernel.ProtoObject'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.ProtoObject guid: (Core.GUID fromString: '{30771b7b-8bf6-4c81-8d54-7ed3b247a81d}')!

Kernel.ProtoObject comment: 'ProtoObject is an abstract class that can be used as a basis for creating a variety of "stub" subclasses.  It supplies the minimum protocol that might be useful for any such stub in order that inspection and debugging may successfully take place.'!

!Kernel.ProtoObject categoriesForClass!System-Support! !

!Kernel.ProtoObject methodsFor!

~~ comparand
	"Answer whether the <Object>, comparand,  is NOT identical to the receiver."

	^(self == comparand) not!

== comparand
	"Answer whether the <Object>, comparand, is the same, identical, 
	object as the receiver. 
	
	The primitive should NOT fail.
	
	N.B. This implementation cannot be overridden, and is never, in fact, received 
	(unless #perform'd), because #== is inlined by the Compiler."

	<primitive: 110>
	^self primitiveFailed: _failureCode!

allReferences
	"Answer an Array containing all objects which reference the receiver.
	The primitive should not fail."

	<primitive: 153>
	^self primitiveFailed: _failureCode!

basicClass
	"Answer the class of the receiver. The primitive should not fail."

	<primitive: 111>
	^self primitiveFailed: _failureCode!

basicIdentityHash
	"Answer the <integer> identity hash value for the receiver. This is
	currently a 16-bit SmallInteger value, which is always positive. The value is a pseudo-random number 
	assigned on first request, and it never changes (i.e. it is temporally 
	invariant). Because the range is limited to 16-bits, very large collections 
	hashed by identity using this value alone may be slow to access."

	<primitive: 75>
	^self primitiveFailed: _failureCode!

basicPrintOn: aStream
	"Append a short developer's description of the receiver to aStream. 
	Should not be overridden by subclasses."

	| name |
	name := self basicClass name.
	aStream 
		nextPutAll: (name first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: name!

basicPrintString
	"Answer a short developer's String description of the receiver. 
	Should not be overridden by subclasses"

	| aStream |
	aStream := String smalltalkWriteStream: 16.
	self basicPrintOn: aStream.
	^aStream contents!

basicSize
	"Private - Sames as #size, but should not be overridden by subclasses (except by subclasses
	whose instances have an immediate representation - e.g. SmallInteger).

	The primitive should not fail. It must be overridden for immediate objects."

	<primitive: 62>
	^self primitiveFailed: _failureCode!

become: anObject
	"Swap the instance pointers of the receiver and the argument, anObject. All variables in the entire system that pointed to the receiver will now point to the argument, and vice versa.

	Primitive failure reasons:
		ObjectTypeMismatch - receiver or argument an object with an immediate representation (e.g. a SmallInteger), or either is a 'permanent' objects (nil, true, false, etc).

	This method should be used with extreme care, as it has side effects for others referring to the receiver and anObject. In particular never attempt to pass nil, true, false, etc, as the argument, as this will almost certainly cause system failure.

	N.B. Though Dolphin is faithful to the original Smalltalk-80 specification for this method, and provides a two way switch as described, this is not universally true for all Smalltalks, so portable code should assume only a one way switch. To better guarantee portability you should use #swappingBecome: which, hopefully, will start to become prevalent on other platforms."

	<primitive: 72>
	^self primitiveFailed: _failureCode!

doesNotUnderstand: failedMessage
	"Sent to the receiver by the VM when a message sent to the receiver was not implemented
	by the receiver or its superclasses (i.e. it has no appropriate behaviour).
	Signal a <MessageNotUnderstood> exception corresponding to the <failedMessage> argument,
	message."

	^MessageNotUnderstood receiver: self message: failedMessage!

error: signalerText
	"Raise an <Error> exception reporting the error message contained in the
	<readableString> argument, signalerText."

	^Error signal: signalerText!

identityHash
	"Answer the <integer> identity hash value for the receiver. Be aware that this is based on a
	16-bit integer randomly generated for each object on first request, so there are only 65536
	unique values. The 16-bit hash is scaled to 30-bits to avoid closely grouped objects in large
	hashed collections with internal overflow causing extremely poor performance. See
	#basicIdentityHash for further details."

	^self basicIdentityHash bitShift: 14!

instVarAt: index
	"Private - Answer a variable in the receiver. The numbering of the variables begins with named instance variables, and corresponds to the order in which the instance variables were defined. Indexed variables have indices following those of the named instance variables."

	"Primitive failure reasons:
		InvalidParameter1	- aSmallInteger is not a SmallInteger.
		OutOfBounds		- aSmallInteger is out of bounds (not in the range 1..recieiver's size)."

	<primitive: 73>
	_failureCode == _PrimitiveFailureCode.OutOfBounds
		ifTrue: [^BoundsError receiver: self index: index].
	_failureCode == _PrimitiveFailureCode.InvalidParameter1 ifTrue: [^Error nonIntegerIndex: index].
	^self primitiveFailed: _failureCode!

isKindOf: candidateClass
	"Answer whether the receiver is an instance of the argument, candidateClass,
	or one of its subclasses.
	The primitive never fails, so the Smalltalk back up code is present for illustrative
	purposes only. The primitive is very fast, so there is no particular reason to
	implement isXXXXXX methods instead, BUT in any case is-kind-of tests are not
	good practice. Tests should be made to see if an object provides a particular
	protocol (if necessary) rather than testing for a particular class."

	<primitive: 57>
	^self class includesBehavior: candidateClass!

oneWayBecome: anObject
	"Make all references to the receiver be references to the argument (i.e. anObject replaces all uses of the receiver, and the receiver's identity and contents are lost). This is the  only form of #become: available in some Smalltalk systems. Can follow a two
	way #become: for even more mind boggling fun (to maintain one objects identity, but anothers value).

	Primitive failure reasons:
		ObjectTypeMismatch	- receiver or argument an object with an immediate representation (e.g. a SmallInteger), or either is a 'permanent' objects (nil, true, false, etc).

	This method should be used with care, but is some what less dangerous than #become:, as it does not affect existing users of anObject. Currently the implementation is not as efficient as #become:."

	<primitive: 154>
	^self primitiveFailed: _failureCode!

primitiveFailed: anInteger
	"Generate an error to the effect that a primitive has failed, including the failure code specified by the primitive."

	^HRESULTError signal: 'Primitive failed' withFailureCode: anInteger! !

!Kernel.ProtoObject categoriesForMethods!
~~!comparing!public! !
==!comparing!public! !
allReferences!enumerating!public! !
basicClass!accessing!public! !
basicIdentityHash!comparing!public! !
basicPrintOn:!printing!public! !
basicPrintString!printing!public! !
basicSize!accessing!private! !
become:!mutating!public! !
doesNotUnderstand:!exceptions!public! !
error:!exceptions!public! !
identityHash!comparing!public! !
instVarAt:!accessing!private! !
isKindOf:!public!testing! !
oneWayBecome:!mutating!public! !
primitiveFailed:!exceptions!public! !
!

