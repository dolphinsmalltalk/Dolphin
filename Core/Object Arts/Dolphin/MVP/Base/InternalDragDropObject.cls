"Filed out from Dolphin Smalltalk"!

DragDropObject subclass: #InternalDragDropObject
	instanceVariableNames: 'availableFormats'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InternalDragDropObject guid: (GUID fromString: '{87b4c54a-026e-11d3-9fd7-00a0cc3e4a32}')!

InternalDragDropObject comment: ''!

!InternalDragDropObject categoriesForClass!MVP-DragDrop! !

!InternalDragDropObject methodsFor!

availableFormats
	"Answer an ordered collection of strings identifying each of the receiver's available formats."

	^availableFormats keys!

format: formatIdentifier data: formattedDataObject
	"Set the receiver's format data for the format identified by formatIdentifier to formattedDataObject."

	availableFormats at: formatIdentifier put: formattedDataObject!

format: formatIdentifier ifAbsent: aNiladicValuable
	"Answer the receiver's data in the format identified by formatIdentifier. If the requested format is
	unavailable then evaluate aNiladicValuable."

	^availableFormats at: formatIdentifier ifAbsent: aNiladicValuable!

initialize
	"Private - Initialize the receiver."

	availableFormats := LookupTable new!

isFormatAvailable: formatIdentifier
	"Answer whether the receiver can render itself in the format identified by formatIdentifier."

	^availableFormats includesKey: formatIdentifier! !

!InternalDragDropObject categoriesForMethods!
availableFormats!accessing!public! !
format:data:!accessing!public! !
format:ifAbsent:!accessing!public! !
initialize!initializing!private! !
isFormatAvailable:!public!testing! !
!

