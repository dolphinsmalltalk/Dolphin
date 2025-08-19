"Filed out from Dolphin Smalltalk"!

Kernel.Tests.STBTest
	subclass: #'Kernel.Tests.STBValidatingInFilerTest'
	instanceVariableNames: 'locator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.STBValidatingInFilerTest guid: (Core.GUID fromString: '{078c50e0-a124-4739-8f98-fab43c74c0d7}')!

Kernel.Tests.STBValidatingInFilerTest comment: ''!

!Kernel.Tests.STBValidatingInFilerTest methodsFor!

infilerClass
	^STBValidatingInFiler!

initializeLocator: anInteger
	"Additional classes are derestricted in specific tests, or if #serialized:"

	^locator
		ifNil: 
			[locator := RestrictedClassLocator forClasses: (anInteger < 4
								ifTrue: 
									[anInteger < 2
										ifTrue: 
											[#(#{Core.ByteArray} #{Core.String} #{Core.AnsiString} #{Smalltalk.STBSymbolProxy} #{Core.Array})]
										ifFalse: [#(#{Core.ByteArray} #{Core.String} #{Core.AnsiString} #{Core.Symbol} #{Core.Array})]]
								ifFalse: [#(#{Core.ByteArray} #{Core.Utf8String} #{Core.Array} #{Core.Symbol} #{Core.AnsiString})])]!

newInFilerOn: aByteArray
	| stream inFiler |
	stream := aByteArray readStream.
	inFiler := self infilerClass on: stream.
	self initializeLocator: inFiler version.
	inFiler classLocator: locator.
	^inFiler!

newLocator: anInteger
	locator := nil.
	self initializeLocator: anInteger!

serialize: anObject version: anInteger
	self initializeLocator: anInteger.
	anObject isBehavior
		ifTrue: 
			[anObject isMeta
				ifTrue: 
					[locator
						includeClass: STBMetaclassProxy;
						includeClass: anObject instanceClass]
				ifFalse: 
					[locator
						includeClass: STBClassProxy;
						includeClass: anObject]]
		ifFalse: [locator includeClass: anObject class].
	^super serialize: anObject version: anInteger!

testBlockClass
	| bytes filer |
	bytes := self serialize: { self class. Core.Tests.DolphinTest. TestCase }.
	"Utf8String is required for the class names, and classes are represented by STBClassProxy. Then each specific class has to be allowed. Since we don't allow TestCase, an error is raised when it is encountered."
	self dumpToTranscriptIfDebug: bytes.
	filer := self infilerClass on: bytes readStream
				validClasses: { Array. Utf8String. #{Kernel.STBClassProxy}. self class. #{Core.Tests.DolphinTest} }.
	self
		should: [filer next]
		raise: STBError
		matching: 
			[:ex |
			ex description = 'STBFiler - Input stream contains an invalid class (XProgramming.SUnit.TestCase)']!

testClassProxy0
	self initializeLocator: 0.
	locator includeClass: STBClassProxy.
	super testClassProxy0!

testDisallowedPredefinedClass
	"Test error for a predefined class that is not among the allowed classes."

	| bytes subject |
	bytes := #[33 83 84 66 32 53 32 98 0 0 0 3 0 0 0 3 0 0 0 5 0 0 0 7 0 0 0].
	subject := self newInFilerOn: bytes.
	subject classLocator excludeClass: Array.
	self
		should: [subject next]
		raise: Error
		matching: [:ex | ex description = 'STBFiler - Input stream contains an invalid class (Core.Array)']!

testEggsBeforeChickenVersion0
	self initializeLocator: 0.
	locator includeClass: STBClassProxy.
	^super testEggsBeforeChickenVersion0!

testGlobalProxyingVersion0
	self initializeLocator: 0.
	locator includeClass: Smalltalk.STBGlobalObjectProxy.
	super testGlobalProxyingVersion0!

testGlobalProxyingVersion1
	self initializeLocator: 1.
	locator includeClass: Smalltalk.STBGlobalObjectProxy.
	super testGlobalProxyingVersion1!

testGlobalProxyingVersion3
	self initializeLocator: 3.
	locator includeClass: Smalltalk.STBGlobalObjectProxy; includeClass: Symbol.
	super testGlobalProxyingVersion3!

testGlobalProxyingVersion4
	self initializeLocator: 4.
	locator includeClass: Smalltalk.STBGlobalObjectProxy.
	super testGlobalProxyingVersion4!

testLargeIntegers0
	self initializeLocator: 0.
	locator includeClass: LargeInteger.
	super testLargeIntegers0!

testMetaclassProxy0
	self initializeLocator: 0.
	locator includeClass: STBMetaclassProxy.
	super testMetaclassProxy0!

testSecureByDefault
	"SmallIntegers, nil, true and false can always be loaded"

	#(123 nil true false) do: 
			[:each |
			| filer |
			filer := self infilerClass on: (self serialize: each) readStream.
			self assert: filer next equals: each].
	"But nothing else, not even a string, or array, and certainly not a class - not even the class of one of the default allowed types"
	{ 'foo'. #(123). #[123]. #foo. Symbol. 2 ** 64. 1 -> 2. Association class. UndefinedObject. True. False. SmallInteger } do: 
			[:each |
			| filer class serialised |
			serialised := self serialize: each.
			self dumpToTranscriptIfDebug: serialised.
			filer := self infilerClass on: serialised readStream.
			class := each isBehavior
						ifTrue: 
							[(filer predefinedClasses includes: each)
								ifTrue: [each]
								ifFalse: [each isMeta ifTrue: [STBMetaclassProxy] ifFalse: [STBClassProxy]]]
						ifFalse: [each class].
			self
				should: [filer next]
				raise: STBError
				matching: 
					[:ex |
					ex description = ('STBFiler - Input stream contains an invalid class (<1s>)' << class fullName)]].
	{ LookupTable with: 123 -> 456. IdentityDictionary with: 123 -> 456 } do: 
			[:each |
			| filer |
			filer := STBValidatingInFiler on: (self serialize: each) readStream.
			self
				should: [filer next]
				raise: STBError
				matching: 
					[:ex |
					ex description = ('STBFiler - Input stream contains an invalid class (<1s>)' << each class fullName)]]!

testSortedCollections
	self initializeLocator: STBOutFiler version.
	locator includeClass: STBSortedCollectionProxy.
	"The STBSortedCollectionProxy hasn't been changed from its original design, and writes out a class proxy for SortedCollection, which is a bit overkill but does allow for subclasses (in theory). Allowing class proxies is potentially insecure in an untrusted STB stream, but the class it is proxying (i.e. SortedCollection) still has to be allowed as well."
	locator includeClass: STBClassProxy.
	"Here the test is also serializing a pluggable algorithm with a block, which is not something one would want to allow in an untrusted stream in practice"
	locator includeClass: MergesortAlgorithm.
	locator includeClass: BlockClosure.	"Never do this"
	locator includeClass: CompiledMethod.	"Or this - allows loading of arbitrary code from the stream"
	locator includeClass: STBMetaclassProxy.	"The home method of the default sort block is a class method..."
	locator includeClass: PluggableSortAlgorithm.	"... of PluggableSortAlgorithm"
	super testSortedCollections!

testStringsVersion0
	self initializeLocator: 0.
	locator includeClass: #{Smalltalk.UnicodeString}.
	super testStringsVersion0!

testStringsVersion1
	self initializeLocator: 1.
	locator includeClass: #{Smalltalk.UnicodeString}.
	super testStringsVersion1!

testSymbolUpgrade
	"The point of this test is that the test STB stream contains the legacy symbol proxy"
	self initializeLocator: 0.
	locator includeClass: Symbol.
	super testSymbolUpgrade!

testTranscript
	self initializeLocator: STBOutFiler version.
	locator
		includeClass: STBSingletonProxy;
		includeClass: STBClassProxy;
		includeClass: UI.TranscriptShell.
	^super testTranscript!

testUnicodeStringUpgrade0
	self initializeLocator: 0.
	locator includeClass: 'UnicodeString'.
	^super testUnicodeStringUpgrade0!

testUnicodeStringUpgrade3
	self initializeLocator: 3.
	locator includeClass: 'UnicodeString'.
	^super testUnicodeStringUpgrade3!

testUnicodeStringVersion0
	self initializeLocator: 0.
	locator includeClass: #{Smalltalk.UnicodeString}.
	super testUnicodeStringVersion0!

testVariableBindingsVersion1
	self newLocator: 1.
	locator includeClasses: #(#{Core.Association} #{Kernel.STBClassProxy} #{Core.Object}).
	super testVariableBindingsVersion1!

testVariableBindingsVersion4
	self newLocator: 4.
	locator includeClasses: #(#{Kernel.VariableBinding} #{Core.Object} #{Kernel.STBClassProxy}).
	super testVariableBindingsVersion4!

testVariableBindingsVersion5
	self initializeLocator: 5.
	locator includeClass: VariableBinding!

verifyBindingReferencesAtVersion: anInteger
	self newLocator: anInteger.
	locator
		includeClass: STBClassProxy;
		includeClass: Object.
	super verifyBindingReferencesAtVersion: anInteger!

verifyByteArraysAtVersion: anInteger
	self newLocator: anInteger.
"	locator includeClass: (anInteger < 4 ifTrue: [#{Smalltalk.UnicodeString}] ifFalse: [Utf16String])."
	super verifyByteArraysAtVersion: anInteger
!

verifyDictionaries: aClass atVersion: anInteger
	self newLocator: anInteger.
	locator
		includeClass: Graphics.Point;
		includeClass: aClass new associationClass.
	anInteger < 4 ifTrue: [locator includeClass: Association].
	anInteger < 5 ifTrue: [locator includeClass: STBClassProxy].
	anInteger < 6
		ifTrue: 
			[locator
				includeClass: STBClassProxy;
				includeClass: STBCollectionProxy]
		ifFalse: 
			[locator
				includeClass: aClass;
				excludeClass: STBCollectionProxy].
	super verifyDictionaries: aClass atVersion: anInteger!

verifyEggsBeforeChicken: anInteger
	self newLocator: anInteger.
	locator includeClass: STBClassProxy!

verifyFloatsAtVersion: anInteger
	self initializeLocator: anInteger.
	locator includeClass: Float.
	super verifyFloatsAtVersion: anInteger!

verifyLargeIntegersAtVersion: anInteger
	self initializeLocator: anInteger.
	locator includeClass: LargeInteger.
	super verifyLargeIntegersAtVersion: anInteger!

verifyLookupTablesAtVersion: anInteger
	self newLocator: anInteger.
	locator includeClass: Graphics.Point.
	anInteger < 1 ifTrue: [locator includeClass: STBClassProxy].
	anInteger < 6
		ifTrue: [locator includeClass: STBIdentityDictionaryProxy]
		ifFalse: [locator excludeClass: STBIdentityDictionaryProxy].
	super verifyLookupTablesAtVersion: anInteger!

verifyOrderedCollectionsAtVersion: anInteger
	self newLocator: anInteger.
	anInteger < 1 ifTrue: [locator includeClass: STBClassProxy].
	anInteger < 6
		ifTrue: [locator includeClass: STBCollectionProxy]
		ifFalse: [locator excludeClass: STBCollectionProxy].
	super verifyOrderedCollectionsAtVersion: anInteger!

verifyResourceLibraryAtVersion: anInteger
	self initializeLocator: anInteger.
	anInteger < 6
		ifTrue: 
			[locator includeClass: STBExternalResourceLibraryProxy.
			anInteger < 4
				ifTrue: 
					[locator
						includeClass: #{Smalltalk.UnicodeString};
						includeClass: String]]
		ifFalse: [locator includeClass: ResourceLibrary].
	super verifyResourceLibraryAtVersion: anInteger!

verifyRoundTripSingleton: anObject version: anInteger expected: aByteArray
	self initializeLocator: anInteger.
	locator includeClass: anObject class.
	anInteger >= 6
		ifTrue: 
			[locator
				includeClass: STBStaticVariableProxy;
				includeClass: Kernel.FullBindingReference]
		ifFalse: 
			[locator
				includeClass: STBSingletonProxy;
				includeClass: STBClassProxy].
	super
		verifyRoundTripSingleton: anObject
		version: anInteger
		expected: aByteArray!

verifySaveStaticVariableReferenceAtVersion: anInteger
	self initializeLocator: anInteger.
	locator
		includeClass: STBStaticVariableProxy;
		includeClass: Kernel.FullBindingReference.
	super verifySaveStaticVariableReferenceAtVersion: anInteger!

verifyScaledDecimalsAtVersion: anInteger
	self initializeLocator: anInteger.
	locator includeClass: ScaledDecimal; includeClass: Fraction.
	super verifyScaledDecimalsAtVersion: anInteger!

verifySetsAtVersion: anInteger
	self newLocator: anInteger.
	locator includeClass: Core.Symbol.
	anInteger < 6
		ifTrue: 
			[locator
				includeClass: STBClassProxy;
				includeClass: STBCollectionProxy]
		ifFalse: 
			[locator
				excludeClass: STBClassProxy;
				excludeClass: STBCollectionProxy].
	super verifySetsAtVersion: anInteger!

verifyStrings: anArray atVersion: anInteger
	self newLocator: anInteger.
	locator includeClass: (anInteger < 4 ifTrue: [#{Smalltalk.UnicodeString}] ifFalse: [Utf16String]).
	super verifyStrings: anArray atVersion: anInteger!

verifySymbolsAtVersion: anInteger
	self newLocator: anInteger.
	anInteger > 1 ifTrue: [locator includeClass: Symbol].
	super verifySymbolsAtVersion: anInteger!

verifyTranscriptRoundTripAtVersion: anInteger 
	self newLocator: anInteger.
	^super verifyTranscriptRoundTripAtVersion: anInteger!

verifyVariableBindingsAtVersion: anInteger
	self newLocator: anInteger.
	locator includeClass: STBClassProxy.
	anInteger < 4
		ifTrue: [locator includeClass: Association]
		ifFalse: 
			[locator
				includeClass: Core;
				includeClass: Core.String].
	locator
		includeClass: Object;
		includeClass: Symbol.
	super verifyVariableBindingsAtVersion: anInteger! !

!Kernel.Tests.STBValidatingInFilerTest categoriesForMethods!
infilerClass!helpers!private! !
initializeLocator:!private!running! !
newInFilerOn:!helpers!private! !
newLocator:!helpers!private! !
serialize:version:!helpers!private! !
testBlockClass!public!unit tests! !
testClassProxy0!public!unit tests! !
testDisallowedPredefinedClass!public!unit tests! !
testEggsBeforeChickenVersion0!public!unit tests! !
testGlobalProxyingVersion0!public!unit tests! !
testGlobalProxyingVersion1!public!unit tests! !
testGlobalProxyingVersion3!public!unit tests! !
testGlobalProxyingVersion4!public!unit tests! !
testLargeIntegers0!public!unit tests! !
testMetaclassProxy0!public!unit tests! !
testSecureByDefault!public!unit tests! !
testSortedCollections!public!unit tests! !
testStringsVersion0!public!unit tests! !
testStringsVersion1!public!unit tests! !
testSymbolUpgrade!public!unit tests! !
testTranscript!public!unit tests! !
testUnicodeStringUpgrade0!public! !
testUnicodeStringUpgrade3!public! !
testUnicodeStringVersion0!public!unit tests! !
testVariableBindingsVersion1!public! !
testVariableBindingsVersion4!public! !
testVariableBindingsVersion5!public! !
verifyBindingReferencesAtVersion:!helpers!private! !
verifyByteArraysAtVersion:!helpers!private! !
verifyDictionaries:atVersion:!helpers!private! !
verifyEggsBeforeChicken:!helpers!private! !
verifyFloatsAtVersion:!helpers!private! !
verifyLargeIntegersAtVersion:!helpers!private! !
verifyLookupTablesAtVersion:!helpers!private! !
verifyOrderedCollectionsAtVersion:!helpers!private! !
verifyResourceLibraryAtVersion:!helpers!private! !
verifyRoundTripSingleton:version:expected:!helpers!private! !
verifySaveStaticVariableReferenceAtVersion:!helpers!private! !
verifyScaledDecimalsAtVersion:!helpers!private! !
verifySetsAtVersion:!helpers!private! !
verifyStrings:atVersion:!helpers!private! !
verifySymbolsAtVersion:!helpers!private! !
verifyTranscriptRoundTripAtVersion:!public! !
verifyVariableBindingsAtVersion:!helpers!private! !
!

