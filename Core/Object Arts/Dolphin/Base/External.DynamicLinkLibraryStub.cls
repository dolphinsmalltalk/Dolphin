"Filed out from Dolphin Smalltalk"!

Kernel.ProtoObject
	subclass: #'External.DynamicLinkLibraryStub'
	instanceVariableNames: 'libraryClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.DynamicLinkLibraryStub guid: (Core.GUID fromString: '{2c412c1c-e4c6-4d45-a346-0773de70202e}')!

External.DynamicLinkLibraryStub comment: ''!

!External.DynamicLinkLibraryStub categoriesForClass!System-Support! !

!External.DynamicLinkLibraryStub methodsFor!

clear
	"Private - Reinitialize this module instance, e.g. on startup."!

doesNotUnderstand: failedMessage
	^failedMessage forwardTo: libraryClass openDefault!

isOpen
	^false!

libraryClass: aClass
	libraryClass := aClass! !

!External.DynamicLinkLibraryStub categoriesForMethods!
clear!private!realizing/unrealizing! !
doesNotUnderstand:!exceptions!public! !
isOpen!public!testing! !
libraryClass:!initializing!private! !
!

!External.DynamicLinkLibraryStub class methodsFor!

libraryClass: aClass
	<primitive: 157>
	^self new
		libraryClass: aClass;
		yourself! !

!External.DynamicLinkLibraryStub class categoriesForMethods!
libraryClass:!public! !
!

