"Filed out from Dolphin Smalltalk 7"!

AddClassChange subclass: #DolphinAddClassChange
	instanceVariableNames: 'classConstants'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinAddClassChange guid: (GUID fromString: '{aa997683-c5f3-48d4-99c3-38db54fd285a}')!
DolphinAddClassChange comment: ''!
!DolphinAddClassChange categoriesForClass!Refactory-Change Objects! !
!DolphinAddClassChange methodsFor!

areSubclassCreationMessageArgumentsValid: aMessageNode
	^aMessageNode arguments allSatisfy: [:each | each isLiteralNode or: [each isDynamicArray]]!

classConstants
	classConstants isNil ifTrue: [self fillOutDefinition].
	^classConstants!

fillOutDefinitionArguments: parseTree
	| args keywords pairs |
	args := parseTree arguments.
	keywords := parseTree selector keywords.
	pairs := LookupTable new.
	keywords with: args do: [:eachKeyword :eachArg | pairs at: eachKeyword put: eachArg].
	className := (pairs at: 'subclass:') value.
	instanceVariableNames := self namesIn: (pairs at: 'instanceVariableNames:') value.
	classVariableNames := self namesIn: (pairs at: 'classVariableNames:') value.
	poolDictionaryNames := self namesIn: (pairs at: 'poolDictionaries:') value.
	category := (pairs lookup: 'category:') ifNil: [#Unknown] ifNotNil: [:arg | arg value asSymbol].
	classConstants := (pairs lookup: 'classConstants:')
				ifNotNil: [:arg | arg childrenDo: [:each | each halt]]!

isValidMessageName: aMessageNode
	^(#(#subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants: 
		#variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants: 
		#variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants:)
			includes: aMessageNode selector) or: [super isValidMessageName: aMessageNode]!

namesIn: aString 
	^aString subStrings! !
!DolphinAddClassChange categoriesFor: #areSubclassCreationMessageArgumentsValid:!private!testing! !
!DolphinAddClassChange categoriesFor: #classConstants!accessing!public! !
!DolphinAddClassChange categoriesFor: #fillOutDefinitionArguments:!helpers!private! !
!DolphinAddClassChange categoriesFor: #isValidMessageName:!public!testing! !
!DolphinAddClassChange categoriesFor: #namesIn:!helpers!private! !

