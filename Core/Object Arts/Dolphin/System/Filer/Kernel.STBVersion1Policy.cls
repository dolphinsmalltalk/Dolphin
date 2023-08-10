"Filed out from Dolphin Smalltalk"!

Kernel.STBVersion0Policy
	subclass: #'Kernel.STBVersion1Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion1Policy guid: (Core.GUID fromString: '{2e444423-06ca-467d-8a6b-fd12b1d095d1}')!
Kernel.STBVersion1Policy comment: '`STBVersion1Policy` is the the policy/strateger plugin for writing and reading the STB v1 serialization format.

This was the format used in Dolphin 5.x. It differed from v0 in the following ways:
  - Some commonly used and pre-requisite classes were pre-registered, fixing some obscure chicken-before-egg issues.
  - `String` was pre-registered, but the rarely used `UnicodeString` was not. `String` was effectively equivalent to `AnsiString` in Dolphin post the addition of full Unicode support in 7.1, and `UnicodeString` was the predecessor of `Utf16String`.

'!
!Kernel.STBVersion1Policy methodsFor!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB v1 file. These make it possible to binary file the classes STBClassProxy and String. Also these clases are almost always needed, so we can save space pre-registering them so that they	don't need to be written into the filer."

	"Note that pre-registering classes does not inflate the size of the binary file, it just pre-allocates a range of indices for fixed uses. Changing the order of these (or deleting registrations) will break existing binary files. Lastly a consequence of pre-registering these classes is that normal STB versioning will have no effect - the #stbVersion is only checked when a class is first read from the file. In order to version these classes it is	necessary to increment the global STB version number."

	^##({
		AnsiString.
		Array.
		ByteArray.
		LargeInteger.
		STBClassProxy.
		STBMetaclassProxy.
		Smalltalk.STBSymbolProxy.
		STBCollectionProxy.
		OrderedCollection.
		STBIdentityDictionaryProxy.
		LookupTable.
		IdentityDictionary
	})!

saveString: aString
	"In STB 1, String was pre-registered but UnicodeString was not. We map byte strings to the pre-registered AnsiString, and register Utf16String in the place of UnicodeString, but write a locator for UnicodeString."

	| bytes |
	aString basicClass == Utf16String
		ifTrue: 
			[(filer refForObject: Utf16String)
				ifNotNil: [:refIndex | self writeClassReference: refIndex prefix: PrefixDataMask]
				ifNil: 
					[stream
						nextInt32Put: (##(PrefixClassMask | PrefixBytesMask) bitOr: ##(13 bitShift: PrefixLocatorLenShift));
						nextPutAll: ##('UnicodeString' asByteArray).
					filer register: Utf16String].
			bytes := aString asByteArray]
		ifFalse: 
			[self writeClassReference: (filer refForObject: AnsiString) prefix: PrefixDataMask.
			bytes := aString asAnsiString asByteArray].
	filer register: aString.
	self writeByteObject: bytes! !
!Kernel.STBVersion1Policy categoriesForMethods!
lastPredefined!constants!public! !
predefinedClasses!constants!public! !
saveString:!binary filing!public! !
!

!Kernel.STBVersion1Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^1! !
!Kernel.STBVersion1Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

