"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #ObjectANSITest
	instanceVariableNames: 'object'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ObjectANSITest guid: (GUID fromString: '{7a6475f8-046f-44eb-8488-10ed58579d6c}')!
ObjectANSITest comment: ''!
!ObjectANSITest categoriesForClass!Unclassified! !
!ObjectANSITest methodsFor!

canonicalObject
	^object!

protocol
	^#Object!

setUp
	super setUp.
	object := Object new.! !
!ObjectANSITest categoriesFor: #canonicalObject!public! !
!ObjectANSITest categoriesFor: #protocol!public! !
!ObjectANSITest categoriesFor: #setUp!public! !

