"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #Association
	instanceVariableNames: 'key value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Association guid: (GUID fromString: '{87b4c650-026e-11d3-9fd7-00a0cc3e4a32}')!
Association comment: 'Association is a simple class to encapsulate the relationship between
a key and a value. It is used for the elements of Dictionaries.'!
!Association categoriesForClass!Collections-Support! !
!Association methodsFor!

< anAssociation 
	"Answer whether the receiver is considered 'less than' the argument."

	^key < anAssociation key!

<= operand
	^key <= operand key!

= anAssociation 
	"Answer whether the receiver is equal to the argument."

	^self species == anAssociation species 
		and: [key = anAssociation key
		and: [value = anAssociation value]]!

displayOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		display: key;
		nextPutAll: ' -> ';
		display: value!

hash
	"Answer the hash value of the receiver's key."

	^key hash
!

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
	"Set the instance variables of the receiver to aKey->aValue"

	key := aKey.
	value := aValue
!

owningPackage: aPackage
	aPackage addVariableNamed: self key!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream 
		print: key;
		nextPutAll: ' -> ';
		print: value!

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
!Association categoriesFor: #<!comparing!public! !
!Association categoriesFor: #<=!comparing!public! !
!Association categoriesFor: #=!comparing!public! !
!Association categoriesFor: #displayOn:!printing!public! !
!Association categoriesFor: #hash!comparing!public! !
!Association categoriesFor: #key!accessing!public! !
!Association categoriesFor: #key:!initializing!public! !
!Association categoriesFor: #key:value:!initializing!public! !
!Association categoriesFor: #owningPackage:!accessing!development!public! !
!Association categoriesFor: #printOn:!printing!public! !
!Association categoriesFor: #setKey:!accessing!private! !
!Association categoriesFor: #setValue:!accessing!private! !
!Association categoriesFor: #value!accessing!public! !
!Association categoriesFor: #value:!accessing!public! !

Association methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!Association class methodsFor!

key: aKey value: aValue 
	"Answer a new instance of the receiver whose key is aKey and
	value is aValue."

	<primitive: 157>
	^self new key: aKey value: aValue! !
!Association class categoriesFor: #key:value:!instance creation!public! !

