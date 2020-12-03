"Filed out from Dolphin Smalltalk 7"!

Core.SortAlgorithm subclass: #'Kernel.PluggableSortAlgorithm'
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.PluggableSortAlgorithm guid: (Core.GUID fromString: '{725a8310-4a25-47fa-ba80-9dcef64b53e2}')!
Kernel.PluggableSortAlgorithm isNonInstantiable: true!
Kernel.PluggableSortAlgorithm comment: 'PluggableSortAlgorithm is the class of <SortAlgorithm>s that allow the sort order relationship between elements to be configured by means of a pluggable sort block.

Instance Variables:
	sortBlock		<dyadicValuable> defines the sort-order relationship.

'!
!Kernel.PluggableSortAlgorithm categoriesForClass!Kernel-Objects! !
!Kernel.PluggableSortAlgorithm methodsFor!

compare: operand1 with: operand2 
	"Answer whether the <Object>, operand1, should sort before the <Object> argument, operand2,
	using the receiver's comparison method."

	^sortBlock value: operand1 value: operand2!

setSortBlock: aDyadicValuable 
	sortBlock := aDyadicValuable!

sortBlock
	"Answer a <dyadicVariable> that implements the sort-order comparison in use by the receiver."

	^sortBlock! !
!Kernel.PluggableSortAlgorithm categoriesFor: #compare:with:!comparing!public! !
!Kernel.PluggableSortAlgorithm categoriesFor: #setSortBlock:!initializing!private! !
!Kernel.PluggableSortAlgorithm categoriesFor: #sortBlock!accessing!public! !

!Kernel.PluggableSortAlgorithm class methodsFor!

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
!Kernel.PluggableSortAlgorithm class categoriesFor: #new!public! !
!Kernel.PluggableSortAlgorithm class categoriesFor: #newSortBlock:!instance creation!public! !

