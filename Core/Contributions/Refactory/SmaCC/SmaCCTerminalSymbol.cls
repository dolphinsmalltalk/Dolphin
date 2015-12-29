"Filed out from Dolphin Smalltalk XP"!

SmaCCSymbol subclass: #SmaCCTerminalSymbol
	instanceVariableNames: 'regularExpression createIdMethod'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCTerminalSymbol guid: (GUID fromString: '{6C23BDB0-55E1-427B-ACDA-17E99B10A15D}')!
SmaCCTerminalSymbol comment: 'SmaCCTerminalSymbol represents a terminal symbol in our grammar.

Instance Variables:
	createIdMethod	<Boolean>	should we create a symbolNameId method for this symbol.
	regularExpression	<SmaCCRegularExpression>	our regular expression that we must match for this terminal symbol'!
!SmaCCTerminalSymbol categoriesForClass!SmaCC Runtime! !
!SmaCCTerminalSymbol methodsFor!

calculateFirstTerminals
	^false!

createIdMethod
	^createIdMethod!

createIdMethod: aBoolean
	createIdMethod := aBoolean!

isTerminal
	^true!

name: aString 
	super name: aString.
	firstItems add: self.
	createIdMethod := false!

regularExpression
	^regularExpression!

regularExpression: aScannerNode
	regularExpression := aScannerNode! !
!SmaCCTerminalSymbol categoriesFor: #calculateFirstTerminals!private! !
!SmaCCTerminalSymbol categoriesFor: #createIdMethod!accessing!public! !
!SmaCCTerminalSymbol categoriesFor: #createIdMethod:!accessing!public! !
!SmaCCTerminalSymbol categoriesFor: #isTerminal!public!testing! !
!SmaCCTerminalSymbol categoriesFor: #name:!initialize-release!public! !
!SmaCCTerminalSymbol categoriesFor: #regularExpression!accessing!public! !
!SmaCCTerminalSymbol categoriesFor: #regularExpression:!accessing!public! !

