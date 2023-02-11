"Filed out from Dolphin Smalltalk"!

Kernel.Tests.SystemNamespaceTest subclass: #'Kernel.Tests.RootNamespaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.RootNamespaceTest guid: (Core.GUID fromString: '{d86d3cf1-c931-498c-b32a-89afd6f71306}')!
Kernel.Tests.RootNamespaceTest comment: ''!
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
	| expected actual |
	expected := Smalltalk allClasses asSet.
	actual := Root allClasses.
	self assert: actual size equals: expected size - 1.
	actual := actual asSet.
	self assert: (actual symmetricDifference: expected) equals: (Set with: Root)!

testAllEnvironments
	self assert: self subject allEnvironments equals: {}!

testEnvironment
	self assertIsNil: self subject environment!

testIncludesKey
	#(#Root #Smalltalk) do: [:each | self assert: (self subject includesKey: each)].
	self deny: (self subject includesKey: Object name)! !
!Kernel.Tests.RootNamespaceTest categoriesForMethods!
subject!constants!private! !
testAbsoluteName!public!unit tests! !
testAbsoluteNameOfIdentifier!public!unit tests! !
testAbsoluteReference!public!unit tests! !
testAllClasses!public!unit tests! !
testAllEnvironments!public!unit tests! !
testEnvironment!public!unit tests! !
testIncludesKey!public!unit tests! !
!

