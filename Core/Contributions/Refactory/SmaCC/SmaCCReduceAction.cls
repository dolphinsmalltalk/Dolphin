"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

SmaCCAction subclass: #SmaCCReduceAction
	instanceVariableNames: 'symbol rhs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCReduceAction guid: (GUID fromString: '{886D9D1E-3E49-476A-B7A6-C033019854D2}')!
SmaCCReduceAction comment: 'SmaCCReduceAction represents a reduce action in our parser''s table.

Instance Variables:
	rhs	<SmaCCRHS>	the rhs that is being reduced
	symbol	<SmaCCNonTerminalSymbol>	the symbol that has the rhs'!
!SmaCCReduceAction categoriesForClass!SmaCC Runtime! !
!SmaCCReduceAction methodsFor!

id
	^2r10!

isReduce
	^true!

rhs
	^rhs!

size
	^rhs size!

symbol
	^symbol!

symbol: aSymbol rhs: aRHS
	rhs := aRHS.
	symbol := aSymbol! !
!SmaCCReduceAction categoriesFor: #id!accessing!public! !
!SmaCCReduceAction categoriesFor: #isReduce!public!testing! !
!SmaCCReduceAction categoriesFor: #rhs!accessing!public! !
!SmaCCReduceAction categoriesFor: #size!accessing!public! !
!SmaCCReduceAction categoriesFor: #symbol!accessing!public! !
!SmaCCReduceAction categoriesFor: #symbol:rhs:!initialize-release!public! !

!SmaCCReduceAction class methodsFor!

symbol: aSymbol rhs: aRHS
	^self new symbol: aSymbol rhs: aRHS! !
!SmaCCReduceAction class categoriesFor: #symbol:rhs:!instance creation!public! !

