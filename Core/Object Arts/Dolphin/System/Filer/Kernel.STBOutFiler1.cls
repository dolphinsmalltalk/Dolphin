"Filed out from Dolphin Smalltalk"!

Kernel.STBOutFiler0
	subclass: #'Kernel.STBOutFiler1'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler1 guid: (Core.GUID fromString: '{0157af13-aed1-4241-a85a-0fdfb8b3e8a7}')!
Kernel.STBOutFiler1 comment: '`STBOutFiler1` is an `STBOutFiler` for writing STB 1 binary object serialization format.

STB 1 was introduced in Dolphin 5. It differed little from STB 0, but included pre-registration of some classes to fix a chicken-before-egg problem but also to reduce the size of the STB streams.'!
!Kernel.STBOutFiler1 categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler1 methodsFor!

inFilerClass
	^STBInFiler1!

lastPredefined
	"Private - Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

saveString: aString
	"Serialize a <String> into the object stream."

	"In STB 1, String was pre-registered but UnicodeString was not. We map byte strings to the pre-registered AnsiString, and register Utf16String in the place of UnicodeString, but write a locator for UnicodeString so that the result will deserialize correctly in an old image with UnicodeString rather than Utf16String."

	| bytes |
	aString basicClass == Utf16String
		ifTrue: 
			[self writeUnicodeStringClassReference.
			bytes := aString asByteArray]
		ifFalse: 
			[| ansi |
			ansi := aString asAnsiString.
			ansi asUtf8String = aString
				ifTrue: 
					[self writeClassReference: (self refForObject: AnsiString) prefix: PrefixDataMask.
					bytes := ansi asByteArray]
				ifFalse: 
					[self writeUnicodeStringClassReference.
					bytes := aString asUtf16String asByteArray]].
	self register: aString.
	self writeByteObject: bytes!

writeUnicodeStringClassReference
	(self refForObject: Utf16String)
		ifNotNil: [:refIndex | self writeClassReference: refIndex prefix: PrefixDataMask]
		ifNil: 
			[stream
				nextInt32Put: (##(PrefixClassMask | PrefixBytesMask) bitOr: ##(13 bitShift: PrefixLocatorLenShift));
				nextPutAll: ##('UnicodeString' asByteArray).
			self register: Utf16String]! !
!Kernel.STBOutFiler1 categoriesForMethods!
inFilerClass!constants!private! !
lastPredefined!constants!private! !
saveString:!public!serializing! !
writeUnicodeStringClassReference!private!serializing! !
!

!Kernel.STBOutFiler1 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	^1! !
!Kernel.STBOutFiler1 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

