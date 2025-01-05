"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'UI.AXHostLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.AXHostLibrary guid: (Core.GUID fromString: '{18253c53-1d94-42d1-abe8-3cfaba597275}')!

UI.AXHostLibrary comment: ''!

!UI.AXHostLibrary categoriesForClass!External-Libraries! !

!UI.AXHostLibrary methodsFor!

axWinInit
	"Initialize the AX host window stuff."

	<stdcall: bool AtlAxWinInit>
	^self invalidCall: _failureCode!

loadFlags
	"Private - Includes VM folder in search"

	^LOAD_LIBRARY_SEARCH_DEFAULT_DIRS! !

!UI.AXHostLibrary categoriesForMethods!
axWinInit!initializing!public! !
loadFlags!constants!private! !
!

!UI.AXHostLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the receiver represents."

	^'DolphinAX8'! !

!UI.AXHostLibrary class categoriesForMethods!
fileName!constants!public! !
!

