"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.SmalllintContext'
	instanceVariableNames: 'class selector parseTree literals literalSemaphore literalProcess selectors compiledMethod selfMessages superMessages messages ignoredUnimplementedMessages'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.SmalllintContext guid: (Core.GUID fromString: '{3cc8c7db-8970-4652-bff7-519cda9ca376}')!

Refactory.Browser.SmalllintContext comment: ''!

!Refactory.Browser.SmalllintContext categoriesForClass!Refactory-Lint! !

!Refactory.Browser.SmalllintContext methodsFor!

addImplementationSpecificLiterals
	#rbFix.	"Dolphin's VM references symbols"
	VM registry do: [:each | each isSymbol ifTrue: [literals add: each]]!

buildParseTree
	^(self selectedClass parseTreeFor: self selector) ifNil: [Parser parseMethod: 'method']!

checkLiteral: aLiteral
	aLiteral isSymbol
		ifTrue: 
			[literals add: aLiteral.
			^self].
	#rbFix.	"In Dolphin X6 and later class refs are stored as constants in the literal frame, rather than variable bindings."
	aLiteral isBehavior
		ifTrue: 
			[literals add: aLiteral.
			^self].
	aLiteral isVariableBinding
		ifTrue: 
			[#rbFix.	"An optimization - because we only need to know of literal refs to variables that ref classes, we can
				ignore all other variables. This also avoids the cached literals collection preventing the GC of objects
				referenced from class variables, etc."
			aLiteral value isBehavior ifTrue: [literals add: aLiteral value]]
		ifFalse: [aLiteral class == Array ifTrue: [aLiteral do: [:each | self checkLiteral: each]]]!

compiledMethod
	^compiledMethod ifNil: [compiledMethod := class compiledMethodAt: selector]!

computeLiterals
	literalSemaphore := Semaphore new.
	literalProcess := [self primitiveComputeLiterals] forkAt: Processor userBackgroundPriority!

computeLiteralsForClass: aClass 
	#rbFix.	"Optimize"
	aClass methodDictionary keysAndValuesDo: 
			[:eachSelector :eachMethod | 
			selectors add: eachSelector.
			eachMethod allLiteralsDo: [:literal | self checkLiteral: literal]]!

computeMessages
	| searcher ast |
	selfMessages := Set new.
	superMessages := Set new.
	messages := Set new.
	ast := self parseTree.
	ignoredUnimplementedMessages := IdentitySet new.
	ast annotations do: 
			[:each |
			each selector == #ignoreNotImplementedSelectors:
				ifTrue: 
					[(each arguments lookup: 1)
						ifNotNil: [:arg | arg isLiteralArray ifTrue: [ignoredUnimplementedMessages addAll: arg value]]]].
	searcher := ParseTreeSearcher new.
	searcher
		matches: 'self `@message: ``@args'
			do: [:aNode :answer | aNode isInStaticExpression ifFalse: [selfMessages add: aNode selector]];
		matches: 'super `@message: ``@args' do: [:aNode :answer | superMessages add: aNode selector];
		matches: '``@receiver `@message: ``@args' do: [:aNode :answer | messages add: aNode selector].
	searcher executeTree: ast initialAnswer: nil!

ignoredUnimplementedMessages
	^ignoredUnimplementedMessages!

implements: aSelector 
	^(ignoredUnimplementedMessages includes: aSelector) or: [self selectors includes: aSelector]!

initialize
	self computeLiterals!

instanceVariableNames
	^self selectedClass allInstanceVariableNames!

isAbstract: aClass 
	^(aClass isMeta 
		or: [(self literals includes: aClass name) or: [self literals includes: aClass]]) not!

lintProtocols
	^self selectedClass whichCategoriesIncludeSelector: self selector!

literals
	literalSemaphore isNil
		ifTrue: 
			[literals isNil ifTrue: 
					[self computeLiterals.
					literalSemaphore wait]]
		ifFalse: [literalSemaphore wait].
	^literals

!

messages
	messages isNil ifTrue: [self computeMessages].
	^messages!

parseTree
	^parseTree ifNil: [parseTree := self buildParseTree]!

primitiveComputeLiterals
	"Dolphin's view resources may reference symbols, and so may the VM"

	| semaphore |
	literals := IdentitySet new: 25000.
	literals addAll: self specialSelectors.
	selectors := IdentitySet new: 20000.
	Smalltalk allBehaviorsDo: [:aClass | self computeLiteralsForClass: aClass].
	#rbFix.	"Provide a hook to add extra literals from sources that depend on the host Smalltalk."
	self addImplementationSpecificLiterals.
	semaphore := literalSemaphore.
	literalSemaphore := nil.
	self signalProcesses: semaphore.
	^literalProcess := nil!

protocol
	#rbFix.	"Dolphin support multiple categories for each method"
	^self protocols asSortedArray first!

protocols
	#rbFix.	"Added"
	^self lintProtocols!

release
	literalProcess notNil ifTrue: [literalProcess terminate].
	super release!

selectedClass
	^class!

selectedClass: anObject 
	class := anObject.
	self selector: nil!

selector
	^selector!

selector: anObject 
	selector := anObject.
	parseTree := compiledMethod := selfMessages := superMessages := messages := nil!

selectors
	literalSemaphore isNil
		ifTrue: 
			[selectors isNil ifTrue: 
					[self computeLiterals.
					literalSemaphore wait]]
		ifFalse: [literalSemaphore wait].
	^selectors!

selfImplements: aSelector
	^(ignoredUnimplementedMessages includes: aSelector)
		or: [self selectedClass canUnderstand: aSelector]!

selfMessages
	selfMessages isNil ifTrue: [self computeMessages].
	^selfMessages!

signalProcesses: aSemaphore 
	aSemaphore isNil ifTrue: [^self].
	[aSemaphore isEmpty] whileFalse: [aSemaphore signal]!

specialSelectors
	#rbFix.
	"	^(OpcodePool at: #SpecialSelectorDictionary) keys"
	^VM specialSelectors!

superImplements: aSelector
	^(ignoredUnimplementedMessages includes: aSelector) or: 
			[| superc |
			superc := self selectedClass superclass.
			superc notNil and: [superc canUnderstand: aSelector]]!

superMessages
	superMessages isNil ifTrue: [self computeMessages].
	^superMessages!

uses: anObject 
	^self literals includes: anObject! !

!Refactory.Browser.SmalllintContext categoriesForMethods!
addImplementationSpecificLiterals!private! !
buildParseTree!helpers!private! !
checkLiteral:!helpers!private! !
compiledMethod!accessing!public! !
computeLiterals!helpers!private! !
computeLiteralsForClass:!helpers!private! !
computeMessages!helpers!private! !
ignoredUnimplementedMessages!accessing!private! !
implements:!public!testing! !
initialize!initialize/release!public! !
instanceVariableNames!accessing!public! !
isAbstract:!public!testing! !
lintProtocols!accessing!public! !
literals!accessing!public! !
messages!accessing!public! !
parseTree!accessing!public! !
primitiveComputeLiterals!helpers!private! !
protocol!accessing!public! !
protocols!accessing!public! !
release!initialize/release!public! !
selectedClass!accessing!public! !
selectedClass:!accessing!public! !
selector!accessing!public! !
selector:!accessing!public! !
selectors!accessing!public! !
selfImplements:!public!testing! !
selfMessages!accessing!public! !
signalProcesses:!helpers!private! !
specialSelectors!helpers!private! !
superImplements:!public!testing! !
superMessages!accessing!public! !
uses:!public!testing! !
!

!Refactory.Browser.SmalllintContext class methodsFor!

new
	^(super new)
		initialize;
		yourself!

newNoCache
	^self basicNew! !

!Refactory.Browser.SmalllintContext class categoriesForMethods!
new!instance creation!public! !
newNoCache!instance creation!public! !
!

