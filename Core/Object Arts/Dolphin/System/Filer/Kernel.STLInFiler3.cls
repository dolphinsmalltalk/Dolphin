"Filed out from Dolphin Smalltalk"!

Kernel.STLLegacyInFiler
	subclass: #'Kernel.STLInFiler3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLInFiler3 guid: (Core.GUID fromString: '{3f04c8bc-7157-48c8-9896-37f495bad391}')!

Kernel.STLInFiler3 comment: '`STBInFiler3` is an `STLInFiler` for reading the STL 3 literal object serialization format.

STL 3 was the original STL format introduced in Dolphin 6. There were no versions prior to 3 as the version number was synchronised with the STB version current at the time. This was partly because there was a lot of shared implementation and the object prefix encoding was the same. Not all literals were necessarily written as literals into the STL; nil appeared as the special prefix code zero (as in STB), and likewise Characters were encoded in the prefix. The same predefined objects and classes were also used, so some classes were not directly visible in the literal array source, but were hidden in the encoding (e.g. Array).'!

!Kernel.STLInFiler3 categoriesForClass!System-Binary storage! !

!Kernel.STLInFiler3 methodsFor!

characterValue: anInteger
	"Answer the <Character> for the specified <Integer> code from the object stream."

	"In STL 3, Characters were not emitted as literals even though they obviously have a literal from. This did allow for non-printable characters to be serialised, as these did not have a literal form until Dolphin 7.1, but the ansi code unit, not the code point, was saved. This may not deserialize correctly on a system with a different code page than when serialized."

	^Character ansiValue: anInteger!

readBytes: anInteger into: aByteObject
	1 to: anInteger do: [:i | aByteObject basicAt: i put: stream next].
	^aByteObject!

readClassDataWithPrefix: anInteger
	"Private - Deserialize the class data preceding the instance data of a class not previously seen in the object stream."

	^self
		registerVersion: ((anInteger allMask: PrefixNonZeroVersionMask) ifTrue: [stream next] ifFalse: [0])
		ofClass: stream next
		prefix: anInteger!

readObjectWithPrefix: anInteger
	"Private - Deserialize an object from the literal stream with the specified <Integer> prefix code."

	"STL 3 shared common decoding with STB 3, and unlike later STL versions may contain encoded characters."

	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^decorator readNil].

	"SmallInteger?"
	(anInteger allMask: PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: PrefixDataMask)
		ifFalse: 
			[^(anInteger allMask: PrefixCharacterMask)
				ifTrue: [decorator characterValue: (anInteger bitShift: PrefixRefUnshift)]
				ifFalse: [decorator objectAt: (anInteger bitShift: PrefixRefUnshift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: [decorator classAt: (anInteger bitShift: PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := readMap size + 1.
	anObject := class stbReadFrom: decorator format: (converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: decorator at: newObjectIndex!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	| string size |
	size := stream next.
	string := aClass new: size.
	decorator register: string.
	self readBytes: size into: string.
	^string!

registerPredefinedClasses
	"Private -"

	super registerPredefinedClasses.

	"In STL 3, all literals were added to the read map and only the first reference was emitted as a literal. This included classes, so if an object stream contained a direct reference to a class object before any class instances of that class, and the class required an STB upgrade (i.e. later STB version when filing in), then the stream would fail to load because the instance loading code assumes that the conversion required for any class loaded from the read map would already have been stored into the converters map. This bug went unnoticed for years because the chance of occurence is low, but the IDB PoolDictionary Browser tool default view has such an occurrence when loading into Dolphin 8. It contains a reference to the class Icon embedded in a block. Subsequently icons are encountered when loading CommandDescriptions, and in Dolphin 8 the Image hierarchy stbVersion has advanced from 3 to 4. When the icon instances are encountered, they are loaded as if of the current version so the wrong number of instance variables are read and the converter is not run. This bug does not occur from STL4 onwards, because classes written as literals are not entered into the object map

	An example demonstrating this bug can be seen with the STL3 representation for { Icon. Icon error. Icon warning. Icon}:
		#(#'!!STL' 3 98 4 8 ##(Smalltalk.Icon)  418 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  65027 1 418 0 16 464 65031 1 416)

	Note how the Icon class only appears once. However, in the STL4 representation it appears twice because the first literal reference is not recorded in the object map. Once an instance has been emitted it is recorded, and then all subsequent references emit the reference, whether a class reference or instance:
		#(#'!!STL' 4 34 4 ##(Smalltalk.Icon) 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 65027 1 418 nil true 464 65031 1 416)

	For completeness, the STL6 form is similar, mainly varying because of the change to the Image hierarchy to use initializer objects:
		#(#'!!STL' 6 38 #{Core.Array} 4 #{Graphics.Icon} 838 4 #{Graphics.Icon} nil true 518 #{Graphics.IconFromSystemInitializer} nil 65027 50 nil true 82 nil 65031 48)
	
	An unfortunate consequence of the bug is that the STL3 stream will not record the stbVersion for any class that is first emitted as a literal due to an instance variable referencing the class itself appearing before any instances.
	To workaround this we pre-register some conversions for classes that we expect to appear in STL resources. We have to assume the stbVersion, but generally this should be the version that was current in Dolphin 6.

	Further classes can be added to the pre-registered conversions as required. Each entry in the list consists of a BindingReference resolving to the class, the stbVersion that should have been current, and then the relevant bits of the prefix mask that would have been present had the class been written properly. Only the instance size, bytes and indexable flags are required. It is not necessary to add View subclasses because the instances of these are always proxied. The same should apply to any other class that is proxied."
	#(#(#{Graphics.Icon} 3 ##(5 bitShift: PrefixInstSizeShift))) do: 
			[:each |
			(each at: 1) valueOrNil
				ifNotNil: 
					[:class |
					self
						registerConversionFrom: (each at: 2)
						ofClass: class
						prefix: (each at: 3)]]!

registerPredefinedObjects
	"Private - We pre-register objects that must never be recreated - note that if the 'fixed' list of pre-registered objects is changed, then the STB version must be
	changed and an upgrade mechanism put in place."

	decorator
		register: true;
		register: false;
		register: Smalltalk;
		register: Processor! !

!Kernel.STLInFiler3 categoriesForMethods!
characterValue:!helpers!public! !
readBytes:into:!helpers!private! !
readClassDataWithPrefix:!operations!public! !
readObjectWithPrefix:!operations!private! !
readString:format:!deserializing!public! !
registerPredefinedClasses!initializing!private! !
registerPredefinedObjects!initializing!private! !
!

!Kernel.STLInFiler3 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL 3 stream."

	"There is relatively little benefit in pre-registering classes in STL, since we do not have the chicken-before-egg problem that STB has with, for example, Strings, since all the types that are required to support the format have a literal representation and will be instantiated by the compiler. The classes for objects with literal form do not need to be registered. We also do not need the STB class proxies in the STL representation. However, in all STL versions up to and including 5, the pre-registered classes of STB were retained."

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
	"Private - Answer the version number of the format read by the receiver."

	^3! !

!Kernel.STLInFiler3 class categoriesForMethods!
initialize!class initialization!public! !
predefinedClasses!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!private! !
!

