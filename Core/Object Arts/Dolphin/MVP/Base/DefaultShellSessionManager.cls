"Filed out from Dolphin Smalltalk X6.2"!

RuntimeSessionManager subclass: #DefaultShellSessionManager
	instanceVariableNames: 'mainShellClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DefaultShellSessionManager guid: (GUID fromString: '{6554F3CE-3AD5-4EF5-86CE-14AC1596FE2D}')!
DefaultShellSessionManager comment: ''!
!DefaultShellSessionManager categoriesForClass!System-Support! !
!DefaultShellSessionManager methodsFor!

main
	self mainShellClass show!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^mainShellClass!

mainShellClass: aShellClass 
	mainShellClass := aShellClass! !
!DefaultShellSessionManager categoriesFor: #main!operations-startup!public! !
!DefaultShellSessionManager categoriesFor: #mainShellClass!constants!public! !
!DefaultShellSessionManager categoriesFor: #mainShellClass:!constants!public! !

!DefaultShellSessionManager class methodsFor!

installNew
	self shouldNotImplement! !
!DefaultShellSessionManager class categoriesFor: #installNew!public! !

