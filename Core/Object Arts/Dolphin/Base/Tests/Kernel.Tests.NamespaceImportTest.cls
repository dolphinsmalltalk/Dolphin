"Filed out from Dolphin Smalltalk"!

Kernel.Tests.BindingReferenceTest subclass: #'Kernel.Tests.NamespaceImportTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.NamespaceImportTest guid: (Core.GUID fromString: '{bb6feae3-ac2b-4223-82f9-94aa698dd070}')!
Kernel.Tests.NamespaceImportTest comment: ''!
!Kernel.Tests.NamespaceImportTest methodsFor!

bindingTestCases
	| missingNamespace |
	missingNamespace := '_' , GUID newUnique idlString copyReplacing: $- withObject: $_.
	^{#(#(#Object) nil nil).
		#(#(#Core #Object) nil #(#Object)).
		{#(#Smalltalk #Object). nil. nil}.
		#(#(#Kernel #OpcodePool #Nop) nil #(#OpcodePool #Nop)).
		#(#(#Smalltalk #OpcodePool #Nop) nil nil).
		{{missingNamespace. '__MissingClass'}. nil. nil}.
		{{missingNamespace. 'Date'}. nil. nil}.
		#(#(#Core #Object #_EventsRegister) nil #(#Object #_EventsRegister)).
		{#(#Kernel #VMLibrary #Registry #Symbol). nil. nil}.
		#(#(#XProgramming #SUnit #TestCase) nil #(#XProgramming #SUnit #TestCase))}!

pathTestCases
	^{#(#(#Core) nil #(#Core)).
		#(#(#Core #Object) nil #(#Core #Object)).
		{#(#Core #Object #_EventsRegister). nil. #(#Core #Object #_EventsRegister)}.
		#(#(#XProgramming #SUnit #TestCase) nil #(#XProgramming #SUnit #TestCase))}!

printStringTestCases
	^#(#(#(#Core #Object) nil '#{Core.Object}') #(#(#Kernel #OpcodePool #Nop) nil '#{Kernel.OpcodePool.Nop}') #(#('A' 'B' 'C') #{Root} '#{A.B.C}'))!

subjectClass
	^NamespaceImport!

testAsNamespaceImport
	| subject import |
	subject := self newSubjectWithPath: #(#'Core.Object').
	import := subject asNamespaceImport.
	self assert: import identicalTo: subject!

testBindingScope
	| subject |
	subject := self newSubjectWithPath: #(#Core #Object).
	self assert: subject bindingScope identicalTo: Root!

testErrorRelative
	self
		should: [self newSubjectWithPath: #('_' 'Object')]
		raise: Error
		matching: [:ex | ex messageText = NamespaceImport.InvalidImportPath].
	self
		should: [self newSubjectWithPathString: '_.Object']
		raise: Error
		matching: [:ex | ex messageText = NamespaceImport.InvalidImportPath]!

testHome
	| subject |
	subject := self newSubjectWithPath: #(#Kernel 'OpcodePool' 'Nop').
	self assert: subject home identicalTo: Root!

testIsRelative
	| subject |
	subject := self newSubjectWithPath: #(#Core).
	self deny: subject isRelative!

testMissingSmalltalkImport
	| original importBlah |
	original := Smalltalk imports.
	importBlah := #Blah asQualifiedReference asNamespaceImport.
	
	[Smalltalk setImports: (original copyWith: importBlah).
	self assertIsNil: #Foo asQualifiedReference bindingOrNil]
			ensure: [Smalltalk setImports: original]! !
!Kernel.Tests.NamespaceImportTest categoriesForMethods!
bindingTestCases!constants!private! !
pathTestCases!private!unit tests! !
printStringTestCases!constants!private! !
subjectClass!constants!private! !
testAsNamespaceImport!public!unit tests! !
testBindingScope!public!unit tests! !
testErrorRelative!public! !
testHome!public!unit tests! !
testIsRelative!public!unit tests! !
testMissingSmalltalkImport!public!unit tests! !
!

