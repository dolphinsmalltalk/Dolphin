"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'External.Tests.StructureTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.StructureTest guid: (Core.GUID fromString: '{a9244232-e68c-4a65-bbf2-c8392aee459b}')!
External.Tests.StructureTest comment: 'SUnitBrowser openOnTestCase: self'!
!External.Tests.StructureTest categoriesForClass!Unclassified! !
!External.Tests.StructureTest methodsFor!

testCanUnderstand
	"Test canUnderstand: works for implemented, inherited, and dynamic selectors"

	| subject |
	subject := MSGBOXPARAMSW new.
	#(#text: #alignment #dwLanguageId:) do: 
			[:each |
			self assert: (subject respondsTo: each).
			self assert: (subject class canUnderstand: each)].
	#(#dwLanguageId #dwContextHelpId #blah #blah:) do: 
			[:each |
			self deny: (subject respondsTo: each).
			self deny: (subject class canUnderstand: each)]!

testCompileDefinition
	"Test that compiling structure fields defines the right set of accessors:
		- get selector for read-only fields
		- set selector for write-only fields
		- get and set selectors for normal fields
		- no selectors for filler fields."

	| subject |
	subject := Structure newAnonymousSubclass.
	subject class
		compile: 'defineFields
	self
		defineField: #a type: UINT_PTRField readOnly;
		defineField: #b type: DWORDField writeOnly;
		defineField: #c type: WORDField new;
		defineField: #d type: BYTEField filler'.
	subject compileDefinition.
	self assert: subject selectors asArray sort equals: #(#a #b: #c #c:).
	self assert: subject byteSize equals: 12!

testDynamicSelectors
	| subject expected |
	subject := Structure newAnonymousSubclass.
	subject initializeTemplate.
	subject
		defineField: #writeOnly type: DWORDField writeOnly;
		defineField: #readOnly type: DWORDField readOnly;
		defineField: #readWrite type: DWORDField new;
		defineField: #fillter type: INT_PTRField filler.
	expected := #(#readOnly #readWrite #readWrite: #writeOnly:).
	self assert: subject dynamicSelectors asArray sort equals: expected!

testEquals
	| s1 s2 s3 s4 |
	s1 := FILETIME newPointer.
	s2 := FILETIME newPointer.
	self assert: s1 equals: s1.
	self assert: s1 equals: s2.
	s1 := FILETIME fromInteger: 1234.
	self deny: s1 equals: s2.
	self assert: s1 equals: s1.
	s3 := FILETIME fromAddress: s1 yourAddress.
	self assert: s3 equals: s3.
	self assert: s1 equals: s3.
	self deny: s2 equals: s3.
	self deny: s3 equals: s2.
	s2 := FILETIME fromInteger: 1234.
	self assert: s1 equals: s2.
	self assert: s2 equals: s1.
	self assert: s1 equals: s3.
	self assert: s3 equals: s1.
	self assert: s3 equals: s2.
	self assert: s2 equals: s3.
	s4 := FILETIME fromAddress: s2 yourAddress.
	self assert: s1 equals: s4.
	self assert: s4 equals: s1!

testIsNull
	| struct |
	self assert: FILETIME newPointer isNull.
	struct := FILETIME new.
	self assert: struct isNull not.
	struct bytes: 0.
	self assert: struct isNull.
	struct bytes: nil.
	self assert: struct isNull.
	struct bytes: Object new.
	self should: [struct isNull] raise: MessageNotUnderstood.
	struct bytes: ByteArray new.
	self assert: struct isNull not.
	struct bytes: External.Address new.
	self assert: struct isNull! !
!External.Tests.StructureTest categoriesFor: #testCanUnderstand!public!unit tests! !
!External.Tests.StructureTest categoriesFor: #testCompileDefinition!public!unit tests! !
!External.Tests.StructureTest categoriesFor: #testDynamicSelectors!public!unit tests! !
!External.Tests.StructureTest categoriesFor: #testEquals!public!unit tests! !
!External.Tests.StructureTest categoriesFor: #testIsNull!public!unit tests! !

