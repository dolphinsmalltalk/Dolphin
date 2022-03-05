"Filed out from Dolphin Smalltalk"!

MethodRefactoring subclass: #RemoveMethodRefactoring
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveMethodRefactoring guid: (GUID fromString: '{b0514c20-922f-4ee5-b5bb-e0ebabdf52bd}')!
RemoveMethodRefactoring comment: ''!
!RemoveMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!RemoveMethodRefactoring methodsFor!

checkReferencesToAnyOf: aSelectorCollection 
	aSelectorCollection do: 
			[:each | 
			self model allReferencesTo: each
				do: 
					[:aRBMethod | 
					(aSelectorCollection includes: aRBMethod selector) 
						ifFalse: 
							[self refactoringError: ('Possible call to <2p> in <1p>.<n><n>Would you like to browse references?' 
										expandMacrosWith: aRBMethod modelClass
										with: each)
								with: 
									[#rbFix.	"Should use model's BrowserEnvironment to perform the reference search"
									self openBrowserOn: (self model environment referencesTo: each)]]]]!

checkReferencesToSuperSendsToAnyOf: superMessages 
	[superMessages isEmpty] whileFalse: 
			[self 
				refactoringWarning: ('Although <1s> is equivalent to a superclass method,<n>it contains a super send so it might modify behavior.' 
						expandMacrosWith: superMessages first).
			superMessages remove: superMessages first]!

checkSuperMethods
	| superMessages nonSupers |
	nonSupers := OrderedCollection new.
	superMessages := OrderedCollection new.
	(selectors reject: [:each | self justSendsSuper: each]) do: 
			[:each | 
			(self superclassEquivalentlyDefines: each) 
				ifTrue: [(class parseTreeFor: each) superMessages notEmpty ifTrue: [superMessages add: each]]
				ifFalse: [nonSupers add: each]].
	nonSupers isEmpty & superMessages isEmpty ifTrue: [^self].
	self checkReferencesToAnyOf: nonSupers.
	self checkReferencesToSuperSendsToAnyOf: superMessages.
!

justSendsSuper: aSelector
	| matcher parseTree superclass |
	matcher := ParseTreeSearcher justSendsSuper.
	parseTree := class parseTreeFor: aSelector.
	(matcher executeTree: parseTree initialAnswer: false) ifFalse: [^false].
	parseTree lastIsReturn ifTrue: [^true].
	superclass := class superclass whoDefinesMethod: aSelector.
	superclass isNil ifTrue: [^true].	"Since there isn't a superclass that implements the message, we can 
								 delete it since it would be an error anyway."
	parseTree := superclass parseTreeFor: aSelector.
	matcher := ParseTreeSearcher new.
	matcher matches: '^``@object'
		do: 
			[:aNode :answer |
			answer
				add: aNode value;
				yourself].
	matcher executeTree: parseTree initialAnswer: Set new.
	^matcher answer allSatisfy: [:each | each isSelfVariable]!

preconditions
	^(selectors inject: RBCondition empty
		into: [:cond :each | cond & (RBCondition definesSelector: each in: class)]) 
			& (RBCondition withBlock: 
						[self checkSuperMethods.
						true])!

removeMethods: selectorCollection from: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selectors := selectorCollection.
	class := self classObjectFor: aClass.
!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' removeMethods: '.
	selectors asArray storeOn: aStream.
	aStream nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)!

superclassEquivalentlyDefines: aSelector 
	| superTree myTree |
	class superclass isNil ifTrue: [^false].
	superTree := class superclass parseTreeFor: aSelector.
	myTree := class parseTreeFor: aSelector.
	(superTree isNil or: [myTree isNil]) ifTrue: [^false].
	^superTree equalTo: myTree exceptForVariables: #()!

transform
	selectors do: [:each | class removeMethod: each]! !
!RemoveMethodRefactoring categoriesForMethods!
checkReferencesToAnyOf:!preconditions!public! !
checkReferencesToSuperSendsToAnyOf:!preconditions!public! !
checkSuperMethods!preconditions!public! !
justSendsSuper:!preconditions!public! !
preconditions!preconditions!public! !
removeMethods:from:!initialize/release!public! !
storeOn:!printing!public! !
superclassEquivalentlyDefines:!preconditions!public! !
transform!public!transforming! !
!

!RemoveMethodRefactoring class methodsFor!

model: aRBNamespace removeMethods: selectorCollection from: aClass 
	^(self new)
		model: aRBNamespace;
		removeMethods: selectorCollection from: aClass;
		yourself!

removeMethods: selectorCollection from: aClass
	^self new removeMethods: selectorCollection from: aClass! !
!RemoveMethodRefactoring class categoriesForMethods!
model:removeMethods:from:!instance creation!public! !
removeMethods:from:!instance creation!public! !
!

