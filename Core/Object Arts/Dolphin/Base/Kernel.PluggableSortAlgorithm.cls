"Filed out from Dolphin Smalltalk"!

Core.SortAlgorithm
	subclass: #'Kernel.PluggableSortAlgorithm'
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

insertionSort: anObject from: startInteger to: stopInteger
	startInteger + 1 to: stopInteger
		do: 
			[:j |
			| a t i |
			a := anObject basicAt: j.
			i := j.
			[i <= startInteger or: [sortBlock value: (t := anObject basicAt: i - 1) value: a]] whileFalse: 
					[anObject basicAt: i put: t.
					i := i - 1].
			anObject basicAt: i put: a]!

setSortBlock: aDyadicValuable 
	sortBlock := aDyadicValuable!

sift: anObject from: anInteger between: startInteger and: stopInteger
	| val i |
	val := anObject basicAt: anInteger.
	i := anInteger.
	
	[| left right max j leftVal rightVal |
	max := val.
	j := i.
	left := j + j + 1 - startInteger.
	(left <= stopInteger and: [sortBlock value: max value: (leftVal := anObject basicAt: left)])
		ifTrue: 
			[i := left.
			max := leftVal].
	right := left + 1.
	(right <= stopInteger and: [sortBlock value: max value: (rightVal := anObject basicAt: right)])
		ifTrue: 
			[i := right.
			max := rightVal].
	i == j
		ifTrue: 
			[j > anInteger ifTrue: [anObject basicAt: j put: val].
			^self].
	anObject basicAt: j put: max]
			repeat!

sortBlock
	"Answer a <dyadicVariable> that implements the sort-order comparison in use by the receiver."

	^sortBlock! !
!Kernel.PluggableSortAlgorithm categoriesForMethods!
compare:with:!comparing!public! !
insertionSort:from:to:!operations!private! !
setSortBlock:!initializing!private! !
sift:from:between:and:!helpers!private! !
sortBlock!accessing!public! !
!

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
!Kernel.PluggableSortAlgorithm class categoriesForMethods!
new!public! !
newSortBlock:!instance creation!public! !
!

