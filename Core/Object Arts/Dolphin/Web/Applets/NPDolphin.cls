"Filed out from Dolphin Smalltalk X6"!

COMInterfaceImp subclass: #NPDolphin
	instanceVariableNames: 'plugHole versions allAppletHolders namedAppletHolders'
	classVariableNames: 'Current'
	poolDictionaries: 'PluginConstants'
	classInstanceVariableNames: ''!
NPDolphin guid: (GUID fromString: '{2648C8A1-6B87-11D3-97BB-0080C8D59432}')!
NPDolphin comment: 'NPDolphin is the singleton class whose instance hosts the main inbound COM interface, <INPPlugHole>, from the Dolphin browser plug-in DLL. It is responsible for initialization and shutdown of the plug-in image, and for initiating new applet instances and destroying existing applet instances when instructed. 

Once an applet has been created, inbound messages from the browser plug-in are directed to the applet''s own COM interface. Once up and running an applet calls out to the browser via the NPDolphin singleton which then forwards on the calls via the INPPlugHole interface it recovered from the SessionManager''s startup arguments.

Instance Variables:
	plugHole		<INPPlugHole> interface onto the plug-in COM object running in the browser''s thread.
	versions		<Array> of two elements describing the plug-in''s API version requirement and the browser''s provision.
	allAppletHolders	<SharedSet> of <DeferredValues> wrapping the applets hosted on the current page.
	namedAppletHolders <DeferredValueTable> for looking up applets by <readableString>names.

Class Variables:
	Current		<NPDolphin> singleton instance.

'!
!NPDolphin categoriesForClass!Plugin-Support! !
!NPDolphin methodsFor!

aboutBitmap
	"Private - Answer a default image to use for the receiver's splash screen"

	^OLEPicture fromFile: 'Resources\Plugin.jpg' usingLocator: FileLocator installRelative.
!

aboutPlugin
	"Displays a splash screen for the receiver"

	(Splash bitmap: self aboutBitmap) show!

allApplets
	"Answer Set of applets contained on the current page. This method will block
	until all applets are loaded"

	^allAppletHolders collect: [:each | each value ]

!

appletAt: aStringName ifAbsent: exceptionHandler
	"Answers the applet with aStringName in the receiver."

	"When an applet is registered they will be as an instance of DeferredValue.
	When access from the namedAppletHolders table it will be dereferenced to the 
	applet itself. If the applet is still loading this method will block until it is ready"

	^namedAppletHolders at: aStringName ifAbsent: exceptionHandler!

browserAPIVersion
	"Answer the version of the plugin API implemented by the browser."

	^self versions last!

defaultAppletClass
	"Answer the class of <NPApplet> to be used as the context for new applet instances
	created in the receiver."

	^NPApplet!

destroyStream: piStream reason: npReason
	"Private - Request that the browser destroy the specified stream, giving the reason code, npReason."

	plugHole DestroyStream: piStream reason: npReason!

getURL: instance url: url target: target
	"Private - Request the internet browser to open a new stream on the specified <String> URL,
	directed to the window named by the <String>, target, on behalf of the applet identified 
	by the browser instance handle, instance. There is no return value as the operation
	is asynchronous, but an exception may be raised if it download could not be initiated."

	plugHole GetURL: instance URL: url Target: target!

getURLNotify: instance url: url target: target notifyData: notifyData
	"Private - Request the internet browser to open a new stream on the specified <String> URL,
	directed to the window named by the <String>, target, on behalf of the applet identified 
	by the browser instance handle, instance.
	On completing the use of the stream an onURLNotify:... message will be sent
	to the instance including the 32-bit value, notifyData, to distinguish it.
	May raise an HRESULTError exception, the status code of which is the underlying
	NPError value from the Netscape plugin API.
	Note: Unfortunately this call appears to be unsupported by MS Internet Explorer, and 
	therefore it is of somewhat limited utility."

	plugHole GetURLNotify: instance URL: url Target: target NotifyData: notifyData!

initialize
	"Private - Initialize the state of the receiver. This is setup
	so that the next time Dolphin is loaded up, the receiver will
	create its plugin messages view."

	SessionManager current when: #sessionStarted send: #onStartup to: self.!

newStream: instance mimeType: mimeType target: target 
	"Private - Ask the plug-hole to create a new INPStream on a new browser stream for the specified MIME type
	and browser target window."

	^plugHole newStream: instance mimeType: mimeType target: target!

OnInitialize
	"Private - Initialize call-in from Browser. This is called immediately after the plug-in has been loaded on
	encountering the first Dolphin applet on a page which uses the same image, and is a chance to 
	perform once off initialization for this plug-in session.
	At present there is nothing more for us to do."

	self status: 0 message: 'Dolphin plugin initialized'.
	^S_OK!

OnNewApplet: mimeType Instance: instance mode: mode 
		argc: argc argn: argn argv: argv 
		cSaved: countSaved pbSaved: saved
		ppiNewInstance: ppiNewInstance
	"Private - Notification from the host internet browser on the creation of a new instance. Each applet on 
	a page is a separate instance. Build a dictionary of the arguments from the applets EMBED tag to 
	parameterize the applet. Answers, via the ppiNewInstance output argument, 	an <INPApplet> COM 
	interface onto a new <NPApplet> (sub)instance through which all subsequent communications with 
	the applet from the plug-hole will be received."

	| arguments context if hr |
	"Arguments from EMBED tag are passed as an array of argument name strings and an array of argument value
	 strings, both with the number of elements specified by the <integer> argument, argc."
	arguments := LookupTable new.
	(StructureArray fromAddress: argn yourAddress length: argc elementClass: LPVOID) with:
		(StructureArray fromAddress: argv yourAddress length: argc elementClass: LPVOID) do: [:pn :pv |
			arguments at: (String fromAddress: pn value) asUppercase put: (String fromAddress: pv value)].

	"Create a new <NPApplet> subinstance to represent the applet"
	context := self defaultAppletClass
				mimeType: mimeType
				instance: instance
				displayMode: mode
				attributes: arguments.

	"Pass the saved data to the new instance, giving it an opportunity to restore state, and report
	 back an error code if necessary."
	hr := context onNew: saved.

	"Finally pass out an <INPApplet> for the plug-hole to communicate with subsequently."
	if := context queryInterface: INPApplet.
	ppiNewInstance value: if detach.

	^hr!

OnShutdown
	"Private - The plugin has been requested to be closed down by
	the internet browser. Assume that we are running exclusively within
	the browser so we can just quit the VM."

	SessionManager current isEmbedded 
		ifFalse: 
			[| mb |
			mb := MessageBox new.
			mb beTaskModal.
			(mb confirm: 'You are about to exit Dolphin Smalltalk
Do you wish to save the image?') 
				ifTrue: [SessionManager current saveImage]].
	self pullPlug.

	"To avoid locking up the browser thread we must perform the actual VM exit after this call has returned,
	so post a non-cancellable quit (exit codes < 1 do not cause dev. session manager to prompt)."
	SessionManager current exit: -1.
	^S_OK!

onStartup
	"Private - Perform any session startup actions. "
	| unkOuter |

	allAppletHolders := SharedSet new.
	namedAppletHolders := DeferredValueTable new.

	"Implementation Note: See if the plug-hole started us up by querying <INPPlugHole> off the
	outer unknown passed as a startup argument."

	plugHole := nil.
	versions := nil.
	(unkOuter := SessionManager current outer) notNull ifTrue: [
		plugHole := unkOuter queryInterface: INPPlugHole.
		plugHole notNull ifTrue: [ | if |
			if := self queryInterface: INPDolphin.
			plugHole put_Peer: if.
			if free]]!

pluginAPIVersion
	"Answer the version of the plugin API for which the plugin was built.
	N.B. This is not the version of the Dolphin plugin."

	^self versions first!

postURL: instance url: url target: target data: data isFile: isFile
	"Private - Post the data in the variable byte object, data, to the specified <readableString> 
	url on behalf of the <NPApplet> whose instance handle is, instance. If the <boolean> flag, 
	isFile, is true, then the data is treated as the path to a file which is posted and deleted. The
	target specifies the destination of the response from the server:
		- If null, the server response is sent back to the plug-in as a new stream.
		- If _current, _self, or _top, the response data is written to the plug-in window and the plug-in is unloaded. 
		- If _new or _blank, the response data is written to a new browser window. 
		- If the name of a frame, then the response data is written to that frame.
	"

	^plugHole 
		PostURL: instance 
		URL: url 
		Target: target 
		BufLen: data byteSize 
		Buf: data 
		File: isFile asParameter!

postURLNotify: instance url: url target: target data: data isFile: isFile notifyData: notifyData
	"Private - Post data to the specified url. See postURL:url:target:data:isFile: for further details.
	This method differs in that notification of successful/unsuccessful posting of the data is sent
	back to the originating <NPApplet> via OnURLNotify:etc:
	Note that this is not supported by IE."

	^plugHole 
		PostURLNotify: instance 
		URL: url 
		Target: target 
		BufLen: data byteSize 
		Buf: data 
		File: isFile asParameter
		NotifyData: notifyData asDword
!

pullPlug
	"Private - Revoke the receiver's relationship with the Dolphin plugin host."

	plugHole free.
	plugHole := nil!

registerApplet: appletHolder withName: aStringName
	"Private - Register the applet held in the <DeferredValue>, appletHolder,
	with the receiver. A named applet will have aStringname that is non-nil "

	allAppletHolders add: appletHolder.
	aStringName notNil ifTrue: [
		(namedAppletHolders includesKey: aStringName ) ifTrue: [
			self error: 'An applet already has the name, ', aStringName ].
		namedAppletHolders at: aStringName put: appletHolder ].
!

status: instance message: msg
	"Private - Set the browser status line message for the applet instance, instance, to the 
	<String> message, msg."

	plugHole status: instance _: msg!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^#(##(INPDolphin))!

unregisterApplet: appletHolder withName: aStringName
	"Private - Unregister the applet held in the <DeferredValue>, appletHolder,
	with the receiver. A named applet will have aStringname that is non-nil "

	allAppletHolders remove: appletHolder ifAbsent: [].
	aStringName notNil ifTrue: [
		namedAppletHolders removeKey: aStringName ifAbsent: [] ]!

userAgent: instance
	"Private - Answer the UserAgent string of the browser hosting the specified applet instance."

	^plugHole userAgent: instance!

versions
	"Private - Answer a two element array, the first element of which is a decimal number 
	representing the version of the Netscape plugin API for which the Dolphin browser 
	plugin DLL was built, and the second of which is the version of the same API supported 
	by the host browser."

	versions isNil ifTrue: [ | pv bv |
		pv := SDWORD new.
		bv := SDWORD new.
		plugHole GetVersions: pv pBrowserVer: bv.
		versions := Array with: pv value with: bv value].
	^versions
! !
!NPDolphin categoriesFor: #aboutBitmap!accessing!private! !
!NPDolphin categoriesFor: #aboutPlugin!commands!public! !
!NPDolphin categoriesFor: #allApplets!accessing!public! !
!NPDolphin categoriesFor: #appletAt:ifAbsent:!accessing!public! !
!NPDolphin categoriesFor: #browserAPIVersion!operations!public! !
!NPDolphin categoriesFor: #defaultAppletClass!constants!public! !
!NPDolphin categoriesFor: #destroyStream:reason:!helpers!private! !
!NPDolphin categoriesFor: #getURL:url:target:!operations!private! !
!NPDolphin categoriesFor: #getURLNotify:url:target:notifyData:!operations!private! !
!NPDolphin categoriesFor: #initialize!initializing!private! !
!NPDolphin categoriesFor: #newStream:mimeType:target:!operations!private! !
!NPDolphin categoriesFor: #OnInitialize!events-session!private! !
!NPDolphin categoriesFor: #OnNewApplet:Instance:mode:argc:argn:argv:cSaved:pbSaved:ppiNewInstance:!events-session!private! !
!NPDolphin categoriesFor: #OnShutdown!events-session!private! !
!NPDolphin categoriesFor: #onStartup!events-session!private! !
!NPDolphin categoriesFor: #pluginAPIVersion!operations!public! !
!NPDolphin categoriesFor: #postURL:url:target:data:isFile:!operations!private! !
!NPDolphin categoriesFor: #postURLNotify:url:target:data:isFile:notifyData:!operations!private! !
!NPDolphin categoriesFor: #pullPlug!operations!private! !
!NPDolphin categoriesFor: #registerApplet:withName:!accessing!private! !
!NPDolphin categoriesFor: #status:message:!operations!private! !
!NPDolphin categoriesFor: #supportedInterfaces!constants!public! !
!NPDolphin categoriesFor: #unregisterApplet:withName:!accessing!private! !
!NPDolphin categoriesFor: #userAgent:!enquiries!private! !
!NPDolphin categoriesFor: #versions!accessing!private! !

NPDolphin methodProtocol: #'NPDolphin.INPDolphin' attributes: #() selectors: #(#OnInitialize #OnNewApplet:Instance:mode:argc:argn:argv:cSaved:pbSaved:ppiNewInstance: #OnShutdown)!

!NPDolphin class methodsFor!

current
	"Answer the singleton instance of the receiver."

	Current isNil ifTrue: [Current := super new initialize].
	^Current!

initialize
	"Private - Initialize the receiver's class variables."

	self current.!

new
	"Private - The receiver is a singleton class"

	^self shouldNotImplement!

reset
	"Private - Reset the current instance of the receiver.

	NPDolphin reset
"

	Current := nil!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self reset.! !
!NPDolphin class categoriesFor: #current!instance creation!public! !
!NPDolphin class categoriesFor: #initialize!initializing!private! !
!NPDolphin class categoriesFor: #new!object creation!private! !
!NPDolphin class categoriesFor: #reset!instance creation!private! !
!NPDolphin class categoriesFor: #uninitialize!class hierarchy-removing!private! !

