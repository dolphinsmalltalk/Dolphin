"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocEditPageTask
	instanceVariableNames: 'pageId'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocEditPageTask guid: (GUID fromString: '{61AF4635-0A0F-4CAD-AC02-544EC77CA259}')!
WikiDocEditPageTask comment: ''!
!WikiDocEditPageTask categoriesForClass!Unclassified! !
!WikiDocEditPageTask methodsFor!

getPageVersionBeingEdited
	^(application getOrCreatePage: pageId language: language) getCurrentVersion!

getTopNavigation
	^parentTopNavigation isNil 
		ifFalse: [parentTopNavigation , (Array with: 'WikiDoc.EditPage' webTranslate -> self taskURLPrefix)]!

initializeForEditOn: pageVersion 
	pageId := pageVersion page pageName!

newCoder: stream 
	^(super newCoder: stream)
		defaultToolbar: defaultToolbar;
		topNavigation: self getTopNavigation;
		yourself!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processSave:on: #processPreview:on: #processGoBack:on: #processSetPageFormat:on:)
		on: stream
		withDefault: #processDefault:on:!

processDefault: request on: stream 
	(self newCoder: stream) 
		editPageVersionFormPage: self getPageVersionBeingEdited
		errors: nil
		isNewPage: pageId isNil
		previewContents: nil!

processGoBack: request on: stream 
	stream 
		redirectResponseTemporarilyTo: self sessionURLPrefix , '?page=' 
				, pageId asWebString webHttpUrlEncoded , '&lang=' 
				, language!

processPreview: request on: stream 
	^self 
		processSave: request
		on: stream
		isPreview: true
		doCommit: false!

processSave: request on: stream 
	^self 
		processSave: request
		on: stream
		isPreview: false
		doCommit: true!

processSave: request on: stream isPreview: previewBool doCommit: doCommit 
	"Private - Preview metoda je popolnoma enaka save, razen na koncu je ponoven prikaz forme s preview contents
	namesto save."

	| previousPageVersion page newVersion errors parser ws oldReferences newReferences indexer wikiSession mutex keywords |
	errors := LookupTable new.
	page := application getOrCreatePage: pageId language: language.
	previousPageVersion := page currentVersion.
	newVersion := page createNewVersion.
	pageId isNil 
		ifTrue: 
			[page pageName: (request stringAt: 'page').
			page pageName isNilOrEmpty 
				ifTrue: [errors at: 'page' put: 'asp.error.MandatoryEntry']
				ifFalse: 
					[(WikiDocPage isValidPageName: page pageName) 
						ifFalse: [errors at: 'page' put: 'WikiDoc.ErrorInvalidPageName']
						ifTrue: 
							[(application getPage: page pageName language: language) isNil 
								ifFalse: [errors at: 'page' put: 'WikiDoc.ErrorPageAlreadyExists']]]].
	newVersion
		pageFormat: (request symbolAt: 'pageFormat');
		contents: (request stringOrNilAt: 'pageContents');
		pageTitle: (request stringOrNilAt: 'pageTitle');
		parentPage: (request stringOrNilAt: 'parentPage');
		isLeafPage: (request booleanAt: 'isLeafPage');
		pagePosition: (request integerAt: 'pagePosition');
		tocNodeIcon: (request stringOrNilAt: 'nodeIcon');
		pageFormat: (request symbolAt: 'pageFormat');
		dateFrom: (request dateAt: 'dateFrom');
		dateTo: (request dateAt: 'dateTo');
		keywords: ((keywords := request stringOrNilAt: 'keywords') isNilOrEmpty 
					ifFalse: 
						[((keywords itcSubStrings: $,) collect: [:each | each trimBlanks]) reject: [:each | each isEmpty]]).
	newVersion contents isNilOrEmpty 
		ifTrue: [errors at: 'pageContents' put: 'asp.error.MandatoryEntry']
		ifFalse: 
			[ws := WriteStream on: (String new: 10240).
			
			[parser := WikiDocPageParser new.
			parser 
				generateHtmlFrom: newVersion contents
				for: newVersion
				on: ws
				urlPrefix: ''
				application: application
				session: nil] 
					on: Error
					do: 
						[:ex | 
						errors at: 'pageContents'
							put: 'WikiDoc.ErrorParsingPageContents' webTranslate , '<br />(' , ex description asWebString , ')']].
	errors isEmpty 
		ifTrue: 
			[page pageTitle: (newVersion pageTitle isNilOrEmpty 
						ifTrue: [parser pageTitle]
						ifFalse: [newVersion pageTitle]).
			(page pageTitle isNilOrEmpty and: [page currentVersion pageFormat == #wikiDocPageFormatWikiMarkup]) 
				ifTrue: [errors at: 'pageContents' put: 'WikiDoc.ErrorPageHasNoTitle']].
	(previewBool or: [doCommit not or: [errors notEmpty]]) 
		ifTrue: 
			[^(self newCoder: stream) 
				editPageVersionFormPage: newVersion
				errors: ((doCommit or: [previewBool]) ifTrue: [errors])
				isNewPage: pageId isNil
				previewContents: ((previewBool and: [errors isEmpty]) ifTrue: [newVersion contents])].
	pageId isNil 
		ifTrue: 
			[((application pageIndexForLanguage: language) lockKey: page pageName) 
				ifFalse: [self error: 'Can not lock dictionary key'].
			((application pageIndexForLanguage: language) at: page pageName) isNil 
				ifFalse: [self error: 'Can not overwrite existing page'].
			(application pageIndexForLanguage: language) at: page pageName put: page]
		ifFalse: [page markDirty].
	newVersion makePersistent.
	"update references to page in all referenced page objects"
	newReferences := parser referencedPages.
	previousPageVersion isNil 
		ifFalse: 
			[
			[oldReferences := (WikiDocPageParser new)
						generateHtmlFrom: previousPageVersion contents
							for: previousPageVersion
							on: (WriteStream on: String new)
							urlPrefix: ''
							application: application
							session: nil;
						referencedPages] 
					on: Error
					do: [:ex | ]].
	self 
		updateReferencesFor: page
		oldReferences: oldReferences
		newReferences: newReferences
		pageLanguage: language.
	(session sessionData at: #sessionIndex) isNil 
		ifFalse: 
			[wikiSession := (OmniBase root at: application sessionsDictionaryKey) 
						at: (session sessionData at: #sessionIndex)].
	newVersion
		editTS: Timestamp now;
		editIP: request clientIP;
		editSession: wikiSession;
		editUserAgent: request userAgent.
	(application pageTsToVersionIndexForLanguage: language) at: newVersion editTS put: newVersion.
	OmniBase checkpoint.
	indexer := WikiDocFullTextSearchIndex new application: application.
	previousPageVersion isNil 
		ifFalse: 
			[indexer 
				updateFullTextSearchIndexForPageVersion: previousPageVersion
				indexDict: (application fullTextSearchIndexFor: language)
				removeFlag: true].
	indexer 
		updateFullTextSearchIndexForPageVersion: page currentVersion
		indexDict: (application fullTextSearchIndexFor: language)
		removeFlag: false.
	OmniBase commit.
	"record page edit record in the server log"
	(mutex := session sessionData at: #statMutex ifAbsent: []) isNil 
		ifFalse: 
			[mutex critical: 
					[((session sessionData at: #pageEdits) at: language , '\\' , page pageName
						ifAbsentPut: [OrderedCollection new]) add: Timestamp now]].

	"---"
	application resetTableOfContentsForLanguage: language.
	stream 
		redirectReponseInTopFrameTo: self sessionURLPrefix , '?action=' 
				, #processReload:on: webAsActionString , '&page=' 
				, page pageName webHttpUrlEncoded , '&lang=' 
				, language!

processSetPageFormat: request on: stream 
	^self 
		processSave: request
		on: stream
		isPreview: false
		doCommit: false! !
!WikiDocEditPageTask categoriesFor: #getPageVersionBeingEdited!public! !
!WikiDocEditPageTask categoriesFor: #getTopNavigation!public! !
!WikiDocEditPageTask categoriesFor: #initializeForEditOn:!public! !
!WikiDocEditPageTask categoriesFor: #newCoder:!public! !
!WikiDocEditPageTask categoriesFor: #process:on:!public! !
!WikiDocEditPageTask categoriesFor: #processDefault:on:!public! !
!WikiDocEditPageTask categoriesFor: #processGoBack:on:!public! !
!WikiDocEditPageTask categoriesFor: #processPreview:on:!public! !
!WikiDocEditPageTask categoriesFor: #processSave:on:!public! !
!WikiDocEditPageTask categoriesFor: #processSave:on:isPreview:doCommit:!private! !
!WikiDocEditPageTask categoriesFor: #processSetPageFormat:on:!public! !

