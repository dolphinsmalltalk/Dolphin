"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RBClassTest'
	instanceVariableNames: 'objectClass newClass messageNodeClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBClassTest guid: (Core.GUID fromString: '{5220987d-f53e-4675-8166-5035964aa131}')!
Refactory.Browser.Tests.RBClassTest comment: ''!
!Refactory.Browser.Tests.RBClassTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBClassTest methodsFor!

setUp
	| st |
	super setUp.
	st := RBNamespace new.
	objectClass := st classNamed: 'Core.Object'.
	messageNodeClass := st classNamed: RBMessageNode fullName.
	st
		defineClass: 'Core.Object subclass: #SomeClassName
	instanceVariableNames: ''instanceVariable1 instanceVariable2''
	classVariableNames: ''ClassVariable1''
	poolDictionaries: ''OpcodePool''
	category: ''Refactory-Testing'''.
	newClass := st classNamed: #SomeClassName!

testDefinesClassVariable
	self deny: (objectClass definesClassVariable: #ClassVariable1).
	self assert: (objectClass definesClassVariable: self objectClassVariable).
	self assert: (newClass definesClassVariable: #ClassVariable1).
	self deny: (messageNodeClass definesClassVariable: #ClassVariable1).
	self 
		assert: (messageNodeClass definesClassVariable: self objectClassVariable)!

testDefinesInstanceVariable
	self deny: (objectClass definesInstanceVariable: 'instanceVariable1').
	self assert: (newClass definesInstanceVariable: 'instanceVariable1').
	self deny: (messageNodeClass definesInstanceVariable: 'instanceVariable1').
	self assert: (messageNodeClass definesInstanceVariable: 'parent').
	self assert: (messageNodeClass definesInstanceVariable: 'selector')!

testDefinesMethod
	self assert: (objectClass definesMethod: #printString).
	self assert: (newClass definesMethod: #printString).
	self assert: (messageNodeClass definesMethod: #printString)!

testDefinesPoolDictionary
	self deny: (objectClass importsNamespace: #OpcodePool).
	self assert: (newClass importsNamespace: #OpcodePool).
	self deny: (messageNodeClass importsNamespace: #'OS.Win32Constants').
	self
		assert: ((RBNamespace new classNamed: #'OS.HRESULTError') importsNamespace: #'OS.FacilityCodes')!

testHierarchy
	| meta |
	meta := objectClass metaclass.
	self assert: (objectClass withAllSubclasses includes: meta).
	self assert: (meta withAllSuperclasses includes: objectClass)! !
!Refactory.Browser.Tests.RBClassTest categoriesFor: #setUp!public!set up! !
!Refactory.Browser.Tests.RBClassTest categoriesFor: #testDefinesClassVariable!method tests!public! !
!Refactory.Browser.Tests.RBClassTest categoriesFor: #testDefinesInstanceVariable!method tests!public! !
!Refactory.Browser.Tests.RBClassTest categoriesFor: #testDefinesMethod!method tests!public! !
!Refactory.Browser.Tests.RBClassTest categoriesFor: #testDefinesPoolDictionary!method tests!public! !
!Refactory.Browser.Tests.RBClassTest categoriesFor: #testHierarchy!method tests!public! !

