"Filed out from Dolphin Smalltalk"!

CreateWindowDecorator subclass: #CreateMixedDpiHost
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CreateMixedDpiHost guid: (GUID fromString: '{536a81c5-4789-4976-811f-1c9d26ec6d41}')!

CreateMixedDpiHost comment: ''!

!CreateMixedDpiHost categoriesForClass!Kernel-Objects! !

!CreateMixedDpiHost methodsFor!

create: aView
	"Create a native window for the <View> argument, decorating it with mixed DPI hosting behaviour."

	^UserLibrary default withDpiHostingBehavior: DPI_HOSTING_BEHAVIOR_MIXED
		do: [decorated create: aView]! !

!CreateMixedDpiHost categoriesForMethods!
create:!operations!public! !
!

