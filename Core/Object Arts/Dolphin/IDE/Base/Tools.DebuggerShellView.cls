"Filed out from Dolphin Smalltalk 7"!

UI.ShellView subclass: #'Tools.DebuggerShellView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.DebuggerShellView guid: (Core.GUID fromString: '{46a54a97-6440-41a5-b00d-c69b68f2a410}')!
Tools.DebuggerShellView comment: 'DebuggerShellView is a specialised <ShellView> used by the debugger to ensure that the debugger window will open when invoked following an error opening some other window which leaves the VMs system''s create window hook in an inconsistent state. This is important when the option to disable walkbacks, dropping directly into a debugger instead, is enabled.'!
!Tools.DebuggerShellView categoriesForClass!Unclassified! !
!Tools.DebuggerShellView methodsFor!

primHookWindowCreate: hookBoolean
	"Private - Hook the first window creation event for the receiver.
	We override this to force the hooking if another window is currently hogging it. This prevents recursive walkbacks in some situations."

	"Primitive failure reasons:
		InvalidParameter1	- hookBoolean not a boolean
		IllegalStateChange 	- already hooked by another view
		NotSupported		- The VM is for console apps only"

	<primitive: 108>
	^_failureCode == _PrimitiveFailureCode.IllegalStateChange
		ifTrue: 
			["First forcibly unhook so error walkback can be displayed"
			self primHookWindowCreate: nil.
			Notification signal: 'Forcibly unhooked failed window creation'.
			"Now retry"
			super primHookWindowCreate: hookBoolean]
		ifFalse: [self primitiveFailed: _failureCode]! !
!Tools.DebuggerShellView categoriesFor: #primHookWindowCreate:!helpers!private! !

