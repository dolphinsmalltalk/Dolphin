"Filed out from Dolphin Smalltalk"!

Object subclass: #DragDropObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DragDropObject guid: (GUID fromString: '{87b4c480-026e-11d3-9fd7-00a0cc3e4a32}')!
DragDropObject isAbstract: true!
DragDropObject comment: ''!
!DragDropObject categoriesForClass!MVP-DragDrop! !
!DragDropObject methodsFor!

availableFormats
	"Answer an ordered collection of strings identifying each of the receiver's available formats."

	^self subclassResponsibility!

format: formatIdentifier 
	"Answer the receiver's data in the format identified by formatIdentifier. If the requested format is
	unavailable then signals an error."

	^self format: formatIdentifier
		ifAbsent: [self error: 'Requested format is not available: ' , formatIdentifier printString]!

format: formatIdentifier data: formattedDataObject 
	"Set the receiver's format data for the format identified by formatIdentifier to formattedDataObject."

	^self subclassResponsibility!

format: formatIdentifier ifAbsent: aNiladicValuable 
	"Answer the receiver's data in the format identified by formatIdentifier. If the requested format is
	unavailable then evaluate aNiladicValuable."

	^self subclassResponsibility!

isFormatAvailable: formatIdentifier
	"Answer whether the receiver can render itself in the format identified by formatIdentifier."

	^self subclassResponsibility!

isObjectAvailable
	"Answer whether the receiver has #Object amongst its available formats."

	^self isFormatAvailable: #Object!

isObjectKindAvailable: aClass
	"Answer whether the receiver has #Object amongst its available formats
	and that the object is a kind of aClass."

	^self isObjectAvailable and: [self object isKindOf: aClass]!

object
	"Answer the receiver's data in #Object format. If #Object is unavailable then signal an error."

	^self format: #Object!

object: anObject
	"Add to the receiver an 'object' format of a native Smalltalk object."

	self format: #Object data: anObject!

objectIfAbsent: aNiladicValuable
	"Answer the receiver's 'object' format or evaluate aNiladicValuable if it is not supported."

	^self format: #Object ifAbsent: aNiladicValuable!

printOn: aStream 
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self object;
		nextPut: $)! !
!DragDropObject categoriesForMethods!
availableFormats!accessing!public! !
format:!accessing!public! !
format:data:!accessing!public!testing! !
format:ifAbsent:!accessing!public! !
isFormatAvailable:!public!testing! !
isObjectAvailable!public!testing! !
isObjectKindAvailable:!public!testing! !
object!accessing!public! !
object:!accessing!public! !
objectIfAbsent:!accessing!public! !
printOn:!printing!public! !
!

!DragDropObject class methodsFor!

new
	"Answer a new instance of the receiver."

	^super new initialize!

object: anObject
	"Answer a new instance of the receiver initialized with anObject in 'object' format."

	^self new
		object: anObject;
		yourself! !
!DragDropObject class categoriesForMethods!
new!instance creation!public! !
object:!instance creation!public! !
!

