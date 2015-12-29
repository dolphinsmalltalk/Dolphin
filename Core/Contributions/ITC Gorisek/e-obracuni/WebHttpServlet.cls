"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebHttpServlet
	instanceVariableNames: 'application'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpServlet guid: (GUID fromString: '{3EC5B5D1-52A0-4B10-A8BD-2D8BEB822ED2}')!
WebHttpServlet comment: ''!
!WebHttpServlet categoriesForClass!Unclassified! !
!WebHttpServlet methodsFor!

application
	^application!

application: aWebApplication 
	application := aWebApplication.
	self initialize!

checkOrSetDefaultClientIdCookieAndSessionFor: request on: responseStream 
	| clientCookie sessionCookie session noClientCookie |
	(noClientCookie := (clientCookie := request header cookieAt: 'ItcClientID') isNilOrEmpty) 
		ifTrue: 
			[responseStream 
				setCookieNamed: 'ItcClientID'
				value: (clientCookie := (request stringOrNilAt: '_cc') isNilOrEmpty 
								ifTrue: [self generateNewClientCookieValue]
								ifFalse: [request stringOrNilAt: '_cc'])
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
	(sessionCookie := request header cookieAt: application webSessionCookieName) isNilOrEmpty 
		ifFalse: [session := application sessionAtCookie: sessionCookie]
		ifTrue: 
			[noClientCookie 
				ifTrue: 
					[(request stringAt: '_cc') isNilOrEmpty 
						ifFalse: 
							["predpostavlja, da bi client cookie le moral biti nastavljen zato naredi poseben interni cookie za taksne, ki ne podpirajo cookie-jev"
							clientCookie := #cookiesTurnedOff asString].


					"preveri ali obstaja se kak session za ta IP in user agent-a, to pomeni, da ima uporabnik izklopljene cookie-je, v tem primeru se za ta IP kreira posebni session z ID-jem cookies_turned_off"
					session := application activeSessions detect: 
									[:each | 
									each user isNil and: 
											[each clientIP = request clientIP 
												and: [each userAgent = request userAgent and: [each clientCookie = #cookiesTurnedOff asString]]]]
								ifNone: []]].
	session isNil 
		ifTrue: 
			[session := application 
						newSessionFor: request
						sessionCookie: application getNewSessionId , '_' , Timestamp now totalSeconds printString
						clientCookie: clientCookie.
			responseStream 
				setCookieNamed: application webSessionCookieName
				value: session cookieId
				path: '/'
				expires: (Timestamp fromSeconds: Timestamp now totalSeconds + 300000)
				domain: nil
				secure: false].
	(Processor activeProcess)
		webSession: session;
		language: session language.
	session lastRequestTime: ItcSystemManager absoluteSecondsClockValue.
	^session!

checkOrSetDefaultClientIdCookieFor: request on: responseStream 
	(request header cookieAt: 'ItcClientID') isNilOrEmpty 
		ifTrue: 
			[responseStream 
				setCookieNamed: 'ItcClientID'
				value: self generateNewClientCookieValue
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
				secure: false]!

dispatch: request on: stream ifNone: aBlock 
	| action methodSelector |
	action := request action copy.
	(action isNilOrEmpty or: [action = 'post' or: [action = 'get']]) 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]].
	^aBlock value!

dispatch: request on: stream withDefault: defaultAction 
	| action methodSelector |
	(action := request action copy) isNilOrEmpty 
		ifTrue: [action := defaultAction webAsActionString copy].
	action isNilOrEmpty 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]]!

dispatch: request using: possibleActions on: stream 
	| action methodSelector |
	action := request action copy.
	(possibleActions detect: [:eachAction | eachAction webAsActionString = action] ifNone: []) isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream]]!

dispatch: request using: possibleActions on: stream withDefault: defaultAction 
	| action methodSelector |
	action := request action copy.
	possibleActions detect: [:eachAction | eachAction webAsActionString = action]
		ifNone: [action := defaultAction webAsActionString copy].
	action isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream]]!

generateNewClientCookieValue
	^application getNewSessionId , '_' , Timestamp now totalSeconds printString!

initialize
	"Add servlet initialization code here. Application inst var reference is already set at this point."

	!

newCoder
	^self newCoder: self webStream!

newCoder: stream 
	^(application basicNewCoder: stream)
		urlPrefix: '/' , application urlPrefix , '/' , self servletName;
		session: self webSession;
		sessionURLPrefix: '/' , application urlPrefix , '/' , (application indexServlet isNil 
							ifTrue: [self servletName]
							ifFalse: [application indexServlet servletName])!

printWebUrlOn: aStream 
	aStream nextPutAll: self servletName!

process: request on: stream 
	self subclassResponsibility!

processGet: request on: stream 
	self process: request on: stream!

processHead: request on: stream 
	self processGet: request on: stream!

processPost: request on: stream 
	self process: request on: stream!

putAjaxResults: results isFrameRequest: isFrameRequest on: stream 
	stream putAjaxResults: results isFrameRequest: isFrameRequest!

service: request on: stream 
	| command |
	command := request header command.
	(Processor activeProcess)
		webApplication: application;
		webRequest: request;
		webStream: stream.
	command = 'GET' ifTrue: [^self processGet: request on: stream].
	command = 'POST' ifTrue: [^self processPost: request on: stream].
	command = 'HEAD' ifTrue: [^self processHead: request on: stream]!

servletName
	^self class servletName!

urlPrefix
	^'/' , application urlPrefix , '/' , self servletName!

urlPrefixForAction: aStringOrSymbol 
	^self urlPrefixForAction: aStringOrSymbol id: nil!

urlPrefixForAction: aStringOrSymbol id: anObject 
	| stream |
	stream := WriteStream on: (String new: 128).
	aStringOrSymbol isAjaxAction 
		ifTrue: 
			[Processor activeProcess attributes at: #javascriptDialogBox put: true.
			stream
				nextPutAll: 'javascript:ajaxGetRequest(''';
				nextPutAll: self urlPrefix;
				nextPutAll: '?action=';
				nextPutAll: aStringOrSymbol webAsActionString.
			anObject isNilOrEmpty 
				ifFalse: 
					[stream
						nextPutAll: '&id=';
						nextPutAll: anObject asWebString].
			stream nextPutAll: ''');void(0);']
		ifFalse: 
			[stream
				nextPutAll: self urlPrefix;
				nextPutAll: '?action=';
				nextPutAll: aStringOrSymbol webAsActionString.
			anObject isNilOrEmpty 
				ifFalse: 
					[stream
						nextPutAll: '&id=';
						nextPutAll: anObject asWebString]].
	^stream contents! !
!WebHttpServlet categoriesFor: #application!public! !
!WebHttpServlet categoriesFor: #application:!public! !
!WebHttpServlet categoriesFor: #checkOrSetDefaultClientIdCookieAndSessionFor:on:!public!session management! !
!WebHttpServlet categoriesFor: #checkOrSetDefaultClientIdCookieFor:on:!public!session management! !
!WebHttpServlet categoriesFor: #dispatch:on:ifNone:!public! !
!WebHttpServlet categoriesFor: #dispatch:on:withDefault:!public! !
!WebHttpServlet categoriesFor: #dispatch:using:on:!public! !
!WebHttpServlet categoriesFor: #dispatch:using:on:withDefault:!public! !
!WebHttpServlet categoriesFor: #generateNewClientCookieValue!public!session management! !
!WebHttpServlet categoriesFor: #initialize!public! !
!WebHttpServlet categoriesFor: #newCoder!public! !
!WebHttpServlet categoriesFor: #newCoder:!public! !
!WebHttpServlet categoriesFor: #printWebUrlOn:!public! !
!WebHttpServlet categoriesFor: #process:on:!public! !
!WebHttpServlet categoriesFor: #processGet:on:!public! !
!WebHttpServlet categoriesFor: #processHead:on:!public! !
!WebHttpServlet categoriesFor: #processPost:on:!public! !
!WebHttpServlet categoriesFor: #putAjaxResults:isFrameRequest:on:!public! !
!WebHttpServlet categoriesFor: #service:on:!public! !
!WebHttpServlet categoriesFor: #servletName!public! !
!WebHttpServlet categoriesFor: #urlPrefix!public! !
!WebHttpServlet categoriesFor: #urlPrefixForAction:!public! !
!WebHttpServlet categoriesFor: #urlPrefixForAction:id:!public! !

!WebHttpServlet class methodsFor!

printWebUrlOn: aStream

	aStream nextPutAll: self servletName!

servletName

	^self name asString! !
!WebHttpServlet class categoriesFor: #printWebUrlOn:!public! !
!WebHttpServlet class categoriesFor: #servletName!public! !

