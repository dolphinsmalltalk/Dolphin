"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.AbstractClassVariableRefactoring'
	instanceVariableNames: 'accessorsRefactoring variableBinding'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.AbstractClassVariableRefactoring guid: (Core.GUID fromString: '{4f0f7ebc-00ab-4a37-8aa9-f879d6b34c5a}')!

Refactory.Browser.AbstractClassVariableRefactoring comment: ''!

!Refactory.Browser.AbstractClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.AbstractClassVariableRefactoring methodsFor!

abstractClassReferences
	| replacer getterMethod setterMethod |
	replacer := ParseTreeRewriter
				replaceClassVariable: variableBinding
				withGetter: accessorsRefactoring getterMethod
				andSetter: accessorsRefactoring setterMethod
				forReceiver: 'self'.
	getterMethod := class metaclass methodFor: accessorsRefactoring getterMethod.
	setterMethod := accessorsRefactoring setterMethod ifNotNil: [:selector | class metaclass methodFor: selector].
	class metaclass withAllSubclasses do: 
			[:aClass |
			((aClass whichMethodsReferToBinding: variableBinding) reject: [:each | each == getterMethod or: [each == setterMethod]])
				do: 
					[:method |
					method boundParseTree.
					self convertMethod: method using: replacer]]!

abstractExternalReferences
	| replacer |
	replacer := ParseTreeRewriter
				replaceClassVariable: variableBinding
				withGetter: accessorsRefactoring getterMethod
				andSetter: accessorsRefactoring setterMethod
				forReceiver: class fullName.
	model allBehaviorsDo: 
			[:behavior |
			(behavior instanceClass includesBehavior: class instanceClass)
				ifFalse: 
					[(behavior whichMethodsReferToBinding: variableBinding) do: 
							[:method |
							method boundParseTree.
							self convertMethod: method using: replacer]]]!

abstractInstanceReferences
	| replacer |
	replacer := ParseTreeRewriter
				replaceClassVariable: variableBinding
				withGetter: accessorsRefactoring getterMethod
				andSetter: accessorsRefactoring setterMethod
				forReceiver: 'self class'.
	class withAllSubclasses do: 
			[:aClass |
			(aClass whichMethodsReferToBinding: variableBinding) do: 
					[:method |
					method boundParseTree.
					self convertMethod: method using: replacer]]!

createAccessors
	accessorsRefactoring := CreateAccessorsForVariableRefactoring
				model: model
				variable: variableName asString
				class: class
				classVariable: true.
	self performComponentRefactoring: accessorsRefactoring!

preconditions
	^(RBCondition isMetaclass: class) not
		& (RBCondition directlyDefinesClassVariable: variableName in: class)
			& ((RBCondition withBlock: 
						[(#(#'Core.Object' #'Core.Behavior' #'Core.ClassDescription' #'Core.Class') includes: class name)
							not])
					errorMacro: 'This refactoring does not work for Object, Behavior, ClassDescription, or Class')!

transform
	variableBinding := class bindingFor: variableName.
	self
		createAccessors;
		abstractInstanceReferences;
		abstractClassReferences;
		abstractExternalReferences! !

!Refactory.Browser.AbstractClassVariableRefactoring categoriesForMethods!
abstractClassReferences!private!transforming! !
abstractExternalReferences!private!transforming! !
abstractInstanceReferences!private!transforming! !
createAccessors!private!transforming! !
preconditions!preconditions!public! !
transform!public!transforming! !
!

