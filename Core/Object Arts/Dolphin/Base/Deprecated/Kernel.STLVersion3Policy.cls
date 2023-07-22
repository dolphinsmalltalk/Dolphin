"Filed out from Dolphin Smalltalk"!

Kernel.STLVersionPolicy
	subclass: #'Kernel.STLVersion3Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersion3Policy guid: (Core.GUID fromString: '{d443c598-bf59-48b8-83ff-9cce6e8ca411}')!
Kernel.STLVersion3Policy comment: ''!
!Kernel.STLVersion3Policy methodsFor!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered for every STL stream. 
	There is relatively little benefit in pre-registering classes in STL, since we do not have the chicken-before-egg problem that STB has with, for example, Strings, since all the types that are required to support the format have a literal representation and will be instantiated by the compiler. The classes for objects with literal form do not need to be registered. We also do not need the STB class proxies in the STL representation. However, in all STL versions up to and including 5, the pre-registered classes were retained."

	"Note that STBClassProxy and STBMetaclassProxy (entries 5 & 6) are not really required for STL, but because they were pre-registered if they appeared as class references (as opposed to instances) then the predefined index would have been used. Similar for ByteArray, Symbol, and the String classes. These have literal form (all Strings are written as either AnsiStrings in STL3 or, Utf8Strings in 4+), at least for instances. The same is true for classes (they have a literal form), but there were written as reference indices if registered. As of STL6, there are no longer any pre-registered classes."

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

readByteObject: aByteObject
	1 to: aByteObject basicSize do: [:i | aByteObject basicAt: i put: stream next]!

writeByteObject: aByteObject
	"Bytes of byte objects other than ByteArrays were written individually"

	| size |
	size := aByteObject basicSize.
	stream nextPut: size.
	1 to: size do: [:i | stream nextPut: (aByteObject basicAt: i)]!

writeClass: aClass
	| code locatorString |
	locatorString := self classLocatorStringFor: aClass.
	code := STBFiler.PrefixClassMask
				bitOr: ((locatorString size bitShift: STBFiler.PrefixLocatorLenShift)
						bitOr: (aClass instSize bitShift: STBFiler.PrefixInstSizeShift)).
	aClass isVariable
		ifTrue: 
			[code := code
						bitOr: (aClass isBytes ifTrue: [STBFiler.PrefixBytesMask] ifFalse: [STBFiler.PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [stream nextPut: code]
		ifFalse: 
			[stream
				nextPut: (code bitOr: STBFiler.PrefixNonZeroVersionMask);
				nextPut: aClass stbVersion].
	stream nextPut: aClass! !
!Kernel.STLVersion3Policy categoriesForMethods!
predefinedClasses!constants!public! !
readByteObject:!operations!public! !
writeByteObject:!operations!public! !
writeClass:!operations!public! !
!

!Kernel.STLVersion3Policy class methodsFor!

initialize
	"
	self initialize
	"

	Versions at: 3+1 put: self!

literalPrinterClass
	^LegacySTLPrinter! !
!Kernel.STLVersion3Policy class categoriesForMethods!
initialize!class initialization!public! !
literalPrinterClass!constants!public! !
!

