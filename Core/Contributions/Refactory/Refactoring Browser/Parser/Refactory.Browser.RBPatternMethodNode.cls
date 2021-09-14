"Filed out from Dolphin Smalltalk"!

Kernel.StMethodNode subclass: #'Refactory.Browser.RBPatternMethodNode'
	instanceVariableNames: 'isList'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBPatternMethodNode guid: (Core.GUID fromString: '{6846df75-8a6c-48dc-944d-453103430651}')!
Refactory.Browser.RBPatternMethodNode comment: 'RBPatternMethodNode is an RBMethodNode that will match other method nodes without their selectors being equal. 

Instance Variables:
	isList	<Boolean>	are we matching each keyword or matching all keywords together (e.g., `keyword1: would match a one argument method whereas `@keywords: would match 0 or more arguments)

'!
!Refactory.Browser.RBPatternMethodNode categoriesForClass!Refactory-Parser! !
!Refactory.Browser.RBPatternMethodNode methodsFor!

copyInContext: aDictionary
	| selectors |
	selectors := self isSelectorList
				ifTrue: [(aDictionary at: selectorParts first value) keywords]
				ifFalse: [selectorParts collect: [:each | aDictionary at: each value]].
	^RBMethodNode new
		selectorParts: (selectors collect: 
						[:each |
						(each last == $: ifTrue: [RBKeywordToken] ifFalse: [RBIdentifierToken])
							start: nil
							comments: nil
							value: each]);
		arguments: (self copyList: arguments inContext: aDictionary);
		body: (body copyInContext: aDictionary);
		source: (aDictionary at: '-source-');
		yourself!

isPatternNode
	^true!

isSelectorList
	^isList!

match: aNode inContext: aDictionary
	aNode class == self matchingClass ifFalse: [^false].
	aDictionary at: '-source-' put: aNode source.
	self isSelectorList
		ifTrue: 
			[| msg |
			msg := aNode selector.
			^(aDictionary at: selectorParts first value ifAbsentPut: msg) = msg and: 
					[| args |
					args := aNode arguments.
					(aDictionary at: arguments first ifAbsentPut: args) = args
						and: [body match: aNode body inContext: aDictionary]]].
	^(self matchArgumentsAgainst: aNode inContext: aDictionary)
		and: [body match: aNode body inContext: aDictionary]!

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
	^RBMethodNode!

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

selectorParts: tokenCollection arguments: variableNodes 
	super selectorParts: tokenCollection arguments: variableNodes.
	isList := (tokenCollection first value at: 2) == self listCharacter! !
!Refactory.Browser.RBPatternMethodNode categoriesForMethods!
copyInContext:!matching!public! !
isPatternNode!public!testing/matching! !
isSelectorList!public!testing! !
match:inContext:!matching!public! !
matchArgumentsAgainst:inContext:!matching!public! !
matchingClass!constants!public! !
matchSelectorAgainst:inContext:!matching!public! !
selectorParts:arguments:!initialize/release!public! !
!

!Refactory.Browser.RBPatternMethodNode class methodsFor!

selectorParts: tokenCollection arguments: variableNodes 
	^(tokenCollection anySatisfy: [:each | each isPatternVariable]) 
		ifTrue: [super selectorParts: tokenCollection arguments: variableNodes]
		ifFalse: 
			[RBMethodNode selectorParts: tokenCollection arguments: variableNodes]! !
!Refactory.Browser.RBPatternMethodNode class categoriesForMethods!
selectorParts:arguments:!instance creation!public! !
!

