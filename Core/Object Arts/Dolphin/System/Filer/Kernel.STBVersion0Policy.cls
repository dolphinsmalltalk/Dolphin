"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicy
	subclass: #'Kernel.STBVersion0Policy'
	instanceVariableNames: 'globals globalNils'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion0Policy guid: (Core.GUID fromString: '{645b2749-5dfa-4fc3-afd3-708ede25667b}')!
Kernel.STBVersion0Policy comment: '`STBVersion0Policy` is the the policy/strateger plugin for writing and reading the STB v0 serialization format.

This was the original format as used in the earliest betas prior to Dolphin 1.0, right through to Dolphin 4.x.
  - Proxy objects were serialised in the place of certain other objects in order to allow for special fixup behaviours. For example class objects were represented by instances of `STBClassProxy`, and `OrderedCollection`s, `Set`s and `Dictionary` instances by `STBCollectionProxy` instances.
  - There were no pre-registered classes. Later versions pre-registered some classes for both space efficiency, and to fix some obscure boundary cases representing String and STBClassProxy classes.
  - Strings stored in STB used the encoding of the code page where written. If decoded (i.e. deserialised) no a system with a different code page, the resulting String might contain different characters to the original. for any code points outside the ASCII range. This was inherent in the pre-unicode string representation.

'!
!Kernel.STBVersion0Policy methodsFor!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^4!

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

readClassWithPrefix: anInteger
	| locatorString |
	locatorString := AnsiString new: (anInteger bitShift: PrefixLocatorLenUnshift).
	1 to: locatorString size do: [:i | locatorString basicAt: i put: stream next].
	^filer classLocator locateClass: (BindingReference
				pathString: locatorString
				private: false
				scope: Smalltalk)!

readCollection: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	"Should not be received as this version emits STBIdentityDictionaryProxy for LookupTables"

	^self shouldNotImplement!

readObjectSize: aClass
	^stream nextInt32!

readString: aClass
	| bytes size |
	size := stream nextInt32.
	^aClass == String
		ifTrue: 
			[bytes := AnsiString new: size.
			self readBytes: size into: bytes.
			"Convert to UTF-8"
			bytes asUtf8String]
		ifFalse: 
			[bytes := ByteArray new: size.
			self readBytes: size into: bytes.
			aClass fromByteArray: bytes]!

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

saveLookupTable: aLookupTable
	self saveObject: aLookupTable as: (STBIdentityDictionaryProxy forCollection: aLookupTable)!

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

saveStatic: aBindingReference
	"Not supported in this version"

	self shouldNotImplement!

saveString: aString
	"Prior to D7.1, which introduced full Unicode support, normal Strings were in ansi encoding, and there was a very incomplete UnicodeString UTF-16 encoding.
	In version 0, there were no pre-registered classes, so we'll map to String and UnicodeString (as a BindingRef since the class does not exist as such), and register those."

	| substituteClass bytes |
	aString basicClass == Utf16String
		ifTrue: 
			[substituteClass := #{Smalltalk.UnicodeString}.
			bytes := aString asByteArray]
		ifFalse: 
			[substituteClass := String.
			bytes := aString asAnsiString asByteArray].
	(filer refForObject: substituteClass)
		ifNotNil: [:refIndex | self writeClassReference: refIndex prefix: PrefixDataMask]
		ifNil: 
			[| locatorString |
			locatorString := self locatorKeyFor: substituteClass.
			stream
				nextInt32Put: (##(PrefixClassMask | PrefixBytesMask)
							bitOr: (locatorString size bitShift: PrefixLocatorLenShift));
				nextPutAll: locatorString asByteArray.
			filer register: substituteClass].
	filer register: aString.
	self writeByteObject: bytes!

saveSymbol: aSymbol
	self saveObject: aSymbol as: (Smalltalk.STBSymbolProxy for: aSymbol)!

writeInstanceVariables: anObject
	| instanceSpec basicSize |
	instanceSpec := anObject basicClass instanceSpec.
	"In the original STB the indexed size was always written, even for non-indexable objects where it would be 0"
	basicSize := anObject basicSize.
	stream nextInt32Put: basicSize.
	(instanceSpec anyMask: Behavior._PointersMask)
		ifFalse: 
			["Bytes written directly"
			1 to: basicSize do: [:i | stream nextPut: (anObject basicAt: i)]]
		ifTrue: 
			[1 to: (instanceSpec bitAnd: Behavior._SizeMask) + basicSize
				do: [:i | filer nextPut: (anObject instVarAt: i)]]! !
!Kernel.STBVersion0Policy categoriesForMethods!
lastPredefined!constants!public! !
locatorKeyFor:!helpers!public! !
nextPut:!accessing!public! !
objectIsGlobal:!globals!private! !
putGlobal:!globals!private! !
readClassWithPrefix:!operations!private! !
readCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
readObjectSize:!operations!public! !
readString:!binary filing!public! !
register:asGlobal:!globals!public! !
registerPredefined:!initializing!public! !
saveLookupTable:!operations!public! !
saveObject:as:!binary filing!public! !
saveResourceLibrary:!binary filing!public! !
saveStatic:!binary filing!public! !
saveString:!binary filing!public! !
saveSymbol:!binary filing!public! !
writeInstanceVariables:!operations!private! !
!

!Kernel.STBVersion0Policy class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^0! !
!Kernel.STBVersion0Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

