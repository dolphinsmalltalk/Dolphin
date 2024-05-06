"Filed out from Dolphin Smalltalk"!

RefactoringBrowserTest subclass: #RBClassTest
	instanceVariableNames: 'objectClass newClass messageNodeClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBClassTest guid: (GUID fromString: '{5220987d-f53e-4675-8166-5035964aa131}')!

RBClassTest comment: ''!

!RBClassTest categoriesForClass!Refactory-Testing! !

!RBClassTest methodsFor!

setUp
	| st |
	super setUp.
	st := RBNamespace new.
	objectClass := st classNamed: #Object.
	messageNodeClass := st classNamed: #RBMessageNode.
	st 
		defineClass: 'Object subclass: #SomeClassName
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
	#rbFix.	"Use a different pool for Dolphin (Win32Constants instead of OpcodePool)"
	self deny: (objectClass definesPoolDictionary: #_BehaviorMasks).
	self assert: (newClass definesPoolDictionary: #OpcodePool).
	self deny: (messageNodeClass definesPoolDictionary: #Win32Constants).
	self assert: ((RBNamespace new classNamed: #HRESULTError) definesPoolDictionary: #FacilityCodes)!

testHierarchy
	| meta |
	meta := objectClass metaclass.
	self assert: (objectClass withAllSubclasses includes: meta).
	self assert: (meta withAllSuperclasses includes: objectClass)! !

!RBClassTest categoriesForMethods!
setUp!public!set up! !
testDefinesClassVariable!method tests!public! !
testDefinesInstanceVariable!method tests!public! !
testDefinesMethod!method tests!public! !
testDefinesPoolDictionary!method tests!public! !
testHierarchy!method tests!public! !
!

