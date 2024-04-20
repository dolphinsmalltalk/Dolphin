"Filed out from Dolphin Smalltalk"!

UI.CreateWindowDecorator
	subclass: #'UI.CreateInDpiAwarenessContext'
	instanceVariableNames: 'dpiAwarenessContext'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CreateInDpiAwarenessContext guid: (Core.GUID fromString: '{e611bc6e-804a-4271-848d-fe40b6c3e7c8}')!

UI.CreateInDpiAwarenessContext comment: ''!

!UI.CreateInDpiAwarenessContext categoriesForClass!Kernel-Objects! !

!UI.CreateInDpiAwarenessContext methodsFor!

create: aView
	"Create a native window for the <View> argument, in a specific DPi awareness context that may be different to the default context of the process."

	^User32 inDpiAwarenessContext: dpiAwarenessContext do: [decorated create: aView]!

dpiAwarenessContext: anInteger
	dpiAwarenessContext := anInteger! !

!UI.CreateInDpiAwarenessContext categoriesForMethods!
create:!operations!public! !
dpiAwarenessContext:!initializing!private! !
!

!UI.CreateInDpiAwarenessContext class methodsFor!

decorating: aCreateWindow withDpiAwareness: aSymbol
	^self decorating: aCreateWindow
		withDpiAwarenessContext: (UserLibrary dpiAwarenessContextFromName: aSymbol)!

decorating: aCreateWindow withDpiAwarenessContext: anInteger
	<primitive: 157>
	^(self decorating: aCreateWindow)
		dpiAwarenessContext: anInteger;
		yourself! !

!UI.CreateInDpiAwarenessContext class categoriesForMethods!
decorating:withDpiAwareness:!public! !
decorating:withDpiAwarenessContext:!public! !
!

