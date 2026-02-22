"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'External.Tests.StructureTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.StructureTest guid: (Core.GUID fromString: '{a9244232-e68c-4a65-bbf2-c8392aee459b}')!

External.Tests.StructureTest comment: 'SUnitBrowser openOnTestCase: self'!

!External.Tests.StructureTest methodsFor!

allNonInterfaceStructs
	| interfaces |
	interfaces := #{OS.COM.Interface} ifDefined: [:comInterface | comInterface withAllSubclasses]
				ifNotDefined: [#()].
	^Structure withAllSubclasses difference: interfaces!

testCanUnderstand
	"Test canUnderstand: works for implemented, inherited, and dynamic selectors"

	| subject |
	subject := MSGBOXPARAMSW new.
	#(#text: #alignment #dwLanguageId: #dwStyle:) do: 
			[:each |
			self assert: (subject respondsTo: each).
			self assert: (subject class canUnderstand: each)].
	#(#dwStyle #dwLanguageId #dwContextHelpId #blah #blah:) do: 
			[:each |
			self deny: (subject respondsTo: each).
			self deny: (subject class canUnderstand: each)].
	self assert: (_FPIEEE_RECORD canUnderstand: #status).
	self deny: (_FPIEEE_RECORD canUnderstand: #status:)!

testCanUnderstandExhaustive
	"Test canUnderstand: works for implemented, inherited, and dynamic selectors"

	| autogen |
	autogen := Structure autoGenCategory asMethodCategory.
	self allNonInterfaceStructs do: 
			[:each |
			each template keysAndValuesDo: 
					[:symbol :field |
					field isFiller
						ifTrue: 
							[self assert: ((each canUnderstand: symbol) not
										or: [(autogen includesMethod: (each lookupMethod: symbol)) not])
								description: ['<1p> can understand <2p> for filler field' << { each. symbol }]]
						ifFalse: 
							[| setSelector |
							self
								assert: (each canUnderstand: symbol)
								equals: field isReadable
								description: 
									['<1p> can<2?:not> understand <3p>, but field is<4?: not> readable'
										<< { each. each canUnderstand: symbol. symbol. field isReadable }].
							setSelector := (symbol , ':') asSymbol.
							self
								assert: (each canUnderstand: setSelector)
								equals: field isWriteable
								description: 
									['<1p> can<2?: not> understand <3p>, but field is<4?: not> writeable'
										<< { each. each canUnderstand: setSelector. setSelector. field isWriteable }]]]]!

testCompileDefinition
	"Test that compiling structure fields defines the right set of accessors:
		- get selector for read-only fields
		- set selector for write-only fields
		- get and set selectors for normal fields
		- no selectors for filler fields."
	<ignoreNotImplementedSelectors: #(c: e:)>

	| subject inst |
	subject := Structure newAnonymousSubclass.
	subject class
		compile: 'defineFields
	self
		defineField: #a type: UIntPtrField readOnly;
		defineField: #b type: UInt32Field writeOnly;
		defineField: #c type: UInt16Field new;
		defineField: #d type: UInt8Field filler;
		defineField: #e type: Int32Field uncompiled'.
	subject compileDefinition.
	self assert: subject selectors asSortedArray equals: #(#a #b: #c #c:).
	self assert: subject byteSize equals: 16.
	self assert: subject template keys asSortedArray equals: #(#a #b #c #d #e).
	self assert: subject getFieldNames equals: #(#a #b #c #e).
	self assert: subject dynamicSelectors asSortedArray equals: #(#e #e:).
	inst := subject new.
	self assert: inst c equals: 0.
	inst c: 32768.
	self assert: inst c equals: 32768.
	self assert: inst e equals: 0.
	inst e: 65537.
	self assert: inst e equals: 65537!

testCopyReference
	| struct copy ref |
	struct := RECTL origin: 100@200 extent: 50@75.
	ref := RECTL fromAddress: struct yourAddress.
	self assert: ref isReferenceStruct.
	copy := ref copy.
	self assert: copy isValueStruct.
	self deny: copy bytes identicalTo: ref bytes.
	self assertIsNil: copy owner.
	self assert: copy equals: ref.
	self assert: copy equals: struct.
	"Not a finalizable structure"
	self deny: copy needsFree.
	self deny: copy isFinalizable.
!

testCopyValue
	| struct copy |
	struct := RECTL origin: 100@200 extent: 50@75.
	struct owner: struct.
	copy := struct copy.
	self deny: copy bytes identicalTo: struct bytes.
	self assertIsNil: copy owner.
	self assert: copy equals: struct.
	self assert: copy isValueStruct.
	"Not a finalizable structure"
	self deny: copy needsFree.
	self deny: copy isFinalizable.
!

testDynamicSelectors
	<ignoreNotImplementedSelectors: #(writeOnly: readWrite)>

	| subject expected inst |
	self assert: MSGBOXPARAMSW dynamicSelectors single equals: #dwLanguageId:.
	self assert: _FPIEEE_RECORD dynamicSelectors single equals: #status.
	self assert: _FPIEEE_VALUE dynamicSelectors size equals: 0.
	subject := Structure newAnonymousSubclass.
	subject initializeTemplate.
	self assert: subject dynamicSelectors isEmpty.
	subject
		beUncompiled;
		defineField: #writeOnly type: UInt32Field writeOnly;
		defineField: #readOnly type: UInt32Field readOnly;
		defineField: #readWrite type: UInt32Field new;
		defineField: #filler type: IntPtrField filler.
	expected := #(#readOnly #readWrite #readWrite: #writeOnly:).
	self assert: subject dynamicSelectors asSortedArray equals: expected.
	self assert: subject template keys asSortedArray equals: #(#filler #readOnly #readWrite #writeOnly).
	inst := subject new.
	inst writeOnly: 1234.
	self
		should: [inst writeOnly]
		raise: MessageNotUnderstood
		matching: [:ex | ex selector == #writeOnly].
	self assert: (inst bytes uint32AtOffset: 0) equals: 1234.
	self assert: inst readOnly equals: 0.
	self
		should: [inst readOnly: 456]
		raise: MessageNotUnderstood
		matching: [:ex | ex selector == #readOnly:].
	inst bytes uint32AtOffset: 4 put: 456.
	self assert: inst readOnly equals: 456.
	self assert: inst readWrite equals: 0.
	inst readWrite: 123.
	self assert: inst readWrite equals: 123!

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

testFieldNamesFromTemplateExhaustive
	self allNonInterfaceStructs do: 
			[:each |
			| names |
			names := each fieldNamesFromTemplate.
			self
				assert: (names allSatisfy: 
							[:symbol |
							symbol argumentCount = 0 and: 
									[| field |
									field := each template at: symbol.
									field isReadable or: [field isWriteable]]])]!

testHasUncompiledFields
	self assert: MSGBOXPARAMSW hasUncompiledFields.
	self assert:  _FPIEEE_RECORD hasUncompiledFields.
	self deny: _FPIEEE_VALUE hasUncompiledFields!

testIsNull
	| struct |
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
	self assert: struct isNull!

testNewBuffer
	| struct |
	struct := FILETIME new.
	self assert: struct isNull not.
	self assert: struct isValueStruct.
	self deny: struct isPointerStruct.
	self deny: struct isReferenceStruct.
	self deny: struct needsFree.
	self deny: struct isFinalizable.
	struct free.
	self assert: struct isNull.
	self deny: struct isValueStruct.
	self deny: struct isPointerStruct.
	self deny: struct isReferenceStruct.
	self deny: struct needsFree.
	self deny: struct isFinalizable!

testNewPointer
	| struct |
	struct := FILETIME newPointer.
	self assert: struct isNull.
	self deny: struct needsFree.
	self deny: struct isFinalizable.
	self assert: struct isPointerStruct.
	"Not a reference, because it is null"
	self deny: struct isReferenceStruct!

testUnderstoodSelectors
	self assert: MSGBOXPARAMSW understoodSelectors asSortedArray
		equals: #(#caption: #dwLanguageId: #dwStyle: #hInstance: #hwndOwner: #lpszCaption: #lpszIcon: #lpszText: #text:).
	self assert: _FPIEEE_RECORD understoodSelectors asSortedArray
		equals: #(#cause #causeCode #causeDescription #causeName #causeNames #decodeExceptionFlags: #enabled #flags #isDivide #isOverflow #isUnderflow #isZeroDivide #operand1 #operand1Value #operand2 #operation #operationName #precision #precisionName #printFieldsOn: #printFlags:on: #roundingMode #roundingModeName #status).
	self assert: _FPIEEE_VALUE understoodSelectors equals: _FPIEEE_VALUE selectors! !

!External.Tests.StructureTest categoriesForMethods!
allNonInterfaceStructs!helpers!private! !
testCanUnderstand!public!unit tests! !
testCanUnderstandExhaustive!public!unit tests! !
testCompileDefinition!public!unit tests! !
testCopyReference!public!unit tests! !
testCopyValue!public!unit tests! !
testDynamicSelectors!public!unit tests! !
testEquals!public!unit tests! !
testFieldNamesFromTemplateExhaustive!public!unit tests! !
testHasUncompiledFields!public!unit tests! !
testIsNull!public!unit tests! !
testNewBuffer!public!unit tests! !
testNewPointer!public!unit tests! !
testUnderstoodSelectors!public!unit tests! !
!

