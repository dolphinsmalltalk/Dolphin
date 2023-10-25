"Filed out from Dolphin Smalltalk"!

Kernel.STBOutFiler1
	subclass: #'Kernel.STBOutFiler2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler2 guid: (Core.GUID fromString: '{f95ce4b8-e5eb-4936-b698-e8d21497e119}')!
Kernel.STBOutFiler2 comment: '`STBOutFiler2` is an `STBOutFiler` for writing the STB 2 binary object serialization format.

The key difference from STB 1 was that loading of objects was delegated to the object class. This remove the requirement to use proxies in many cases, although the pre-existing proxies largely remained. Only `STBSymbolProxy` became obsolete, with `Symbol`s being stored directly.'!
!Kernel.STBOutFiler2 categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler2 methodsFor!

inFilerClass
	^STBInFiler2!

saveSymbol: aSymbol
	"Serialize a <Symbol> into the object stream."

	"As of STB 2 Symbols were no longer proxied - newly deserialised objects are all sent #stbFixup:at:, so the requirement to use proxies to perform even simple fixup was removed. Symbols, as with all other strings, were Ansi encoded."

	| size string |
	self writeClassReference: (self refForObject: Symbol) prefix: PrefixDataMask.
	self register: aSymbol.
	string := aSymbol asAnsiString.
	size := string basicSize.
	stream nextInt32Put: size.
	1 to: size do: [:i | stream nextPut: (string basicAt: i)]! !
!Kernel.STBOutFiler2 categoriesForMethods!
inFilerClass!constants!private! !
saveSymbol:!public!serializing! !
!

!Kernel.STBOutFiler2 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^2! !
!Kernel.STBOutFiler2 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

