"Filed out from Dolphin Smalltalk 7"!

StsImportProxy subclass: #StsDolphinResourceProxy
	instanceVariableNames: 'owningClass resource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsDolphinResourceProxy guid: (GUID fromString: '{fb6a96a8-1fb8-49d8-947b-66a48224ad82}')!
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

