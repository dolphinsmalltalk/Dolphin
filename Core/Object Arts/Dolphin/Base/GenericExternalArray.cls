"Filed out from Dolphin Smalltalk"!

ExternalArray subclass: #GenericExternalArray
	instanceVariableNames: 'elementClass owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GenericExternalArray guid: (GUID fromString: '{a784c4d3-dd39-4844-b096-400529d9295c}')!

GenericExternalArray isAbstract: true!

GenericExternalArray comment: 'GenericExternalArray is an abstract class of <ExternalArray>s that can be used to represent single-dimensioned arrays of more than one type.

Instance Variables:
	elementClass	<Class> of element, typically an <ExternalStructure>.
	owner		<Object>. Object responsible for freeing the underlying array. Typically nil, in which case the receiver is responsible.
'!

!GenericExternalArray categoriesForClass!External-Data-Structured! !

!GenericExternalArray methodsFor!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	any element of the receiver.
	Implementation Note: The argument is evaluated for every element of the
	receiver iff it evaluates to false for every element."

	self
		uncheckedFrom: 1
		to: self size
		keysAndValuesDo: [:i :elem | (discriminator value: elem) ifTrue: [^true]].
	^false!

asArray
	"Answer an <Array> containing the constituent elements of the receiver."

	^self collect: [:each | each asObject]!

base
	^self yourAddress!

elementClass
	"Answer the class of <ExternalStructure> used to represent the receiver's elements."

	^elementClass!

elementClass: aClass 
	"Private - Set the class of Smalltalk object used to represent the elements	of the receiver."

	elementClass := aClass!

hash
	"Answer the SmallInteger hash value for the receiver.
	In order for internal structure to have the same value as pointer structures
	we use the VM export here."

	^VMLibrary default hashBytes: self base count: self comparisonSize!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources.
	In most cases we don't want to free if this object is a reference to an array of
	structures held elsewhere, since that that would be rather rude."

	^self notNull and: [owner isNil]!

newElementAt: anAddress 
	"Answer a new reference instance of the receiver's element class, pointing at the element
	at the specified memory address."

	^self elementClass atAddress: anAddress!

owner: arrayOwner
	"Set the object responsible for managing the storage allocated for the underlying elements.
	This is used both to keep that object alive while the receiver is alive, and to determine
	who should free the elements. If nil then the receiver frees the elements by passing them
	back to their class' #free: method, otherwise it is assumed that the owner will free them
	when it no longer requires them."

	(arrayOwner isNil or: [arrayOwner == self])
		ifTrue: [owner := nil. self beFinalizable]
		ifFalse: [owner := arrayOwner. self beUnfinalizable]!

uncheckedAt: anInteger 
	"Private - Answer an instance of the receiver's elementClass which is a reference to the
	element of the receiver at the specified <integer> index. No bounds checks are performed on
	the subscript."

	^self newElementAt: self base + ((anInteger - 1) * self packing)!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: operation 
	"Private - Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the specified, inclusive, <integer> indices with the element and its index as
	respectively the second and first arguments. No bounds checking is performed. "

	"Implementation Note: Override for improved performance (reduction of address calculations).
	By overriding this one method, we improve the performance of all enumerators."

	| address spacing |
	spacing := self packing.
	address := self base + ((startInteger - 1) * spacing).
	startInteger to: stopInteger
		do: 
			[:i | 
			operation value: i value: (self newElementAt: address).
			address := address + spacing]! !

!GenericExternalArray categoriesForMethods!
anySatisfy:!enumerating!public! !
asArray!converting!public! !
base!accessing!private! !
elementClass!accessing!public! !
elementClass:!accessing!private! !
hash!comparing!public! !
needsFree!initializing!private!realizing/unrealizing! !
newElementAt:!helpers!private! !
owner:!accessing!private! !
uncheckedAt:!accessing!private! !
uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !
!

!GenericExternalArray class methodsFor!

length: length elementClass: elementClass 
	"Answer a new vector (single dimensioned) array that 
	contains <integer>, length, elements of type, elementClass."

	^self subclassResponsibility!

withAll: aCollection elementClass: structClass 
	"Answer a new instance of the receiver containing all of the elements of the <collection> 
	argument, represented in the format of the <ExternalStructure> class argument.  An error 
	will be raised if any of the elements cannot be represented as instances of the element class."

	| answer |
	answer := self length: aCollection size elementClass: structClass.
	aCollection inject: 1
		into: 
			[:i :elem | 
			answer at: i put: elem.
			i + 1].
	^answer! !

!GenericExternalArray class categoriesForMethods!
length:elementClass:!instance creation!public! !
withAll:elementClass:!instance creation!public! !
!

