"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.RegistrySerializerTest'
	instanceVariableNames: 'testKey'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.RegistrySerializerTest guid: (Core.GUID fromString: '{dba1e292-4a5c-4484-b1d9-c3151b1df7c2}')!
OS.Tests.RegistrySerializerTest comment: ''!
!OS.Tests.RegistrySerializerTest methodsFor!

keyPath
	^'Software\Object Arts\Dolphin Smalltalk\' , self class name!

numberTestValues
	| numbers |
	numbers := OrderedCollection new.
	numbers add: 1.23.
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
	numbers add: 1.234s.
	^numbers!

setUp
	super setUp.
	testKey := RegKey userRoot createKey: self keyPath!

tearDown
	testKey free.
	RegKey userRoot removeSubTree: self keyPath.
	testKey := nil.
	super tearDown!

testBag
	| subject restored key |
	subject := Bag new.
	subject
		add: '2x';
		add: '2x';
		add: {1}.
	testKey objectAt: self selector put: subject.
	key := testKey at: self selector.
	"The keys names should be integers"
	self assert: (key keys asArray , key subValueNames) sort
		equals: #('') , ((1 to: subject size) collect: [:i | i printString]).
	"Deafult value should be the class and tally"
	self assert: (key valueAt: '') equals: {subject class shortName. subject size printString}.
	key free.
	restored := testKey objectAt: self selector.
	self assert: restored class identicalTo: subject class.
	self assert: restored equals: subject!

testBooleans
	| rehydrated booleans |
	booleans := #(true #(true) false #(false)).
	testKey objectAt: self selector put: booleans.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated equals: booleans!

testByteArrayRef
	| method bytes2 rehydrated key deserializer |
	method := self class compiledMethodAt: self selector.
	bytes2 := #[1 2 3 4].
	testKey objectAt: self selector put: {bytes2. method. method byteCodes. bytes2}.
	key := testKey at: self selector.
	deserializer := OS.RegistryDeserializer regKey: key.
	deserializer allowUnknownClasses.
	rehydrated := deserializer readObject.
	key free.
	self assert: (rehydrated at: 1) equals: bytes2.
	self assert: (rehydrated at: 2) equals: method.
	self assert: (rehydrated at: 3) identicalTo: (rehydrated at: 2) byteCodes.
	self assert: (rehydrated at: 4) identicalTo: (rehydrated at: 1)!

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

testClasses
	| rehydrated |
	testKey objectAt: self selector put: { self class. self class class. self class class class. self class class class class }.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated first identicalTo: self class.
	self assert: rehydrated second identicalTo: self class class.
	self assert: rehydrated third identicalTo: Metaclass.
	self assert: rehydrated fourth identicalTo: Metaclass class.

!

testColors
	<namespace: Graphics>
	| colors rehydrated argb key serializer |
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
				argb.
				ColorAlpha color: Color purple alpha: 128.
				PluggableColor with: argb.
				Color brightness: 243 / 255}.
	self assert: (colors at: 3) identicalTo: (colors at: 5).
	testKey objectAt: self selector put: colors.
	key := testKey at: self selector.
	serializer := OS.RegistryDeserializer regKey: key.
	serializer addSafeClass: PluggableColor.
	rehydrated := serializer readObject.
	key free.
	self assert: rehydrated equals: colors.
	self assert: (rehydrated at: 1) identicalTo: (rehydrated at: 6).
	"The identity of (A)RGBs and other unnamed Colors will not be preserved. These are considered value objects."
	self deny: (rehydrated at: 2) identicalTo: (rehydrated at: 7).
	self assert: (rehydrated at: 3) identicalTo: (rehydrated at: 5).
	self assert: (rehydrated at: 8) isKindOf: ColorAlpha.
	self assert: (rehydrated at: 9) isKindOf: PluggableColor!

testCyclicRefs
	| array1 array2 rehydrated |
	array1 := Array new: 1.
	array2 := {array1}.
	array1 at: 1 put: array2.
	testKey objectAt: self selector put: array1.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated first first identicalTo: rehydrated!

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

testFont
	| subject rehydrated |
	subject := Smalltalk developmentSystem defaultFont.
	testKey objectAt: self selector put: {subject. subject}.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated first identicalTo: rehydrated second.
	self assert: rehydrated first equals: subject!

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
	self assert: (key keys asArray , key subValues keys asArray) sort
		equals: #('') , subject keys asSortedArray.
	key free.
	restored := testKey objectAt: self selector.
	self assert: restored class identicalTo: IdentityDictionary.
	self assert: restored equals: subject!

testIntegerBytes
	| subjects rehydrated key deserializer |
	"Note that it doesn't make sense to serialize ExternalAddress objects to the registry, as these are pointers and not necesssarily valid for any duration.
	The same is true of handles really."
	subjects := {Handle fromInteger: 1234.
				UInt32Bytes fromInteger: 16r80000001.
				UInt64Bytes fromInteger: 16r8000000000000001}.
	testKey objectAt: self selector put: subjects.
	key := testKey at: self selector.
	deserializer := OS.RegistryDeserializer regKey: key.
	rehydrated := deserializer readObject.
	key free.
	"Handles are not serialized"
	subjects at: 1 put: nil.
	self assert: rehydrated equals: subjects!

testInterval
	| rehydrated interval |
	interval := 2 to: 10 by: 1.5.
	testKey objectAt: self selector put: { interval. { interval } }.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated equals: { interval. { interval } }!

testLocales
	| key welsh locales serializer rehydrated |
	welsh := Locale named: 'cy'.
	locales := {
				Locale smalltalk.
				welsh.
				Locale invariant.
				Locale named: 'en-Cy'.
				welsh.
				Locale named: 'cy-GB'
			}.
	testKey objectAt: self selector put: locales.
	key := testKey at: self selector.
	serializer := RegistryDeserializer regKey: key.
	rehydrated := serializer readObject.
	key free.
	self assert: rehydrated equals: locales.
	"No attempt is made to maintain identity of WindowsLocale objects - from a public perspective they are immutable value objects."
	self assert: (rehydrated at: 2) equals: (rehydrated at: 5)!

testLookupTableWithNonStringKeys
	"If any of the Dictionary keys are not strings, the general serialization format for Sets should be used"

	self verifyDictionarySerializationWithNonStringKeys: LookupTable!

testLookupTableWithStringKeys
	self verifyDictionarySerializationStringKeys: LookupTable!

testNumbers
	| numbers rehydrated |
	numbers := self numberTestValues.
	testKey objectAt: self selector put: numbers.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated equals: numbers!

testOrderedCollection
	| numbers rehydrated key deserializer |
	numbers := self numberTestValues asOrderedCollection.
	numbers addFirst: 0.
	numbers removeFirst.
	numbers addLast: 0.
	numbers removeLast.
	testKey objectAt: self selector put: numbers.
	key := testKey at: self selector.
	deserializer := RegistryDeserializer regKey: key.
	rehydrated := deserializer readObject.
	key free.
	self assert: rehydrated equals: numbers.
	self assert: rehydrated isKindOf: OrderedCollection!

testRemoveNamedInstVar
	"Simulates the schema migration scenario of an named instance variable being removed - previously serialized values under old inst var names should just be ignored"

	| interval deserializer rehydrated instVarMap key |
	interval := 1 to: 10 by: 0.25.
	testKey objectAt: self selector put: interval.
	"Sanity check that it reads back ok, also populating the inst var name cache"
	key := testKey at: self selector.
	deserializer := RegistryDeserializer regKey: key.
	key free.
	rehydrated := deserializer readObject.
	self assert: rehydrated equals: interval.

	"Remove a variable serialized as a value"
	deserializer := RegistryDeserializer regKey: key.
	instVarMap := deserializer instVarMapFor: Interval.
	instVarMap removeKey: 'stop'.
	rehydrated := deserializer readObject.
	self assertIsNil: rehydrated stop.
	rehydrated stop: 10.
	self assert: rehydrated equals: interval.

	"Remove a variable serialized as a class key"
	deserializer := RegistryDeserializer regKey: key.
	instVarMap := deserializer instVarMapFor: Interval.
	instVarMap removeKey: 'step'.
	rehydrated := deserializer readObject.
	self assertIsNil: rehydrated step.
	rehydrated step: 0.25.
	self assert: rehydrated equals: interval!

testScintillaTextStyles
	| styles rehydratedStyles deserializer key |
	styles := Tools.SmalltalkWorkspace textStyles.
	testKey objectAt: self selector put: styles.
	key := testKey at: self selector.
	deserializer := RegistryDeserializer regKey: key.
	deserializer addSafeClass: UI.Scintilla.TextStyle.
	rehydratedStyles := deserializer readObject.
	key free.
	self deny: rehydratedStyles identicalTo: styles.
	self assert: rehydratedStyles equals: styles!

testSelfRef
	| assoc rehydrated |
	assoc := 'me' -> nil.
	assoc value: assoc.
	testKey objectAt: self selector put: assoc.
	rehydrated := testKey objectAt: self selector.
	self assert: rehydrated key equals: 'me'.
	self assert: rehydrated value equals: rehydrated!

testSet
	| subject restored key |
	subject := Set new.
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
	"The keys names should be integers"
	self assert: (key keys asArray , key subValues keys asArray) sort
		equals: #('') , ((1 to: subject size) collect: [:i | i printString]).
	"Deafult value should be the class and tally"
	self assert: (key valueAt: '') equals: {subject class shortName. subject size printString}.
	key free.
	restored := testKey objectAt: self selector.
	self assert: restored isHealthy.
	self assert: restored equals: subject!

testSortedCollection
	| numbers rehydrated key deserializer |
	numbers := self numberTestValues asSortedCollection: [:a :b | a > b].
	testKey objectAt: self selector put: numbers.
	key := testKey at: self selector.
	deserializer := OS.RegistryDeserializer regKey: key.
	deserializer
		addSafeClass: SortedCollection;
		addSafeClass: IntrosortAlgorithm.
	"Storing code in the registry under HKEY_CURRENT_USER is definitely not safe in general"
	deserializer
		addSafeClass: BlockClosure;
		addSafeClass: CompiledMethod.
	rehydrated := deserializer readObject.
	key free.
	self assert: rehydrated equals: numbers.
	self assert: rehydrated algorithm isKindOf: SortAlgorithm pluggableEquivalentClass.
	numbers add: 7.
	rehydrated add: 7.
	self assert: rehydrated equals: numbers!

testSortedCollectionDefaultAlgorithm
	| numbers rehydrated key deserializer |
	"Test with default sort algorithm"
	numbers := self numberTestValues asSortedCollection.
	testKey objectAt: self selector put: numbers.
	key := testKey at: self selector.
	deserializer := OS.RegistryDeserializer regKey: key.
	rehydrated := deserializer readObject.
	key free.
	self assert: rehydrated equals: numbers.
	self assert: rehydrated algorithm identicalTo: SortAlgorithm default.
	numbers add: 5.
	rehydrated add: 5.
	self assert: rehydrated equals: numbers!

testStockFont
	| subject rehydrated font |
	subject := Graphics.Font system.
	testKey objectAt: self selector put: { subject. Array with: subject }.
	rehydrated := testKey objectAt: self selector.
	font := subject copy.
	self assert: rehydrated equals: {font. {font}}!

testUnsafeObjects
	| subject rehydrated notifications duration literal |
	literal := ##('abc' -> Object new).
	subject := 
			["Not actually unsafe, since the become primitive will detect this and fail, but you get the idea. Blocks contain arbitrary code, so shouldn't be loaded from potentially unsafe locations."
			Object become: literal].
	duration := 1 seconds.
	testKey objectAt: self selector
		put: {
				subject.
				duration.
				{ literal. subject. duration }.
				subject.
				subject method.
				duration.
				#become:
			}.
	notifications := OrderedCollection new.
	rehydrated := [testKey objectAt: self selector] on: Notification
				do: 
					[:ex |
					notifications add: ex.
					ex resume].
	self assert: rehydrated
		equals: { nil. duration. { 'abc' -> nil. nil. duration }. nil. nil. duration. #become: }.
	self assert: notifications size equals: 3.
	self assert: notifications first messageText
		equals: 'Software\Object Arts\Dolphin Smalltalk\RegistrySerializerTest\testUnsafeObjects\1 stores a BlockClosure which is not a known and/or safe class, and will be substituted'.
	self assert: notifications second messageText
		equals: 'Software\Object Arts\Dolphin Smalltalk\RegistrySerializerTest\testUnsafeObjects\1\method stores a CompiledMethod which is not a known and/or safe class, and will be substituted'.
	self assert: notifications third messageText
		equals: 'Software\Object Arts\Dolphin Smalltalk\RegistrySerializerTest\testUnsafeObjects\1\method\1\value stores a Object which is not a known and/or safe class, and will be substituted'!

verifyDictionarySerializationStringKeys: aClass
	| restored subject key |
	subject := aClass new.
	subject
		at: '123' put: 123;
		at: 'float' put: 1.23;
		at: 'Interval' put: (1 to: 10 by: 2);
		at: 'myself' put: subject.
	testKey objectAt: self selector put: subject.
	key := testKey at: self selector.
	self assert: (key keys asArray , key subValues keys asArray) sort
		equals: #('') , subject keys asSortedArray.
	restored := RegistryDeserializer readFrom: key.
	key free.
	self assert: restored class identicalTo: aClass.
	self assert: (restored at: 'myself') identicalTo: restored.
	subject removeKey: 'myself'.
	restored removeKey: 'myself'.
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
		at: #Interval put: (1 to: 10 by: 2);
		at: 'myself' put: subject;
		at: true put: true.
	testKey objectAt: self selector put: subject.
	key := testKey at: self selector.
	"The keys names should be integers"
	self assert: key keys asSortedArray equals: ((1 to: subject size) collect: [:i | i printString]).
	"Only the default value should be present"
	self assert: key subValues keys single equals: ''.
	"And it's value should be the class and tally"
	self assert: (key valueAt: '') equals: { subject class shortName. subject size printString }.
	key free.
	"It should read-back as an equivalent dictionary"
	restored := testKey objectAt: self selector.
	self assert: restored class identicalTo: aClass.
	self assert: (restored at: 'myself') identicalTo: restored.
	"We have to remove the cyclic reference before the equality comparison or it will loop until stack overflow"
	subject removeKey: 'myself'.
	restored removeKey: 'myself'.
	self assert: restored equals: subject.
	self assert: (restored keys identityIncludes: #'123')! !
!OS.Tests.RegistrySerializerTest categoriesForMethods!
keyPath!constants!private! !
numberTestValues!constants!private! !
setUp!private!running! !
tearDown!private!running! !
testBag!public!unit tests! !
testBooleans!public!unit tests! !
testByteArrayRef!public!unit tests! !
testByteArrays!public!unit tests! !
testClasses!public!unit tests! !
testColors!public!unit tests! !
testCyclicRefs!public!unit tests! !
testDictionaryWithNonStringKeys!public!unit tests! !
testDictionaryWithStringKeys!public!unit tests! !
testEmptyArray!public!unit tests! !
testFont!public!unit tests! !
testIdentityDictionaryWithSymbolKeys!public!unit tests! !
testIntegerBytes!public!unit tests! !
testInterval!public!unit tests! !
testLocales!public!unit tests! !
testLookupTableWithNonStringKeys!public!unit tests! !
testLookupTableWithStringKeys!public!unit tests! !
testNumbers!public!unit tests! !
testOrderedCollection!public!unit tests! !
testRemoveNamedInstVar!public!unit tests! !
testScintillaTextStyles!public!unit tests! !
testSelfRef!public!unit tests! !
testSet!public!unit tests! !
testSortedCollection!public!unit tests! !
testSortedCollectionDefaultAlgorithm!public!unit tests! !
testStockFont!public!unit tests! !
testUnsafeObjects!public!unit tests! !
verifyDictionarySerializationStringKeys:!helpers!private! !
verifyDictionarySerializationWithNonStringKeys:!helpers!private! !
!

