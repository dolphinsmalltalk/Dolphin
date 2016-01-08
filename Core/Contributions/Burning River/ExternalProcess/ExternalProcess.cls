"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ExternalProcess
	instanceVariableNames: 'commandLine directory millisecondsToWait stdinFilename stdoutFilename stderrFilename si pi stdin stdout stderr'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
ExternalProcess guid: (GUID fromString: '{4C6CE2DA-1739-4610-834E-53A21E4FCBA9}')!
ExternalProcess comment: 'This class represents a native Win32 process.  Methods are available to allow processes to be executed synchronously (where the Dolphin image blocks until the external process completes - use the #executeSync message) or asynchronously (where the Dolphin image continues on its merry way after the external process has been started - use the #executeAsync message).

NOTE: if you execute an ExternalProcess asynchronously YOU are responsible for cleaning up process, thread, and file handles by sending the #close message to your ExternalProcess instance.  Failure to do so will result in resource leaks and, eventually, difficult-to-debug system slowdowns, crashes, and hangs.'!
!ExternalProcess categoriesForClass!Unclassified! !
!ExternalProcess methodsFor!

close
	self closeFiles;
		closeProcessHandles!

closeFiles
	stdin notNil ifTrue: [ stdin close ].
	stdout notNil ifTrue: [ stdout close ].
	stderr notNil ifTrue: [ stderr close ].
!

closeProcessHandles
	KernelLibrary default
		closeHandle: pi hThread;
		closeHandle: pi hProcess

!

commandLine
	"Answer the value of the receiver's ''commandLine'' instance variable."

	^commandLine!

commandLine: anObject
	"Set the value of the receiver's ''commandLine'' instance variable to the argument, anObject."

	commandLine := anObject!

directory
	"Answer the value of the receiver's ''directory'' instance variable."

	^directory!

directory: anObject
	"Set the value of the receiver's ''directory'' instance variable to the argument, anObject."

	directory := anObject!

executeAsync
	"Execute a command by launching a separate process."

	| bResult |

	self initializeFileHandles.

	bResult := KernelLibrary default createProcess: nil
							lpCommandLine: self commandLine
							lpProcessAttributes: nil
							lpThreadAttributes: nil
							bInheritsHandles: true
							dwCreationFlags: 0
							lpEnvironment: nil
							lpCurrentDirectory: self directory
							lpStartupInfo: si
							lpProcessInformation: pi.
	bResult = false ifTrue:
		[ self closeFiles.		"Process and thread handles weren't opened sucessfully."
		ExternalProcessExecuteError signal: 'Unable to start process' with: self ]!

executeSync
	"Execute a command by launching a separate process."

	self executeAsync.
	self waitForCompletion.
	self close!

initialize
	super initialize.

	self millisecondsToWait: self class infiniteTimeoutDelay.

	si := STARTUPINFO new.
	si
		dwFlags: STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES;
		wShowWindow: SW_HIDE.

	pi := PROCESS_INFORMATION new.!

initializeFileHandles
	self stdinFilename notNil ifTrue:
		[ stdin := InheritableFile open: self stdinFilename mode: #open check: true share: #readWrite.
		si hStdInput: stdin handle ].

	self stdoutFilename notNil ifTrue:
		[ stdout := InheritableFile open: self stdoutFilename mode: #open check: false share: #readWrite.
		si hStdOutput: stdout handle ].

	self stderrFilename notNil ifTrue:
		[ stderr := InheritableFile open: self stderrFilename mode: #open check: false share: #readWrite.
		si hStdError: stderr handle ].
!

isAlive
	| waitResult |

	waitResult := KernelLibrary default waitForSingleObject: pi hProcess waitForMilliseconds: 0.
	waitResult = WAIT_TIMEOUT ifTrue: [ ^true ].
	^false
!

isTerminated
	^self isAlive not!

kill
	self kill: 1!

kill: anIntegerExitCode
	"Terminate the external process with extreme prejudice."

	KernelLibrary default terminateProcess: pi hProcess exitCode: anIntegerExitCode!

millisecondsToWait
	^millisecondsToWait!

millisecondsToWait: aNumber
	millisecondsToWait := aNumber!

secondsToWait
	^self millisecondsToWait / 1000!

secondsToWait: aNumber
	self millisecondsToWait: aNumber * 1000!

stderrFilename
	"Answer the value of the receiver's ''stderrFilename'' instance variable."

	^stderrFilename!

stderrFilename: anObject
	"Set the value of the receiver's ''stderrFilename'' instance variable to the argument, anObject."

	stderrFilename := anObject!

stdinFilename
	"Answer the value of the receiver's ''stdinFilename'' instance variable."

	^stdinFilename!

stdinFilename: anObject
	"Set the value of the receiver's ''stdinFilename'' instance variable to the argument, anObject."

	stdinFilename := anObject!

stdoutFilename
	"Answer the value of the receiver's ''stdoutFilename'' instance variable."

	^stdoutFilename!

stdoutFilename: anObject
	"Set the value of the receiver's ''stdoutFilename'' instance variable to the argument, anObject."

	stdoutFilename := anObject!

waitForCompletion
	| waitResult |

	waitResult := KernelLibrary default
					waitForSingleObject: pi hProcess waitForMilliseconds: self millisecondsToWait.
	waitResult = WAIT_FAILED
		ifTrue: [ self kill;
			  	  close.
			  ^ExternalProcessWaitFailure signal: 'Unable to wait on process completion' with: self ].
	waitResult = WAIT_TIMEOUT
		ifTrue: [ self kill;
			  	  close.
			  ^ExternalProcessWaitTimeout signal: 'Process execution timed out' with: self ]! !
!ExternalProcess categoriesFor: #close!execution control!public! !
!ExternalProcess categoriesFor: #closeFiles!operations!private! !
!ExternalProcess categoriesFor: #closeProcessHandles!operations!private! !
!ExternalProcess categoriesFor: #commandLine!accessing!public! !
!ExternalProcess categoriesFor: #commandLine:!accessing!public! !
!ExternalProcess categoriesFor: #directory!accessing!public! !
!ExternalProcess categoriesFor: #directory:!accessing!public! !
!ExternalProcess categoriesFor: #executeAsync!execution control!public! !
!ExternalProcess categoriesFor: #executeSync!execution control!public! !
!ExternalProcess categoriesFor: #initialize!initialize/release!public! !
!ExternalProcess categoriesFor: #initializeFileHandles!initialize/release!private! !
!ExternalProcess categoriesFor: #isAlive!accessing!public! !
!ExternalProcess categoriesFor: #isTerminated!accessing!public! !
!ExternalProcess categoriesFor: #kill!execution control!public! !
!ExternalProcess categoriesFor: #kill:!execution control!public! !
!ExternalProcess categoriesFor: #millisecondsToWait!accessing!public! !
!ExternalProcess categoriesFor: #millisecondsToWait:!accessing!public! !
!ExternalProcess categoriesFor: #secondsToWait!accessing!public! !
!ExternalProcess categoriesFor: #secondsToWait:!accessing!public! !
!ExternalProcess categoriesFor: #stderrFilename!accessing!public! !
!ExternalProcess categoriesFor: #stderrFilename:!accessing!public! !
!ExternalProcess categoriesFor: #stdinFilename!accessing!public! !
!ExternalProcess categoriesFor: #stdinFilename:!accessing!public! !
!ExternalProcess categoriesFor: #stdoutFilename!accessing!public! !
!ExternalProcess categoriesFor: #stdoutFilename:!accessing!public! !
!ExternalProcess categoriesFor: #waitForCompletion!execution control!public! !

!ExternalProcess class methodsFor!

infiniteTimeoutDelay
	^16rFFFFFFFF!

new
	^super new initialize!

referencesToOtherPackages
	"Private - Force references to other packages."
	KernelLibraryExtension		"Global defined in the KernelLibraryExtension package"! !
!ExternalProcess class categoriesFor: #infiniteTimeoutDelay!public! !
!ExternalProcess class categoriesFor: #new!object creation!public! !
!ExternalProcess class categoriesFor: #referencesToOtherPackages!Dependencies!private! !

