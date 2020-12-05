"Filed out from Dolphin Smalltalk 7"!

Kernel.StMessageNode subclass: #'Refactory.Browser.RBPatternMessageNode'
	instanceVariableNames: 'isList isCascadeList'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBPatternMessageNode guid: (Core.GUID fromString: '{880ff09f-aa85-4f4d-bd3e-0416f929352d}')!
Refactory.Browser.RBPatternMessageNode comment: 'RBPatternMessageNode is an RBMessageNode that will match other message nodes without their selectors being equal. 

Instance Variables:
	isList	<Boolean>	are we matching each keyword or matching all keywords together (e.g., `keyword1: would match a one argument method whereas `@keywords: would match 0 or more arguments)'!
!Refactory.Browser.RBPatternMessageNode categoriesForClass!Refactory-Parser! !
!Refactory.Browser.RBPatternMessageNode methodsFor!

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
!Refactory.Browser.RBPatternMessageNode categoriesFor: #copyInContext:!matching!public! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #isList!public!testing/matching! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #isPatternNode!public!testing/matching! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #isSelectorList!public!testing/matching! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #match:inContext:!matching!public! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #matchArgumentsAgainst:inContext:!matching!public! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #matchingClass!constants!public! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #matchSelectorAgainst:inContext:!matching!public! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #receiver:selectorParts:arguments:!initialize/release!public! !
!Refactory.Browser.RBPatternMessageNode categoriesFor: #sentMessages!accessing!public! !

!Refactory.Browser.RBPatternMessageNode class methodsFor!

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
!Refactory.Browser.RBPatternMessageNode class categoriesFor: #receiver:selectorParts:arguments:!instance creation!public! !

