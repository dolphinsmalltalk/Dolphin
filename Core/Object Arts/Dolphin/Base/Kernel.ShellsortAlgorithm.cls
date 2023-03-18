"Filed out from Dolphin Smalltalk"!

Kernel.PluggableSortAlgorithm
	subclass: #'Kernel.ShellsortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ShellsortAlgorithm guid: (Core.GUID fromString: '{10f42ee9-007e-446c-9c87-5e71a22dd423}')!
Kernel.ShellsortAlgorithm comment: 'ShellsortAlgorithm implements the Shellsort algorithm as a pluggable sorting strategy for use in conjunction with <SortedCollection>s.

Shellsort is a relatively simple modification of the basic insertion sort method, which improves performance by allowing the exchange of elements that are far apart, not just those which are adjacent.

On average Shellsort is slower than Quicksort, but is quick for partially sorted files, and doesn''t have a bad worst case. Shellsort is a reasonable choice when sorting collections that are already sorted (perhaps in the opposite order), or which contain large numbers of sort-equal elements.

Like Quicksort, Shellsort is not a stable sort, in that it does not preserve any previous ordering between sort-equal elements.'!
!Kernel.ShellsortAlgorithm categoriesForClass!Kernel-Objects! !
!Kernel.ShellsortAlgorithm methodsFor!

sort: anObject from: startInteger to: stopInteger
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the receiver's sort block."

	| d |
	d := stopInteger - startInteger + 1.
	[d > 1] whileTrue: 
			[| i |
			d := d < 5 ifTrue: [1] ifFalse: [(5 * d - 1) // 11].
			i := stopInteger - d.
			[i >= startInteger] whileTrue: 
					[| ei j ej |
					ei := anObject basicAt: i.
					j := i + d.
					[j <= stopInteger and: [sortBlock value: (ej := anObject basicAt: j) value: ei]] whileTrue: 
							[anObject basicAt: j - d put: ej.
							j := j + d].
					anObject basicAt: j - d put: ei.
					i := i - 1]]! !
!Kernel.ShellsortAlgorithm categoriesForMethods!
sort:from:to:!algorithms!operations!public! !
!

