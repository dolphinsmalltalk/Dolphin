"Filed out from Dolphin Smalltalk X6.1"!

WikiDocObject subclass: #WikiDocSession
	instanceVariableNames: 'user loginTS loginIP loginHostname loginUserAgent cookie previousSession clientCookie nextSession referer logoutTS usageLog selectedLanguage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocSession guid: (GUID fromString: '{29213918-CA96-405A-9A81-F02063F681BC}')!
WikiDocSession comment: ''!
!WikiDocSession categoriesForClass!Unclassified! !
!WikiDocSession methodsFor!

clientCookie
	^clientCookie!

clientCookie: anObject
	clientCookie := anObject!

cookie
	^cookie!

cookie: anObject
	cookie := anObject!

loginHostname
	^loginHostname!

loginHostname: anObject
	loginHostname := anObject!

loginIP
	^loginIP!

loginIP: anObject
	loginIP := anObject!

loginTS
	^loginTS!

loginTS: anObject
	loginTS := anObject!

loginUserAgent
	^loginUserAgent!

loginUserAgent: anObject
	loginUserAgent := anObject!

logoutTS
	^logoutTS!

logoutTS: anObject
	logoutTS := anObject!

nextSession
	^nextSession!

nextSession: anObject
	nextSession := anObject!

previousSession
	^previousSession!

previousSession: anObject
	previousSession := anObject!

referer
	^referer!

referer: anObject
	referer := anObject!

selectedLanguage
	^selectedLanguage!

selectedLanguage: anObject
	selectedLanguage := anObject!

usageLog
	usageLog isNil ifTrue: [usageLog := LookupTable new].
	^usageLog!

user
	^user!

user: anObject
	user := anObject! !
!WikiDocSession categoriesFor: #clientCookie!accessing!private! !
!WikiDocSession categoriesFor: #clientCookie:!accessing!private! !
!WikiDocSession categoriesFor: #cookie!accessing!private! !
!WikiDocSession categoriesFor: #cookie:!accessing!private! !
!WikiDocSession categoriesFor: #loginHostname!accessing!private! !
!WikiDocSession categoriesFor: #loginHostname:!accessing!private! !
!WikiDocSession categoriesFor: #loginIP!accessing!private! !
!WikiDocSession categoriesFor: #loginIP:!accessing!private! !
!WikiDocSession categoriesFor: #loginTS!accessing!private! !
!WikiDocSession categoriesFor: #loginTS:!accessing!private! !
!WikiDocSession categoriesFor: #loginUserAgent!accessing!private! !
!WikiDocSession categoriesFor: #loginUserAgent:!accessing!private! !
!WikiDocSession categoriesFor: #logoutTS!accessing!private! !
!WikiDocSession categoriesFor: #logoutTS:!accessing!private! !
!WikiDocSession categoriesFor: #nextSession!accessing!private! !
!WikiDocSession categoriesFor: #nextSession:!accessing!private! !
!WikiDocSession categoriesFor: #previousSession!accessing!private! !
!WikiDocSession categoriesFor: #previousSession:!accessing!private! !
!WikiDocSession categoriesFor: #referer!accessing!private! !
!WikiDocSession categoriesFor: #referer:!accessing!private! !
!WikiDocSession categoriesFor: #selectedLanguage!accessing!private! !
!WikiDocSession categoriesFor: #selectedLanguage:!accessing!private! !
!WikiDocSession categoriesFor: #usageLog!accessing!private! !
!WikiDocSession categoriesFor: #user!accessing!private! !
!WikiDocSession categoriesFor: #user:!accessing!private! !

