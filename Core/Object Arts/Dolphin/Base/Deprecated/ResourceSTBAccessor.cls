﻿"Filed out from Dolphin Smalltalk"!

ResourceAccessor
	subclass: #ResourceSTBAccessor
	instanceVariableNames: 'classLocator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

ResourceSTBAccessor guid: (Core.GUID fromString: '{0cc7574b-24f8-4714-9068-6c282e7bf1f1}')!

ResourceSTBAccessor isNonInstantiable: true!

ResourceSTBAccessor comment: ''!

!ResourceSTBAccessor categoriesForClass!MVP-Resources! !

!ResourceSTBAccessor methodsFor!

byteArray
	"Private - Answer the receiver's byteArray inst var."

	^self subclassResponsibility!

classLocator
	"Private - Answer the class locator used to import referenced classes into the image"

	^classLocator!

classLocator: aClassLocator
	"Private - Set the receiver's classLocator inst var to aClassLocator.
	This will be injected into the filer used to load the resource so that
	any references to remote classes can be resolved."

	classLocator := aClassLocator!

hiddenObjects
	"Private - Answers a <collection> of the <Object>s that are contained in the receiver's resource
	Implementation note. This is not particularly fast since it loads the resource and any external
	classes it needs into the image. View resources will not be realized as windows however."

	| stream |
	stream := self readStream.
	^
	[(STBInFiler on: stream)
		basicNext;
		readMap] ensure: [stream close]!

initialize
	"Private - Initialize the receiver."

	super initialize.
	self classLocator: ClassLocator new!

loadWithContext: anObject forEdit: isLoadingForEdit
	"Answer an instance of the resource held in the STB file associated with the receiver.
	If the new instance requires a context in which to live, this is provided by context."

	| stream |
	stream := self readStream.
	^
	[(STBInFiler on: stream)
		classLocator: classLocator copyWithCodeBase;
		isUpgrading: isLoadingForEdit;
		context: anObject;
		next]
			ensure: [stream close]!

readStream
	^self subclassResponsibility!

save: anObject as: aResourceClass on: stream
	aResourceClass save: anObject toFiler: (STBOutFiler on: stream)! !

!ResourceSTBAccessor categoriesForMethods!
byteArray!accessing!private! !
classLocator!accessing!private! !
classLocator:!accessing!private! !
hiddenObjects!image stripping!private! !
initialize!initializing!private! !
loadWithContext:forEdit:!operations!public! !
readStream!accessing!private! !
save:as:on:!operations!private! !
!

