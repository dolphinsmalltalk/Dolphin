"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RBClassTest'
	instanceVariableNames: 'model objectClass newClass messageNodeClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBClassTest guid: (Core.GUID fromString: '{5220987d-f53e-4675-8166-5035964aa131}')!
Refactory.Browser.Tests.RBClassTest comment: ''!
!Refactory.Browser.Tests.RBClassTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBClassTest methodsFor!

setUp
	super setUp.
	model := RBNamespace new.
	objectClass := model classNamed: 'Core.Object'.
	messageNodeClass := model classNamed: RBMessageNode fullName.
	model
		defineClass: 'Core.Object subclass: #SomeClassName
	instanceVariableNames: ''instanceVariable1 instanceVariable2''
	classVariableNames: ''ClassVariable1''
	poolDictionaries: ''OpcodePool''
	category: ''Refactory-Testing'''.
	newClass := model classNamed: #SomeClassName!

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

testEnvironment
	| rbTests myClass refactory root |
	myClass := model classFor: self class.
	rbTests := model classFor: self class environment.
	self assert: myClass environment equals: rbTests.
	refactory := model classNamed: #Refactory.
	root := model classNamed: #Root.
	self assert: rbTests environment environment equals: refactory.
	self assert: refactory environment equals: root.
	self assertIsNil: root environment.
	self assert: newClass environment equals: (model classNamed: #Smalltalk)!

testFullName
	self assert: objectClass fullName equals: 'Core.Object'.
	self assert: objectClass metaclass fullName equals: 'Core.Object class'.
	self assert: (model classFor: self class) fullName equals: self class fullName.
	self assert: newClass fullName equals: 'SomeClassName'.
	self assert: objectClass environment environment fullName equals: 'Root'!

testHierarchy
	| meta |
	meta := objectClass metaclass.
	self assert: (objectClass withAllSubclasses includes: meta).
	self assert: (meta withAllSuperclasses includes: objectClass)!

testName
	self assert: objectClass name equals: 'Core.Object'.
	self assert: (model classFor: self class) name equals: self class fullName!

testSuperclass
	self assert: newClass superclass equals: objectClass.
	self assert: newClass metaclass superclass equals: objectClass metaclass.
	self assertIsNil: objectClass superclass.
	self assert: objectClass metaclass superclass equals: (model classFor: Class)!

testUnqualifiedName
	self assert: objectClass unqualifiedName equals: #Object.
	self assert: objectClass metaclass unqualifiedName equals: 'Object class'.
	self assert: (model classFor: self class) unqualifiedName equals: self class unqualifiedName! !
!Refactory.Browser.Tests.RBClassTest categoriesForMethods!
setUp!public!set up! !
testDefinesClassVariable!public!unit tests! !
testDefinesInstanceVariable!public!unit tests! !
testDefinesMethod!public!unit tests! !
testDefinesPoolDictionary!public!unit tests! !
testEnvironment!public!unit tests! !
testFullName!public!unit tests! !
testHierarchy!public!unit tests! !
testName!public!unit tests! !
testSuperclass!public! !
testUnqualifiedName!public!unit tests! !
!

