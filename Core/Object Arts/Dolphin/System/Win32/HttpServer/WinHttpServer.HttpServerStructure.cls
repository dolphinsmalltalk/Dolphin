"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'WinHttpServer.HttpServerStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WinHttpServer.HttpServerStructure guid: (Core.GUID fromString: '{20120606-4b34-448e-9c39-69371965b5b6}')!
WinHttpServer.HttpServerStructure isNonInstantiable: true!
WinHttpServer.HttpServerStructure comment: ''!
!WinHttpServer.HttpServerStructure categoriesForClass!External-Data-Structured! !
!WinHttpServer.HttpServerStructure methodsFor!

byteSize
	^bytes class isIndirection ifTrue: [super byteSize] ifFalse: [bytes size]! !
!WinHttpServer.HttpServerStructure categoriesFor: #byteSize!accessing!public! !

