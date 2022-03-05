"Filed out from Dolphin Smalltalk"!

RefactoryClassChange subclass: #AddClassChange
	instanceVariableNames: 'definition superclassName instanceVariableNames classVariableNames poolDictionaryNames category'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddClassChange guid: (GUID fromString: '{441f8dc3-4a20-4e6d-9311-c190ceb74f11}')!
AddClassChange comment: ''!
!AddClassChange categoriesForClass!Refactory-Change Objects! !
!AddClassChange methodsFor!

= anAddClassChange 
	self class = anAddClassChange class ifFalse: [^false].
	^definition = anAddClassChange definition!

asUndoOperation
	| class |
	class := Smalltalk at: self changeClassName ifAbsent: [nil].
	^class isBehavior 
		ifTrue: [AddClassChange definition: class definition]
		ifFalse: [RemoveClassChange removeClassName: self changeClassName]!

category
	category isNil ifTrue: [self fillOutDefinition].
	^category!

changeClassName
	className isNil ifTrue: [self fillOutDefinition].
	^className!

changeString
	^'Define ' , self displayClassName!

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
	parseTree := RBParser parseExpression: definition
				onError: [:str :pos | ^self parseDefinitionError].
	parseTree isMessage ifFalse: [^self parseDefinitionError].
	(self isValidSubclassCreationMessage: parseTree) 
		ifFalse: [^self parseDefinitionError].
	superclassName := parseTree receiver isVariable 
				ifTrue: [parseTree receiver name asSymbol]
				ifFalse: [parseTree receiver value].
	className := parseTree arguments first value.
	instanceVariableNames := self namesIn: (parseTree arguments at: 2) value.
	classVariableNames := self namesIn: (parseTree arguments at: 3) value.
	poolDictionaryNames := self namesIn: (parseTree arguments at: 4) value.
	category := parseTree arguments size < 5 
				ifTrue: [#Unknown]
				ifFalse: [(parseTree arguments at: 5) value asSymbol]!

hash
	^definition hash!

initialize
	super initialize.
	isMeta := false!

instanceVariableNames
	instanceVariableNames isNil ifTrue: [self fillOutDefinition].
	^instanceVariableNames!

isValidMessageName: aMessageNode
	^#(#subclass:instanceVariableNames:classVariableNames:poolDictionaries: 
	#subclass:instanceVariableNames:classVariableNames:poolDictionaries:category: 
	#variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries: 
	#variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:
	#variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries: 
	#variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:
	#subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:
	#variableSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:
	#variableByteSubclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:) 
		includes: aMessageNode selector!

isValidSubclassCreationMessage: aMessageNode 
	(aMessageNode receiver isVariable or: [aMessageNode receiver isLiteralNode]) 
		ifFalse: [^false].
	(self isValidMessageName: aMessageNode) ifFalse: [^false].
	^aMessageNode arguments allSatisfy: [:each | each isLiteralNode]!

namesIn: aString 
	| names stream |
	names := OrderedCollection new.
	stream := ReadStream on: aString.
	
	[stream skipSeparators.
	stream atEnd] whileFalse: 
				[| nameStream |
				nameStream := WriteStream on: (Utf8String new: 10).
				[stream atEnd or: [stream peek isSeparator]] 
					whileFalse: [nameStream nextPut: stream next].
				names add: nameStream contents].
	^names!

parseDefinitionError
	className := #'Unknown Class'.
	instanceVariableNames := #().
	classVariableNames := #().
	poolDictionaryNames := #()!

poolDictionaryNames
	poolDictionaryNames isNil ifTrue: [self fillOutDefinition].
	^poolDictionaryNames!

primitiveExecute
	#rbFix. "rbDmm changed "

	^self definingSuperclass compilerClass evaluate: definition.




!

printOn: aStream 
	aStream
		nextPutAll: definition;
		nextPut: $!!!

superclassName
	className isNil ifTrue: [self fillOutDefinition].
	^superclassName! !
!AddClassChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
category!accessing!public! !
changeClassName!accessing!public! !
changeString!printing!public! !
classVariableNames!accessing!public! !
controller!accessing!private! !
definingSuperclass!accessing!private! !
definition!accessing!private! !
definition:!initialize/release!public! !
fillOutDefinition!helpers!private! !
hash!comparing!public! !
initialize!initialize/release!public! !
instanceVariableNames!accessing!public! !
isValidMessageName:!public!testing! !
isValidSubclassCreationMessage:!public!testing! !
namesIn:!helpers!private! !
parseDefinitionError!helpers!private! !
poolDictionaryNames!accessing!public! !
primitiveExecute!public! !
printOn:!printing!public! !
superclassName!accessing!public! !
!

!AddClassChange class methodsFor!

definition: aString 
	^self new definition: aString! !
!AddClassChange class categoriesForMethods!
definition:!instance creation!public! !
!

