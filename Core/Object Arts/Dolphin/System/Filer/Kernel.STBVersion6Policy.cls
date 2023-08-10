"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicy
	subclass: #'Kernel.STBVersion6Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion6Policy guid: (Core.GUID fromString: '{06b49981-a085-480c-a078-0131fb4389bc}')!
Kernel.STBVersion6Policy comment: ''!
!Kernel.STBVersion6Policy methodsFor!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB v6 file. 
	The collection proxies are no longer used."

	^##({
		AnsiString.
		Array.
		ByteArray.
		LargeInteger.
		STBClassProxy.
		STBMetaclassProxy.
		Symbol.
		#{Kernel.STBCollectionProxy}.
		OrderedCollection.
		#{Kernel.STBIdentityDictionaryProxy}.
		LookupTable.
		IdentityDictionary.
		Utf8String.
		Utf16String
	})!

readCollection: aClass format: anSTBClassConversion size: anInteger
	| set |
	set := aClass new: anInteger.
	filer register: set.
	anInteger timesRepeat: [set add: filer basicNext].
	^set!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"LookupTables have a proxy-less representation in version 6. The format is the the class name and size (already read), followed by a sequence of key-value pairs emitted directly into the STB stream."

	| lookupTable |
	lookupTable := aClass new: anInteger.
	filer register: lookupTable.
	anInteger timesRepeat: [lookupTable at: filer basicNext put: filer basicNext].
	^lookupTable!

saveCollection: aCollection
	"STx version 6 no longer uses the collection proxies."

	self writePreambleFor: aCollection class: aCollection basicClass.
	stream nextInt32Put: aCollection size.
	aCollection do: [:each | filer nextPut: each]!

saveLookupTable: aLookupTable
	"STx version 6 no longer uses the collection proxies."

	self writePreambleFor: aLookupTable class: aLookupTable basicClass.
	stream nextInt32Put: aLookupTable size.
	aLookupTable keysAndValuesDo: 
			[:eachKey :eachValue |
			filer
				nextPut: eachKey;
				nextPut: eachValue]!

saveSet: aSet elements: aCollection
	self writePreambleFor: aSet class: aSet basicClass.
	stream nextInt32Put: aCollection size.
	aCollection do: [:each | filer nextPut: each]! !
!Kernel.STBVersion6Policy categoriesForMethods!
predefinedClasses!constants!public! !
readCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
saveCollection:!operations!public! !
saveLookupTable:!operations!public! !
saveSet:elements:!operations!public! !
!

!Kernel.STBVersion6Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^6! !
!Kernel.STBVersion6Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

