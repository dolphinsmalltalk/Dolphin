"Filed out from Dolphin Smalltalk 7"!

RuntimeSessionManager subclass: #COMRandomStreamSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
COMRandomStreamSessionManager guid: (GUID fromString: '{0851ca36-6a4f-41de-80d8-77d4c965d723}')!
COMRandomStreamSessionManager comment: ''!
!COMRandomStreamSessionManager categoriesForClass!System-Support! !
!COMRandomStreamSessionManager methodsFor!

main
	self mainShellClass show.
	COMRandomStream registerClassFactory! !
!COMRandomStreamSessionManager categoriesFor: #main!operations!public! !

!COMRandomStreamSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Shell! !
!COMRandomStreamSessionManager class categoriesFor: #mainShellClass!constants!public! !

