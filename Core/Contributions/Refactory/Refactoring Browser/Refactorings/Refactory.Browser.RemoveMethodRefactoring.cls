"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring subclass: #'Refactory.Browser.RemoveMethodRefactoring'
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveMethodRefactoring guid: (Core.GUID fromString: '{b0514c20-922f-4ee5-b5bb-e0ebabdf52bd}')!
Refactory.Browser.RemoveMethodRefactoring comment: ''!
!Refactory.Browser.RemoveMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RemoveMethodRefactoring methodsFor!

checkReferencesToAnyOf: aSelectorCollection
	aSelectorCollection do: 
			[:each |
			| refs |
			refs := (self model allReferencesTo: each)
						reject: [:aRBMethod | aSelectorCollection includes: aRBMethod selector].
			refs notEmpty
				ifTrue: [(self shouldRemoveSelector: each referencedIn: refs) ifFalse: [self refactoringAborted]]]!

checkReferencesToSuperSendsToAnyOf: superMessages
	superMessages isEmpty
		ifFalse: 
			[(self shouldRemoveDuplicatesWithSupersends: superMessages) ifFalse: [self refactoringAborted]]!

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

shouldRemoveDuplicatesWithSupersends: superMessages
	^(self lookupOption: #removeDuplicatesWithSupersends) cull: self cull: superMessages!

shouldRemoveSelector: aSymbol referencedIn: aCollection
	^(self lookupOption: #removeReferencedSelector)
		cull: self
		cull: aSymbol
		cull: aCollection!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' removeMethods: '.
	selectors asArray storeOn: aStream.
	aStream nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)!

superclassEquivalentlyDefines: aSelector
	| superTree myTree superclass |
	superclass := class superclass.
	superclass isNil ifTrue: [^false].
	superTree := superclass parseTreeFor: aSelector.
	myTree := class parseTreeFor: aSelector.
	(superTree isNil or: [myTree isNil]) ifTrue: [^false].
	^superTree equalTo: myTree exceptForVariables: #()!

transform
	selectors do: [:each | class removeMethod: each]! !
!Refactory.Browser.RemoveMethodRefactoring categoriesForMethods!
checkReferencesToAnyOf:!preconditions!public! !
checkReferencesToSuperSendsToAnyOf:!preconditions!public! !
checkSuperMethods!preconditions!public! !
justSendsSuper:!preconditions!public! !
preconditions!preconditions!public! !
removeMethods:from:!initialize/release!public! !
shouldRemoveDuplicatesWithSupersends:!private!requests! !
shouldRemoveSelector:referencedIn:!private!requests! !
storeOn:!printing!public! !
superclassEquivalentlyDefines:!preconditions!public! !
transform!public!transforming! !
!

!Refactory.Browser.RemoveMethodRefactoring class methodsFor!

model: aRBModel removeMethods: selectorCollection from: aClass
	^self new
		model: aRBModel;
		removeMethods: selectorCollection from: aClass;
		yourself!

removeMethods: selectorCollection from: aClass
	^self new removeMethods: selectorCollection from: aClass! !
!Refactory.Browser.RemoveMethodRefactoring class categoriesForMethods!
model:removeMethods:from:!instance creation!public! !
removeMethods:from:!instance creation!public! !
!

