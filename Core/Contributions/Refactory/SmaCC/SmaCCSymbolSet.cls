"Filed out from Dolphin Smalltalk XP"!

Model subclass: #SmaCCSymbolSet
	instanceVariableNames: 'symbols components'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCSymbolSet guid: (GUID fromString: '{2A440511-9BA6-4665-BE82-069BA21380C9}')!
SmaCCSymbolSet comment: 'SmaCCSymbolSet represents a set of follow symbols in the LALR(1) item sets.

Instance Variables:
	components	<Collection of: SmaCCSymbolSet>	other SmaCCSymbolSets that we depend on, we include all items in these sets also
	symbols	<Collection of: SmaCCTerminalSymbol>	our follow symbols'!
!SmaCCSymbolSet categoriesForClass!SmaCC Runtime! !
!SmaCCSymbolSet methodsFor!

add: aSymbol 
	(symbols includes: aSymbol) ifTrue: [^self].
	symbols add: aSymbol.
	self changed!

addAll: aCollection 
	| oldSize |
	oldSize := symbols size.
	symbols addAll: aCollection.
	oldSize ~= symbols size ifTrue: [self changed]!

addComponent: each 
	(each = self or: [components includes: each]) ifTrue: [^self].
	components add: each.
	each addDependent: self.
	self addAll: each symbols!

addComponentsFrom: aSymbolSet 
	aSymbolSet components do: [:each | self addComponent: each]!

allSatisfy: aBlock 
	^symbols allSatisfy: aBlock!

baseOn: aSymbolSet 
	self addComponent: aSymbolSet.
	self addAll: aSymbolSet symbols!

components
	^components!

includes: aSymbol 
	^symbols includes: aSymbol!

initialize
	symbols := Set new.
	components := Set new!

mergeWith: aSymbolSet 
	self addAll: aSymbolSet symbols.
	self addComponentsFrom: aSymbolSet!

printOn: aStream 
	symbols do: [:each | aStream nextPutAll: each printString]
		separatedBy: [aStream space]!

size
	^symbols size!

symbols
	^symbols!

update: anAspectSymbol with: aParameter from: aSender 
	(components includes: aSender) ifTrue: [self addAll: aSender symbols]! !
!SmaCCSymbolSet categoriesFor: #add:!accessing!public! !
!SmaCCSymbolSet categoriesFor: #addAll:!accessing!public! !
!SmaCCSymbolSet categoriesFor: #addComponent:!private! !
!SmaCCSymbolSet categoriesFor: #addComponentsFrom:!private! !
!SmaCCSymbolSet categoriesFor: #allSatisfy:!public!testing! !
!SmaCCSymbolSet categoriesFor: #baseOn:!accessing!public! !
!SmaCCSymbolSet categoriesFor: #components!private! !
!SmaCCSymbolSet categoriesFor: #includes:!public!testing! !
!SmaCCSymbolSet categoriesFor: #initialize!initialize-release!public! !
!SmaCCSymbolSet categoriesFor: #mergeWith:!accessing!public! !
!SmaCCSymbolSet categoriesFor: #printOn:!printing!public! !
!SmaCCSymbolSet categoriesFor: #size!accessing!public! !
!SmaCCSymbolSet categoriesFor: #symbols!private! !
!SmaCCSymbolSet categoriesFor: #update:with:from:!public!updating! !

!SmaCCSymbolSet class methodsFor!

basedOn: aSymbolSet 
	^(self new)
		baseOn: aSymbolSet;
		yourself!

new
	^(super new)
		initialize;
		yourself! !
!SmaCCSymbolSet class categoriesFor: #basedOn:!instance creation!public! !
!SmaCCSymbolSet class categoriesFor: #new!instance creation!public! !

