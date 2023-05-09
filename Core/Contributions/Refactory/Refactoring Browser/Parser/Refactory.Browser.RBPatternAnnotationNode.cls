"Filed out from Dolphin Smalltalk"!

Kernel.StAnnotationNode
	subclass: #'Refactory.Browser.RBPatternAnnotationNode'
	instanceVariableNames: 'isList'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBPatternAnnotationNode guid: (Core.GUID fromString: '{6e4d495f-83bf-4e5b-938e-a20577e08f94}')!
Refactory.Browser.RBPatternAnnotationNode comment: ''!
!Refactory.Browser.RBPatternAnnotationNode categoriesForClass!System-Compiler! !
!Refactory.Browser.RBPatternAnnotationNode methodsFor!

copyInContext: aDictionary
	| keywordSelector |
	keywordSelector := self isSelectorList
				ifTrue: [aDictionary at: self keywords first]
				ifFalse: 
					[| stream |
					stream := String writeStream.
					self keywords do: [:each | stream nextPutAll: (aDictionary at: each)].
					stream contents].
	^StAnnotationNode selector: keywordSelector
		arguments: (self copyList: self arguments inContext: aDictionary)!

isPatternNode
	^true!

isPatternVariable: aString
	^(aString at: 1) == RBPatternScanner.VariableCharacter!

isSelectorList
	^isList!

match: aNode inContext: aDictionary
	aNode class == self matchingClass ifFalse: [^false].
	self isSelectorList
		ifTrue: 
			[^(aDictionary at: self keywords first ifAbsentPut: [aNode selector]) = aNode selector
				and: [(aDictionary at: arguments first ifAbsentPut: [aNode arguments]) = aNode arguments]].
	^self matchArgumentsAgainst: aNode inContext: aDictionary!

matchArgumentsAgainst: aNode inContext: aDictionary
	arguments size = aNode arguments size ifFalse: [^false].
	(self matchSelectorAgainst: aNode inContext: aDictionary) ifFalse: [^false].
	^super matchArgumentsAgainst: aNode inContext: aDictionary!

matchingClass
	^StAnnotationNode!

matchSelectorAgainst: aNode inContext: aDictionary
	| keywords otherKeywords |
	otherKeywords := aNode keywords.
	1 to: (keywords := self keywords) size
		do: 
			[:i |
			| keyword other |
			other := otherKeywords at: i.
			(aDictionary at: (keyword := keywords at: i)
				ifAbsentPut: [(self isPatternVariable: keyword) ifTrue: [other] ifFalse: [keyword]]) = other
				ifFalse: [^false]].
	^true!

setSelector: aSymbol arguments: anArray
	super setSelector: aSymbol arguments: anArray.
	isList := aSymbol includes: RBPatternScanner.ListCharacter! !
!Refactory.Browser.RBPatternAnnotationNode categoriesForMethods!
copyInContext:!matching!public! !
isPatternNode!public!testing/matching! !
isPatternVariable:!matching!private! !
isSelectorList!public!testing! !
match:inContext:!matching!public! !
matchArgumentsAgainst:inContext:!matching!private! !
matchingClass!constants!matching!private! !
matchSelectorAgainst:inContext:!matching!private! !
setSelector:arguments:!initializing!private! !
!

