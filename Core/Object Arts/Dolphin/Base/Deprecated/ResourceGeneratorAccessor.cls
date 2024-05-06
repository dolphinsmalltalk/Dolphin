"Filed out from Dolphin Smalltalk"!

ResourceAccessor subclass: #ResourceGeneratorAccessor
	instanceVariableNames: 'class selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceGeneratorAccessor guid: (GUID fromString: '{87b4c6d8-026e-11d3-9fd7-00a0cc3e4a32}')!

ResourceGeneratorAccessor comment: ''!

!ResourceGeneratorAccessor categoriesForClass!MVP-Resources! !

!ResourceGeneratorAccessor methodsFor!

canSave
	"Answer whether the receiver is capable of saving a resource."

	^false!

class: aClass selector: aSelector
	"Set the receiver's inst vars from the parameters."

	class := aClass.
	selector := aSelector!

loadWithContext: anObject forEdit: isLoadingForEdit 
	"Answer an instance of the resource held represented by the receiver.
	The new instance requires a context in which to live, this is provided by context."

	^class perform: selector with: anObject!

save: anObject as: aResource
	"Save out anObject in the format dictated by aResourceClass."

	^self shouldNotImplement! !

!ResourceGeneratorAccessor categoriesForMethods!
canSave!public!testing! !
class:selector:!instance creation!public! !
loadWithContext:forEdit:!operations!public! !
save:as:!operations!public! !
!

!ResourceGeneratorAccessor class methodsFor!

class: aClass selector: aSelector
	"Answer a new instance of the receiver initialized from the parameters."

	^self new
		class: aClass selector: aSelector;
		yourself!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !

!ResourceGeneratorAccessor class categoriesForMethods!
class:selector:!instance creation!public! !
stbVersion!instance creation!public! !
!

