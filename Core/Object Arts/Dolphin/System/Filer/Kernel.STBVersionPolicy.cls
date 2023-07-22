"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STBVersionPolicy'
	instanceVariableNames: 'version'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'version signatureBytes'
	classConstants: {
			'FirstPredefinedClassRef' -> 16r5.
			'LastPredefinedClassRef' -> 16r18.
			'PredefinedClasses' -> {
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
					}
		}!
Kernel.STBVersionPolicy guid: (Core.GUID fromString: '{c3707a61-0143-415a-b869-e30ff4ad09bd}')!
Kernel.STBVersionPolicy isNonInstantiable: true!
Kernel.STBVersionPolicy comment: ''!
!Kernel.STBVersionPolicy methodsFor!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^self subclassResponsibility!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file. 
	For STB, these make it possible to binary file the classes STBClassProxy and String. Also these clases are almost always needed, so we can save space pre-registering them so that they don't need to be written into the filer.
	STL does not require the STB class proxies, and stores strings as literals, so it does not require pre-registration of classes. There reamains a small compactness benefit, but it makes it harder to find class references in resources so has been dropped from STL 6."

	"Note that pre-registering classes does not inflate the size of the binary file, it just pre-allocates a range of indices for fixed uses. Changing the order of these (or deleting registrations) will break existing binary files. Lastly a consequence of pre-registering these classes is that normal STB versioning will have no effect - the #stbVersion is only checked when a class is first read from the file. In order to version these classes it is necessary to increment the global STB version number."

	^self subclassResponsibility!

putCharacter: aCharacter on: aPuttableStream
	self subclassResponsibility!

putNilOn: aPuttableStream
	self subclassResponsibility!

putSmallInteger: aSmallInteger on: aStream
	self subclassResponsibility!

readClassData: anSTBFiler prefix: anInteger
	^self subclassResponsibility!

readIntegerFrom: aGettableStream
	self subclassResponsibility!

readObject: anSTBInFiler withPrefix: anInteger
	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(anInteger allMask: STBFiler.PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: STBFiler.PrefixDataMask)
		ifFalse: 
			[^(anInteger allMask: STBFiler.PrefixCharacterMask)
				ifTrue: [Character value: (anInteger bitShift: STBFiler.PrefixRefUnshift)]
				ifFalse: [anSTBInFiler objectAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBFiler.PrefixClassMask)
				ifTrue: [self readClassData: anSTBInFiler prefix: anInteger]
				ifFalse: [anSTBInFiler classAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := anSTBInFiler readMap size + 1.
	anObject := class stbReadFrom: anSTBInFiler format: (anSTBInFiler converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: anSTBInFiler at: newObjectIndex!

readObjectSize: aClass from: aPositionableStream
	^aPositionableStream nextInt32!

registerPredefined: anSTBFiler
	self registerPredefinedObjects: anSTBFiler.
	self registerPredefinedClasses: anSTBFiler!

registerPredefinedClasses: anSTBFiler
	anSTBFiler
		registerAllClasses: self predefinedClasses;
		setRefOffset: self lastPredefined!

registerPredefinedObjects: anSTBFiler
	"Private - We pre-register objects that must never be recreated - note	that if the 'fixed' list of pre-registered objects is changed, then the STB version must be
	changed and an upgrade mechanism put in place."

	anSTBFiler
		register: true;
		register: false;
		register: Smalltalk;
		register: Processor!

serializeObject: anObject with: anSTxOutFiler
	self subclassResponsibility!

version
	^version!

version: anInteger
	version := anInteger!

writeClass: aClass on: aStream
	self subclassResponsibility!

writeClassReference: refIndex on: aStream
	self subclassResponsibility!

writeInteger: anInteger on: aPuttableStream
	self subclassResponsibility!

writeReference: refIndex on: aStream
	self subclassResponsibility!

writeSignatureAndVersionOn: aPuttableStream
	self subclassResponsibility! !
!Kernel.STBVersionPolicy categoriesForMethods!
lastPredefined!constants!public! !
predefinedClasses!constants!public! !
putCharacter:on:!helpers!public! !
putNilOn:!operations!public! !
putSmallInteger:on:!operations!public! !
readClassData:prefix:!helpers!public! !
readIntegerFrom:!operations!public! !
readObject:withPrefix:!accessing!public! !
readObjectSize:from:!operations!public! !
registerPredefined:!public! !
registerPredefinedClasses:!operations!private! !
registerPredefinedObjects:!operations!private! !
serializeObject:with:!operations!private! !
version!accessing!public! !
version:!initializing!private! !
writeClass:on:!operations!private! !
writeClassReference:on:!operations!public! !
writeInteger:on:!operations!public! !
writeReference:on:!operations!public! !
writeSignatureAndVersionOn:!operations!public! !
!

!Kernel.STBVersionPolicy class methodsFor!

forVersion: anInteger
	^(self versions lookup: anInteger + 1)
		ifNil: 
			[STBError
				signal: 'Unsupported <2s> format (version <1d>)' << { anInteger. self name copyFrom: 1 to: 3 }]!

initialize
	self addClassConstant: 'PredefinedClasses'
		value: {
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
			}!

readVersionFrom: aByteStream
	^self subclassResponsibility!

versions
	^self subclassResponsibility! !
!Kernel.STBVersionPolicy class categoriesForMethods!
forVersion:!accessing!public! !
initialize!public! !
readVersionFrom:!instance creation!public! !
versions!accessing!public! !
!

