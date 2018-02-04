"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServer
	instanceVariableNames: 'session listeners state'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServer guid: (GUID fromString: '{3ab54ad2-8e20-408b-8120-3b9418540c51}')!
HttpServer comment: ''!
!HttpServer categoriesForClass!Unclassified! !
!HttpServer methodsFor!

addListener: listenerName at: urlPrefix handler: handler
	| listener |
	listener := self listeners add: (HttpServerListener
						name: listenerName
						url: urlPrefix
						handler: handler).
	self isRunning ifTrue: [listener startInSession: self session].
	^listener!

createServerSession
	session := HttpServerSession new!

free
	self stop.
	SessionManager current removeEventsTriggeredFor: self!

initialize
	state := #stopped.
	listeners := OrderedCollection new.
	self registerSessionManagerEvents.
	self beFinalizable!

isRunning
	^state == #running!

listeners
	^listeners!

onImageSaveCompleted
	self startIfPaused!

onImageSaveStarting
	self isRunning
		ifTrue: 
			[state := #paused.
			self stopListenersAndCloseSession]!

onSessionStarted
	self startIfPaused!

onSessionStopped
	self stop!

registerSessionManagerEvents
	SessionManager current
		when: #imageSaveStarting
			send: #onImageSaveStarting
			to: self;
		when: #imageSaveCompleted
			send: #onImageSaveCompleted
			to: self;
		when: #sessionStopped
			send: #onSessionStopped
			to: self;
		when: #sessionStarted
			send: #onSessionStarted
			to: self!

session
	session ifNil: [self createServerSession].
	^session!

start
	self isRunning ifTrue: [self stop; start].
	state := #running.
	self listeners do: [:each | each startInSession: self session]!

startIfPaused
	state == #paused ifTrue: [self start]!

stop
	state := #stopped.
	self stopListenersAndCloseSession!

stopListenersAndCloseSession
	self listeners do: [:each | each stop].
	session ifNotNil: [session close].
	session := nil! !
!HttpServer categoriesFor: #addListener:at:handler:!public! !
!HttpServer categoriesFor: #createServerSession!private! !
!HttpServer categoriesFor: #free!public! !
!HttpServer categoriesFor: #initialize!private! !
!HttpServer categoriesFor: #isRunning!public! !
!HttpServer categoriesFor: #listeners!public! !
!HttpServer categoriesFor: #onImageSaveCompleted!private! !
!HttpServer categoriesFor: #onImageSaveStarting!private! !
!HttpServer categoriesFor: #onSessionStarted!private! !
!HttpServer categoriesFor: #onSessionStopped!private! !
!HttpServer categoriesFor: #registerSessionManagerEvents!private! !
!HttpServer categoriesFor: #session!public! !
!HttpServer categoriesFor: #start!public! !
!HttpServer categoriesFor: #startIfPaused!private! !
!HttpServer categoriesFor: #stop!public! !
!HttpServer categoriesFor: #stopListenersAndCloseSession!private! !

