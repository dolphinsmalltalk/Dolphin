"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.AddClassChange'
	instanceVariableNames: 'definition attributes'
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

areSubclassCreationMessageArgumentsValid: aMessageNode
	^aMessageNode arguments allSatisfy: [:each | each isLiteralNode or: [each isDynamicArray]]!

asUndoOperation
	| class |
	class := self classReference valueOrNil.
	^class isBehavior
		ifTrue: [self class definition: class definition]
		ifFalse: [RemoveClassChange removeClassName: self changeClassName]!

attributes
	^attributes ifNil: [self fillOutDefinition]!

category
	^self attributes category!

changeClassName
	^self attributes className!

changeString
	^'Define <1d>' << self classReference!

classConstants
	^self attributes classConstants!

classReference
	self attributes.
	^classReference!

classVariableNames
	^self attributes classVariableNames!

definingSuperclass
	^self class!

definition
	^definition!

definition: aString 
	definition := aString!

fillOutDefinition
	| parseTree |
	parseTree := Parser parseExpression: definition onError: [:str :pos | ^self parseDefinitionError].
	parseTree isMessage ifFalse: [^self parseDefinitionError].
	(self isValidSubclassCreationMessage: parseTree) ifFalse: [^self parseDefinitionError].
	self fillOutDefinitionArguments: parseTree.
	^attributes!

fillOutDefinitionArguments: parseTree
	| args keywords pairs |
	attributes := ClassAttributes new.
	attributes superclassName: (parseTree receiver isVariable
				ifTrue: [parseTree receiver name asSymbol]
				ifFalse: [parseTree receiver value]).
	args := parseTree arguments.
	keywords := parseTree selector keywords.
	"The new class name is always the 1st argument, but might have differing selector keywords, so look up by position"
	attributes
		className: (classReference := (args at: 1) value);
		kindOfSubclass: (keywords at: 1).
	classReference := attributes className asQualifiedReference.
	pairs := LookupTable new.
	keywords with: args do: [:eachKeyword :eachArg | pairs at: eachKeyword put: eachArg].
	attributes
		instanceVariableNames: (self namesIn: (pairs at: 'instanceVariableNames:') value);
		classVariableNames: (self namesIn: (pairs at: 'classVariableNames:') value).
	(pairs lookup: 'imports:')
		ifNil: 
			[(pairs lookup: 'poolDictionaries:')
				ifNotNil: [:arg | attributes imports: (self namesIn: arg value)]]
		ifNotNil: 
			[:arg |
			attributes imports: (arg children
						collect: [:each | BindingReference pathString: each pathString private: each isPrivate])].
	(pairs lookup: 'classConstants:')
		ifNotNil: 
			[:arg |
			"We defer evaluating the brace array expression until needed, as mostly it is not"
			attributes classConstants: arg formattedCode].
	(pairs lookup: 'classInstanceVariableNames:')
		ifNotNil: [:arg | attributes classInstanceVariableNames: (self namesIn: arg value)].
	(pairs lookup: 'category:') ifNotNil: [:arg | attributes category: arg value asSymbol]!

getClassAttributes
	^self attributes!

hash
	^definition hash!

imports
	^self attributes imports!

instanceVariableNames
	^self attributes instanceVariableNames!

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
	attributes := ClassAttributes new
				className: #Unknown;
				yourself!

primitiveExecute
	#rbFix. "rbDmm changed "

	^self definingSuperclass compilerClass evaluate: definition.




!

printOn: aStream 
	aStream
		nextPutAll: definition;
		nextPut: $!!!

sourceFilerClass
	^Object sourceFilerClass!

superclassName
	^self attributes superclassName! !
!Refactory.Browser.AddClassChange categoriesForMethods!
=!comparing!public! !
areSubclassCreationMessageArgumentsValid:!private!testing! !
asUndoOperation!converting!public! !
attributes!accessing!public! !
category!accessing!public! !
changeClassName!accessing!public! !
changeString!printing!public! !
classConstants!accessing!public! !
classReference!accessing!public! !
classVariableNames!accessing!public! !
definingSuperclass!accessing!private! !
definition!accessing!private! !
definition:!initializing!public! !
fillOutDefinition!helpers!private! !
fillOutDefinitionArguments:!helpers!private! !
getClassAttributes!printing!private! !
hash!comparing!public! !
imports!accessing!public! !
instanceVariableNames!accessing!public! !
isValidMessageName:!private!testing! !
isValidSubclassCreationMessage:!private!testing! !
namesIn:!helpers!private! !
parseDefinitionError!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
sourceFilerClass!constants!private! !
superclassName!accessing!public! !
!

!Refactory.Browser.AddClassChange class methodsFor!

definition: aString 
	^self new definition: aString! !
!Refactory.Browser.AddClassChange class categoriesForMethods!
definition:!instance creation!public! !
!

