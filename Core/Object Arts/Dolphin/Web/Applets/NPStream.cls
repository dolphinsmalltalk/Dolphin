"Filed out from Dolphin Smalltalk X6"!

COMInterfaceImp subclass: #NPStream
	instanceVariableNames: 'npStream applet mode mimeType handler'
	classVariableNames: ''
	poolDictionaries: 'PluginConstants'
	classInstanceVariableNames: ''!
NPStream guid: (GUID fromString: '{2648C89F-6B87-11D3-97BB-0080C8D59432}')!
NPStream comment: 'NPStream is an abstract class that provides a Smalltalk interface onto a web browser''s stream objects.

Instance Variables:
	npStream		<NPStream> object which the stream wraps.
	applet		<NPAppletContext> which the stream is owned by.
	mode		<integer> mode of the stream.
	mimeType		<readableStringt> describing the contents of the stream.
	handler		<NPSynchronousStreamHandler> which receives notifications (#onXXX) about the stream from the browser.'!
!NPStream categoriesForClass!Plugin-Support! !
!NPStream methodsFor!

applet
	"Answer the applet which owns the receiver."

	^applet!

basicFree
	"Private - Request to the internet browser to close and delete the receivers
	stream after being successfully completed. This will result in the
	#OnDestroy: being sent to the receiver."

	^self destroy: NPRES_DONE!

destroy: reason
	"Private - Request the internet browser to close and delete the receivers stream.
	This will result in the #pluginDestroyStream: being sent to the receiver.
	May raise an HRESULTError if the operation was not successful."

	npStream Destroy: reason!

free
	"Release any external resources associated with the receiver."

	npStream notNull ifTrue: [
		self basicFree]!

handler
	"Answer the NPSynchronousStreamHandler which receieves the notifications
	from the web browser when something of interest happens to
	the receiever. The notifications are called onXXX:..."

	^handler!

isSeekable
	"Answer whether the stream is inherently seekable. For NPN_RequestRead
	to operate the mode must have been set to NP_SEEK when the stream was
	created."

	^npStream seekable!

lastModified
	"Answer the TimeStamp of when the contents of the receivers URL,
	if applicable, were last modified."

	^TimeStamp fromSYSTEMTIME:
		(FILETIME fromUnixTime: self npStream lastModified) asSYSTEMTIME!

mimeType
	"Answer the <readableString> mimeType of the stream associated with the receiver."

	mimeType isNil ifTrue: [mimeType := npStream mimeType].
	^mimeType!

mode
	"Answer the mode of the receiver."

	^mode!

mode: anInteger
	"Private - Set the mode of the receiver."

	mode := anInteger!

npStream
	"Private - Answer the INPStream which wraps the internet browser stream 
	associated with the receiver."

	^npStream!

onDestroy: reason
	"Notification from the internet browser that a stream is being
	closed and deleted. Answer an NPError value."

	| answer |
	answer := self handler onStreamClosed: self reason: reason.
	npStream := nil.
	^answer!

OnDestroy: reason
	"Private - Notification from the internet browser that the stream associated with the receiver
	is being destroyed for the <NPReason>, reason. Inform the applet (which maintains a registry
	of all its active streams) and then forward the notification to the streams handler (which might 
	very well be this applet)."

	| nperr |
	nperr := self onDestroy: reason.
	^applet hresultFromNPError: nperr!

OnStreamAsFile: filename
	"Private - Notification from the internet browser hosting this applet that the stream wrapped by
	the <INPStream> argument, piStream, has been downloaded to the file in the browser cache
	identified by the <String> pathname, filename"

	self handler onStreamAsFile: self filename: filename.
	^S_OK!

OnWrite: offset cBuf: bufLen pbBuf: buf plRet: plRet
	"Private - Notification from the internet browser of a range of bytes from the 
	stream associated with the receiver.
	Answer (via the output argument plRet) the numbers of bytes read or a 
	negative value to indicate an error and stop the stream."

	plRet value: (self handler onWriteStream: self offset: offset length: bufLen buffer: buf).
	^S_OK
!

OnWriteReady: pcMaxBytes
	"Private - Notification from the internet browser (via the plug-hole) that data is available from the
	stream associated with the receiver. Answer through the output argument, pcMaxBytes,  the maximum
	number of bytes that can be accepted through a subsequent OnWrite() notification."

	pcMaxBytes value: (self handler onWriteStreamReady: self).
	^S_OK!

setApplet: anNPApplet npStream: aNPStream handler: streamHandler
	"Private - Initialize the identity instance variables of the receiver."

	mode := NP_NORMAL.
	applet := anNPApplet.
	npStream := aNPStream.
	handler := streamHandler!

size
	"Answer the length of the stream in bytes.
	Note that some streams may answer 0; old FTP servers or CGI scripts."

	^self npStream end!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^#(##(INPStreamEvents))!

url
	"Answer the receivers <readableString> url of the origin or destination of the stream 
	associated with the receiver."

	^self npStream url! !
!NPStream categoriesFor: #applet!accessing!public! !
!NPStream categoriesFor: #basicFree!operations!private! !
!NPStream categoriesFor: #destroy:!operations!private! !
!NPStream categoriesFor: #free!operations!public! !
!NPStream categoriesFor: #handler!accessing!public! !
!NPStream categoriesFor: #isSeekable!public!testing! !
!NPStream categoriesFor: #lastModified!accessing!public! !
!NPStream categoriesFor: #mimeType!accessing!public! !
!NPStream categoriesFor: #mode!accessing!public! !
!NPStream categoriesFor: #mode:!accessing!private! !
!NPStream categoriesFor: #npStream!accessing!private! !
!NPStream categoriesFor: #onDestroy:!events-plugin!public! !
!NPStream categoriesFor: #OnDestroy:!events-plugin!private! !
!NPStream categoriesFor: #OnStreamAsFile:!events-plugin!private! !
!NPStream categoriesFor: #OnWrite:cBuf:pbBuf:plRet:!events-plugin!private! !
!NPStream categoriesFor: #OnWriteReady:!events-plugin!private! !
!NPStream categoriesFor: #setApplet:npStream:handler:!initializing!private! !
!NPStream categoriesFor: #size!accessing!public! !
!NPStream categoriesFor: #supportedInterfaces!constants!public! !
!NPStream categoriesFor: #url!accessing!public! !

NPStream methodProtocol: #'NPDolphin.INPStreamEvents' attributes: #() selectors: #(#OnDestroy: #OnStreamAsFile: #OnWrite:cBuf:pbBuf:plRet: #OnWriteReady:)!

!NPStream class methodsFor!

stream: piNPStream context: context handler: handler
	"Answer a new instance of the receiver wrapping the <INPStream>, piNPStream, 
	for the <NPApplet>, context, and <npStreamHandler>, handler."

	^self new
		setApplet: context
		npStream: piNPStream
		handler: handler! !
!NPStream class categoriesFor: #stream:context:handler:!instance creation!public! !

