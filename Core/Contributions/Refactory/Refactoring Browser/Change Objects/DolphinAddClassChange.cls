"Filed out from Dolphin Smalltalk 7"!

AddClassChange subclass: #DolphinAddClassChange
	instanceVariableNames: 'classConstants'
	classVariableNames: ''
	imports: #()
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
	className := args first value.
	instanceVariableNames := self namesIn: (pairs at: 'instanceVariableNames:') value.
	classVariableNames := self namesIn: (pairs at: 'classVariableNames:') value.
	poolDictionaryNames := (pairs lookup: 'imports:')
				ifNil: [(pairs lookup: 'poolDictionaries:') ifNil: [#()] ifNotNil: [:arg | self namesIn: arg value]]
				ifNotNil: [:arg | arg children collect: [:each | each value]].
	category := (pairs lookup: 'category:') ifNil: [#Unknown] ifNotNil: [:arg | arg value asSymbol].
	"We defer evaluating the brace array expression until needed, as mostly it is not"
	classConstants := (pairs lookup: 'classConstants:')
				ifNil: [#()]
				ifNotNil: [:arg | arg formattedCode]!

isValidMessageName: aMessageNode
	^(#(#subclass:instanceVariableNames:classVariableNames:imports: #subclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants: #variableSubclass:instanceVariableNames:classVariableNames:imports: #variableSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants: #variableByteSubclass:instanceVariableNames:classVariableNames:imports: #variableByteSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:)
		includes: aMessageNode selector) or: [super isValidMessageName: aMessageNode]!

namesIn: aString 
	^aString subStrings! !
!DolphinAddClassChange categoriesFor: #areSubclassCreationMessageArgumentsValid:!private!testing! !
!DolphinAddClassChange categoriesFor: #classConstants!accessing!public! !
!DolphinAddClassChange categoriesFor: #fillOutDefinitionArguments:!helpers!private! !
!DolphinAddClassChange categoriesFor: #isValidMessageName:!public!testing! !
!DolphinAddClassChange categoriesFor: #namesIn:!helpers!private! !

