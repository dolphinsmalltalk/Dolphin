"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.AbstractInstanceVariableRefactoring'
	instanceVariableNames: 'accessorsRefactoring'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AbstractInstanceVariableRefactoring guid: (Core.GUID fromString: '{0d72d85d-4099-47a8-8916-be81b11662df}')!
Refactory.Browser.AbstractInstanceVariableRefactoring comment: ''!
!Refactory.Browser.AbstractInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AbstractInstanceVariableRefactoring methodsFor!

abstractReferences
	| replacer |
	replacer := ParseTreeRewriter
				replaceInstanceVariable: variableName
				withGetter: accessorsRefactoring getterMethod
				andSetter: accessorsRefactoring setterMethod
				forReceiver: 'self'.
	class withAllSubclasses do: 
			[:aClass |
			((aClass whichSelectorsReferToInstanceVariable: variableName) reject: 
					[:each |
					aClass == class
						and: [each == accessorsRefactoring getterMethod or: [each == accessorsRefactoring setterMethod]]])
				do: [:selector | self convertMethod: (aClass methodFor: selector) using: replacer]]!

createAccessors
	accessorsRefactoring := CreateAccessorsForVariableRefactoring
				model: self model
				variable: variableName
				class: class
				classVariable: false.
	self performComponentRefactoring: accessorsRefactoring!

preconditions
	^RBCondition directlyDefinesInstanceVariable: variableName in: class!

transform
	self
		createAccessors;
		abstractReferences! !
!Refactory.Browser.AbstractInstanceVariableRefactoring categoriesForMethods!
abstractReferences!public!transforming! !
createAccessors!public!transforming! !
preconditions!preconditions!public! !
transform!public!transforming! !
!

