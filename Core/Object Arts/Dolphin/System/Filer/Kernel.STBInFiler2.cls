"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler1
	subclass: #'Kernel.STBInFiler2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBInFiler2 guid: (Core.GUID fromString: '{d8d3dab7-0798-4c4a-b684-fcdc42f8933b}')!
Kernel.STBInFiler2 comment: '`STBInFiler2` is an `STBInFiler` for reading the STB 2 binary object serialization format.

The key difference from STB 1 was that loading of objects was delegated to the object class. This remove the requirement to use proxies in many cases, although the pre-existing proxies largely remained. Only `STBSymbolProxy` became obsolete, with `Symbol`s being stored directly.'!
!Kernel.STBInFiler2 methodsFor!

readSymbol: aSTxClassConversion
	"Deserialize a <Symbol> from the object stream."

	"In STB 2 & 3, Symbols were no longer proxied, but were ANSI encoded"

	| size symbol |
	size := stream nextInt32.
	symbol := Symbol intern: (self readBytes: size into: (AnsiString new: size)).
	decorator register: symbol.
	^symbol! !
!Kernel.STBInFiler2 categoriesForMethods!
readSymbol:!deserializing!public! !
!

!Kernel.STBInFiler2 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB 2 file."

	"Difference from STB 1 is that Symbol replaced STBSymbolProxy since the latter is no longer used."

	^##({
		AnsiString.
		Array.
		ByteArray.
		LargeInteger.
		STBClassProxy.
		STBMetaclassProxy.
		Symbol.
		STBCollectionProxy.
		OrderedCollection.
		STBIdentityDictionaryProxy.
		LookupTable.
		IdentityDictionary
	})!

uninitialize
	self unregister!

version
	^2! !
!Kernel.STBInFiler2 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

