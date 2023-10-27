"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.SplitClassRefactoring'
	instanceVariableNames: 'class instanceVariables newClassName referenceVariableName newClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.SplitClassRefactoring guid: (Core.GUID fromString: '{22a704e1-3527-4416-ad61-b066186fc300}')!
Refactory.Browser.SplitClassRefactoring comment: ''!
!Refactory.Browser.SplitClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.SplitClassRefactoring methodsFor!

abstractReferenceToInstanceVariable: aString
	| replacer createAccessors |
	createAccessors := CreateAccessorsForVariableRefactoring
				variable: aString
				class: newClass
				classVariable: false.
	self performComponentRefactoring: createAccessors.
	replacer := ParseTreeRewriter
				replaceInstanceVariable: aString
				withGetter: createAccessors getterMethod
				andSetter: createAccessors setterMethod
				forReceiver: referenceVariableName.
	class withAllSubclasses do: 
			[:subclass |
			(subclass whichSelectorsReferToInstanceVariable: aString)
				do: [:selector | self convertMethod: (subclass methodFor: selector) using: replacer]].
	self performComponentRefactoring: (RemoveInstanceVariableRefactoring variable: aString class: class)!

abstractVariableReferences
	instanceVariables do: [:each | self abstractReferenceToInstanceVariable: each]!

addClass
	self performComponentRefactoring: (AddClassRefactoring
				model: self model
				addClass: newClassName
				superclass: Object
				subclasses: #()
				categories: class categories).
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
	self performComponentRefactoring: (AddInstanceVariableRefactoring variable: referenceVariableName
				class: class)!

preconditions
	^(RBCondition isValidClassName: newClassName)
		& (RBCondition isStatic: newClassName in: self model) not
			& (RBCondition isValidInstanceVariableName: referenceVariableName)
			& (RBCondition hierarchyOf: class definesVariable: referenceVariableName) not
			& (RBCondition isStatic: referenceVariableName in: self model) not
			& (RBCondition definesTemporaryVariable: referenceVariableName in: class) not!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPutAll: ' instanceVariables: '.
	instanceVariables asArray storeOn: aStream.
	aStream
		nextPutAll: ' newClassName: ';
		print: newClassName asSymbol;
		nextPutAll: ' referenceVariableName: ''';
		nextPutAll: referenceVariableName;
		nextPutAll: ''')'!

transform
	self
		createNewClass;
		createReference;
		abstractVariableReferences! !
!Refactory.Browser.SplitClassRefactoring categoriesForMethods!
abstractReferenceToInstanceVariable:!private!transforming! !
abstractVariableReferences!public!transforming! !
addClass!private!transforming! !
addInstanceVariables!private!transforming! !
class:instanceVariables:newClassName:referenceVariableName:!initialize/release!public! !
createNewClass!public!transforming! !
createReference!public!transforming! !
preconditions!preconditions!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.SplitClassRefactoring class methodsFor!

class: class instanceVariables: instVars newClassName: className referenceVariableName: newVariable 
	^(self new)
		class: class
			instanceVariables: instVars
			newClassName: className
			referenceVariableName: newVariable;
		yourself!

model: aRBModel class: class instanceVariables: instVars newClassName: className referenceVariableName: newVariable
	^self new
		model: aRBModel;
		class: class
			instanceVariables: instVars
			newClassName: className
			referenceVariableName: newVariable;
		yourself! !
!Refactory.Browser.SplitClassRefactoring class categoriesForMethods!
class:instanceVariables:newClassName:referenceVariableName:!instance creation!public! !
model:class:instanceVariables:newClassName:referenceVariableName:!instance creation!public! !
!

