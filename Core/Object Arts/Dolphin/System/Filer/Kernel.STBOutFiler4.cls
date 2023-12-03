"Filed out from Dolphin Smalltalk"!

Kernel.STBOutFiler3
	subclass: #'Kernel.STBOutFiler4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler4 guid: (Core.GUID fromString: '{3565474c-060a-4697-8e40-5e4837551d69}')!
Kernel.STBOutFiler4 comment: '`STBOutFiler4` is an `STBOutFiler` for writing the STB 4 binary object serialization format.

STB 4 was introduced in Dolphin 7.1, primarily to support UTF-encoded strings.'!
!Kernel.STBOutFiler4 categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler4 methodsFor!

inFilerClass
	^STBInFiler4!

locatorKeyFor: aClass
	"Answer a <String> name for the <Class> argument that receiver's class locator can use to resolve the class."

	"We need to use a backwards compatible name that would have been used for the class prior to the introduction of namespaces in Dolphin 8. This will be the unqualified name that would have appeared in the Smalltalk dictionary."

	^self preNamespaceLocatorKeyFor: aClass!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	"As of STL 4, any Unicode codepoint can be saved in STB/STL"

	stream nextInt32Put: ((aCharacter codePoint bitShift: PrefixRefShift) bitOr: PrefixCharacterMask)!

saveString: aString
	"Serialize a <String> into the object stream."

	"STB 4 was introduced in Dolphin 7.1, and had proper UTF-encoded strings. However, Utf16String instances were written as Utf8Strings. This did mean that the class of Utf16Strings was not preserved, but the UTF encoded strings are interchangeable for most purposes. AnsiStrings were written directly, and this did mean they might not deserialize correctly on a host with a different system code page."

	| bytes size |
	bytes := aString encoding == #utf16le ifTrue: [aString asUtf8String] ifFalse: [aString].
	self writePreambleFor: aString class: bytes class.
	stream nextInt32Put: (size := bytes size).
	1 to: size do: [:i | stream nextPut: (bytes basicAt: i)]!

saveSymbol: aSymbol
	"Symbols were no longer proxied - newly deserialised objects are all sent #stbFixup:at:, so there is no need to use proxies just to perform fixup.
	The Symbols themselves are now UTF-8 encoded."

	| size |
	self writeClassReference: (self refForObject: Symbol) prefix: PrefixDataMask.
	self register: aSymbol.
	stream nextInt32Put: (size := aSymbol size).
	1 to: size do: [:i | stream nextPut: (aSymbol basicAt: i)]!

variableBindingClass
	^VariableBinding! !
!Kernel.STBOutFiler4 categoriesForMethods!
inFilerClass!constants!private! !
locatorKeyFor:!helpers!public! !
saveCharacter:!operations!public! !
saveString:!public!serializing! !
saveSymbol:!public!serializing! !
variableBindingClass!constants!private! !
!

!Kernel.STBOutFiler4 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^4! !
!Kernel.STBOutFiler4 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

