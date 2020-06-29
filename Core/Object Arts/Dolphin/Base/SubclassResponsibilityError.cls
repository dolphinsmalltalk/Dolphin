"Filed out from Dolphin Smalltalk 7"!

Error subclass: #SubclassResponsibilityError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SubclassResponsibilityError guid: (GUID fromString: '{34505503-a094-4bd0-a9f3-542f3cfbec32}')!
SubclassResponsibilityError comment: ''!
!SubclassResponsibilityError categoriesForClass!Unclassified! !
!SubclassResponsibilityError methodsFor!

hresult
	"Answer the <HRESULT> error code associated with the receiver.
	Overridden by subclasses to answer more specified HRESULT codes."

	^HRESULT notImplemented!

initialize
	"Private - Initialize the receiver's instance variables"

	messageText := 'Not implemented'! !
!SubclassResponsibilityError categoriesFor: #hresult!accessing!public! !
!SubclassResponsibilityError categoriesFor: #initialize!initializing!private! !

