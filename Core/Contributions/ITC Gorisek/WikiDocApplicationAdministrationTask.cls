"Filed out from Dolphin Smalltalk X6.1"!

WebApplicationAdministrationTask subclass: #WikiDocApplicationAdministrationTask
	instanceVariableNames: 'defaultToolbar'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocApplicationAdministrationTask guid: (GUID fromString: '{099A7CB6-9818-4CBE-908A-37F565C88BA6}')!
WikiDocApplicationAdministrationTask comment: ''!
!WikiDocApplicationAdministrationTask categoriesForClass!Unclassified! !
!WikiDocApplicationAdministrationTask methodsFor!

defaultToolbar
	^defaultToolbar!

defaultToolbar: anObject
	defaultToolbar := anObject!

newCoder: stream 
	^(application basicNewCoder: stream)
		task: self urlPrefix: self taskURLPrefix;
		session: session;
		sessionURLPrefix: self sessionURLPrefix;
		defaultToolbar: defaultToolbar;
		topNavigation: parentTopNavigation!

processNoAccess: request on: stream 
	(self newCoder: stream) formPage: 'Access denied'! !
!WikiDocApplicationAdministrationTask categoriesFor: #defaultToolbar!accessing!private! !
!WikiDocApplicationAdministrationTask categoriesFor: #defaultToolbar:!accessing!private! !
!WikiDocApplicationAdministrationTask categoriesFor: #newCoder:!public! !
!WikiDocApplicationAdministrationTask categoriesFor: #processNoAccess:on:!public!request handlers! !

