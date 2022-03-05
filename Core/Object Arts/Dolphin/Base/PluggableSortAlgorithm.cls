"Filed out from Dolphin Smalltalk"!

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

compare: operand1 with: operand2 
	"Answer whether the <Object>, operand1, should sort before the <Object> argument, operand2,
	using the receiver's comparison method."

	^sortBlock value: operand1 value: operand2!

setSortBlock: aDyadicValuable 
	sortBlock := aDyadicValuable!

sortBlock
	"Answer a <dyadicVariable> that implements the sort-order comparison in use by the receiver."

	^sortBlock! !
!PluggableSortAlgorithm categoriesForMethods!
compare:with:!comparing!public! !
setSortBlock:!initializing!private! !
sortBlock!accessing!public! !
!

!PluggableSortAlgorithm class methodsFor!

new
	"Answer a new instance of the receiver with the default sort block."

	^self basicNew
		setSortBlock: [:a :b | a <= b];
		yourself!

newSortBlock: aDyadicValuable
	<primitive: 157>
	^(self basicNew)
		setSortBlock: aDyadicValuable;
		yourself! !
!PluggableSortAlgorithm class categoriesForMethods!
new!public! !
newSortBlock:!instance creation!public! !
!

