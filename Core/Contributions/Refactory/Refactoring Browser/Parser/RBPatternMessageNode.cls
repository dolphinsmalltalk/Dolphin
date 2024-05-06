"Filed out from Dolphin Smalltalk"!

StMessageNode subclass: #RBPatternMessageNode
	instanceVariableNames: 'isList isCascadeList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBPatternMessageNode guid: (GUID fromString: '{880ff09f-aa85-4f4d-bd3e-0416f929352d}')!

RBPatternMessageNode comment: 'RBPatternMessageNode is an RBMessageNode that will match other message nodes without their selectors being equal. 

Instance Variables:
	isList	<Boolean>	are we matching each keyword or matching all keywords together (e.g., `keyword1: would match a one argument method whereas `@keywords: would match 0 or more arguments)'!

!RBPatternMessageNode categoriesForClass!Refactory-Parser! !

!RBPatternMessageNode methodsFor!

copyInContext: aDictionary
	| selectors |
	self isList ifTrue: [^aDictionary at: self].
	selectors := self isSelectorList
				ifTrue: [(aDictionary at: selectorParts first value) keywords]
				ifFalse: [selectorParts collect: [:each | aDictionary at: each value]].
	^RBMessageNode new
		receiver: (receiver copyInContext: aDictionary);
		selectorParts: (selectors collect: 
						[:each |
						(each last == $: ifTrue: [RBKeywordToken] ifFalse: [RBIdentifierToken])
							start: nil
							comments: nil
							value: each]);
		arguments: (self copyList: arguments inContext: aDictionary);
		yourself!

isList
	^isCascadeList and: [parent notNil and: [parent isCascade]]!

isPatternNode
	^true!

isSelectorList
	^isList!

match: aNode inContext: aDictionary 
	aNode class == self matchingClass ifFalse: [^false].
	(receiver match: aNode receiver inContext: aDictionary) ifFalse: [^false].
	self isSelectorList 
		ifTrue: 
			[^(aDictionary at: selectorParts first value ifAbsentPut: [aNode selector]) 
				== aNode selector and: 
						[(aDictionary at: arguments first ifAbsentPut: [aNode arguments]) 
							= aNode arguments]].
	^self matchArgumentsAgainst: aNode inContext: aDictionary!

matchArgumentsAgainst: aNode inContext: aDictionary 
	self arguments size == aNode arguments size ifFalse: [^false].
	(self matchSelectorAgainst: aNode inContext: aDictionary) 
		ifFalse: [^false].
	1 to: arguments size
		do: 
			[:i | 
			((arguments at: i) match: (aNode arguments at: i) inContext: aDictionary) 
				ifFalse: [^false]].
	^true!

matchingClass
	^RBMessageNode!

matchSelectorAgainst: aNode inContext: aDictionary 
	1 to: selectorParts size
		do: 
			[:i | 
			| keyword |
			keyword := selectorParts at: i.
			(aDictionary at: keyword value
				ifAbsentPut: 
					[keyword isPatternVariable 
						ifTrue: [(aNode selectorParts at: i) value]
						ifFalse: [keyword value]]) 
					= (aNode selectorParts at: i) value ifFalse: [^false]].
	^true!

receiver: aValueNode selectorParts: keywordTokens arguments: valueNodes 
	| message |
	super 
		receiver: aValueNode
		selectorParts: keywordTokens
		arguments: valueNodes.
	isCascadeList := isList := false.
	message := keywordTokens first value.
	2 to: message size
		do: 
			[:i | 
			| character |
			character := message at: i.
			character == self listCharacter 
				ifTrue: [isList := true]
				ifFalse: 
					[character == self cascadeListCharacter 
						ifTrue: [isCascadeList := true]
						ifFalse: [^self]]]!

sentMessages
	^(super sentMessages)
		remove: self selector ifAbsent: [];
		yourself! !

!RBPatternMessageNode categoriesForMethods!
copyInContext:!matching!public! !
isList!public!testing/matching! !
isPatternNode!public!testing/matching! !
isSelectorList!public!testing/matching! !
match:inContext:!matching!public! !
matchArgumentsAgainst:inContext:!matching!public! !
matchingClass!constants!public! !
matchSelectorAgainst:inContext:!matching!public! !
receiver:selectorParts:arguments:!initialize/release!public! !
sentMessages!accessing!public! !
!

!RBPatternMessageNode class methodsFor!

receiver: aValueNode selectorParts: keywordTokens arguments: valueNodes 
	^(keywordTokens anySatisfy: [:each | each isPatternVariable]) 
		ifTrue: 
			[super 
				receiver: aValueNode
				selectorParts: keywordTokens
				arguments: valueNodes]
		ifFalse: 
			[RBMessageNode 
				receiver: aValueNode
				selectorParts: keywordTokens
				arguments: valueNodes]! !

!RBPatternMessageNode class categoriesForMethods!
receiver:selectorParts:arguments:!instance creation!public! !
!

