"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocServerManagementTask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocServerManagementTask guid: (GUID fromString: '{681FE242-1938-443B-ADAC-4559C747A5FE}')!
WikiDocServerManagementTask comment: ''!
!WikiDocServerManagementTask categoriesForClass!Unclassified! !
!WikiDocServerManagementTask methodsFor!

getDefaultToolbar
	| coll |
	coll := OrderedCollection new.
	coll
		add: (Array 
					with: 'Recent sessions' webTranslate
					with: nil
					with: true
					with: self taskURLPrefix , '?action=recentSessions&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Reorg DB'
					with: nil
					with: true
					with: self taskURLPrefix , '?action=reorgDB&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Backup DB' webTranslate
					with: nil
					with: true
					with: self taskURLPrefix , '?action=backupDB&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Rebuild full text search indexes' webTranslate
					with: nil
					with: true
					with: self taskURLPrefix , '?action=rebuildFullTextSearchIndex&lang=' , language);
		add: nil;
		add: (Array 
					with: 'Shutdown' webTranslate
					with: nil
					with: true
					with: self taskURLPrefix , '?action=shutdown&lang=' , language);
		add: nil.
	^coll!

initialize
	super initialize.
	self defaultToolbar: self getDefaultToolbar!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processRebuildFullTextSearchIndex:on: #processDefault:on: #processReorgDB:on: #processBackupDB:on: #processRecentSessions:on: #processShowSession:on: #processShutdown:on:)
		on: stream
		withDefault: #processDefault:on:!

processBackupDB: request on: stream 
	
	[| db |
	(Delay forSeconds: 1) wait.
	db := application db class openOn: application omniBasePath.
	
	[db 
		createBackupOn: application dbBackupLocalDirectory , '/' , application applicationPath 
				, '-ODB-' , Timestamp now asFilenameString] 
			ensure: [db close]] 
			forkAt: ItcSystemManager batchJobPriority.
	(self newCoder: stream) showControlPanelPage!

processDefault: request on: stream 
	(self newCoder: stream) showControlPanelPage!

processRebuildFullTextSearchIndex: request on: stream 
	[application updateIndexes] forkAt: ItcSystemManager batchJobPriority.
	self processDefault: request on: stream!

processRecentSessions: request on: stream 
	| wikiSessions dict a lastSessionIndex |
	wikiSessions := OrderedCollection new.
	dict := OmniBase root at: application sessionsDictionaryKey.
	(lastSessionIndex := request integerAt: 'last') isNil 
		ifTrue: [a := dict getLast]
		ifFalse: 
			[a := dict
						goTo: lastSessionIndex;
						getPrevious].
	1 to: 21
		do: 
			[:i | 
			a isNil 
				ifFalse: 
					[wikiSessions add: a.
					a := dict getPrevious]].
	(self newCoder: stream) showLastSessionsList: wikiSessions!

processReorgDB: request on: stream 
	
	[| path |
	path := application omniBasePath.
	application shutdown.
	
	[(Delay forSeconds: 1) wait.
	(OmniBase openOn: path)
		reorganize;
		close] 
			ensure: [application startup]] 
			fork.
	(self newCoder: stream) showControlPanelPage!

processShowSession: request on: stream 
	| id wikiSession t2 |
	(id := request integerAt: 'id') isNil 
		ifFalse: 
			[t2 := application newTransaction.
			wikiSession := (t2 root at: application sessionsDictionaryKey) at: id ifAbsent: []].
	wikiSession isNil 
		ifTrue: [self processDefault: request on: stream]
		ifFalse: 
			[
			[(session addTask: WikiDocSessionBrowserTask new)
				setTransaction: t2;
				wikiSession: wikiSession;
				wikiSessionIndex: id;
				superTask: self;
				setDefaultToolbar;
				processDefault: request on: stream] 
					evaluateIn: t2]!

processShutdown: request on: stream 
	application shutdown! !
!WikiDocServerManagementTask categoriesFor: #getDefaultToolbar!public! !
!WikiDocServerManagementTask categoriesFor: #initialize!public! !
!WikiDocServerManagementTask categoriesFor: #process:on:!public! !
!WikiDocServerManagementTask categoriesFor: #processBackupDB:on:!public! !
!WikiDocServerManagementTask categoriesFor: #processDefault:on:!public! !
!WikiDocServerManagementTask categoriesFor: #processRebuildFullTextSearchIndex:on:!public! !
!WikiDocServerManagementTask categoriesFor: #processRecentSessions:on:!public! !
!WikiDocServerManagementTask categoriesFor: #processReorgDB:on:!public! !
!WikiDocServerManagementTask categoriesFor: #processShowSession:on:!public! !
!WikiDocServerManagementTask categoriesFor: #processShutdown:on:!public! !

