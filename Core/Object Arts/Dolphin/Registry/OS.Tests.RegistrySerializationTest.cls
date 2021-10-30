"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'OS.Tests.RegistrySerializationTest'
	instanceVariableNames: 'testKey'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.RegistrySerializationTest guid: (Core.GUID fromString: '{dba1e292-4a5c-4484-b1d9-c3151b1df7c2}')!
OS.Tests.RegistrySerializationTest comment: ''!
!OS.Tests.RegistrySerializationTest categoriesForClass!Unclassified! !
!OS.Tests.RegistrySerializationTest methodsFor!

keyPath
	^'Software\Object Arts\Dolphin Smalltalk\' , self class name!

numberTestValues
	| numbers |
	numbers := OrderedCollection new.
	numbers addAll: #(-1 0 1).
	numbers add: SmallInteger maximum.
	numbers add: SmallInteger maximum + 1.
	numbers add: SmallInteger minimum.
	numbers add: SmallInteger minimum - 1.
	"A range of large integers that can be represented natively as REG_DWORD or REG_QWORD, and larger values that require a class key with REG_BINARY value"
	#(31 32 63 64 127 128 255 256) do: 
			[:each |
			numbers add: 2 ** each - 1.
			numbers add: -2 ** each].
	numbers add: 22 / 7.
	numbers add: 1.23.
	numbers add: 1.234s.
	^numbers!

setUp
	super setUp.
	testKey := RegKey userRoot createKey: self keyPath!

tearDown
	testKey free.
	"RegKey userRoot removeKey: self keyPath ifAbsent: nil."
	testKey := nil.
	super tearDown.
!

testByteArrays
	#(#[] #[1] #[0 255] #[127 128 255]) do: 
			[:each |
			| array |
			testKey objectAt: self selector put: each.
			array := testKey valueAt: self selector.
			self assert: array equals: each.
			testKey objectAt: self selector put: {each}.
			array := testKey objectAt: self selector.
			self assert: array equals: {each}]!

testColors
	<namespace: Graphics>
	| colors rehydrated argb |
	argb := Color
				a: 128
				r: 111
				g: 158
				b: 238.
	colors := {Color purple.
				argb.
				Color named: #smalltalkSystem.
				Color
					r: 209
					g: 55
					b: 193.
				Color named: #smalltalkSystem.
				Color purple.
				argb}.
	self assert: (colors at: 3) identicalTo: (colors at: 5).
	testKey objectAt: self selector put: colors.
	rehydrated := testKey objectAt: self selector.
	self assert: colors equals: rehydrated.
	self assert: (rehydrated at: 3) identicalTo: (rehydrated at: 5)!

testDictionaryWithNonStringKeys
	"If any of the Dictionary keys are not strings, the general serialization format for Sets should be used"

	self verifyDictionarySerializationWithNonStringKeys: Dictionary!

testDictionaryWithStringKeys
	self verifyDictionarySerializationStringKeys: Dictionary!

testEmptyArray
	| array |
	testKey objectAt: self selector put: #().
	array := testKey valueAt: self selector.
	self assert: array equals: #().
	testKey objectAt: self selector put: #(#()).
	array := testKey objectAt: self selector.
	self assert: array equals: #(#())!

testFractions
	| subject rehydrated |
	subject := 22 / 7.
	testKey objectAt: self selector put: subject.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated equals: subject!

testIdentityDictionaryWithSymbolKeys
	| restored subject key |
	subject := IdentityDictionary new.
	subject
		at: #'123' put: 123;
		at: #oneTwoThree put: 'one two three';
		at: #Float put: 1.23;
		at: #Interval put: (1 to: 10 by: 2).
	testKey objectAt: self selector put: subject.
	key := testKey at: self selector.
	self assertIsNil: key handle.
	self assert: (key keys asArray , key subValues keys asArray) sort
		equals: #('') , subject keys asArray sort.
	key free.
	restored := testKey objectAt: self selector.
	self assert: restored class identicalTo: IdentityDictionary.
	self assert: restored equals: subject!

testIntegerBytes
	| subjects rehydrated |
	"Note that it doesn't make sense to serialize ExternalAddress objects to the registry, as these are pointers and not necesssarily valid for any duration.
	The same is true of handles really."
	subjects := {UInt32Bytes fromInteger: 16r80000001.
				UInt64Bytes fromInteger: 16r8000000000000001.
				Handle fromInteger: 1234}.
	testKey objectAt: self selector put: subjects.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated equals: subjects!

testLookupTableWithNonStringKeys
	"If any of the Dictionary keys are not strings, the general serialization format for Sets should be used"

	self verifyDictionarySerializationWithNonStringKeys: LookupTable!

testLookupTableWithStringKeys
	self verifyDictionarySerializationStringKeys: LookupTable!

testNumbers
	| numbers rehydrated |
	numbers := self numberTestValues asArray.
	testKey objectAt: self selector put: numbers.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated equals: numbers!

testScintillaTextStyles
	| styles rehydratedStyles |
	styles := Tools.SmalltalkWorkspace textStyles asArray.
	testKey objectAt: self selector put: styles.
	rehydratedStyles := testKey objectAt: self selector.
	self deny: rehydratedStyles identicalTo: styles.
	self assert: rehydratedStyles equals: styles!

testSetSerialization
	| subject restored key |
	subject := Set new.	" withAll: self integerTestValues."
	subject
		add: 1.23;
		add: '123';
		add: #oneTwoThree;
		add: (1 to: 3);
		add: 1 -> 3;
		add: #[1 2 3];
		add: self class guid.
	testKey objectAt: self selector put: subject.
	key := testKey at: self selector.
	self assertIsNil: key handle.
	"The keys names should be integers"
	self assert: (key keys asArray , key subValues keys asArray) sort
		equals: #('') , ((1 to: subject size) collect: [:i | i printString]).
	"Deafult value should be the class and tally"
	self assert: (key valueAt: '') equals: {subject class shortName. subject size printString}.
	key free.
	restored := testKey objectAt: self selector.
	self assert: restored equals: subject!

verifyDictionarySerializationStringKeys: aClass
	| restored subject key |
	subject := aClass new.
	subject
		at: '123' put: 123;
		at: 'float' put: 1.23;
		at: 'Interval' put: (1 to: 10 by: 2).
	testKey objectAt: self selector put: subject.
	key := testKey at: self selector.
	self assertIsNil: key handle.
	self assert: (key keys asArray , key subValues keys asArray) sort
		equals: #('') , subject keys asArray sort.
	restored := testKey objectAt: self selector.
	self assert: restored class identicalTo: aClass.
	self assert: restored equals: subject!

verifyDictionarySerializationWithNonStringKeys: aClass
	| subject float key restored |
	subject := aClass new.
	float := 1.23.
	subject
		at: #'123' put: 123;
		at: 'float' put: float;
		at: #Symbol put: #Symbol;
		at: 'sameFloat' put: float;
		at: #Interval put: (1 to: 10 by: 2).
	testKey objectAt: self selector put: subject.
	key := testKey at: self selector.
	"The keys names should be integers"
	self assert: key keys asArray sort equals: ((1 to: subject size) collect: [:i | i printString]).
	"Only the default value should be present"
	self assert: key subValues keys single equals: ''.
	"And it's value should be the class and tally"
	self assert: (key valueAt: '') equals: {subject class shortName. subject size printString}.
	key free.
	"It should read-back as an equivalent dictionary"
	restored := testKey objectAt: self selector.
	self assert: restored class identicalTo: aClass.
	self assert: restored equals: subject.
	self assert: (restored keys identityIncludes: #'123')! !
!OS.Tests.RegistrySerializationTest categoriesForMethods!
keyPath!constants!private! !
numberTestValues!constants!private! !
setUp!private!running! !
tearDown!private!running! !
testByteArrays!public!unit tests! !
testColors!public!unit tests! !
testDictionaryWithNonStringKeys!public!unit tests! !
testDictionaryWithStringKeys!public!unit tests! !
testEmptyArray!public!unit tests! !
testFractions!public!unit tests! !
testIdentityDictionaryWithSymbolKeys!public!unit tests! !
testIntegerBytes!public!unit tests! !
testLookupTableWithNonStringKeys!public!unit tests! !
testLookupTableWithStringKeys!public!unit tests! !
testNumbers!public!unit tests! !
testScintillaTextStyles!public!unit tests! !
testSetSerialization!public!unit tests! !
verifyDictionarySerializationStringKeys:!helpers!private! !
verifyDictionarySerializationWithNonStringKeys:!helpers!private! !
!

