"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocLoginTask
	instanceVariableNames: 'onLogin'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocLoginTask guid: (GUID fromString: '{D433B200-90AA-4263-962B-DBA5F0189C1F}')!
WikiDocLoginTask comment: ''!
!WikiDocLoginTask categoriesForClass!Unclassified! !
!WikiDocLoginTask methodsFor!

onLogin: anObject
	onLogin := anObject!

processDefault: request on: stream 
	request isIndexingRobotOrWebSpider 
		ifTrue: [^(self newCoder: stream) errorPage: 'Invalid user agent for logging in.'].
	session user isNil ifFalse: [^onLogin value: stream].
	(self newCoder: stream)
		topNavigation: parentTopNavigation;
		loginPage: nil!

processGet: request on: stream 
	Processor activeProcess language: language.
	self processDefault: request on: stream!

processPost: request on: stream 
	| uid pwd result |
	Processor activeProcess language: language.
	uid := request stringAt: 'uid'.
	pwd := request stringAt: 'pwd'.
	result := application 
				loginForSession: session
				username: uid
				password: pwd.
	
	[result = true 
		ifTrue: [onLogin value: stream]
		ifFalse: 
			[(self newCoder: stream)
				topNavigation: parentTopNavigation;
				loginPage: result]] 
			evaluateIn: application newReadOnlyTransaction! !
!WikiDocLoginTask categoriesFor: #onLogin:!accessing!public! !
!WikiDocLoginTask categoriesFor: #processDefault:on:!public! !
!WikiDocLoginTask categoriesFor: #processGet:on:!public! !
!WikiDocLoginTask categoriesFor: #processPost:on:!public! !

