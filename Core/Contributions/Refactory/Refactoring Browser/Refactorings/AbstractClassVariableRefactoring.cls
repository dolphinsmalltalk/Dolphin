"Filed out from Dolphin Smalltalk 2000 release 5.00"!

VariableRefactoring subclass: #AbstractClassVariableRefactoring
	instanceVariableNames: 'accessorsRefactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractClassVariableRefactoring guid: (GUID fromString: '{4F0F7EBC-00AB-4A37-8AA9-F879D6B34C5A}')!
AbstractClassVariableRefactoring comment: ''!
!AbstractClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!AbstractClassVariableRefactoring methodsFor!

abstractClassReferences
	| replacer |
	replacer := ParseTreeRewriter 
				variable: variableName
				getter: self accessorsRefactoring getterMethod
				setter: self accessorsRefactoring setterMethod.
	self 
		convertClasses: class metaclass withAllSubclasses
		select: 
			[:aClass | 
			(aClass whichSelectorsReferToClassVariable: variableName) reject: 
					[:each | 
					aClass == class metaclass and: 
							[each == self accessorsRefactoring getterMethod 
								or: [each == self accessorsRefactoring setterMethod]]]]
		using: replacer!

abstractInstanceReferences
	| replacer |
	replacer := ParseTreeRewriter 
				classVariable: variableName
				getter: self accessorsRefactoring getterMethod
				setter: self accessorsRefactoring setterMethod.
	self 
		convertClasses: class withAllSubclasses
		select: [:aClass | aClass whichSelectorsReferToClassVariable: variableName]
		using: replacer!

accessorsRefactoring
	^accessorsRefactoring isNil 
		ifTrue: 
			[accessorsRefactoring := CreateAccessorsForVariableRefactoring 
						model: self model
						variable: variableName asString
						class: class
						classVariable: true]
		ifFalse: [accessorsRefactoring]!

createAccessors
	self performComponentRefactoring: self accessorsRefactoring!

preconditions
	^(RBCondition isMetaclass: class) not 
		& (RBCondition directlyDefinesClassVariable: variableName asSymbol in: class) 
			& ((RBCondition withBlock: 
						[(#(#Object #Behavior #ClassDescription #Class) includes: class name) not]) 
					errorMacro: 'This refactoring does not work for Object, Behavior, ClassDescription, or Class')!

transform
	self createAccessors.
	self abstractInstanceReferences.
	self abstractClassReferences! !
!AbstractClassVariableRefactoring categoriesFor: #abstractClassReferences!public!transforming! !
!AbstractClassVariableRefactoring categoriesFor: #abstractInstanceReferences!public!transforming! !
!AbstractClassVariableRefactoring categoriesFor: #accessorsRefactoring!private/accessing!public! !
!AbstractClassVariableRefactoring categoriesFor: #createAccessors!public!transforming! !
!AbstractClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!AbstractClassVariableRefactoring categoriesFor: #transform!public!transforming! !

