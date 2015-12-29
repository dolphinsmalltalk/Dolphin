"Filed out from Dolphin Smalltalk X6"!

DragDropObject subclass: #InternalDragDropObject
	instanceVariableNames: 'availableFormats'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InternalDragDropObject guid: (GUID fromString: '{87B4C54A-026E-11D3-9FD7-00A0CC3E4A32}')!
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
!InternalDragDropObject categoriesFor: #availableFormats!accessing!public! !
!InternalDragDropObject categoriesFor: #format:data:!accessing!public! !
!InternalDragDropObject categoriesFor: #format:ifAbsent:!accessing!public! !
!InternalDragDropObject categoriesFor: #initialize!initializing!private! !
!InternalDragDropObject categoriesFor: #isFormatAvailable:!public!testing! !

