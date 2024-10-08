﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.BehaviorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.BehaviorTest guid: (Core.GUID fromString: '{157f8981-4d21-430b-bbec-c8b53e6a6f56}')!

Core.Tests.BehaviorTest comment: ''!

!Core.Tests.BehaviorTest methodsFor!

testHasAbstractMethods
	| subject |
	subject := BehaviorTestClasses current classWithAbstractMethod1.
	self assert: subject hasAbstractMethods.
	self deny: subject class hasAbstractMethods.
	subject := BehaviorTestClasses current classWithAbstractMethod2.
	self deny: subject hasAbstractMethods.
	self assert: subject class hasAbstractMethods.
	"#577: There was a false positive in Behavior"
	self deny: Behavior hasAbstractMethods.
	self assert: ClassDescription hasAbstractMethods!

testIncludesBehavior
	self assert: (SmallInteger includesBehavior: SmallInteger).
	self assert: (SmallInteger includesBehavior: Integer).
	self assert: (SmallInteger includesBehavior: Number).
	self assert: (SmallInteger includesBehavior: Object).
	self assert: (SmallInteger includesBehavior: nil).
	self deny: (SmallInteger includesBehavior: SmallInteger class).
	self deny: (SmallInteger includesBehavior: Float)!

testInheritsFrom
	self deny: (SmallInteger inheritsFrom: SmallInteger).
	self assert: (SmallInteger inheritsFrom:Integer).
	self assert: (SmallInteger inheritsFrom:Number).
	self assert: (SmallInteger inheritsFrom:Object).
	self assert: (SmallInteger inheritsFrom: nil).
	self deny: (SmallInteger inheritsFrom: SmallInteger class).
	self deny: (SmallInteger inheritsFrom: Float)!

testIsAbstract
	self assert: BehaviorTestClasses current classWithAbstractMethod1 isAbstract.
	self assert: BehaviorTestClasses current classWithAbstractMethod2 isAbstract!

testIsNonInstantiable
	| subject |
	subject := BehaviorTestClasses current classWithAbstractMethod1.
	self deny: subject isNonInstantiable.
	self deny: subject class isNonInstantiable.
	subject isNonInstantiable: true.
	self assert: subject isNonInstantiable.
	self deny: subject class isNonInstantiable.
	subject isNonInstantiable: false.
	self deny: subject isNonInstantiable.
	self deny: subject class isNonInstantiable.
	subject class isNonInstantiable: true.
	self deny: subject isNonInstantiable.
	self assert: subject class isNonInstantiable.
	subject class isNonInstantiable: false.
	self deny: subject isNonInstantiable.
	self deny: subject class isNonInstantiable!

testUnderstoodSelectors
	self assert: Association understoodSelectors equals: Association selectors.
	self assert: (OS.MSGBOXPARAMSW understoodSelectors difference: OS.MSGBOXPARAMSW selectors) asArray
		equals: #(#dwLanguageId:).
	self assertIsNil: (IntrosortAlgorithm class instVarNamed: 'methodDictionary').
	self assert: IntrosortAlgorithm class understoodSelectors isEmpty!

testWhichMethodsOnlySelfSend
	| subject |
	subject := BehaviorTestClasses current classWithAbstractMethod1.
	self
		assert: ((subject whichMethodsOnlySelfSend: #subclassResponsibility) collect: [:each | each selector])
				asArray
		equals: #(#abstractMethod).
	self assert: ((subject whichMethodsOnlySelfSend: #class) collect: [:each | each selector]) asArray
		equals: #(#returnSendSelfSpecial).
	self assert: ((subject whichMethodsOnlySelfSend: #value) collect: [:each | each selector]) asArray
		equals: #(#sendSelfSpecial)!

testWithAllSuperclasses
	self assert: Object withAllSuperclasses asArray equals: { Object }.
	self assert: Object class withAllSuperclasses asArray
		equals: { Object class. Class. ClassDescription. Behavior. Object }.
	self assert: ProtoObject withAllSuperclasses asArray equals: { ProtoObject }.
	self assert: Utf8String withAllSuperclasses asArray
		equals: {
				Utf8String.
				UtfEncodedString.
				String.
				ArrayedCollection.
				SequenceableCollection.
				Collection.
				Object
			}.
	self assert: Utf8String class withAllSuperclasses asArray
		equals: {
				Utf8String class.
				UtfEncodedString class.
				String class.
				ArrayedCollection class.
				SequenceableCollection class.
				Collection class.
				Object class.
				Class.
				ClassDescription.
				Behavior.
				Object
			}! !

!Core.Tests.BehaviorTest categoriesForMethods!
testHasAbstractMethods!public! !
testIncludesBehavior!public! !
testInheritsFrom!public! !
testIsAbstract!public! !
testIsNonInstantiable!public! !
testUnderstoodSelectors!public! !
testWhichMethodsOnlySelfSend!public! !
testWithAllSuperclasses!public! !
!

!Core.Tests.BehaviorTest class methodsFor!

resources
	^{BehaviorTestClasses}! !

!Core.Tests.BehaviorTest class categoriesForMethods!
resources!Accessing!public! !
!

