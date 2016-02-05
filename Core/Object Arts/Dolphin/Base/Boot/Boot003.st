SequencedStream subclass: #StdioFileStream
	instanceVariableNames: 'stream isText name oldFd'
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!

!SessionManager methodsFor!

openConsoleStreams
	"Private - Open the standard console I/O streams. Note that the actual C-runtime library
	stdin/stdout/stderr streams will be correctly set up so that it is possible to use the CRT
	stdio functions such as puts(), printf(), etc."

	| kernel |
	stdioStreams isNil ifFalse: [^self].
	kernel := KernelLibrary default.
	stdioStreams := Array 
				with: (StdioFileStream 
						attach: (kernel getStdHandle: STD_INPUT_HANDLE)
						toFd: 0
						mode: #read)
				with: (StdioFileStream 
						attach: (kernel getStdHandle: STD_OUTPUT_HANDLE)
						toFd: 1
						mode: #append)
				with: (StdioFileStream 
						attach: (kernel getStdHandle: STD_ERROR_HANDLE)
						toFd: 2
						mode: #append)! !
!SessionManager categoriesFor: #openConsoleStreams!operations!private! !

!CRTLibrary methodsFor!

_close: anInteger 
	"Close the file associated with the descriptor, anInteger, and release the descriptor."

	<cdecl: sdword _close sdword>
	^self invalidCall!

_dup: anInteger 
	"Create and answer a duplicate file descriptor for the open file with descriptor, anInteger.
	Note that the underlying file handle is also duplicated."

	<cdecl: sdword _dup sdword>
	^self invalidCall!

_dup2: anInteger handle2: anInteger2 
	"Reassign a file descriptor by copying a duplicate of the file descriptor, anInteger, over
	the file descriptor, anInteger2. Note that the underlying file handle of the first
	descriptor is duplicated, and any open file associated with the target file descriptor is
	closed."

	<cdecl: sdword _dup2 sdword sdword>
	^self invalidCall! !
!CRTLibrary categoriesFor: #_close:!CRT functions-low level I/O!public! !
!CRTLibrary categoriesFor: #_dup:!CRT functions-low level I/O!public! !
!CRTLibrary categoriesFor: #_dup2:handle2:!CRT functions-low level I/O!public! !

!StdioFileStream class methodsFor!

attach: anExternalHandle toFd: fdInteger mode: modeSymbol 
	"Answer a new instance of the receiver representing a text stdio stream with the file
	descriptor, fdInteger, attached to the OS file handle, anExternalHandle, The <symbol>
	argument identifies the manner in which the file is opened, #read for a read-only stream
	(e.g. stdin), or any other mode integer for a writable stream."

	^self 
		attach: anExternalHandle
		toFd: fdInteger
		mode: modeSymbol
		text: true!

attach: anExternalHandle toFd: fdInteger mode: modeSymbol text: aBoolean 
	"Answer a new instance of the receiver representing a stdio stream with the file descriptor,
	fdInteger, attached to the OS file handle, anExternalHandle, The <symbol> argument
	identifies the manner in which the file is opened, #read for a read-only stream (e.g.
	stdin), or any other mode integer for a writable stream. If aBoolean is true, then the
	stream is in text translation mode, if false it is in binary mode."

	^self basicNew 
		attach: anExternalHandle
		toFd: fdInteger
		mode: modeSymbol
		text: aBoolean! !
!StdioFileStream class categoriesFor: #attach:toFd:mode:!instance creation!public! !
!StdioFileStream class categoriesFor: #attach:toFd:mode:text:!instance creation!public! !

!StdioFileStream methodsFor!

attach: anExternalHandle toFd: fdInteger mode: aSymbol text: aBoolean 
	"Private - Attach the stdio descriptor identified by fdInteger (usually one of 0=stdin,
	1=stdout, or 2-stderr) to the specified OS file, and open a stdio stream onto it in the
	specified read/write and text/binary modes (usual Smalltalk FileStream conventions for the
	interpretation of the mode and text parameters applies)."

	| newFd crt |
	crt := CRTLibrary default.
	"1: Preserve the existing file descriptor (fd) for later restoration by dup'ing it"
	oldFd := crt _dup: fdInteger.
	oldFd < 0 ifTrue: [CRTError signal].
	"2: Attach an fd to the provided OS file handle"
	newFd := crt _open_osfhandle: anExternalHandle flags: 0.
	newFd < 0 ifTrue: [CRTError signal].
	"3: Redirect target fd to the OS file"
	(crt _dup2: newFd handle2: fdInteger) < 0 ifTrue: [CRTError signal].
	"4: Dispose of the fd created in step 2 and dup'd in step 3 so we don't leak it and the duplicate OS handle it contains"
	(crt _close: newFd) < 0 ifTrue: [CRTError signal].
	"5: Finally open a stdio stream onto the target fd"
	stream := crt _fdopen: fdInteger
				mode: (aSymbol == #read ifTrue: ['r'] ifFalse: ['w']) , (aBoolean ifTrue: ['t'] ifFalse: ['b']).
	stream isNil ifTrue: [CRTError signal].
	isText := aBoolean.
	self beFinalizable!

close
	"Relinquish any external resources associated with the receiver, and put the
	receiver into a 'closed' state. Answer the receiver."

	| stdFd |
	stream isNull ifTrue: [^self].
	self beUnfinalizable.
	stdFd := self fileno.
	CRTLibrary default fclose: stream.
	stream := nil.
	oldFd isNil 
		ifFalse: 
			["Restore original stdio stream from saved descriptor"
			(CRTLibrary default)
				_dup2: oldFd handle2: stdFd;
				_close: oldFd.
			oldFd := nil]! !
!StdioFileStream categoriesFor: #attach:toFd:mode:text:!initializing!private! !
!StdioFileStream categoriesFor: #close!operations!public! !

"19:59:44, 03 February 2016: Compressed changes"!

"19:59:45, 03 February 2016: Image saved"!
