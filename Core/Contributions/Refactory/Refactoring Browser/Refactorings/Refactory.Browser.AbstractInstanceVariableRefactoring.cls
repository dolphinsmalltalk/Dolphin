"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.VariableRefactoring subclass: #'Refactory.Browser.AbstractInstanceVariableRefactoring'
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
				variable: variableName
				getter: self accessorsRefactoring getterMethod
				setter: self accessorsRefactoring setterMethod.
	self
		convertClasses: class withAllSubclasses
		select: 
			[:aClass |
			(aClass whichSelectorsReferToInstanceVariable: variableName) reject: 
					[:each |
					aClass == class and: 
							[each == self accessorsRefactoring getterMethod or: [each == self accessorsRefactoring setterMethod]]]]
		using: replacer!

accessorsRefactoring
	^accessorsRefactoring isNil
		ifTrue: 
			[accessorsRefactoring := CreateAccessorsForVariableRefactoring
						model: self model
						variable: variableName
						class: class
						classVariable: false]
		ifFalse: [accessorsRefactoring]!

createAccessors
	self performComponentRefactoring: self accessorsRefactoring!

preconditions
	^RBCondition directlyDefinesInstanceVariable: variableName in: class!

transform
	self createAccessors.
	self abstractReferences! !
!Refactory.Browser.AbstractInstanceVariableRefactoring categoriesFor: #abstractReferences!public!transforming! !
!Refactory.Browser.AbstractInstanceVariableRefactoring categoriesFor: #accessorsRefactoring!accessing!private! !
!Refactory.Browser.AbstractInstanceVariableRefactoring categoriesFor: #createAccessors!public!transforming! !
!Refactory.Browser.AbstractInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.AbstractInstanceVariableRefactoring categoriesFor: #transform!public!transforming! !

