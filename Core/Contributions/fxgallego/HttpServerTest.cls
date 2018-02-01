"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #HttpServerTest
	instanceVariableNames: 'server'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerTest guid: (GUID fromString: '{4e9330e5-2596-4f2f-a003-a0b5b12f8eb4}')!
HttpServerTest comment: ''!
!HttpServerTest categoriesForClass!SUnit! !
!HttpServerTest methodsFor!

addListener1
	^server
		addListener: 'test1'
		at: 'http://localhost:9999/test/'
		handler: [:req :res | res statusCode: 200; content: 'true']!

addListener2
	^server
		addListener: 'test2'
		at: 'http://localhost:9998/test/'
		handler: [:req :res | ]!

setUp
	server := HttpServer new!

tearDown
	server stop.
	server := nil!

testAddListener
	| test1 test2 |
	test1 := self addListener1.
	self deny: test1 isRunning.

	server start.
	self assert: test1 isRunning.

	test2 := self addListener2.
	self assert: test2 isRunning!

testFree
	| events |
	events := SessionManager current getEvents.
	self addListener1.
	server start.
	server free.
	self deny: server isRunning.
	self deny: ((events at: #imageSaveStarting ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onImageSaveStarting)).
	self deny: ((events at: #imageSaveCompleted ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onImageSaveCompleted)).
	self deny: ((events at: #sessionStopped ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onSessionStopped)).
	self deny: ((events at: #sessionStarted ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onSessionStarted)).!

testListenerStop
	| listener |
	listener := self addListener1.
	server start.
	
	self assert: listener isRunning.
	self assert: (listener instVarNamed: 'threadPool') isRunning.
	
	server stop.

	self deny: listener isRunning.
	self assert: (listener instVarNamed: 'threadPool') isNil.
	self assert: (listener instVarNamed: 'loop') isNil.
	self assert: (listener instVarNamed: 'urlGroup') isNil.
	self assert: (listener instVarNamed: 'queue') isNil

	!

testNewServerIsNotRunning
	self deny: server isRunning!

testSessionManagerEventsRegistration
	| events |
	events := SessionManager current getEvents.
	self assert: ((events at: #imageSaveStarting ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onImageSaveStarting)).
	self assert: ((events at: #imageSaveCompleted ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onImageSaveCompleted)).
	self assert: ((events at: #sessionStopped ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onSessionStopped)).
	self assert: ((events at: #sessionStarted ifAbsent: [#()]) includes: (EventMessageSend receiver: server selector: #onSessionStarted)).!

testStart
	server start.
	self assert: server isRunning.
	self assert: server session notNil.
	self assert: server listeners isEmpty!

testStop
	self addListener1.
	server start.
	self assert: server isRunning.
	self assert: (server listeners anySatisfy: [:each | each isRunning]).
	
	server stop.
	self deny: server isRunning.
	self deny: (server listeners anySatisfy: [:each | each isRunning]).
	self assert: (server instVarNamed: 'session') isNil! !
!HttpServerTest categoriesFor: #addListener1!private! !
!HttpServerTest categoriesFor: #addListener2!private! !
!HttpServerTest categoriesFor: #setUp!private! !
!HttpServerTest categoriesFor: #tearDown!private! !
!HttpServerTest categoriesFor: #testAddListener!public! !
!HttpServerTest categoriesFor: #testFree!public! !
!HttpServerTest categoriesFor: #testListenerStop!public! !
!HttpServerTest categoriesFor: #testNewServerIsNotRunning!public! !
!HttpServerTest categoriesFor: #testSessionManagerEventsRegistration!public! !
!HttpServerTest categoriesFor: #testStart!public! !
!HttpServerTest categoriesFor: #testStop!public! !

