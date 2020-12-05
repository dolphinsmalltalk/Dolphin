"Filed out from Dolphin Smalltalk 7"!

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
			& (RBCondition isGlobal: newName asString in: self model) not!

rename: aVarName to: aName in: aClass
	#rbFix. "Set the newName first so displayString works."
	newName := aName.
	self variable: aVarName class: aClass.
!

renameReferences
	| replacer subclasses |
	replacer := ParseTreeRewriter
				rename: variableName
				to: newName
				handler: 
					[self
						refactoringError: ('<1s> is already defined as a method or block temporary <n> variable in this class or one of its subclasses'
								expandMacrosWith: newName)].
	subclasses := class withAllSubclasses asSet.
	subclasses addAll: class metaclass withAllSubclasses.
	self
		convertClasses: subclasses
		select: [:aClass | aClass whichSelectorsReferToClassVariable: variableName]
		using: replacer!

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
		renameClassVariable: variableName
		to: newName
		around: [self renameReferences]! !
!Refactory.Browser.RenameClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.RenameClassVariableRefactoring categoriesFor: #rename:to:in:!initialize/release!public! !
!Refactory.Browser.RenameClassVariableRefactoring categoriesFor: #renameReferences!public!transforming! !
!Refactory.Browser.RenameClassVariableRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.RenameClassVariableRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.RenameClassVariableRefactoring class methodsFor!

model: aRBNamespace rename: aVarName to: aName in: aClass 
	^(self new)
		model: aRBNamespace;
		rename: aVarName
			to: aName
			in: aClass;
		yourself!

rename: aVarName to: aName in: aClass
	^self new
		rename: aVarName
		to: aName
		in: aClass! !
!Refactory.Browser.RenameClassVariableRefactoring class categoriesFor: #model:rename:to:in:!instance creation!public! !
!Refactory.Browser.RenameClassVariableRefactoring class categoriesFor: #rename:to:in:!instance creation!public! !

