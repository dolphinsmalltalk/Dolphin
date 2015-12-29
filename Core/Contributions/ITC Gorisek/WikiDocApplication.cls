"Filed out from Dolphin Smalltalk X6.1"!

WebApplication subclass: #WikiDocApplication
	instanceVariableNames: 'urlPrefix pageIndexOid mutex completeToc imageIndexOid downloadableFileIndexOid imagesServlet downloadableFilesServlet linksForPlugIns managedHomepageApplication'
	classVariableNames: 'LastSessionIndexDict LastSessionIndexMutex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocApplication guid: (GUID fromString: '{5C27D049-23B0-4F4C-A024-6B9ED6035333}')!
WikiDocApplication comment: ''!
!WikiDocApplication categoriesForClass!Unclassified! !
!WikiDocApplication methodsFor!

addAllNonLeafPageNamesFrom: nodes to: coll prefix: prefix 
	| index |
	index := 1.
	nodes do: 
			[:eachNode | 
			eachNode isLeafPageNode 
				ifFalse: 
					[coll add: (Association key: eachNode pageName
								value: prefix , index printString , '. ' , eachNode title).
					eachNode children isNilOrEmpty 
						ifFalse: 
							[self 
								addAllNonLeafPageNamesFrom: eachNode children
								to: coll
								prefix: prefix , index printString , '.'].
					index := index + 1]]!

addPlugInFor: label action: action image: image 
	linksForPlugIns isNil ifTrue: [linksForPlugIns := OrderedCollection new].
	linksForPlugIns add: (Array 
				with: action
				with: label
				with: image)!

allNonLeafPageNamesFor: languageName 
	| coll |
	coll := OrderedCollection new.
	self 
		addAllNonLeafPageNamesFrom: (self getTableOfContentsFor: languageName)
		to: coll
		prefix: ''.
	^coll!

applicationPath
	^'WikiDoc'!

appPluginForAction: selector label: label image: image 
	linksForPlugIns add: (Array 
				with: selector
				with: label
				with: image)!

basicNewCoder: aStream 
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	^(WikiDocCoder on: (HtmlStream new: aStream compact: ItcSystemManager isRuntime))
		application: self;
		charSet: self defaultCodePage!

buildIndexedTableOfContentsForLanguage: languageName 
	| pageNameTocNodeDict nodeIndexTocNodeDict toc |
	toc := self buildTreeNodeTableOfContentsForLanguage: languageName onlyValidPages: false.
	pageNameTocNodeDict := LookupTable new.
	toc do: 
			[:eachNode | 
			pageNameTocNodeDict at: eachNode pageName put: eachNode.
			eachNode 
				forEachChildDo: [:eachChildNode | pageNameTocNodeDict at: eachChildNode pageName put: eachChildNode]].
	nodeIndexTocNodeDict := Array new: pageNameTocNodeDict size + 10.
	toc do: 
			[:eachNode | 
			nodeIndexTocNodeDict at: eachNode nodeIndex + 1 put: eachNode.
			eachNode 
				forEachChildDo: [:eachChildNode | nodeIndexTocNodeDict at: eachChildNode nodeIndex + 1 put: eachChildNode]].
	^Array 
		with: toc
		with: nodeIndexTocNodeDict
		with: pageNameTocNodeDict
		with: pageNameTocNodeDict size!

buildTreeNodeTableOfContentsForLanguage: languageName onlyValidPages: onlyValidPages 
	| pnPageDict parentPage pos newNode newToc parentNode rootNode rootParent currentNodeIndex |
	currentNodeIndex := 0.
	pnPageDict := LookupTable new.
	(self pageIndexForLanguage: languageName) transactionReadOnlyDo: 
			[:transaction :eachPage | 
			(onlyValidPages = false or: 
					[eachPage getCurrentVersion dateTo isNilOrEmpty 
						or: [eachPage getCurrentVersion dateTo >= Date today]]) 
				ifTrue: 
					[parentPage := eachPage getCurrentVersion parentPage.
					pos := eachPage getCurrentVersion pagePosition.
					pos isNil ifTrue: [pos := 0].
					newNode := (WikiDocTocNode new)
								application: self;
								parentPageName: parentPage;
								pageName: eachPage pageName;
								pagePosition: pos;
								isLeafPage: eachPage getCurrentVersion isLeafPage;
								languageName: languageName;
								nodeIcon: eachPage getCurrentVersion tocNodeIcon;
								title: eachPage getPageTitle;
								nodeIndex: currentNodeIndex.
					currentNodeIndex := currentNodeIndex + 1.
					pnPageDict at: newNode pageName asWebString put: newNode]].
	newToc := SortedCollection sortBlock: 
					[:a :b | 
					a pagePosition < b pagePosition or: 
							[a pagePosition = b pagePosition 
								and: [a title notNil and: [b title notNil and: [a title isAlphabeticalyBefore: b title]]]]].
	pnPageDict do: 
			[:eachNode | 
			| done |
			parentNode := eachNode parentPageName isNilOrEmpty 
						ifFalse: [pnPageDict at: eachNode parentPageName ifAbsent: []].
			parentNode isNil 
				ifFalse: 
					["prevent circular references"
					rootNode := parentNode.
					done := IdentitySet new.
					
					[rootNode parentPageName isNilOrEmpty or: 
							[(done includes: rootNode) 
								or: [(rootParent := pnPageDict at: rootNode parentPageName ifAbsent: []) isNil]]] 
							whileFalse: 
								[done add: rootNode.
								rootParent == eachNode ifTrue: [parentNode := nil].
								rootNode := rootParent]].
			parentNode isNil ifTrue: [newToc add: eachNode] ifFalse: [parentNode addChildNode: eachNode]].
	^newToc!

connectToDatabase
	[db := OmniBase openOn: self omniBasePath] on: Error do: [:ex | ex exitWith: nil].
	db isNil ifTrue: [db := OmniBase createOn: self omniBasePath].
	self initializeDatabase!

createNewFullTextSearchDictionaryFor: languageName in: transaction 
	| dict |
	dict := db 
				newBTreeIndexDictionary: WikiDocFullTextSearchIndex fullTextSearchKeySize 
						+ ODBObjectID sizeInBytes + 8.
	transaction store: dict.
	transaction root at: languageName , '.Page.fullTextSearchIndex' put: dict!

cssStyleForWikiPageLayout
	| cssStyleForWikiPageLayout |
	managedHomepageApplication isNil 
		ifTrue: 
			["this is obsolete way of doing things since it relies on having a single instance of WikiDoc application"
			self class allSubclassesDo: 
					[:eachSubclass | 
					eachSubclass defaultOrNil isNil 
						ifFalse: 
							[(eachSubclass default respondsTo: #cssStyleForWikiPageLayout) 
								ifTrue: 
									[cssStyleForWikiPageLayout := cssStyleForWikiPageLayout 
												add: eachSubclass default cssStyleForWikiPageLayout
												withDelimiter: '
']]]]
		ifFalse: 
			[(managedHomepageApplication respondsTo: #cssStyleForWikiPageLayout) 
				ifTrue: 
					[cssStyleForWikiPageLayout := cssStyleForWikiPageLayout 
								add: managedHomepageApplication cssStyleForWikiPageLayout
								withDelimiter: '
']].
	^cssStyleForWikiPageLayout isNilOrEmpty 
		ifTrue: [self cssStyleForWikiPageLayoutDefault]
		ifFalse: [cssStyleForWikiPageLayout]!

cssStyleForWikiPageLayoutDefault
	"CSS styles used for generating wiki page's content:
		.caption - for bitmaps/figure's description aka caption
		.inputFieldLabel - markup [[input...]]
		.menuLabel - markup [[menu....]]
		.buttonLabel - markup [[button...]
		.checkBoxLabe - markup [[checkbox:...]]
		.toolTip - markup [[tooltip:...]]
	"

	^'body{BACKGROUND-COLOR:#FFFFFF;COLOR:#000;FONT-FAMILY:Arial,Helvetica,sans-serif;FONT-STYLE:normal;FONT-WEIGHT:normal;FONT-SIZE:10pt;}
td{empty-cells:show;}
td{COLOR:#000;FONT-FAMILY:Arial,Helvetica,sans-serif;FONT-STYLE:normal;FONT-WEIGHT:normal;FONT-SIZE:10pt;}
td.bottom { border-top: 1px solid gray; }
td.top { border-bottom: 1px solid gray; }
div.pageContents{line-height:12.5pt;}
#wikiReferencesToPage{border:gray 1px solid;background:#f8fff8;padding:10px;margin-top:5px;}
#wikiReferencesToPage h3{padding:0px;margin-top:0px;margin-bottom:0px;}
#wikiReferencesToPage p{margin:5px;}
#wikiReferencesToPage ul{margin:0px;margin-left:20px;padding:0px;}
a.external{color: #3366BB;}
a.external:after{margin-left: 2px;content: url("/' 
		, self urlPrefix 
			, '/images/external.png");}
h1{font-size:150%;}
h2{font-size:120%;}
h2, h3, h4, h5, h6 {margin-bottom:0;}
h3{font-size:106.25%;}
.toolTip {background-color: #FFFF55; color: #000000; border: 1px solid black;}
.menuLabel{FONT-SIZE:8.5pt;COLOR:#008800;FONT-FAMILY:Verdana;TEXT-DECORATION:none;font-weight:bold}
.buttonLabel{BORDER-RIGHT:#104a7b 2px solid;BORDER-TOP:#afc4d5 2px solid;FONT-SIZE:8pt;BACKGROUND:#efefef;BORDER-LEFT:#afc4d5 2px solid;COLOR:#000066;BORDER-BOTTOM:#104a7b 2px solid;FONT-FAMILY:Arial,Helvetica,sans-serif;TEXT-DECORATION:none;padding:1pt}
.checkBoxLabel{FONT-SIZE:10pt;BACKGROUND:#f0f0f0;COLOR:#000066;FONT-FAMILY:Arial,Helvetica,sans-serif;TEXT-DECORATION:none}
.inputFieldLabel{FONT-SIZE:10pt;COLOR:#000066;FONT-FAMILY:Arial,Helvetica,sans-serif;TEXT-DECORATION:none;font-weight:bold}
.caption{FONT-SIZE:9pt;color:#502010;FONT-FAMILY:Verdana,Helvetica,sans-serif}
a.downloadableFile,a.downloadableFile:visited{font-family:Arial,Helvetica,sans-serif;COLOR:#101010;FONT-STYLE: normal;FONT-WEIGHT:normal;FONT-SIZE:9pt;TEXT-DECORATION:none}
a.downloadableFile:hover{font-family:Arial,Helvetica,sans-serif;COLOR:#101010;FONT-STYLE: normal;FONT-WEIGHT:normal;FONT-SIZE:9pt;TEXT-DECORATION:underline}
'!

cssStyleItcDefault
	^'body{background-color:#FFFFFF;font-family:Arial,Helvetica,sans-serif;font-style:normal;font-weight:normal;font-size:10pt;}
.error,.note{COLOR:#FF0000}
.warning{COLOR:#1f7f1f}
.dgLb{FONT-SIZE:10pt;}
a.printable{text-decoration: underline;}
a.printLink,a.printLink:visited{FONT-FAMILY:Arial,Helvetica,sans-serif;color:#104A7B;FONT-STYLE:normal;FONT-WEIGHT:normal;FONT-SIZE:12px;TEXT-DECORATION:none;}
a.printLink:hover{FONT-FAMILY:Arial,Helvetica,sans-serif;color:#104A7B;FONT-STYLE:normal;FONT-WEIGHT:normal;FONT-SIZE:12px;TEXT-DECORATION:underline;}
.toolbarButton{font-family:Arial,Helvetica,sans-serif;FONT-STYLE:normal;FONT-WEIGHT:normal;FONT-SIZE:14px;TEXT-DECORATION:none;color:#000000}
.topnavg{font-family:Verdana;FONT-SIZE:8pt;}
.listTable{BORDER:0;FONT-FAMILY:Arial,Helvetica,sans-serif;FONT-SIZE:10pt;vertical-align:top}
.ltbHd{BACKGROUND-COLOR:#d0d0d0;COLOR:#000;FONT-SIZE:9pt;vertical-align:top}
.ltbEv{BACKGROUND-COLOR:#f1f1f1;vertical-align:top}
.ltbOd{BACKGROUND-COLOR:#ffffff;vertical-align:top}

/* Calendar styles */
.Calendar {background-color: #cccccc;cursor: default;border: 1px solid black;}
.CalendarHeader {-moz-user-select:none;background-color: #eeeeff;}
.CalendarDaysRow {font-size: 9pt;}
.CalendarSelectedDay {cursor: pointer;background-color: #00008b;color: #ffffff;font-size: 9pt;}
.CalendarNoDay {cursor: pointer;background-color: #ffffff;color: #777777;font-style: italic;font-size: 9pt;}
.CalendarNoDayWeekend {cursor: pointer;background-color: #dddddd;color: #777777;font-style: italic;font-size: 9pt;}
.CalendarDay {cursor: pointer;background-color: #ffffff;font-size: 9pt;}
.CalendarDayHoliday {cursor: pointer;background-color: #fbdad4;color: #000000;font-size: 9pt;}
.CalendarWeekend {cursor: pointer;background-color: #dddddd;color: #000000;font-size: 9pt;}

/* Dialog box styles */
.DialogBox{padding:2px;position:absolute;overflow:hidden;display:none;background-color:#0073CF;border:2px outset #0073CF;}
/* for IE only... */
.DialogBoxTitleBar{height:18px;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:14px;margin:0px;color: #ffffff;font-weight:bold;cursor:default;padding-left:2px;padding-right:2px;}
/* ...for the rest */
html>body .DialogBoxTitleBar{height:18px;overflow:hidden;font-family:Arial,Helvetica,sans-serif;font-size:14px;margin:0px;color: #ffffff;font-weight:bold;cursor:default;padding: 2px;-moz-user-select:none;}
.DialogBoxTitleText{white-space:nowrap;overflow:hidden;-moz-user-select:none;margin-right:5px;}
.DialogBoxTitleBar .alt{display:none;}
.DialogBoxTitleBar a.close{margin-top:2px;display:block;float:right;width:14px;height:14px;background:url(../images/dialog-close.gif) no-repeat;}
.DialogBoxTitleBar a.close:hover{background:url(../images/dialog-close.gif) no-repeat 0px -18px;}
.DialogBoxTitleBar a.help{margin-top:2px;margin-right:3px;display:block;float:right;width:14px;height:14px;background:url(../images/dialog-help.gif) no-repeat;}
.DialogBoxTitleBar a.help:hover{background:url(../images/dialog-help.gif) no-repeat 0px -18px;}
.DialogBoxContent{overflow:auto;background-color:#ffffff;}
/* for IE only... */
.DialogBoxOverlay{display:none;position:absolute;top:0px;left:0px;width:100%;height:100%;background:url(../images/ccc.gif);}
/* ...for the rest */
html>body .DialogBoxOverlay{display:none;position:absolute;top:0px;left:0px;width:100%;height:100%;background-color: #d0d0d0;filter:alpha(opacity=50);opacity:.50;-moz-user-select: none;}
.DialogBoxOutline{display:none;position:absolute;background-color:#b0a060;width:4px;height:4px;top:0px;left:0px;overflow:hidden;-moz-user-select:none;}

' 
		, self cssStyleForWikiPageLayout!

cssStyleTableOfContents
	^'a.toc{font-family:Arial,Helvetica,sans-serif;COLOR:#101010;FONT-STYLE: normal;FONT-WEIGHT:normal;FONT-SIZE:8pt;TEXT-DECORATION:none}
a.toc:visited{font-family:Arial,Helvetica,sans-serif;COLOR: #000068;FONT-STYLE: normal;FONT-WEIGHT:normal;FONT-SIZE:8pt;TEXT-DECORATION:none}
a.toc:hover{font-family:Arial,Helvetica,sans-serif;COLOR:#000000;FONT-STYLE:normal;FONT-WEIGHT:normal;FONT-SIZE:8pt;TEXT-DECORATION:none}
.tocNodeText{border-style:solid;border-width:1px;border-color:#f1f1f1;background-color:#f1f1f1;margin-left:2pt;padding-left:2px;padding-right:2px;margin-top:0px;margin-bottom:0px;}
.tocNodeTextHover{border-style:solid;border-width:1px;border-color:#000000;background-color:#d8d8d8;margin-left:2pt;padding-left:2px;padding-right:2px;margin-top:0px;margin-bottom:0px;}
'!

currentReleaseDate
	^Date 
		newDay: 9
		monthIndex: 12
		year: 2008!

currentReleaseId
	^'1.0.439.9'!

defaultAdminPassword
	^'wikiadm'!

defaultAdminUser
	^'WIKIADM'!

defaultApplicationLanguages
	^#('Slovene' 'English' 'German' 'Czech')!

defaultCodePage
	^'windows-1250'!

defaultPageName
	| coll languageName |
	languageName := Processor activeProcess language.
	coll := self getTableOfContentsFor: languageName.
	^coll isEmpty 
		ifTrue: 
			[languageName = 'Slovene' 
				ifTrue: ['Prva stran']
				ifFalse: [languageName = 'Serbian' ifTrue: ['Prva strana'] ifFalse: ['Main page']]]
		ifFalse: [coll first pageName]!

defaultUrlPrefix
	"Answer default url prefix if it is not defined in the configuration file."

	^'WikiDoc'!

defaultUrlPrefixForWikiPageServlet
	^'WikiPage?page='!

domainName
	^'...'!

downloadableFileIndex
	| dict |
	downloadableFileIndexOid isNil 
		ifTrue: 
			[dict := OmniBase root at: 'Downloadable.name'.
			downloadableFileIndexOid := OmniBase currentTransaction getObjectID: dict]
		ifFalse: [dict := OmniBase currentTransaction objectAt: downloadableFileIndexOid].
	^dict!

fullTextSearchIndexFor: languageName 
	^OmniBase root at: languageName , '.Page.fullTextSearchIndex'!

getCompleteTableOfContentsFor: languageName 
	"Vrne kompleten table of contents.
	Metoda je namenjena temu, da vrne kompleten TOC, ki se lahko uporablja ne glede na vmesne spremembe podatkov v drugih threadih."

	| result |
	mutex critical: 
			[(result := completeToc at: languageName ifAbsent: []) isNil 
				ifTrue: 
					[OmniBase currentTransactionOrNil isNil 
						ifFalse: [result := self buildIndexedTableOfContentsForLanguage: languageName]
						ifTrue: 
							[[result := self buildIndexedTableOfContentsForLanguage: languageName] 
								evaluateIn: self newTransaction].
					completeToc at: languageName put: result]].
	^result!

getDownloadableFile: fileName 
	^self downloadableFileIndex at: fileName!

getImage: imageName 
	^self imageIndex at: imageName!

getNextTocNodeFrom: aWikiDocTocNode language: languageName 
	| t index |
	t := self getTableOfContentsFor: languageName.
	t isNilOrEmpty ifTrue: [^nil].
	index := t indexOf: aWikiDocTocNode.
	^index < t size ifTrue: [t at: index + 1]!

getOrCreatePage: pageName 
	^self getOrCreatePage: pageName language: Processor activeProcess language!

getOrCreatePage: pageName language: languageName 
	| dict key page |
	key := pageName isNil ifFalse: [pageName asWebString trimBlanks].
	key isNil 
		ifFalse: 
			[dict := self pageIndexForLanguage: languageName.
			page := dict at: key].
	page isNil 
		ifTrue: 
			[page := WikiDocPage new.
			page pageName: key].
	^page!

getOrCreatePersistentPage: pageName language: languageName 
	| dict key page |
	key := pageName asWebString trimBlanks.
	key isNilOrEmpty 
		ifFalse: 
			[dict := self pageIndexForLanguage: languageName.
			page := dict at: key].
	page isNil 
		ifTrue: 
			[page := WikiDocPage new.
			page pageName: key.
			(self pageIndexForLanguage: languageName) at: key put: page].
	^page!

getPage: pageName 
	^self getPage: pageName language: Processor activeProcess language!

getPage: pageName language: pageLanguage 
	| key |
	^pageName isNil 
		ifFalse: 
			[key := pageName asWebString trimBlanks.
			(self pageIndexForLanguage: pageLanguage) at: key]!

getPreviousTocNodeFrom: aWikiDocTocNode language: languageName 
	| t index |
	t := self getTableOfContentsFor: languageName.
	t isNilOrEmpty ifTrue: [^nil].
	index := t indexOf: aWikiDocTocNode.
	^index > 1 ifTrue: [(t at: index - 1) getLastSubNode]!

getTableOfContentsFor: languageName 
	| result |
	mutex critical: 
			[(result := completeToc at: languageName ifAbsent: []) isNil 
				ifTrue: 
					[result := self buildIndexedTableOfContentsForLanguage: languageName.
					completeToc at: languageName put: result]].
	^result first!

getTOCNodeForPage: pageName 
	^self getTOCNodeForPage: pageName language: Processor activeProcess language!

getTOCNodeForPage: pageName language: languageName 
	| toc dict |
	mutex critical: 
			[(toc := completeToc at: languageName ifAbsent: []) isNil 
				ifTrue: 
					[toc := self buildIndexedTableOfContentsForLanguage: languageName.
					completeToc at: languageName put: toc].
			dict := toc at: 3].
	^dict isNil ifFalse: [dict at: pageName ifAbsent: []]!

imageIndex
	| dict |
	imageIndexOid isNil 
		ifTrue: 
			[dict := OmniBase root at: 'Image.name'.
			imageIndexOid := OmniBase currentTransaction getObjectID: dict]
		ifFalse: [dict := OmniBase currentTransaction objectAt: imageIndexOid].
	^dict!

indexServletClass
	^WikiDocIndexServlet!

initializeDatabase
	| dict transaction user |
	db objectManager containerNamed: 'Images' ifAbsent: [db objectManager containerNew: 'Images'].
	db objectManager containerNamed: 'Files' ifAbsent: [db objectManager containerNew: 'Files'].
	db objectManager containerNamed: 'Sessions' ifAbsent: [db objectManager containerNew: 'Sessions'].
	transaction := db newTransaction.
	
	[(dict := transaction root at: 'Image.name' ifAbsent: []) isNil 
		ifTrue: 
			[dict := db newBTreeDictionary: 120.
			transaction store: dict in: 'Images'.
			transaction root at: 'Image.name' put: dict].
	(dict := transaction root at: 'Downloadable.name' ifAbsent: []) isNil 
		ifTrue: 
			[dict := db newBTreeDictionary: 120.
			transaction store: dict in: 'Files'.
			transaction root at: 'Downloadable.name' put: dict].
	(dict := transaction root at: self sessionsDictionaryKey ifAbsent: []) isNil 
		ifTrue: 
			[dict := ODBBTreeIntegerIndexDictionary new.
			transaction store: dict in: 'Sessions'.
			transaction root at: self sessionsDictionaryKey put: dict].
	(dict := transaction root at: 'Clients' ifAbsent: []) isNil 
		ifTrue: 
			[dict := db newBTreeDictionary: 64.
			transaction store: dict in: 'Sessions'.
			transaction root at: 'Clients' put: dict].
	((dict := transaction root at: 'Users' ifAbsent: []) isNil or: [dict isEmpty]) 
		ifTrue: 
			[dict := db newBTreeDictionary: 20.
			transaction store: dict.
			transaction root at: 'Users' put: dict.
			dict at: self defaultAdminUser
				put: ((WikiDocUser newPersistent)
						username: self defaultAdminUser;
						fullName: '';
						password: self defaultAdminPassword;
						eMail: '';
						homepage: '';
						addRole: #userAdmin;
						addRole: #serverAdmin;
						yourself)].
	user := nil.
	(dict := transaction root at: 'Users') 
		do: [:each | (each canDo: #userAdmin) ifTrue: [user := each]].
	user isNil 
		ifTrue: 
			[user := dict at: self defaultAdminUser.
			user isNil ifTrue: [user := dict values first].
			user addRole: #userAdmin].
	user := nil.
	(dict := transaction root at: 'Users') 
		do: [:each | (each canDo: #serverAdmin) ifTrue: [user := each]].
	user isNil 
		ifTrue: 
			[user := dict at: self defaultAdminUser.
			user isNil ifTrue: [user := dict values first].
			user addRole: #serverAdmin]] 
			evaluateAndCommitIn: transaction.
	self initializeThumbnails.
	self applicationLanguages 
		do: [:eachLanguageName | self initializeDatabaseForLanguage: eachLanguageName]!

initializeDatabaseForLanguage: languageName 
	| dict transaction |
	transaction := db newTransaction.
	"index for: page name -> page object"
	(dict := transaction root at: languageName , '.Page.name' ifAbsent: []) isNil 
		ifTrue: 
			[languageName = self defaultLanguage 
				ifTrue: [dict := transaction root at: 'Page.name' ifAbsent: []].
			dict isNil 
				ifTrue: 
					[dict := db newBTreeDictionary: 200.
					transaction store: dict].
			transaction root at: languageName , '.Page.name' put: dict].
	"pageTS to page version"
	(dict := transaction root at: languageName , '.Page.tsToVersion' ifAbsent: []) isNil 
		ifTrue: 
			[languageName = self defaultLanguage 
				ifTrue: [dict := transaction root at: 'Page.tsToVersion' ifAbsent: []].
			dict isNil 
				ifTrue: 
					[dict := db newBTreeDictionary: 10.
					transaction store: dict].
			transaction root at: languageName , '.Page.tsToVersion' put: dict].
	"last deleted pages"
	(dict := transaction root at: languageName , '.Page.deletedPages' ifAbsent: []) isNil 
		ifTrue: 
			[languageName = self defaultLanguage 
				ifTrue: [dict := transaction root at: 'Page.deletedPages' ifAbsent: []].
			dict isNil ifTrue: [dict := OrderedCollection new].
			transaction root at: languageName , '.Page.deletedPages' put: dict].
	"index for: full text search key -> page object"
	(dict := transaction root at: languageName , '.Page.fullTextSearchIndex' ifAbsent: []) 
		isNil ifTrue: [self createNewFullTextSearchDictionaryFor: languageName in: transaction].
	transaction commit!

initializeThumbnails
	"This method migrates all wiki images data to images which include thumbnails for wiki doc image selector servlet."

	| dict counter |
	dict := self newTransaction root at: 'Image.name'.
	counter := 0.
	dict transactionValueBlocksDo: 
			[:t :blockOfImages | 
			blockOfImages do: 
					[:eachImage | 
					eachImage width isNil 
						ifTrue: 
							[| size |
							(size := ItcSystemManager getImageSize: eachImage imageBytes fileName: eachImage imageName) isNil 
								ifFalse: 
									[eachImage
										width: size x;
										height: size y.
									t markDirty: eachImage]].
					eachImage thumbnailBytes isNil 
						ifTrue: 
							[counter := counter + 1.
							counter = 1 
								ifTrue: [ItcSystemManager logLineWithTS: 'Converting ' , dict size printString , ' wiki image(s)...']
								ifFalse: [ItcSystemManager log: '.'].
							(ItcSystemManager isRuntime or: [counter < 1000]) 
								ifTrue: 
									[| thumbnailBytes |
									thumbnailBytes := WikiDocImage getThumbnailBytesForImage: eachImage application: self.
									eachImage 
										thumbnailBytes: (thumbnailBytes isNil ifTrue: [eachImage imageBytes] ifFalse: [thumbnailBytes]).
									t markDirty: eachImage]]].
			t commit].
	counter > 0 ifTrue: [ItcSystemManager logLineWithTS: 'Wiki images conversion done.']!

initialWikiWelcomePage
	^'==Welcome to WikiDoc==

You have now successfully installed the WikiDoc wiki server. The server is now running on your computer.

You can use the wiki from any other computer on your network which has a HTML browser installed. The wiki works with Mozilla and Internet Explorer, other browsers will also work but we have not performed any compatibility tests.

To add new wiki users or pages please click on the [[button:Login]] above.

The default wiki administrator username and password is:

* Username: ''''''wikiadm''''''
* Password: ''''''wikiadm''''''



[[hint:{{
To learn more about the wiki please visit the WikiDoc homepage at:

[http://wiki.gorisek.com]
}}]]'!

linksForPlugIns
	^linksForPlugIns!

loadServlets
	| editorAreaCssString servlet |
	(self servletManager)
		addFileServlet: WebHttpFileServlet new for: self;
		addServlet: WebTaskRoutingServlet new for: self;
		addServlet: WikiDocImageSelectorServlet new for: self;
		addServlet: WikiDocUploadImageServlet new for: self;
		addServlet: WikiDocLinkSelectorServlet new for: self;
		addServlet: WikiDocGetRequestParameterFromUrlServlet new for: self;
		addServlet: ((imagesServlet := WikiDocImageFileServlet new)
					urlPrefix: self urlPrefix;
					yourself)
			for: self;
		addServlet: ((WikiDocThumbnailFileServlet new)
					urlPrefix: self urlPrefix;
					yourself)
			for: self;
		addServlet: ((downloadableFilesServlet := WikiDocDownloadableFileServlet new)
					urlPrefix: self urlPrefix;
					yourself)
			for: self.
	servlet := self servletManager addServlet: self indexServletClass new for: self.
	managedHomepageApplication isNil 
		ifTrue: 
			["act as index servlet only if there is no other managed application"
			self servletManager indexServlet: servlet for: self].
	(self servletManager addServlet: ((WikiDocFckEditorImageFileServlet new)
				urlPrefix: self urlPrefix;
				yourself)
		for: self) setFileCache: imagesServlet fileCache mutex: imagesServlet fileCacheMutex.
	(self servletManager addServlet: ((WikiDocFckEditorPopUpSelectorImageFileServlet new)
				urlPrefix: self urlPrefix;
				yourself)
		for: self) setFileCache: imagesServlet fileCache mutex: imagesServlet fileCacheMutex.
	managedHomepageApplication isNil 
		ifTrue: 
			["this is obsolete way of doing things since it relies on having a single instance of WikiDoc application"
			self class allSubclassesDo: 
					[:eachSubclass | 
					eachSubclass defaultOrNil isNil 
						ifFalse: 
							[(eachSubclass default respondsTo: #cssForFCKEditorArea) 
								ifTrue: 
									[editorAreaCssString := editorAreaCssString add: eachSubclass default cssForFCKEditorArea
												withDelimiter: '
']]]]
		ifFalse: 
			[(managedHomepageApplication respondsTo: #cssForFCKEditorArea) 
				ifTrue: 
					[editorAreaCssString := editorAreaCssString add: managedHomepageApplication cssForFCKEditorArea
								withDelimiter: '
']].
	editorAreaCssString isNilOrEmpty 
		ifFalse: 
			[self servletManager addServlet: ((WebHttpGenericMemoryFileServlet new)
						setFilename: 'fck_editor-' , Timestamp now asFilenameString , '.css' contents: editorAreaCssString;
						yourself)
				for: self].
	scriptServlet := self servletManager addFileScriptServlet: WebHttpScriptFileServlet new for: self.
	cssServlet := self servletManager addFileScriptServlet: WebHttpCssFileServlet new for: self!

loginForSession: aWebSession username: uid password: pwd 
	"Tries to login with an existing web session."

	| t user wikiSession result |
	aWebSession user isNil 
		ifFalse: 
			["user is already logged in"
			^true].
	"answer error message in case login is not successfull"
	result := self loginMessageInvalidUsernameOrPassword.
	t := self newTransaction.
	
	[
	[user := self userIndex at: uid asUppercase.
	(user notNil and: [user password = pwd and: [user inactive ~= true]]) 
		ifTrue: 
			[aWebSession user: user odbResolve.
			(aWebSession sessionData at: #sessionIndex) isNil 
				ifFalse: 
					[(wikiSession := (OmniBase root at: self sessionsDictionaryKey) 
								at: (aWebSession sessionData at: #sessionIndex)) isNil 
						ifFalse: 
							[wikiSession
								user: user;
								markDirty].
					OmniBase checkpoint].
			result := true]] 
			evaluateIn: t] 
			ensure: [t abort].
	^result!

newSessionFor: request sessionCookie: sessionCookie clientCookie: clientCookie 
	| newSession sessionIndex wikiSession previousWikiSession t oid hostname |
	newSession := self 
				newSessionFor: request
				sessionCookie: sessionCookie
				clientCookie: clientCookie
				onlyOneSessionPerClientCookie: true.
	(newSession sessionData at: #sessionIndex ifAbsent: []) isNil 
		ifFalse: 
			["the client was reattached to an existing session, no need to store it again"
			^newSession].
	self setLocalizedLanguageFor: newSession request: request.
	sessionIndex := self class getNextSessionIndexForDatabase: db.
	(newSession sessionData)
		at: #FCKEditorEditorAreaCSS put: (self servletUrlOfClass: WebHttpGenericMemoryFileServlet);
		at: #FCKEditorImageBrowserUrl put: (self servletUrlOfClass: WikiDocImageSelectorServlet);
		at: #FCKEditorLinkBrowserUrl put: (self servletUrlOfClass: WikiDocLinkSelectorServlet);
		at: #FCKEditorImageUploadUrl put: (self servletUrlOfClass: WikiDocUploadImageServlet);
		at: #statMutex put: Semaphore forMutualExclusion;
		at: #pageViews put: LookupTable new;
		at: #pagePrint put: LookupTable new;
		at: #pageEdits put: LookupTable new;
		at: #downloads put: LookupTable new;
		at: #searches put: LookupTable new;
		at: #sessionIndex put: sessionIndex.
	
	[configurationSettingsMutex critical: 
			[t := self newTransaction.
			
			[hostname := WebHttpServer getCachedHostnameFromIPorNil: newSession clientIP.
			wikiSession := WikiDocSession new.
			wikiSession
				referer: request referer;
				loginTS: Timestamp now;
				loginIP: newSession clientIP;
				loginHostname: (hostname ifNil: ['N/A']);
				loginUserAgent: request userAgent;
				clientCookie: newSession clientCookie;
				cookie: newSession cookieId;
				selectedLanguage: newSession language.
			t store: wikiSession in: 'Sessions'.
			(t root at: self sessionsDictionaryKey) at: sessionIndex put: wikiSession.
			previousWikiSession := (t root at: 'Clients') at: wikiSession clientCookie ifAbsent: [].
			wikiSession previousSession: previousWikiSession.
			previousWikiSession isNil 
				ifFalse: 
					[previousWikiSession nextSession: wikiSession.
					t markDirty: previousWikiSession].
			(t root at: 'Clients') at: wikiSession clientCookie put: wikiSession.
			t checkpoint.
			oid := wikiSession odbGetOID] 
					evaluateAndCommitIn: t]] 
			on: Error
			do: [:ex | ItcSystemManager writeErrorLogInRuntime: ex].
	(oid notNil and: [hostname isNil]) 
		ifTrue: 
			["resolve hostname in another thread if it was not already cached"
			
			[hostname := newSession clientHostname.
			
			[(OmniBase objectAt: oid)
				loginHostname: hostname;
				markDirty] 
					evaluateAndCommitIn: self newTransaction] 
					forkAt: ItcSystemManager batchJobPriority].
	^newSession!

omejitevStevilaStrani
	"FREE Retail verzija wiki-ja ima omejitev najvec do 10 wiki strani."

	^nil!

omniBasePath
	^managedHomepageApplication isNil 
		ifFalse: [managedHomepageApplication omniBasePath]
		ifTrue: 
			[self configurationSettingsAt: 'Application.OmniBasePath'
				ifAbsent: [self applicationRootDirectory , 'OmniBase']]!

pageIndexForLanguage: languageName 
	| dict oid |
	(oid := pageIndexOid at: languageName ifAbsent: []) isNil 
		ifTrue: 
			[dict := OmniBase root at: languageName , '.Page.name'.
			pageIndexOid at: languageName put: dict odbObjectID]
		ifFalse: [dict := OmniBase currentTransaction objectAt: oid].
	^dict!

pageTsToVersionIndexForLanguage: languageName 
	^OmniBase root at: languageName , '.Page.tsToVersion'!

removeOldPageVersions
	"This will remove all but the most current page version of every page in the repository."

	| keys t1 |
	
	[keys := OrderedCollection new.
	OmniBase root keys do: [:each | (each endsWith: '.Page.name') ifTrue: [keys add: each]]] 
			evaluateIn: self newTransaction.
	keys do: 
			[:eachKey | 
			t1 := self newReadOnlyTransaction.
			(t1 root at: eachKey) transactionReadOnlyDo: 
					[:transaction :eachPage | 
					| t2 page |
					t2 := self newTransaction.
					page := t2 objectAt: (transaction getObjectID: eachPage).
					page pageVersions copy do: 
							[:eachVersion | 
							(eachVersion isIdenticalTo: page currentVersion) 
								ifFalse: 
									[t2 markDirty: page.
									page pageVersions remove: eachVersion odbResolve]].
					t2 commit]]!

removeSession: session removedDueToSessionExpiration: removedDueToSessionExpirationFlag 
	| wikiSession sessionIndex t |
	super removeSession: session removedDueToSessionExpiration: removedDueToSessionExpirationFlag.
	(sessionIndex := session sessionData at: #sessionIndex ifAbsent: []) isNil 
		ifFalse: 
			[t := self newTransaction.
			(wikiSession := (t root at: self sessionsDictionaryKey) at: sessionIndex ifAbsent: []) isNil 
				ifFalse: 
					[wikiSession logoutTS: Timestamp now.
					#(#pageViews #pagePrint #pageEdits #downloads #searches) 
						do: [:eachKey | wikiSession usageLog at: eachKey put: (session sessionData at: eachKey)].
					t
						markDirty: wikiSession;
						commit]]!

removeSessionsHistory
	"This will remove all history of visitors on this wiki."

	| transaction dict |
	transaction := self newTransaction.
	dict := ODBBTreeIntegerIndexDictionary new.
	transaction store: dict in: 'Sessions'.
	transaction root at: self sessionsDictionaryKey put: dict.
	dict := db newBTreeDictionary: 64.
	transaction store: dict in: 'Sessions'.
	transaction root at: 'Clients' put: dict.
	transaction commit!

resetTableOfContentsForLanguage: languageName 
	completeToc ifNotNil: [:value | value removeKey: languageName ifAbsent: []].
	managedHomepageApplication isNil 
		ifTrue: 
			["this is obsolete way of doing things since it relies on having a single instance of WikiDoc application"
			self class allSubclassesDo: 
					[:eachSubclass | 
					eachSubclass defaultOrNil isNil 
						ifFalse: [eachSubclass default resetTableOfContentsForLanguage: languageName]]]
		ifFalse: [managedHomepageApplication resetTableOfContentsForLanguage: languageName]!

sessionsDictionaryKey
	^'SessionLogDictionary'!

setManagedHomepageApplication: aWebApplication 
	"Set homepage application instance which is managed by this instance of WikiDoc.
	This means that the homepage application's wiki pages can be edited by this instance's tasks.
	"

	managedHomepageApplication := aWebApplication!

shutdown
	completeToc := nil.
	mutex := nil.
	pageIndexOid := nil.
	imageIndexOid := nil.
	downloadableFileIndexOid := nil.
	imagesServlet := nil.
	downloadableFilesServlet := nil.
	db isNil ifFalse: [self class resetLastSessionIndexForDatabase: db].
	super shutdown!

startup
	
	[completeToc := LookupTable new.
	pageIndexOid := LookupTable new.
	linksForPlugIns := OrderedCollection new.
	mutex := Semaphore forMutualExclusion.
	self loadConfigurationSettings.
	urlPrefix := self configurationSettingsAt: 'application.urlPrefix' ifAbsent: [self defaultUrlPrefix].
	self
		connectToDatabase;
		basicStartup] 
			ifCurtailed: [self shutdown]!

sysAdminHasFreeDiskSpaceCheck
	"Answer <true> if free disk space checking is performed."

	^true!

title
	^self configurationSettingsAt: 'application.title' ifAbsent: ['WikiDoc']!

updateCachedFiles
	downloadableFilesServlet isNil ifFalse: [downloadableFilesServlet releaseCachedFiles]!

updateCachedImages
	imagesServlet isNil ifFalse: [imagesServlet releaseCachedFiles]!

updateIndexes
	(WikiDocFullTextSearchIndex new)
		application: self;
		updateFullTextSearchIndex!

urlPrefix
	^managedHomepageApplication isNil 
		ifTrue: [urlPrefix]
		ifFalse: [managedHomepageApplication urlPrefix , '/WikiDoc']!

userIndex
	^OmniBase root at: 'Users'! !
!WikiDocApplication categoriesFor: #addAllNonLeafPageNamesFrom:to:prefix:!defining!page manipulation!private! !
!WikiDocApplication categoriesFor: #addPlugInFor:action:image:!defining!private! !
!WikiDocApplication categoriesFor: #allNonLeafPageNamesFor:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #applicationPath!public! !
!WikiDocApplication categoriesFor: #appPluginForAction:label:image:!public!startup and shutdown! !
!WikiDocApplication categoriesFor: #basicNewCoder:!layout definitions!private! !
!WikiDocApplication categoriesFor: #buildIndexedTableOfContentsForLanguage:!defining!page manipulation!private! !
!WikiDocApplication categoriesFor: #buildTreeNodeTableOfContentsForLanguage:onlyValidPages:!defining!page manipulation!private! !
!WikiDocApplication categoriesFor: #connectToDatabase!public! !
!WikiDocApplication categoriesFor: #createNewFullTextSearchDictionaryFor:in:!defining!private! !
!WikiDocApplication categoriesFor: #cssStyleForWikiPageLayout!layout definitions!public! !
!WikiDocApplication categoriesFor: #cssStyleForWikiPageLayoutDefault!layout definitions!private! !
!WikiDocApplication categoriesFor: #cssStyleItcDefault!layout definitions!public! !
!WikiDocApplication categoriesFor: #cssStyleTableOfContents!layout definitions!public! !
!WikiDocApplication categoriesFor: #currentReleaseDate!defining!public! !
!WikiDocApplication categoriesFor: #currentReleaseId!defining!public! !
!WikiDocApplication categoriesFor: #defaultAdminPassword!public! !
!WikiDocApplication categoriesFor: #defaultAdminUser!public! !
!WikiDocApplication categoriesFor: #defaultApplicationLanguages!defining!NLS support!public! !
!WikiDocApplication categoriesFor: #defaultCodePage!NLS support!public! !
!WikiDocApplication categoriesFor: #defaultPageName!defining!public! !
!WikiDocApplication categoriesFor: #defaultUrlPrefix!NLS support!public! !
!WikiDocApplication categoriesFor: #defaultUrlPrefixForWikiPageServlet!NLS support!public! !
!WikiDocApplication categoriesFor: #domainName!public! !
!WikiDocApplication categoriesFor: #downloadableFileIndex!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #fullTextSearchIndexFor:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getCompleteTableOfContentsFor:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getDownloadableFile:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getImage:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getNextTocNodeFrom:language:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getOrCreatePage:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getOrCreatePage:language:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getOrCreatePersistentPage:language:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getPage:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getPage:language:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getPreviousTocNodeFrom:language:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getTableOfContentsFor:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getTOCNodeForPage:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #getTOCNodeForPage:language:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #imageIndex!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #indexServletClass!public!startup and shutdown! !
!WikiDocApplication categoriesFor: #initializeDatabase!defining!private!startup and shutdown! !
!WikiDocApplication categoriesFor: #initializeDatabaseForLanguage:!defining!private!startup and shutdown! !
!WikiDocApplication categoriesFor: #initializeThumbnails!defining!private!startup and shutdown! !
!WikiDocApplication categoriesFor: #initialWikiWelcomePage!defining!public! !
!WikiDocApplication categoriesFor: #linksForPlugIns!defining!private! !
!WikiDocApplication categoriesFor: #loadServlets!public!startup and shutdown! !
!WikiDocApplication categoriesFor: #loginForSession:username:password:!public!session management! !
!WikiDocApplication categoriesFor: #newSessionFor:sessionCookie:clientCookie:!public!session management! !
!WikiDocApplication categoriesFor: #omejitevStevilaStrani!licence key management!public! !
!WikiDocApplication categoriesFor: #omniBasePath!public! !
!WikiDocApplication categoriesFor: #pageIndexForLanguage:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #pageTsToVersionIndexForLanguage:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #removeOldPageVersions!defining!private!startup and shutdown! !
!WikiDocApplication categoriesFor: #removeSession:removedDueToSessionExpiration:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #removeSessionsHistory!defining!private!startup and shutdown! !
!WikiDocApplication categoriesFor: #resetTableOfContentsForLanguage:!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #sessionsDictionaryKey!defining!private! !
!WikiDocApplication categoriesFor: #setManagedHomepageApplication:!defining!public!startup and shutdown! !
!WikiDocApplication categoriesFor: #shutdown!defining!page manipulation!public!startup and shutdown! !
!WikiDocApplication categoriesFor: #startup!public!startup and shutdown! !
!WikiDocApplication categoriesFor: #sysAdminHasFreeDiskSpaceCheck!private!system administration! !
!WikiDocApplication categoriesFor: #title!defining!public! !
!WikiDocApplication categoriesFor: #updateCachedFiles!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #updateCachedImages!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #updateIndexes!defining!page manipulation!public! !
!WikiDocApplication categoriesFor: #urlPrefix!public! !
!WikiDocApplication categoriesFor: #userIndex!defining!page manipulation!public! !

!WikiDocApplication class methodsFor!

getLastSessionIndexForDatabase: anOmniBase 
	| lastId dict |
	LastSessionIndexMutex isNil 
		ifTrue: 
			[LastSessionIndexMutex := Semaphore forMutualExclusion.
			LastSessionIndexDict := LookupTable new].
	LastSessionIndexMutex critical: 
			[lastId := LastSessionIndexDict at: anOmniBase dirName ifAbsent: [].
			lastId isNil 
				ifTrue: 
					[dict := anOmniBase newReadOnlyTransaction root at: 'SessionLogDictionary' ifAbsent: [].
					lastId := (dict isNil or: [dict getLast isNil]) ifTrue: [0] ifFalse: [dict getLast key].
					LastSessionIndexDict at: anOmniBase dirName put: lastId]].
	^lastId!

getNextSessionIndexForDatabase: anOmniBase 
	| lastId dict |
	LastSessionIndexMutex isNil 
		ifTrue: 
			[LastSessionIndexMutex := Semaphore forMutualExclusion.
			LastSessionIndexDict := LookupTable new].
	LastSessionIndexMutex critical: 
			[lastId := LastSessionIndexDict at: anOmniBase dirName ifAbsent: [].
			lastId isNil 
				ifTrue: 
					[dict := anOmniBase newReadOnlyTransaction root at: 'SessionLogDictionary' ifAbsent: [].
					lastId := (dict isNil or: [dict getLast isNil]) ifTrue: [0] ifFalse: [dict getLast key]].
			lastId := lastId + 1.
			LastSessionIndexDict at: anOmniBase dirName put: lastId].
	^lastId!

resetLastSessionIndexForDatabase: anOmniBase 
	LastSessionIndexMutex isNil ifTrue: [^self].
	LastSessionIndexMutex critical: [LastSessionIndexDict removeKey: anOmniBase dirName ifAbsent: []]! !
!WikiDocApplication class categoriesFor: #getLastSessionIndexForDatabase:!public! !
!WikiDocApplication class categoriesFor: #getNextSessionIndexForDatabase:!public! !
!WikiDocApplication class categoriesFor: #resetLastSessionIndexForDatabase:!public! !

