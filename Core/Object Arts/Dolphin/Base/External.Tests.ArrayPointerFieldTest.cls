"Filed out from Dolphin Smalltalk 7"!

External.Tests.ExternalFieldTest subclass: #'External.Tests.ArrayPointerFieldTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.ArrayPointerFieldTest guid: (Core.GUID fromString: '{a0c1a616-8f49-45e5-9a9e-f968b315ce71}')!
External.Tests.ArrayPointerFieldTest comment: ''!
!External.Tests.ArrayPointerFieldTest categoriesForClass!Unclassified! !
!External.Tests.ArrayPointerFieldTest methodsFor!

testGenerateAccessorsForSizedString
	| structClass actual expected string struct |
	structClass := Structure newAnonymousSubclass.
	structClass class
		basicCompile: 'defineFields
		self defineField: #Test
			type: (ArrayPointerField type: String lengthField: #Size)
			offset: 0;
		defineField: #Size
			type: DWORDField new
			offset: 4'.
	structClass recompileDefinition.
	actual := (structClass compiledMethodAt: #Test:) parseTree.
	expected := Parser
				parseMethod: 'Test: aString bytes uintPtrAtOffset: _OffsetOf_Test put: aString yourAddress. self Size: aString size'.
	self assert: actual equals: expected.
	"Write a string with embedded null terminator so we can check it reads back using the size."
	string := 'Foo0🐬' copyReplacing: $0 withObject: $\0.
	struct := structClass new.
	struct Test: string.
	self assert: struct Size equals: string size.
	actual := struct Test.
	self assert: (actual includes: $\0).
	self assert: actual equals: string.
	"Test uncompiled write/read while we are here."
	structClass
		methodDictionary: nil;
		flushMethodCache.
	string := '🐬' copyWith: $\0.
	struct Test: string.
	self assert: struct Size equals: string size.
	self assert: struct Test equals: string!

testGenerateAccessorsForSizeIsExpression
	| structClass actual expected string struct |
	structClass := Structure newAnonymousSubclass.
	structClass class
		basicCompile: 'defineFields
		self defineField: #Test
			type: (ArrayPointerField type: Utf16String arrayLength: (SizeIsArrayFieldLength sizeIs: ''Size >> 1''))
			offset: 4;
		defineField: #Size
			type: DWORDField new
			offset: 0'.
	structClass recompileDefinition.
	actual := (structClass compiledMethodAt: #Test:) parseTree.
	expected := Parser
				parseMethod: 'Test: anUtf16String bytes uintPtrAtOffset: _OffsetOf_Test put: anUtf16String yourAddress. self Size: anUtf16String size << 1'.
	self assert: actual equals: expected.
	"Write a string with embedded null terminator so we can check it reads back using the size."
	string := ('Foo0🐬' copyReplacing: $0 withObject: $\0) asUtf16String.
	struct := structClass new.
	struct Test: string.
	self assert: struct Size equals: string size * 2.
	actual := struct Test.
	self assert: (actual includes: $\0).
	self assert: actual equals: string.
	"Test uncompiled write/read while we are here."
	structClass
		methodDictionary: nil;
		flushMethodCache.
	string := ('🐬' copyWith: $\0) asUtf16String.
	struct Test: string.
	self assert: struct Size equals: string size * 2.
	self assert: struct Test equals: string! !
!External.Tests.ArrayPointerFieldTest categoriesFor: #testGenerateAccessorsForSizedString!public! !
!External.Tests.ArrayPointerFieldTest categoriesFor: #testGenerateAccessorsForSizeIsExpression!public! !

