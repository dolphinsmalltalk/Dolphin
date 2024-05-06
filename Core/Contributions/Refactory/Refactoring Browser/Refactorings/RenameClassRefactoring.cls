"Filed out from Dolphin Smalltalk"!

ClassRefactoring subclass: #RenameClassRefactoring
	instanceVariableNames: 'newName class'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RenameClassRefactoring guid: (GUID fromString: '{4b70f70b-e0fc-4588-8c6f-6a913fd411bd}')!

RenameClassRefactoring comment: ''!

!RenameClassRefactoring categoriesForClass!Refactory-Refactorings! !

!RenameClassRefactoring methodsFor!

className: aName newName: aNewName 
	#rbFix.	"Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	self className: aName.
	newName := aNewName asSymbol.
	class := self model classNamed: className!

preconditions
	^(RBCondition withBlock: [class notNil and: [class isMeta not]]
		errorString: className , ' is not a valid class name') 
			& (RBCondition isValidClassName: newName) 
			& (RBCondition isGlobal: newName in: self model) not!

renameReferences
	| replacer |
	replacer := (ParseTreeRewriter replaceLiteral: className with: newName)
				replace: className with: newName;
				replace: 'Smalltalk.' , className with: 'Smalltalk.' , newName;
				replaceArgument: newName
					withValueFrom: 
						[:aNode | 
						self 
							refactoringError: newName , ' already exists within the reference scope'];
				yourself.
	self model allReferencesToClass: class
		do: 
			[:method | 
			(method modelClass hierarchyDefinesVariable: newName) 
				ifTrue: 
					[self refactoringError: newName , ' is already defined in hierarchy of ' 
								, method modelClass printString].
			self 
				convertMethod: method selector
				for: method modelClass
				using: replacer]!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' rename: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' to: #';
		nextPutAll: newName;
		nextPut: $)!

transform
	self model 
		renameClass: class
		to: newName
		around: [self renameReferences]! !

!RenameClassRefactoring categoriesForMethods!
className:newName:!initialize/release!public! !
preconditions!preconditions!public! !
renameReferences!public!transforming! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!RenameClassRefactoring class methodsFor!

model: aRBNamespace rename: aClass to: aNewName 
	^(self new)
		model: aRBNamespace;
		className: aClass name newName: aNewName;
		yourself!

rename: aClass to: aNewName
	^self new className: aClass name newName: aNewName! !

!RenameClassRefactoring class categoriesForMethods!
model:rename:to:!instance creation!public! !
rename:to:!instance creation!public! !
!

