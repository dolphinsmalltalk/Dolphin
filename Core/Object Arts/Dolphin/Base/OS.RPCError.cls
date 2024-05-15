"Filed out from Dolphin Smalltalk"!

OS.Win32Error
	subclass: #'OS.RPCError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.RPCError guid: (Core.GUID fromString: '{87b4c569-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.RPCError comment: 'Exception class for errors associated with the RPCLibrary'!

!OS.RPCError categoriesForClass!System-Exception Handling! !

!OS.RPCError class methodsFor!

fromHRESULT: aHRESULT
	^self new
		tag: aHRESULT;
		yourself! !

!OS.RPCError class categoriesForMethods!
fromHRESULT:!instance creation!public! !
!

