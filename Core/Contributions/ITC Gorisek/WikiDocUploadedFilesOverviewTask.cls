"Filed out from Dolphin Smalltalk X6.1"!

WikiDocOverviewTask subclass: #WikiDocUploadedFilesOverviewTask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUploadedFilesOverviewTask guid: (GUID fromString: '{A8359465-8FEA-465F-BF65-0BF29BF49867}')!
WikiDocUploadedFilesOverviewTask comment: ''!
!WikiDocUploadedFilesOverviewTask categoriesForClass!Unclassified! !
!WikiDocUploadedFilesOverviewTask methodsFor!

getDefaultToolbar
	| buttons |
	buttons := OrderedCollection new.
	buttons
		add: (Array 
					with: 'Add new file' webTranslate
					with: nil
					with: true
					with: self taskURLPrefix , '?action=addNewFile&lang=' , language);
		add: nil.
	self getDefaultToolbarTo: buttons.
	^buttons!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processUploadFileon: #processSearch:on: #processConfirmDelete:on: #processAddNewFile:on: #processUploadFile:on:)
		on: stream
		withDefault: #processDefault:on:!

processAddNewFile: request on: stream 
	^(self newCoder: stream) 
		fileUploadPage: nil
		errors: nil
		fileName: nil!

processConfirmDelete: request on: stream 
	| fileName files |
	fileName := request stringOrNilAt: 'id'.
	files := transaction root at: 'Downloadable.name'.
	files removeKey: fileName.
	transaction commit.
	transaction := application newTransaction.
	coll := nil.
	self processDefault: request on: stream!

processDefault: request on: stream 
	| c pageNumber |
	(c := coll) isNil ifTrue: [c := self updateSearchCache].
	pageNumber := lastPageNumber.
	request isNil 
		ifFalse: 
			[((pageNumber := request integerAt: 'PN') isNil and: [(pageNumber := request integerAt: 'CP') isNil]) 
				ifTrue: [pageNumber := lastPageNumber]].
	lastPageNumber := pageNumber.
	self 
		sendOverviewPage: pageNumber
		for: c
		searchFields: searchFields
		on: stream!

processUploadFile: request on: stream 
	| file newVersion previousVersion fileName |
	
	[(file := request getAttachedFile: 'fileName') isNil 
		ifTrue: 
			[^(self newCoder: stream) 
				fileUploadPage: nil
				errors: ((LookupTable new)
						at: 'fileName' put: 'asp.error.NoFileWasUploaded';
						yourself)
				fileName: nil].
	fileName := file key.
	previousVersion := application getDownloadableFile: fileName.
	newVersion := WikiDocDownloadableFile new.
	newVersion
		fileName: fileName;
		uploadTS: Timestamp now;
		fileBytes: file value;
		previousVersion: previousVersion.
	newVersion fileBytes size > 16384 
		ifTrue: [OmniBase currentTransaction store: newVersion fileBytes in: 'Images'].
	newVersion fileSize: newVersion fileBytes size.
	application downloadableFileIndex at: fileName put: newVersion.
	OmniBase checkpoint.
	application updateCachedFiles] 
			evaluateIn: application newTransaction.
	coll := nil.
	self processDefault: request on: stream!

searchObjects: fields maxLimit: limit 
	| c all files searchString dateFrom dateTo |
	searchString := fields at: #fileName.
	dateFrom := fields at: #dateFrom.
	dateTo := fields at: #dateTo.
	[c := application downloadableFileIndex values] evaluateIn: application newReadOnlyTransaction.
	all := c asSortedCollection: (ItcSortBlock with: #fileName).
	all := searchString isNilOrEmpty 
				ifFalse: [all select: [:eachImage | searchString asUppercase match: eachImage fileName asUppercase]]
				ifTrue: [all].
	files := OrderedCollection new.
	(dateFrom notNil or: [dateTo notNil]) 
		ifTrue: 
			[all do: 
					[:eachImage | 
					(dateFrom notNil and: [dateTo notNil]) 
						ifTrue: 
							[(eachImage uploadTS date >= dateFrom and: [eachImage uploadTS date <= dateTo]) 
								ifTrue: [files add: eachImage]]
						ifFalse: 
							[dateFrom notNil ifTrue: [eachImage uploadTS date >= dateFrom ifTrue: [files add: eachImage]].
							dateTo notNil ifTrue: [eachImage uploadTS date <= dateTo ifTrue: [files add: eachImage]]]]]
		ifFalse: [files := all].
	^files!

sendOverviewPage: pageNumber for: c searchFields: sf on: stream 
	(self newCoder: stream) 
		wikiDocUploadedFilesOverviewPage: pageNumber
		coll: c
		searchFields: sf!

updateSearchCache
	| c |
	coll := c := self searchObjects: searchFields maxLimit: 1000.
	^c!

updateSearchFields: fields from: request 
	fields
		at: #fileName put: (request stringOrNilAt: #fileName);
		at: #dateFrom put: (request dateAt: #dateFrom);
		at: #dateTo put: (request dateAt: #dateTo)! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #getDefaultToolbar!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #process:on:!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #processAddNewFile:on:!accessing!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #processConfirmDelete:on:!accessing!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #processDefault:on:!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #processUploadFile:on:!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #searchObjects:maxLimit:!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #sendOverviewPage:for:searchFields:on:!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #updateSearchCache!public! !
!WikiDocUploadedFilesOverviewTask categoriesFor: #updateSearchFields:from:!public! !

