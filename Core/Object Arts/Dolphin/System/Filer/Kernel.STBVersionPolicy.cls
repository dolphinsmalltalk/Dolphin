"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STBVersionPolicy'
	instanceVariableNames: 'filer stream version'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'version signatureBytes'
	classConstants: { 'LastPredefinedClassRef' -> 16r18 }!
Kernel.STBVersionPolicy guid: (Core.GUID fromString: '{c3707a61-0143-415a-b869-e30ff4ad09bd}')!
Kernel.STBVersionPolicy isNonInstantiable: true!
Kernel.STBVersionPolicy comment: ''!
!Kernel.STBVersionPolicy methodsFor!

classLocatorStringFor: aClass
	^(Smalltalk oldNames lookup: aClass)
		ifNil: 
			[| name |
			name := aClass shortName.
			(BindingReference isQualifiedName: name)
				ifTrue: 
					[STBError
						signal: '<1p> does not have an unqualified short name for use in version <2d> object stream'
								<< { aClass. self version }]
				ifFalse: [name]]!

filer: anSTBFiler version: anInteger
	filer := anSTBFiler.
	"The stream is cached locally for perf reasons only"
	stream := anSTBFiler stream.
	version := anInteger!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^self subclassResponsibility!

on: aStream version: anInteger
	stream := aStream.
	version := anInteger!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file. 
	For STB, these make it possible to binary file the classes STBClassProxy and String. Also these clases are almost always needed, so we can save space pre-registering them so that they don't need to be written into the filer.
	STL does not require the STB class proxies, and stores strings as literals, so it does not require pre-registration of classes. There reamains a small compactness benefit, but it makes it harder to find class references in resources so has been dropped from STL 6."

	"Note that pre-registering classes does not inflate the size of the binary file, it just pre-allocates a range of indices for fixed uses. Changing the order of these (or deleting registrations) will break existing binary files. Lastly a consequence of pre-registering these classes is that normal STB versioning will have no effect - the #stbVersion is only checked when a class is first read from the file. In order to version these classes it is necessary to increment the global STB version number."

	^self subclassResponsibility!

putCharacter: aCharacter
	self subclassResponsibility!

putNil
	self subclassResponsibility!

putSmallInteger: aSmallInteger
	self subclassResponsibility!

readByteObject: aByteObject
	self subclassResponsibility!

readClassDataWithPrefix: anInteger
	^self subclassResponsibility!

readInteger
	self subclassResponsibility!

readObjectSize: aClass
	^self subclassResponsibility!

readObjectWithPrefix: anInteger
	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(anInteger allMask: STBFiler.PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: STBFiler.PrefixDataMask)
		ifFalse: 
			[^(anInteger allMask: STBFiler.PrefixCharacterMask)
				ifTrue: [Character value: (anInteger bitShift: STBFiler.PrefixRefUnshift)]
				ifFalse: [filer objectAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: STBFiler.PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: [filer classAt: (anInteger bitShift: STBFiler.PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class stbReadFrom: filer format: (filer converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex!

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

serializeObject: anObject
	self subclassResponsibility!

version
	^version!

writeByteObject: aByteObject
	self subclassResponsibility!

writeClass: aClass
	self subclassResponsibility!

writeClassReference: anInteger
	self subclassResponsibility!

writeInteger: anInteger
	self subclassResponsibility!

writeReference: anInteger
	self subclassResponsibility!

writeSignatureAndVersion
	self subclassResponsibility! !
!Kernel.STBVersionPolicy categoriesForMethods!
classLocatorStringFor:!helpers!private! !
filer:version:!initializing!private! !
lastPredefined!constants!public! !
on:version:!initializing!private! !
predefinedClasses!constants!public! !
putCharacter:!operations!public! !
putNil!operations!public! !
putSmallInteger:!operations!public! !
readByteObject:!operations!public! !
readClassDataWithPrefix:!operations!public! !
readInteger!operations!public! !
readObjectSize:!operations!public! !
readObjectWithPrefix:!accessing!public! !
registerPredefined:!initializing!public! !
registerPredefinedClasses:!initializing!private! !
registerPredefinedObjects:!initializing!private! !
serializeObject:!operations!private! !
version!accessing!public! !
writeByteObject:!operations!public! !
writeClass:!operations!private! !
writeClassReference:!operations!public! !
writeInteger:!operations!public! !
writeReference:!operations!public! !
writeSignatureAndVersion!operations!public! !
!

!Kernel.STBVersionPolicy class methodsFor!

classForVersion: anInteger
	^(self versions lookup: anInteger + 1)
		ifNil: 
			[STBError
				signal: 'Unsupported <2s> format (version <1d>)' << { anInteger. self name copyFrom: 1 to: 3 }]!

filer: anSTBFiler version: anInteger
	^(self classForVersion: anInteger)
		new filer: anSTBFiler version: anInteger!

readVersionFrom: aByteStream
	^self subclassResponsibility!

versions
	^self subclassResponsibility! !
!Kernel.STBVersionPolicy class categoriesForMethods!
classForVersion:!accessing!public! !
filer:version:!instance creation!public! !
readVersionFrom:!instance creation!public! !
versions!accessing!public! !
!

