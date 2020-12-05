"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.InlineMethodRefactoring subclass: #'Refactory.Browser.InlineMethodFromComponentRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.InlineMethodFromComponentRefactoring guid: (Core.GUID fromString: '{f56f3dba-48f3-4b00-8281-fcdff1f92c33}')!
Refactory.Browser.InlineMethodFromComponentRefactoring comment: ''!
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.InlineMethodFromComponentRefactoring methodsFor!

abstractVariableReferences
	| refactoring |
	refactoring := AbstractVariablesRefactoring
				model: self model
				abstractVariablesIn: inlineParseTree
				from: inlineClass
				toAll: {class}.
	self performComponentRefactoring: refactoring.
	inlineParseTree := refactoring parseTree!

addArgumentToSelector: aSymbol 
	^aSymbol isInfix 
		ifTrue: [#value:value:]
		ifFalse: [(aSymbol , 'value:') asSymbol]!

addSelfReferenceToInlineParseTree
	| variableName rewriter newArguments |
	variableName := self newNameForSelf.
	rewriter := ParseTreeRewriter rename: 'self' to: variableName.
	(rewriter executeTree: inlineParseTree) ifTrue: [inlineParseTree := rewriter tree].
	newArguments := OrderedCollection withAll: inlineParseTree arguments.
	newArguments addFirst: (RBVariableNode named: variableName).
	inlineParseTree renameSelector: (self addArgumentToSelector: inlineParseTree selector)
		andArguments: newArguments.
	sourceMessage receiver replaceWith: (RBVariableNode named: variableName)!

addSelfReferenceToSourceMessage
	| newArguments |
	newArguments := OrderedCollection withAll: sourceMessage arguments.
	newArguments addFirst: sourceMessage receiver copy.
	sourceMessage renameSelector: (self addArgumentToSelector: sourceMessage selector)
		andArguments: newArguments!

checkSuperMessages
	inlineParseTree superMessages notEmpty 
		ifTrue: [self refactoringError: 'Cannot inline method since it sends a super message']!

findSelectedMessage
	sourceParseTree := class parseTreeFor: sourceSelector.
	sourceParseTree isNil 
		ifTrue: [self refactoringError: 'Could not parse sources'].
	sourceMessage := sourceParseTree whichNodeIsContainedBy: sourceInterval.
	sourceMessage isNil 
		ifTrue: 
			[self 
				refactoringError: 'The selection doesn''t appear to be a message send'].
	sourceMessage isCascade 
		ifTrue: [sourceMessage := sourceMessage messages last].
	sourceMessage isMessage 
		ifFalse: 
			[self 
				refactoringError: 'The selection doesn''t appear to be a message send']!

inlineClass
	| imps |
	inlineClass notNil ifTrue: [^inlineClass].
	imps := (self model allImplementorsOf: self inlineSelector) asOrderedCollection.
	imps size = 1 ifTrue: [^inlineClass := imps first].
	imps isEmpty
		ifTrue: 
			[self refactoringError: ('There are no definitions of <1p>' expandMacrosWith: self inlineSelector)].
	inlineClass := self requestImplementorToInline: imps.
	inlineClass isNil
		ifTrue: 
			[#rbFix.	"Use abort signal rather than error"
			self refactoringAborted: 'No implementor selected'].
	^inlineClass!

isOverridden
	^self inlineClass allSubclasses 
		anySatisfy: [:each | each directlyDefinesMethod: self inlineSelector]!

newNameForSelf
	| variableName index originalName nonMetaClass name |
	nonMetaClass := inlineClass nonMetaclass.
	name := nonMetaClass unqualifiedName.
	variableName := originalName := (name first isVowel ifTrue: ['an'] ifFalse: ['a']) , name.
	index := 1.
	
	[variableName := self safeVariableNameBasedOn: variableName.
	inlineParseTree allDefinedVariables includes: variableName]
			whileTrue: 
				[variableName := originalName , index printString.
				index := index + 1].
	^variableName!

renameSelfReferences
	self addSelfReferenceToSourceMessage.
	self addSelfReferenceToInlineParseTree.!

safeVariableNameBasedOn: aString 
	"Creates an unused variable name containing aString"

	| baseString newString i allTempVars |
	allTempVars := inlineParseTree allTemporaryVariables.
	baseString := aString copy.
	baseString at: 1 put: baseString first asLowercase.
	newString := baseString.
	i := 0.
	
	[(allTempVars includes: newString) 
		or: [class definesInstanceVariable: newString]] 
			whileTrue: 
				[i := i + 1.
				newString := baseString , i printString].
	^newString!

transform
	self abstractVariableReferences.
	self renameSelfReferences.
	super transform! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #abstractVariableReferences!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #addArgumentToSelector:!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #addSelfReferenceToInlineParseTree!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #addSelfReferenceToSourceMessage!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #checkSuperMessages!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #findSelectedMessage!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #inlineClass!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #isOverridden!public! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #newNameForSelf!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #renameSelfReferences!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #safeVariableNameBasedOn:!public!transforming! !
!Refactory.Browser.InlineMethodFromComponentRefactoring categoriesFor: #transform!public!transforming! !

