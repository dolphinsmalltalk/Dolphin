"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ExternalProcess
	instanceVariableNames: 'commandLine directory millisecondsToWait stdinFilename stdoutFilename stderrFilename si pi stdin stdout stderr processExitCode threadExitCode'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalProcess guid: (GUID fromString: '{4c6ce2da-1739-4610-834e-53a21e4fcba9}')!
ExternalProcess comment: 'This class represents a native Win32 process.  Methods are available to allow processes to be executed synchronously (where the Dolphin image blocks until the external process completes - use the #executeSync message) or asynchronously (where the Dolphin image continues on its merry way after the external process has been started - use the #executeAsync message).  If you are running an ExternalProcess asynchronously you can use the #isAlive and #isTerminated methods to determine if the Win32 process has completed
its work or is still running.

NOTE: if you execute an ExternalProcess asynchronously YOU are responsible for cleaning up process, thread, and file handles by sending the #close message to your ExternalProcess instance.  Failure to do so will result in resource leaks and, eventually, difficult-to-debug system slowdowns, crashes, and hangs.

(The following explanation of how the various directories involved in spawning an ExternalProcess are related and used was provided by Peter Kenny in a message on the comp.lang.smalltalk.dolphin newsgroup, and is used here with his kind permission):

There may be four directories involved in spawning an ExternalProcess (any two or more could be the same, but for generality let them be different):

(a) The current working directory (CWD) of the Smalltalk application which spawns the process.
(b) The directory containing the executable which is to be spawned.
(c) The CWD of the spawned External Process.
(d) The directory in which the redirected standard outputof the ExternalProcess is to be stored.

The first of these is given, of course. The others are specified, if required, as follows:

1. The first item on the command line specifies (b), either absolutely or relative to (a).
2. The ''directory'' argument specifies (c), either absolutely or relative to (a). If the ''directory'' argument is not used, (c) is the same as (a).
3. The ''stdoutFilename'' parameter specifies (d), either absolutely or relative to (a) (and similarly for stdin and stderr).
4. Any files referenced by the External Process which are passed as command line arguments are specified either absolutely or relative to (c).
'!
!ExternalProcess categoriesForClass!Unclassified! !
!ExternalProcess methodsFor!

close
	self
		closeFiles;
		closeProcessHandles!

closeFiles
	stdin notNil ifTrue: [ stdin close ].
	stdout notNil ifTrue: [ stdout close ].
	stderr notNil ifTrue: [ stderr close ]
!

closeProcessHandles
	KernelLibrary default
		closeHandle: pi hThread;
		closeHandle: pi hProcess

!

commandLine
	"Answer the value of the receiver's ''commandLine'' instance variable."

	^commandLine!

commandLine: aString
	commandLine := aString!

directory
	"Answer the value of the receiver's ''directory'' instance variable."

	^directory!

directory: aString
	directory := aString!

executeAsync
	"Execute a command by launching a separate process."

	| bResult |

	self initializeFileHandles.

	bResult := KernelLibrary default
				createProcess: nil
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

executeCommand:aStringCommand inDirectory:aDirectoryString waitForSeconds:anIntegerSeconds stdin: stdinStream stdout: stdoutBlock stderr: stderrBlock
	"Execute a command by launching a separate process.
		stdinStream should be a stream of input text.
		outBlock and errorBlock are monadic valuables, evaluated with the corresponding
			stream text produced by the external process.

	Any of the arguments stdinStream, stdoutBlock, or stderrBlock may be nil."

	| tmpStdinName tmpStdoutName tmpStderrName stream | 

	stdinStream notNil ifTrue:
		[ tmpStdinName := File temporaryFilename.
		stream := FileStream write: tmpStdinName.
		stream nextPutAll: stdinStream contents.
		stream close ].
	stdoutBlock notNil ifTrue: [ tmpStdoutName := File temporaryFilename ].
	stderrBlock notNil ifTrue: [ tmpStderrName := File temporaryFilename ].

	self
		commandLine: aStringCommand;
		directory: aDirectoryString;
		secondsToWait: anIntegerSeconds.
	tmpStdinName notNil ifTrue: [ self stdinFilename: tmpStdinName ].
	tmpStdoutName notNil ifTrue: [ self stdoutFilename: tmpStdoutName ].
	tmpStderrName notNil ifTrue: [ self stderrFilename: tmpStderrName ].

	"NOTE: the following code doesn't trap potential errors but the #ensure:
	block gives us a chance to clean up the temporary files."

	[ self executeSync.

	(Array with: tmpStdoutName with: tmpStderrName)
		with: (Array with: stdoutBlock with: stderrBlock)
		do:
			[ :fileName :block |

			block notNil
				ifTrue:
					[ stream := FileStream read: fileName.
					block value: stream contents.
					stream close ] ] ]
	ensure:
		[ (tmpStdinName notNil and: [ File exists: tmpStdinName ])
			ifTrue: [ File delete: tmpStdinName ].
		(tmpStdoutName notNil and: [ File exists: tmpStdoutName ])
			ifTrue: [ File delete: tmpStdoutName ].
		(tmpStderrName notNil and: [ File exists: tmpStderrName ])
			ifTrue: [ File delete: tmpStderrName ] ]!

executeSync
	"Execute a command by launching a separate process."

	self executeAsync.
	self waitForCompletion.
	self getExitCodes.
	self close!

getExitCodes
	"Retrieve process and thread exit codes for the started process. 

	NOTE: this method must be invoked before the #close message is sent; otherwise the
		process and thread handles will not be valid."

	| bool dword |

	dword := DWORD new.
	bool := KernelLibrary default getExitCodeThread: pi hThread lpExitCode: dword.
	bool ifFalse: [ KernelLibrary default systemError ].
	dword value ~= STILL_ACTIVE
		ifTrue: [ threadExitCode := dword value ].

	bool := KernelLibrary default getExitCodeProcess: pi hProcess lpExitCode: dword.
	bool ifFalse: [ KernelLibrary default systemError ].
	dword value ~= STILL_ACTIVE
		ifTrue: [ processExitCode := dword value ]!

initialize
	super initialize.
	self millisecondsToWait: self class infiniteTimeoutDelay.
	si := STARTUPINFOW new.
	si
		dwFlags: STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES;
		wShowWindow: SW_HIDE.
	pi := PROCESS_INFORMATION new!

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
	"Test to see if the external process is alive, i.e. still running."

	| waitResult |

	waitResult := KernelLibrary default waitForSingleObject: pi hProcess dwMilliseconds: 0.
	waitResult = WAIT_TIMEOUT ifTrue: [ ^true ].
	^false
!

isTerminated
	"Test to see if the external process has terminated, i.e. has completed."

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

processExitCode
	processExitCode isNil
		ifTrue: [ self getExitCodes ].
	^processExitCode		"May still be nil, in which case exit codes are not
					yet available because the process is still running."!

secondsToWait
	^self millisecondsToWait / 1000!

secondsToWait: aNumber
	self millisecondsToWait: aNumber * 1000!

stderrFilename
	"Answer the value of the receiver's ''stderrFilename'' instance variable."

	^stderrFilename!

stderrFilename: aString
	stderrFilename := aString!

stdinFilename
	"Answer the value of the receiver's ''stdinFilename'' instance variable."

	^stdinFilename!

stdinFilename: aString
	stdinFilename := aString!

stdoutFilename
	"Answer the value of the receiver's ''stdoutFilename'' instance variable."

	^stdoutFilename!

stdoutFilename: aString
	stdoutFilename := aString!

threadExitCode
	threadExitCode isNil
		ifTrue: [ self getExitCodes ].
	^threadExitCode		"May still be nil, in which case exit codes are not
					yet available because the thread is still running."!

waitForCompletion
	| waitResult |

	waitResult := KernelLibrary default
					waitForSingleObject: pi hProcess dwMilliseconds: self millisecondsToWait.
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
!ExternalProcess categoriesFor: #executeCommand:inDirectory:waitForSeconds:stdin:stdout:stderr:!operations!public! !
!ExternalProcess categoriesFor: #executeSync!execution control!public! !
!ExternalProcess categoriesFor: #getExitCodes!public! !
!ExternalProcess categoriesFor: #initialize!initialize/release!public! !
!ExternalProcess categoriesFor: #initializeFileHandles!initialize/release!private! !
!ExternalProcess categoriesFor: #isAlive!accessing!public! !
!ExternalProcess categoriesFor: #isTerminated!accessing!public! !
!ExternalProcess categoriesFor: #kill!execution control!public! !
!ExternalProcess categoriesFor: #kill:!execution control!public! !
!ExternalProcess categoriesFor: #millisecondsToWait!accessing!public! !
!ExternalProcess categoriesFor: #millisecondsToWait:!accessing!public! !
!ExternalProcess categoriesFor: #processExitCode!public! !
!ExternalProcess categoriesFor: #secondsToWait!accessing!public! !
!ExternalProcess categoriesFor: #secondsToWait:!accessing!public! !
!ExternalProcess categoriesFor: #stderrFilename!accessing!public! !
!ExternalProcess categoriesFor: #stderrFilename:!accessing!public! !
!ExternalProcess categoriesFor: #stdinFilename!accessing!public! !
!ExternalProcess categoriesFor: #stdinFilename:!accessing!public! !
!ExternalProcess categoriesFor: #stdoutFilename!accessing!public! !
!ExternalProcess categoriesFor: #stdoutFilename:!accessing!public! !
!ExternalProcess categoriesFor: #threadExitCode!public! !
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

