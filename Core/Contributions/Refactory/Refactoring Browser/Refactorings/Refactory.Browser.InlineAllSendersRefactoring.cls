"Filed out from Dolphin Smalltalk"!

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
	| messagesToInline previousCountOfMessages method |
	previousCountOfMessages := SmallInteger maximum.	"Some really large
number > # of initial self sends."
	
	[method := aClass methodFor: aSelector.
	messagesToInline := self numberOfSelfSendsIn: method parseTree.
	messagesToInline > 0 and: [previousCountOfMessages > messagesToInline]]
			whileTrue: 
				[| node |
				previousCountOfMessages := messagesToInline.
				node := self selfSendIn: method parseTreeWithSourceIntervals.
				self onError: 
						[self performComponentRefactoring: (InlineMethodRefactoring
									model: self model
									inline: node sourceInterval
									inMethod: aSelector
									forClass: aClass).
						numberReplaced := numberReplaced + 1]
					do: [:ex | ex toTrace]].
	numberNotReplaced := numberNotReplaced + messagesToInline!

inlineSelfSends
	class withAllSubclasses do: 
			[:each |
			| selectors |
			selectors := (each whichMethodsReferToSymbol: selector) collect: [:method | method selector].
			selectors remove: selector ifAbsent: nil.
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
			[| removeMethod |
			removeMethod := RemoveMethodRefactoring
						model: self model
						removeMethods: {selector}
						from: class.
			"It may not be possible to preserve behaviour and remove the inlined method if it is sent from call sites other than the inline sites"
			removeMethod setOption: #removeReferencedSelector toUse: [:ref :symbol :references | false].
			self performComponentRefactoring: removeMethod]
		do: [:ex | ex toTrace]!

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
		nextPutAll: ' sendersOf: ';
		print: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		inlineSelfSends;
		removeMethod;
		checkInlinedMethods! !
!Refactory.Browser.InlineAllSendersRefactoring categoriesForMethods!
checkInlinedMethods!public!transforming! !
inlineMessagesInClass:andSelector:!public!transforming! !
inlineSelfSends!public!transforming! !
messagePattern!public!transforming! !
messagesNotReplaced!accessing!public! !
numberOfSelfSendsIn:!public!transforming! !
preconditions!preconditions!public! !
removeMethod!public!transforming! !
selfSendIn:!public!transforming! !
sendersOf:in:!initialize/release!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.InlineAllSendersRefactoring class methodsFor!

model: aRBModel sendersOf: aSelector in: aClass
	^self new
		model: aRBModel;
		sendersOf: aSelector in: aClass;
		yourself!

sendersOf: aSelector in: aClass 
	^self new sendersOf: aSelector in: aClass! !
!Refactory.Browser.InlineAllSendersRefactoring class categoriesForMethods!
model:sendersOf:in:!instance creation!public! !
sendersOf:in:!instance creation!public! !
!

