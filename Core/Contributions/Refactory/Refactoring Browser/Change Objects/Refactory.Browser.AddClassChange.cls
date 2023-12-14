"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange
	subclass: #'Refactory.Browser.AddClassChange'
	instanceVariableNames: 'definition details'
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
	^self definition = anAddClassChange definition!

areSubclassCreationMessageArgumentsValid: aMessageNode
	^aMessageNode arguments allSatisfy: [:each | each isLiteralNode or: [each isDynamicArray]]!

asUndoOperation
	| binding |
	binding := self classReference realReference bindingOrNil.
	^(binding notNil and: [binding isClassBinding])
		ifTrue: [self class details: (ClassDetails fromClass: binding value)]
		ifFalse: [RemoveClassChange removeClassName: self changeClassName]!

changeClassName
	^self details className!

changeString
	^'Define <1d>' << self classReference!

classReference
	^self details classReference!

classReference: aBindingReference
	self details classReference: aBindingReference!

definingSuperclass
	^self class!

definition
	^definition ifNil: [definition := details fullPrintString]!

definition: aString 
	definition := aString.
	^self!

details
	"Answer a <ClassDetails> describing the attributes of the new class."

	^details ifNil: [self fillOutDefinition]!

details: aClassDetails 
	details := aClassDetails.
	^self!

fillOutDefinition
	| parseTree |
	parseTree := Parser parseExpression: self definition onError: [:str :pos | ^self parseDefinitionError].
	parseTree isMessage ifFalse: [^self parseDefinitionError].
	(self isValidSubclassCreationMessage: parseTree) ifFalse: [^self parseDefinitionError].
	self fillOutDefinitionArguments: parseTree.
	^details!

fillOutDefinitionArguments: parseTree
	| args keywords pairs |
	details := ClassDetails new.
	details superclassName: (parseTree receiver isVariable
				ifTrue: [parseTree receiver name asSymbol]
				ifFalse: [parseTree receiver value]).
	args := parseTree arguments.
	keywords := parseTree selector keywords.
	"The new class name is always the 1st argument, but might have differing selector keywords, so look up by position"
	details
		className: (args at: 1) value;
		kindOfSubclass: (keywords at: 1).
	pairs := LookupTable new.
	keywords with: args do: [:eachKeyword :eachArg | pairs at: eachKeyword put: eachArg].
	details
		instanceVariableNames: (self namesIn: (pairs at: 'instanceVariableNames:') value);
		classVariableNames: (self namesIn: (pairs at: 'classVariableNames:') value).
	(pairs lookup: 'imports:')
		ifNil: 
			[(pairs lookup: 'poolDictionaries:') ifNotNil: [:arg | details imports: (self namesIn: arg value)]]
		ifNotNil: 
			[:arg |
			details imports: (arg children
						collect: [:each | BindingReference pathString: each pathString private: each isPrivate])].
	(pairs lookup: 'classConstants:')
		ifNotNil: 
			[:arg |
			"We defer evaluating the brace array expression until needed, as mostly it is not"
			details classConstants: arg formattedCode].
	(pairs lookup: 'classInstanceVariableNames:')
		ifNotNil: [:arg | details classInstanceVariableNames: (self namesIn: arg value)].
	(pairs lookup: 'category:') ifNotNil: [:arg | details category: arg value]!

getClassDetails
	^self details!

hash
	^self definition hash!

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
	details := ClassDetails new
				className: #Unknown;
				yourself!

primitiveExecute
	^(self definingSuperclass compilerClass evaluate: self definition)
		ifNotNil: 
			[:newClass |
			details isNonInstantiable ifTrue: [newClass isNonInstantiable: true].
			details guid ifNotNil: [:guid | newClass guid: guid].
			details comment ifNotNil: [:comment | newClass comment: comment].
			details package ifNotNil: [:package | newClass owningPackage: package].
			newClass]!

printOn: aStream
	| classDetails |
	classDetails := self details.
	(classDetails sourceFilerClass on: aStream) fileOutDefinitionOfClass: classDetails!

sourceFilerClass
	^Object sourceFilerClass! !
!Refactory.Browser.AddClassChange categoriesForMethods!
=!comparing!public! !
areSubclassCreationMessageArgumentsValid:!private!testing! !
asUndoOperation!converting!public! !
changeClassName!accessing!public! !
changeString!printing!public! !
classReference!accessing!public! !
classReference:!accessing!public! !
definingSuperclass!accessing!private! !
definition!accessing!public! !
definition:!initializing!public! !
details!accessing!public! !
details:!initializing!public! !
fillOutDefinition!helpers!private! !
fillOutDefinitionArguments:!helpers!private! !
getClassDetails!printing!private! !
hash!comparing!public! !
isValidMessageName:!private!testing! !
isValidSubclassCreationMessage:!private!testing! !
namesIn:!helpers!private! !
parseDefinitionError!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
sourceFilerClass!constants!private! !
!

!Refactory.Browser.AddClassChange class methodsFor!

definition: aString 
	^self new definition: aString!

details: aClassDetails
	^self new details: aClassDetails! !
!Refactory.Browser.AddClassChange class categoriesForMethods!
definition:!instance creation!public! !
details:!instance creation!public! !
!

