"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.ClassRefactoring subclass: #'Refactory.Browser.RenameClassRefactoring'
	instanceVariableNames: 'newName class'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameClassRefactoring guid: (Core.GUID fromString: '{4b70f70b-e0fc-4588-8c6f-6a913fd411bd}')!
Refactory.Browser.RenameClassRefactoring comment: ''!
!Refactory.Browser.RenameClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RenameClassRefactoring methodsFor!

className: aName newName: aNewName
	self className: aName.
	"If the new name is unqualified, preserve the original namespace of the class."
	#namespaceToDo.	"Do we need the asSymbol here?"
	newName := ((BindingReference isQualifiedName: aNewName)
				ifTrue: [aNewName]
				ifFalse: 
					[| parts |
					parts := $. split: aName.
					parts at: parts size put: aNewName.
					$. join: parts])
					asSymbol.
	class := self model classNamed: className!

preconditions
	^(RBCondition withBlock: [class notNil and: [class isMeta not]]
		errorString: className , ' is not an existing class') 
			& (RBCondition isValidClassName: newName) 
			& (RBCondition hasNamespace: newName)
			& (RBCondition isGlobal: newName in: self model) not!

renameImportsOf: oldBindingRef to: newBindingRef
	"Private - Update any imports of the class - here we really need to match any of the binding references that might refer to the original class"

	self model allClassesDo: 
			[:eachClass |
			eachClass isMeta
				ifFalse: 
					[(eachClass imports includes: oldBindingRef)
						ifTrue: 
							[eachClass
								addImport: newBindingRef;
								removeImport: oldBindingRef]]]!

renameReferences
	"Note that renaming a class will rename any Symbols that happen to be the name of the class, whether directly held literals or embedded in literal arrays. This is not strictly a refactoring as one cannot be certain that an arbitrary Symbol in a method that happens to be the same as a class name is actually intended for use as the name of that class. This is one good reason to use BindingReferences instead, since these are intended as references to classes so if they bound to the original class, we can be reasonably certain that they should also be renamed."

	| newRef oldRef oldUnqualified newUnqualified replacer |
	"The old and new names are full names"
	newRef := newName asQualifiedReference.
	oldRef := className asQualifiedReference.
	#namespaceToDo.	"Also rename BindingReferences that are referring to the class being renamed."
	#namespaceToDo. "External types appearing in ExternalMethod function descriptors also need to be renamed - seems like a pre-existing issue with not finding these."
	self renameImportsOf: oldRef to: newRef.
	"First the full names as both symbols and variables"
	replacer := (ParseTreeRewriter replaceLiteral: className asSymbol with: newName asSymbol)
				replace: className with: newName;
				yourself.
	#namespaceToDo.	"This is just bodged to rename all possible references - they may not actually be references. This needs to be checked against the method's binding environment. Also we need to determine the most minimal name to use as the replacement in that environment as we are allowing the rename refactoring to move classes to different namespaces. A lot of work is needed here. I don't think this can be done correctly without modelling namespaces in the RB model, as we need to rename all the possible names (full, short, etc), and which of those are valid references in any particular method will depend on the binding scope at that point."
	oldUnqualified := oldRef unqualifiedName.
	newUnqualified := newRef unqualifiedName.
	newRef environmentName = oldRef environmentName
		ifTrue: 
			["Rename unqualified refs to unqualified as the namespace remains the same. As mentioned above we really need to check that the reference is actually a relevant name to this rename, depending on the binding scope, but to do so we need some model of namespaces to resolve names in context."
			replacer
				replaceTree: (RBLiteralNode value: oldUnqualified asSymbol)
					withTree: (RBLiteralNode value: newUnqualified asSymbol);
				replace: oldUnqualified with: newUnqualified]
		ifFalse: 
			[| shortName |
			"Namespace has changed: Replace original unqualified references with fully qualified reference, unless the target namespace is imported into Smalltalk - again a temporary bodge"
			shortName := (Smalltalk imports includes: newRef environmentName asQualifiedReference)
						ifTrue: [newUnqualified]
						ifFalse: [newName].
			replacer
				replaceTree: (RBLiteralNode value: oldUnqualified asSymbol)
					withTree: (RBLiteralNode value: shortName asSymbol);
				replace: oldUnqualified with: shortName].
	replacer replaceArgument: newUnqualified
		withValueFrom: [:aNode | self refactoringError: newUnqualified , ' already exists within the reference scope'].
	self model allReferencesToClass: class
		do: 
			[:method |
			#namespaceToDo.	"Need to check that the new name is not ambiguous in the target scope, not necessarily that it isn't defined."
			(method modelClass hierarchyDefinesVariable: newName)
				ifTrue: 
					[self
						refactoringError: newName , ' is already defined in hierarchy of ' , method modelClass printString].
			self convertMethod: method using: replacer]!

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
!Refactory.Browser.RenameClassRefactoring categoriesFor: #className:newName:!initialize/release!public! !
!Refactory.Browser.RenameClassRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.RenameClassRefactoring categoriesFor: #renameImportsOf:to:!private!transforming! !
!Refactory.Browser.RenameClassRefactoring categoriesFor: #renameReferences!public!transforming! !
!Refactory.Browser.RenameClassRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.RenameClassRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.RenameClassRefactoring class methodsFor!

model: aRBNamespace rename: aClass to: aNewName 
	^(self new)
		model: aRBNamespace;
		className: aClass fullName newName: aNewName;
		yourself!

rename: aClass to: aNewName
	^self new className: aClass fullName newName: aNewName! !
!Refactory.Browser.RenameClassRefactoring class categoriesFor: #model:rename:to:!instance creation!public! !
!Refactory.Browser.RenameClassRefactoring class categoriesFor: #rename:to:!instance creation!public! !

