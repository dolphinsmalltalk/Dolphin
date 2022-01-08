"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.AddClassChange'
	instanceVariableNames: 'definition superclassName instanceVariableNames classVariableNames imports category classConstants'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddClassChange guid: (Core.GUID fromString: '{441f8dc3-4a20-4e6d-9311-c190ceb74f11}')!
Refactory.Browser.AddClassChange comment: ''!
!Refactory.Browser.AddClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.AddClassChange methodsFor!

= anAddClassChange 
	self class = anAddClassChange class ifFalse: [^false].
	^definition = anAddClassChange definition!

afterText
	^self definition!

areSubclassCreationMessageArgumentsValid: aMessageNode
	^aMessageNode arguments allSatisfy: [:each | each isLiteralNode or: [each isDynamicArray]]!

asUndoOperation
	| class |
	class := self classReference valueOrNil.
	^class isBehavior
		ifTrue: [self class definition: class definition]
		ifFalse: [RemoveClassChange removeClassName: self changeClassName]!

category
	category isNil ifTrue: [self fillOutDefinition].
	^category!

changeClassName
	^self classReference asString!

changeString
	^'Define ' , self displayClassName!

classConstants
	classConstants isNil ifTrue: [self fillOutDefinition].
	classConstants isString ifTrue: [classConstants := Compiler evaluate: classConstants].
	^classConstants!

classReference
	^classReference
		ifNil: 
			[self fillOutDefinition.
			classReference]!

classVariableNames
	classVariableNames isNil ifTrue: [self fillOutDefinition].
	^classVariableNames!

controller
	^nil!

definingSuperclass
	^self class!

definition
	^definition!

definition: aString 
	definition := aString!

fillOutDefinition
	| parseTree |
	parseTree := RBParser parseExpression: definition onError: [:str :pos | ^self parseDefinitionError].
	parseTree isMessage ifFalse: [^self parseDefinitionError].
	(self isValidSubclassCreationMessage: parseTree) ifFalse: [^self parseDefinitionError].
	superclassName := parseTree receiver isVariable
				ifTrue: [parseTree receiver name asSymbol]
				ifFalse: [parseTree receiver value].
	self fillOutDefinitionArguments: parseTree!

fillOutDefinitionArguments: parseTree
	| args keywords pairs |
	args := parseTree arguments.
	keywords := parseTree selector keywords.
	pairs := LookupTable new.
	keywords with: args do: [:eachKeyword :eachArg | pairs at: eachKeyword put: eachArg].
	"The new class name is always the 1st argument, but might have differing selector keywords, so look up by position"
	classReference := (args at: 1) value asQualifiedReference.
	instanceVariableNames := self namesIn: (pairs at: 'instanceVariableNames:') value.
	classVariableNames := self namesIn: (pairs at: 'classVariableNames:') value.
	imports := (pairs lookup: 'imports:')
				ifNil: [(pairs lookup: 'poolDictionaries:') ifNil: [#()] ifNotNil: [:arg | self namesIn: arg value]]
				ifNotNil: 
					[:arg |
					arg children collect: [:each | BindingReference pathString: each pathString private: each isPrivate]].
	category := (pairs lookup: 'category:') ifNil: [#Unknown] ifNotNil: [:arg | arg value asSymbol].
	"We defer evaluating the brace array expression until needed, as mostly it is not"
	classConstants := (pairs lookup: 'classConstants:')
				ifNil: [#()]
				ifNotNil: [:arg | arg formattedCode]!

hash
	^definition hash!

imports
	imports isNil ifTrue: [self fillOutDefinition].
	^imports!

instanceVariableNames
	instanceVariableNames isNil ifTrue: [self fillOutDefinition].
	^instanceVariableNames!

isValidMessageName: aMessageNode
	^##(#(
	#subclass:instanceVariableNames:classVariableNames:poolDictionaries: 
	#subclass:instanceVariableNames:classVariableNames:poolDictionaries:category: 
	#variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries: 
	#variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:
	#variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries: 
	#variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:
	#subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:
	#variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:
	#variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:
	#subclass:instanceVariableNames:classVariableNames:imports: 
	#subclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:
	#variableSubclass:instanceVariableNames:classVariableNames:imports: 
	#variableSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants: 
	#variableByteSubclass:instanceVariableNames:classVariableNames:imports: 
	#variableByteSubclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:) asSet)
		includes: aMessageNode selector!

isValidSubclassCreationMessage: aMessageNode
	(aMessageNode receiver isVariable or: [aMessageNode receiver isLiteralNode]) ifFalse: [^false].
	(self isValidMessageName: aMessageNode) ifFalse: [^false].
	^self areSubclassCreationMessageArgumentsValid: aMessageNode!

namesIn: aString 
	^aString subStrings!

parseDefinitionError
	classReference := #{Unknown}.
	instanceVariableNames := #().
	classVariableNames := #().
	imports := #().
	classConstants := #()!

primitiveExecute
	#rbFix. "rbDmm changed "

	^self definingSuperclass compilerClass evaluate: definition.




!

printOn: aStream 
	aStream
		nextPutAll: definition;
		nextPut: $!!!

superclassName
	self classReference.
	^superclassName! !
!Refactory.Browser.AddClassChange categoriesForMethods!
=!comparing!public! !
afterText!printing!public! !
areSubclassCreationMessageArgumentsValid:!private!testing! !
asUndoOperation!converting!public! !
category!accessing!public! !
changeClassName!accessing!public! !
changeString!printing!public! !
classConstants!accessing!public! !
classReference!accessing!private! !
classVariableNames!accessing!public! !
controller!accessing!private! !
definingSuperclass!accessing!private! !
definition!accessing!private! !
definition:!initializing!public! !
fillOutDefinition!helpers!private! !
fillOutDefinitionArguments:!helpers!private! !
hash!comparing!public! !
imports!accessing!public! !
instanceVariableNames!accessing!public! !
isValidMessageName:!private!testing! !
isValidSubclassCreationMessage:!private!testing! !
namesIn:!helpers!private! !
parseDefinitionError!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
superclassName!accessing!public! !
!

!Refactory.Browser.AddClassChange class methodsFor!

definition: aString 
	^self new definition: aString! !
!Refactory.Browser.AddClassChange class categoriesForMethods!
definition:!instance creation!public! !
!

