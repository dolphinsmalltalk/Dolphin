"Filed out from Dolphin Smalltalk X6"!

COMInterfaceImp subclass: #NPApplet
	instanceVariableNames: 'instance attributes mimeType displayMode srcURL browserView site pendingURLHandlers urlNotifications srcStream appletClass classLocator appletHolder accessProtect'
	classVariableNames: 'DownloadFailedSignal MimeStartContexts TimeoutSignal UserAbortSignal'
	poolDictionaries: 'FacilityCodes PluginConstants Win32Constants'
	classInstanceVariableNames: ''!
NPApplet guid: (GUID fromString: '{2648C8A4-6B87-11D3-97BB-0080C8D59432}')!
NPApplet comment: 'An NPApplet instance is used by the web browser plug-in for each Dolphin applet EMBED tag found in a web page. It can be used to allow the applet to gain access to the browser itself or to the various functions it provides. Any view or presenter used by an applet can gain access to the NPApplet instance via its NPAppletSite, as follows:

npApplet := presenter site context.

Amongst other things, via the #status: method, this will give an applet access to the browser''s status bar.

Instance Variables:
	instance		<integer> which identifies the context for communication with the browser.
	attributes		<LookupTable> containing the attribute-value pairs from the HTML EMBED tag.
	mimeType		<readableString> MIME type identifying the contents of the source file.
	displayMode	<integer> either NP_FULL or NP_EMBED depending on how the applet was created.
	srcURL		<readableString> giving the source URL of the associated web page.
	browserView	<BrowserView> with the handle of the browser window which hosts the applet.
	site		<NPAppletSite> holding the view associated with the applet.
	pendingURLHandlers<LookupTable> of url''s to queues of applet stream handlers.
	urlNotifications	<PermanentRegistry> holding an number of dyadic valuables to be evaluated when an asynchronous URL operation completes.
	srcStream		<npStreamHandler> used to notify the completion of the applet''s URL download.
	appletClass	<Class> of the applet that has been loaded.
	classLocator	<ClassLocator> used to locate the applet''s imported class files.
	accessProtect	<Mutex> to synchronize access to pendingURLHandlers

Class Variables:
	MimeStartContexts		<LookupTable> for applet start classes vs MIME types.
	DownloadFailedSignal	<Signal> raised when download started but failed to complete
	TimeoutSignal 		<Signal> raised when download fails to start
	UserAbortSignal		<Signal> raised when user aborted download'!
!NPApplet categoriesForClass!Plugin-Support! !
!NPApplet methodsFor!

aboutPlugin
	"Displays a splash screen for the receiver"

	NPDolphin current aboutPlugin!

addURLHandler: streamHandler
	"Private - Register a streamHandler to use on the next new stream
	onto url. Multiple handlers can be queued to receiver downloads of a single
	URL. Answer streamHandler."

	accessProtect critical: [ | handlers |
		handlers := pendingURLHandlers at: streamHandler url ifAbsentPut: [OrderedCollection new: 1].
		handlers addLast: streamHandler].
	^streamHandler!

applet
	"Once started, answers the instance of the applet that is owned by the receiver. The 	appletHolder holds an instance of DeferredValue which starts the applet on a background 
	process. If the applet is not yet started then this method will block until it is fully loaded."

	^appletHolder value
!

appletClass
	"Answer the class for the receiver's applet"

	appletClass isNil ifTrue: [
		appletClass := 	(ClassStub withClassLocator: self classLocator) ].
	^appletClass!

appletClassName
	"Answer the name of the class of the applet"

	^self attributes at: 'APPLET' ifAbsent: [
		self error: 'APPLET attribute not specified for ', self srcURL] 
	

	!

appletPackageName
	"Answer the name of the package to load for the applet"

	^File splitStemFrom: self srcURL.
	

	!

attributes
	"Answer the <LookupTable> which contains the attributes specified with the 
	HTML EMBED tag of the receiver. Both keys and values are Strings."

	^attributes!

browserView: hWnd
	"Private - Set the parent view for the applet (supplied by the internet browser)."

	| appletName |
	browserView := BrowserView fromBrowserHandle: hWnd.
	site := NPAppletSite browserView: browserView.
	site context: self.

	(appletName := self name) notNil ifTrue: [
		browserView name: site as: appletName ].

	self onSetBrowserView
!

classLocator
	"Private - Answer an appropriate <ClassLocator> for use by the receiver"

	classLocator isNil 
		ifTrue: 
			[| codeBase classKey packageName |
			codeBase := File splitPathFrom: self srcURL.
			classKey := self appletClassName.
			packageName := self appletPackageName.
			classLocator := URLClassLocator 
						codeBase: codeBase
						packageName: packageName
						key: classKey.
			classLocator transport: self].
	^classLocator!

defaultAppletStreamClass
	"Private - Answer the default class to be used to represent streams of data from the browser."

	^NPInStream!

defaultGetURLTimeout
	"Answer an <integer> which is the default number of seconds to wait after a GetURL() request
	of the browser before deciding that no download is going to occur."

	^10!

defaultHandlerForURL: url
	"Private - Answer the default stream handler used to handle the
	events generated by the AppletStream onto the contents of url."

	(srcURL isNil) ifTrue: [
		self srcURL: url.
		^srcStream].
	^self!

destroyStream: piStream reason: npReason
	"Private - Request that the browser destroy the specified stream, which belongs to this instance."

	NPDolphin current destroyStream: piStream reason: npReason!

destroyViews
	"Private - Destroy all the children of the receiver browsers view."

	browserView notNil ifTrue: [
		browserView subViewsDo: [:c | c destroy].
		browserView := nil]!

errorWrongVersion: requiredVersion 
	"Private - Signals an error indicating that this version of the plugin is too old to
	load a particular applet. The requiredVersion is provided"

	self 
		error: ('This version of the Dolphin Web Applet plug-in is too old to load the applet package:

<1s>

Please upgrade the plug-in to version <2d> or later. 
Visit http://www.object-arts.com for more information.' 
				expandMacrosWith: self srcURL
				with: requiredVersion)!

evaluateAttributes
	"Private - Once the receivers site view and source url have been setup we start the applet."

	"The actual start of the applet takes place on a difference process. We use
	a DeferredValue to represent the eventual instance."

	(self hasSite and: [self srcURL notNil]) ifTrue: [	
		appletHolder := [ self startApplet ] deferredValue.
		NPDolphin current registerApplet: appletHolder withName: self name ].		
!

get_Instance: pNPP
	"Private - Answer the internet browser NPP applet instance handle via the output parameter, pNPP."

	pNPP value: instance.
	^S_OK!

getSrcURLSynchronous: url
	"Private - The source file at url is required to be downloaded onto
	the local machine. If the requested URL is the same as the original
	SRC of the applet then the file will already have been downloaded
	and we can simply return the existing local filename"

	| canonURL |
	canonURL := URLClassLocator canonicalizeURL: url.
	^canonURL = self srcURL
		ifTrue: [srcStream localFilename]
		ifFalse: [self getURLSynchronous: canonURL]!

getURL: url
	"Request the internet browser to open a new stream onto the contents of url. 
	Note that this is an asychronous call resulting in an OnNewStream:... being 
	received by the receiver some time in the future, and therefore there is no 
	useful return value, furthermore it is necessary to put the receiver into a state
	where it is able to relate the new stream to the requested URL as unfortunately	
	the plugin API provides no closure argument. May raise an NPError exception."

	self getURL: url target: nil!

getURL: url target: targetWindow
	"Request the internet browser to open a new asynchronous stream onto the named 
	targetWindow, which can be nil if the results are to be directed back to this applet.
	May raise an NPError exception."

	NPDolphin current getURL: instance url: url target: targetWindow!

getURL: url target: targetWindow notify: operation
	"Request the internet browser to open a new stream onto the named targetWindow.
	On completing the use of the stream an onURLNotify:... message will be sent
	to the receiver including notifyData to distinguish it.
	On completion of the get the dyadic valuable, operation, is evaluated with the url
	and the reason why it completed.
	May raise an NPError exception."

	| notifyData |
	notifyData := urlNotifications addAnsweringIndex: operation.
	self getURL: url target: targetWindow notifyData: notifyData.!

getURL: url target: targetWindow notifyData: notifyData
	"Request the internet browser to open a new stream onto the named targetWindow.
	On completing the use of the stream an onURLNotify:... message will be sent
	to the receiver including notifyData to distinguish it."

	NPDolphin current
		getURLNotify: instance
		url: url
		target: targetWindow
		notifyData: notifyData!

getURLSynchronous: url
	"Retrieve the resource with the canonicalized <readableString> uniform 
	resource locator, url, blocking until it is available,
	Answers a local file name after the url has been copied or
	nil if the download failed. Note that the url must be in canonicalized form so
	that it may be compared by equality.

	As suggested by the selector this downloads the url contents synchronously 
	rather than asynchronously in contrast to the other getURL:... methods. 
	This is simple to use, but may lock up the thread for an indefinite period."

	^self getURLSynchronous: url timeout: self defaultGetURLTimeout.!

getURLSynchronous: url timeout: secs
	"Retrieve the resource with the canonicalized <readableString> uniform 
	resource locator, url, blocking until it is available.  The <integer>, secs, specifies 
	the number of seconds to wait after the URL is initially requested of the browser
	before deciding that it isn't going to open, i.e. this is not a timeout for the whole
	download, just the period between request and the browser confirming the download
	stream has been oened. Such a timeout is necessary because if the URL does not
	exist, then it appears that the browser simply keeps quiet about it.
	Answers a local file name after the url has been copied or
	nil if the download failed. Note that the url must be in canonicalized form so
	that it may be compared by equality."

	| handler path |
	handler := NPSynchronousStreamHandler newUrl: url timeout: secs.
	self addURLHandler: handler.
	[	browserView notNil ifTrue: [browserView disable; class releaseCapture].
		self getURL: url.
		path := handler localFilename.
	] ensure: [
		browserView notNil ifTrue: [browserView enable].
		self removeURLHandler: handler].
	^path
!

handlerForURL: url
	"Private - Answer an applet stream handler used to handle the events
	sent to the stream used to get the contents of URL. We pop one off the
	queue if there are any, else answer the default handler."

	| handler |
	accessProtect critical: [ | handlers |
		handlers := pendingURLHandlers at: url ifAbsent: [^self defaultHandlerForURL: url].
		handler := handlers removeFirst.
		handlers isEmpty ifTrue: [pendingURLHandlers removeKey: url]].
	^handler!

hasSite
	"Answer whether a site has been connected to the receiver."

	^self site notNil!

hiddenAttributeName
	"Private - Answer the String hidden embed attribute name. If the attributes
	value is TRUE then the receivers context will not appear in the browser. On
	Netscape3.0 the receivers will not receive the onSetBrowserView: notification,
	where as Microsofts' Internet Explorer will still send it."

	^'HIDDEN'

!

hresultFromNPError: nperr
	"Private - Answer an HRESULT code corresponding to the NPError code, nperr, which the
	plug-hole can decode back into an NPError for returning to the internet browser."

	^nperr = NPERR_NO_ERROR
		ifTrue: [S_OK]
		ifFalse: [(HRESULT status: 1000+nperr facility: FACILITY_ITF) asInteger]


!

initialize
	"Private - Initialize the receiver's instance variables."

	accessProtect := Mutex new!

instance
	"Private - Answer the applet instance handle data of the receiver. This was supplied
	by the internet browser when the plugin instance was created and will stay
	valid until NPP_Destroy is received. Note that we treat this as an opaque
	value as it is an unmarshalled pointer which is only valid in the plug-hole
	(which lives on the browser thread)."

	^instance!

invalidateViews
	"Private - A NPP_SetWindow has been received from the internet browser after the
	receivers browserView has been successfully set up. This indicates that
	the browserView has been scrolled, resized, etc.

	Note that MS IExplorer 3.0 will not supply the scrolled case."

	(self hasSite and: [browserView extent ~= site extent]) ifTrue: [
		browserView
			invalidateLayout;
			validateLayout]
!

isBrowserIE
	"Answer whether the browser hosting the applet is Internet explorer."

	^self userAgent = 'Microsoft Internet Explorer'
!

isEmbedded
	"Answer whether the receiver was created in embedded mode. This
	is as a result of an EMBED tag on an html page, and the receiver's
	view will only occupy a part of the browsers area."

	^displayMode == NP_EMBED!

isFullPage
	"Answer whether the receiver was created in full page mode. Rather
	than being start from an EMBED tag on an html page, a file was
	directly opened."

	^displayMode == NP_FULL!

isHidden
	"Answer whether the should have a window to display itself in.
	A context is hidden if the HIDDEN attribute is TRUE."

	self attributes
		at: self hiddenAttributeName
		ifPresent: [:boolName | ^boolName asUppercase = 'TRUE'].
	^false!

isOkToDownload: url
	"Private - Answer whether the user agrees to download an applet.

	Presently we immediately answer with the positive, but in the future
	a code-signing test could be incorparated here, or if each indivual class
	is to be tested the #getClassURL: method."

	^true!

mimeType
	"Answer the mimeType of the file on which the receivers source
	stream was opened on."

	^mimeType!

name
	"Answer the name of the applet or nil if none was specified"

	^self attributes at: 'NAME' ifAbsent: []
	

	!

newStream: type target: target
	"Answer a new NPStream onto the internet browser's target.

	Introduced with Netscape 3.0"

	| stm piStream |
	stm := NPOutStream new.
	piStream := NPDolphin current 
				newStream: instance 
				mimeType: type 
				target: target.
	stm setApplet: self npStream: piStream handler: self.
	^stm					!

onDestroy
	"The receiver is being destroyed by the browser. Clean up and answer 
	a byte array to be saved against this mimetype/url or nil if no data need
	be persisted."

	NPDolphin current unregisterApplet: appletHolder withName: self name.
	appletHolder notNil ifTrue: [
		site := nil.
		self destroyViews.
		self trigger: #appletDestroy ].
	^nil

!

OnDestroy: pSaved pcSaved: pcSaved
	"Private - Notification from the browser (via the plug-hole) that the receiver is to be destroyed."

	| data |
	data := self onDestroy.
	data isNil 
		ifTrue: [
			pSaved value: 0.
			pcSaved value: 0]
		ifFalse: [ | saved |
			saved := COMTaskMemory new: data size.
			saved replaceFrom: 1 to: data size with: data startingAt: 1.
			pSaved value: saved detach.
			pcSaved value: data size].

	^S_OK!

onEmbedPrint: npEmberPrint
	"Private - Notification that the receiver should print itself."

	^self.
!

OnEvent: event wParam: wParam lParam: lParam pRet: pRet
	"Private - Handle a Win32 event redirected here by the internet browser hosting this applet."

	pRet value: 0.
	^self hresultFromNPError: NPERR_NO_ERROR!

onFullPrint: npFullPrint
	"Private - Notification that the receiver should print itself."

	^self.

!

onNew: savedDataOrNil
	"TPrivate - he receiver has just been created by the internet browser. savedData
	is a <COMTaskMemory> pointer (or nil) holding any data blocks associated 
	with this mimetype/url by the last instance of the applet."

	^self hresultFromNPError: NPERR_NO_ERROR
!

OnNewStream: piStream szURL: url pSType: pSType ppiHandler: ppiStreamEvents
	"Private - Notification from the internet browser hosting this applet that a new stream has been 
	created. The new stream is wrapped by the <INPStream> argument, piStream.  Locate the 
	handler for this stream, and send it an #onStreamOpened:onURL: notification.
	Answer the desired streaming mode via the output argument, pSType."

	| stm handler nperr canon |
	canon := URLClassLocator canonicalizeURL: url.
	handler := self handlerForURL: canon.
	stm := self defaultAppletStreamClass
				stream: piStream
				context: self
				handler: handler.
	"Inform the handler that a new stream is being created for it"
	nperr := handler onStreamOpened: stm onURL: url.
	"Return the desired stream mode back to the browser"
	pSType value: stm mode.
	ppiStreamEvents value: (stm queryInterface: INPStreamEvents) detach.
	^self hresultFromNPError: nperr
!

OnPrint: npPrint
	"Private - Notification from the internet browser that the instance should be
	printed."

"	| context modeLookup |
	modeLookup := ##(IdentityDictionary new
		at: NP_FULL put: NPFullPrint;
		at: NP_EMBED put: NPEmbedPrint;
		yourself).
	((modeLookup at: npPrint mode)
		fromAddress: npPrint asParameter yourAddress)
			contextPrint: context"
!

onSetBrowserView
	"The receivers browser view, which is donated by the browser has been set.
	This completes applet setup, so we should now be able to start the applet."

	self evaluateAttributes!

OnSetWindow: hWnd x: x y: y cx: width cy: height clipTop: clipTop clipLeft: clipLeft clipBottom: clipBottom clipRight: clipRight
	"Private - Notification from the internet browser hosting this applet of its host window details.
	This notification is used to both notify the applet of the attributes of its window, changes to 
	those attributes, and to refresh the browser view. Note that we ignore messages with a null
	handle as these seem to occur even when the view is not being destroyed."

	hWnd notNull ifTrue: ["set this as the receivers new window"
		(browserView isNil or: [browserView asParameter asInteger ~= hWnd])
			ifTrue: [self browserView: hWnd]
			ifFalse: [self invalidateViews]].
	^S_OK

!

onStreamAsFile: anAppletStream filename: filenameOrNil
	"A stream which had the NP_ASFILE or NP_ASFILEONLY mode set has
	either failed or been completly downloaded onto a local drive."

	^self!

onStreamClosed: stm reason: reason
	"Notification from an NPStream handled by the receiver (this
	is part of the <npStreamHandler> protocol) that it is being
	destroyed for the reason specified. The reason could be one of:

	NPRES_DONE				Normal stream completion
	NPRES_USER_BREAK		Action cancelled by user
	NPRES_NETWORK_ERR		Failed because of network problems.

	Answer the NPError value to be returned to the internet browser."

	^NPERR_NO_ERROR!

onStreamOpened: anNPInStream onURL: url
	"Notification that a new stream has been created and connected to
	the receiver. At this stage it is possible to set the mode of the
	stream.
	Answer the NPError value to be returned to internet browser."

	self status: url.
	self srcURL isNil ifTrue: [self srcURL: url].
	^NPERR_NO_ERROR!

OnURLNotify: url npReason: reason dwNotifyData: notifyData
	"Private - Notification from the internet browser hosting this applet that download of the 
	stream identified by notifyData has been completed or otherwise terminated. The reason 
	argument encodes whether it was successful, or why it failed."

	| operation |
	operation := urlNotifications at: notifyData ifAbsent: [^self].
	urlNotifications removeAtIndex: notifyData.
	operation value: url value: reason.
!

onWriteStream: anAppletStream offset: offset length: length buffer: buffer
	"Accept the next block of data from anAppletStream. Answer the
	number of bytes consumed, or a negative value to indicate an
	error occurred."

	^length!

onWriteStreamReady: anAppletStream
	"Answer the maximum number of bytes the receiver will
	accept from anAppletStream in the next onWrite:... notification."

	^SmallInteger maximum!

postURL: url string: string
	"Posts string to url. This call is typically asynchronous so it
	will answer immediately whether it was successful, but the post may
	only be sent at a later time."

	^self postURL: url target: nil string: string!

postURL: url target: targetWindow fileURL: fileURL
	"Posts fileURL to url. This call is typically asynchronous so it
	will answer immediately whether it was successful, but the post may
	only be sent at a later time. The targetWindow receives the servers
	response to the action."

	^NPDolphin current
		postURL: instance
		url: url
		target: targetWindow
		data: fileURL
		isFile: true!

postURL: url target: targetWindow string: string
	"Posts string to url. This call is typically asynchronous so it
	will answer immediately whether it was successful, but the post may
	only be sent at a later time. The targetWindow receives the servers
	response to the action.

	Introduced with Netscape 2.0 but completed in Netscape 3.0"

	^NPDolphin current
		postURL: instance
		url: url
		target: targetWindow
		data: string
		isFile: false!

postURL: url target: targetWindow string: string notify: operation
	"Posts string to url. This call is typically asynchronous so it
	will answer immediately whether it was successful, but the post may
	only be sent at a later time. The targetWindow receives the servers
	response to the action (see plugin SDK help for more details of the interpretation
	of the target parameter). 	On completion of the get the diadic valuable, operation, 
	is evaluated with the url and the reason why it completed.
	Note that this is not supported by IE."

	| notifyData |
	notifyData := urlNotifications addAnsweringIndex: operation.
	^self postURL: url target: targetWindow string: string notifyData: notifyData!

postURL: url target: targetWindow string: string notifyData: notifyData 
	"Private - Posts string to url. This call is typically asynchronous so it
	will answer immediately whether it was successful, but the post may
	only be sent at a later time. The targetWindow receives the servers
	response to the action."

	^NPDolphin current
		postURLNotify: instance
		url: url
		target: targetWindow
		data: string
		isFile: false
		notifyData: notifyData!

removeURLHandler: streamHandler
	"Private - Removes streamHandler from any of the pending URLs.
	Answer streamHandler."

	| url |
	url := streamHandler url.
	accessProtect critical: [
		pendingURLHandlers at: url ifPresent: [:handlers |
			handlers remove: streamHandler ifAbsent: [].
			handlers isEmpty ifTrue: [pendingURLHandlers removeKey: url]]].
	^streamHandler!

script
	"Answer the text of the SCRIPT attribute (if any)"

	^self attributes at: 'SCRIPT' ifAbsent: []
	

	!

setMimeType: mimeString instance: instanceNPP displayMode: modeEnum attributes: attributesDictionary
	"Private - Set the instance variables of the receiver."

	mimeType := mimeString.
	instance := instanceNPP.
	displayMode := modeEnum.
	attributes := attributesDictionary.
	pendingURLHandlers := LookupTable new.
	urlNotifications := PermanentRegistry new.
	srcStream := NPSynchronousStreamHandler new.



!

site
	"Answer the AppletSite view which spatially coincides with the
	receivers window as supplied by the internet browser via NPP_SetWindow."

	^site!

src
	"Answer the value of the SRC attribute of the EMBED tag which started the receiver."

	^attributes at: self srcAttributeName ifAbsent: ['']
!

srcAttributeName
	"Private - Answer the source attribute name. On starting the
	internet browser will automatically open a stream onto the
	source attributes value."

	^'SRC'!

srcURL
	"Answer the URL from which the receivers source file was
	opened to. In embedded mode this is supplied as an argument, in full
	page mode it is gained from the first opened stream."

	^srcURL!

srcURL: urlString
	"Private - Record the URL of the applets main source data/code."

	srcURL := URLClassLocator canonicalizeURL: urlString.
	self evaluateAttributes.
!

startApplet
	"Private - Start executing an applet. We rely on a #showInPlugin: or #show:inPlugin: class method
	being understood by the applet's class. This should initialize itself and add a
	subview to the receiver's site. At this stage the package defined by the source url
	has not been downloaded and installed into Dolphin. This action occurrs on demand
	for it, and all the further packages that it references which aren't already installed. Note that
	this installation is only for this execution of Dolphin."

	| presenter view |
	self assert: [browserView notNil].
	[presenter := self appletClass show: self viewName inPlugin: self] on: BinaryPackageVersionError
		do: [:x | self errorWrongVersion: x messageText].

	"The applet presenter is up and running"
	view := presenter view.
	view extent isZero 
		ifTrue: 
			["On IE after a refresh, the size is often set to 0@0"
			browserView layout].

	"We need to query all commands for initial enablement status"
	view invalidateUserInterface.

	"Under Win95/98 wee need to wake up the input queue to ensure
	that the applet draws successfully"
	SessionManager inputState inputSemaphore signal.

	"Let the user know we've started"
	self status: 'Applet ' , presenter class name , ' started'.
	^presenter!

status: statusString
	"Display a status message for the receiver in the internet browser. This is
	typically shown in the status bar of the browser and is meant for imitating
	the actions on moving the mouse over a hyperlink."

	NPDolphin current status: instance message: statusString!

supportedInterfaces
	"Private - Answer the set of interface classes supported by the receiver."

	^#(##(INPApplet))!

userAgent
	"Answer a string containing the internet browser's 'user agent' field. This
	identifies the browser during http transfers."

	^NPDolphin current userAgent: instance!

viewName
	"Private - Answer the view resource name to be used for the receiver.
	If a VIEW tag is included in the attributes then use this, otherwise choose a default view"

	^self attributes at: 'VIEW' ifAbsent: ['Default view']! !
!NPApplet categoriesFor: #aboutPlugin!commands!public! !
!NPApplet categoriesFor: #addURLHandler:!adding!private! !
!NPApplet categoriesFor: #applet!accessing!public! !
!NPApplet categoriesFor: #appletClass!accessing!public! !
!NPApplet categoriesFor: #appletClassName!accessing!public! !
!NPApplet categoriesFor: #appletPackageName!accessing!public! !
!NPApplet categoriesFor: #attributes!accessing!public! !
!NPApplet categoriesFor: #browserView:!accessing!private! !
!NPApplet categoriesFor: #classLocator!accessing!private! !
!NPApplet categoriesFor: #defaultAppletStreamClass!constants!private! !
!NPApplet categoriesFor: #defaultGetURLTimeout!constants!public! !
!NPApplet categoriesFor: #defaultHandlerForURL:!constants!private! !
!NPApplet categoriesFor: #destroyStream:reason:!helpers!private! !
!NPApplet categoriesFor: #destroyViews!operations!private! !
!NPApplet categoriesFor: #errorWrongVersion:!exceptions!private! !
!NPApplet categoriesFor: #evaluateAttributes!operations!private! !
!NPApplet categoriesFor: #get_Instance:!accessing!private! !
!NPApplet categoriesFor: #getSrcURLSynchronous:!accessing!private!transport! !
!NPApplet categoriesFor: #getURL:!operations!public! !
!NPApplet categoriesFor: #getURL:target:!operations!public! !
!NPApplet categoriesFor: #getURL:target:notify:!operations!public! !
!NPApplet categoriesFor: #getURL:target:notifyData:!operations!public! !
!NPApplet categoriesFor: #getURLSynchronous:!operations!public!transport! !
!NPApplet categoriesFor: #getURLSynchronous:timeout:!operations!public!transport! !
!NPApplet categoriesFor: #handlerForURL:!accessing!private! !
!NPApplet categoriesFor: #hasSite!public!testing! !
!NPApplet categoriesFor: #hiddenAttributeName!constants!private! !
!NPApplet categoriesFor: #hresultFromNPError:!helpers!private! !
!NPApplet categoriesFor: #initialize!initializing!private! !
!NPApplet categoriesFor: #instance!accessing!private! !
!NPApplet categoriesFor: #invalidateViews!operations!private! !
!NPApplet categoriesFor: #isBrowserIE!public!testing! !
!NPApplet categoriesFor: #isEmbedded!public!testing! !
!NPApplet categoriesFor: #isFullPage!public!testing! !
!NPApplet categoriesFor: #isHidden!public!testing! !
!NPApplet categoriesFor: #isOkToDownload:!private!testing! !
!NPApplet categoriesFor: #mimeType!accessing!public! !
!NPApplet categoriesFor: #name!accessing!public! !
!NPApplet categoriesFor: #newStream:target:!operations!public! !
!NPApplet categoriesFor: #onDestroy!events-plugin!public! !
!NPApplet categoriesFor: #OnDestroy:pcSaved:!COM Interfaces-INPApplet!events-plugin!private! !
!NPApplet categoriesFor: #onEmbedPrint:!events-plugin!private! !
!NPApplet categoriesFor: #OnEvent:wParam:lParam:pRet:!COM Interfaces-INPApplet!events-plugin!private! !
!NPApplet categoriesFor: #onFullPrint:!events-plugin!private! !
!NPApplet categoriesFor: #onNew:!events-plugin!private! !
!NPApplet categoriesFor: #OnNewStream:szURL:pSType:ppiHandler:!COM Interfaces-INPApplet!events-plugin!private! !
!NPApplet categoriesFor: #OnPrint:!COM Interfaces-INPApplet!events-plugin!private! !
!NPApplet categoriesFor: #onSetBrowserView!events-plugin!public! !
!NPApplet categoriesFor: #OnSetWindow:x:y:cx:cy:clipTop:clipLeft:clipBottom:clipRight:!COM Interfaces-INPApplet!events-plugin!private! !
!NPApplet categoriesFor: #onStreamAsFile:filename:!event handling!events-plugin!public! !
!NPApplet categoriesFor: #onStreamClosed:reason:!events-plugin!public! !
!NPApplet categoriesFor: #onStreamOpened:onURL:!events-plugin!public! !
!NPApplet categoriesFor: #OnURLNotify:npReason:dwNotifyData:!events-plugin!private! !
!NPApplet categoriesFor: #onWriteStream:offset:length:buffer:!events-plugin!public! !
!NPApplet categoriesFor: #onWriteStreamReady:!events-plugin!public! !
!NPApplet categoriesFor: #postURL:string:!operations!public! !
!NPApplet categoriesFor: #postURL:target:fileURL:!operations!public! !
!NPApplet categoriesFor: #postURL:target:string:!operations!public! !
!NPApplet categoriesFor: #postURL:target:string:notify:!operations!public! !
!NPApplet categoriesFor: #postURL:target:string:notifyData:!operations!private! !
!NPApplet categoriesFor: #removeURLHandler:!private!removing! !
!NPApplet categoriesFor: #script!accessing!public! !
!NPApplet categoriesFor: #setMimeType:instance:displayMode:attributes:!initializing!private! !
!NPApplet categoriesFor: #site!accessing!public! !
!NPApplet categoriesFor: #src!accessing!public! !
!NPApplet categoriesFor: #srcAttributeName!constants!private! !
!NPApplet categoriesFor: #srcURL!accessing!public! !
!NPApplet categoriesFor: #srcURL:!accessing!private! !
!NPApplet categoriesFor: #startApplet!operations!private! !
!NPApplet categoriesFor: #status:!operations!public! !
!NPApplet categoriesFor: #supportedInterfaces!constants!private! !
!NPApplet categoriesFor: #userAgent!operations!public! !
!NPApplet categoriesFor: #viewName!accessing!private! !

NPApplet methodProtocol: #'NPDolphin.INPApplet' attributes: #() selectors: #(#get_Instance: #OnDestroy:pcSaved: #OnEvent:wParam:lParam:pRet: #OnNewStream:szURL:pSType:ppiHandler: #OnSetWindow:x:y:cx:cy:clipTop:clipLeft:clipBottom:clipRight: #OnURLNotify:npReason:dwNotifyData:)!
NPApplet methodProtocol: #npStreamHandler attributes: #() selectors: #(#onStreamAsFile:filename: #onStreamClosed:reason: #onStreamOpened:onURL: #onWriteStream:offset:length:buffer: #onWriteStreamReady:)!

!NPApplet class methodsFor!

downloadAbortedSignal
	"Answer the <Signal> that is raised when a download initiates but is aborted by the user."

	^DownloadFailedSignal

!

downloadFailedSignal	
	"Answer the <Signal> that is raised when a download initiates but fails to complete."

	^DownloadFailedSignal

!

downloadTimeoutSignal	
	"Answer the <Signal> that is raised when a download fails to initiate before the timeout
	has elapsed."

	^TimeoutSignal
!

errorDownloadFailed: url reason: npresult
	"Private - Signal that a download or the resource with <readableString> URL, url, failed
	 for the specified <integer> reason, npresult, from the NPRES enumeration (augmented
	 to include a timeout value)."

	| sig |
	sig := npresult < NPRES_BASE
			ifTrue: [self downloadTimeoutSignal]
			ifFalse: [
				npresult == NPRES_USER_BREAK
					ifTrue: [self downloadAbortedSignal]
					ifFalse: [self downloadFailedSignal]]. 
	^sig signal: url
!

initialize
	"Private - Initialize the receivers class variables.
		self initialize
	"

	MimeStartContexts := LookupTable new.
	MimeStartContexts
		at: self mimeDolphinApplet put: NPApplet.
	
	TimeoutSignal := Signal description: 'Timed out initiating download of  ''%1'''.
	DownloadFailedSignal := Signal description: 'Failed to complete download of: ''%1'''.
	UserAbortSignal := Signal description: 'Aborted download of ''%1'''.!

mimeDolphinApplet
	"Answer the MIME String for a dolphin binary applet."

	^'application/x-dolphin-applet'!

mimeStartContexts
	"Private - Answer a Dictionary of mimeTypes against the context
	class of any instances used to process that type."

	^MimeStartContexts!

mimeType: mimeType instance: instanceNPP displayMode: mode attributes: attributes 
	"Answer a new instance for handling mimeType. If there is no registered
	class handling mimeType then answer a new instance of the receiver."

	| contextClass |
	contextClass := self mimeStartContexts at: mimeType ifAbsent: [self].
	^contextClass new 
		setMimeType: mimeType
		instance: instanceNPP
		displayMode: mode
		attributes: attributes!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !
!NPApplet class categoriesFor: #downloadAbortedSignal!constants!public! !
!NPApplet class categoriesFor: #downloadFailedSignal!constants!public! !
!NPApplet class categoriesFor: #downloadTimeoutSignal!constants!public! !
!NPApplet class categoriesFor: #errorDownloadFailed:reason:!exceptions!private! !
!NPApplet class categoriesFor: #initialize!initializing!private! !
!NPApplet class categoriesFor: #mimeDolphinApplet!constants!public! !
!NPApplet class categoriesFor: #mimeStartContexts!accessing!private! !
!NPApplet class categoriesFor: #mimeType:instance:displayMode:attributes:!instance creation!public! !
!NPApplet class categoriesFor: #new!instance creation!public! !

