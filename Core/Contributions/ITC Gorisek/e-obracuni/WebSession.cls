"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebSession
	instanceVariableNames: 'clientIP clientHostname loginTime pageHits language lastRequestTime id application user lastTaskId tasks defaultTask sessionData tracer thousandsSeparator decimalPoint userAgent isPersistent screenWidth screenHeight cookieId superSession dateFormat clientCookie mutex useEnterForTabbing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebSession guid: (GUID fromString: '{1168CD69-861C-4E4D-8AB4-6E77B57E4FF8}')!
WebSession comment: ''!
!WebSession categoriesForClass!Unclassified! !
!WebSession methodsFor!

addPersistentTask: aWebTask 
	^(self addTask: aWebTask) lastRequestTime: false!

addTask: aWebTask 
	| taskId |
	mutex critical: [taskId := lastTaskId := lastTaskId + 1].
	taskId := taskId printString.
	aWebTask 
		setApplication: application
		session: self
		taskId: taskId.
	mutex critical: [tasks at: taskId put: aWebTask].
	^aWebTask!

allTasks
	^mutex critical: [tasks values]!

application
	^application!

clientCookie
	^clientCookie!

clientCookie: aString 
	clientCookie := aString!

clientHostname
	clientHostname isNil ifTrue: [clientHostname := WebHttpServer getHostnameFromIP: clientIP].
	^clientHostname!

clientIP
	^clientIP!

cookieId
	^cookieId!

cookieId: aString 
	cookieId := aString!

dateFormat
	| targetLanguage |
	(targetLanguage := Processor activeProcess attributes at: #targetLanguage ifAbsent: []) isNil 
		ifFalse: [^WebTranslationService dateFormatForLanguage: targetLanguage].
	^dateFormat isNil 
		ifTrue: [WebTranslationService dateFormatForLanguage: self language]
		ifFalse: [dateFormat]!

decimalPoint
	^decimalPoint!

decimalPoint: aCharacterOrNil 
	decimalPoint := aCharacterOrNil!

defaultTask
	^defaultTask!

defaultTask: aWebTask 
	(mutex critical: [tasks includes: aWebTask]) ifFalse: [self addPersistentTask: aWebTask].
	defaultTask := aWebTask!

expirationTime
	"Answer number of seconds when the session expires."

	| lastTime timeNow |
	lastTime := superSession isNil 
				ifTrue: [lastRequestTime]
				ifFalse: [superSession lastRequestTime].
	timeNow := ItcSystemManager absoluteSecondsClockValue.
	^application maxInactivityTime - timeNow + lastTime!

expirationTimeInfo
	| lastTime timeNow seconds |
	lastTime := superSession isNil 
				ifTrue: [lastRequestTime]
				ifFalse: [superSession lastRequestTime].
	timeNow := ItcSystemManager absoluteSecondsClockValue.
	seconds := application maxInactivityTime - timeNow + lastTime.
	^(seconds // 60) printString , ' min ' , (seconds \\ 60) printString , ' sec'!

getLastRequestTime
	"Answer last request time on the absolute time scale."

	^superSession isNil ifTrue: [lastRequestTime] ifFalse: [superSession lastRequestTime]!

getScreenHeight
	^screenHeight isNilOrZero ifTrue: [768] ifFalse: [screenHeight]!

getScreenWidth
	^screenWidth isNilOrZero ifTrue: [1024] ifFalse: [screenWidth]!

isAjaxCapableBrowser
	"Vrne <true>, ce brskalnik podpira AJAX funkcionalnost."

	userAgent isNilOrEmpty ifTrue: [^false].
	self isUserAgentMozilla ifTrue: [^true].
	self isUserAgentInternetExplorer55AndUp ifTrue: [^true].
	self isUserAgentOpera ifTrue: [^true].
	^false!

isPersistent
	^isPersistent!

isUserAgentInternetExplorer55AndUp
	"DG: Na Win 98 naj bi z IE 5.5 ne koledarcek ne deloval zato sem spremenil, da javi <true> sele takrat, ko je IE 6.0"

	| str index |
	str := self userAgent.
	str isNilOrEmpty ifTrue: [^false].
	index := str indexOfSubCollection: 'MSIE ' startingAt: 1.
	index = 0 ifTrue: [^false].
	str := str copyFrom: index + 5 to: str size.
	str size < 3 ifTrue: [^false].
	(str at: 1) >= $6 ifTrue: [^true].
	^false!

isUserAgentMozilla
	^'*GECKO*' match: self userAgent asUppercase!

isUserAgentOpera
	^'*OPERA*' match: self userAgent asUppercase!

language
	language isNil ifTrue: [^application defaultLanguage].
	^language!

language: aString 
	language := aString.
	thousandsSeparator := WebTranslationService thousandsSeparatorFor: language.
	decimalPoint := WebTranslationService decimalPointFor: language.
	dateFormat := WebTranslationService dateFormatForLanguage: language!

lastRequestTime
	^lastRequestTime!

lastRequestTime: anInteger 
	lastRequestTime := anInteger.
	pageHits := pageHits + 1.
	superSession isNil ifFalse: [superSession lastRequestTime: anInteger]!

loginTime
	^loginTime!

makePersistent
	"Mark session as persistent i.e. a session that never expires."

	isPersistent := true!

onSessionRemoved
	"This method is sent when the session is removed from the web server.
	This method can be sent more than once."

	defaultTask isNil ifFalse: [defaultTask onTaskRemoved].
	(mutex critical: [tasks values]) do: [:eachTask | eachTask onTaskRemoved]!

pageHits
	^pageHits!

printOn: aStream 
	self class printOn: aStream.
	aStream
		space;
		nextPutAll: id asString;
		space.
	user printOn: aStream!

purgeExpiredTasks
	| currentTime maxInactivityTime elapsedTime |
	maxInactivityTime := application maxInactivityTime.
	currentTime := ItcSystemManager absoluteSecondsClockValue.
	(mutex critical: [tasks values]) do: 
			[:eachTask | 
			(elapsedTime := eachTask elapsedTimeSince: currentTime) notNil 
				ifTrue: 
					[elapsedTime > maxInactivityTime 
						ifTrue: [eachTask ~= defaultTask ifTrue: [self removeTask: eachTask]]]]!

removeTask: aWebTask 
	| key |
	aWebTask isNil ifTrue: [^self].
	aWebTask == defaultTask ifTrue: [self error: 'Default task can not be removed'].
	aWebTask onTaskRemoved.
	(key := aWebTask taskId) isNil 
		ifFalse: [mutex critical: [tasks removeKey: aWebTask taskId ifAbsent: []]]!

removeTrace
	tracer := nil!

screenHeight
	^screenHeight!

screenHeight: anObject
	screenHeight := anObject!

screenWidth
	^screenWidth!

screenWidth: anObject
	screenWidth := anObject!

sessionCritical: aBlock 
	"Evaluate aBlock using session's mutex."

	^mutex critical: aBlock!

sessionData
	^sessionData!

sessionId
	^id!

setApplication: aWebApplication 
	application := aWebApplication.
	tasks isNil ifFalse: [self allTasks do: [:each | each setApplication: aWebApplication]]!

setApplication: aWebApplication clientIP: aString sessionId: sessionId 
	application := aWebApplication.
	id := sessionId.
	lastTaskId := 0.
	pageHits := 1.
	loginTime := Timestamp now.
	mutex := Semaphore forMutualExclusion.
	tasks := LookupTable new.
	clientIP := aString.
	sessionData := ItcLookupTable new.
	lastRequestTime := ItcSystemManager absoluteSecondsClockValue.
	isPersistent := false!

superSession
	^superSession!

superSession: aWebSession 
	"Super session je session, ki zdruzuje vec locenih session-ov za enega user-ja.
	Vsi ti session-i imajo enak expiration time.
	Logout enega session-a povzroci logout vseh session-ov."

	superSession := aWebSession!

taskAt: taskIdString 
	"Answer task at taskIdString. A taskIdString can be in the following form:

		TTTTTT-RRRR

	where
		TTTTTT  is a task ID
		RRRR   is any random number or none"

	| index taskId |
	(index := taskIdString indexOf: $-) = 0 
		ifFalse: [taskId := taskIdString copyFrom: 1 to: index - 1]
		ifTrue: [taskId := taskIdString].
	^mutex critical: [tasks at: taskId ifAbsent: []]!

thousandsSeparator
	^thousandsSeparator!

thousandsSeparator: aCharacterOrNil 
	thousandsSeparator := aCharacterOrNil!

traceNotifying: aStream 
	tracer := aStream!

tracer
	^tracer!

useEnterForTabbing
	^useEnterForTabbing!

useEnterForTabbing: aBoolean 
	useEnterForTabbing := aBoolean!

user
	^user!

user: anObject 
	user := anObject!

userAgent
	^userAgent!

userAgent: aString 
	userAgent := aString!

usernameInfo
	^user isNil 
		ifTrue: ['N/A']
		ifFalse: 
			[user isString 
				ifTrue: [user]
				ifFalse: 
					[(user respondsTo: #usernameInfo) ifTrue: [user usernameInfo asWebString] ifFalse: [user printString]]]! !
!WebSession categoriesFor: #addPersistentTask:!public! !
!WebSession categoriesFor: #addTask:!public! !
!WebSession categoriesFor: #allTasks!public! !
!WebSession categoriesFor: #application!public! !
!WebSession categoriesFor: #clientCookie!public! !
!WebSession categoriesFor: #clientCookie:!public! !
!WebSession categoriesFor: #clientHostname!public! !
!WebSession categoriesFor: #clientIP!public! !
!WebSession categoriesFor: #cookieId!public! !
!WebSession categoriesFor: #cookieId:!public! !
!WebSession categoriesFor: #dateFormat!public! !
!WebSession categoriesFor: #decimalPoint!public! !
!WebSession categoriesFor: #decimalPoint:!public! !
!WebSession categoriesFor: #defaultTask!public! !
!WebSession categoriesFor: #defaultTask:!public! !
!WebSession categoriesFor: #expirationTime!public! !
!WebSession categoriesFor: #expirationTimeInfo!public! !
!WebSession categoriesFor: #getLastRequestTime!public! !
!WebSession categoriesFor: #getScreenHeight!accessing!public! !
!WebSession categoriesFor: #getScreenWidth!accessing!public! !
!WebSession categoriesFor: #isAjaxCapableBrowser!public! !
!WebSession categoriesFor: #isPersistent!public! !
!WebSession categoriesFor: #isUserAgentInternetExplorer55AndUp!public! !
!WebSession categoriesFor: #isUserAgentMozilla!public! !
!WebSession categoriesFor: #isUserAgentOpera!public! !
!WebSession categoriesFor: #language!public! !
!WebSession categoriesFor: #language:!public! !
!WebSession categoriesFor: #lastRequestTime!public! !
!WebSession categoriesFor: #lastRequestTime:!public! !
!WebSession categoriesFor: #loginTime!public! !
!WebSession categoriesFor: #makePersistent!public! !
!WebSession categoriesFor: #onSessionRemoved!private! !
!WebSession categoriesFor: #pageHits!public! !
!WebSession categoriesFor: #printOn:!public! !
!WebSession categoriesFor: #purgeExpiredTasks!public! !
!WebSession categoriesFor: #removeTask:!public! !
!WebSession categoriesFor: #removeTrace!public! !
!WebSession categoriesFor: #screenHeight!accessing!public! !
!WebSession categoriesFor: #screenHeight:!accessing!public! !
!WebSession categoriesFor: #screenWidth!accessing!public! !
!WebSession categoriesFor: #screenWidth:!accessing!public! !
!WebSession categoriesFor: #sessionCritical:!public! !
!WebSession categoriesFor: #sessionData!public! !
!WebSession categoriesFor: #sessionId!public! !
!WebSession categoriesFor: #setApplication:!public! !
!WebSession categoriesFor: #setApplication:clientIP:sessionId:!public! !
!WebSession categoriesFor: #superSession!public! !
!WebSession categoriesFor: #superSession:!public! !
!WebSession categoriesFor: #taskAt:!public! !
!WebSession categoriesFor: #thousandsSeparator!public! !
!WebSession categoriesFor: #thousandsSeparator:!public! !
!WebSession categoriesFor: #traceNotifying:!public! !
!WebSession categoriesFor: #tracer!public! !
!WebSession categoriesFor: #useEnterForTabbing!accessing!public! !
!WebSession categoriesFor: #useEnterForTabbing:!accessing!public! !
!WebSession categoriesFor: #user!public! !
!WebSession categoriesFor: #user:!public! !
!WebSession categoriesFor: #userAgent!public! !
!WebSession categoriesFor: #userAgent:!public! !
!WebSession categoriesFor: #usernameInfo!public! !

!WebSession class methodsFor!

forLanguage: aString 
	^(self new)
		language: aString;
		yourself! !
!WebSession class categoriesFor: #forLanguage:!public! !

