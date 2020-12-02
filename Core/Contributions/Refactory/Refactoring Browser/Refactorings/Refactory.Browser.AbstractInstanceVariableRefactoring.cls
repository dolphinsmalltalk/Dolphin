"Filed out from Dolphin Smalltalk 7"!

VariableRefactoring subclass: #AbstractInstanceVariableRefactoring
	instanceVariableNames: 'accessorsRefactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractInstanceVariableRefactoring guid: (GUID fromString: '{0d72d85d-4099-47a8-8916-be81b11662df}')!
AbstractInstanceVariableRefactoring comment: ''!
!AbstractInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!AbstractInstanceVariableRefactoring methodsFor!

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
							[each == self accessorsRefactoring getterMethod 
								or: [each == self accessorsRefactoring setterMethod]]]]
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
!AbstractInstanceVariableRefactoring categoriesFor: #abstractReferences!public!transforming! !
!AbstractInstanceVariableRefactoring categoriesFor: #accessorsRefactoring!accessing!private! !
!AbstractInstanceVariableRefactoring categoriesFor: #createAccessors!public!transforming! !
!AbstractInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!AbstractInstanceVariableRefactoring categoriesFor: #transform!public!transforming! !

