"Filed out from Dolphin Smalltalk 7"!

Refactoring subclass: #SplitClassRefactoring
	instanceVariableNames: 'class instanceVariables newClassName referenceVariableName newClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SplitClassRefactoring guid: (GUID fromString: '{22a704e1-3527-4416-ad61-b066186fc300}')!
SplitClassRefactoring comment: ''!
!SplitClassRefactoring categoriesForClass!Refactory-Refactorings! !
!SplitClassRefactoring methodsFor!

abstractReferenceTo: each 
	| setterMethod replacer accessorRef getterMethod |
	accessorRef := CreateAccessorsForVariableRefactoring 
				variable: each
				class: newClass
				classVariable: false.
	self performComponentRefactoring: accessorRef.
	getterMethod := accessorRef getterMethod.
	setterMethod := accessorRef setterMethod.
	replacer := ParseTreeRewriter 
				variable: each
				getter: getterMethod
				setter: setterMethod
				receiver: referenceVariableName.
	self 
		convertClasses: class withAllSubclasses
		select: [:aClass | aClass whichSelectorsReferToInstanceVariable: each]
		using: replacer.
	self performComponentRefactoring: (RemoveInstanceVariableRefactoring variable: each class: class)!

abstractVariableReferences
	instanceVariables do: [:each | self abstractReferenceTo: each]!

addClass
	self performComponentRefactoring: (AddClassRefactoring 
				model: self model
				addClass: newClassName
				superclass: Object
				subclasses: #()
				category: class category).
	newClass := self model classNamed: newClassName!

addInstanceVariables
	instanceVariables do: 
			[:each | 
			self performComponentRefactoring: (AddInstanceVariableRefactoring 
						model: self model
						variable: each
						class: newClass)]!

class: aClass instanceVariables: instVars newClassName: className referenceVariableName: newVariable 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	instanceVariables := instVars.
	newClassName := className.
	referenceVariableName := newVariable.
	class := self model classFor: aClass.
!

createNewClass
	self
		addClass;
		addInstanceVariables!

createReference
	self performComponentRefactoring: (AddInstanceVariableRefactoring 
				variable: referenceVariableName
				class: class)!

preconditions
	^(RBCondition isValidClassName: newClassName) 
		& (RBCondition isGlobal: newClassName in: self model) not 
			& (RBCondition isValidInstanceVariableName: referenceVariableName for: class) 
			& (RBCondition hierarchyOf: class definesVariable: referenceVariableName) 
					not 
			& (RBCondition isGlobal: referenceVariableName in: self model) not 
			& (RBCondition definesTemporaryVariable: referenceVariableName in: class) 
					not!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPutAll: ' instanceVariables: '.
	instanceVariables asArray storeOn: aStream.
	aStream
		nextPutAll: ' newClassName: #';
		nextPutAll: newClassName;
		nextPutAll: ' referenceVariableName: ''';
		nextPutAll: referenceVariableName;
		nextPutAll: ''')'!

transform
	self
		createNewClass;
		createReference;
		abstractVariableReferences! !
!SplitClassRefactoring categoriesFor: #abstractReferenceTo:!private!transforming! !
!SplitClassRefactoring categoriesFor: #abstractVariableReferences!public!transforming! !
!SplitClassRefactoring categoriesFor: #addClass!private!transforming! !
!SplitClassRefactoring categoriesFor: #addInstanceVariables!private!transforming! !
!SplitClassRefactoring categoriesFor: #class:instanceVariables:newClassName:referenceVariableName:!initialize/release!public! !
!SplitClassRefactoring categoriesFor: #createNewClass!public!transforming! !
!SplitClassRefactoring categoriesFor: #createReference!public!transforming! !
!SplitClassRefactoring categoriesFor: #preconditions!preconditions!public! !
!SplitClassRefactoring categoriesFor: #storeOn:!printing!public! !
!SplitClassRefactoring categoriesFor: #transform!public!transforming! !

!SplitClassRefactoring class methodsFor!

class: class instanceVariables: instVars newClassName: className referenceVariableName: newVariable 
	^(self new)
		class: class
			instanceVariables: instVars
			newClassName: className
			referenceVariableName: newVariable;
		yourself!

model: aRBNamespace class: class instanceVariables: instVars newClassName: className referenceVariableName: newVariable 
	^(self new)
		model: aRBNamespace;
		class: class
			instanceVariables: instVars
			newClassName: className
			referenceVariableName: newVariable;
		yourself! !
!SplitClassRefactoring class categoriesFor: #class:instanceVariables:newClassName:referenceVariableName:!instance creation!public! !
!SplitClassRefactoring class categoriesFor: #model:class:instanceVariables:newClassName:referenceVariableName:!instance creation!public! !

