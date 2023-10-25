"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler0
	subclass: #'Kernel.STBInFiler1'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBInFiler1 guid: (Core.GUID fromString: '{7b25c85f-974d-4429-aba7-bbe2323a30f0}')!
Kernel.STBInFiler1 comment: '`STBInFiler1` is an `STBInFiler` for reading STB 1 binary object serialization format.

STB 1 was introduced in Dolphin 5. It differed little from STB 0, but included pre-registration of some classes to fix a chicken-before-egg problem but also to reduce the size of the STB streams.'!
!Kernel.STBInFiler1 methodsFor!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef! !
!Kernel.STBInFiler1 categoriesForMethods!
lastPredefined!constants!private! !
!

!Kernel.STBInFiler1 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

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

uninitialize
	self unregister!

version
	^1! !
!Kernel.STBInFiler1 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

