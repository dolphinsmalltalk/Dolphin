"Filed out from Dolphin Smalltalk"!

UI.CreateWindowDecorator
	subclass: #'UI.CreateMixedDpiHost'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CreateMixedDpiHost guid: (Core.GUID fromString: '{536a81c5-4789-4976-811f-1c9d26ec6d41}')!

UI.CreateMixedDpiHost comment: ''!

!UI.CreateMixedDpiHost categoriesForClass!Kernel-Objects! !

!UI.CreateMixedDpiHost methodsFor!

create: aView
	"Create a native window for the <View> argument, decorating it with mixed DPI hosting behaviour."

	^User32 withDpiHostingBehavior: DPI_HOSTING_BEHAVIOR_MIXED
		do: [decorated create: aView]! !

!UI.CreateMixedDpiHost categoriesForMethods!
create:!operations!public! !
!

