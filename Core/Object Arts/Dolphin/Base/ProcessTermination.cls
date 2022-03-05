"Filed out from Dolphin Smalltalk"!

Exception subclass: #ProcessTermination
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProcessTermination guid: (GUID fromString: '{87b4c570-026e-11d3-9fd7-00a0cc3e4a32}')!
ProcessTermination comment: '<ProcessTermination> is a special system <Exception> the sole purpose of which is to provide a safe means to terminate processes cleanly. A ProcessTermination is raised by terminating process, and caught in the base frame (see BlockClosure>>#newProcess), unwinding any protected blocks (see BlockClosure>>#ensure: and BlockClosure>>#ifCurtailed:) on the way. The base frame''s handled from ProcessTermination requests a far return to itself, and it then sends Process>>#shutdown to the active (terminating) Process.

Setting up a handler to catch ProcessTermination is not recommended as it can cause unpredictable behaviour. The #defaultAction for ProcessTermination is to do nothing, so catching a ProcessTermination exception will effectively abort process termination unless the exception is rethrown (see Exception>>#pass). This has application in some circumstances (e.g. on system startup), but interfering with process termination in general is a bad idea. In order to avoid inadvertently trapping ProcessTermination, it derives directly from <Exception> so it is outside the main user exception hierarchies such as that under <Error>. 

For circumstances requiring cleanup code to be run on process shutdown, this should be achieved using BlockClosure>>#ifCurtailed: or BlockClosure>>#ensure:.
'!
!ProcessTermination categoriesForClass!Kernel-Exception Handling! !
!ProcessTermination methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."
	
	^'Terminating %2'!

defaultAction
	"The receiver is an unhandled notification, perform the default action.
	In the case of ProcessTermination signals, we'll only get here on attempts to
	terminate processes which have no base handler, which will only happen if
	the process has not yet completed its initialization, or if it has been
	incompletely terminated. The defaultAction here is to do nothing, and
	if the process is still running, it will shut itself down."
! !
!ProcessTermination categoriesForMethods!
_descriptionFormat!displaying!public! !
defaultAction!handling!public! !
!

