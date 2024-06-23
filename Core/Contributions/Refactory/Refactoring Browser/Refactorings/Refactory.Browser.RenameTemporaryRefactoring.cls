"Filed out from Dolphin Smalltalk"!

Refactory.Browser.MethodRefactoring
	subclass: #'Refactory.Browser.RenameTemporaryRefactoring'
	instanceVariableNames: 'selector interval oldName newName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RenameTemporaryRefactoring guid: (Core.GUID fromString: '{605981c4-3d80-4ce9-b0ac-9691e8a47ded}')!

Refactory.Browser.RenameTemporaryRefactoring comment: ''!

!Refactory.Browser.RenameTemporaryRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.RenameTemporaryRefactoring methodsFor!

class: aClass selector: aSelector interval: anInterval newName: aString 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	selector := aSelector.
	interval := anInterval.
	newName := aString.
	class := self classObjectFor: aClass.
!

oldName: aString 
	#rbFix.	"Add this accessor: Update name of model since we now know the oldName."
	oldName := aString.
	self model name: self displayString!

preconditions
	^(RBCondition definesSelector: selector in: class)
		& (RBCondition isValidTemporaryVariableName: newName)
			& (RBCondition definesInstanceVariable: newName in: class) not
			& (RBCondition definesStaticVariable: newName in: class) not
			& (RBCondition withBlock: 
						[| methodSource |
						interval first > interval last ifTrue: [self refactoringError: 'Invalid variable name'].
						methodSource := class sourceCodeFor: selector.
						methodSource size >= interval last ifFalse: [self refactoringError: 'Invalid range for variable'].
						self oldName: (methodSource copyFrom: interval first to: interval last).
						true])!

renameNode: aParseTree
	| rewriter |
	(aParseTree whoDefines: newName) notNil
		ifTrue: [self refactoringError: newName , ' is already defined'].
	(aParseTree allDefinedVariables includes: newName)
		ifTrue: [self refactoringError: newName , ' is already defined'].
	rewriter := ParseTreeRewriter rename: oldName to: newName.
	^(rewriter executeTree: aParseTree)
		ifTrue: [rewriter tree]
		ifFalse: [self refactoringError: 'Expected renames did not take place']!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' renameTemporaryFrom: '.
	interval storeOn: aStream.
	aStream
		nextPutAll: ' to: ''';
		nextPutAll: newName;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' selector: ';
		print: selector.
	aStream nextPut: $)!

transform
	| definingNode variableNode method parseTree |
	method := class methodFor: selector.
	parseTree := method parseTreeWithSourceIntervals copy.
	variableNode := self
				whichVariableNode: parseTree
				inInterval: interval
				name: oldName.
	(variableNode isNil or: [variableNode isVariable not])
		ifTrue: [self refactoringError: oldName , ' isn''t a valid variable'].
	variableNode name = oldName ifFalse: [self refactoringError: 'Invalid selection'].
	definingNode := variableNode whoDefines: oldName.
	definingNode ifNil: [self refactoringError: oldName , ' isn''t defined by the method'].
	"The ParseTreeRewriter actually updates in place, otherwise we'd have to update the body of the defining node at this point."
	self renameNode: definingNode.
	model compileTree: parseTree forMethod: method! !

!Refactory.Browser.RenameTemporaryRefactoring categoriesForMethods!
class:selector:interval:newName:!initialize/release!public! !
oldName:!accessing!private! !
preconditions!preconditions!public! !
renameNode:!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.RenameTemporaryRefactoring class methodsFor!

model: aRBModel renameTemporaryFrom: anInterval to: newName in: aClass selector: aSelector
	^self new
		model: aRBModel;
		class: aClass
			selector: aSelector
			interval: anInterval
			newName: newName;
		yourself!

renameTemporaryFrom: anInterval to: newName in: aClass selector: aSelector 
	^self new
		class: aClass
		selector: aSelector
		interval: anInterval
		newName: newName! !

!Refactory.Browser.RenameTemporaryRefactoring class categoriesForMethods!
model:renameTemporaryFrom:to:in:selector:!instance creation!public! !
renameTemporaryFrom:to:in:selector:!instance creation!public! !
!

