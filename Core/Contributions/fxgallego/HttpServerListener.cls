"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerListener
	instanceVariableNames: 'name urlPrefix queue urlGroup handler loop multithreaded state threadPool'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerListener guid: (GUID fromString: '{4f77f481-7018-4676-b62c-a0aca1e1c3e2}')!
HttpServerListener comment: ''!
!HttpServerListener categoriesForClass!Unclassified! !
!HttpServerListener methodsFor!

handleRequest: request
	| block |
	block := 
			[
			[| response |
			response := HttpServerResponse for: request.
			[handler value: request value: response] on: HttpServerError
				do: 
					[:ex |
					response
						statusCode: ex statusCode;
						reason: ex reason;
						content: ex html].
			response send]
					ifCurtailed: [request cancel]].
	multithreaded ifTrue: [threadPool queueWorkItem: block] ifFalse: [block value]!

initializeName: listenerName url: url handler: httpApiHandler multithreaded: aBoolean
	name := listenerName.
	urlPrefix := url.
	handler := httpApiHandler.
	multithreaded := aBoolean!

isRunning
	^state = #running!

loop
	^
	[[
	[| request |
	request := self receiveRequest.
	self handleRequest: request] repeat]
		ifCurtailed: [self isRunning ifTrue: [self restartServerLoop]]]
			fork!

name
	^name!

receiveRequest
	^HttpServerRequest on: queue!

restartServerLoop
	loop := self loop.
	loop name: self name.
	multithreaded ifTrue: [threadPool stop; start].
	state := #running!

startInSession: httpApiSession
	queue := HttpServerQueue named: self name.
	urlGroup := HttpServerUrlGroup on: httpApiSession.
	threadPool := ThreadPool new.
	urlGroup addUrl: urlPrefix.
	urlGroup bindQueue: queue.
	self restartServerLoop!

stop
	state := #stopping.
	loop ifNotNil: [loop terminate].
	queue ifNotNil: [queue close].
	threadPool ifNotNil: [threadPool stop].
	queue := urlGroup := loop := threadPool := nil.
	state := #stopped
! !
!HttpServerListener categoriesFor: #handleRequest:!private! !
!HttpServerListener categoriesFor: #initializeName:url:handler:multithreaded:!private! !
!HttpServerListener categoriesFor: #isRunning!public! !
!HttpServerListener categoriesFor: #loop!private! !
!HttpServerListener categoriesFor: #name!public! !
!HttpServerListener categoriesFor: #receiveRequest!private! !
!HttpServerListener categoriesFor: #restartServerLoop!private! !
!HttpServerListener categoriesFor: #startInSession:!public! !
!HttpServerListener categoriesFor: #stop!public! !

!HttpServerListener class methodsFor!

name: listenerName url: urlPrefix handler: handler
	^self
		name: listenerName
		url: urlPrefix
		handler: handler
		multithreaded: true!

name: listenerName url: urlPrefix handler: handler multithreaded: aBoolean
	^self new
		initializeName: listenerName
		url: urlPrefix
		handler: handler
		multithreaded: aBoolean! !
!HttpServerListener class categoriesFor: #name:url:handler:!public! !
!HttpServerListener class categoriesFor: #name:url:handler:multithreaded:!public! !

