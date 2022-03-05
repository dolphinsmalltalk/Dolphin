"Filed out from Dolphin Smalltalk"!

Set variableSubclass: #PluggableSet
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableSet guid: (GUID fromString: '{faa6a208-2202-4d7e-b342-d9590b9bf6c8}')!
PluggableSet comment: 'PluggableSet is the class of <Set>s which support a pluggable <searchPolicy>, and which can thus be configured to behave in the same way as either standard <Set>s (equality search) or <IdentitySet>s (identity search), or indeed any user-defined search policy.

Instance Variables:
	searchPolicy		<searchPolicy>. The policy used to hash and compare elements of the receiver.'!
!PluggableSet categoriesForClass!Collections-Unordered! !
!PluggableSet methodsFor!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver, with enough space for anInteger
	number of elements. 
	Implementation Note: We must override in order to preserve the searchPolicy."

	^(super copyEmpty: anInteger) setSearchPolicy: self searchPolicy!

findElementOrNil: anObject
	"Private - Answer the index of the given object in the receiver, or, if not found,
	the index of the first empty slot including and after that to which the object hashes.
	A pluggable <searchPolicy> is used for key comparisons and hashing."

	| capacity index |
	index := self hash: anObject max: (capacity := self basicSize).
	
	[| element |
	(element := self basicAt: index) isNil or: [searchPolicy compare: element with: anObject]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^searchPolicy hash: anObject max: anInteger!

initialize
	"Private - Instance variable initialization. The tally records the number of elements."

	super initialize.
	searchPolicy := self class defaultSearchPolicy
!

newSelection
	"Private - Answer a new empty collection like the receiver to 
	contain a selection of the receiver's elements."

	^self class searchPolicy: self searchPolicy!

preResize: newMe
	"This message is sent by the receiver when resizing, before the
	receiver's elements are added to newMe. We must assign across the
	search policy."

	newMe setSearchPolicy: self searchPolicy!

searchPolicy
	"Answer the receiver's <searchPolicy>."

	^searchPolicy!

searchPolicy: aSearchPolicy 
	"Set the receiver's <searchPolicy>."

	self setSearchPolicy: aSearchPolicy.
	self notEmpty ifTrue: [self rehash]!

setSearchPolicy: aSearchPolicy
	"Private - Set the receiver's <searchPolicy>. Answer the receiver."

	searchPolicy := aSearchPolicy.
	^self!

species
	"Answer the class of object to be used when copying the receiver with #collect:, etc."

	^Set
! !
!PluggableSet categoriesForMethods!
copyEmpty:!copying!private! !
findElementOrNil:!private!searching! !
hash:max:!private!searching! !
initialize!initializing!private! !
newSelection!enumerating!private! !
preResize:!adding!public! !
searchPolicy!accessing!public! !
searchPolicy:!accessing!public! !
setSearchPolicy:!accessing!private! !
species!constants!public! !
!

!PluggableSet class methodsFor!

defaultSearchPolicy
	"Answer the default <searchPolicy> used by instances of the receiver."

	^SearchPolicy equality!

new: anInteger searchPolicy: aSearchPolicy
	"Answer a new instance of the receiver with an initial capacity of at least 
	<integer> count elements (i.e. the size is a hint), and with the specified <searchPolicy>."

	^(self new: anInteger) setSearchPolicy: aSearchPolicy!

searchPolicy: policy
	"Answer a new, empty, instance of the receiver with the specified <searchPolicy>."

	^self new setSearchPolicy: policy! !
!PluggableSet class categoriesForMethods!
defaultSearchPolicy!constants!public! !
new:searchPolicy:!instance creation!public! !
searchPolicy:!instance creation!public! !
!

