"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Kernel.SubclassResponsibilityError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.SubclassResponsibilityError guid: (Core.GUID fromString: '{34505503-a094-4bd0-a9f3-542f3cfbec32}')!

Kernel.SubclassResponsibilityError comment: ''!

!Kernel.SubclassResponsibilityError categoriesForClass!Kernel-Exception Handling! !

!Kernel.SubclassResponsibilityError methodsFor!

defaultMessageText
	^'Not implemented'!

hresult
	"Answer the <HRESULT> error code associated with the receiver.
	Overridden by subclasses to answer more specified HRESULT codes."

	^HRESULT notImplemented! !

!Kernel.SubclassResponsibilityError categoriesForMethods!
defaultMessageText!accessing!private! !
hresult!accessing!public! !
!

