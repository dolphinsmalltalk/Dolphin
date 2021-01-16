"Filed out from Dolphin Smalltalk 7"!

Kernel.Tests.SystemNamespaceTest subclass: #'Kernel.Tests.SmalltalkNamespaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.SmalltalkNamespaceTest guid: (Core.GUID fromString: '{2aa58b1b-4203-4bcd-bd4b-b7497c69d4df}')!
Kernel.Tests.SmalltalkNamespaceTest comment: ''!
!Kernel.Tests.SmalltalkNamespaceTest categoriesForClass!Unclassified! !
!Kernel.Tests.SmalltalkNamespaceTest methodsFor!

subject
	^Smalltalk!

testAbsoluteName
	self assert: self subject absoluteName equals: 'Root.Smalltalk'!

testAbsoluteNameOfIdentifier
	self assert: (self subject absoluteNameFor: #Wibble) equals: 'Root.Smalltalk.Wibble'!

testAbsoluteReference
	self assert: self subject absoluteReference equals: 'Root.Smalltalk' asQualifiedReference!

testAllClasses
	self assert: (Smalltalk allClasses difference: Class allClasses asSet) equals: #()!

testAllEnvironments
	self assert: self subject allEnvironments equals: {Root}!

testEnvironment
	self assert: self subject environment equals: Root!

testIncludesKey
	"At the moment all classes are still in the system namespace."

	"Smalltalk no longer includes a variable for itself - this is held in the Root namespace and will be find by normal binding resolution"

	#(#Root #Smalltalk) do: [:each | self deny: (self subject includesKey: each)].
	#('ExternalHandle') do: [:each | self assert: (self subject includesKey: each)].
	self deny: (self subject includesKey: GUID newUnique asString)!

testWellFormed
	Smalltalk associationsDo: 
			[:each |
			self assert: each isKindOf: VariableBinding.
			self assert: each environment identicalTo: Smalltalk.
			self deny: each isClassVariable]! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #subject!constants!private! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testAbsoluteName!public!unit tests! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testAbsoluteNameOfIdentifier!public!unit tests! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testAbsoluteReference!public!unit tests! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testAllClasses!public!unit tests! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testAllEnvironments!public!unit tests! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testEnvironment!public!unit tests! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testIncludesKey!public!unit tests! !
!Kernel.Tests.SmalltalkNamespaceTest categoriesFor: #testWellFormed!public!unit tests! !

