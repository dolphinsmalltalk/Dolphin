"Filed out from Dolphin Smalltalk"!

Kernel.STLVersionPolicy
	subclass: #'Kernel.STLVersion3Policy'
	instanceVariableNames: 'globals globalNils'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersion3Policy guid: (Core.GUID fromString: '{d443c598-bf59-48b8-83ff-9cce6e8ca411}')!
Kernel.STLVersion3Policy comment: ''!
!Kernel.STLVersion3Policy methodsFor!

locatorKeyFor: aClass
	^(Smalltalk oldNames lookup: aClass)
		ifNil: 
			[| name |
			name := aClass shortName asString.
			(BindingReference isQualifiedName: name)
				ifTrue: 
					[STBError
						signal: '<1p> does not have an unqualified short name for use in a version <2d> <3s> stream'
								<< { aClass. self version. self formatName }]
				ifFalse: [name]]!

nextPut: anObject
	| objectToSave |
	"If anObject has been registered as a global then we wrap it up as an STBGlobalObjectProxy and output that instead."
	(self objectIsGlobal: anObject)
		ifTrue: 
			[self putGlobal: anObject.
			^anObject].
	(filer refForObject: anObject)
		ifNotNil: 
			[:refIndex |
			self writeReference: refIndex.
			^anObject].
	"If anObject is the subject of an override:with: message then we output the 'with' proxy object instead."
	objectToSave := filer overrideFor: anObject.
	objectToSave == Collection.AbsentCookie
		ifTrue: [anObject stbSaveOn: filer]
		ifFalse: 
			[objectToSave notNil ifTrue: [filer removeOverrideFor: anObject].
			self saveObject: anObject as: objectToSave].
	^anObject!

objectIsGlobal: anObject
	"Private - Answer true if anObject has been registered as global."

	anObject isNil
		ifTrue: [^globalNils isEmpty not].

	^globals includesKey: anObject!

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
	})!

putGlobal: anObject
	"Private - Wrap anObject up as an STBGlobalObjectProxy and output that instead."

	| symbolCollection symbol |
	anObject isNil
		ifTrue: [symbol := globalNils removeFirst]
		ifFalse: [
			symbolCollection := globals at: anObject.
			symbol := symbolCollection removeFirst.
			symbolCollection isEmpty
				ifTrue: [globals removeKey: anObject]].

	self nextPut: (Smalltalk.STBGlobalObjectProxy for: anObject name: symbol)!

readBytes: anInteger into: aByteObject
	1 to: anInteger do: [:i | aByteObject basicAt: i put: stream next].
	^aByteObject!

readClassDataWithPrefix: anInteger
	^(anInteger allMask: PrefixNonZeroVersionMask)
		ifTrue: 
			[| versionBeingRead |
			versionBeingRead := stream next.
			filer
				registerClass: stream next
				version: versionBeingRead
				prefix: anInteger]
		ifFalse: 
			[filer
				registerClass: stream next
				version: 0
				prefix: anInteger]!

readCollection: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement!

readObjectWithPrefix: anInteger
	| anObject newObjectIndex class |
	anInteger == 0 ifTrue: [^nil].	"optimize for nil"

	"SmallInteger?"
	(anInteger allMask: PrefixSmallIntegerMask) ifTrue: [^anInteger bitShift: -1].
	(anInteger allMask: PrefixDataMask)
		ifFalse: 
			[^(anInteger allMask: PrefixCharacterMask)
				ifTrue: [Character value: (anInteger bitShift: PrefixRefUnshift)]
				ifFalse: [filer objectAt: (anInteger bitShift: PrefixRefUnshift)]].

	"Ascertain the class of the object."
	class := (anInteger allMask: PrefixClassMask)
				ifTrue: [self readClassDataWithPrefix: anInteger]
				ifFalse: [filer classAt: (anInteger bitShift: PrefixRefUnshift)].

	"Now read the object data."
	newObjectIndex := filer readMap size + 1.
	anObject := class stbReadFrom: filer format: (filer converters lookup: class).

	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: filer at: newObjectIndex!

readString: aClass
	| string size |
	size := stream next.
	string := aClass new: size.
	self readBytes: size into: string.
	^string!

register: anObject asGlobal: aSymbol
	"Add anObject to the globals dictionary.
	When this object is output it will be wrapped in an STBGlobalObjectProxy.
	When the proxy is subsequently loaded it be added to Smalltalk with the
	name aSymbol. If the same object is registered as several global symbols
	then it must be #nextPut: a corresponding number of times." 

	(anObject isNil
		ifTrue: [globalNils]
		ifFalse: [globals at: anObject ifAbsentPut: [OrderedCollection new]]) add: aSymbol!

registerPredefined: anSTBFiler
	super registerPredefined: anSTBFiler.
	globals := IdentityDictionary new.
	globalNils := OrderedCollection new.!

registerPredefinedObjects: anSTBFiler
	"Private - We pre-register objects that must never be recreated - note that if the 'fixed' list of pre-registered objects is changed, then the STB version must be
	changed and an upgrade mechanism put in place."

	anSTBFiler
		register: true;
		register: false;
		register: Smalltalk;
		register: Processor!

saveArray: anArray
	"Save an <Array> to the object stream."

	"Arrays were never written in literal form - always broken down."

	| size |
	self writePreambleFor: anArray class: anArray basicClass.
	stream nextPut: (size := anArray basicSize).
	1 to: size do: [:i | filer nextPut: (anArray basicAt: i)]!

saveCharacter: aCharacter
	"Characters were encoded, as in STB"

	| codePoint |
	codePoint := aCharacter codePoint.
	codePoint > 255 ifTrue: [STBError signal: 'Character code point cannot be represented in STL 3: <1s> (<2d>)' << { aCharacter codePointString. aCharacter }].
	stream nextPut: ((codePoint bitShift: PrefixRefShift) bitOr: PrefixCharacterMask)!

saveClass: aClass
	self writeLiteral: aClass!

saveCollection: aCollection
	self saveObject: aCollection as: (STBCollectionProxy forCollection: aCollection)!

saveFloat: aFloat
	"In STL 3, Float's were not printed as literals"

	self writePreambleFor: aFloat class: aFloat basicClass.
	stream nextPut: 8.
	1 to: 8 do: [:i | stream nextPut: (aFloat basicAt: i)]!

saveLookupTable: aLookupTable
	self saveObject: aLookupTable as: (STBIdentityDictionaryProxy forCollection: aLookupTable)!

saveNil
	stream nextPut: 0!

saveObject: anObject as: anObjectToSave
	"If anObjectToSave is zero then output anObject as normal (ie. without any proxy)."

	anObjectToSave == 0 ifTrue: [^self saveObject: anObject].

	"A proxy of nil means output nil instead of anObject."
	anObjectToSave ifNil: [^self saveNil].

	"Output anObjectToSave (usually a proxy) instead of anObject"
	self
		writeProxyPreambleFor: anObject class: anObjectToSave basicClass;
		writeInstanceVariables: anObjectToSave!

saveResourceLibrary: aResourceLibrary
	self saveObject: aResourceLibrary
		as: (STBExternalResourceLibraryProxy forLibrary: aResourceLibrary)!

saveScaledDecimal: aScaledDecimal
	self saveObject: aScaledDecimal!

saveSet: aSet elements: aCollection
	self saveObject: aSet as: (STBCollectionProxy class: aSet basicClass array: aCollection asArray)!

saveStatic: aBindingReference
	stream nextPut: aBindingReference value!

saveString: aString
	aString asAnsiString asUtf8String = aString ifFalse: [STBError signal: 'String contains extended character that cannot be represented in STL 3: <1p>' << aString].
	self writeLiteral: aString!

saveSymbol: aSymbol
	self writeLiteral: aSymbol!

writeByteObject: aByteObject
	"Private - Bytes of byte objects other than ByteArrays were written individually"

	| size |
	size := aByteObject basicSize.
	stream nextPut: size.
	1 to: size do: [:i | stream nextPut: (aByteObject basicAt: i)]!

writeClass: aClass prefix: anInteger
	| code locatorString |
	locatorString := self locatorKeyFor: aClass.
	code := anInteger bitOr: ((locatorString size bitShift: PrefixLocatorLenShift)
						bitOr: (aClass instSize bitShift: PrefixInstSizeShift)).
	aClass isVariable
		ifTrue: [code := code bitOr: (aClass isBytes ifTrue: [PrefixBytesMask] ifFalse: [PrefixVariableMask])].
	aClass stbVersion == 0
		ifTrue: [stream nextPut: code]
		ifFalse: 
			[stream
				nextPut: (code bitOr: PrefixNonZeroVersionMask);
				nextPut: aClass stbVersion].
	stream nextPut: aClass!

writeReference: anInteger
	"nil was not written as a literal, but as its STB reference, 0"

	stream nextPut: (anInteger bitShift: PrefixRefShift)! !
!Kernel.STLVersion3Policy categoriesForMethods!
locatorKeyFor:!helpers!public! !
nextPut:!accessing!public! !
objectIsGlobal:!globals!private! !
predefinedClasses!constants!public! !
putGlobal:!globals!private! !
readBytes:into:!operations!public! !
readClassDataWithPrefix:!operations!public! !
readCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
readObjectWithPrefix:!operations!private! !
readString:!binary filing!public! !
register:asGlobal:!globals!public! !
registerPredefined:!initializing!public! !
registerPredefinedObjects:!initializing!private! !
saveArray:!binary filing!public! !
saveCharacter:!binary filing!public! !
saveClass:!binary filing!public! !
saveCollection:!operations!public! !
saveFloat:!binary filing!public! !
saveLookupTable:!operations!public! !
saveNil!binary filing!public! !
saveObject:as:!binary filing!public! !
saveResourceLibrary:!binary filing!public! !
saveScaledDecimal:!binary filing!public! !
saveSet:elements:!operations!public! !
saveStatic:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
writeByteObject:!operations!private! !
writeClass:prefix:!operations!private! !
writeReference:!operations!private! !
!

!Kernel.STLVersion3Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

literalPrinterClass
	^LegacySTLPrinter!

uninitialize
	self unregister!

version
	^3! !
!Kernel.STLVersion3Policy class categoriesForMethods!
initialize!class initialization!public! !
literalPrinterClass!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

