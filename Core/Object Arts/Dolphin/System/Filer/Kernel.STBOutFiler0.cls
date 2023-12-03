"Filed out from Dolphin Smalltalk"!

Kernel.STBLegacyOutFiler
	subclass: #'Kernel.STBOutFiler0'
	instanceVariableNames: 'globals globalNils'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler0 guid: (Core.GUID fromString: '{26c51f71-0639-44b9-b9e1-90423d6717e9}')!
Kernel.STBOutFiler0 comment: '`STBOutFiler0` is an `STBOutFiler` for writing the first STB serialization format, version 0.

This was the original format as used in the earliest betas prior to Dolphin 1.0, right through to Dolphin 4.x.
  - Proxy objects were serialised in the place of certain other objects in order to allow for special fixup behaviours. For example class objects were represented by instances of `STBClassProxy`, and `OrderedCollection`s, `Set`s and `Dictionary` instances by `STBCollectionProxy` instances.
  - There were no pre-registered classes. Later versions pre-registered some classes for both space efficiency, and to fix some obscure boundary cases representing `String` and `STBClassProxy` classes.
  - Strings stored in STB used the encoding of the code page where written. If decoded (i.e. deserialised) no a system with a different code page, the resulting `String` might contain different characters to the original. for any code points outside the ASCII range. This was inherent in the pre-unicode string representation.
'!
!Kernel.STBOutFiler0 categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler0 methodsFor!

inFilerClass
	^STBInFiler0!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^4!

locatorKeyFor: aClass
	"Answer a <String> name for the <Class> argument that receiver's class locator can use to resolve the class."

	"We need to use a backwards compatible name that would have been used for the class prior to the introduction of namespaces in Dolphin 8, and the addition of UTF-encoded strings in 7.1."

	^self preUtfStringsLocatorKeyFor: aClass!

nextPut: anObject
	"Write anObject to the stream in STB format."

	| objectToSave |
	"Originally STB had a special mechanism for saving globals that would have the deliberate side-effect of inserting variables into the Smalltalk dictionary when deserialising. This was really intended only for use in the original binary packages, and fell out of use when source format packages were introduced. The mechanism remained, however, until it was dropped from STx 5 in Dolphin 8"
	(self objectIsGlobal: anObject)
		ifTrue: 
			[self putGlobal: anObject.
			^anObject].
	(self refForObject: anObject)
		ifNotNil: 
			[:refIndex |
			self writeReference: refIndex.
			^anObject].	"If anObject is the subject of an override:with: message then we output the 'with' proxy object instead."
	objectToSave := self overrideFor: anObject.
	objectToSave == Collection.AbsentCookie
		ifTrue: [anObject stbSaveOn: self]
		ifFalse: 
			[objectToSave notNil ifTrue: [self removeOverrideFor: anObject].
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
		ifFalse: 
			[symbolCollection := globals at: anObject.
			symbol := symbolCollection removeFirst.
			symbolCollection isEmpty ifTrue: [globals removeKey: anObject]].
	self nextPut: (Smalltalk.STBGlobalObjectProxy for: anObject name: symbol)!

register: anObject asGlobal: aSymbol
	"Add anObject to the globals dictionary.
	When this object is output it will be wrapped in an STBGlobalObjectProxy.
	When the proxy is subsequently loaded it be added to Smalltalk with the
	name aSymbol. If the same object is registered as several global symbols
	then it must be #nextPut: a corresponding number of times." 

	(anObject isNil
		ifTrue: [globalNils]
		ifFalse: [globals at: anObject ifAbsentPut: [OrderedCollection new]]) add: aSymbol!

registerPredefined
	super registerPredefined.
	globals := IdentityDictionary new.
	globalNils := OrderedCollection new!

saveBindingReference: aBindingReference
	self errorBindingReferencesNotSupported: aBindingReference!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	"Up until the addition of full Unicode support in Dolphin 7.1 the Characters encoded in STB could only be byte-characters from the system ANSI code page. This did mean that some characters may not restore correctly on a system with a different code page."

	| codeUnit |
	codeUnit := aCharacter codeUnit.
	codeUnit > 255 ifTrue: [self errorExtendedCharacterNotSupported: aCharacter].
	stream nextInt32Put: ((codeUnit bitShift: PrefixRefShift) bitOr: PrefixCharacterMask)!

saveObject: anObject as: anObjectToSave
	"If anObjectToSave is zero then output anObject as normal (ie. without any proxy)."

	anObjectToSave == 0 ifTrue: [^self saveObject: anObject].

	"A proxy of nil means output nil instead of anObject."
	anObjectToSave ifNil: [^self saveNil].

	"Output anObjectToSave (usually a proxy) instead of anObject"
	self
		writeProxyPreambleFor: anObject class: anObjectToSave basicClass;
		writeInstanceVariables: anObjectToSave!

saveStatic: aBindingReference
	"Serialize a static variable reference into the stream."

	"Requires <BindingReference>s, which did not exist at the time of STB 0"

	self errorStaticVarRefsNotSupported!

saveString: aString
	"Serialize a <String> into the object stream."

	"Prior to D7.1, which introduced full Unicode support, normal Strings were ansi code-page encoded, and there was a very incomplete UnicodeString UTF-16 encoding.
	In version 0, there were no pre-registered classes, so we'll map to String and UnicodeString (as a BindingRef since the class does not exist as such), and register those substitutes."

	| substituteClass bytes |
	aString basicClass == Utf16String
		ifTrue: 
			[substituteClass := #{Smalltalk.UnicodeString}.
			bytes := aString asByteArray]
		ifFalse: 
			[| ansi |
			ansi := aString asAnsiString.
			ansi asUtf8String = aString
				ifTrue: 
					[substituteClass := String.
					bytes := ansi asByteArray]
				ifFalse: 
					["Utf8String that is not representable in ansi encoding. Serialize as if a UnicodeString"
					substituteClass := #{Smalltalk.UnicodeString}.
					bytes := aString asUtf16String asByteArray]].
	(self refForObject: substituteClass)
		ifNotNil: [:refIndex | self writeClassReference: refIndex prefix: PrefixDataMask]
		ifNil: 
			[| locatorString |
			locatorString := self locatorKeyFor: substituteClass.
			stream
				nextInt32Put: (##(PrefixClassMask | PrefixBytesMask)
							bitOr: (locatorString size bitShift: PrefixLocatorLenShift));
				nextPutAll: locatorString asByteArray.
			self register: substituteClass].
	self register: aString.
	self writeByteObject: bytes!

saveSymbol: aSymbol
	"Serialize a <Symbol> into the object stream."

	"In STB versions prior to 2, symbols were proxied."

	self saveObject: aSymbol as: (Smalltalk.STBSymbolProxy for: aSymbol)!

saveVariableBinding: aVariableBinding
	"Pre-namespace format"

	self
		writePreambleFor: aVariableBinding
		class: self variableBindingClass
		version: 0
		instSize: 2.
	"Indexed size - always written until STB 3"
	stream nextInt32Put: 0.
	self
		nextPut: aVariableBinding key;
		nextPut: aVariableBinding value!

variableBindingClass
	^Association!

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
				do: [:i | self nextPut: (anObject instVarAt: i)]]! !
!Kernel.STBOutFiler0 categoriesForMethods!
inFilerClass!constants!private! !
lastPredefined!constants!private! !
locatorKeyFor:!helpers!public! !
nextPut:!accessing!public! !
objectIsGlobal:!globals!private! !
putGlobal:!globals!private! !
register:asGlobal:!globals!public! !
registerPredefined!initializing!private! !
saveBindingReference:!operations!public! !
saveCharacter:!operations!public! !
saveObject:as:!operations!public! !
saveStatic:!public!serializing! !
saveString:!public!serializing! !
saveSymbol:!public!serializing! !
saveVariableBinding:!public!serializing! !
variableBindingClass!constants!private! !
writeInstanceVariables:!operations!private! !
!

!Kernel.STBOutFiler0 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	"Answer the format version of the STB stream."

	^0! !
!Kernel.STBOutFiler0 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!accessing!public! !
!

