"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'OS.Examples.FileSystemMonitorSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Examples.FileSystemMonitorSessionManager guid: (Core.GUID fromString: '{a00427fb-6695-464a-8e1f-251a892444a6}')!
OS.Examples.FileSystemMonitorSessionManager comment: ''!
!OS.Examples.FileSystemMonitorSessionManager categoriesForClass!System-Support! !
!OS.Examples.FileSystemMonitorSessionManager methodsFor!

main
	| fsm |
	fsm := self mainShellClass show.
	self argc > 1 
		ifTrue: 
			[| path |
			path := self argv at: 2.
			(File isDirectory: path) ifTrue: [fsm directory: path]]! !
!OS.Examples.FileSystemMonitorSessionManager categoriesForMethods!
main!operations!public! !
!

!OS.Examples.FileSystemMonitorSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^FileSystemMonitor! !
!OS.Examples.FileSystemMonitorSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

