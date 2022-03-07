"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring subclass: #'Refactory.Browser.RenameClassVariableRefactoring'
	instanceVariableNames: 'newName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameClassVariableRefactoring guid: (Core.GUID fromString: '{003765cb-253b-40cb-9a7a-fc0be15648ec}')!
Refactory.Browser.RenameClassVariableRefactoring comment: ''!
!Refactory.Browser.RenameClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RenameClassVariableRefactoring methodsFor!

preconditions
	^(RBCondition isMetaclass: class) not
		& (RBCondition isValidClassVarName: newName asString for: class)
			& (RBCondition definesClassVariable: variableName asString in: class)
			& (RBCondition hierarchyOf: class definesVariable: newName asString) not
			& (RBCondition isStatic: newName asString in: self model) not!

rename: aVarName to: aName in: aClass
	#rbFix. "Set the newName first so displayString works."
	newName := aName.
	self variable: aVarName class: aClass.
!

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
	| methods binding |
	binding := class bindingFor: variableName.
	methods := model allReferencesToBinding: binding.
	methods do: [:each | each boundParseTree].
	class
		renameClassVariable: variableName
		to: newName
		around: [self rewriteStaleVariableReferences: methods]! !
!Refactory.Browser.RenameClassVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
rename:to:in:!initialize/release!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.RenameClassVariableRefactoring class methodsFor!

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
!Refactory.Browser.RenameClassVariableRefactoring class categoriesForMethods!
model:rename:to:in:!instance creation!public! !
rename:to:in:!instance creation!public! !
!

