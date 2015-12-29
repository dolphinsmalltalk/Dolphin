"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WikiDocIndexServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocIndexServlet guid: (GUID fromString: '{56131ED5-D06A-430E-841B-96F12F74A7A8}')!
WikiDocIndexServlet comment: ''!
!WikiDocIndexServlet categoriesForClass!Unclassified! !
!WikiDocIndexServlet methodsFor!

addChildrenOf: node to: coll 
	| page |
	node children isNilOrEmpty 
		ifFalse: 
			[node children do: 
					[:eachNode | 
					(page := application getPage: eachNode pageName language: eachNode languageName) isNil 
						ifFalse: [coll add: page getCurrentVersion].
					self addChildrenOf: eachNode to: coll]]!

getApplicationAdministrationToolbar
	| coll language |
	language := Processor activeProcess language.
	coll := OrderedCollection new.
	coll
		add: (Array 
					with: 'Recent sessions' webTranslate
					with: nil
					with: true
					with: self urlPrefix , '?action=recentSessions&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Reorg DB'
					with: nil
					with: true
					with: self urlPrefix , '?action=reorgDB&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Backup DB' webTranslate
					with: nil
					with: true
					with: self urlPrefix , '?action=backupDB&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Rebuild full text search indexes' webTranslate
					with: nil
					with: true
					with: self urlPrefix , '?action=rebuildFullTextSearchIndex&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Shutdown' webTranslate
					with: nil
					with: true
					with: self urlPrefix , '?action=shutdown&lang=' , language);
		add: nil.
	^coll!

getNavigationFor: pageId 
	| tocNode navigation title |
	(tocNode := application getTOCNodeForPage: pageId) isNil 
		ifFalse: 
			[navigation := OrderedCollection new.
			
			[title := tocNode title.
			title size > 30 ifTrue: [title := (title copyFrom: 1 to: 30) , '...'].
			navigation addFirst: title 
						-> (self urlPrefix , '?page=' , tocNode pageName webHttpUrlEncoded , '&lang=' , tocNode languageName).
			tocNode parentNode isNil] 
					whileFalse: [tocNode := tocNode parentNode]].
	^navigation!

newCoder: stream 
	^(application basicNewCoder: stream)
		urlPrefix: '/' , application urlPrefix , '/' , self servletName;
		sessionURLPrefix: '/' , application urlPrefix , '/' , self servletName;
		session: self webSession!

persistentTaskForApplicationAdministration
	| session |
	session := self webSession.
	^(session user notNil and: [session user canDo: #serverAdmin]) 
		ifTrue: 
			[session sessionData at: #applicationAdministrationTask
				ifAbsentPut: 
					[(session addPersistentTask: WikiDocApplicationAdministrationTask new)
						defaultToolbar: self getApplicationAdministrationToolbar;
						yourself]]!

process: request on: stream 
	| t session lang user selectorsForPlugins |
	session := self checkOrSetDefaultClientIdCookieAndSessionFor: request on: stream.
	(('*google*search*' match: request referer) or: ['*najdi*search*' match: request referer]) 
		ifTrue: [session sessionData at: #requestComingFromSearchEngine put: true].

	"set default language for processing the request"
	(application applicationLanguages includes: (lang := request stringOrNilAt: 'lang')) 
		ifTrue: [Processor activeProcess language: lang].
	selectorsForPlugins := application linksForPlugIns isNilOrEmpty 
				ifTrue: [#()]
				ifFalse: [application linksForPlugIns collect: [:each | each at: 1]].
	t := application newTransaction.
	
	[
	[session isNil ifFalse: [user := session user].
	((application configurationSettingsAt: 'application.loginForPreviewRequired') = 'true' 
		and: [user isNil]) ifTrue: [^self processLogin: request on: stream].
	self 
		dispatch: request
		using: self supportedActions , selectorsForPlugins
		on: stream
		withDefault: #processDefault:on:] 
			evaluateIn: t] 
			ensure: [t abort]!

processAdvanceSearch: request on: stream 
	(self newCoder: stream)
		defaultToolbar: (self toolbarFor: nil);
		advanceSearchPage: ItcLookupTable new!

processApplicationAdministration: request on: stream 
	| task |
	(task := self persistentTaskForApplicationAdministration) isNil 
		ifFalse: [task processDefault: request on: stream]
		ifTrue: [self processDefault: request on: stream]!

processApplicationAdministrationCommandPrompt: request on: stream 
	| task |
	(task := self persistentTaskForApplicationAdministration) isNil 
		ifFalse: [task processCommandLine: request on: stream]
		ifTrue: [self processDefault: request on: stream]!

processApplicationAdministrationDownloadServerLog: request on: stream 
	| task |
	(task := self persistentTaskForApplicationAdministration) isNil 
		ifFalse: [task processDownloadServerLog: request on: stream]
		ifTrue: [self processDefault: request on: stream]!

processApplicationAdministrationErrorLog: request on: stream 
	| task |
	(task := self persistentTaskForApplicationAdministration) isNil 
		ifFalse: [task processErrorLog: request on: stream]
		ifTrue: [self processDefault: request on: stream]!

processApplicationAdministrationLiveUpdate: request on: stream 
	| task |
	(task := self persistentTaskForApplicationAdministration) isNil 
		ifFalse: [task processLiveUpdate: request on: stream]
		ifTrue: [self processDefault: request on: stream]!

processApplicationAdministrationStatistics: request on: stream 
	| task |
	(task := self persistentTaskForApplicationAdministration) isNil 
		ifFalse: [task processShowServerStatistics: request on: stream]
		ifTrue: [self processDefault: request on: stream]!

processChangePasswordFor: request on: stream 
	| session toolbar language pageId page pageVersion |
	language := Processor activeProcess language.
	(application omejitevStevilaStrani notNil 
		and: [(application pageIndexForLanguage: language) size > application omejitevStevilaStrani]) 
			ifTrue: [^self showFreeVersionExpiredResponseOn: stream].
	session := self webSession.
	pageId := request stringOrNilAt: 'page'.
	page := application getPage: pageId.
	page isNil ifFalse: [pageVersion := page getCurrentVersion].
	toolbar := self toolbarFor: pageVersion.
	session user isNil 
		ifTrue: [self processDefault: request on: stream]
		ifFalse: 
			[(session addTask: WikiDocChangePasswordTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: (self getNavigationFor: pageId);
				processDefault: request on: stream]!

processCopy: request on: stream 
	| session toolbar language pageId page pageVersion |
	language := Processor activeProcess language.
	(application omejitevStevilaStrani notNil 
		and: [(application pageIndexForLanguage: language) size > application omejitevStevilaStrani]) 
			ifTrue: [^self showFreeVersionExpiredResponseOn: stream].
	session := self webSession.
	pageId := request stringOrNilAt: 'page'.
	page := application getPage: pageId.
	page isNil ifTrue: [^self processCreateNewPage: request on: stream].
	pageVersion := page getCurrentVersion.
	toolbar := self toolbarFor: pageVersion.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				onLogin: 
						[:aStream | 
						Processor activeProcess language: language.
						(session addTask: WikiDocCopyPageTask new)
							pageToCopy: pageVersion;
							defaultToolbar: toolbar;
							parentTopNavigation: (self getNavigationFor: pageId);
							processDefault: request on: aStream];
				processDefault: request on: stream]
		ifFalse: 
			[(session addTask: WikiDocCopyPageTask new)
				pageToCopy: pageVersion;
				defaultToolbar: toolbar;
				parentTopNavigation: (self getNavigationFor: pageId);
				processDefault: request on: stream]!

processCreateNewPage: request on: stream 
	| session toolbar language pageId page pageVersion |
	language := Processor activeProcess language.
	(application omejitevStevilaStrani notNil 
		and: [(application pageIndexForLanguage: language) size > application omejitevStevilaStrani]) 
			ifTrue: [^self showFreeVersionExpiredResponseOn: stream].
	session := self webSession.
	pageId := request stringOrNilAt: 'page'.
	page := application getPage: pageId.
	page isNil ifFalse: [pageVersion := page getCurrentVersion].
	toolbar := self toolbarFor: pageVersion.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				onLogin: 
						[:aStream | 
						Processor activeProcess language: language.
						(session addTask: WikiDocNewPageTask new)
							pageToCopy: pageVersion;
							defaultToolbar: toolbar;
							parentTopNavigation: (self getNavigationFor: pageId);
							processDefault: request on: aStream];
				processDefault: request on: stream]
		ifFalse: 
			[(session addTask: WikiDocNewPageTask new)
				pageToCopy: pageVersion;
				defaultToolbar: toolbar;
				parentTopNavigation: (self getNavigationFor: pageId);
				processDefault: request on: stream]!

processDefault: request on: stream 
	| pageId page pageVersion session user |
	session := self webSession.
	session isNil ifFalse: [user := session user].
	((application configurationSettingsAt: 'application.loginForPreviewRequired') = 'true' 
		and: [user isNil]) ifTrue: [^self processLogin: request on: stream].
	(request action isNilOrEmpty and: [(request formFieldNames includes: 'page') not]) 
		ifTrue: 
			[^request isIndexingRobotOrWebSpider 
				ifTrue: [self sendCompleteTocPageForWebSpidersOn: stream]
				ifFalse: [self processReload: request on: stream]].
	pageId := request stringAt: 'page'.
	(page := application getPage: pageId) isNil 
		ifFalse: [pageVersion := page getCurrentVersion]
		ifTrue: 
			[(application getTableOfContentsFor: Processor activeProcess language) isNilOrEmpty 
				ifFalse: 
					[page := application getOrCreatePage: application defaultPageName.
					pageVersion := page getCurrentVersion]
				ifTrue: 
					[application applicationLanguages do: 
							[:eachLanguage | 
							page isNil 
								ifTrue: 
									[(application getTableOfContentsFor: eachLanguage) isNilOrEmpty 
										ifFalse: 
											[page := application getOrCreatePage: application defaultPageName.
											pageVersion := page getCurrentVersion.
											Processor activeProcess language: eachLanguage]]]].
			page isNil 
				ifTrue: 
					[page := WikiDocPage new.
					page pageName: 'Welcome'.
					pageVersion := page getCurrentVersion.
					pageVersion contents: application initialWikiWelcomePage]].
	(self newCoder: stream)
		defaultToolbar: (self toolbarFor: pageVersion);
		topNavigation: (self getNavigationFor: page pageName);
		showPageVersion: pageVersion!

processEdit: request on: stream 
	| pageId session toolbar pageVersion page language |
	pageId := (request formFieldNames includes: 'page') ifTrue: [request stringAt: 'page'].
	language := Processor activeProcess language.
	page := application getPage: pageId language: language.
	page isNil ifTrue: [^self processDefault: request on: stream].
	(application omejitevStevilaStrani notNil and: 
			[(application pageIndexForLanguage: language) size > application omejitevStevilaStrani 
				and: [page pageVersions isNilOrEmpty]]) 
		ifTrue: [^self showFreeVersionExpiredResponseOn: stream].
	pageVersion := page getCurrentVersion.
	toolbar := self toolbarFor: pageVersion.
	session := self webSession.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: (self getNavigationFor: pageId) 
							, (Array with: 'WikiDoc.EditPage' webTranslate 
											-> (self urlPrefix , '?page=' , pageId webHttpUrlEncoded , '&action=edit&lang=' , language));
				onLogin: 
						[:aStream | 
						Processor activeProcess language: language.
						(session addTask: WikiDocEditPageTask new)
							defaultToolbar: toolbar;
							parentTopNavigation: (self getNavigationFor: pageId);
							initializeForEditOn: pageVersion;
							processDefault: request on: aStream];
				processDefault: request on: stream]
		ifFalse: 
			[(session addTask: WikiDocEditPageTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: (self getNavigationFor: pageId);
				initializeForEditOn: pageVersion;
				processDefault: request on: stream]!

processLogin: request on: stream 
	| pageId session toolbar pageVersion page language coll |
	pageId := request stringOrNilAt: 'page'.
	language := Processor activeProcess language.
	page := application getPage: pageId language: language.
	page isNil ifFalse: [pageVersion := page getCurrentVersion].
	toolbar := self toolbarFor: pageVersion.
	session := self webSession.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: ((coll := self getNavigationFor: pageId) isNil 
							ifFalse: 
								[coll 
									, (Array with: 'WikiDoc.Login' webTranslate 
													-> (self urlPrefix , '?page=' , pageId webHttpUrlEncoded , '&action=login&lang=' 
															, language))]);
				onLogin: 
						[:aStream | 
						aStream 
							redirectReponseInTopFrameTo: self urlPrefix , '?action=reload&page=' 
									, pageId asWebString webHttpUrlEncoded , '&lang=' 
									, language];
				processDefault: request on: stream]
		ifFalse: [self processDefault: request on: stream]!

processLogout: request on: stream 
	| pageId session language |
	session := self webSession.
	session user isNil ifTrue: [^self processDefault: request on: stream].
	pageId := request stringOrNilAt: 'page'.
	language := Processor activeProcess language.
	application removeSession: session.
	stream 
		redirectReponseInTopFrameTo: self urlPrefix , '?action=reload&page=' 
				, pageId asWebString webHttpUrlEncoded , '&lang=' 
				, language!

processNextPage: request on: stream 
	| pageId tocNode page pageVersion |
	pageId := request stringOrNilAt: 'page'.
	(request action isNilOrEmpty and: [(request formFieldNames includes: 'page') not]) 
		ifTrue: [^self processReload: request on: stream].
	(tocNode := application getTOCNodeForPage: pageId) notNil 
		ifTrue: 
			[tocNode := tocNode getNextNode.
			tocNode isNil ifFalse: [page := application getPage: tocNode pageName]].
	page isNil ifTrue: [^self processDefault: request on: stream].
	pageVersion := page getCurrentVersion.
	(self newCoder: stream)
		defaultToolbar: (self toolbarFor: pageVersion);
		topNavigation: (self getNavigationFor: page pageName);
		showPageVersion: pageVersion!

processPreviousPage: request on: stream 
	| pageId tocNode page pageVersion |
	pageId := request stringOrNilAt: 'page'.
	(request action isNilOrEmpty and: [(request formFieldNames includes: 'page') not]) 
		ifTrue: [^self processReload: request on: stream].
	(tocNode := application getTOCNodeForPage: pageId) notNil 
		ifTrue: 
			[tocNode := tocNode getPreviousNode.
			tocNode isNil ifFalse: [page := application getPage: tocNode pageName]].
	page isNil ifTrue: [^self processDefault: request on: stream].
	pageVersion := page getCurrentVersion.
	(self newCoder: stream)
		defaultToolbar: (self toolbarFor: pageVersion);
		topNavigation: (self getNavigationFor: page pageName);
		showPageVersion: pageVersion!

processPrint: request on: stream 
	| pageId page |
	(request referer isNilOrEmpty not and: ['*.google.*/search?*' match: request referer]) 
		ifTrue: [^self processDefault: request on: stream].
	pageId := request stringOrNilAt: 'page'.
	(page := application getPage: pageId) isNil ifTrue: [^stream fileNotFoundResponse].
	(self newCoder: stream) showPageVersionForPrint: page getCurrentVersion printChapterBool: false!

processPrintPages: request on: stream 
	| pageId page |
	request isIndexingRobotOrWebSpider 
		ifTrue: 
			["makes no sense for web spiders to print everything, chapter printing is disabled"
			^self processPrint: request on: stream].
	(request referer isNilOrEmpty not and: ['*.google.*/search?*' match: request referer]) 
		ifTrue: [^self processDefault: request on: stream].
	pageId := request stringOrNilAt: 'page'.
	(page := application getPage: pageId) isNil ifTrue: [^stream fileNotFoundResponse].
	(self newCoder: stream) showPageVersionForPrint: page getCurrentVersion printChapterBool: true!

processRecentChanges: request on: stream 
	| lastDate lastTime ts index coll asoc language |
	request isIndexingRobotOrWebSpider 
		ifTrue: [^(self newCoder: stream) errorPage: 'Invalid user agent for this request'].
	language := Processor activeProcess language.
	lastDate := request dateAt: 'lastDate'.
	lastTime := request timeAt: 'lastTime'.
	(lastDate isNil or: [lastTime isNil]) ifFalse: [ts := Timestamp date: lastDate time: lastTime].
	index := application pageTsToVersionIndexForLanguage: language.
	coll := OrderedCollection new.
	ts isNil 
		ifTrue: [asoc := index getLast]
		ifFalse: 
			[asoc := index
						goTo: ts;
						getPrevious].
	[asoc isNil or: [coll size >= 20]] whileFalse: 
			[(coll isEmpty or: 
					[coll last editTS isNil or: 
							[(coll last page isIdenticalTo: asoc value page) not 
								or: [(asoc value editTS totalSeconds - coll last editTS totalSeconds) abs > 3600]]]) 
				ifTrue: [coll add: asoc value].
			asoc := index getPrevious].
	(self newCoder: stream)
		defaultToolbar: (self toolbarFor: nil);
		topNavigation: (Array with: 'WikiDoc.RecentChanges' webTranslate 
							-> (self urlPrefix , '?action=recentChanges&lang=' , language));
		showRecentChangesList: coll!

processReload: request on: stream 
	| pageId |
	pageId := request stringAt: 'page'.
	self 
		reloadResponseForPage: pageId
		action: nil
		on: stream
		request: request!

processRemovePage: request on: stream 
	| pageId session toolbar pageVersion page topNavigation language |
	language := Processor activeProcess language.
	(pageId := request stringOrNilAt: 'page') isNil 
		ifTrue: [(request formFieldNames includes: 'page') ifTrue: [pageId := '']].
	session := self webSession.
	page := application getPage: pageId.
	page isNil ifTrue: [^self processDefault: request on: stream].
	pageVersion := page getCurrentVersion.
	toolbar := self toolbarFor: pageVersion.
	topNavigation := self getNavigationFor: pageId.
	topNavigation isNilOrEmpty 
		ifFalse: 
			[topNavigation := topNavigation 
						, (Array with: 'WikiDoc.RemovePage' webTranslate 
										-> (self urlPrefix , '?page=' , pageId webHttpUrlEncoded , '&action=removePage&lang=' , language))].
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: topNavigation;
				onLogin: 
						[:aStream | 
						Processor activeProcess language: language.
						(self newCoder: aStream)
							defaultToolbar: toolbar;
							topNavigation: topNavigation;
							wikiPageConfirmRemovePage: pageVersion];
				processDefault: request on: stream]
		ifFalse: 
			[(self newCoder: stream)
				defaultToolbar: toolbar;
				topNavigation: topNavigation;
				wikiPageConfirmRemovePage: pageVersion]!

processRemovePageConfirm: request on: stream 
	| pageId session page language |
	(pageId := request stringOrNilAt: 'page') isNil 
		ifTrue: [(request formFieldNames includes: 'page') ifTrue: [pageId := '']].
	language := request stringAt: 'lang'.
	session := self webSession.
	page := application getPage: pageId language: language.
	(page isNil or: [session user isNil]) ifTrue: [^self processDefault: request on: stream].
	(application pageIndexForLanguage: language) removeKey: pageId.
	(OmniBase root at: language , '.Page.deletedPages')
		add: page;
		markDirty.
	(WikiDocFullTextSearchIndex new)
		application: application;
		updateFullTextSearchIndexForPageVersion: page currentVersion
			indexDict: (application fullTextSearchIndexFor: language)
			removeFlag: true.
	OmniBase commit.
	application resetTableOfContentsForLanguage: language.
	stream redirectReponseInTopFrameTo: self urlPrefix , '?action=reload&lang=' 
				, Processor activeProcess language!

processSearch: request on: stream 
	| searchString results searchFields lang languages searchChapter searchPagesRange session mutex |
	request isIndexingRobotOrWebSpider 
		ifTrue: [^(self newCoder: stream) errorPage: 'Invalid user agent for full text search'].
	session := self webSession.
	searchFields := LookupTable new.
	searchString := request stringAt: 'q'.
	searchFields at: 'q' put: searchString.
	lang := request stringAt: 'lang'.
	(application applicationLanguages includes: lang) 
		ifTrue: [languages := Array with: lang]
		ifFalse: [languages := application applicationLanguages].
	searchChapter := request stringOrNilAt: 'searchChapter'.
	
	[searchChapter isNilOrEmpty 
		ifFalse: 
			["glede na izbrano poglavje zbere imena page-ov, po katerih se isce, da v rezultatih ne kaze strani iz drugih poglavij"
			searchPagesRange := OrderedCollection new.
			languages do: 
					[:eachLang | 
					| tocNode |
					tocNode := application getTOCNodeForPage: searchChapter language: eachLang.
					tocNode isNil ifFalse: [searchPagesRange add: tocNode]]].
	results := (WikiDocFullTextSearchIndex new)
				application: application;
				findPagesMatching: searchString
					languages: languages
					maxResults: 200
					parentNodes: searchPagesRange.
	(mutex := session sessionData at: #statMutex ifAbsent: []) isNil 
		ifFalse: 
			["record user search"
			mutex critical: 
					[((session sessionData at: #searches) at: searchString ifAbsentPut: [OrderedCollection new]) 
						add: (Array 
								with: Timestamp now
								with: results size
								with: searchChapter)]].
	"---"
	results isNilOrEmpty 
		ifTrue: 
			[(self newCoder: stream)
				defaultToolbar: (self toolbarFor: nil);
				wikiDocNoSearchResultsPage: searchFields]
		ifFalse: 
			[(session addTask: WikiDocSearchResultsTask new)
				setTransaction: OmniBase currentTransaction;
				defaultToolbar: (self toolbarFor: nil);
				searchResults: results;
				searchFields: searchFields;
				processDefault: request on: stream]] 
			evaluateIn: application newReadOnlyTransaction!

processServerManagement: request on: stream 
	| session |
	session := self webSession.
	(session user notNil and: [session user canDo: #serverAdmin]) 
		ifFalse: [self processDefault: request on: stream]
		ifTrue: [(session addTask: WikiDocServerManagementTask new) processDefault: request on: stream]!

processSessionExpired: request on: stream 
	| pageId |
	pageId := request stringAt: 'page'.
	self 
		reloadResponseForPage: ''
		action: 'login'
		on: stream
		request: request!

processShowPageVersions: request on: stream 
	| pageId session toolbar pageVersion page language |
	pageId := request stringOrNilAt: 'page'.
	language := Processor activeProcess language.
	page := application getPage: pageId language: language.
	page isNil ifTrue: [^self processDefault: request on: stream].
	pageVersion := page getCurrentVersion.
	toolbar := self toolbarFor: pageVersion.
	session := self webSession.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: (self getNavigationFor: pageId) 
							, (Array with: 'WikiDoc.ShowVersions' webTranslate 
											-> (self urlPrefix , '?page=' , pageId webHttpUrlEncoded , '&action=' 
													, #processShowPageVersions:on: webAsActionString , '&lang=' 
													, language));
				onLogin: 
						[:aStream | 
						Processor activeProcess language: language.
						(session addTask: WikiDocPageVersionsTask new)
							defaultToolbar: toolbar;
							parentTopNavigation: (self getNavigationFor: pageId);
							initializeForEditOn: pageVersion;
							processDefault: request on: aStream];
				processDefault: request on: stream]
		ifFalse: 
			[(session addTask: WikiDocPageVersionsTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: (self getNavigationFor: pageId);
				initializeForEditOn: pageVersion;
				processDefault: request on: stream]!

processTableOfContents: request on: stream 
	| completeToc selectedPage |
	selectedPage := request stringOrNilAt: 'page'.
	completeToc := application getCompleteTableOfContentsFor: Processor activeProcess language.
	(self newCoder: stream)
		baseTarget: 'contentsFrame';
		styleLinks: nil;
		style: application cssStyleTableOfContents;
		showTableOfContents: (completeToc at: 1)
			indexToNodeDict: (completeToc at: 2)
			numberOfNodes: (completeToc at: 4)
			selectedNode: (selectedPage isNilOrEmpty 
					ifFalse: [(completeToc at: 3) at: selectedPage ifAbsent: []])!

processTocSearchForm: request on: stream 
	(self newCoder: stream)
		baseTarget: 'contentsFrame';
		styleLinks: nil;
		style: application cssStyleTableOfContents;
		showTableOfContentsSearchForm: nil!

processTopReferers: request on: stream 
	| session |
	session := self webSession.
	(session user notNil and: [session user canDo: #userAdmin]) 
		ifFalse: [self processDefault: request on: stream]
		ifTrue: 
			[(session sessionData at: WikiDocTopReferersStatisticTask
				ifAbsentPut: [session addPersistentTask: WikiDocTopReferersStatisticTask new]) 
					processDefault: request
					on: stream]!

processUploadedFiles: request on: stream 
	| session |
	session := self webSession.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				onLogin: [:aStream | (session addTask: WikiDocUploadedFilesOverviewTask new) processDefault: request on: aStream];
				processDefault: request on: stream]
		ifFalse: [(session addTask: WikiDocUploadedFilesOverviewTask new) processDefault: request on: stream]!

processUploadFile: request on: stream 
	| pageId session toolbar pageVersion page parentTopNavigation fileName |
	(fileName := request stringOrNilAt: 'id') isNilOrEmpty 
		ifTrue: [^self processDefault: request on: stream].
	pageId := request stringOrNilAt: 'page'.
	session := self webSession.
	page := application getPage: pageId language: session language.
	page isNil 
		ifFalse: 
			[parentTopNavigation := (self getNavigationFor: pageId) 
						, (Array with: 'WikiDoc.UploadFile' webTranslate 
										-> (self urlPrefix , '?page=' , pageId webHttpUrlEncoded , '&action=uploadFile&id=' 
												, fileName webHttpUrlEncoded) webHtmlEncodedForForm).
			pageVersion := page getCurrentVersion].
	toolbar := self toolbarFor: pageVersion.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: parentTopNavigation;
				onLogin: 
						[:aStream | 
						(session addTask: WikiDocUploadFileTask new)
							defaultToolbar: toolbar;
							parentTopNavigation: parentTopNavigation;
							fileName: fileName;
							processDefault: request on: aStream];
				processDefault: request on: stream]
		ifFalse: 
			[(session addTask: WikiDocUploadFileTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: parentTopNavigation;
				fileName: fileName;
				processDefault: request on: stream]!

processUploadImage: request on: stream 
	| pageId session toolbar pageVersion page parentTopNavigation imageName |
	(imageName := request stringOrNilAt: 'id') isNilOrEmpty 
		ifTrue: [^self processDefault: request on: stream].
	pageId := request stringOrNilAt: 'page'.
	session := self webSession.
	page := application getPage: pageId language: session language.
	page isNil 
		ifFalse: 
			[parentTopNavigation := (self getNavigationFor: pageId) 
						, (Array with: 'WikiDoc.UploadImage' webTranslate 
										-> (self urlPrefix , '?page=' , pageId webHttpUrlEncoded , '&action=uploadImage&id=' 
												, imageName webHttpUrlEncoded)).
			pageVersion := page getCurrentVersion].
	toolbar := self toolbarFor: pageVersion.
	session user isNil 
		ifTrue: 
			[(session addTask: WikiDocLoginTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: parentTopNavigation;
				onLogin: 
						[:aStream | 
						(session addTask: WikiDocUploadImageTask new)
							defaultToolbar: toolbar;
							parentTopNavigation: parentTopNavigation;
							imageName: imageName;
							processDefault: request on: aStream];
				processDefault: request on: stream]
		ifFalse: 
			[(session addTask: WikiDocUploadImageTask new)
				defaultToolbar: toolbar;
				parentTopNavigation: parentTopNavigation;
				imageName: imageName;
				processDefault: request on: stream]!

processUserManagement: request on: stream 
	| session |
	session := self webSession.
	(session user notNil and: [session user canDo: #userAdmin]) 
		ifFalse: [self processDefault: request on: stream]
		ifTrue: [(session addTask: WikiDocUserOverviewTask new) processDefault: request on: stream]!

reloadResponseForPage: pageId action: action on: stream request: request 
	| language cookie |
	language := Processor activeProcess language.
	cookie := self webSession clientCookie.
	stream 
		nextPutAll: '<html><head>
<title>' , application title , '</title>' 
				, (application defaultCodePage isNilOrEmpty 
						ifTrue: ['']
						ifFalse: 
							['
<meta http-equiv="Content-Type" content="text/html; charset=' , application defaultCodePage 
								, '">']) 
					, '
</head>
	<frameset cols="216,*" ' 
					, (request isMozilla ifTrue: ['border="4"'] ifFalse: ['border="1" frameborder="1" framespacing="6"']) 
					, ' topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<frameset rows="80,*" border="0" frameborder="0" framespacing="0" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<frame src="' 
					, self urlPrefix , '?action=tocSearchForm&_cc=' 
				, cookie webHttpUrlEncoded , '&lang=' 
				, language 
					, '" name="tocSearchFormFrame" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="0" border="1" scrolling="no"></frame>
  		<frame src="' 
					, self urlPrefix , '?action=tableOfContents&_cc=' 
				, cookie webHttpUrlEncoded , '&page=' 
				, pageId webHttpUrlEncoded , '&lang=' 
				, language 
					, '" name="tocFrame" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="1" border="1"></frame></frameset>
			<frame src="' 
					, self urlPrefix , '?' 
				, (action isNil ifTrue: [''] ifFalse: ['action=' , action , '&']) , 'page=' 
				, pageId webHttpUrlEncoded , '&_cc=' 
				, cookie webHttpUrlEncoded , '&lang=' 
				, language 
					, '" name="contentsFrame" frameborder="no" border="0" bordercolor="#6699CC"></frame>
	</frameset>
<body>
<h1>WikiDoc - the documentation wiki</h1>
<p>WikiDoc is an on-line collaboration system for writing hierachical documentation (user manuals, intranets, process documentation, references, ...). It comes in a form of a stand-alone wiki system. Download, install and run. And you are ready to write on-line documentation or even host a web page using a wiki.</p>
</body>
</html>'!

sendCompleteTocPageForWebSpidersOn: stream 
	"For web spiders send TOC page with ALL nodes and without using frames."

	| completeToc |
	completeToc := application getCompleteTableOfContentsFor: Processor activeProcess language.
	(self newCoder: stream)
		styleLinks: nil;
		style: application cssStyleTableOfContents;
		showTableOfContents: (completeToc at: 1)
			indexToNodeDict: (completeToc at: 2)
			numberOfNodes: (completeToc at: 4)
			selectedNode: nil!

showFreeVersionExpiredResponseOn: stream 
	| page pageVersion |
	page := WikiDocPage new.
	page pageName: 'FREE VERSION limitation exceeded'.
	pageVersion := page getCurrentVersion.
	pageVersion contents: application trialPeriodExpiredWikiPage.
	(self newCoder: stream)
		defaultToolbar: (self toolbarFor: pageVersion);
		topNavigation: (self getNavigationFor: page pageName);
		showPageVersion: pageVersion!

supportedActions
	^#(#processDefault:on: #processEdit:on: #processReload:on: #processTableOfContents:on: #processTocSearchForm:on: #processCreateNewPage:on: #processUploadImage:on: #processUploadFile:on: #processPreviousPage:on: #processNextPage:on: #processRemovePage:on: #processRemovePageConfirm:on: #processRecentChanges:on: #processShowPageVersions:on: #processPrint:on: #processPrintPages:on: #processSearch:on: #processUserManagement:on: #processServerManagement:on: #processLogin:on: #processSessionExpired:on: #processLogout:on: #processAdvanceSearch:on: #processCopy:on: #processChangePassword:on: #processApplicationAdministration:on: #processApplicationAdministrationErrorLog:on: #processApplicationAdministrationStatistics:on: #processApplicationAdministrationLiveUpdate:on: #processApplicationAdministrationDownloadServerLog:on: #processApplicationAdministrationCommandPrompt:on: #processChangePasswordFor:on: #processUploadedFiles:on: #processTopReferers:on:)!

toolbarFor: pageVersion 
	| coll pageIdUrl language session |
	language := Processor activeProcess language.
	pageIdUrl := pageVersion isNil ifTrue: [''] ifFalse: [pageVersion page pageName webHttpUrlEncoded].
	coll := OrderedCollection new.
	coll
		add: (Array 
					with: 'WikiDoc.PreviousPage' webTranslate
					with: 'previousObject'
					with: pageVersion notNil
					with: (self urlPrefixForAction: #processPreviousPage:on:) , '&page=' , pageIdUrl , '&lang=' 
							, language);
		add: nil;
		add: (Array 
					with: 'WikiDoc.NextPage' webTranslate
					with: 'nextObject'
					with: pageVersion notNil
					with: (self urlPrefixForAction: #processNextPage:on:) , '&page=' , pageIdUrl , '&lang=' , language);
		add: nil;
		add: (Array 
					with: 'WikiDoc.RecentChanges' webTranslate
					with: 'lucka'
					with: true
					with: (self urlPrefixForAction: #processRecentChanges:on:) , '&lang=' , language);
		add: nil.
	session := self webSession.
	session user isNil 
		ifTrue: 
			[coll
				add: (Array 
							with: 'WikiDoc.Login' webTranslate
							with: nil
							with: true
							with: (self urlPrefixForAction: #processLogin:on:) , '&page=' , pageIdUrl , '&lang=' , language);
				add: nil]
		ifFalse: 
			[coll
				add: (Array 
							with: 'WikiDoc.CreateNewPage' webTranslate
							with: 'createNew'
							with: true
							with: (self urlPrefixForAction: #processCreateNewPage:on:) , '&page=' , pageIdUrl , '&lang=' 
									, language);
				add: nil;
				add: (Array 
							with: 'WikiDoc.EditPage' webTranslate
							with: 'edit'
							with: pageVersion notNil
							with: (self urlPrefixForAction: #processEdit:on:) , '&page=' , pageIdUrl , '&lang=' , language);
				add: nil;
				add: (Array 
							with: 'WikiDoc.CopyPage' webTranslate
							with: 'copy'
							with: pageVersion notNil
							with: (self urlPrefixForAction: #processCopy:on:) , '&page=' , pageIdUrl , '&lang=' , language);
				add: nil;
				add: (Array 
							with: 'WikiDoc.ShowVersions' webTranslate
							with: 'changeLog'
							with: pageVersion notNil
							with: (self urlPrefixForAction: #processShowPageVersions:on:) , '&page=' , pageIdUrl , '&lang=' 
									, language);
				add: nil;
				add: (Array 
							with: 'WikiDoc.RemovePage' webTranslate
							with: 'remove'
							with: pageVersion notNil
							with: (self urlPrefixForAction: #processRemovePage:on:) , '&page=' , pageIdUrl , '&lang=' , language);
				add: nil].
	^coll! !
!WikiDocIndexServlet categoriesFor: #addChildrenOf:to:!private! !
!WikiDocIndexServlet categoriesFor: #getApplicationAdministrationToolbar!private!server administration! !
!WikiDocIndexServlet categoriesFor: #getNavigationFor:!private! !
!WikiDocIndexServlet categoriesFor: #newCoder:!public! !
!WikiDocIndexServlet categoriesFor: #persistentTaskForApplicationAdministration!public!server administration!task factory! !
!WikiDocIndexServlet categoriesFor: #process:on:!public! !
!WikiDocIndexServlet categoriesFor: #processAdvanceSearch:on:!public! !
!WikiDocIndexServlet categoriesFor: #processApplicationAdministration:on:!public!server administration! !
!WikiDocIndexServlet categoriesFor: #processApplicationAdministrationCommandPrompt:on:!public!server administration! !
!WikiDocIndexServlet categoriesFor: #processApplicationAdministrationDownloadServerLog:on:!public!server administration! !
!WikiDocIndexServlet categoriesFor: #processApplicationAdministrationErrorLog:on:!public!server administration! !
!WikiDocIndexServlet categoriesFor: #processApplicationAdministrationLiveUpdate:on:!public!server administration! !
!WikiDocIndexServlet categoriesFor: #processApplicationAdministrationStatistics:on:!public!server administration! !
!WikiDocIndexServlet categoriesFor: #processChangePasswordFor:on:!public! !
!WikiDocIndexServlet categoriesFor: #processCopy:on:!public! !
!WikiDocIndexServlet categoriesFor: #processCreateNewPage:on:!public! !
!WikiDocIndexServlet categoriesFor: #processDefault:on:!public! !
!WikiDocIndexServlet categoriesFor: #processEdit:on:!public! !
!WikiDocIndexServlet categoriesFor: #processLogin:on:!public! !
!WikiDocIndexServlet categoriesFor: #processLogout:on:!public! !
!WikiDocIndexServlet categoriesFor: #processNextPage:on:!public! !
!WikiDocIndexServlet categoriesFor: #processPreviousPage:on:!public! !
!WikiDocIndexServlet categoriesFor: #processPrint:on:!public! !
!WikiDocIndexServlet categoriesFor: #processPrintPages:on:!public! !
!WikiDocIndexServlet categoriesFor: #processRecentChanges:on:!public! !
!WikiDocIndexServlet categoriesFor: #processReload:on:!public! !
!WikiDocIndexServlet categoriesFor: #processRemovePage:on:!public! !
!WikiDocIndexServlet categoriesFor: #processRemovePageConfirm:on:!public! !
!WikiDocIndexServlet categoriesFor: #processSearch:on:!public! !
!WikiDocIndexServlet categoriesFor: #processServerManagement:on:!public!server administration! !
!WikiDocIndexServlet categoriesFor: #processSessionExpired:on:!public! !
!WikiDocIndexServlet categoriesFor: #processShowPageVersions:on:!public! !
!WikiDocIndexServlet categoriesFor: #processTableOfContents:on:!public! !
!WikiDocIndexServlet categoriesFor: #processTocSearchForm:on:!public! !
!WikiDocIndexServlet categoriesFor: #processTopReferers:on:!public! !
!WikiDocIndexServlet categoriesFor: #processUploadedFiles:on:!public! !
!WikiDocIndexServlet categoriesFor: #processUploadFile:on:!public! !
!WikiDocIndexServlet categoriesFor: #processUploadImage:on:!public! !
!WikiDocIndexServlet categoriesFor: #processUserManagement:on:!public! !
!WikiDocIndexServlet categoriesFor: #reloadResponseForPage:action:on:request:!private! !
!WikiDocIndexServlet categoriesFor: #sendCompleteTocPageForWebSpidersOn:!public! !
!WikiDocIndexServlet categoriesFor: #showFreeVersionExpiredResponseOn:!private! !
!WikiDocIndexServlet categoriesFor: #supportedActions!private! !
!WikiDocIndexServlet categoriesFor: #toolbarFor:!public! !

!WikiDocIndexServlet class methodsFor!

servletName
	^'WikiPage'! !
!WikiDocIndexServlet class categoriesFor: #servletName!public! !

