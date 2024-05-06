"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #AbstractClassVariableRefactoring
	instanceVariableNames: 'accessorsRefactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractClassVariableRefactoring guid: (GUID fromString: '{4f0f7ebc-00ab-4a37-8aa9-f879d6b34c5a}')!

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

!AbstractClassVariableRefactoring categoriesForMethods!
abstractClassReferences!public!transforming! !
abstractInstanceReferences!public!transforming! !
accessorsRefactoring!accessing!private! !
createAccessors!public!transforming! !
preconditions!preconditions!public! !
transform!public!transforming! !
!

