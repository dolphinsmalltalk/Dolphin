"Filed out from Dolphin Smalltalk"!

Core.Magnitude
	subclass: #'Core.Association'
	instanceVariableNames: 'key value'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Association guid: (Core.GUID fromString: '{87b4c650-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Association comment: 'Association is a simple class to encapsulate the relationship between
a key and a value. It is used for the elements of Dictionaries.'!

!Core.Association categoriesForClass!Collections-Support! !

!Core.Association methodsFor!

< anAssociation 
	"Answer whether the receiver is considered 'less than' the argument."

	^key < anAssociation key!

<= anAssociation
	"Answer whether the receiver is considered 'less than or equals to' the argument."

	^key <= anAssociation key!

<==> anAssociation
	"Answer the receiver's <integer> collation order with respect to the <Association> argument, based on case-sensitive (where relevant) comparison of the keys only."

	^key <==> anAssociation key!

<=> anAssociation
	"Answer the receiver's <integer> collation order with respect to the <Association> argument, based on case-insensitive (where relevant) comparison of the keys only."

	^key <=> anAssociation key!

= anAssociation
	"Answer whether the receiver is equal to the argument."

	^self == anAssociation or: 
			[self species == anAssociation species
				and: [key = anAssociation key and: [value = anAssociation value]]]!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: key;
		nextPutAll: ' -> ';
		display: value!

hash
	"Answer the hash value of the receiver's key."

	^key hash
!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^self isSelfEvaluating: IdentitySet new!

isSelfEvaluating: visitedSet
	^(visitedSet addNewElement: self) and: 
			[self class == ##(self)
				and: [(key isSelfEvaluating: visitedSet) and: [value isSelfEvaluating: visitedSet]]]!

key
	"Answer the lookup key of the receiver."

	^key
!

key: aKey
	"Set the lookup key of the receiver. Normally this is only done when initializing the
	Association as changing the key of an Association stored in a Dictionary will break that
	Dictionary."

	key := aKey
!

key: aKey value: aValue
	"Private - Set the instance variables of the receiver to aKey->aValue"

	key := aKey.
	value := aValue.
	^self!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream visit: self
		do: 
			[aStream
				print: key;
				nextPutAll: ' -> ';
				print: value]!

printString
	"Answer a <readableString> whose characters are a description of the receiver as a developer would want to see it."

	"Implementation Note: Override back to implementation that limits possible output, as Associations can go recursive and/or contain large strings, etc."

	^self printStringLimitedTo: 2000!

setKey: aKey
	<mutable>
	key := aKey!

setValue: anObject
	<mutable>
	value := anObject!

value
	"Answer the 'value' of the receiver."

	^value!

value: aValue
	"Set the 'value' of the receiver. N.B. The meaning of #value: to an Association 
	is not the same as that defined by the ANSI monadic valuable protocol."

	value := aValue
! !

!Core.Association categoriesForMethods!
<!comparing!public! !
<=!comparing!public! !
<==>!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
displayOn:!printing!public! !
hash!comparing!public! !
isSelfEvaluating!public!testing! !
isSelfEvaluating:!private!testing! !
key!accessing!public! !
key:!initializing!public! !
key:value:!initializing!private! !
printOn:!printing!public! !
printString!printing!public! !
setKey:!accessing!private! !
setValue:!accessing!private! !
value!accessing!public! !
value:!accessing!public! !
!

Core.Association methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!Core.Association class methodsFor!

key: aKey value: aValue 
	"Answer a new instance of the receiver whose key is aKey and
	value is aValue."

	^self new key: aKey value: aValue! !

!Core.Association class categoriesForMethods!
key:value:!instance creation!public! !
!

