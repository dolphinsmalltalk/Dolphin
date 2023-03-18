"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'OS.COM.Examples.RandomStreamSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Examples.RandomStreamSessionManager guid: (Core.GUID fromString: '{0851ca36-6a4f-41de-80d8-77d4c965d723}')!
OS.COM.Examples.RandomStreamSessionManager comment: ''!
!OS.COM.Examples.RandomStreamSessionManager categoriesForClass!System-Support! !
!OS.COM.Examples.RandomStreamSessionManager methodsFor!

main
	self mainShellClass show.
	RandomStream registerClassFactory! !
!OS.COM.Examples.RandomStreamSessionManager categoriesForMethods!
main!operations!public! !
!

!OS.COM.Examples.RandomStreamSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^UI.Shell! !
!OS.COM.Examples.RandomStreamSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

