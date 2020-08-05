"Filed out from Dolphin Smalltalk 7"!

RefactoryClassChange subclass: #AddClassChange
	instanceVariableNames: 'definition superclassName instanceVariableNames classVariableNames poolDictionaryNames category'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
AddClassChange guid: (GUID fromString: '{441f8dc3-4a20-4e6d-9311-c190ceb74f11}')!
AddClassChange comment: ''!
!AddClassChange categoriesForClass!Refactory-Change Objects! !
!AddClassChange methodsFor!

= anAddClassChange 
	self class = anAddClassChange class ifFalse: [^false].
	^definition = anAddClassChange definition!

areSubclassCreationMessageArgumentsValid: aMessageNode
	^aMessageNode arguments allSatisfy: [:each | each isLiteralNode]!

asUndoOperation
	| class |
	class := self changeClassName asQualifiedReference valueOrNil.
	^class isBehavior 
		ifTrue: [self class definition: class definition]
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
	parseTree := RBParser parseExpression: definition onError: [:str :pos | ^self parseDefinitionError].
	parseTree isMessage ifFalse: [^self parseDefinitionError].
	(self isValidSubclassCreationMessage: parseTree) ifFalse: [^self parseDefinitionError].
	superclassName := parseTree receiver isVariable
				ifTrue: [parseTree receiver name asSymbol]
				ifFalse: [parseTree receiver value].
	self fillOutDefinitionArguments: parseTree!

fillOutDefinitionArguments: parseTree
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
	(aMessageNode receiver isVariable or: [aMessageNode receiver isLiteralNode]) ifFalse: [^false].
	(self isValidMessageName: aMessageNode) ifFalse: [^false].
	^self areSubclassCreationMessageArgumentsValid: aMessageNode!

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
!AddClassChange categoriesFor: #=!comparing!public! !
!AddClassChange categoriesFor: #areSubclassCreationMessageArgumentsValid:!private!testing! !
!AddClassChange categoriesFor: #asUndoOperation!converting!public! !
!AddClassChange categoriesFor: #category!accessing!public! !
!AddClassChange categoriesFor: #changeClassName!accessing!public! !
!AddClassChange categoriesFor: #changeString!printing!public! !
!AddClassChange categoriesFor: #classVariableNames!accessing!public! !
!AddClassChange categoriesFor: #controller!accessing!private! !
!AddClassChange categoriesFor: #definingSuperclass!accessing!private! !
!AddClassChange categoriesFor: #definition!accessing!private! !
!AddClassChange categoriesFor: #definition:!initialize/release!public! !
!AddClassChange categoriesFor: #fillOutDefinition!helpers!private! !
!AddClassChange categoriesFor: #fillOutDefinitionArguments:!helpers!private! !
!AddClassChange categoriesFor: #hash!comparing!public! !
!AddClassChange categoriesFor: #initialize!initialize/release!public! !
!AddClassChange categoriesFor: #instanceVariableNames!accessing!public! !
!AddClassChange categoriesFor: #isValidMessageName:!public!testing! !
!AddClassChange categoriesFor: #isValidSubclassCreationMessage:!public!testing! !
!AddClassChange categoriesFor: #namesIn:!helpers!private! !
!AddClassChange categoriesFor: #parseDefinitionError!helpers!private! !
!AddClassChange categoriesFor: #poolDictionaryNames!accessing!public! !
!AddClassChange categoriesFor: #primitiveExecute!public! !
!AddClassChange categoriesFor: #printOn:!printing!public! !
!AddClassChange categoriesFor: #superclassName!accessing!public! !

!AddClassChange class methodsFor!

definition: aString 
	^self new definition: aString! !
!AddClassChange class categoriesFor: #definition:!instance creation!public! !

