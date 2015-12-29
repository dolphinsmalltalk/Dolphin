"Filed out from Dolphin Smalltalk X6.2"!

StsImportProxy subclass: #StsDolphinResourceProxy
	instanceVariableNames: 'owningClass resource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsDolphinResourceProxy guid: (GUID fromString: '{FB6A96A8-1FB8-49D8-947B-66A48224AD82}')!
StsDolphinResourceProxy comment: ''!
!StsDolphinResourceProxy categoriesForClass!Unclassified! !
!StsDolphinResourceProxy methodsFor!

owningClass
	^owningClass!

owningClass: aStsClassProxy 
	owningClass := aStsClassProxy!

resource
	^resource!

resource: resourceBytesOrSomething 
	resource := resourceBytesOrSomething! !
!StsDolphinResourceProxy categoriesFor: #owningClass!public! !
!StsDolphinResourceProxy categoriesFor: #owningClass:!public! !
!StsDolphinResourceProxy categoriesFor: #resource!public! !
!StsDolphinResourceProxy categoriesFor: #resource:!public! !

