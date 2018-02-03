"Filed out from Dolphin Smalltalk 7"!

Object subclass: #HttpServerObject
	instanceVariableNames: 'lib'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerObject guid: (GUID fromString: '{7b0e8449-2c26-4746-8033-5372855f37ec}')!
HttpServerObject comment: ''!
!HttpServerObject categoriesForClass!Unclassified! !
!HttpServerObject methodsFor!

lib
	lib ifNil: [lib := self class library].
	^lib! !
!HttpServerObject categoriesFor: #lib!public! !

!HttpServerObject class methodsFor!

library
	^HttpApiLibrary default!

new
	^super new initialize! !
!HttpServerObject class categoriesFor: #library!public! !
!HttpServerObject class categoriesFor: #new!public! !

