"Filed out from Dolphin Smalltalk 7"!

UI.DragDropObject subclass: #'UI.InternalDragDropObject'
	instanceVariableNames: 'availableFormats'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.InternalDragDropObject guid: (Core.GUID fromString: '{66dcba44-45b2-4c2d-8b18-0fbcf0e9ff95}')!
UI.InternalDragDropObject comment: ''!
!UI.InternalDragDropObject categoriesForClass!Unclassified! !
!UI.InternalDragDropObject methodsFor!

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
!UI.InternalDragDropObject categoriesFor: #availableFormats!accessing!public! !
!UI.InternalDragDropObject categoriesFor: #format:data:!accessing!public! !
!UI.InternalDragDropObject categoriesFor: #format:ifAbsent:!accessing!public! !
!UI.InternalDragDropObject categoriesFor: #initialize!initializing!private! !
!UI.InternalDragDropObject categoriesFor: #isFormatAvailable:!public!testing! !

