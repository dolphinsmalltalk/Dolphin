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

dpiAwarenessContext
	^dpiAwarenessContext!

dpiAwarenessContext: anInteger
	dpiAwarenessContext := anInteger!

scaleToDpiOf: aView
	"Scale the receiver in-place to the dpi of the <View> argument (which would normally be the prospective parent). That parent must have been created with mixed DPI hosting behaviour."

	"Given that we are creating the view in a particular DPI awareness context, we may not want to scale to the DPI of the parent."

	dpiAwarenessContext == DPI_AWARENESS_CONTEXT_SYSTEM_AWARE
		ifTrue: 
			["Scale to the current system DPI rather than the parent DPI"
			^self scaleToDpi: SystemMetrics current dpi].
	(dpiAwarenessContext == DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED
		or: [dpiAwarenessContext == DPI_AWARENESS_CONTEXT_UNAWARE])
			ifTrue: 
				["For unaware modes, we don't want to scale at all as the DPI is always 96."
				^self].
	"For per-monitor modes, scale to the parent, although in practice we shouldn't be here because it isn't possible to host per-monitor aware Windows in windows that are not themselves per-monitor aware."
	super scaleToDpiOf: aView! !

!CreateInDpiAwarenessContext categoriesForMethods!
create:!operations!public! !
dpiAwarenessContext!accessing!public! !
dpiAwarenessContext:!initializing!public! !
scaleToDpiOf:!operations!public! !
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
decorating:withDpiAwareness:!instance creation!public! !
decorating:withDpiAwarenessContext:!instance creation!public! !
!

