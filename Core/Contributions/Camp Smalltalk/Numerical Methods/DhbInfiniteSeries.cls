"Filed out from Dolphin Smalltalk XP"!

DhbIterativeProcess subclass: #DhbInfiniteSeries
	instanceVariableNames: 'termServer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DhbInfiniteSeries guid: (GUID fromString: '{E5500292-7D2B-11D6-B6CC-00022D5019C8}')!
DhbInfiniteSeries comment: ''!
!DhbInfiniteSeries categoriesForClass!DHB Numerical! !
!DhbInfiniteSeries methodsFor!

evaluateIteration
		"Perform one iteration.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	| delta |
	delta := termServer termAt: iterations.
	result := result + delta.
	^self precisionOf: delta abs relativeTo: result abs!

initialize: aTermServer
		"Private - Assigns the object responsible to compute each term.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	termServer := aTermServer.
	^self!

initializeIterations
	"Initialize the series.
		 (c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "

	result := termServer initialTerm! !
!DhbInfiniteSeries categoriesFor: #evaluateIteration!operation!public! !
!DhbInfiniteSeries categoriesFor: #initialize:!initialization!public! !
!DhbInfiniteSeries categoriesFor: #initializeIterations!operation!public! !

!DhbInfiniteSeries class methodsFor!

server: aTermServer
		"(c) Copyrights Didier BESSET, 1999, all rights reserved.
		 Initial code: 15/3/99 "
	^self new initialize: aTermServer! !
!DhbInfiniteSeries class categoriesFor: #server:!creation!public! !

