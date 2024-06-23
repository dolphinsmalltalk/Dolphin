"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RBConditionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.RBConditionTest guid: (Core.GUID fromString: '{d7c6868f-bf84-4580-b4c0-20abbdcdb10e}')!

Refactory.Browser.Tests.RBConditionTest comment: ''!

!Refactory.Browser.Tests.RBConditionTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.RBConditionTest methodsFor!

testConditions
	| condition newCondition |
	condition := RBCondition new
				type: #false
				block: [false]
				errorString: 'false'.
	condition errorMacro: '<1?true:false>'.
	self deny: condition check.
	self assert: condition errorString equals: 'false'.
	self assert: condition not check.
	self assert: condition printString equals: '#false'.
	self assert: condition not printString equals: 'NOT #false'.
	self deny: (condition not & condition) check.
	self assert: (condition not & condition) printString equals: 'NOT #false & #false'.
	self assert: (condition & condition) not check.
	self assert: (condition | condition not) check.
	self deny: (newCondition := condition | condition) check.
	self assert: newCondition errorString equals: 'false AND false'.
	self assert: (condition not | condition not) check.
	self deny: (newCondition := condition & condition) check.
	self assert: newCondition errorString equals: 'false'.
	self assert: (condition not & condition not) check.
	self assert: (condition & condition) errorString equals: 'false OR false'!

testIsEmptyClass
	| subject foo foobar |
	model := self abstractVariableTestData.
	foo := model classNamed: #Foo.
	subject := RBCondition isEmptyClass: foo.
	self deny: subject check.
	self assert: (subject errorStringFor: false)
		equals: 'Foo is not empty (has class/shared variables, instance variables, and methods)'.
	foo instanceVariableNames: #().
	self deny: subject check.
	self assert: (subject errorStringFor: false)
		equals: 'Foo is not empty (has class/shared variables, and methods)'.
	foo instanceVariableNames: #('foo1').
	foo classVariableNames: #().
	self deny: subject check.
	self assert: (subject errorStringFor: false)
		equals: 'Foo is not empty (has instance variables, and methods)'.
	subject := RBCondition isEmptyClass: (model classNamed: #Bar).
	self deny: subject check.
	self assert: subject errorString equals: 'Bar is not empty (has methods)'.
	model
		defineClass: 'Foo subclass: #FooBar
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''Testing'''.
	foobar := model classNamed: #FooBar.
	subject := RBCondition isEmptyClass: foobar.
	self assert: subject check.
	self assert: (subject errorStringFor: true) equals: 'FooBar is empty (has no variables or methods)'.
	foobar instanceVariableNames: #('foobar1').
	self deny: subject check.
	self assert: subject errorString equals: 'FooBar is not empty (has instance variables)'.
	foobar classVariableNames: #('FooBar1').
	self deny: subject check.
	self assert: (subject errorStringFor: false)
		equals: 'FooBar is not empty (has class/shared variables, and instance variables)'.
	foobar instanceVariableNames: #().
	self deny: subject check.
	self assert: subject errorString equals: 'FooBar is not empty (has class/shared variables)'!

testIsGlobalIn
	| subject |
	model := RBModel new.
	subject := RBCondition isStatic: 'Graphics.Gdiplus.Bitmap' in: model.
	self assert: subject check description: subject errorString.
	model removeClassNamed: 'Graphics.Gdiplus.Bitmap'.
	self deny: subject check description: (subject errorStringFor: true).
	subject := RBCondition isStatic: 'Graphics.Bitmap' in: model.
	self assert: subject check description: subject errorString.
	"UI.Bitmap is bindable, but as an import so there is no actual UI.Bitmap 'global'"
	subject := RBCondition isStatic: 'UI.Bitmap' in: model.
	self deny: subject check description: (subject errorStringFor: true)!

testIsSubclassable
	| subject result |
	subject := RBCondition isSubclassable: Character.
	result := subject validate.
	self deny: result value.
	self assert: result hint messageText equals: ClassBuilder.ErrorUnsubclassable << Character.
	subject := RBCondition isSubclassable: Object.
	self assert: subject check.
	self assert: (subject errorStringFor: true) equals: 'Object is subclassable.'! !

!Refactory.Browser.Tests.RBConditionTest categoriesForMethods!
testConditions!public!tests! !
testIsEmptyClass!public!tests! !
testIsGlobalIn!public!tests! !
testIsSubclassable!public!tests! !
!

