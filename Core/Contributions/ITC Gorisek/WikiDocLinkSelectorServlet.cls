"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WikiDocLinkSelectorServlet
	instanceVariableNames: 'completeToc'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocLinkSelectorServlet guid: (GUID fromString: '{13BDC3F6-BF9D-4D1D-B858-2AD8114E2157}')!
WikiDocLinkSelectorServlet comment: ''!
!WikiDocLinkSelectorServlet categoriesForClass!Unclassified! !
!WikiDocLinkSelectorServlet methodsFor!

oblikujCollNodov: collResult 
	| result collWithParent parent |
	result := OrderedCollection new.
	collResult do: 
			[:each | 
			collWithParent := OrderedCollection new.
			collWithParent add: (Array with: each pageName with: each nodeIndex).
			parent := each parentNode.
			[parent notNil] whileTrue: 
					[collWithParent add: (Array with: parent pageName with: parent nodeIndex).
					parent := parent parentNode].
			result add: collWithParent].
	^result!

process: request on: stream 
	| t session lang user |
	session := self checkOrSetDefaultClientIdCookieAndSessionFor: request on: stream.

	"set default language for processing the request"
	(application applicationLanguages includes: (lang := request stringOrNilAt: 'lang')) 
		ifTrue: [Processor activeProcess language: lang].
	t := application newTransaction.
	
	[
	[session isNil ifFalse: [user := session user].
	((application configurationSettingsAt: 'application.loginForPreviewRequired') = 'true' 
		and: [user isNil]) ifTrue: [^application indexServlet processLogin: request on: stream].
	self 
		dispatch: request
		using: #(#processDefault:on: #processTocSearchFormLink:on: #processTableOfContentsLink:on: #processTocSearchFormOKAndCancel:on: #processSearchStraniKazala:on:)
		on: stream
		withDefault: #processDefault:on:] 
			evaluateIn: t] 
			ensure: [t abort]!

processDefault: request on: stream 
	| pageId |
	pageId := request stringAt: 'page'.
	self 
		reloadResponseForPageLink: pageId
		action: nil
		on: stream
		request: request!

processSearchStraniKazala: request on: stream 
	| collResult result searchString |
	self itcTodo.
	"metoda #findString: ni portabilna"
	collResult := SortedCollection sortBlock: 
					[:a :b | 
					a pagePosition < b pagePosition 
						or: [a pagePosition = b pagePosition and: [a title isAlphabeticalyBefore: b title]]].
	searchString := request stringAt: 'str'.
	completeToc isNil 
		ifTrue: [completeToc := application getCompleteTableOfContentsFor: Processor activeProcess language].
	(completeToc at: 2) do: 
			[:each | 
			each notNil 
				ifTrue: 
					[(((searchString asUppercase match: each title) or: [searchString asUppercase match: each pageName]) 
						= true or: [(each title asLowercase findString: searchString asLowercase) > 0]) 
						ifTrue: [collResult add: each]]].
	result := self oblikujCollNodov: collResult.
	self 
		putAjaxResults: result
		isFrameRequest: (request booleanAt: 'isDataFrame')
		on: stream!

processTableOfContentsLink: request on: stream 
	| completeToc selectedPage |
	selectedPage := request stringOrNilAt: 'page'.
	completeToc := application getCompleteTableOfContentsFor: Processor activeProcess language.
	(self newCoder: stream)
		baseTarget: 'tocFrameLink';
		style: application cssStyleTableOfContents;
		showTableOfContentsForLink: (completeToc at: 1)
			indexToNodeDict: (completeToc at: 2)
			numberOfNodes: (completeToc at: 4)
			selectedNode: (selectedPage isNilOrEmpty 
					ifFalse: [(completeToc at: 3) at: selectedPage ifAbsent: []])!

processTocSearchFormLink: request on: stream 
	(self newCoder: stream)
		baseTarget: 'tocFrameLink';
		style: application cssStyleTableOfContents;
		showSearchFormForLink: nil!

processTocSearchFormOKAndCancel: request on: stream 
	(self newCoder: stream)
		baseTarget: 'tocFrameLink';
		style: application cssStyleTableOfContents;
		showSearchFormForLinkOkAndCancel: nil!

reloadResponseForPageLink: pageId action: action on: stream request: request 
	| language |
	language := Processor activeProcess language.
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
	<frameset cols="2870,*" ' 
					, (request isMozilla ifTrue: ['border="0"'] ifFalse: ['border="0" frameborder="0" framespacing="0"']) 
					, ' topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<frameset rows="35,*,35" border="0" frameborder="0" framespacing="0" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<frame src="' 
					, self urlPrefix , '?action=' 
				, #processTocSearchFormLink:on: webAsActionString , '&lang=' 
				, language 
					, '" name="tocSearchFormFrameLink" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="0" border="0" scrolling="no"></frame>
  		<frame src="' 
					, self urlPrefix , '?action=' 
				, #processTableOfContentsLink:on: webAsActionString , '&page=' 
				, pageId webHttpUrlEncoded , '&lang=' 
				, language 
					, '" name="tocFrameLink" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="0" border="0"></frame>
<frame src="' 
					, self urlPrefix , '?action=' 
				, #processTocSearchFormOKAndCancel:on: webAsActionString , '&lang=' 
				, language 
					, '" name="tocSearchFormOKAndCancelFrame" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="0" border="0" scrolling="no"></frame>
	</frameset>
<body>
<h1>WikiDoc - the documentation wiki</h1>
<p>WikiDoc is an on-line collaboration system for writing hierachical documentation (user manuals, intranets, process documentation, references, ...). It comes in a form of a stand-alone wiki system. Download, install and run. And you are ready to write on-line documentation or even host a web page using a wiki.</p>
</body>
</html>'! !
!WikiDocLinkSelectorServlet categoriesFor: #oblikujCollNodov:!public! !
!WikiDocLinkSelectorServlet categoriesFor: #process:on:!public! !
!WikiDocLinkSelectorServlet categoriesFor: #processDefault:on:!public! !
!WikiDocLinkSelectorServlet categoriesFor: #processSearchStraniKazala:on:!public! !
!WikiDocLinkSelectorServlet categoriesFor: #processTableOfContentsLink:on:!public! !
!WikiDocLinkSelectorServlet categoriesFor: #processTocSearchFormLink:on:!public! !
!WikiDocLinkSelectorServlet categoriesFor: #processTocSearchFormOKAndCancel:on:!public! !
!WikiDocLinkSelectorServlet categoriesFor: #reloadResponseForPageLink:action:on:request:!public! !

!WikiDocLinkSelectorServlet class methodsFor!

servletName
	^'LinkSelector.html'! !
!WikiDocLinkSelectorServlet class categoriesFor: #servletName!public! !

