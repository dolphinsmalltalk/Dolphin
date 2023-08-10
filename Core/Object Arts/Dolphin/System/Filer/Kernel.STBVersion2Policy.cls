"Filed out from Dolphin Smalltalk"!

Kernel.STBVersion1Policy
	subclass: #'Kernel.STBVersion2Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion2Policy guid: (Core.GUID fromString: '{d8774fdb-db59-4b99-a873-184bd5ea624e}')!
Kernel.STBVersion2Policy comment: ''!
!Kernel.STBVersion2Policy methodsFor!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB v2 file. STBSymbolProxy no longer used so slot re-used for Symbol class."

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

saveSymbol: aSymbol
	"Symbols were no longer proxied - newly deserialised objects are all sent #stbFixup:at:, so there is no need to use proxies just to perform fixup."

	| size string |
	self writeClassReference: (filer refForObject: Symbol) prefix: PrefixDataMask.
	filer register: aSymbol.
	string := aSymbol asAnsiString.
	size := string basicSize.
	stream nextInt32Put: size.
	1 to: size do: [:i | stream nextPut: (string basicAt: i)]! !
!Kernel.STBVersion2Policy categoriesForMethods!
predefinedClasses!constants!public! !
saveSymbol:!binary filing!public! !
!

!Kernel.STBVersion2Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^2! !
!Kernel.STBVersion2Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

