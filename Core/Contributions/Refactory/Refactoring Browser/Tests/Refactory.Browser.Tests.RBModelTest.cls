"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RBModelTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBModelTest guid: (Core.GUID fromString: '{6f34d39e-50df-446a-b75c-b8d21fc030e1}')!
Refactory.Browser.Tests.RBModelTest comment: ''!
!Refactory.Browser.Tests.RBModelTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBModelTest methodsFor!

testMetaclassNamed
	| model metaclass |
	model := RBModel new.
	metaclass := model metaclassNamed: 'Core.Symbol'.
	self assert: metaclass realClass identicalTo: Symbol class.
	self assert: (model metaclassNamed: 'Core.Symbol') identicalTo: metaclass
	! !
!Refactory.Browser.Tests.RBModelTest categoriesForMethods!
testMetaclassNamed!public! !
!

