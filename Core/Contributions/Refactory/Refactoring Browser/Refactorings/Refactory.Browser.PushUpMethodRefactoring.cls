"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.MethodRefactoring subclass: #'Refactory.Browser.PushUpMethodRefactoring'
	instanceVariableNames: 'removeDuplicates selectors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.PushUpMethodRefactoring guid: (Core.GUID fromString: '{9124b878-03e9-4e01-abb4-34cf953777f4}')!
Refactory.Browser.PushUpMethodRefactoring comment: ''!
!Refactory.Browser.PushUpMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.PushUpMethodRefactoring methodsFor!

checkBackReferencesTo: aSelector
	| definingClass pushUpParseTree |
	definingClass := class superclass whoDefinesMethod: aSelector.
	definingClass isNil ifTrue: [^self].
	pushUpParseTree := class parseTreeFor: aSelector.
	class superclass allSubclasses do: 
			[:each |
			each selectors do: 
					[:sel |
					| parseTree |
					parseTree := each parseTreeFor: sel.
					(parseTree notNil and: 
							[(parseTree superMessages includes: aSelector)
								and: [definingClass == (each whoDefinesMethod: aSelector)]])
						ifTrue: 
							[removeDuplicates := true.
							(aSelector == sel and: [parseTree equalTo: pushUpParseTree exceptForVariables: #()])
								ifFalse: 
									[self refactoringError: ('Cannot push up <1p> since it would override the method defined in <2p>'
												expandMacrosWith: aSelector
												with: definingClass)]]]]!

checkClassVars
	selectors do: [:each | self checkClassVarsFor: each]!

checkClassVarsFor: aSelector
	class nonMetaclass classVariableNames do: 
			[:each |
			((class whichSelectorsReferToClassVariable: each) includes: aSelector)
				ifTrue: 
					[self refactoringError: ('<1p> refers to <2s> which is defined in <3p>'
								expandMacrosWith: aSelector
								with: each
								with: class)]]!

checkInstVars
	selectors do: [:each | self checkInstVarsFor: each]!

checkInstVarsFor: aSelector
	class instanceVariableNames do: 
			[:each |
			((class whichSelectorsReferToInstanceVariable: each) includes: aSelector)
				ifTrue: 
					[self refactoringError: ('<1p> refers to <2s> which is defined in <3p>'
								expandMacrosWith: aSelector
								with: each
								with: class)]]!

checkSiblingSuperSendsFrom: aRBClass
	selectors do: 
			[:aSelector |
			(aRBClass whichMethodsReferToSymbol: aSelector) do: 
					[:each |
					| tree |
					tree := each parseTree.
					tree notNil
						ifTrue: 
							[(tree superMessages includes: aSelector)
								ifTrue: 
									[| definer |
									definer := aRBClass superclass whoDefinesMethod: aSelector.
									(definer notNil and: [class includesClass: definer])
										ifTrue: 
											[self refactoringError: ('Cannot push up <1p> since <2p>>><3s> sends a super message to it.'
														expandMacrosWith: aSelector
														with: aRBClass
														with: each selector)]]]]].
	aRBClass allSubclasses do: [:each | self checkSiblingSuperSendsFrom: each]!

checkSuperclass
	| overrideSelectors |
	overrideSelectors := selectors select: [:each | class superclass definesMethod: each].
	overrideSelectors := overrideSelectors reject: 
					[:each |
					| myTree superTree |
					myTree := class parseTreeFor: each.
					superTree := class superclass parseTreeFor: each.
					superTree equalTo: myTree exceptForVariables: #()].
	overrideSelectors isEmpty ifTrue: [^self].
	class superclass isAbstract
		ifFalse: 
			[self refactoringError: ('Non-abstract class <2p> or one of its superclasses already define <1p>'
						expandMacrosWith: overrideSelectors asArray first
						with: class superclass)].
	overrideSelectors do: [:each | self checkBackReferencesTo: each]!

checkSuperMessages
	self checkSuperSendsFromPushedUpMethods.
	self checkSuperSendsFromSiblings!

checkSuperSendsFromPushedUpMethods
	selectors do: 
			[:each |
			| parseTree |
			parseTree := class parseTreeFor: each.
			(parseTree superMessages anySatisfy: [:sup | class superclass directlyDefinesMethod: sup])
				ifTrue: 
					[self
						refactoringError: ('Cannot push up <1p> since it sends a super message that is defined in the superclass.'
								expandMacrosWith: each)]]!

checkSuperSendsFromSiblings
	| siblings |
	siblings := class superclass subclasses reject: [:each | each = class].
	siblings do: [:aRBClass | self checkSiblingSuperSendsFrom: aRBClass]!

copyDownMethod: aSelector
	| oldProtocol oldSource superclassDefiner subclasses refactoring |
	superclassDefiner := class superclass whoDefinesMethod: aSelector.
	superclassDefiner isNil ifTrue: [^self].
	oldSource := superclassDefiner sourceCodeFor: aSelector.
	oldSource isNil
		ifTrue: 
			[self
				refactoringError: ('Source code for <1s> superclass method not available' expandMacrosWith: aSelector)].
	oldProtocol := superclassDefiner protocolsFor: aSelector.
	subclasses := class superclass subclasses reject: [:each | each directlyDefinesMethod: aSelector].
	subclasses isEmpty ifTrue: [^self].
	((superclassDefiner parseTreeFor: aSelector) superMessages
		anySatisfy: [:each | superclassDefiner directlyDefinesMethod: each])
			ifTrue: 
				[self
					refactoringError: ('Cannot push up <1p> since we must copy down the superclass method in <2p><n>to the other subclasses, and the superclass method sends a super message which is overridden.'
							expandMacrosWith: aSelector
							with: superclassDefiner)].
	self
		refactoringWarning: ('Do you want to copy down the superclass method to the classes that don''t define <1p>?'
				expandMacrosWith: aSelector).
	refactoring := ExpandReferencedPoolsRefactoring
				model: self model
				forMethod: (superclassDefiner parseTreeFor: aSelector)
				fromClass: superclassDefiner
				toClasses: subclasses.
	self performComponentRefactoring: refactoring.
	subclasses do: [:each | each compile: oldSource classified: oldProtocol]!

copyDownMethods
	selectors do: [:each | self copyDownMethod: each]!

preconditions
	^(selectors inject: (RBCondition hasSuperclass: class)
		into: [:cond :each | cond & (RBCondition definesSelector: each in: class)]) 
			& (RBCondition withBlock: 
						[self checkInstVars.
						self checkClassVars.
						self checkSuperclass.
						self checkSuperMessages.
						true])!

pushUp: aSelector
	| source refactoring change |
	source := class sourceCodeFor: aSelector.
	source isNil ifTrue: [self refactoringError: 'Source for method not available'].
	refactoring := ExpandReferencedPoolsRefactoring
				model: self model
				forMethod: (class parseTreeFor: aSelector)
				fromClass: class
				toClasses: {class superclass}.
	self performComponentRefactoring: refactoring.
	change := class superclass compile: source classified: (class protocolsFor: aSelector).
	#rbFix.	"Bodge change object to maintain package relationship"
	class realClass
		ifNotNil: [:c | change package: (c compiledMethodAt: aSelector) owningPackageIfLoose]!

pushUp: selectorCollection from: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selectors := selectorCollection.
	removeDuplicates := false.
	class := self classObjectFor: aClass!

pushUpMethods
	selectors do: [:each | self pushUp: each]!

removeDuplicateMethods
	selectors do: [:each | self removeDuplicatesOf: each]!

removeDuplicatesOf: aSelector 
	| tree |
	tree := class superclass parseTreeFor: aSelector.
	class superclass allSubclasses do: 
			[:each | 
			((each directlyDefinesMethod: aSelector) and: 
					[(tree equalTo: (each parseTreeFor: aSelector) exceptForVariables: #()) 
						and: [(each superclass whoDefinesMethod: aSelector) == class superclass]]) 
				ifTrue: 
					[removeDuplicates 
						ifFalse: 
							[removeDuplicates := true.
							self 
								refactoringWarning: 'Do you want to remove duplicate subclass methods?'].
					each removeMethod: aSelector]]!

removePushedUpMethods
	selectors do: [:each | class removeMethod: each]!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' pushUp: '.
	selectors asArray storeOn: aStream.
	aStream nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		copyDownMethods;
		pushUpMethods;
		removePushedUpMethods;
		removeDuplicateMethods! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkBackReferencesTo:!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkClassVars!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkClassVarsFor:!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkInstVars!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkInstVarsFor:!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkSiblingSuperSendsFrom:!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkSuperclass!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkSuperMessages!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkSuperSendsFromPushedUpMethods!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #checkSuperSendsFromSiblings!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #copyDownMethod:!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #copyDownMethods!public!transforming! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #pushUp:!public!transforming! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #pushUp:from:!initialize/release!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #pushUpMethods!public!transforming! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #removeDuplicateMethods!public!transforming! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #removeDuplicatesOf:!public!transforming! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #removePushedUpMethods!public!transforming! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.PushUpMethodRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.PushUpMethodRefactoring class methodsFor!

model: aRBNamespace pushUp: selectorCollection from: aClass 
	^(self new)
		model: aRBNamespace;
		pushUp: selectorCollection from: aClass;
		yourself!

pushUp: selectorCollection from: aClass 
	^self new pushUp: selectorCollection from: aClass! !
!Refactory.Browser.PushUpMethodRefactoring class categoriesFor: #model:pushUp:from:!instance creation!public! !
!Refactory.Browser.PushUpMethodRefactoring class categoriesFor: #pushUp:from:!instance creation!public! !

