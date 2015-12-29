"Filed out from Dolphin Smalltalk X6.1"!

Shell subclass: #WebApplicationServerShell
	instanceVariableNames: 'sessionsPresenter serverInstance'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebApplicationServerShell guid: (GUID fromString: '{684E07A1-760E-4B1B-ACEE-C517041593C5}')!
WebApplicationServerShell comment: ''!
!WebApplicationServerShell categoriesForClass!Unclassified! !
!WebApplicationServerShell methodsFor!

activeApplications
	| coll |
	coll := OrderedCollection new.
	WebApplication allSubclasses 
		do: [:each | each defaultOrNil isNil ifFalse: [coll add: each default]].
	^coll!

buttonClickedCreateDatabaseBackup
	| omniBaseApps |
	omniBaseApps := self omniBaseApps.
	omniBaseApps isNilOrEmpty 
		ifFalse: 
			[(SessionManager current respondsTo: #makeOmniBaseBackupFor:) 
				ifTrue: [omniBaseApps do: [:each | SessionManager current makeOmniBaseBackupFor: each]]]!

buttonClickedRefreshList
	| allSessions |
	allSessions := OrderedCollection new.
	self activeApplications do: [:each | allSessions addAll: each activeSessions].
	sessionsPresenter list: allSessions.
	self updateCaption!

buttonClickedResetApplications
	self activeApplications do: 
			[:each | 
			each
				shutdown;
				startup].
	self buttonClickedRefreshList!

buttonClickedShutdown
	self activeApplications do: [:each | each shutdown].
	self serverInstance isNil ifFalse: [self serverInstance shutdown].
	ItcSystemManager quitImage!

createComponents
	super createComponents.
	sessionsPresenter := self add: ListPresenter new name: 'sessionsList'!

omniBaseApps
	^self activeApplications 
		select: [:each | (each respondsTo: #omniBasePath) and: [each omniBasePath isNilOrEmpty not]]!

onViewOpened
	super onViewOpened.
	[self buttonClickedRefreshList] postToInputQueue!

serverInstance
	serverInstance notNil ifTrue: [^serverInstance].
	^WebHttpServer currentOrNil!

updateCaption
	| server |
	(server := self serverInstance) isNil 
		ifTrue: [self caption: 'No web server is currently running, click Refresh button to update...']
		ifFalse: 
			[self 
				caption: server serverProtocol , ' server@localhost:' , server serverPort printString , ' ' 
						, (self activeApplications collect: [:each | each urlPrefix]) asWebString , ' [started@' 
						, server serverStartedTS displayString , ']']! !
!WebApplicationServerShell categoriesFor: #activeApplications!public! !
!WebApplicationServerShell categoriesFor: #buttonClickedCreateDatabaseBackup!public! !
!WebApplicationServerShell categoriesFor: #buttonClickedRefreshList!public! !
!WebApplicationServerShell categoriesFor: #buttonClickedResetApplications!public! !
!WebApplicationServerShell categoriesFor: #buttonClickedShutdown!public! !
!WebApplicationServerShell categoriesFor: #createComponents!public! !
!WebApplicationServerShell categoriesFor: #omniBaseApps!private! !
!WebApplicationServerShell categoriesFor: #onViewOpened!private! !
!WebApplicationServerShell categoriesFor: #serverInstance!public! !
!WebApplicationServerShell categoriesFor: #updateCaption!public! !

!WebApplicationServerShell class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 0 234 256 98 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 802 1017 49 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 252 1 0 0 24 0 0 0] 98 4 410 8 ##(Smalltalk.PushButton)  98 20 0 560 98 2 8 1140924416 1 912 0 0 0 7 0 0 0 912 0 8 4294912845 1180998 4 ##(Smalltalk.CommandDescription)  8 #buttonClickedRefreshList 8 'Refresh list' 1 1 0 0 32 0 0 0 674 202 208 98 3 738 768 98 2 802 1 1 802 191 51 912 738 8 #isEnabled: 98 1 32 912 738 8 #text: 98 1 8 'Refresh list' 912 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 95 0 0 0 25 0 0 0] 98 0 802 193 193 0 29 410 928 98 20 0 560 98 2 8 1140924416 1 1360 0 0 0 7 0 0 0 1360 0 8 4294912845 1010 8 #buttonClickedResetApplications 8 'Restart all' 1 1 0 0 32 0 0 0 674 202 208 98 3 738 768 98 2 802 191 1 802 261 49 1360 738 1200 98 1 32 1360 738 1248 98 1 8 'Restart all' 1360 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 0 0 0 0 225 0 0 0 24 0 0 0] 98 0 1344 0 29 410 928 98 20 0 560 98 2 8 1140924416 1 1728 0 0 0 7 0 0 0 1728 0 8 4294912845 1010 8 #buttonClickedShutdown 8 'Shutdown all' 1 1 0 0 32 0 0 0 674 202 208 98 3 738 768 98 2 802 451 1 802 211 49 1728 738 1200 98 1 32 1728 738 1248 98 1 8 'Shutdown all' 1728 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 225 0 0 0 0 0 0 0 74 1 0 0 24 0 0 0] 98 0 1344 0 29 410 928 98 20 0 560 98 2 8 1140924416 1 2096 0 0 0 7 0 0 0 2096 0 8 4294912845 1010 8 #buttonClickedCreateDatabaseBackup 8 'Create database backup' 1 1 0 0 32 0 0 0 674 202 208 98 3 738 768 98 2 802 661 1 802 371 49 2096 738 1200 98 1 32 2096 738 1248 98 1 8 'Create database backup' 2096 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 3 2 0 0 24 0 0 0] 98 0 1344 0 29 1344 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 2464 590662 2 ##(Smalltalk.ListModel)  202 208 656 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 2464 0 8 4294912777 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 9 920646 5 ##(Smalltalk.ListViewColumn)  8 'Application' 251 8 #left 2656 8 ##(Smalltalk.SortedCollection)  787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:session | session application urlPrefix]' 8 #[31 105 226 0 159 106] 8 #application 8 #urlPrefix 2848 7 257 0 0 2464 0 1 0 0 2754 8 'Session ID' 201 2800 2656 2816 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session | session sessionId ]' 8 #[30 105 226 0 106] 8 #sessionId 3024 7 257 0 0 2464 0 1 0 0 2754 8 'User' 201 2800 2656 2816 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session | session usernameInfo]' 8 #[30 105 226 0 106] 8 #usernameInfo 3152 7 257 0 0 2464 0 1 0 0 2754 8 'IP' 201 2800 459270 ##(Smalltalk.Message)  8 #displayString 98 0 3282 8 #<= 3328 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session | session clientIP]' 8 #[30 105 226 0 106] 8 #clientIP 3376 7 257 0 0 2464 0 1 0 0 2754 8 'Login' 201 2800 2656 2816 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session | session loginTime]' 8 #[30 105 226 0 106] 8 #loginTime 3504 7 257 0 0 2464 0 1 0 0 2754 8 'Last request TS' 201 2800 3282 3312 3328 3282 3360 3328 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session | session lastRequestTime]' 8 #[30 105 226 0 106] 8 #lastRequestTime 3664 7 257 0 0 2464 0 1 0 0 2754 8 'Expires in' 201 2800 2656 2816 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session | session expirationTimeInfo]' 8 #[30 105 226 0 106] 8 #expirationTimeInfo 3792 7 257 0 0 2464 0 1 0 0 2754 8 'Page hits' 201 2800 2656 2816 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session | session pageHits ]' 8 #[30 105 226 0 106] 8 #pageHits 3920 7 257 0 0 2464 0 1 0 0 2754 8 'Browser' 201 2800 2656 2816 2834 0 0 2866 2 1 2896 8 'doIt' 8 '[:session |session userAgent].' 8 #[30 105 226 0 106] 8 #userAgent 4048 7 257 0 0 2464 0 3 0 0 8 #report 656 0 131169 0 0 674 202 208 98 2 738 768 98 2 802 1 49 802 1017 597 2464 738 1248 98 1 8 'Application' 2464 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 252 1 0 0 66 1 0 0] 98 0 1344 0 27 234 256 98 2 2464 8 'sessionsList' 0 0 0 0 0 1 0 0 0 0 1 0 0 674 202 208 98 3 738 768 98 2 802 3359 21 802 1049 721 416 738 1248 98 1 8 'ITC application server control panel' 416 738 8 #updateMenuBar 656 416 850 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 155 8 0 0 114 1 0 0] 98 2 2464 560 1344 0 27 )! !
!WebApplicationServerShell class categoriesFor: #resource_Default_view!public!resources-views! !

