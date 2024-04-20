"Filed out from Dolphin Smalltalk"!

CreateWindowDecorator subclass: #CreateInDpiAwarenessContext
	instanceVariableNames: 'dpiAwarenessContext'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CreateInDpiAwarenessContext guid: (GUID fromString: '{e611bc6e-804a-4271-848d-fe40b6c3e7c8}')!

CreateInDpiAwarenessContext comment: ''!

!CreateInDpiAwarenessContext categoriesForClass!Kernel-Objects! !

!CreateInDpiAwarenessContext methodsFor!

create: aView
	"Create a native window for the <View> argument, in a specific DPi awareness context that may be different to the default context of the process."

	^UserLibrary default inDpiAwarenessContext: dpiAwarenessContext do: [decorated create: aView]!

dpiAwarenessContext: anInteger
	dpiAwarenessContext := anInteger! !

!CreateInDpiAwarenessContext categoriesForMethods!
create:!operations!public! !
dpiAwarenessContext:!initializing!private! !
!

!CreateInDpiAwarenessContext class methodsFor!

decorating: aCreateWindow withDpiAwareness: aSymbol
	^self decorating: aCreateWindow
		withDpiAwarenessContext: (UserLibrary dpiAwarenessContextFromName: aSymbol)!

decorating: aCreateWindow withDpiAwarenessContext: anInteger
	<primitive: 157>
	^(self decorating: aCreateWindow)
		dpiAwarenessContext: anInteger;
		yourself! !

!CreateInDpiAwarenessContext class categoriesForMethods!
decorating:withDpiAwareness:!public! !
decorating:withDpiAwarenessContext:!public! !
!

