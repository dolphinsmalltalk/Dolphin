"Filed out from Dolphin Smalltalk 7"!

Core.LookupTable variableSubclass: #'Core.PluggableLookupTable'
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.PluggableLookupTable guid: (Core.GUID fromString: '{123a1504-7cb8-11d3-93ca-00a024ca708a}')!
Core.PluggableLookupTable comment: 'PluggableLookupTable is the class of <LookupTable>s which support a pluggable <searchPolicy>, and which can thus be configured to behave in the same way as either standard <LookupTable>s (equality search) or <IdentityDictionary>s (identity search), or indeed any user-defined search policy.

Instance Variables:
	searchPolicy		<searchPolicy>. The policy used to hash and compare elements of the receiver.

'!
!Core.PluggableLookupTable categoriesForClass!Collections-Unordered! !
!Core.PluggableLookupTable methodsFor!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver, with enough space for anInteger
	number of elements. 
	Implementation Note: We must override in order to preserve the searchPolicy."

	^(super copyEmpty: anInteger) setSearchPolicy: self searchPolicy!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"As the transformations performed when copying can be arbitrary, we revert to a generic LookupTable."

	^LookupTable!

findKeyOrNil: anObject
	"Private - Answer the <integer> index of the given key in the receiver, or, if not found,
	the index of the first empty slot including and after that to which 
	the key hashes. A pluggable <searchPolicy> is used for key comparisons and hashing."

	| policy capacity index |
	index := (policy := self searchPolicy) hash: anObject max: (capacity := self basicSize).
	
	[| key |
	(key := self basicAt: index) isNil or: [policy compare: key with: anObject]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

hash: anObject max: anInteger
	^self searchPolicy hash: anObject max: anInteger!

initialize
	"Private - Instance variable initialization. The tally records the number of elements."

	super initialize.
	self setSearchPolicy: self class defaultSearchPolicy
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

setSearchPolicy: policy
	"Private - Set the receiver's <searchPolicy>. Answer the receiver."

	searchPolicy := policy.
	^self! !
!Core.PluggableLookupTable categoriesFor: #copyEmpty:!copying!private! !
!Core.PluggableLookupTable categoriesFor: #copyingClass!copying!private! !
!Core.PluggableLookupTable categoriesFor: #findKeyOrNil:!private!searching! !
!Core.PluggableLookupTable categoriesFor: #hash:max:!private!searching! !
!Core.PluggableLookupTable categoriesFor: #initialize!initializing!private! !
!Core.PluggableLookupTable categoriesFor: #newSelection!enumerating!private! !
!Core.PluggableLookupTable categoriesFor: #preResize:!adding!public! !
!Core.PluggableLookupTable categoriesFor: #searchPolicy!accessing!public! !
!Core.PluggableLookupTable categoriesFor: #searchPolicy:!accessing!public! !
!Core.PluggableLookupTable categoriesFor: #setSearchPolicy:!accessing!private! !

!Core.PluggableLookupTable class methodsFor!

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
!Core.PluggableLookupTable class categoriesFor: #defaultSearchPolicy!constants!public! !
!Core.PluggableLookupTable class categoriesFor: #new:searchPolicy:!instance creation!public! !
!Core.PluggableLookupTable class categoriesFor: #searchPolicy:!instance creation!public! !

