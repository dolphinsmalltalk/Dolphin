"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WebMainPageServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebMainPageServlet guid: (GUID fromString: '{DDF71750-9E4F-4D48-84F1-55B3D17C088D}')!
WebMainPageServlet comment: ''!
!WebMainPageServlet categoriesForClass!Unclassified! !
!WebMainPageServlet methodsFor!

process: request on: stream 
	| session array sessionId loginFirstPageActionParameter |
	self checkOrSetDefaultClientIdCookieFor: request on: stream.
	request action = 'sessionExpired' 
		ifTrue: 
			[Processor activeProcess language: application defaultLanguage.
			^application 
				sendLoginPageFor: request
				withMessage: application sessionExpiredMessage
				on: stream].
"TO DO check this implementation"
	((array := request stringOrNilAt: 'a') isNilOrEmpty 
		or: [(array := array webDeserializeFromString) isNil or: [array class ~~ Array or: [array size < 8]]]) 
			ifFalse: 
				[sessionId := array at: 8.
				sessionId notNil 
					ifTrue: 
						[session := application sessionAt: sessionId.
						session isNilOrEmpty ifFalse: [loginFirstPageActionParameter := array at: 7].
						loginFirstPageActionParameter notNil 
							ifTrue: [session sessionData at: #loginFirstPageActionParameter put: loginFirstPageActionParameter]]].
	session isNil 
		ifTrue: 
			[session := self application 
						newSessionFor: request
						username: (request stringAt: 'username')
						password: (request stringAt: 'password')].
	session isString 
		ifTrue: 
			[Processor activeProcess language: application defaultLanguage.
			application 
				sendLoginPageFor: request
				withMessage: session
				on: stream]
		ifFalse: 
			[(Processor activeProcess)
				language: session language;
				webSession: session.
			session clientCookie isNilOrEmpty 
				ifFalse: 
					[stream 
						setCookieNamed: 'ItcClientID'
						value: session clientCookie
						path: '/'
						expires: (Timestamp date: (Date 
										newDay: 31
										monthIndex: 12
										year: 2015)
								time: (Time 
										hours: 23
										minutes: 59
										seconds: 59))
						domain: nil
						secure: false].
			application 
				sendFirstPageFor: session
				request: request
				on: stream]! !
!WebMainPageServlet categoriesFor: #process:on:!public! !

!WebMainPageServlet class methodsFor!

servletName

	^'index.html'! !
!WebMainPageServlet class categoriesFor: #servletName!public! !

