"Filed out from Dolphin Smalltalk 7"!

Object subclass: #NPSynchronousStreamHandler
	instanceVariableNames: 'semaphore localFilename url downloadUrl openTimeout openTimer npresult'
	classVariableNames: 'DefaultOpenTimeout Opened Pending TimedOut Waiting'
	poolDictionaries: 'PluginConstants'
	classInstanceVariableNames: ''!
NPSynchronousStreamHandler guid: (GUID fromString: '{ccb8755b-6c2e-11d3-bdd5-004005a6900b}')!
NPSynchronousStreamHandler comment: 'An NPSynchronousStreamHandler is an applet stream handler which blocks its clients Smalltalk process until the full contents of a stream onto a URL have been fully downloaded into a locally held file. 

Instance Variables:
	semaphore	<Semaphore> to be signalled once the stream operation has completed.
	localFilename	<readableString> name of the local file which contains the contents of the stream.
	url		<readableString> URL requested for download by this stream.
	downloadUrl	<readableString> URL actually being downloaded by this stream.
	openTimeout	<integer> seconds to wait before concluding download is not going to start
	openTimer		<Process>. Monitors for timeout.
	npresult		<integer>. Code from NPRES enumeration indicating result of dowload

'!
!NPSynchronousStreamHandler categoriesForClass!Plugin-Support! !
!NPSynchronousStreamHandler methodsFor!

continueWithResult: npres
	"Private - Unblock the client process having saved down the <integer> result code,
	npresult, which is one of:
		NPRES_BASE-1			Timed out before stream open notification received.
		NPRES_DONE				Successfully downloaded
		NPRES_USER_BREAK		User aborted the download
		NPRES_NETWORK_ERR	Error downloading file"

	npresult := npres.
	semaphore signal!

defaultOpenTimeout
	"Answer an <integer> which is the default number of seconds to wait
	between requesting the download of a stream and the receipt of the new stream
	notification from the browser before deciding that it isn't going to work!!
	The browser should respond fairly quickly (it doesn't have to actually download
	the data, just report that the download has started)."

	^DefaultOpenTimeout!

initialize
	"Private - Initialize the state of the receiver."

	semaphore := Processor activeProcess isMain 
					ifTrue: [ModalMsgLoop new]
					ifFalse: [Semaphore new].
	openTimeout := -1.
	npresult := Pending.
	url := ''!

localFilename
	"Private - Answer the name of the file held on the local machine which contains
	the contents of the stream. This will be nil if the download has not yet 
	been completed by the browser, but in that case the calling process is
	blocked until the data is available (i.e. this acts like a 'future')."

	self wait.
	npresult ~= NPRES_DONE ifTrue: [NPApplet errorDownloadFailed: self url reason: npresult].
	^localFilename!

onStreamAsFile: anAppletStream filename: filenameOrNil
	"Private - Notification that the streams url contents
	have been copied to a local drive. Signal the blocked
	client process to continue."

	localFilename := filenameOrNil.
	self continueWithResult: NPRES_DONE
!

onStreamClosed: anAppletStream reason: reason
	"Private - Notification that a stream connected to the receiver will be
	destroyed. The reason for this closure is documented by the
	reason argument:

	NPRES_DONE				Normal stream completion
	NPRES_USER_BREAK		Action cancelled by user
	NPRES_NETWORK_ERR		Failed because of network problems.

	Answer the NPError value to be returned to the internet browser."

	self continueWithResult: reason.
	^NPERR_NO_ERROR
!

onStreamOpened: anNPInStream onURL: urlString
	"Private - Notification that a new stream has been created
	and connected to the receiver. Set the desired stream mode and
	the error code to be returned to the internet browser. In this
	case we want synchronous behaviour, so the NP_ASFILEONLY
	mode is simplest and most efficient if supported, with NP_ASFILE
	as a fallback."

	"The download has been initiated, so we can abort the open timeout"
	downloadUrl := urlString.
	npresult := Opened.
	openTimer isNil ifFalse: [openTimer terminate. openTimer := nil].

	anNPInStream mode:
		(NPDolphin current browserAPIVersion < 11 
			ifTrue: [NP_ASFILE] 
			ifFalse: [NP_ASFILEONLY]).

	^NPERR_NO_ERROR!

onWriteStream: anAppletStream offset: offset length: length buffer: buffer
	"Private - Accept the next block of data from anAppletStream. Answer the
	number of bytes consumed, or a negative value to indicate an
	error occurred."

	^length
!

onWriteStreamReady: anAppletStream
	"Private - Answer the maximum number of bytes the receiver will
	accept from anAppletStream in the next onWrite:... notification."

	^SmallInteger maximum
!

openTimeout
	"Answer the number of seconds to wait after starting to wait for a download to start
	before deciding that it isn't going to happen. If < 0, the the timeout is infinite."

	^openTimeout!

openTimeout: secs
	"Set the number of seconds to wait after starting to wait for a download to start
	before deciding that it isn't going to happen."

	openTimeout := secs!

startOpenTimer
	"Private - Fork off a process which pauses for reasonable delay and
	then if it finds that the dowload has not started, initiates a timeout."

	| timeout |
	npresult := Waiting.
	(timeout := self openTimeout) < 0 ifTrue: [^self].
	openTimer := [
		(Delay forSeconds: timeout) wait.
		downloadUrl isNil ifTrue: [self continueWithResult: NPRES_BASE - 1]
	] forkAt: Processor userBackgroundPriority
!

url
	"Answer the <readableString> URL which the receiver is expecting to receive."

	^url!

url: urlString
	"Set the <readableString> URL which the receiver is expecting to receive."

	url := urlString!

wait
	"Suspend active Process until the receiver is informed that the
	internet browser has either succeeded or failed to download the
	contents of a stream onto the local machine. If the download failed
	or timed out before it started, then raise an error."

	npresult = Pending ifTrue: [self startOpenTimer].
	npresult < TimedOut ifTrue: [semaphore wait; signal]
! !
!NPSynchronousStreamHandler categoriesFor: #continueWithResult:!private!process synchronisation! !
!NPSynchronousStreamHandler categoriesFor: #defaultOpenTimeout!accessing!public! !
!NPSynchronousStreamHandler categoriesFor: #initialize!initializing!private! !
!NPSynchronousStreamHandler categoriesFor: #localFilename!accessing!private! !
!NPSynchronousStreamHandler categoriesFor: #onStreamAsFile:filename:!events-plugin!private! !
!NPSynchronousStreamHandler categoriesFor: #onStreamClosed:reason:!events-plugin!private! !
!NPSynchronousStreamHandler categoriesFor: #onStreamOpened:onURL:!events-plugin!private! !
!NPSynchronousStreamHandler categoriesFor: #onWriteStream:offset:length:buffer:!events-plugin!private! !
!NPSynchronousStreamHandler categoriesFor: #onWriteStreamReady:!events-plugin!private! !
!NPSynchronousStreamHandler categoriesFor: #openTimeout!accessing!public! !
!NPSynchronousStreamHandler categoriesFor: #openTimeout:!accessing!public! !
!NPSynchronousStreamHandler categoriesFor: #startOpenTimer!helpers!private! !
!NPSynchronousStreamHandler categoriesFor: #url!accessing!public! !
!NPSynchronousStreamHandler categoriesFor: #url:!accessing!public! !
!NPSynchronousStreamHandler categoriesFor: #wait!private!process synchronisation! !

NPSynchronousStreamHandler methodProtocol: #npStreamHandler attributes: #() selectors: #(#onStreamAsFile:filename: #onStreamClosed:reason: #onStreamOpened:onURL: #onWriteStream:offset:length:buffer: #onWriteStreamReady:)!

!NPSynchronousStreamHandler class methodsFor!

defaultOpenTimeout: secs
	"Set the default open timeout to be the specified number of seconds."

	DefaultOpenTimeout := secs!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Pending := NPRES_BASE - 4.
	Waiting := NPRES_BASE - 3.
	Opened := NPRES_BASE - 2.
	TimedOut := NPRES_BASE - 1.
	self defaultOpenTimeout: 10!

new
	"Answer a new, initialized, instance of the receiver."

	^super new initialize!

newUrl: url
	"Answer a new instance of the receiver initialized to handle a stream
	on the specified url."

	^self newUrl: url timeout: self defaultOpenTimeout!

newUrl: url timeout: secs
	"Answer a new instance of the receiver initialized to handle a stream
	on the specified url."

	^super new
		initialize;
		url: url;
		openTimeout: secs;
		yourself! !
!NPSynchronousStreamHandler class categoriesFor: #defaultOpenTimeout:!accessing!public! !
!NPSynchronousStreamHandler class categoriesFor: #initialize!initializing!private! !
!NPSynchronousStreamHandler class categoriesFor: #new!instance creation!public! !
!NPSynchronousStreamHandler class categoriesFor: #newUrl:!instance creation!public! !
!NPSynchronousStreamHandler class categoriesFor: #newUrl:timeout:!instance creation!public! !

