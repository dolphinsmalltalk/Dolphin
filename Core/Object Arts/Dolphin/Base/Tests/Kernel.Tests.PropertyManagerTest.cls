"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.PropertyManagerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.PropertyManagerTest guid: (Core.GUID fromString: '{fb569e34-0ebf-4ccd-abc2-4739486156f3}')!
Kernel.Tests.PropertyManagerTest comment: ''!
!Kernel.Tests.PropertyManagerTest categoriesForClass!Unclassified! !
!Kernel.Tests.PropertyManagerTest methodsFor!

testRegisterIsWeaklyKeyed
	| subject |
	subject := PropertyManager new.
	self assert: subject register hasWeakKeys.
	self deny: subject register hasWeakValues! !
!Kernel.Tests.PropertyManagerTest categoriesFor: #testRegisterIsWeaklyKeyed!public! !

