"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTestClassResource
	subclass: #'Kernel.Tests.CompilerTestClasses'
	instanceVariableNames: 'testClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CompilerTestClasses guid: (Core.GUID fromString: '{23db72f8-4a90-4244-adbc-ea3e9c776d0a}')!
Kernel.Tests.CompilerTestClasses comment: ''!
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
				imports: #()
				classVars: ''!

tearDown
	super tearDown.
	testClass := nil!

testClass
	^testClass! !
!Kernel.Tests.CompilerTestClasses categoriesForMethods!
compileMethods!private!Running! !
createClasses!private!Running! !
tearDown!public!Running! !
testClass!public!Running! !
!

