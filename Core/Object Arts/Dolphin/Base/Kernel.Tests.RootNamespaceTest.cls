"Filed out from Dolphin Smalltalk 7"!

Kernel.Tests.SystemNamespaceTest subclass: #'Kernel.Tests.RootNamespaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.RootNamespaceTest guid: (Core.GUID fromString: '{d86d3cf1-c931-498c-b32a-89afd6f71306}')!
Kernel.Tests.RootNamespaceTest comment: ''!
!Kernel.Tests.RootNamespaceTest categoriesForClass!Unclassified! !
!Kernel.Tests.RootNamespaceTest methodsFor!

subject
	^Root!

testAbsoluteName
	self assert: self subject absoluteName equals: 'Root'!

testAbsoluteNameOfIdentifier
	self assert: (self subject absoluteNameFor: #Wibble) equals: 'Root.Wibble'!

testAbsoluteReference
	self assert: self subject absoluteReference equals: 'Root' asQualifiedReference!

testAllClasses
	self assert: (Root allClasses difference: Smalltalk allClasses asSet) equals: #()!

testAllEnvironments
	self assert: self subject allEnvironments equals: {}!

testEnvironment
	self assertIsNil: self subject environment!

testIncludesKey
	#(#Root #Smalltalk) do: [:each | self assert: (self subject includesKey: each)].
	self deny: (self subject includesKey: Object name)! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #subject!constants!private! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #testAbsoluteName!public!unit tests! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #testAbsoluteNameOfIdentifier!public!unit tests! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #testAbsoluteReference!public!unit tests! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #testAllClasses!public!unit tests! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #testAllEnvironments!public!unit tests! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #testEnvironment!public!unit tests! !
!Kernel.Tests.RootNamespaceTest categoriesFor: #testIncludesKey!public!unit tests! !

