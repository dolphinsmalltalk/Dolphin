"Filed out from Dolphin Smalltalk X6"!

Error subclass: #SubclassResponsibilityError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SubclassResponsibilityError guid: (GUID fromString: '{34505503-A094-4BD0-A9F3-542F3CFBEC32}')!
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

