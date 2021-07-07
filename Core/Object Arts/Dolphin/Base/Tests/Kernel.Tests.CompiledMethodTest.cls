"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.CompiledMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CompiledMethodTest guid: (Core.GUID fromString: '{32df31e4-99ba-44fb-aaac-99e5dfe82c94}')!
Kernel.Tests.CompiledMethodTest comment: ''!
!Kernel.Tests.CompiledMethodTest categoriesForClass!Tests-Kernel-Methods! !
!Kernel.Tests.CompiledMethodTest methodsFor!

returnPlusOne: anInteger
	^anInteger + 1.!

returnTrue
	^true!

testHasAnnotation
	self assert: (SortedCollection>>#algorithm hasAnnotation: #nonBrowsable).
	self assert: (Association>>#setKey: hasAnnotation: #mutable).
	self deny: (Association>>#key: hasAnnotation: #mutable).!

testIsQuick
	| method |
	method := self class compiledMethodAt: #returnTrue.
	self assert: method extraIndex equals: 2.
	method := self class compiledMethodAt: #returnPlusOne:.
	self deny: method extraIndex equals: 5!

testIsSimpleSelfSend
	"CompiledCode>>isSimpleSelfSend: is used for finding methods of two basic forms: `^self message`, and `self message`. ClassDescription>>comment is an example of the former, and ClassDescription>>comment: the latter."

	| subject |
	#(#comment #comment:)
		do: [:each | self assert: (ClassDescription >> each isSimpleSelfSend: #subclassResponsibility)].
	"CompiledCode>>isAbstract refers to #subclassResponsibility, but is not a simple sender of it."
	subject := CompiledCode >> #isAbstract.
	self assert: (subject refersToLiteral: #subclassResponsibility).
	self deny: (subject isSimpleSelfSend: #subclassResponsibility).
	"Simple sends of something else."
	subject := ArrayedCollection >> #add:.
	self assert: (subject isSimpleSelfSend: #shouldNotImplement).
	self deny: (subject isSimpleSelfSend: #subclassResponsibility).
	"A few methods with no literals at all, with and without packed bytecodes"
	{Association >> #key. Association >> #key:. Association >> #key:value:}
		do: [:each | self deny: (each isSimpleSelfSend: #subclassResponsibility)]!

testLocalEnvironment
	self assert: (Object >> #=) localEnvironment identicalTo: Core.
	"An example of a method that has a namespace different to that of its method class"
	self
		assert: (OS.KernelLibrary
				>> #createProcess:lpCommandLine:lpProcessAttributes:lpThreadAttributes:bInheritsHandles:dwCreationFlags:lpEnvironment:lpCurrentDirectory:lpStartupInfo:lpProcessInformation:)
					localEnvironment
		identicalTo: Smalltalk!

testLocalScope
	self assert: (Object>>#=) localScope equals: Object.
	self assert: Object class methodDictionary anyOne localScope equals: Object!

testRecompileMaintainsEnvironmentAndPackage
	"Verify that a recompiled method's environment is maintained if different from it's method class', and likewise the owning package"

	| subject package |
	subject := OS.KernelLibrary
				>> #createProcess:lpCommandLine:lpProcessAttributes:lpThreadAttributes:bInheritsHandles:dwCreationFlags:lpEnvironment:lpCurrentDirectory:lpStartupInfo:lpProcessInformation:.
	"This test will break if the test method's package is updated, so perform a sanity check."
	self assert: subject environment identicalTo: Smalltalk.
	package := subject owningPackage.
	self assert: package ~~ OS.KernelLibrary owningPackage.
	
	[| newMethod compilationResult |
	compilationResult := subject recompile.
	newMethod := compilationResult method.
	self assertNotNil: newMethod.
	self assert: newMethod ~~ subject.
	self assert: newMethod environment identicalTo: Smalltalk.
	self assert: newMethod owningPackage identicalTo: package]
			ensure: 
				[OS.KernelLibrary methodDictionary at: subject selector put: subject.
				OS.KernelLibrary flushMethodCache]!

testValueWithReceiverArguments
	| method value |
	method := self class compiledMethodAt: #returnTrue.
	self should: [method value: nil withArguments: #()] raise: Error.
	value := method value: self withArguments: #().
	self assert: value equals: true.
	method := self class compiledMethodAt: #returnPlusOne:.
	value := method value: self withArguments: #(1).
	self assert: value equals: 2! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #returnPlusOne:!examples!private! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #returnTrue!examples!private! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #testHasAnnotation!public!unit tests! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #testIsQuick!public!unit tests! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #testIsSimpleSelfSend!public!unit tests! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #testLocalEnvironment!public!unit tests! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #testLocalScope!public!unit tests! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #testRecompileMaintainsEnvironmentAndPackage!public!unit tests! !
!Kernel.Tests.CompiledMethodTest categoriesFor: #testValueWithReceiverArguments!public!unit tests! !

