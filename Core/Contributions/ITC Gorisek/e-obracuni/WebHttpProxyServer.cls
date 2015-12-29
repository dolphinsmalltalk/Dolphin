"Filed out from Dolphin Smalltalk X6.2"!

WebHttpServer subclass: #WebHttpProxyServer
	instanceVariableNames: 'proxyLog proxyLogMutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpProxyServer guid: (GUID fromString: '{85280999-6AD0-4C51-88A2-39546E5F3AF3}')!
WebHttpProxyServer comment: ''!
!WebHttpProxyServer categoriesForClass!Unclassified! !
!WebHttpProxyServer methodsFor!

basicStartup
	proxyLog := OrderedCollection new.
	proxyLogMutex := Semaphore forMutualExclusion.
	connectionsCount := 0.
	threadsCount := 0.
	redirections := true.
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
								[ItcSystemManager logLine: 'HTTP proxy server shutdown'.
								listeningSocket close]]
				named: 'Proxy Server Daemon'.
	watchdog := ItcSystemManager newProcessOn: self watchdogLoopBlock named: 'Proxy Server Watchdog'.
	daemon
		priority: ItcSystemManager serverDaemonPriority;
		resume.
	watchdog
		priority: ItcSystemManager serverWatchdogPriority;
		resume.
	ItcSystemManager logLine: 'HTTP proxy server started on port ' , serverPort printString!

proxyLog
	^proxyLog!

proxyLogFiltered
	^proxyLog reject: [:each | (each at: 3) beginsWith: 'HTTP/1.1 304 Not Modified']!

redirectionResponseFor: request on: stream 
	| hostname port path rs result logStream logRecord |
	logRecord := Array new: 4.
	rs := ReadStream on: request header url.
	rs itcUpToAll: 'http://'.
	hostname := rs upTo: $/.
	path := '/' , rs upToEnd.
	(hostname includes: $:) 
		ifTrue: 
			[port := ((ReadStream on: hostname)
						upTo: $:;
						upToEnd) itcAsInteger.
			hostname := (ReadStream on: hostname) upTo: $:]
		ifFalse: [port := 80].
	request header setPath: path.
	logStream := WriteStream on: (String new: 1024).
	request header printHeaderOn: logStream.
	logRecord
		at: 1 put: logStream contents;
		at: 2 put: request contents.
	result := self 
				getResponseFor: request
				fromIp: hostname
				port: port
				on: stream.
	logStream := WriteStream on: (String new: 1024).
	result printHeaderOn: logStream.
	logRecord
		at: 3 put: logStream contents;
		at: 4 put: result contents.
	proxyLogMutex critical: [proxyLog add: logRecord].
	^result! !
!WebHttpProxyServer categoriesFor: #basicStartup!private! !
!WebHttpProxyServer categoriesFor: #proxyLog!public! !
!WebHttpProxyServer categoriesFor: #proxyLogFiltered!public! !
!WebHttpProxyServer categoriesFor: #redirectionResponseFor:on:!public! !

