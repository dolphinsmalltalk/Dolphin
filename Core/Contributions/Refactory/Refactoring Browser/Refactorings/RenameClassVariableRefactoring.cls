"Filed out from Dolphin Smalltalk 7"!

VariableRefactoring subclass: #RenameClassVariableRefactoring
	instanceVariableNames: 'newName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RenameClassVariableRefactoring guid: (GUID fromString: '{003765cb-253b-40cb-9a7a-fc0be15648ec}')!
RenameClassVariableRefactoring comment: ''!
!RenameClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!RenameClassVariableRefactoring methodsFor!

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
!RenameClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!RenameClassVariableRefactoring categoriesFor: #rename:to:in:!initialize/release!public! !
!RenameClassVariableRefactoring categoriesFor: #renameReferences!public!transforming! !
!RenameClassVariableRefactoring categoriesFor: #storeOn:!printing!public! !
!RenameClassVariableRefactoring categoriesFor: #transform!public!transforming! !

!RenameClassVariableRefactoring class methodsFor!

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
!RenameClassVariableRefactoring class categoriesFor: #model:rename:to:in:!instance creation!public! !
!RenameClassVariableRefactoring class categoriesFor: #rename:to:in:!instance creation!public! !

