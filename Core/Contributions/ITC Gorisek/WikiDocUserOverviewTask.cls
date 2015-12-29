"Filed out from Dolphin Smalltalk X6.1"!

WikiDocOverviewTask subclass: #WikiDocUserOverviewTask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUserOverviewTask guid: (GUID fromString: '{BAB0FC92-E897-4FB6-B057-BA0042687370}')!
WikiDocUserOverviewTask comment: ''!
!WikiDocUserOverviewTask categoriesForClass!Unclassified! !
!WikiDocUserOverviewTask methodsFor!

getDefaultToolbar
	| buttons |
	buttons := OrderedCollection new.
	buttons
		add: (Array 
					with: 'Add new user' webTranslate
					with: nil
					with: true
					with: self taskURLPrefix , '?action=addNewUser&lang=' , language);
		add: nil.
	self getDefaultToolbarTo: buttons.
	^buttons!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processSearch:on: #processAddNewUser:on: #processDefault:on: #processShow:on:)
		on: stream
		withDefault: #processDefault:on:!

processAddNewUser: request on: stream 
	| t2 |
	t2 := application newTransaction.
	
	[(session addTask: WikiDocUserEditTask new)
		setTransaction: t2;
		defaultToolbar: self getDefaultToolbar;
		setUser: WikiDocUser new;
		superTask: self;
		processDefault: request on: stream] 
			evaluateIn: t2!

processDefault: request on: stream 
	| c pageNumber |
	(c := coll) isNil ifTrue: [c := self updateSearchCache].
	pageNumber := lastPageNumber.
	request isNil 
		ifFalse: 
			[((pageNumber := request integerAt: 'PN') isNil 
				and: [(pageNumber := request integerAt: 'CP') isNil]) 
					ifTrue: [pageNumber := lastPageNumber]].
	lastPageNumber := pageNumber.
	self 
		sendOverviewPage: pageNumber
		for: c
		searchFields: searchFields
		on: stream!

processShow: request on: stream 
	| username user t2 |
	username := request stringAt: 'id'.
	t2 := application newTransaction.
	[user := application userIndex at: username] evaluateIn: t2.
	user isNil 
		ifTrue: [self processDefault: request on: stream]
		ifFalse: 
			[
			[(session addTask: WikiDocUserEditTask new)
				setTransaction: t2;
				defaultToolbar: self getDefaultToolbar;
				setUser: user;
				superTask: self;
				processDefault: request on: stream] 
					evaluateIn: t2]!

searchObjects: fields maxLimit: limit 
	| c |
	transaction := application newReadOnlyTransaction.
	[c := application userIndex values] evaluateIn: transaction.
	^c!

sendOverviewPage: pageNumber for: c searchFields: sf on: stream 
	(self newCoder: stream) 
		showUserOverviewPage: pageNumber
		coll: c
		searchFields: sf!

updateSearchCache
	| c |
	coll := c := self searchObjects: searchFields maxLimit: 1000.
	^c! !
!WikiDocUserOverviewTask categoriesFor: #getDefaultToolbar!public! !
!WikiDocUserOverviewTask categoriesFor: #process:on:!public! !
!WikiDocUserOverviewTask categoriesFor: #processAddNewUser:on:!public! !
!WikiDocUserOverviewTask categoriesFor: #processDefault:on:!public! !
!WikiDocUserOverviewTask categoriesFor: #processShow:on:!public! !
!WikiDocUserOverviewTask categoriesFor: #searchObjects:maxLimit:!public! !
!WikiDocUserOverviewTask categoriesFor: #sendOverviewPage:for:searchFields:on:!public! !
!WikiDocUserOverviewTask categoriesFor: #updateSearchCache!public! !

