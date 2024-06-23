"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.ChunkSourceFilerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.ChunkSourceFilerTest guid: (Core.GUID fromString: '{68c7a37f-c3e0-49cd-912f-b09e383474a3}')!

Kernel.Tests.ChunkSourceFilerTest comment: ''!

!Kernel.Tests.ChunkSourceFilerTest methodsFor!

testPrintDefinitionOfClassInSmalltalk
	"Environment makes no different for classes with superclasses that are not in Smalltalk"

	{nil.  Root. Smalltalk. #{UI} value. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: Smalltalk.ScribbleDocument
				environment: each
				definitionPrefix: 'UI.AbstractDocumentShell
	subclass: #ScribbleDocument']!

testPrintDefinitionOfClassWithSuperclassInSmalltalk
	self
		verifyClass: #{UI.Examples.EtchASketchDocument} value
		environment: nil
		definitionPrefix: 'ScribbleDocument
	subclass: #''UI.Examples.EtchASketchDocument'''.
	"Classes that are namespaced with superclasses in Smalltalk are a special case for the browsers, as the superclass name may not be bindable as an unqualified name from another namespace. Therefore if the compilation environment is not Smalltalk, the full superclass name should be used."
	self
		verifyClass: #{UI.Examples.EtchASketchDocument} value
		environment: #{UI.Examples} value
		definitionPrefix: 'Smalltalk.ScribbleDocument
	subclass: #''UI.Examples.EtchASketchDocument'''!

testPrintDefinitionOfNamespace
	"Namespace should be like any other normal class from a definition printing perspective."

	{nil. Root. Smalltalk. Core. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: Namespace
				environment: each
				definitionPrefix: 'Core.Object
	subclass: #''Kernel.Namespace''']!

testPrintDefinitionOfNestedNamespace
	{nil. Root. Smalltalk. #{UI} value. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: #{UI.Scintilla} value
				environment: each
				definitionPrefix: 'UI
	subclass: #''UI.Scintilla'''].
	{nil. Root. Smalltalk. #{UI} value. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: #{UI.Scintilla.Tests} value
				environment: each
				definitionPrefix: 'UI.Scintilla
	subclass: #''UI.Scintilla.Tests''']!

testPrintDefinitionOfRootClass
	"A subclass of nil"

	{nil. Root. Smalltalk. Core. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: Object
				environment: each
				definitionPrefix: 'nil
	subclass: #''Core.Object''']!

testPrintDefinitionOfRootNamespace
	{nil. Root. Smalltalk. Core. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: Root
				environment: each
				definitionPrefix: 'Kernel.Namespace
	subclass: #Root']!

testPrintDefinitionOfSmalltalkNamespace
	{nil. Root. Smalltalk. Core. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: Smalltalk
				environment: each
				definitionPrefix: 'Kernel.Namespace
	subclass: #Smalltalk']!

testPrintDefinitionOfTopLevelNamespace
	"Note that the name of a namespace defined in Root prints as #<unqualifiedName>, not #'<fullName>', although the full name of Kernel is Kernel anyway (the absolute name is Root.Kernel).
	Defining a Namespace with an unqualified name will add the new Namespace class to Root, not Smalltalk. This differs from other classes, which get added to Smalltalk if the name is unqualified.
	Although this seems inconsistent, it makes sense in practice."

	{nil. Root. Smalltalk. Core. Kernel.Tests} do: 
			[:each |
			self
				verifyClass: Kernel
				environment: each
				definitionPrefix: 'Kernel.Namespace
	subclass: #Kernel']!

verifyClass: aClass environment: aNamespaceOrNil definitionPrefix: aString
	| subject actual stream |
	stream := String smalltalkWriteStream.
	subject := ChunkSourceFiler on: stream.
	subject environment: aNamespaceOrNil.
	subject printBasicDefinitionOfClass: aClass.
	actual := stream contents.
	self assert: (actual beginsWith: aString)! !

!Kernel.Tests.ChunkSourceFilerTest categoriesForMethods!
testPrintDefinitionOfClassInSmalltalk!public!unit tests! !
testPrintDefinitionOfClassWithSuperclassInSmalltalk!public!unit tests! !
testPrintDefinitionOfNamespace!public!unit tests! !
testPrintDefinitionOfNestedNamespace!public!unit tests! !
testPrintDefinitionOfRootClass!public!unit tests! !
testPrintDefinitionOfRootNamespace!public!unit tests! !
testPrintDefinitionOfSmalltalkNamespace!public!unit tests! !
testPrintDefinitionOfTopLevelNamespace!public!unit tests! !
verifyClass:environment:definitionPrefix:!helpers!private! !
!

