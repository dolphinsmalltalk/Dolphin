"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STxInFilerWrapper'
	instanceVariableNames: 'stream decorated'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STxInFilerWrapper guid: (Core.GUID fromString: '{1c2e68ec-f7bd-48a9-90f2-ab4118aa3a94}')!

Kernel.STxInFilerWrapper isNonInstantiable: true!

Kernel.STxInFilerWrapper comment: '`STBInFilerWrapper` is an abstract class of `STxInFiler` decorators.
'!

!Kernel.STxInFilerWrapper categoriesForClass!System-Binary storage! !

!Kernel.STxInFilerWrapper methodsFor!

atEnd
	"Answer true if the receiver is positioned at end of its stream."

	^stream atEnd

!

basicNext
	^decorated basicNext!

characterValue: anInteger
	"Answer the <Character> for the specified <Integer> code from the object stream."

	^decorated characterValue: anInteger!

classAt: anInteger
	"Answer the read map value for a <Class> with the specified reference."

	^decorated classAt: anInteger!

classLocator
	^decorated classLocator!

contents
	"Answer an array of the objects stored in the stream."

	^self inFiler contents!

context
	^decorated context!

context: anObject
	decorated context: anObject!

converterFor: aClass
	^decorated converterFor: aClass!

deferAction: aNiladicValuable
	^decorated deferAction: aNiladicValuable!

fixup: anInteger to: anObject
	^decorated fixup: anInteger to: anObject!

inFiler
	^decorated!

inFilerClass
	^self subclassResponsibility!

locatorKeyFor: aClass
	"Answer a <String> name for the <Class> argument that receiver's class locator can use to resolve the class."

	^decorated locatorKeyFor: aClass!

next
	"Answer the next object from the receiver's stream."

	^self inFiler next!

nextIndex
	"Answer the next unused object reference."

	^decorated nextIndex!

objectAt: anInteger
	"Answer the map value at anInteger. Signal an exception if there is no such entry."

	^decorated objectAt: anInteger!

readByteObject: aClass size: anInteger
	^decorated readByteObject: aClass size: anInteger!

readExtensibleCollection: aClass format: anSTBClassConversion size: anInteger
	^decorated
		readExtensibleCollection: aClass
		format: anSTBClassConversion
		size: anInteger!

readLookupTable: aClass format: anSTBClassConversion size: anInteger
	^decorated
		readLookupTable: aClass
		format: anSTBClassConversion
		size: anInteger!

readNil
	"Read a nil from the object stream"

	^nil!

readObjectOfClass: aClass format: anSTBClassConversion size: anInteger
	^decorated readObjectOfClass: aClass format: anSTBClassConversion size: anInteger!

readObjectOfClass: aClass size: anInteger
	^decorated readObjectOfClass: aClass size: anInteger!

readSizeOf: aClass
	"Read the indexable size of an object of the specified <Class> from the object stream."

	^decorated readSizeOf: aClass!

readString: aClass format: aSTxClassConversion
	"Deserialize a <String> from the object stream."

	^decorated readString: aClass format: aSTxClassConversion!

readSymbol: aSTxClassConversion
	"Deserialize a <Symbol> from the object stream."

	^decorated readSymbol: aSTxClassConversion!

register: anObject
	^decorated register: anObject!

reset
	decorated reset!

stream: aStream
	stream := aStream.
	decorated := (self inFilerClass on: stream)
				decorator: self;
				yourself!

stxFormatName
	"Answer the format name, either STB or STL."

	^self inFilerClass stxFormatName!

version
	"Answer the format version of the STB/STL stream."

	^decorated version! !

!Kernel.STxInFilerWrapper categoriesForMethods!
atEnd!public!testing! !
basicNext!deserializing!public! !
characterValue:!helpers!public! !
classAt:!public! !
classLocator!public! !
contents!enumerating!public! !
context!accessing!public! !
context:!public! !
converterFor:!public! !
deferAction:!public! !
fixup:to:!public! !
inFiler!accessing!private! !
inFilerClass!constants!private! !
locatorKeyFor:!public! !
next!operations!public! !
nextIndex!public! !
objectAt:!accessing!public! !
readByteObject:size:!deserializing!public! !
readExtensibleCollection:format:size:!operations!public! !
readLookupTable:format:size:!operations!public! !
readNil!deserializing!public! !
readObjectOfClass:format:size:!public! !
readObjectOfClass:size:!deserializing!public! !
readSizeOf:!deserializing!public! !
readString:format:!deserializing!public! !
readSymbol:!deserializing!public! !
register:!public! !
reset!public! !
stream:!initializing!private! !
stxFormatName!constants!public! !
version!accessing!public! !
!

!Kernel.STxInFilerWrapper class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^STxFiler icon!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self new stream: aStream! !

!Kernel.STxInFilerWrapper class categoriesForMethods!
icon!constants!public! !
on:!instance creation!public! !
!

