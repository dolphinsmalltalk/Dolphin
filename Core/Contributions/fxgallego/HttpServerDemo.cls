"Filed out from Dolphin Smalltalk 7"!

Object subclass: #HttpServerDemo
	instanceVariableNames: 'server'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'Current'!
HttpServerDemo guid: (GUID fromString: '{7297fd1e-c8e5-4c4d-bbd2-79c500f823b9}')!
HttpServerDemo comment: ''!
!HttpServerDemo categoriesForClass!Kernel-Objects! !
!HttpServerDemo methodsFor!

handle: aHttpServerRequest with: aHttpServerResponse
	^HttpServerDemoController handle: aHttpServerRequest with: aHttpServerResponse!

initialize
	server := HttpServer new.
	server
		addListener: 'DolphinHTTPServerDemo'
		at: 'http://localhost:8080/'
		handler: [:req :res | self handle: req with: res]!

start
	server start!

stop
	server stop! !
!HttpServerDemo categoriesFor: #handle:with:!private! !
!HttpServerDemo categoriesFor: #initialize!private! !
!HttpServerDemo categoriesFor: #start!public! !
!HttpServerDemo categoriesFor: #stop!public! !

!HttpServerDemo class methodsFor!

current
	Current ifNil: [Current := self new initialize].
	^Current!

start
	^self current start!

stop
	self current stop.
	Current := nil! !
!HttpServerDemo class categoriesFor: #current!public! !
!HttpServerDemo class categoriesFor: #start!public! !
!HttpServerDemo class categoriesFor: #stop!public! !

