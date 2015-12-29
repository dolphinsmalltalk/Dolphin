"Filed out from Dolphin Smalltalk XP"!

SmaCCSymbol subclass: #SmaCCNonTerminalSymbol
	instanceVariableNames: 'productions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCNonTerminalSymbol guid: (GUID fromString: '{7EF5251F-8716-49D2-9AF4-ABBF2BC26EC0}')!
SmaCCNonTerminalSymbol comment: 'SmaCCNonTerminalSymbol represents a non-terminal symbol in our grammar.

Instance Variables:
	productions	<SequenceableCollection of: SmaCCRHS>	our rhs'' for the symbol'!
!SmaCCNonTerminalSymbol categoriesForClass!SmaCC Runtime! !
!SmaCCNonTerminalSymbol methodsFor!

addProduction: aRHS
	productions add: aRHS!

calculateFirstTerminals
	| initialSize |
	initialSize := firstItems size.
	productions isEmpty 
		ifTrue: [firstItems add: self class empty]
		ifFalse: [productions do: [:each | firstItems addAll: each firstTerminals]].
	^initialSize ~= firstItems size!

isEmpty
	^productions isEmpty!

isTerminal
	^false!

name: aString 
	super name: aString.
	productions := OrderedCollection new!

positionOf: aRHS 
	^productions indexOf: aRHS!

productionsDo: aBlock 
	productions do: aBlock!

size
	^productions size! !
!SmaCCNonTerminalSymbol categoriesFor: #addProduction:!accessing!public! !
!SmaCCNonTerminalSymbol categoriesFor: #calculateFirstTerminals!accessing!public! !
!SmaCCNonTerminalSymbol categoriesFor: #isEmpty!public!testing! !
!SmaCCNonTerminalSymbol categoriesFor: #isTerminal!public!testing! !
!SmaCCNonTerminalSymbol categoriesFor: #name:!initialize-release!public! !
!SmaCCNonTerminalSymbol categoriesFor: #positionOf:!accessing!public! !
!SmaCCNonTerminalSymbol categoriesFor: #productionsDo:!accessing!public! !
!SmaCCNonTerminalSymbol categoriesFor: #size!accessing!public! !

