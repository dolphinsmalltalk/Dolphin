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

newTestSubject: aByteArray
	| stream |
	stream := aByteArray readStream.
	^(STBValidatingInFiler on: stream)
		context: nil;
		classLocator: locator;
		yourself!

serialize: anObject
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
	^anObject binaryStoreBytes!

setUp
	super setUp.
	"Additional classes are derestricted in specific tests, or if #serialized:"
	locator := RestrictedClassLocator forClasses: #(#{Core.ByteArray} #{Core.Utf8String} #{Core.Array} #{Core.Symbol} #{Core.String} #{Core.AnsiString})!

testArrayClass0
	"In the original STB version, String and STBClassFormat classes could not be deserialised from the STB bytes. This was fixed in v1 by pre-registering certain classes."

	locator includeClass: STBClassProxy.
	super testArrayClass0!

testArrayMetaclass0
	locator includeClass: STBMetaclassProxy.
	super testArrayMetaclass0!

testBlockClass
	| bytes filer |
	bytes := self serialize: { self class. Core.Tests.DolphinTest. TestCase }.
	"Utf8String is required for the class names, and classes are represented by STBClassProxy. Then each specific class has to be allowed. Since we don't allow TestCase, an error is raised when it is encountered."
	"(Tools.STBDebugger on: bytes readStream) traceStream: Transcript; dump"
	filer := (STBValidatingInFiler on: bytes readStream)
				validClasses: { Array. Utf8String. #{Kernel.STBClassProxy}. self class. #{Core.Tests.DolphinTest} };
				yourself.
	self
		should: [filer next]
		raise: STBError
		matching: 
			[:ex |
			ex description = 'STBFiler - Input stream contains an invalid class (XProgramming.SUnit.TestCase)']!

testEggsBeforeChicken
	"In the original STB version, there was an obscure boundary case where String and STBClassFormat classes could not be deserialised from the STB bytes. This was fixed in v1 by pre-registering certain classes."

	locator includeClass: STBClassProxy.
	super testEggsBeforeChicken!

testEggsBeforeChickenVersion0
	locator includeClass: STBClassProxy.
	^super testEggsBeforeChickenVersion0!

testSecureByDefault
	"SmallIntegers and nil can always be loaded"

	#(123 nil) do: 
			[:each |
			| filer |
			filer := STBValidatingInFiler on: 123 binaryStoreBytes readStream.
			self assert: filer next equals: 123].
	"But nothing else, not even a string, or array, and certainly not a class"
	{
		'foo'.
		#(123).
		#[123].
		#foo.
		Symbol.
		2 ** 64.
		1 -> 2.
		Association class
	} do: 
				[:each |
				| filer class serialised |
				serialised := each binaryStoreBytes.
				"(Tools.STBDebugger on: serialised readStream) traceStream: Transcript; dump"
				filer := STBValidatingInFiler on: serialised readStream.
				class := each isBehavior
							ifTrue: 
								[(filer policy predefinedClasses includes: each)
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
			filer := STBValidatingInFiler on: each binaryStoreBytes readStream.
			self
				should: [filer next]
				raise: STBError
				matching: 
					[:ex |
					ex description
						= 'STBFiler - Input stream contains an invalid class (Kernel.STBIdentityDictionaryProxy)']]!

testSortedCollection
	locator includeClass: STBSortedCollectionProxy.
	"The STBSortedCollectionProxy hasn't been changed from its original design, and writes out a class proxy for SortedCollection, which is a bit overkill but does allow for subclasses (in theory). Allowing class proxies is potentially insecure in an untrusted STB stream, but the class it is proxying (i.e. SortedCollection) still has to be allowed as well."
	locator includeClass: STBClassProxy.
	"Here the test is also serializing a pluggable algorithm with a block, which is not something one would want to allow in an untrusted stream in practice"
	locator includeClass: MergesortAlgorithm.
	locator includeClass: BlockClosure.	"Never do this"
	locator includeClass: CompiledMethod.	"Or this - allows loading of arbitrary code from the stream"
	locator includeClass: STBMetaclassProxy.	"The home method of the default sort block is a class method..."
	locator includeClass: PluggableSortAlgorithm.	"... of PluggableSortAlgorithm"
	super testSortedCollection!

testSymbolUpgrade
	"The point of this test is that the test STB stream contains the legacy symbol proxy"
	locator includeClass: Smalltalk.STBSymbolProxy.
	^super testSymbolUpgrade!

testTranscript
	locator
		includeClass: STBSingletonProxy;
		includeClass: STBClassProxy;
		includeClass: UI.TranscriptShell.
	^super testTranscript!

testUnicodeStringUpgrade
	locator includeClass: 'UnicodeString'.
	^super testUnicodeStringUpgrade! !
!Kernel.Tests.STBValidatingInFilerTest categoriesForMethods!
newTestSubject:!helpers!private! !
serialize:!helpers!private! !
setUp!public!running! !
testArrayClass0!public!unit tests! !
testArrayMetaclass0!public!unit tests! !
testBlockClass!public!unit tests! !
testEggsBeforeChicken!public!unit tests! !
testEggsBeforeChickenVersion0!public!unit tests! !
testSecureByDefault!public!unit tests! !
testSortedCollection!public!unit tests! !
testSymbolUpgrade!public!unit tests! !
testTranscript!public!unit tests! !
testUnicodeStringUpgrade!public!unit tests! !
!

