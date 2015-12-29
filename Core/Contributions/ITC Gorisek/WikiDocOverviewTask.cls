"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocOverviewTask
	instanceVariableNames: 'coll searchFields lastPageNumber'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocOverviewTask guid: (GUID fromString: '{3FDDC866-C5BD-454A-8911-463D05B89266}')!
WikiDocOverviewTask comment: ''!
!WikiDocOverviewTask categoriesForClass!Unclassified! !
!WikiDocOverviewTask methodsFor!

getDefaultToolbarTo: toolbar 
	toolbar
		add: (Array 
					with: 'WikiDoc.RecentChanges' webTranslate
					with: 'lucka'
					with: true
					with: self sessionURLPrefix , '?action=recentChanges&lang=' , language);
		add: nil;
		add: (Array 
					with: 'WikiDoc.CreateNewPage' webTranslate
					with: 'createNew'
					with: true
					with: self sessionURLPrefix , '?action=createNewPage&lang=' , language);
		add: nil!

initialize
	super initialize.
	transaction := application newTransaction.
	searchFields := ItcLookupTable new.
	lastPageNumber := 1.
	self defaultToolbar: self getDefaultToolbar!

processSearch: request on: stream 
	| c |
	#itcTodo.
	self updateSearchFields: searchFields from: request.
	coll := c := self searchObjects: searchFields maxLimit: 1000.
	self 
		sendOverviewPage: (lastPageNumber := 1)
		for: c
		searchFields: searchFields
		on: stream! !
!WikiDocOverviewTask categoriesFor: #getDefaultToolbarTo:!public! !
!WikiDocOverviewTask categoriesFor: #initialize!public! !
!WikiDocOverviewTask categoriesFor: #processSearch:on:!public! !

