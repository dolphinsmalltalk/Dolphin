"Filed out from Dolphin Smalltalk X6.1"!

ArrayedCollection subclass: #RunArray
	instanceVariableNames: 'values runs '
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RunArray guid: (GUID fromString: '{87B4C513-026E-11D3-9FD7-00A0CC3E4A32}')!
RunArray comment: ''!
!RunArray categoriesForClass!Collections-Arrayed! !
!RunArray methodsFor!

asRunArray
	^self!

at: anInteger
	"Answer the element at index, anInteger, in the receiver."

	| index |
	index := 0.
	1 to: runs size do: [:i |
		index := index + (runs at: i).
		anInteger <= index
			ifTrue: [^values at: i]].
	^self errorSubscriptBounds: anInteger!

at: index put: newElement
	"Replace the element of the receiver at the specified <integer> index with 
	the <Object> argument, newElement. If the index is out of bounds, raise 
	a BoundsError.

	Implementation Note: RunArrays are not mutable."

	^self shouldNotImplement
!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of a RunArray we need to copy the runs and values arrays."

	super postCopy.
	values := values copy.
	runs := runs copy.
	^self!

resize: anInteger
	"Run arrays are not extensible"

	^self shouldNotImplement
!

runs: runsArray values: valuesArray
	"Private - Set the receiver's instance variables."

	runs := runsArray.
	values := valuesArray!

runsAndValuesDo: operation
	runs with: values do: operation!

runStartAndValueAt: anInteger
	"Private - Answer an association between the <dyadicValuable> 
	operation for the element of the receiver at the specified index 
	and the index of the start of the run in which that element occurs.
	The run-start is the key, the element the value."

	| runStart |
	runStart := 1.
	1 to: runs size do: [:i | | nextRun |
		nextRun := runStart + (runs at: i).
		nextRun > anInteger
			ifTrue: [^runStart -> (values at: i)].
		runStart := nextRun].
	^self errorSubscriptBounds: anInteger!

runStartAt: anInteger
	"Answer the index of the start of the run which includes the index anInteger (i.e. the index of
	the first element in the receiver in the run of elements equal to the element at anInteger)."

	| index |
	index := 1.
	runs do: [:run |
		(index + run) > anInteger
			ifTrue: [ ^index ].
		index := index + run].
	^self errorSubscriptBounds: anInteger
!

size
	"Answer the number of elements in the receiver."

	| tally |
	tally := 0.
	1 to: runs size do: [:i | tally := tally + (runs at: i)].
	^tally!

species
	^Array! !
!RunArray categoriesFor: #asRunArray!converting!public! !
!RunArray categoriesFor: #at:!accessing!public! !
!RunArray categoriesFor: #at:put:!accessing!public! !
!RunArray categoriesFor: #postCopy!copying!public! !
!RunArray categoriesFor: #resize:!mutating!public! !
!RunArray categoriesFor: #runs:values:!accessing!private! !
!RunArray categoriesFor: #runsAndValuesDo:!enumerating!public! !
!RunArray categoriesFor: #runStartAndValueAt:!accessing!private! !
!RunArray categoriesFor: #runStartAt:!accessing!public! !
!RunArray categoriesFor: #size!accessing!public! !
!RunArray categoriesFor: #species!accessing!public! !

!RunArray class methodsFor!

new
	"Answer a new, empty, instance of the receiver."

	^self runs: Array new values: Array new!

new: anInteger
	"Answer a new instance of the receiver with anInteger nil elements."

	^self new: anInteger withAll: nil!

new: anInteger withAll: anObject
	"Answer a new instance of the receiver with anInteger elements which are all 
	the argument, anObject."

	^anInteger == 0 
		ifTrue: [self new]
		ifFalse: [self runs: (Array with: anInteger) values: (Array with: anObject)]!

runs: runsArray values: valuesArray
	"Answer a new instance of the receiver with the specified runs and values.
	N.B. The two arrays must be the same size."

	^self basicNew
		runs: runsArray values: valuesArray! !
!RunArray class categoriesFor: #new!instance creation!public! !
!RunArray class categoriesFor: #new:!instance creation!public! !
!RunArray class categoriesFor: #new:withAll:!instance creation!public! !
!RunArray class categoriesFor: #runs:values:!instance creation!public! !

