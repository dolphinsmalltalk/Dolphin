"Filed out from Dolphin Smalltalk"!

IdentityDictionary variableSubclass: #MethodDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MethodDictionary guid: (GUID fromString: '{87b4c530-026e-11d3-9fd7-00a0cc3e4a32}')!

MethodDictionary comment: 'MethodDictionary is a specialized form of <IdentityDictionary> designed for ease and speed of access by the execution machinery. As the name implies, method dictionaries are used to map method selectors to the corresponding compiled method in a particular class.

The primary difference from an ordinary identity dictionary in the current implementation is that method dictionaries are a power of 2 in size to speed up the masking of hash values to the permissible range during method lookup.

You should not rely on the implementation details of this class, and nor should you change them or the instance shape.'!

!MethodDictionary categoriesForClass!Collections-Unordered!Kernel-Support! !

!MethodDictionary methodsFor!

findKeyOrNil: anObject
	"Private - Answer the index of the given key in the receiver, or, if not found, the index of the first empty slot including and after that to which the key hashes."

	| index mask |
	mask := self basicSize - 1.
	index := (anObject basicIdentityHash bitAnd: mask) + 1.
	
	[| key |
	(key := self basicAt: index) isNil or: [key == anObject]]
			whileFalse: [index := (index bitAnd: mask) + 1].
	^index!

hash: anObject max: anInteger
	"Implementation Note: This must match the selector hashing implementation used by the VM."

	^(anObject basicIdentityHash bitAnd: anInteger - 1) + 1!

privateAt: index put: newObject
	"Private - Insert newObject as the element of the receiver at index. Attempts to maintain the
	'optimal' load factor (and thereby ensures there is always a least one empty slot in the Set, an 
	invariant required by the search algorithm)."

	| capacity |
	self basicAt: index put: newObject.
	tally := tally + 1.
	capacity := self basicSize.
	(capacity - tally bitShift: 2) < capacity ifTrue: [self grow].
	^newObject!

removeKey: key ifAbsent: exceptionHandler 
	"Remove the key (and its associated value), from the receiver. If key is not in the 
	receiver, answer the result of evaluating the niladic valuable, exceptionHandler.
	Otherwise, answer the value named by key.
	Implementation Note: Override to perform the update in a copy which is then
	swapped with the receiver. This is to avoid any problems with removing methods
	from the Dictionary hierarchy causing the method dictionaries of these classes
	to become temporarily invalid."

	| index |
	index := self findKeyOrNil: key.
	^(self basicAt: index) isNil 
		ifTrue: [exceptionHandler value]
		ifFalse: 
			[| newMe value |
			value := values basicAt: index.
			newMe := self copy.
			newMe basicValues basicAt: index put: nil.
			newMe removeIndex: index.
			self become: newMe.
			value]! !

!MethodDictionary categoriesForMethods!
findKeyOrNil:!private!searching! !
hash:max:!private!searching! !
privateAt:put:!accessing!private! !
removeKey:ifAbsent:!public!removing! !
!

!MethodDictionary class methodsFor!

defaultCapacity
	^1!

sizeFor: anInteger
	"Private - Answer the <integer> size of collection that should be created to hold 
	the number of elements specified by the <integer> argument, capacity."

	"Implementation Note: Round up to the nearest power of 2, as required 
	by the VM, and avoid any dependency on the superclass sizing scheme."

	^anInteger < 2 ifTrue: [2] ifFalse: [1 bitShift: ((anInteger - 1) * 100 // 75 + 1) highBit]! !

!MethodDictionary class categoriesForMethods!
defaultCapacity!constants!private! !
sizeFor:!instance creation!private! !
!

