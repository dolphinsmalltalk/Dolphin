"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocPageVersionsTask
	instanceVariableNames: 'pageId'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocPageVersionsTask guid: (GUID fromString: '{8B3ECB83-5633-419B-95A3-527389E8BDB1}')!
WikiDocPageVersionsTask comment: ''!
!WikiDocPageVersionsTask categoriesForClass!Unclassified! !
!WikiDocPageVersionsTask methodsFor!

initializeForEditOn: pageVersion 
	pageId := pageVersion page pageName!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processShowVersion:on: #processLoadVersion:on:)
		on: stream
		withDefault: 'default'!

processDefault: request on: stream 
	| page |
	page := application getPage: pageId language: session language.
	page isNil 
		ifFalse: 
			[(self newCoder: stream) showPageVersionsList: page pageVersions
				currentVersion: page getCurrentVersion]!

processLoadVersion: request on: stream 
	| page newVersion currentVersion newReferences oldReferences |
	page := application getPage: pageId language: language.
	page isNil ifTrue: [^self processDefault: request on: stream].
	newVersion := page pageVersions 
				detect: [:each | (OmniBase currentTransaction getObjectID: each) index = (request integerAt: 'id')]
				ifNone: [].
	currentVersion := page getCurrentVersion.
	(newVersion isNil or: [newVersion isIdenticalTo: currentVersion]) 
		ifTrue: 
			[^(self newCoder: stream) showPageVersionsList: page pageVersions
				currentVersion: currentVersion].
	newReferences := (WikiDocPageParser new)
				generateHtmlFrom: newVersion contents
					for: newVersion
					on: (WriteStream on: String new)
					urlPrefix: ''
					application: application
					session: nil;
				referencedPages.

	"update references to page in all referenced page objects"
	oldReferences := (WikiDocPageParser new)
				generateHtmlFrom: currentVersion contents
					for: currentVersion
					on: (WriteStream on: String new)
					urlPrefix: ''
					application: application
					session: nil;
				referencedPages.
	self 
		updateReferencesFor: page
		oldReferences: oldReferences
		newReferences: newReferences
		pageLanguage: language.
	page setCurrentVersion: newVersion.
	(application pageTsToVersionIndexForLanguage: language) at: Timestamp now put: newVersion.
	OmniBase checkpoint.
	application resetTableOfContentsForLanguage: language.
	(self newCoder: stream) showPageVersionsList: page pageVersions currentVersion: newVersion!

processShowVersion: request on: stream 
	| page pageVersion |
	page := application getPage: pageId language: language.
	page isNil ifTrue: [^self processDefault: request on: stream].
	pageVersion := page pageVersions 
				detect: [:each | (OmniBase currentTransaction getObjectID: each) index = (request integerAt: 'id')]
				ifNone: [].
	(self newCoder: stream) showPageVersion: pageVersion! !
!WikiDocPageVersionsTask categoriesFor: #initializeForEditOn:!public! !
!WikiDocPageVersionsTask categoriesFor: #process:on:!public! !
!WikiDocPageVersionsTask categoriesFor: #processDefault:on:!public! !
!WikiDocPageVersionsTask categoriesFor: #processLoadVersion:on:!public! !
!WikiDocPageVersionsTask categoriesFor: #processShowVersion:on:!public! !

