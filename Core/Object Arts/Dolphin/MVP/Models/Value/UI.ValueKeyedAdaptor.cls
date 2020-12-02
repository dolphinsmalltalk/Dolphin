"Filed out from Dolphin Smalltalk 7"!

ValueAdaptor subclass: #ValueKeyedAdaptor
	instanceVariableNames: 'key putSelector getSelector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ValueKeyedAdaptor guid: (GUID fromString: '{87b4c67a-026e-11d3-9fd7-00a0cc3e4a32}')!
ValueKeyedAdaptor comment: 'A ValueKeyedAdaptor is capable of adapting a keyed element of a subject object (typically a Collection) and treating this as a <value>. A keyed element one which can be accessed from the subject object using #at: and #at:put:.

Instance Variables:
	key		<Object> used as the key to access an element of the subject
	putSelector	<selector> message used to set the aspect
	getSelector	<selector> message used to get the aspect
'!
!ValueKeyedAdaptor categoriesForClass!MVP-Models! !
!ValueKeyedAdaptor methodsFor!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand.
	In order to be so the comperand must be of the same species, equal key, and
	identical subject."

	^self == comperand 
		or: [self species == comperand species 
			and: [self key = comperand key 
				and: [self subject == comperand subject]]]!

canGet
	"Private - Answer whether the receiver can be read using #value."

	^self subject respondsTo: self getSelector!

canSet
	"Private - Answer whether the receiver can be set using #value:."

	^self subject respondsTo: self putSelector!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: subject;
		nextPut: $[;
		print: self key;
		nextPut: $]!

getSelector
	"Private - Answers the selector used for getting the indexed value from the subject"

	^getSelector!

hash
	"Answer the <Integer> hash value for the receiver."

	^(self key hash bitShift: 1) bitXor: self subject hash!

key
	"Private - Answers the key used to access the element of the subject that
	the receiver is to treat as a value"

	^key!

objectRefName
	"Private - Answer name to use when the value of the receiver is dragged as an #ObjectRef"

	^self value basicPrintString , self key displayString 
		copyWithout: Character space!

putSelector
	"Private - Answers the selector used for setting the aspect value into the subject"

	^putSelector
!

setValue: anObject
	"Private - Assigns the value for the receiver without notifying 
	dependents of the change"
	
	self subject perform: self putSelector with: self key with: anObject.!

subject: anObject key: aKey
	"Private - Sets the subject object and the key being used to access an element of it"

	super subject: anObject.
	key := aKey.
	getSelector := #at:.
	putSelector := #at:put:.

!

value
	"Answers the <Object> value of the receiver, obtained by
	sending a message to the receiver's subject with the key."
	
	^self subject perform: self getSelector with: self key! !
!ValueKeyedAdaptor categoriesFor: #=!comparing!public! !
!ValueKeyedAdaptor categoriesFor: #canGet!private!testing! !
!ValueKeyedAdaptor categoriesFor: #canSet!private!testing! !
!ValueKeyedAdaptor categoriesFor: #displayOn:!displaying!public! !
!ValueKeyedAdaptor categoriesFor: #getSelector!accessing!private! !
!ValueKeyedAdaptor categoriesFor: #hash!comparing!public! !
!ValueKeyedAdaptor categoriesFor: #key!accessing!private! !
!ValueKeyedAdaptor categoriesFor: #objectRefName!accessing!private! !
!ValueKeyedAdaptor categoriesFor: #putSelector!accessing!private! !
!ValueKeyedAdaptor categoriesFor: #setValue:!accessing!private! !
!ValueKeyedAdaptor categoriesFor: #subject:key:!initializing!private! !
!ValueKeyedAdaptor categoriesFor: #value!accessing!public! !

!ValueKeyedAdaptor class methodsFor!

new
	"Private - An instance of this class requires parameters"

	^self shouldNotImplement!

subject: anObject key: aKey
	"Answers an instance of the receiver that is an interface onto
	an element of anObject identified by aKey"

	^(super new) subject: anObject key: aKey; yourself! !
!ValueKeyedAdaptor class categoriesFor: #new!instance creation!private! !
!ValueKeyedAdaptor class categoriesFor: #subject:key:!instance creation!public! !

