"Filed out from Dolphin Smalltalk"!

Kernel.STBProxy
	subclass: #STBSymbolProxy
	instanceVariableNames: 'string'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STBSymbolProxy guid: (Core.GUID fromString: '{87b4c6f3-026e-11d3-9fd7-00a0cc3e4a32}')!
STBSymbolProxy comment: 'STBSymbolProxy has been deprecated. It is only present for loading STB files saved pre-Dolphin 5. In Dolphin 6.0 the STBInFiler delegates the task of reading a serialized instance to the class of that instance, and this removes the need for the use of STBProxy''s in many cases. STBSymbolProxy is such as case, as it was only present to allow the symbol to be interned on deserialization. The class can just as easily perform this task in its #stbReadFrom:format: implementation, and ditching STBSymbolProxy reduces the size of a typical view resource file by approximately 5%.

Dolphin 5.0 introduced the version 1 STB format that pre-registered a number of classes such as STBSymbolProxy. This means that Dolphin 5.x STB files cannot actually contain a referenced to the STBSymbolProxy class, only Dolphin 4.x and earlier STB files can. In Dolphin 6 the reference number pre-allocated for STBSymbolProxy has been remapped to the Symbol class, and Symbol class>>stbReadFrom:format: understands how to read the old proxy serialization stream format.'!
!STBSymbolProxy categoriesForClass!Deprecated! !
!STBSymbolProxy methodsFor!

stbFixup: inFiler at: anInteger 
	| anObject |
	anObject := self value.
	inFiler fixup: anInteger to: anObject.
	^anObject!

value
	^string asSymbol! !
!STBSymbolProxy categoriesForMethods!
stbFixup:at:!converting!public! !
value!converting!public! !
!

