"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTestClassResource subclass: #'Kernel.Tests.CompilerTestClasses'
	instanceVariableNames: 'testClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CompilerTestClasses guid: (Core.GUID fromString: '{23db72f8-4a90-4244-adbc-ea3e9c776d0a}')!
Kernel.Tests.CompilerTestClasses comment: ''!
!Kernel.Tests.CompilerTestClasses categoriesForClass!Unclassified! !
!Kernel.Tests.CompilerTestClasses methodsFor!

compileMethods
	self compileAccessorsFor: testClass!

createClasses
	| ivs |
	ivs := String writeStream.
	1 to: 33
		do: 
			[:i |
			ivs
				nextPutAll: 'iv';
				print: i;
				space].
	testClass := self
				createClass: #CompilerTestClass
				superclass: Object
				instVars: ivs contents
				pools: ''
				classVars: ''!

tearDown
	super tearDown.
	testClass := nil!

testClass
	^testClass! !
!Kernel.Tests.CompilerTestClasses categoriesFor: #compileMethods!private!Running! !
!Kernel.Tests.CompilerTestClasses categoriesFor: #createClasses!private!Running! !
!Kernel.Tests.CompilerTestClasses categoriesFor: #tearDown!public!Running! !
!Kernel.Tests.CompilerTestClasses categoriesFor: #testClass!public!Running! !

