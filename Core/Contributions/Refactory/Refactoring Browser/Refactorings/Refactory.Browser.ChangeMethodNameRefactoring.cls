"Filed out from Dolphin Smalltalk 7"!

MethodRefactoring subclass: #ChangeMethodNameRefactoring
	instanceVariableNames: 'newSelector oldSelector permutation implementors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChangeMethodNameRefactoring guid: (GUID fromString: '{3f93d212-d92e-4bbb-b225-17bed064896e}')!
ChangeMethodNameRefactoring isAbstract: true!
ChangeMethodNameRefactoring comment: 'Abstract superclass for refactorings that change a methods selector, e.g. add/remove parameter and rename.

Dolphin modifications to this class are:
	#preconditions 			Cosmetic - includes list of affected classes in warning
	#renameImplementors		Maintains previous package of loose methods
	#renameMethod:in:to:permuation:	General change to ensure display string always valid '!
!ChangeMethodNameRefactoring categoriesForClass!Refactory-Refactorings! !
!ChangeMethodNameRefactoring methodsFor!

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
	newString := self buildSelectorString: newSelector
				withPermuteMap: permutation.
	rewriteRule replace: '``@object ' , oldString
		with: '``@object ' , newString.
	^rewriteRule!

preconditions
	"This refactoring only preserves behavior if all implementors are renamed."

	| conditions |
	conditions := self myConditions 
				& (RBCondition definesSelector: oldSelector in: class) 
					& (RBCondition isValidMethodName: newSelector for: class).
	conditions := self implementors inject: conditions
				into: 
					[:condition :each | 
					condition & (RBCondition hierarchyOf: each canUnderstand: newSelector) not].
	^conditions 
		& (RBCondition withBlock: 
					[| definitions |
					definitions := self implementors.
					definitions size > 1 
						ifTrue: 
							[| msg |
							#rbFix.	"Include list of classes (if short) so user can get better idea of effect"
							msg := String writeStream.
							definitions size < 30 
								ifTrue: 
									[msg
										print: oldSelector;
										nextPutAll: ' is implemented in:';
										cr.
									(definitions asSortedCollection: [:a :b | a name < b name]) do: 
											[:each | 
											msg
												crtab;
												print: each].
									msg
										cr;
										cr].
							msg
								nextPutAll: 'This will modify all ';
								display: definitions size;
								nextPutAll: ' implementors.'.
							self refactoringWarning: msg contents].
					true])!

removeRenamedImplementors
	oldSelector == newSelector ifTrue: [^self].
	self implementors do: [:each | each removeMethod: oldSelector]!

renameImplementors
	self implementors do: 
			[:each |
			| parseTree change |
			parseTree := each parseTreeFor: oldSelector.
			parseTree isNil ifTrue: [self refactoringError: 'Could not parse source code.'].
			self implementorsCanBePrimitives
				ifFalse: 
					[parseTree isPrimitive
						ifTrue: 
							[self refactoringError: ('<1p>''s implementation of #<2s> is a primitive' expandMacrosWith: each
										with: oldSelector)]].
			self modifyImplementorParseTree: parseTree in: each.
			change := each compileTree: parseTree classified: (each protocolsFor: oldSelector).
			#rbFix.	"Bodge change object to maintain package relationship"
			each realClass ifNotNil: [:c | change package: (c compiledMethodAt: oldSelector) owningPackage]]!

renameMessageSends
	self convertAllReferencesTo: oldSelector using: self parseTreeRewriter!

renameMethod: aSelector in: aClass to: newSel permutation: aMap 
	#rbFix.	"Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	oldSelector := aSelector asSymbol.
	newSelector := newSel asSymbol.
	class := self classObjectFor: aClass.
	permutation := aMap!

transform
	self renameImplementors.
	self renameMessageSends.
	self removeRenamedImplementors

! !
!ChangeMethodNameRefactoring categoriesFor: #hasPermutedArguments!public!testing! !
!ChangeMethodNameRefactoring categoriesFor: #implementors!accessing!private! !
!ChangeMethodNameRefactoring categoriesFor: #implementorsCanBePrimitives!public!testing! !
!ChangeMethodNameRefactoring categoriesFor: #modifyImplementorParseTree:in:!public! !
!ChangeMethodNameRefactoring categoriesFor: #myConditions!preconditions!public! !
!ChangeMethodNameRefactoring categoriesFor: #newSelector!accessing!public! !
!ChangeMethodNameRefactoring categoriesFor: #parseTreeRewriter!accessing!private! !
!ChangeMethodNameRefactoring categoriesFor: #preconditions!preconditions!public! !
!ChangeMethodNameRefactoring categoriesFor: #removeRenamedImplementors!public!transforming! !
!ChangeMethodNameRefactoring categoriesFor: #renameImplementors!public!transforming! !
!ChangeMethodNameRefactoring categoriesFor: #renameMessageSends!public!transforming! !
!ChangeMethodNameRefactoring categoriesFor: #renameMethod:in:to:permutation:!initialize/release!public! !
!ChangeMethodNameRefactoring categoriesFor: #transform!public!transforming! !

