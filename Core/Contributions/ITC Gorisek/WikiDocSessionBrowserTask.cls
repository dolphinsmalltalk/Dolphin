"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocSessionBrowserTask
	instanceVariableNames: 'wikiSession wikiSessionIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocSessionBrowserTask guid: (GUID fromString: '{FE7767A2-D9F9-49A3-80B3-FE7F2576137A}')!
WikiDocSessionBrowserTask comment: ''!
!WikiDocSessionBrowserTask categoriesForClass!Unclassified! !
!WikiDocSessionBrowserTask methodsFor!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processTimeline:on:)
		on: stream
		withDefault: #processDefault:on:!

processDefault: request on: stream 
	(self newCoder: stream) showWikiSessionEvents: wikiSession!

setDefaultToolbar
	| coll |
	coll := OrderedCollection new.
	coll
		add: (Array 
					with: 'Recent sessions' webTranslate
					with: nil
					with: true
					with: superTask taskURLPrefix , '?action=recentSessions&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Previous session' webTranslate
					with: 'previousObject'
					with: wikiSessionIndex > 1
					with: superTask taskURLPrefix , '?action=showSession&id=' 
							, (wikiSessionIndex - 1) asWebString , '&lang=' 
							, language);
		add: nil;
		add: (Array 
					with: 'Next session' webTranslate
					with: 'nextObject'
					with: true
					with: superTask taskURLPrefix , '?action=showSession&id=' 
							, (wikiSessionIndex + 1) asWebString , '&lang=' 
							, language);
		add: nil;
		add: (Array 
					with: 'Session timeline'
					with: nil
					with: true
					with: self taskURLPrefix , '?action=timeline&lang=' , language);
		add: nil.
	self defaultToolbar: coll!

wikiSession: anObject
	wikiSession := anObject!

wikiSessionIndex: anObject
	wikiSessionIndex := anObject! !
!WikiDocSessionBrowserTask categoriesFor: #process:on:!public! !
!WikiDocSessionBrowserTask categoriesFor: #processDefault:on:!public! !
!WikiDocSessionBrowserTask categoriesFor: #setDefaultToolbar!public! !
!WikiDocSessionBrowserTask categoriesFor: #wikiSession:!accessing!public! !
!WikiDocSessionBrowserTask categoriesFor: #wikiSessionIndex:!accessing!public! !

