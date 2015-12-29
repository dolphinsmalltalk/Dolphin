"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #StsStbProxy
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsStbProxy guid: (GUID fromString: '{AACE35A6-609D-11D4-B177-000000000000}')!
StsStbProxy comment: ''!
!StsStbProxy categoriesForClass!Unclassified! !
!StsStbProxy methodsFor!

bytes
	^bytes!

bytes: aByteArray 
	bytes := aByteArray!

object: anObject 
	| stream |
	stream := WriteStream on: ByteArray new.
	(STBOutFiler on: stream) nextPut: anObject.
	bytes := stream contents!

odbResolve
	^(STBInFiler on: (ReadStream on: bytes)) next! !
!StsStbProxy categoriesFor: #bytes!public! !
!StsStbProxy categoriesFor: #bytes:!public! !
!StsStbProxy categoriesFor: #object:!public! !
!StsStbProxy categoriesFor: #odbResolve!public! !

!StsStbProxy class methodsFor!

on: anObject 
	(anObject isMemberOf: StsStbProxy) ifTrue: [^anObject].
	^self new object: anObject! !
!StsStbProxy class categoriesFor: #on:!public! !

