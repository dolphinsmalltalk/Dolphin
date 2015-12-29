"Filed out from Dolphin Smalltalk 2000 release 5.00"!

VariableRefactoring subclass: #AbstractInstanceVariableRefactoring
	instanceVariableNames: 'accessorsRefactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractInstanceVariableRefactoring guid: (GUID fromString: '{0D72D85D-4099-47A8-8916-BE81B11662DF}')!
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
!AbstractInstanceVariableRefactoring categoriesFor: #accessorsRefactoring!private/accessing!public! !
!AbstractInstanceVariableRefactoring categoriesFor: #createAccessors!public!transforming! !
!AbstractInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!AbstractInstanceVariableRefactoring categoriesFor: #transform!public!transforming! !

