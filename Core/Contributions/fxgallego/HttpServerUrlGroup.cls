"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerUrlGroup
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerUrlGroup guid: (GUID fromString: '{3ce8be5e-3d73-4279-9b3a-0019d7f5d50d}')!
HttpServerUrlGroup comment: ''!
!HttpServerUrlGroup categoriesForClass!Unclassified! !
!HttpServerUrlGroup methodsFor!

addUrl: aString
	self lib addUrl: aString toUrlGroup: self id!

bindQueue: httpApiQueue
	self lib bindQueue: httpApiQueue handle toUrlGroup: self id!

id
	^id!

initializeOn: httpApiSession
	id := self lib createUrlGroup: httpApiSession id! !
!HttpServerUrlGroup categoriesFor: #addUrl:!public! !
!HttpServerUrlGroup categoriesFor: #bindQueue:!public! !
!HttpServerUrlGroup categoriesFor: #id!public! !
!HttpServerUrlGroup categoriesFor: #initializeOn:!private! !

!HttpServerUrlGroup class methodsFor!

on: session
	^self new initializeOn: session! !
!HttpServerUrlGroup class categoriesFor: #on:!public! !

