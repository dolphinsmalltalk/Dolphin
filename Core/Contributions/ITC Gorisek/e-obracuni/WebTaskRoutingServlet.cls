"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WebTaskRoutingServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebTaskRoutingServlet guid: (GUID fromString: '{1931C018-FAEA-4077-AE20-570A2C5E4AB3}')!
WebTaskRoutingServlet comment: ''!
!WebTaskRoutingServlet categoriesForClass!Unclassified! !
!WebTaskRoutingServlet methodsFor!

processGet: request on: stream 
	| taskId task session timeNow |
	self checkOrSetDefaultClientIdCookieFor: request on: stream.
	timeNow := ItcSystemManager absoluteSecondsClockValue.
	taskId := request header url.
	taskId size < (application urlPrefix size + 7) ifTrue: [^stream fileNotFoundResponse].
	task := taskId indexOf: $..
	taskId := taskId copyFrom: application urlPrefix size + 7
				to: (task == 0 ifTrue: [taskId size] ifFalse: [task - 1]).
	(task := application taskAt: taskId) isNil 
		ifTrue: 
			[^(session := application sessionAt: taskId) isNil 
				ifTrue: 
					[Processor activeProcess language: application defaultLanguage.
					application sendSessionExpiredResponseOn: stream]
				ifFalse: 
					[Processor activeProcess language: session language.
					session lastRequestTime: timeNow.
					application sendPageExpiredMessageFor: session on: stream]].
	session := task session.
	"	session requestSender address address = request sender address address
		ifFalse: [ ^application sendLoginPageWithMessage: 'Your session has been cancelled due to wrong network address. Please login again.' on: stream ]."
	session lastRequestTime: timeNow.
	task lastRequestTime: timeNow.
	(Processor activeProcess)
		language: session language;
		webTask: task.
	^task processGet: request on: stream!

processPost: request on: stream 
	| taskId task session timeNow |
	self checkOrSetDefaultClientIdCookieFor: request on: stream.
	timeNow := ItcSystemManager absoluteSecondsClockValue.
	taskId := request header url.
	taskId size < (application urlPrefix size + 7) ifTrue: [^stream fileNotFoundResponse].
	task := taskId indexOf: $..
	taskId := taskId copyFrom: application urlPrefix size + 7
				to: (task == 0 ifTrue: [taskId size] ifFalse: [task - 1]).
	(task := application taskAt: taskId) isNil 
		ifTrue: 
			[^(session := application sessionAt: taskId) isNil 
				ifTrue: 
					[Processor activeProcess language: application defaultLanguage.
					application sendSessionExpiredResponseOn: stream]
				ifFalse: 
					[Processor activeProcess language: session language.
					session lastRequestTime: timeNow.
					application sendPageExpiredMessageFor: session on: stream]].
	session := task session.
	"	session requestSender address address = request sender address address
		ifFalse: [ ^application sendLoginPageWithMessage: 'Your session has been cancelled due to wrong network address. Please login again.' on: stream ]."
	session lastRequestTime: timeNow.
	task lastRequestTime: timeNow.
	(Processor activeProcess)
		language: session language;
		webTask: task.
	^task processPost: request on: stream! !
!WebTaskRoutingServlet categoriesFor: #processGet:on:!public! !
!WebTaskRoutingServlet categoriesFor: #processPost:on:!public! !

!WebTaskRoutingServlet class methodsFor!

servletName

	^'WOB'! !
!WebTaskRoutingServlet class categoriesFor: #servletName!public! !

