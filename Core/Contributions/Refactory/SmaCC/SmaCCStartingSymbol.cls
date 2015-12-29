"Filed out from Dolphin Smalltalk XP"!

SmaCCNonTerminalSymbol subclass: #SmaCCStartingSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCStartingSymbol guid: (GUID fromString: '{6A1DD7B8-BF6D-4F66-81A2-2D0DE1317051}')!
SmaCCStartingSymbol comment: 'SmaCCStartingSymbol is the starting symbol in the grammar. A grammar can only have one starting symbol, but it can have may different starting item sets.'!
!SmaCCStartingSymbol categoriesForClass!SmaCC Runtime! !
!SmaCCStartingSymbol methodsFor!

asLRItemSet
	| itemSet |
	itemSet := SmaCCItemSet new.
	productions do: 
			[:each | 
			itemSet add: (SmaCCLR1Item 
						symbol: self
						rhs: each
						follow: ((SmaCCSymbolSet new)
								add: self class empty;
								yourself))].
	^itemSet!

compileName
	^(productions first at: 1) name!

isStartingSymbol
	^true! !
!SmaCCStartingSymbol categoriesFor: #asLRItemSet!accessing!public! !
!SmaCCStartingSymbol categoriesFor: #compileName!accessing!public! !
!SmaCCStartingSymbol categoriesFor: #isStartingSymbol!public!testing! !

