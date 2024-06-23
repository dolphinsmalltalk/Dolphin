"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ObjectANSITest
	instanceVariableNames: 'object'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!ObjectANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!public! !
!

