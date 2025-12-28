"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'External.PermanentLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.PermanentLibrary guid: (Core.GUID fromString: '{87b4c583-026e-11d3-9fd7-00a0cc3e4a32}')!

External.PermanentLibrary isNonInstantiable: true!

External.PermanentLibrary comment: '`PermanentLibrary` is the class of `DynamicLinkLibrary`s which are expected to remain permanently open in order for the system to continue functioning, and/or to avoid some sequencing issues initializing the system on startup. As of Dolphin 8 this set is limited to the OS kernel library (required to load other libraries), and the Virtual Machine itself.'!

!External.PermanentLibrary categoriesForClass!External-Libraries! !

!External.PermanentLibrary methodsFor!

close
	"Release the reference the receiver has to the External Library it represents. This may
	not cause the library to be unloaded, so it may still function.
	It is really not a good idea to do this for the default instances of permanent libraries 
	because it will break the VM and everything else."

	^self ~~ self class default and: [super close]!

isSelfEvaluating
	^true!

loadFlags
	"Private - Only ever load Windows system libraries from %windows%\system32. The VM library is not a system library, but cannot be loaded from the image in any case."

	^LOAD_LIBRARY_SEARCH_SYSTEM32! !

!External.PermanentLibrary categoriesForMethods!
close!public!realizing/unrealizing! !
isSelfEvaluating!public!testing! !
loadFlags!constants!private! !
!

!External.PermanentLibrary class methodsFor!

clear
	"Private - Clear down cached external function addresses from previous runs."

	self clearProcAddresses!

closeDefault
	"Private - Close the default instance of the receiver (if there is one).
	In the case of the receiver, we ignore this request because the default is not lazily opened."!

onStartup2
	"Private - Perform session startup processing for the receiver."

	"Earlier startup initialization is required for the permanent libraries, so there is nothing to do now."!

open
	"Answer the singleton instance of the receiver (it cannot be re-opened)"

	^default! !

!External.PermanentLibrary class categoriesForMethods!
clear!initializing!private! !
closeDefault!private!realizing/unrealizing! !
onStartup2!event handling!private! !
open!instance creation!public! !
!

