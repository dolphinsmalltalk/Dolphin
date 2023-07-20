"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.ChangeMethodNameRefactoring'
	instanceVariableNames: 'newSelector oldSelector permutation implementors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ChangeMethodNameRefactoring guid: (Core.GUID fromString: '{3f93d212-d92e-4bbb-b225-17bed064896e}')!
Refactory.Browser.ChangeMethodNameRefactoring isNonInstantiable: true!
Refactory.Browser.ChangeMethodNameRefactoring comment: 'Abstract superclass for refactorings that change a methods selector, e.g. add/remove parameter and rename.

Dolphin modifications to this class are:
	#preconditions 			Cosmetic - includes list of affected classes in warning
	#renameImplementors		Maintains previous package of loose methods
	#renameMethod:in:to:permuation:	General change to ensure display string always valid '!
!Refactory.Browser.ChangeMethodNameRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ChangeMethodNameRefactoring methodsFor!

hasPermutedArguments
	oldSelector argumentCount = newSelector argumentCount ifFalse: [^true].
	1 to: oldSelector argumentCount
		do: [:i | (permutation at: i) = i ifFalse: [^true]].
	^false!

implementors
	implementors isNil 
		ifTrue: [implementors := self model allImplementorsOf: oldSelector].
	^implementors!

implementorsCanBePrimitives
	^false!

modifyImplementorParseTree: parseTree in: aClass 
	| oldArgs |
	oldArgs := parseTree arguments.
	parseTree renameSelector: newSelector
		andArguments: (permutation collect: [:each | oldArgs at: each])!

myConditions
	^self subclassResponsibility!

newSelector
	^newSelector!

parseTreeRewriter
	| rewriteRule oldString newString |
	rewriteRule := ParseTreeRewriter new.
	oldString := self buildSelectorString: oldSelector.
	newString := self buildSelectorString: newSelector withPermuteMap: permutation.
	rewriteRule replace: '``@object ' , oldString with: '``@object ' , newString.
	^rewriteRule!

preconditions
	"This refactoring only preserves behavior if all implementors are renamed."

	| conditions |
	conditions := self myConditions & (RBCondition definesSelector: oldSelector in: class)
				& (RBCondition isValidMethodName: newSelector).
	conditions := self implementors inject: conditions
				into: [:condition :each | condition & (RBCondition hierarchyOf: each canUnderstand: newSelector) not].
	^conditions
		& (RBCondition withBlock: 
					[(self shouldRenameDefinitions: self implementors of: oldSelector) or: [self refactoringAborted]])!

removeRenamedImplementors
	oldSelector == newSelector ifTrue: [^self].
	self implementors do: [:each | each removeSelector: oldSelector]!

renameImplementors
	| namespace package |
	self implementors do: 
			[:each |
			| parseTree method |
			method := each methodFor: oldSelector.
			"We must maintain any custom packaging or namespace of the original method, or the new method may not compile"
			package := method owningPackageIfLoose.
			namespace := method customEnvironment.
			parseTree := method parseTree.
			parseTree isNil ifTrue: [self refactoringError: 'Could not parse source code.'].
			self implementorsCanBePrimitives
				ifFalse: 
					[parseTree isPrimitive
						ifTrue: 
							[self refactoringError: '<1d>''s implementation of #<2s> is a primitive'
										<< { each unqualifiedName. oldSelector }]].
			self modifyImplementorParseTree: parseTree in: each.
			each
				compileTree: parseTree
				environment: namespace
				categories: (each protocolsFor: oldSelector)
				package: package]!

renameMessageSends
	self convertAllReferencesTo: oldSelector using: self parseTreeRewriter!

renameMethod: aSelector in: aClass to: newSel permutation: aMap 
	#rbFix.	"Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	oldSelector := aSelector asSymbol.
	newSelector := newSel asSymbol.
	class := self classObjectFor: aClass.
	permutation := aMap!

shouldRenameDefinitions: aCollection of: aSymbol
	"This option replaces use of a RefactoringWarning in Dolphin 8 for renames where there are multiple implementors because requesting option input allows for a better user experience with a much richer message box."

	^(self lookupOption: #renameAllDefinitions)
		cull: self
		cull: aCollection
		cull: aSymbol!

transform
	self renameImplementors.
	self renameMessageSends.
	self removeRenamedImplementors

! !
!Refactory.Browser.ChangeMethodNameRefactoring categoriesForMethods!
hasPermutedArguments!public!testing! !
implementors!accessing!private! !
implementorsCanBePrimitives!public!testing! !
modifyImplementorParseTree:in:!public! !
myConditions!preconditions!public! !
newSelector!accessing!public! !
parseTreeRewriter!accessing!private! !
preconditions!preconditions!public! !
removeRenamedImplementors!public!transforming! !
renameImplementors!public!transforming! !
renameMessageSends!public!transforming! !
renameMethod:in:to:permutation:!initialize/release!public! !
shouldRenameDefinitions:of:!public!requests! !
transform!public!transforming! !
!

