"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.MethodRefactoring subclass: #'Refactory.Browser.InlineAllSendersRefactoring'
	instanceVariableNames: 'selector numberReplaced numberNotReplaced'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.InlineAllSendersRefactoring guid: (Core.GUID fromString: '{09ac0050-928c-41f2-8a20-8d0490a9c4fb}')!
Refactory.Browser.InlineAllSendersRefactoring comment: ''!
!Refactory.Browser.InlineAllSendersRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.InlineAllSendersRefactoring methodsFor!

checkInlinedMethods
	numberReplaced = 0 
		ifTrue: [self refactoringError: 'Could not inline any senders']!

inlineMessagesInClass: aClass andSelector: aSelector
	| messagesToInline previousCountOfMessages |
	previousCountOfMessages := 4294967295.	"Some really large
number > # of initial self sends."
	
	[| tree |
	tree := aClass parseTreeFor: aSelector.
	messagesToInline := tree isNil ifTrue: [0] ifFalse: [self numberOfSelfSendsIn: tree].
	messagesToInline > 0 and: [previousCountOfMessages > messagesToInline]]
			whileTrue: 
				[| node |
				previousCountOfMessages := messagesToInline.
				node := self selfSendIn: (aClass parseTreeFor: aSelector).
				self onError: 
						[self performComponentRefactoring: (InlineMethodRefactoring
									model: self model
									inline: node sourceInterval
									inMethod: aSelector
									forClass: aClass).
						numberReplaced := numberReplaced + 1]
					do: []].
	numberNotReplaced := numberNotReplaced + messagesToInline!

inlineSelfSends
	class withAllSubclasses do: 
			[:each | 
			| selectors |
			selectors := (each whichMethodsReferToSymbol: selector) 
						collect: [:method | method selector].
			selectors remove: selector ifAbsent: [].
			selectors do: [:sel | self inlineMessagesInClass: each andSelector: sel]]!

messagePattern
	^'self ' , (self buildSelectorString: selector)!

messagesNotReplaced
	^numberNotReplaced!

numberOfSelfSendsIn: aParseTree
	| search |
	search := ParseTreeSearcher new.
	search matches: self messagePattern do: [:aNode :answer | answer + 1].
	^search executeTree: aParseTree initialAnswer: 0!

preconditions
	^RBCondition canUnderstand: selector in: class!

removeMethod
	self onError: 
			[self performComponentRefactoring: (RemoveMethodRefactoring
						model: self model
						removeMethods: {selector}
						from: class)]
		do: []!

selfSendIn: aTree
	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: self messagePattern do: [:aNode :answer | ^aNode].
	^searcher executeTree: aTree initialAnswer: nil!

sendersOf: aSelector in: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	class := self classObjectFor: aClass.
	numberReplaced := numberNotReplaced := 0!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' sendersOf: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		inlineSelfSends;
		removeMethod;
		checkInlinedMethods! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #checkInlinedMethods!public!transforming! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #inlineMessagesInClass:andSelector:!public!transforming! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #inlineSelfSends!public!transforming! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #messagePattern!public!transforming! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #messagesNotReplaced!accessing!public! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #numberOfSelfSendsIn:!public!transforming! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #removeMethod!public!transforming! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #selfSendIn:!public!transforming! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #sendersOf:in:!initialize/release!public! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.InlineAllSendersRefactoring class methodsFor!

model: aRBNamespace sendersOf: aSelector in: aClass 
	^(self new)
		model: aRBNamespace;
		sendersOf: aSelector in: aClass;
		yourself!

sendersOf: aSelector in: aClass 
	^self new sendersOf: aSelector in: aClass! !
!Refactory.Browser.InlineAllSendersRefactoring class categoriesFor: #model:sendersOf:in:!instance creation!public! !
!Refactory.Browser.InlineAllSendersRefactoring class categoriesFor: #sendersOf:in:!instance creation!public! !

