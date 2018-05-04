"Filed out from Dolphin Smalltalk 7"!

SortAlgorithm subclass: #PluggableSortAlgorithm
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableSortAlgorithm guid: (GUID fromString: '{725a8310-4a25-47fa-ba80-9dcef64b53e2}')!
PluggableSortAlgorithm comment: 'PluggableSortAlgorithm is the class of <SortAlgorithm>s that allow the sort order relationship between elements to be configured by means of a pluggable sort block.

Instance Variables:
	sortBlock		<dyadicValuable> defines the sort-order relationship.

'!
!PluggableSortAlgorithm categoriesForClass!Kernel-Objects! !
!PluggableSortAlgorithm methodsFor!

setSortBlock: aDyadicValuable 
	sortBlock := aDyadicValuable!

sortBlock
	"Answer a <dyadicVariable> that implements the sort-order comparison in use by the receiver."

	^sortBlock! !
!PluggableSortAlgorithm categoriesFor: #setSortBlock:!initializing!private! !
!PluggableSortAlgorithm categoriesFor: #sortBlock!accessing!public! !

!PluggableSortAlgorithm class methodsFor!

new
	"Answer a new instance of the receiver with the default sort block."

	^self newSortBlock: [:a :b | a <= b]!

newSortBlock: aDyadicValuable
	<primitive: 157>
	^(self basicNew)
		setSortBlock: aDyadicValuable;
		yourself! !
!PluggableSortAlgorithm class categoriesFor: #new!public! !
!PluggableSortAlgorithm class categoriesFor: #newSortBlock:!instance creation!public! !

