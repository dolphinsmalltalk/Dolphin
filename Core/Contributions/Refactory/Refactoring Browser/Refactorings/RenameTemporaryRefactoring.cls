"Filed out from Dolphin Smalltalk"!

MethodRefactoring subclass: #RenameTemporaryRefactoring
	instanceVariableNames: 'selector interval oldName newName parseTree'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RenameTemporaryRefactoring guid: (GUID fromString: '{605981c4-3d80-4ce9-b0ac-9691e8a47ded}')!

RenameTemporaryRefactoring comment: ''!

!RenameTemporaryRefactoring categoriesForClass!Refactory-Refactorings! !

!RenameTemporaryRefactoring methodsFor!

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
		& (RBCondition isValidTemporaryVariableName: newName for: class) 
			& (RBCondition definesInstanceVariable: newName in: class) not 
			& (RBCondition definesClassVariable: newName in: class) not 
			& (RBCondition withBlock: 
						[| methodSource |
						interval first > interval last ifTrue: [self refactoringError: 'Invalid variable name'].
						methodSource := class sourceCodeFor: selector.
						methodSource size >= interval last ifFalse: [self refactoringError: 'Invalid range for variable'].
						self oldName: (methodSource copyFrom: interval first to: interval last).
						true])!

renameNode: aParseTree 
	(aParseTree whoDefines: newName) notNil 
		ifTrue: [self refactoringError: newName , ' is already defined'].
	(aParseTree allDefinedVariables includes: newName) 
		ifTrue: [self refactoringError: newName , ' is already defined'].
	(ParseTreeRewriter rename: oldName to: newName) executeTree: aParseTree!

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
		nextPutAll: ' selector: #';
		nextPutAll: selector.
	aStream nextPut: $)!

transform
	| definingNode variableNode |
	parseTree := class parseTreeFor: selector.
	variableNode := self 
				whichVariableNode: parseTree
				inInterval: interval
				name: oldName.
	(variableNode isNil or: [variableNode isVariable not]) 
		ifTrue: [self refactoringError: oldName , ' isn''t a valid variable'].
	variableNode name = oldName 
		ifFalse: [self refactoringError: 'Invalid selection'].
	definingNode := variableNode whoDefines: oldName.
	definingNode isNil 
		ifTrue: [self refactoringError: oldName , ' isn''t defined by the method'].
	self renameNode: definingNode.
	class compileTree: parseTree! !

!RenameTemporaryRefactoring categoriesForMethods!
class:selector:interval:newName:!initialize/release!public! !
oldName:!accessing!private! !
preconditions!preconditions!public! !
renameNode:!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!RenameTemporaryRefactoring class methodsFor!

model: aRBNamespace renameTemporaryFrom: anInterval to: newName in: aClass selector: aSelector 
	^(self new)
		model: aRBNamespace;
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

!RenameTemporaryRefactoring class categoriesForMethods!
model:renameTemporaryFrom:to:in:selector:!instance creation!public! !
renameTemporaryFrom:to:in:selector:!instance creation!public! !
!

