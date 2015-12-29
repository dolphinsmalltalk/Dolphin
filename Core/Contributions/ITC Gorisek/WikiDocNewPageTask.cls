"Filed out from Dolphin Smalltalk X6.1"!

WikiDocCopyPageTask subclass: #WikiDocNewPageTask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocNewPageTask guid: (GUID fromString: '{00E77082-ECD3-4494-A078-285E8DEC2046}')!
WikiDocNewPageTask comment: ''!
!WikiDocNewPageTask categoriesForClass!Unclassified! !
!WikiDocNewPageTask methodsFor!

getPageVersionBeingEdited
	| page pageVersion |
	page := application getOrCreatePage: pageId language: language.
	pageVersion := page getCurrentVersion.
	page pageName: 'WikiDoc.CreateNewPage' webTranslate.
	pageVersion 
		pageFormat: ((application configurationSettingsAt: 'application.defaultSyntax'
				ifAbsent: ['WikiMarkup']) asUppercase 
				= 'HTML' ifTrue: [#wikiDocPageFormatHTML] ifFalse: [#wikiDocPageFormatWikiMarkup]).
	pageToCopy isNil ifFalse: [pageVersion parentPage: pageToCopy parentPage].
	^pageVersion!

getTopNavigation
	^parentTopNavigation isNil 
		ifFalse: 
			[parentTopNavigation , (Array with: 'WikiDoc.CreateNewPage' webTranslate -> self taskURLPrefix)]! !
!WikiDocNewPageTask categoriesFor: #getPageVersionBeingEdited!public! !
!WikiDocNewPageTask categoriesFor: #getTopNavigation!public! !

