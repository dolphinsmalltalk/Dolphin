"Filed out from Dolphin Smalltalk X6"!

ShellView subclass: #DebuggerShellView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DebuggerShellView guid: (GUID fromString: '{46A54A97-6440-41A5-B00D-C69B68F2A410}')!
DebuggerShellView comment: 'DebuggerShellView is a specialised <ShellView> used by the debugger to ensure that the debugger window will open when invoked following an error opening some other window which leaves the VMs system''s create window hook in an inconsistent state. This is important when the option to disable walkbacks, dropping directly into a debugger instead, is enabled.'!
!DebuggerShellView categoriesForClass!Unclassified! !
!DebuggerShellView methodsFor!

primHookWindowCreate: hookBoolean 
	"Private - Hook the first window creation event for the receiver.
	We override this to force the hooking if another window is currently
	hogging it. This prevents recursive walkbacks in some situations.
	Primitive failure reasons:
		0 	- hookBoolean not a boolean
		1	- already hooked by the view in the failure data
	"

	<primitive: 108>
	^Processor activeProcess primitiveFailureCode == 1 
		ifTrue: 
			["First forcibly unhook so error walkback can be displayed"

			| hooked |
			hooked := Processor activeProcess primitiveFailureData.
			hooked primHookWindowCreate: false.
			Notification 
				signal: 'Forcibly unhooked failed window create of ' , hooked basicPrintString.
			"Now retry"
			super primHookWindowCreate: hookBoolean]
		ifFalse: [self primitiveFailed]! !
!DebuggerShellView categoriesFor: #primHookWindowCreate:!helpers!private! !

