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

!UI.CreateInDpiAwarenessContext categoriesForMethods!
create:!operations!public! !
dpiAwarenessContext!accessing!public! !
dpiAwarenessContext:!initializing!public! !
scaleToDpiOf:!operations!public! !
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
decorating:withDpiAwareness:!instance creation!public! !
decorating:withDpiAwarenessContext:!instance creation!public! !
!

