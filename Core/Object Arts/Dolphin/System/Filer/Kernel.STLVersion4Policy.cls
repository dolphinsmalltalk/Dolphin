"Filed out from Dolphin Smalltalk"!

Kernel.STLVersion3Policy
	subclass: #'Kernel.STLVersion4Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersion4Policy guid: (Core.GUID fromString: '{829de0cb-c85f-4efd-8394-07095db69f9d}')!
Kernel.STLVersion4Policy comment: ''!
!Kernel.STLVersion4Policy methodsFor!

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

readObjectWithPrefix: anInteger
	"Private - In STL version 4 and later, the input stream won't contain encoded Characters, as these are written as literals. SmallIntegers are still encoded though, as this is necessary to distinguish these from the prefix values. STL 4 streams from 7.1 won't contain encoded nil's either, but some earlier streams with the same version will because the filer version wasn't incremented when the change was made to emit nil as a literal (it was backwards, though not forwards, compatible)."

	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"
	"SmallInteger?"
	(anInteger allMask: PrefixSmallIntegerMask)
		ifTrue: 
			["Encoded in the prefix"
			^anInteger bitShift: -1].
	(anInteger allMask: PrefixDataMask)
		ifFalse: 
			["Must be an object reference"
			^filer objectAt: (anInteger bitShift: PrefixRefUnshift)].

	"Ascertain the class of the object."
	class := (anInteger allMask: PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: 
					["Previously encountered class"
					filer classAt: (anInteger bitShift: PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class stbReadFrom: filer format: (filer converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex!

registerPredefinedObjects: anSTLFiler
	"Private - Post version 3, don't pre-register standard objects with literal representation as we write these directly to the stream."!

saveArray: anArray
	"Save an <Array> to the object stream."

	"As of STL 4 Arrays containing only atomic objects were written as literals. This is because there is no need to consider reference identity for these objects since it is implicit (an atomic class of objects is one where any one value can only have one instance)."

	(anArray allSatisfy: [:each | each isAtomic])
		ifTrue: [self writeLiteral: anArray]
		ifFalse: 
			[| size |
			"No literal form, need to break it down"
			self writePreambleFor: anArray class: anArray basicClass.
			stream nextPut: (size := anArray basicSize).
			1 to: size do: [:i | filer nextPut: (anArray basicAt: i)]]!

saveCharacter: aCharacter
	stream nextPut: aCharacter!

saveClass: aClass
	stream nextPut: aClass!

saveString: aString
	| utf8 |
	utf8 := aString asUtf8String.
	stream
		nextPut: PrefixLiteralMask;
		nextPut: utf8.
	filer register: aString!

saveSymbol: aSymbol
	stream nextPut: aSymbol!

writeReference: anInteger
	stream nextPut: (anInteger == 0 ifFalse: [anInteger bitShift: PrefixRefShift])! !
!Kernel.STLVersion4Policy categoriesForMethods!
predefinedClasses!constants!public! !
readObjectWithPrefix:!operations!private! !
registerPredefinedObjects:!initializing!private! !
saveArray:!binary filing!public! !
saveCharacter:!binary filing!public! !
saveClass:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
writeReference:!operations!private! !
!

!Kernel.STLVersion4Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^4! !
!Kernel.STLVersion4Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

