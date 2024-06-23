"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.RenameInstanceVariableRefactoring'
	instanceVariableNames: 'newName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RenameInstanceVariableRefactoring guid: (Core.GUID fromString: '{9ad927e1-5ba7-4dcf-bcd0-6555ab567203}')!

Refactory.Browser.RenameInstanceVariableRefactoring comment: ''!

!Refactory.Browser.RenameInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.RenameInstanceVariableRefactoring methodsFor!

preconditions
	^(RBCondition isValidInstanceVariableName: newName)
		& (RBCondition definesInstanceVariable: variableName in: class)
			& (RBCondition hierarchyOf: class definesVariable: newName) not
			& (RBCondition isStatic: newName in: self model) not!

rename: aVarName to: aName in: aClass
	#rbFix. "Set the newName first so displayString works."
	newName := aName.
	self variable: aVarName class: aClass.
!

renameReferences
	| replacer |
	replacer := ParseTreeRewriter
				rename: variableName
				to: newName
				handler: 
					[self
						refactoringError: ('<1s> is already defined as a method or block temporary <n> variable in this class or one of its subclasses'
								expandMacrosWith: newName)].
	class withAllSubclasses do: 
			[:subclass |
			(subclass whichSelectorsReferToInstanceVariable: variableName)
				do: [:selector | self convertMethod: (subclass methodFor: selector) using: replacer]]!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' rename: ''';
		nextPutAll: variableName;
		nextPutAll: ''' to: ''';
		nextPutAll: newName;
		nextPutAll: ''' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	class 
		renameInstanceVariable: variableName
		to: newName
		around: [self renameReferences]! !

!Refactory.Browser.RenameInstanceVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
rename:to:in:!initialize/release!public! !
renameReferences!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.RenameInstanceVariableRefactoring class methodsFor!

model: aRBModel rename: aVarName to: aName in: aClass
	^self new
		model: aRBModel;
		rename: aVarName
			to: aName
			in: aClass;
		yourself!

rename: aVarName to: aName in: aClass
	^self new
		rename: aVarName
		to: aName
		in: aClass! !

!Refactory.Browser.RenameInstanceVariableRefactoring class categoriesForMethods!
model:rename:to:in:!instance creation!public! !
rename:to:in:!instance creation!public! !
!

