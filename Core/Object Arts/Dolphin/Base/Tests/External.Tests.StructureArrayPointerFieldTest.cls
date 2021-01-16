"Filed out from Dolphin Smalltalk 7"!

External.Tests.ExternalFieldTest subclass: #'External.Tests.StructureArrayPointerFieldTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.StructureArrayPointerFieldTest guid: (Core.GUID fromString: '{05db20c0-4d73-4853-8820-50302b095632}')!
External.Tests.StructureArrayPointerFieldTest comment: ''!
!External.Tests.StructureArrayPointerFieldTest categoriesForClass!Unclassified! !
!External.Tests.StructureArrayPointerFieldTest methodsFor!

testGenerateAccessorsForSizedArray
	| structClass actual expected data struct |
	structClass := Structure newAnonymousSubclass.
	structClass class
		basicCompile: 'defineFields
		self defineField: #Test
			type: (StructureArrayPointerField type: POINTL lengthField: #Size)
			offset: 0;
		defineField: #Size
			type: DWORDField new
			offset: 4'.
	structClass recompileDefinition.
	actual := (structClass compiledMethodAt: #Test:) parseTree.
	expected := Parser
				parseMethod: 'Test: aStructureArray bytes uintPtrAtOffset: _OffsetOf_Test put: aStructureArray yourAddress. self Size: aStructureArray size'.
	self assert: actual equals: expected.

	"Write a string with embedded null terminator so we can check it reads back using the size."
	struct := structClass new.
	data := (StructureArray length: 2 elementClass: POINTL)
				at: 1 put: (100 @ 200) asParameter;
				at: 2 put: (300 @ 400) asParameter;
				yourself.
	struct Test: data.
	self assert: struct Size equals: 2.
	actual := struct Test.
	self assert: actual equals: data.
	"Test uncompiled write/read while we are here."
	struct := structClass new.
	structClass
		methodDictionary: nil;
		flushMethodCache.
	struct Test: data.
	self assert: struct Size equals: 2.
	self assert: struct Test equals: data! !
!External.Tests.StructureArrayPointerFieldTest categoriesFor: #testGenerateAccessorsForSizedArray!public! !

