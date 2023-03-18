"Filed out from Dolphin Smalltalk"!

ResourceAccessor
	subclass: #ResourceDummyAccessor
	instanceVariableNames: 'object'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ResourceDummyAccessor guid: (Core.GUID fromString: '{87b4c6d7-026e-11d3-9fd7-00a0cc3e4a32}')!
ResourceDummyAccessor comment: ''!
!ResourceDummyAccessor categoriesForClass!MVP-Resources! !
!ResourceDummyAccessor methodsFor!

loadWithContext: anObject forEdit: isLoadingForEdit 
	"Answer an instance of the resource held in the receiver.
	If the new instance requires a context in which to live, this is provided by context."

	^object!

object: anObject
	"Set the receiver's object inst var to anObject. This will be answered directly on load."

	object := anObject!

save: anObject as: aResourceClass
	"Save out anObject in the format dictated by aResourceClass."

	self object: anObject.
	self isChanged: true! !
!ResourceDummyAccessor categoriesForMethods!
loadWithContext:forEdit:!operations!public! !
object:!accessing!public! !
save:as:!operations!public! !
!

!ResourceDummyAccessor class methodsFor!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!ResourceDummyAccessor class categoriesForMethods!
stbVersion!binary filing!public! !
!

