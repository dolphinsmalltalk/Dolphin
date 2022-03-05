"Filed out from Dolphin Smalltalk"!

ExternalFieldTest subclass: #ArrayPointerFieldTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayPointerFieldTest guid: (GUID fromString: '{a0c1a616-8f49-45e5-9a9e-f968b315ce71}')!
ArrayPointerFieldTest comment: ''!
!ArrayPointerFieldTest categoriesForClass!Unclassified! !
!ArrayPointerFieldTest methodsFor!

testGenerateAccessorsForSizedString
	| structClass actual expected string struct |
	structClass := ExternalStructure newAnonymousSubclass.
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
	expected := SmalltalkParser
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
	structClass := ExternalStructure newAnonymousSubclass.
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
	expected := SmalltalkParser
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
!ArrayPointerFieldTest categoriesForMethods!
testGenerateAccessorsForSizedString!public! !
testGenerateAccessorsForSizeIsExpression!public! !
!

