"Filed out from Dolphin Smalltalk 7"!

File subclass: #InheritableFile
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
InheritableFile guid: (GUID fromString: '{948edc81-5c17-11d5-be18-00010240d5e2}')!
InheritableFile comment: ''!
!InheritableFile categoriesForClass!Unclassified! !
!InheritableFile methodsFor!

open
	"Open, or reopen, the file described by the receiver with the receiver's
	access and sharing modes so it can be inherited by child processes.
	Answer the receiver or signal a FileException if the operation fails."

	| fh sa |

	sa := SECURITY_ATTRIBUTES new.
	sa bInheritHandle: true asDword.

	fh := KernelLibrary default
			createFile: spec
			dwDesiredAccess: self accessFlags
			dwSharedMode: shareFlags
			lpSecurityAttributes: sa
			dwCreationDistribution: self openFlags
			dwFlagsAndAttributes: Win32Constants.FILE_ATTRIBUTE_NORMAL
			hTemplateFile: nil.
	fh asSignedInteger == -1 
		ifTrue: [ self signalOsError: false ]
		ifFalse: [ self handle: fh ].

	self beFinalizable.	
! !
!InheritableFile categoriesFor: #open!operations!public! !

