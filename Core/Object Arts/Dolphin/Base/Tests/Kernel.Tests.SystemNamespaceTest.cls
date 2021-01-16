"Filed out from Dolphin Smalltalk 7"!

Kernel.Tests.AbstractNamespaceTest subclass: #'Kernel.Tests.SystemNamespaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.SystemNamespaceTest guid: (Core.GUID fromString: '{5a72a2ef-84cc-4954-a159-3ae6bc041f25}')!
Kernel.Tests.SystemNamespaceTest isNonInstantiable: true!
Kernel.Tests.SystemNamespaceTest comment: ''!
!Kernel.Tests.SystemNamespaceTest categoriesForClass!Unclassified! !
!Kernel.Tests.SystemNamespaceTest methodsFor!

canonicalSubject
	^self subject!

subject
	^self subclassResponsibility!

testAbsoluteName
	self assert: self subject absoluteName equals: 'Root.' , self subject unqualifiedName!

testAbsoluteNameOfIdentifier
	self subclassResponsibility!

testAllEnvironments
	self subclassResponsibility!

testBinding
	self assert: self subject binding identicalTo: (Root localBindingFor: self subject name)!

testBindingOrNil
	self assert: self subject bindingOrNil identicalTo: (Root localBindingFor: self subject name)!

testEnvironment
	self subclassResponsibility!

testFullName
	self assert: self subject fullName equals: self subject name!

testFullyQualifiedReference
	self assert: self subject fullyQualifiedReference
		equals: self subject name asQualifiedReference!

testIncludesKey
	self subclassResponsibility!

testShortName
	self assert: self subject shortName equals: self subject name! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #canonicalSubject!private! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #subject!constants!private! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testAbsoluteName!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testAbsoluteNameOfIdentifier!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testAllEnvironments!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testBinding!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testBindingOrNil!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testEnvironment!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testFullName!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testFullyQualifiedReference!public!unit tests! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testIncludesKey!public! !
!Kernel.Tests.SystemNamespaceTest categoriesFor: #testShortName!public!unit tests! !

