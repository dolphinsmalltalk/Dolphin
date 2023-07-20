"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.PushUpMethodRefactoring'
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
	| definingClass pushUpParseTree superclass |
	superclass := class superclass.
	definingClass := superclass whoDefinesMethod: aSelector.
	definingClass isNil ifTrue: [^self].
	pushUpParseTree := class parseTreeFor: aSelector.
	superclass allSubclasses do: 
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
	| method privateBindings |
	privateBindings := class instanceClass definedBindings select: [:each | each isPrivate].
	privateBindings isEmpty ifTrue: [^self].
	method := class methodFor: aSelector.
	privateBindings do: 
			[:each |
			(method refersToBinding: each)
				ifTrue: 
					[self refactoringError: ('<1p> refers to <2s> which is defined privately in <3p>'
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
	| superclass |
	superclass := aRBClass superclass.
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
									definer := superclass whoDefinesMethod: aSelector.
									(definer notNil and: [class includesClass: definer])
										ifTrue: 
											[self
												refactoringError: ('Cannot push up <1p> since <2d>>><3s> sends a super message to <4d> that would be intercepted'
														expandMacrosWith: aSelector
														with: aRBClass unqualifiedName
														with: each selector
														with: definer)]]]]].
	#rbFix. "This used to say #allSubclasses, but the method is recursive already so it will visit all the subclasses, so this became a quadratic algorithm rather than linear, explaining why pushing up to Object was so slow..."
	aRBClass subclasses do: [:each | self checkSiblingSuperSendsFrom: each]!

checkSuperclass
	| overrideSelectors superclass |
	superclass := class superclass.
	overrideSelectors := selectors select: [:each | superclass definesMethod: each].
	overrideSelectors := overrideSelectors reject: 
					[:each |
					| myTree superTree |
					myTree := class parseTreeFor: each.
					superTree := superclass parseTreeFor: each.
					superTree equalTo: myTree exceptForVariables: #()].
	overrideSelectors isEmpty ifTrue: [^self].
	superclass isAbstract
		ifFalse: 
			[self refactoringError: ('Non-abstract class <2p> or one of its superclasses already define <1p>'
						expandMacrosWith: overrideSelectors asArray first
						with: superclass)].
	overrideSelectors do: [:each | self checkBackReferencesTo: each]!

checkSuperMessages
	self checkSuperSendsFromPushedUpMethods.
	self checkSuperSendsFromSiblings!

checkSuperSendsFromPushedUpMethods
	| superclass |
	superclass := class superclass.
	selectors do: 
			[:each |
			| parseTree |
			parseTree := class parseTreeFor: each.
			(parseTree superMessages anySatisfy: [:sup | superclass directlyDefinesMethod: sup])
				ifTrue: 
					[self
						refactoringError: ('Cannot push up <1p> since it sends a super message that is defined in the superclass.'
								expandMacrosWith: each)]]!

checkSuperSendsFromSiblings
	| siblings |
	siblings := class superclass subclasses reject: [:each | each = class].
	siblings do: [:aRBClass | self checkSiblingSuperSendsFrom: aRBClass]!

copyDownMethod: aSelector
	| oldProtocols oldSource superclassDefiner subclasses |
	superclassDefiner := class superclass whoDefinesMethod: aSelector.
	superclassDefiner isNil ifTrue: [^self].
	oldSource := superclassDefiner sourceCodeFor: aSelector.
	oldSource isNil
		ifTrue: [self refactoringError: 'Source code for <1s> superclass method not available' << aSelector].
	oldProtocols := superclassDefiner protocolsFor: aSelector.
	subclasses := class superclass subclasses reject: [:each | each directlyDefinesMethod: aSelector].
	subclasses isEmpty ifTrue: [^self].
	((superclassDefiner parseTreeFor: aSelector) superMessages
		anySatisfy: [:each | superclassDefiner directlyDefinesMethod: each])
			ifTrue: 
				[self
					refactoringError: 'The <2p> method in superclass <3d> must be copied down to its other subclasses, but sends a super message that will be overridden.'
							<< { class. aSelector. superclassDefiner unqualifiedName }].
	(self shouldCopyDownSuperclassMethod: aSelector) ifFalse: [self refactoringAborted].
	"We don't need to push down imports, because they are inherited anyway, so just go an compile up the pushed down superclass methods"
	subclasses do: [:each | each compile: oldSource categories: oldProtocols]!

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
	| package namespace superclass method importsRefactoring |
	superclass := class superclass.
	method := class methodFor: aSelector.
	"We need to maintain package of loose methods and any custom namespace"
	package := method owningPackageIfLoose.
	namespace := method customEnvironment.
	importsRefactoring := ExpandImportsRefactoring
				model: self model
				forMethod: method parseTree
				fromClass: class
				toClasses: { superclass }.
	self performComponentRefactoring: importsRefactoring.
	"Before pushing the method up, fully-qualify any static variable references so that they will still bind. This is necessary if the user chose not to expand imports, or for references to class variables defined in the source class as we don't block pushing up such methods any more."
	self performComponentRefactoring: (QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: aSelector
				forClass: class).
	superclass
		compile: (class sourceCodeFor: aSelector)
		environment: namespace
		categories: (class protocolsFor: aSelector)
		package: package.
	"Finally remove any static variable qualification that isn't required"
	self performComponentRefactoring: (UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: aSelector
				forClass: superclass)!

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
	| tree duplicatedIn superclass |
	superclass := class superclass.
	tree := superclass parseTreeFor: aSelector.
	duplicatedIn := superclass allSubclasses select: 
					[:each |
					(each directlyDefinesMethod: aSelector) and: 
							[(tree equalTo: (each parseTreeFor: aSelector) exceptForVariables: #())
								and: [(each superclass whoDefinesMethod: aSelector) == class superclass]]].
	(removeDuplicates or: [duplicatedIn isEmpty])
		ifFalse: [removeDuplicates := self shouldRemoveDuplicatesOf: aSelector in: duplicatedIn].
	removeDuplicates ifTrue: [duplicatedIn do: [:each | each removeSelector: aSelector]]!

removePushedUpMethods
	selectors do: [:each | class removeSelector: each]!

shouldCopyDownSuperclassMethod: aSelector
	^(self lookupOption: #copyDownSuperclassMethod) cull: self cull: aSelector!

shouldRemoveDuplicatesOf: aSymbol in: aCollectionOfClasses
	^(self lookupOption: #pushUpRemoveDuplicates)
		cull: self
		cull: aSymbol
		cull: aCollectionOfClasses!

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
!Refactory.Browser.PushUpMethodRefactoring categoriesForMethods!
checkBackReferencesTo:!preconditions!public! !
checkClassVars!preconditions!public! !
checkClassVarsFor:!preconditions!public! !
checkInstVars!preconditions!public! !
checkInstVarsFor:!preconditions!public! !
checkSiblingSuperSendsFrom:!preconditions!public! !
checkSuperclass!preconditions!public! !
checkSuperMessages!preconditions!public! !
checkSuperSendsFromPushedUpMethods!preconditions!public! !
checkSuperSendsFromSiblings!preconditions!public! !
copyDownMethod:!private!transforming! !
copyDownMethods!public!transforming! !
preconditions!preconditions!public! !
pushUp:!public!transforming! !
pushUp:from:!initialize/release!public! !
pushUpMethods!public!transforming! !
removeDuplicateMethods!public!transforming! !
removeDuplicatesOf:!public!transforming! !
removePushedUpMethods!public!transforming! !
shouldCopyDownSuperclassMethod:!private!requests! !
shouldRemoveDuplicatesOf:in:!private!requests! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.PushUpMethodRefactoring class methodsFor!

model: aRBModel pushUp: selectorCollection from: aClass
	^self new
		model: aRBModel;
		pushUp: selectorCollection from: aClass;
		yourself!

pushUp: selectorCollection from: aClass 
	^self new pushUp: selectorCollection from: aClass! !
!Refactory.Browser.PushUpMethodRefactoring class categoriesForMethods!
model:pushUp:from:!instance creation!public! !
pushUp:from:!instance creation!public! !
!

