"Filed out from Dolphin Smalltalk 7"!

UI.RuntimeSessionManager subclass: #FileSystemMonitorSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
FileSystemMonitorSessionManager guid: (Core.GUID fromString: '{a00427fb-6695-464a-8e1f-251a892444a6}')!
FileSystemMonitorSessionManager comment: ''!
!FileSystemMonitorSessionManager categoriesForClass!System-Support! !
!FileSystemMonitorSessionManager methodsFor!

main
	| fsm |
	fsm := self mainShellClass show.
	self argc > 1 
		ifTrue: 
			[| path |
			path := self argv at: 2.
			(File isDirectory: path) ifTrue: [fsm directory: path]]! !
!FileSystemMonitorSessionManager categoriesFor: #main!operations!public! !

!FileSystemMonitorSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^FileSystemMonitor! !
!FileSystemMonitorSessionManager class categoriesFor: #mainShellClass!constants!public! !

