"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #PropertyManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PropertyManagerTest guid: (GUID fromString: '{fb569e34-0ebf-4ccd-abc2-4739486156f3}')!

PropertyManagerTest comment: ''!

!PropertyManagerTest categoriesForClass!Unclassified! !

!PropertyManagerTest methodsFor!

testRegisterIsWeaklyKeyed
	| subject |
	subject := PropertyManager new.
	self assert: subject register hasWeakKeys.
	self deny: subject register hasWeakValues
! !

!PropertyManagerTest categoriesForMethods!
testRegisterIsWeaklyKeyed!public! !
!

