"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #RenameInstanceVariableRefactoring
	instanceVariableNames: 'newName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameInstanceVariableRefactoring guid: (GUID fromString: '{9ad927e1-5ba7-4dcf-bcd0-6555ab567203}')!
RenameInstanceVariableRefactoring comment: ''!
!RenameInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!RenameInstanceVariableRefactoring methodsFor!

preconditions
	^(RBCondition isValidInstanceVariableName: newName for: class) 
		& (RBCondition definesInstanceVariable: variableName in: class) 
			& (RBCondition hierarchyOf: class definesVariable: newName) not 
			& (RBCondition isGlobal: newName in: self model) not!

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
	self 
		convertClasses: class withAllSubclasses
		select: [:aClass | aClass whichSelectorsReferToInstanceVariable: variableName]
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
		renameInstanceVariable: variableName
		to: newName
		around: [self renameReferences]! !
!RenameInstanceVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
rename:to:in:!initialize/release!public! !
renameReferences!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!RenameInstanceVariableRefactoring class methodsFor!

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
!RenameInstanceVariableRefactoring class categoriesForMethods!
model:rename:to:in:!instance creation!public! !
rename:to:in:!instance creation!public! !
!

