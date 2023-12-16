"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.CompiledMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CompiledMethodTest guid: (Core.GUID fromString: '{32df31e4-99ba-44fb-aaac-99e5dfe82c94}')!
Kernel.Tests.CompiledMethodTest comment: ''!
!Kernel.Tests.CompiledMethodTest categoriesForClass!Tests-Kernel-Methods! !
!Kernel.Tests.CompiledMethodTest methodsFor!

annotationReferenceTwo
	<rename: #foo two: #bar>
	^#(#dolphin) single basicClass!

returnPlusOne: anInteger
	^anInteger + 1.!

returnTrue
	^true!

testAllSymbolLiterals
	self assert: (self class >> #annotationReferenceTwo) allSymbolLiterals asSortedArray
		equals: #(#bar #basicClass #dolphin #foo #rename:two: #single)!

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

testMessages
	"Messages sent in a primitive, including those with special byte codes - note that #ifTrue: and whileFalse: are not detected. These are in the literal frame; recognising the bytecode patterns would be expensive, but they could be detected from the frame as special cases since we know they are messages."

	self assert: (Object >> #basicIdentityIndexOf:from:to:) messages asSortedArray
		equals: #(#+ #< #== #basicAt:).
	"Special inst var return method - no messages"
	self assert: (Association >> #setKey:) messages asArray equals: #().
	"Null coalescence operator #??"
	self assert: (Behavior >> #methodDictionary) messages asArray equals: #(#??).
	"Not identical #~~"
	self assert: (Boolean >> #xor:) messages asArray equals: #(#~~).
	"#not"
	self assert: (true class >> #xor:) messages asArray equals: #(#not).
	"#+ encoded in an incrementStackTop instruction"
	self assert: (SequenceableCollection >> #allButFirst:) messages asSortedArray
		equals: #(#+ #copyFrom:to: #size).
	"#- encoded in a decrementStackTop instruction"
	self assert: ((SequenceableCollection >> #before:ifAbsent:) messages includes: #-).
	"#+ encoded in an Increment and push temp instruction"
	self assert: ((ArrayedCollection >> #do:) messages includes: #+).
	"#- encoded in an Decrement and push temp instruction"
	self assert: (SequenceableCollection >> #findLast:) messages asSortedArray
		equals: #(#- #> #at: #size #value:).
	"#- encoded in a decrement temp instruction"
	self assert: ((LargeInteger >> #digitLength) messages includes: #-).
	"#+ encoded in an increment temp instruction"
	self assert: ((LinkedList >> #at:) messages includes: #+).
	"Push send self instructions"
	self assert: ((SessionManager >> #serverShutdown) messages includes: #isHeadless).
	"Push temp and send instructions"
	self assert: ((BlockFrame >> #block) messages includes: #block).
	"Supersend"
	self assert: ((Bag >> #postCopy) messages includes: #postCopy).
	"Long send"
	self assert: ((Compiler class >> #notificationCallback:) messages
				includes: #code:in:for:selector:position:line:range:extras:).
	"isZero (i.e. == 0)"
	self assert: (Collection >> #isEmpty) messages asSortedArray equals: #(#== #size)!

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

testReferenceToOwnClassVar
	"Even a class' references to its own class variables are implicitly a reference to itself. This is required in order that tooling is able to find all references when needed, for example for the Rename Class refactoring, which will need to see references to a class via its own class variables in case those variable references are for some reason fully or partially qualified and so need to be renamed."

	| subject |
	subject := Object >> #getEvents.
	self assert: (subject refersToLiteral: Object)!

testRefersToClassViaClassVar
	| subject |
	subject := EventMessageSequence >> #value.
	self assert: (subject refersToLiteral: DeadObject)!

testValueWithReceiverArguments
	| method value |
	method := self class compiledMethodAt: #returnTrue.
	self should: [method value: nil withArguments: #()] raise: Error.
	value := method value: self withArguments: #().
	self assert: value equals: true.
	method := self class compiledMethodAt: #returnPlusOne:.
	value := method value: self withArguments: #(1).
	self assert: value equals: 2! !
!Kernel.Tests.CompiledMethodTest categoriesForMethods!
annotationReferenceTwo!examples!private! !
returnPlusOne:!examples!private! !
returnTrue!examples!private! !
testAllSymbolLiterals!public!unit tests! !
testHasAnnotation!public!unit tests! !
testIsQuick!public!unit tests! !
testIsSimpleSelfSend!public!unit tests! !
testLocalEnvironment!public!unit tests! !
testLocalScope!public!unit tests! !
testMessages!public!unit tests! !
testRecompileMaintainsEnvironmentAndPackage!public!unit tests! !
testReferenceToOwnClassVar!public! !
testRefersToClassViaClassVar!public! !
testValueWithReceiverArguments!public!unit tests! !
!

