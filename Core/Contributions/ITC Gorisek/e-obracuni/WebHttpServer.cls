"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #WebHttpServer
	instanceVariableNames: 'serverPort listeningSocket daemon watchdog servletManager threadsCount connectionsCount redirections serverStartedTS threadsCountMutex requestCounterMutex serverStats serverStatsPosition'
	classVariableNames: 'Current'
	poolDictionaries: 'DialectAbstractionLayerNS'
	classInstanceVariableNames: 'defaultPort ipToHostnameDict ipToHostnameMutex'!
WebHttpServer guid: (GUID fromString: '{32F50AFB-ACA3-432D-9835-46CE5CF5248C}')!
WebHttpServer comment: ''!
!WebHttpServer categoriesForClass!Unclassified! !
!WebHttpServer methodsFor!

addRedirection: hostname urlPrefix: urlPrefix toServer: remoteIp port: remotePort 
	| prefixes |
	redirections isNil ifTrue: [redirections := LookupTable new].
	prefixes := (redirections at: hostname ifAbsent: [Array new]) 
				asSortedCollection: [:a :b | a first size > b first size].
	prefixes add: (Array 
				with: urlPrefix
				with: remoteIp
				with: remotePort).
	redirections at: hostname put: prefixes asArray!

basicStartup
	serverStartedTS := Timestamp now.
	connectionsCount := 0.
	threadsCount := 0.
	serverStats := (Array new: 8640)
				atAllPut: 0;
				yourself.	"24 * 60 * 6"
	serverStatsPosition := 1.
	requestCounterMutex := Semaphore forMutualExclusion.
	redirections := nil.
	threadsCountMutex := Semaphore forMutualExclusion.
	servletManager := WebHttpServletManager new.
	listeningSocket := self getListeningSocket.
	daemon := ItcSystemManager newProcessOn: 
					[
					[[true] whileTrue: 
							[
							[| result |
							result := listeningSocket accept.
							self forkNewThreadOn: result] 
									on: Error
									do: [:ex | ex exitWith: nil]]] 
							ensure: 
								[ItcSystemManager logLine: 'Web server shutdown'.
								listeningSocket socketShutdownAndClose]]
				named: 'Web Server Daemon'.
	watchdog := ItcSystemManager newProcessOn: self watchdogLoopBlock named: 'Web Server Watchdog'.
	daemon
		priority: ItcSystemManager serverDaemonPriority;
		resume.
	watchdog
		priority: ItcSystemManager serverWatchdogPriority;
		resume.
	ItcSystemManager logLine: 'Web server started on port ' , serverPort printString!

cleanAwayBlockedThreads
	"Clean up threads which are running too long. If a thread uses external resources like sockets and database connection
	it will first close external resources and then terminate the process in the seconds pass.
	Answer <true> if second pass is required. Else answer <false>."

	| timeNow result processListStream |
	result := false.
	timeNow := ItcSystemManager absoluteSecondsClockValue.
	"log total memory use in the last slot"
	serverStats at: timeNow // 60 \\ 1440 * 6 + 6 put: ItcSystemManager totalAllocatedMemory.

	"clean up all threads that exceeded their deadline"
	Processor allProcesses do: 
			[:each | 
			
			[| requestDeadline socket |
			(each itcIsTerminated not 
				and: [(requestDeadline := each webHttpRequestDeadline) notNil and: [requestDeadline < timeNow]]) 
					ifTrue: 
						[(socket := each webHttpSocketToClose) isNil 
							ifFalse: 
								["don't terminate the process yet, just close the socket so that the process will exit on exception, if that does not help, it will be terminated in the second pass"
								socket socketShutdown.
								each webHttpSocketToClose: nil.
								result := true]
							ifTrue: 
								[ItcSystemManager logLineWithTsAndPID: 'WebServer scavenger, terminating expired process #' 
											, each itcProcessId printString.
								processListStream isNil 
									ifTrue: 
										[processListStream := WriteStream on: String new.
										processListStream 
											nextPutAll: 'Active process dump before terminating run-away processes:
-------
'.
										Processor allProcesses do: 
												[:eachProcess | 
												processListStream
													nextPutAll: eachProcess itcProcessName asWebString;
													tab;
													nextPutAll: eachProcess itcProcessId asWebString;
													tab;
													nextPutAll: eachProcess itcProcessState asWebString;
													tab;
													nextPutAll: eachProcess priority asWebString;
													tab;
													nextPutAll: eachProcess itcProcessSize asWebString;
													tab;
													nextPutAll: (eachProcess webRequest isNil ifFalse: [eachProcess webRequest clientIP]) asWebString;
													tab;
													nextPutAll: (eachProcess webSession isNil ifFalse: [eachProcess webSession usernameInfo]) 
																asWebString;
													tab;
													nextPutAll: (((eachProcess isActive ifTrue: ['...'] ifFalse: [eachProcess itcSuspendedFrameString]) 
																add: (eachProcess webRequest isNil ifFalse: [eachProcess webRequest header url])
																withDelimiter: '
') 
																	add: (eachProcess webTask isNil ifFalse: ['Task: ' , eachProcess webTask class asWebString])
																	withDelimiter: '
') asWebString;
													cr].
										processListStream nextPutAll: '
---------

'].
								each itcSafeTerminate]]] 
					on: Error
					do: [:ex | ex exitWith: nil]].
	processListStream isNil ifFalse: [ItcSystemManager logLineWithTsAndPID: processListStream contents].
	^result!

forkNewThreadOn: socket 
	threadsCountMutex critical: [threadsCount := threadsCount + 1].
	threadsCount > 30 
		ifTrue: 
			[threadsCount > 50 
				ifFalse: [(Delay forMilliseconds: 100) wait]
				ifTrue: [(Delay forMilliseconds: 200) wait]].
	(ItcSystemManager newProcessOn: [self processRequestFrom: socket]
		named: 'HTTP request thread @' , ItcSystemManager absoluteMillisecondsClockValue printString)
		priority: ItcSystemManager requestHandlerPriority;
		webHttpSocketToClose: socket;
		resume.
	Processor yield!

getListeningSocket
	^ItcSystemManager newServerSocketOnPort: serverPort backlog: 10!

getRequestCounterArrayForLastNminutes: nOfMinutes 
	| currentPos result i |
	i := nOfMinutes.
	result := Array new: nOfMinutes.
	currentPos := ItcSystemManager absoluteMillisecondsClockValue // 60000 \\ 1440 * 6 + 1.
	nOfMinutes timesRepeat: 
			[result at: i put: (serverStats copyFrom: currentPos to: currentPos + 5).	"6 - 1"
			currentPos := currentPos - 6.
			currentPos < 0 ifTrue: [currentPos := serverStats size - 6 + 1].
			i := i - 1].
	^result!

getResponseFor: request fromIp: remoteIP port: remotePort on: clientStream 
	| responseStream socket |
	
	[socket := ItcSystemManager newTCPclientSocketToHost: remoteIP port: remotePort.
	
	[| stream |
	stream := socket writeStream.
	stream
		isBytes: false;
		nextPutAll: request redirectionMessageContents;
		itcFlush.
	stream := socket readStream.
	stream isBytes: false.
	responseStream := WebHttpReceivedResponse new initializeFrom: stream on: clientStream] 
			ensure: [socket close]] 
			on: Error
			do: 
				[:ex | 
				responseStream := (WebHttpStream new on: clientStream) serviceTemporarilyUnavailableResponse.
				ItcSystemManager isRuntime 
					ifFalse: [ex signal]
					ifTrue: 
						[(ItcSystemManager isIgnoredSocketError: ex socket: socket) 
							ifFalse: [[ItcSystemManager writeErrorLog: ex] on: Error do: [:sig | sig exitWith: nil]]].
				ex exitWith: nil].
	^responseStream!

incrementKeepAliveRequestCounter: requestStartTime 
	| newServerStatsPosition |
	newServerStatsPosition := requestStartTime // 60000 \\ 1440 * 6 + 1.
	requestCounterMutex critical: 
			[(newServerStatsPosition > serverStatsPosition or: 
					["roll-over occured?"
					serverStatsPosition - newServerStatsPosition > 360]) 
				ifTrue: 
					[
					[serverStatsPosition := serverStatsPosition + 6.
					serverStatsPosition > 8640 ifTrue: [serverStatsPosition := 1].	"24 * 60 * 6"
					serverStats
						at: serverStatsPosition put: 0;
						at: serverStatsPosition + 1 put: 0;
						at: serverStatsPosition + 2 put: 0;
						at: serverStatsPosition + 3 put: 0;
						at: serverStatsPosition + 4 put: 0.
						"at: serverStatsPosition + 5 put: ItcSystemManager totalAllocatedMemory."
					serverStatsPosition = newServerStatsPosition] 
							whileFalse: []].
			serverStats at: newServerStatsPosition + 1 put: (serverStats at: newServerStatsPosition + 1) + 1]!

incrementRequestCounter: requestStartTime 
	| newServerStatsPosition |
	newServerStatsPosition := requestStartTime // 60000 \\ 1440 * 6 + 1.
	requestCounterMutex critical: 
			[(newServerStatsPosition > serverStatsPosition or: 
					["roll-over occured?"
					serverStatsPosition - newServerStatsPosition > 360]) 
				ifTrue: 
					[[serverStatsPosition = newServerStatsPosition] whileFalse: 
							[serverStatsPosition := serverStatsPosition + 6.
							serverStatsPosition > 8640 ifTrue: [serverStatsPosition := 1].	"24 * 60 * 6"
							serverStats
								at: serverStatsPosition put: 0;
								at: serverStatsPosition + 1 put: 0;
								at: serverStatsPosition + 2 put: 0;
								at: serverStatsPosition + 3 put: 0;
								at: serverStatsPosition + 4 put: 0
								"at: serverStatsPosition + 5 put: ItcSystemManager totalAllocatedMemory"]].
			serverStats
				at: newServerStatsPosition put: (serverStats at: newServerStatsPosition) + 1;
				at: newServerStatsPosition + 1 put: (serverStats at: newServerStatsPosition + 1) + 1]!

logRequestDuration: requestStartTime 
	"Log minimum, maximum and total (average) for HTTP requests during the given 1 minute time slot."

	| pos min duration |
	duration := ItcSystemManager absoluteMillisecondsClockValue - requestStartTime.
	duration > 0 ifFalse: [^self].
	pos := requestStartTime // 60000 \\ 1440 * 6 + 1.
	requestCounterMutex critical: 
			[min := serverStats at: pos + 2.
			serverStats
				at: pos + 2 put: (min = 0 ifTrue: [duration] ifFalse: [min min: duration]);
				at: pos + 3 put: ((serverStats at: pos + 3) max: duration);
				at: pos + 4 put: (serverStats at: pos + 4) + duration]!

processRequestFrom: socket 
	| stream httpStream request keepAlive timeNow |
	
	[
	[
	[stream := socket readStream.
	stream isBytes: false.
	"allow max 30 seconds to read request header"
	timeNow := ItcSystemManager absoluteMillisecondsClockValue.
	self incrementRequestCounter: timeNow.
	Processor activeProcess webHttpRequestDeadline: timeNow // 1000 + 30.
	request := WebHttpRequest new initializeFrom: stream.

	"allow max 180 seconds for processing request"
	Processor activeProcess webHttpRequestDeadline: ItcSystemManager absoluteSecondsClockValue + 180.
	(redirections isNil 
		or: [(httpStream := self redirectionResponseFor: request on: socket writeStream) isNil]) 
			ifTrue: 
				[httpStream := WebHttpStream new on: socket writeStream.
				servletManager service: request on: httpStream]

	"decrement thread count when the first request is processed"] 
			ensure: 
				[threadsCountMutex critical: [threadsCount := threadsCount - 1].
				self logRequestDuration: timeNow].
	
	[request header clientHandlesInternetExplorerCompression 
		ifTrue: [httpStream compressResponseForInternetExplorer]
		ifFalse: 
			[request header clientHandlesMozillaCompression 
				ifTrue: [httpStream compressResponseForMozilla]
				ifFalse: [request header clientHandlesOperaCompression ifTrue: [httpStream compressResponseForOpera6]]].
	"is keep-alive client and there are less than 20 opened connections?"
	((keepAlive := request header isKeepAlive) and: [connectionsCount < 50]) 
		ifTrue: [httpStream connectionKeepAlive].
	"set maximum response time at minimum transfer speed of 2048 bytes per second"
	Processor activeProcess 
		webHttpRequestDeadline: ItcSystemManager absoluteSecondsClockValue 
				+ (httpStream contentLength // 2048) + 30.
	request header command = 'HEAD' 
		ifTrue: [httpStream sendResponseHeader]
		ifFalse: [httpStream sendResponse].
	socket writeStream itcFlush.
	keepAlive] 
			whileTrue: 
				[
				[threadsCountMutex critical: [connectionsCount := connectionsCount + 1].
				"allow max 2 minutes for the client to send another request on an open connection"
				"reset request specific process based attributes"
				(Processor activeProcess)
					attributesReset;
					webHttpRequestDeadline: ItcSystemManager absoluteSecondsClockValue + 120.
				stream
					isBytes: false;
					peek.
				timeNow := ItcSystemManager absoluteMillisecondsClockValue.
				Processor activeProcess webHttpRequestDeadline: timeNow // 1000 + 30.
				self incrementKeepAliveRequestCounter: timeNow.
				request := WebHttpRequest new initializeFrom: stream] 
						ensure: [threadsCountMutex critical: [connectionsCount := connectionsCount - 1]].
				threadsCountMutex critical: [threadsCount := threadsCount + 1].
				
				["allow max 180 seconds for processing request"
				Processor activeProcess webHttpRequestDeadline: ItcSystemManager absoluteSecondsClockValue + 180.
				(redirections isNil 
					or: [(httpStream := self redirectionResponseFor: request on: socket writeStream) isNil]) 
						ifTrue: 
							[httpStream := WebHttpStream new on: socket writeStream.
							servletManager service: request on: httpStream]] 
						ensure: 
							[threadsCountMutex critical: [threadsCount := threadsCount - 1].
							self logRequestDuration: timeNow]].
	socket close] 
			on: Error
			do: 
				[:ex | 
				(ItcSystemManager isIgnoredSocketError: ex socket: socket) 
					ifTrue: [ex exitWith: self]
					ifFalse: 
						[socket isClosed 
							ifFalse: 
								[httpStream
									errorResponseWithDescription: ex description asWebString;
									sendResponse.
								
								[socket writeStream itcFlush.
								socket close] on: Error do: [:sig | sig exitWith: nil]].
						ItcSystemManager isRuntime 
							ifFalse: [ex signal]
							ifTrue: 
								[[ItcSystemManager writeErrorLog: ex] on: Error do: [:sig | sig exitWith: nil].
								ex exitWith: self]]]] 
			ensure: [socket isClosed ifFalse: [[socket close] on: Error do: [:ex | ex exitWith: nil]]]!

redirectionResponseFor: request on: stream 
	| hostname coll url |
	hostname := request header host.
	coll := hostname isNil 
				ifTrue: [redirections at: '...' ifAbsent: []]
				ifFalse: 
					["preveri za primer, ko tece na drugem portu, npr.: http://host:222/file.html"
					(hostname indexOf: $:) > 0 
						ifTrue: [hostname := hostname copyFrom: 1 to: (hostname indexOf: $:) - 1].
					redirections at: hostname asLowercase ifAbsent: [redirections at: '...' ifAbsent: []]].
	coll isNil ifTrue: [^nil].
	url := request header url.
	coll do: 
			[:each | 
			(url beginsWith: (each at: 1)) 
				ifTrue: 
					[^self 
						getResponseFor: request
						fromIp: (each at: 2)
						port: (each at: 3)
						on: stream]].
	^nil!

redirections
	^redirections!

serverPort
	^serverPort!

serverProtocol
	^'HTTP'!

serverStartedTS
	^serverStartedTS!

servletManager
	^servletManager!

servletManager: aWebHttpInvokerServlet 
	servletManager := aWebHttpInvokerServlet!

shutdown
	listeningSocket isNil ifFalse: [[listeningSocket socketShutdownAndClose] on: Error do: [:ex | ]].
	daemon notNil 
		ifTrue: 
			[daemon itcSafeTerminate.
			daemon := nil].
	watchdog notNil 
		ifTrue: 
			[watchdog itcSafeTerminate.
			watchdog := nil]!

startup
	serverPort := self class defaultPort.
	self basicStartup!

startupOnPort: anInteger 
	serverPort := anInteger.
	self basicStartup!

watchdogLoop
	| duration |
	duration := 15.
	[true] whileTrue: 
			[(Delay forSeconds: duration) wait.
			self cleanAwayBlockedThreads 
				ifTrue: 
					["allow 3 seconds for sockets and other external connections to close"
					duration := 3]
				ifFalse: [duration := 15]]!

watchdogLoopBlock
	^[self watchdogLoop]! !
!WebHttpServer categoriesFor: #addRedirection:urlPrefix:toServer:port:!public! !
!WebHttpServer categoriesFor: #basicStartup!private! !
!WebHttpServer categoriesFor: #cleanAwayBlockedThreads!public! !
!WebHttpServer categoriesFor: #forkNewThreadOn:!public! !
!WebHttpServer categoriesFor: #getListeningSocket!public! !
!WebHttpServer categoriesFor: #getRequestCounterArrayForLastNminutes:!public!server statistics! !
!WebHttpServer categoriesFor: #getResponseFor:fromIp:port:on:!public! !
!WebHttpServer categoriesFor: #incrementKeepAliveRequestCounter:!private!server statistics! !
!WebHttpServer categoriesFor: #incrementRequestCounter:!private!server statistics! !
!WebHttpServer categoriesFor: #logRequestDuration:!private!server statistics! !
!WebHttpServer categoriesFor: #processRequestFrom:!public! !
!WebHttpServer categoriesFor: #redirectionResponseFor:on:!public! !
!WebHttpServer categoriesFor: #redirections!public! !
!WebHttpServer categoriesFor: #serverPort!public! !
!WebHttpServer categoriesFor: #serverProtocol!public! !
!WebHttpServer categoriesFor: #serverStartedTS!public!server statistics! !
!WebHttpServer categoriesFor: #servletManager!public! !
!WebHttpServer categoriesFor: #servletManager:!public! !
!WebHttpServer categoriesFor: #shutdown!public! !
!WebHttpServer categoriesFor: #startup!public! !
!WebHttpServer categoriesFor: #startupOnPort:!public! !
!WebHttpServer categoriesFor: #watchdogLoop!private! !
!WebHttpServer categoriesFor: #watchdogLoopBlock!private! !

!WebHttpServer class methodsFor!

current
	"Answer an instance of a web server already running.
	If there is no web server running start one on port 80."

	Current isNil ifTrue: [self startup].
	^Current!

currentOrNil
	^Current!

defaultPort
	^defaultPort isNil ifTrue: [80] ifFalse: [defaultPort]!

getCachedHostnameFromIPorNil: ipString 
	"Resolve IP to hostname by using internal cache of already resolved IP addresses.
	Answer hostname of the IP address or nil if no entry exists in the cache.
	"

	| hostname |
	self ipToHostnameMutex critical: [hostname := ipToHostnameDict at: ipString ifAbsent: []].
	^hostname!

getHostnameFromIP: ipString 
	"Resolve IP to hostname. Answer hostname of the IP address.
	Get hostname from cache if already resolved before.
	If not, then get it from the name servers and cache for the next time when needed.
	"

	| hostname |
	hostname := self getCachedHostnameFromIPorNil: ipString.
	hostname isNil 
		ifTrue: 
			[hostname := (ItcSystemManager getHostnameFromIP: ipString) ifNil: ['N/A'].
			self ipToHostnameMutex critical: [ipToHostnameDict at: ipString put: hostname]].
	^hostname!

ipToHostnameMutex
	ipToHostnameMutex isNil 
		ifTrue: 
			[ipToHostnameDict := ItcLookupTable new.
			ipToHostnameMutex := Semaphore forMutualExclusion].
	^ipToHostnameMutex!

setDefaultServerPort: anInteger 
	defaultPort := anInteger!

shutdown
	Current isNil 
		ifFalse: 
			[Current shutdown.
			Current := nil]!

startup
	^self startupOnPort: self defaultPort!

startupOnPort: portNumber 
	^Current := self new startupOnPort: portNumber! !
!WebHttpServer class categoriesFor: #current!public! !
!WebHttpServer class categoriesFor: #currentOrNil!public! !
!WebHttpServer class categoriesFor: #defaultPort!public! !
!WebHttpServer class categoriesFor: #getCachedHostnameFromIPorNil:!IP to hostname resolution cache!public! !
!WebHttpServer class categoriesFor: #getHostnameFromIP:!IP to hostname resolution cache!public! !
!WebHttpServer class categoriesFor: #ipToHostnameMutex!IP to hostname resolution cache!private! !
!WebHttpServer class categoriesFor: #setDefaultServerPort:!public! !
!WebHttpServer class categoriesFor: #shutdown!public! !
!WebHttpServer class categoriesFor: #startup!public! !
!WebHttpServer class categoriesFor: #startupOnPort:!public! !

