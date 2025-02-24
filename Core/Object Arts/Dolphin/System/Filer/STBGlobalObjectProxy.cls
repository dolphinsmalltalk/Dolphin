﻿"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #STBGlobalObjectProxy
	instanceVariableNames: 'symbol object'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STBGlobalObjectProxy guid: (Core.GUID fromString: '{87b4c6ed-026e-11d3-9fd7-00a0cc3e4a32}')!

STBGlobalObjectProxy comment: '`STBGlobalObjectProxy` is part of a mechanism used in the original binary format Dolphin packages that was used to save/restore ''global'' variables (i.e. static variables in the Smalltalk namespace). It was not used in the source format packages introduced in Dolphin 5. 

The mechanism is now retained only to enable loading of old STB files. It was designed rather specifically for code packages, as in other cases having the side effect of creating a global variable when deserialising an object graph from STB is rather undesirable. The mechanism is no longer supported by the latest version of the STx filers in Dolphin 8 and should be considered deprecated.'!

!STBGlobalObjectProxy categoriesForClass!System-Binary storage! !

!STBGlobalObjectProxy methodsFor!

object: anObject
	"Private - Set the receiver's object inst var."

	object := anObject!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents.
	We must not use #become: to swap the receiver with the represented
	object because the object is either:
		a reference to an existing global, or
		a new global that may be nil but in this case there will never
		be other references to the proxy.

	We need to tell inFiler to replace its readMap entry for our answer."

	| anObject |
	anObject := self value.
	inFiler fixup: anInteger to: anObject.
	^anObject!

stbSaveOn: anSTxOutFiler
	"Save out a serialised representation of the receiver to anSTBOutFiler.
	This is a rather unusual case. This outputs itself as its own proxy.
	Mmm... It's just a trick used by STBOutFiler, best not to copy this idea."

	anSTxOutFiler saveObject: self as: self!

symbol: aSymbol
	"Private - Set the symbol inst var to aSymbol."

	symbol := aSymbol!

value
	"Install object as a global in the Smalltalk System Dictionary and answer it."

	^Smalltalk at: symbol put: object! !

!STBGlobalObjectProxy categoriesForMethods!
object:!accessing!private! !
stbFixup:at:!accessing!public! !
stbSaveOn:!binary filing!public! !
symbol:!accessing!private! !
value!converting!public! !
!

!STBGlobalObjectProxy class methodsFor!

for: anObject name: aSymbol
	"Answer an instance of the receiver representing the global anObject
	which will be made global on load with the name asymbol."

	^self basicNew
		symbol: aSymbol;
		object: anObject;
		yourself! !

!STBGlobalObjectProxy class categoriesForMethods!
for:name:!instance creation!public! !
!

