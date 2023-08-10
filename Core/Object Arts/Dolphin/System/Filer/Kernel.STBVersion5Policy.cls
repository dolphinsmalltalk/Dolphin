"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicy
	subclass: #'Kernel.STBVersion5Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion5Policy guid: (Core.GUID fromString: '{5514d6ae-d32f-459b-8eb4-79c07ca815a1}')!
Kernel.STBVersion5Policy comment: ''!
!Kernel.STBVersion5Policy methodsFor!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB v5 file. Same as STB v4."

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
		IdentityDictionary.
		Utf8String.
		Utf16String
	})!

readCollection: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement!

saveLookupTable: aLookupTable
	self saveObject: aLookupTable as: (STBIdentityDictionaryProxy forCollection: aLookupTable)!

saveResourceLibrary: aResourceLibrary
	self saveObject: aResourceLibrary as: (STBExternalResourceLibraryProxy forLibrary: aResourceLibrary)! !
!Kernel.STBVersion5Policy categoriesForMethods!
predefinedClasses!constants!public! !
readCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
saveLookupTable:!operations!public! !
saveResourceLibrary:!binary filing!public! !
!

!Kernel.STBVersion5Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^5! !
!Kernel.STBVersion5Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

