"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCSymbol
	instanceVariableNames: 'name precedence firstItems'
	classVariableNames: 'EmptySymbol ErrorSymbol SentinelSymbol'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCSymbol guid: (GUID fromString: '{FDB01FB9-3F0E-4606-997B-E2D7F9A9F5A6}')!
SmaCCSymbol comment: 'SmaCCSymbol is an abstract class that represents a symbol in the grammar.

Subclasses must implement the following messages:
	accessing
		calculateFirstTerminals
	testing
		isTerminal

Instance Variables:
	firstItems	<Collection of: SmaCCTerminalSymbol>	the first terminals that can be produced from us
	name	<String>	our name
	precedence	<Integer>	our precedence (in case of shift/reduce conflicts)

'!
!SmaCCSymbol categoriesForClass!SmaCC Runtime! !
!SmaCCSymbol methodsFor!

calculateFirstTerminals
	^self subclassResponsibility!

createIdMethod
	^false!

firstTerminals
	^firstItems!

isEmptySymbol
	^self = self class empty!

isStartingSymbol
	^false!

isTerminal
	^self subclassResponsibility!

name
	^name!

name: aString 
	name := aString.
	firstItems := Set new!

precedence
	^precedence!

precedence: anInteger
	precedence := anInteger!

printOn: aStream 
	aStream nextPutAll: name!

productionsDo: aBlock!

regularExpression
	^nil!

size
	^0! !
!SmaCCSymbol categoriesFor: #calculateFirstTerminals!accessing!public! !
!SmaCCSymbol categoriesFor: #createIdMethod!accessing!public! !
!SmaCCSymbol categoriesFor: #firstTerminals!accessing!public! !
!SmaCCSymbol categoriesFor: #isEmptySymbol!accessing!public! !
!SmaCCSymbol categoriesFor: #isStartingSymbol!public!testing! !
!SmaCCSymbol categoriesFor: #isTerminal!public!testing! !
!SmaCCSymbol categoriesFor: #name!accessing!public! !
!SmaCCSymbol categoriesFor: #name:!initialize-release!public! !
!SmaCCSymbol categoriesFor: #precedence!accessing!public! !
!SmaCCSymbol categoriesFor: #precedence:!accessing!public! !
!SmaCCSymbol categoriesFor: #printOn:!printing!public! !
!SmaCCSymbol categoriesFor: #productionsDo:!accessing!public! !
!SmaCCSymbol categoriesFor: #regularExpression!accessing!public! !
!SmaCCSymbol categoriesFor: #size!accessing!public! !

!SmaCCSymbol class methodsFor!

empty
	EmptySymbol isNil 
		ifTrue: [EmptySymbol := SmaCCTerminalSymbol name: 'E O F'].
	^EmptySymbol!

error
	ErrorSymbol isNil 
		ifTrue: [ErrorSymbol := SmaCCTerminalSymbol name: 'error'].
	^ErrorSymbol!

name: aString 
	^(self new)
		name: aString;
		yourself!

onPreStripImage
	self uninitialize!

releaseObjects
	EmptySymbol := nil.
	SentinelSymbol := nil.
	ErrorSymbol := nil!

sentinel
	SentinelSymbol isNil 
		ifTrue: [SentinelSymbol := SmaCCTerminalSymbol name: 'S e n t i n e l'].
	^SentinelSymbol!

uninitialize
	self releaseObjects! !
!SmaCCSymbol class categoriesFor: #empty!instance creation!public! !
!SmaCCSymbol class categoriesFor: #error!instance creation!public! !
!SmaCCSymbol class categoriesFor: #name:!instance creation!public! !
!SmaCCSymbol class categoriesFor: #onPreStripImage!class hierarchy-removing!public! !
!SmaCCSymbol class categoriesFor: #releaseObjects!instance creation!public! !
!SmaCCSymbol class categoriesFor: #sentinel!instance creation!public! !
!SmaCCSymbol class categoriesFor: #uninitialize!class hierarchy-removing!public! !

