"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STxFiler'
	instanceVariableNames: 'stream predefinedClassOffset flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'LastPredefinedClassRef' -> 16r18.
			'PrefixBytesMask' -> 16r30.
			'PrefixCharacterMask' -> 16r4.
			'PrefixClassMask' -> 16r6.
			'PrefixDataMask' -> 16r2.
			'PrefixInstSizeMask' -> 16rFF.
			'PrefixInstSizeShift' -> 16r8.
			'PrefixInstSizeUnshift' -> -16r8.
			'PrefixLiteralMask' -> 16r8.
			'PrefixLocatorLenShift' -> 16r10.
			'PrefixLocatorLenUnshift' -> -16r10.
			'PrefixNonZeroVersionMask' -> 16r40.
			'PrefixProxyMask' -> 16r8.
			'PrefixRefShift' -> 16r4.
			'PrefixRefUnshift' -> -16r4.
			'PrefixSmallIntegerMask' -> 16r1.
			'PrefixVariableMask' -> 16r20
		}!

Kernel.STxFiler guid: (Core.GUID fromString: '{87b4c4c1-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.STxFiler isNonInstantiable: true!

Kernel.STxFiler comment: '`STxFiler` is the abstract class of object serializers and deserializers for writing and reading in STB and STL formats. There are concrete classes for both reading and writing of each version from the original STB v0 up to the current version.

Note that whilst the writing of the historic formats is supported, the format of the classes themselves in the image may have changed, so forwards compatibility is limited. Backwards compatibility (i.e. reading old formats) should be complete by virtue of this hierarchy of classes and the class specific conversions as implemented by each class'' `stbConvertFrom:` method.

## Instance Variables:
  `stream`					`<puttableStream>`. Stream to/from which objects are serialized/deserialized.
  `predefinedClassOffset`		`<integer>`. Offset of first predefined class in the object map.

'!

!Kernel.STxFiler categoriesForClass!System-Binary storage! !

!Kernel.STxFiler methodsFor!

atEnd
	"Answer true if the receiver is positioned at end of its stream."

	^stream atEnd

!

defaultFlags
	^0!

initialize
	flags := self defaultFlags.
	self reset.
	^self!

isSTL
	^self stxFormatName = 'STL'
!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

locatorKeyFor: aClass
	"Answer a <String> name for the <Class> argument that receiver's class locator can use to resolve the class."

	"In STB v5+, class locator strings are full names in order to disambiguate classes that might have the same unqualified name but reside in different namespaces."

	^aClass fullName!

position: anInteger
	"Position the receiver's stream to anInteger, read/write a header at this
	place and prepare it for a new input or output session."

	stream position: anInteger.
	self reset.!

predefinedClasses
	"Private - Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB file. 
	For STB, these make it possible to binary file the classes STBClassProxy and String. Also these clases are almost always needed, so we can save space pre-registering them so that they don't need to be written into the filer.
	STL does not require the STB class proxies, and stores strings as literals, so it does not require pre-registration of classes. There reamains a small compactness benefit, but it makes it harder to find class references in resources so has been dropped from STL 6."

	"Note that pre-registering classes does not inflate the size of the binary file, it just pre-allocates a range of indices for fixed uses. Changing the order of these (or deleting registrations) will break existing binary files. Lastly a consequence of pre-registering these classes is that normal STB versioning will have no effect - the #stbVersion is only checked when a class is first read from the file. In order to version pre-registered classes it is necessary to increment the global STB version number."

	^self subclassResponsibility!

preNamespaceLocatorKeyFor: aClass
	^(Smalltalk oldNames lookup: aClass) ifNil: [self unqualifiedShortNameOfClass: aClass]!

preUtfStringsLocatorKeyFor: aClass
	aClass == Utf16String ifTrue: [^'UnicodeString'].
	aClass == AnsiString ifTrue: [^'String'].
	^(Smalltalk oldNames lookup: aClass) ifNil: [self unqualifiedShortNameOfClass: aClass]!

register: anObject 
	"Register an object has having been seen before in the STB stream. Answer the unique object reference."

	^self subclassResponsibility!

registerPredefined
	self
		registerPredefinedObjects;
		registerPredefinedClasses!

registerPredefinedClasses
	self subclassResponsibility!

registerPredefinedObjects
	"Private - We pre-register objects that must never be recreated - note that if the 'fixed' list of pre-registered objects is changed, then the STB version must be
	changed and an upgrade mechanism put in place."

	self
		register: true;
		register: false;
		register: Smalltalk;
		register: Processor!

reset
	"Private - Reset the instance."

	self subclassResponsibility!

stream
	"Answer the stream to which the receiver is attached."

	^stream!

stxFormatName
	"Answer the format name, either STB or STL."

	^self class stxFormatName!

unqualifiedShortNameOfClass: aClass
	| name |
	name := aClass shortName asString.
	^(BindingReference isQualifiedName: name)
		ifTrue: 
			[STBError
				signal: '<1p> does not have an unqualified short name for use in a version <2d> <3s> stream'
						<< { aClass. self version. self stxFormatName }]
		ifFalse: [name]!

version
	"Answer the format version of the STB stream."

	^self class version! !

!Kernel.STxFiler categoriesForMethods!
atEnd!public!testing! !
defaultFlags!constants!private! !
initialize!initializing!private! !
isSTL!public!testing! !
lastPredefined!constants!private! !
locatorKeyFor:!helpers!public! !
position:!positioning!public! !
predefinedClasses!constants!private! !
preNamespaceLocatorKeyFor:!helpers!private! !
preUtfStringsLocatorKeyFor:!helpers!private! !
register:!operations!public! !
registerPredefined!initializing!private! !
registerPredefinedClasses!initializing!private! !
registerPredefinedObjects!initializing!private! !
reset!initializing!private! !
stream!accessing!public! !
stxFormatName!constants!public! !
unqualifiedShortNameOfClass:!helpers!private! !
version!accessing!public! !
!

!Kernel.STxFiler class methodsFor!

classForVersion: anInteger
	^(self versions lookup: anInteger + 1)
		ifNil: [STBError signal: 'Unsupported <2s> format (version <1d>)' << { anInteger. self stxFormatName }]!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self subclassResponsibility!

stxFormatName
	"Answer the format name, either STB or STL."

	^self subclassResponsibility!

version
	^6!

versions
	^self subclassResponsibility! !

!Kernel.STxFiler class categoriesForMethods!
classForVersion:!enquiries!private! !
on:!instance creation!public! !
stxFormatName!constants!public! !
version!constants!public! !
versions!accessing!private! !
!

