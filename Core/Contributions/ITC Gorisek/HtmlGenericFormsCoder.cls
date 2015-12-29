"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #HtmlGenericFormsCoder
	instanceVariableNames: 'htmlWriter htmlStream urlPrefix sessionURLPrefix session application task style styleLinks pageTitle baseUrl baseTarget topNavigation defaultToolbar topNavigationTabs charSet javascriptLinks favoritesIconUrl'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlGenericFormsCoder guid: (GUID fromString: '{255DC96E-4F87-44F2-B438-42FC22640B3B}')!
HtmlGenericFormsCoder comment: ''!
!HtmlGenericFormsCoder categoriesForClass!Unclassified! !
!HtmlGenericFormsCoder methodsFor!

accessDeniedPage

	self errorPage: 'error.PageAccessDenied'!

add: anObject 
	anObject isNil ifTrue: [^self].
	anObject isBlockClosure 
		ifTrue: 
			[anObject argumentCount = 0 ifTrue: [^anObject value].
			anObject value: self]
		ifFalse: [htmlStream nextPutAll: anObject]!

add: aString linkTo: url 
	htmlStream
		nextPutAll: '<a href="' , url , '">';
		code: aString;
		nextPutAll: '</a>'!

addBodyOnLoadScript: onLoadScript 
	Processor activeProcess webProcessingAjaxRequest 
		ifTrue: [Processor activeProcess webAjaxRequestJavascriptOnLoadCollector nextPutAll: onLoadScript]
		ifFalse: 
			[Processor activeProcess webRequest isInternetExplorer 
				ifTrue: 
					[self addJavascript: 'window.attachEvent(''onload'', function() {
' , onLoadScript , '
});
']
				ifFalse: 
					[self 
						addJavascript: 'window.addEventListener(''load'', function() {
' , onLoadScript , '
}, true);
']]!

addBodyOnUnloadScript: onUnloadScript 
	Processor activeProcess webRequest isInternetExplorer 
		ifTrue: 
			[self addJavascript: 'window.attachEvent(''onunload'', function() {
' , onUnloadScript , '
});
']
		ifFalse: 
			[self addJavascript: 'window.addEventListener(''unload'', function() {
' , onUnloadScript 
						, '
}, true);
']!

addBold: aString 
	htmlStream
		nextPutAll: '<b>';
		code: aString;
		nextPutAll: '</b>'!

addHiddenDefaultButton: action 
	self add: '<input type="image" border="0" name="BUTTON_' , action webAsActionString 
				, '" src="images/pixel.gif" width="1" height="1"/>'!

addHintBoxWithText: aMessageId 
	(HtmlContainer new)
		addHintBoxWithText: aMessageId;
		generateOn: htmlStream!

addJavascript: aStringOrBlock 
	aStringOrBlock isNilOrEmpty ifTrue: [^self].
	Processor activeProcess webProcessingAjaxRequest 
		ifTrue: 
			[aStringOrBlock isBlockClosure 
				ifTrue: 
					[| temp |
					temp := htmlStream.
					htmlStream := Processor activeProcess webAjaxRequestJavascriptCollector.
					htmlWriter htmlStream: htmlStream.
					aStringOrBlock value.
					htmlStream := temp.
					htmlWriter htmlStream: htmlStream]
				ifFalse: [Processor activeProcess webAjaxRequestJavascriptCollector nextPutAll: aStringOrBlock]]
		ifFalse: [htmlWriter javascript: aStringOrBlock]!

addLabelText: text 
	htmlStream
		nextPutAll: '<span class="dgLb">';
		nextPutAll: text webTranslate webHtmlEncoded;
		nextPutAll: ':</span>'!

addSeparator
	htmlStream nextPutAll: '<hr size="1" />'!

ajaxHtmlFragment
	^htmlStream contents asJavascriptValue!

application: anApplication 
	application := anApplication.
	pageTitle := application title.
	self cssStyleGeneratedLinkAdd: #cssStyleItcDefault!

barCancel: cancelAction
	htmlWriter 
		bar: nil
		sideActions: (Array with: cancelAction)
		labels: #('asp.button.Cancel')!

barOk: okAction
	htmlWriter 
		bar: nil
		sideActions: (Array with: okAction)
		labels: #('asp.button.OK')!

barOk: okAction cancel: cancelAction 
	htmlWriter 
		bar: nil
		sideActions: (Array with: okAction with: cancelAction)
		labels: #('asp.button.OK' 'asp.button.Cancel')!

barWaitClockOk: okAction cancel: cancelAction 
	htmlWriter 
		bar: nil
		sideActions: (Array with: okAction with: cancelAction)
		labels: #('#asp.button.OK' 'asp.button.Cancel')!

baseTarget: aString 
	baseTarget := aString!

baseUrl: aString 
	baseUrl := aString!

bigDiskette: docName label: label action: action smallLabel: anObject action: anObject1 
	htmlWriter
		code: '<table cellpadding="6" cellspacing="0"><tr><td valign="middle">';
		link: urlPrefix , '/' , docName , '?action=' , action
			content: '<img src="images/diskette2.gif" width="19" height="19" border="0"/>';
		code: '</td><td valign="middle">';
		link: urlPrefix , '/' , docName , '?action=' , action content: label webTranslate;
		code: '</td></tr></table>'!

bigDiskette: docName label: label action: action target: target onClick: onClick 
	htmlWriter
		code: '<table cellpadding="6" cellspacing="0"><tr><td valign="middle">';
		code: '<a href="' , urlPrefix , '/' , docName , '?action=' , action , '" target="' 
					, target , '" onclick="' 
					, onClick , '">';
		code: '<img src="images/diskette2.gif" width="19" height="19" border="0" alt=""/></a>';
		code: '</td><td valign="middle">';
		code: '<a href="' , urlPrefix , '/' , docName , '?action=' , action , '" target="' 
					, target , '" onclick="' 
					, onClick , '">';
		code: label webTranslate;
		code: '</a></td></tr></table>'!

break
	htmlStream write: '<br />'!

center: aBlock 
	htmlStream
		nextPutAll: '<center>';
		code: aBlock;
		nextPutAll: '</center>'!

charSet: aString 
	charSet := aString!

code: code
	htmlStream code: code!

crashIE6
	"The code below will crash IE6. Do not use it."

	htmlStream nextPutAll: '<style>*{position:relative}</style><table><input></table>'!

cssStyleGeneratedLinkAdd: aString 
	^self styleLinkAdd: (application getRealCssPathFor: aString)!

defaultContentsPageMargin
	^5!

defaultToolbar
	^defaultToolbar!

defaultToolbar: aCollection 
	"Set default toolbar for generated page."

	defaultToolbar := aCollection!

emptyPage
	self formPage: []!

errorPage: errorMessage 
	self formPage: 
			[self
				writeTitleBar: 'asp.error';
				break;
				errorText: errorMessage]
		focusField: nil!

errorPage: errorMessage backAction: backAction 
	self formPage: 
			[self
				writeTitleBar: 'asp.error';
				break;
				errorText: errorMessage;
				break;
				break;
				writeActionButtons: (Array with: backAction with: 'asp.button.Back')]
		focusField: 'BUTTON_' , backAction webAsActionString!

errorPageWithHeader: errorMessage 
	self htmlPageWithHeader: 
			[self
				writeTitleBar: 'asp.error';
				break;
				errorText: errorMessage]!

errorText: text 
	htmlStream nextPutAll: '<font class="error">' , text asWebString webTranslate , '</font>'!

evaluateBlockAndGetContentsString: aBlock 
	"Ta medoda se uporablja za tiste strani, kjer se med izvedbo <aBlock> spreminja page header.
	Na tak nacin lahko koda v block-u spreminja instancne variable v coder-ju ter vpliva na header page-a znotraj katerega je contents."

	| oldHtmlStream oldHtmlWriter result |
	aBlock isBlockClosure ifFalse: [^aBlock].
	oldHtmlStream := htmlStream.
	oldHtmlWriter := htmlWriter.
	self htmlStream: (HtmlStream new: (WriteStream on: (String new: 10240))
				compact: ItcSystemManager isRuntime).
	aBlock value.
	result := htmlStream contents.
	htmlStream := oldHtmlStream.
	htmlWriter := oldHtmlWriter.
	^result!

favoritesIconUrl
	^favoritesIconUrl!

favoritesIconUrl: aString 
	favoritesIconUrl := aString!

fieldGroupNamed: subTitle contents: aBlockOrString 
	self
		writeSubtitle: subTitle;
		singleLineBorderWhiteBackground: aBlockOrString!

for: coll bottomSubmitPageIndex: pageNumber table: listTable doWithIndex: aBlock 
	| pn start stop itemsPerPage |
	itemsPerPage := 20.
	pn := pageNumber isNil ifTrue: [1] ifFalse: [pageNumber].
	start := (pn - 1) * itemsPerPage + 1.
	start > coll size 
		ifTrue: 
			[start := 1.
			pn := 1].
	stop := coll size min: start + itemsPerPage - 1.
	start to: stop do: [:i | aBlock value: (coll at: i) value: i].
	coll size > itemsPerPage 
		ifTrue: 
			[listTable
				spanRow;
				nextCell;
				spanRow;
				nextCell;
				spanRow;
				cellNoWrap;
				addHiddenField: 'CP' value: pn printString;
				addHiddenField: 'PN' value: '';
				labelText: 'Stran: '.
			1 to: coll size // itemsPerPage + 1
				do: 
					[:i | 
					i = pn 
						ifTrue: [listTable add: ' <font color=#990000><b>' , i printString , '</b></font>']
						ifFalse: 
							[listTable 
								add: ' <a href="javascript:document.form.PN.value=''' , i printString 
										, ''';document.form.submit();">' , i printString 
										, '</a>']].
			listTable add: ' <a href="next">' , 'asp.button.Forward' webTranslate , '</a>']!

for: coll page: pageNumber table: listTable doWithIndex: aBlock 
	| pn start stop itemsPerPage |
	itemsPerPage := 20.
	pn := pageNumber isNil ifTrue: [1] ifFalse: [pageNumber].
	start := (pn - 1) * itemsPerPage + 1.
	start > coll size 
		ifTrue: 
			[start := 1.
			pn := 1].
	stop := coll size min: start + itemsPerPage - 1.
	start to: stop do: [:i | aBlock value: (coll at: i) value: i].
	coll size > itemsPerPage 
		ifTrue: 
			[listTable
				spanRow;
				nextCell;
				spanRow;
				nextCell;
				spanRow;
				cellNoWrap;
				labelText: 'Stran: '.
			1 to: coll size // itemsPerPage + 1
				do: 
					[:i | 
					i = pn 
						ifTrue: [listTable add: ' <font color=#990000><b>' , i printString , '</b></font>']
						ifFalse: [listTable add: ' <a href="' , i printString , '">' , i printString , '</a>']].
			listTable add: ' <a href="next">' , 'asp.button.Forward' webTranslate , '</a>']!

for: coll topPageIndex: pageNumber smallTable: listTable addHeaderBlock: aBlock2 doWithIndex: aBlock 
	^self 
		for: coll
		topPageIndex: pageNumber
		table: listTable
		addHeaderBlock: aBlock2
		itemsPerPage: 26
		doWithIndex: aBlock!

for: coll topPageIndex: pageNumber table: listTable addHeaderBlock: aBlock2 doWithIndex: aBlock 
	^self 
		for: coll
		topPageIndex: pageNumber
		table: listTable
		addHeaderBlock: aBlock2
		itemsPerPage: 20
		doWithIndex: aBlock!

for: coll topPageIndex: pageNumber table: listTable addHeaderBlock: aBlock2 itemsPerPage: itemsPerPage doWithIndex: aBlock 
	^self 
		for: coll
		topPageIndex: pageNumber
		table: listTable
		addHeaderBlock: aBlock2
		itemsPerPage: itemsPerPage
		emptyLineBefore: true
		doWithIndex: aBlock!

for: coll topPageIndex: pageNumber table: listTable addHeaderBlock: aBlock2 itemsPerPage: nItemsPerPage emptyLineBefore: emptyLineBeforeBool doWithIndex: aBlock 
	| pn start stop lastPage itemsPerPage |
	itemsPerPage := listTable isVirtualListTable 
				ifTrue: [(nItemsPerPage * 7 / 4) rounded + 1]
				ifFalse: [nItemsPerPage].
	listTable isPrintableReportListTable 
		ifTrue: 
			[start := 1.
			stop := coll size]
		ifFalse: 
			[pn := pageNumber isNil ifTrue: [1] ifFalse: [pageNumber].
			start := (pn - 1) * itemsPerPage + 1.
			start > coll size 
				ifTrue: 
					[start := 1.
					pn := 1].
			stop := coll size min: start + itemsPerPage - 1.
			lastPage := (coll size - 1) // itemsPerPage + 1].
	listTable isVirtualListTable 
		ifTrue: 
			[listTable
				dataRequestUrl: urlPrefix , '?action=getVirtualListTablePage&PN=';
				setCurrentPage: pn;
				totalRows: coll size;
				itemsPerPage: itemsPerPage;
				onSelectInNewWindow: (session user notNil and: 
								[(session user respondsTo: #openDocumentsInNewWindow) 
									and: [session user openDocumentsInNewWindow = true]])]
		ifFalse: 
			[listTable isPrintableReportListTable 
				ifFalse: 
					[(coll respondsTo: #sortString) 
						ifTrue: 
							[listTable
								overviewTaskUrlPrefix: urlPrefix;
								overviewTaskSortString: coll sortString].
					emptyLineBeforeBool = false 
						ifFalse: 
							[listTable
								spanRow;
								nextCell;
								skipRowSwitch].
					coll size > (itemsPerPage * 2) 
						ifFalse: 
							["ce jih je manj kot za dve strani se ne splaca prikazat vec strani"
							start := 1.
							pn := 1.
							stop := coll size]
						ifTrue: 
							[listTable
								width: '100%';
								spanRow;
								addHiddenField: 'CP' value: pn printString;
								labelText: 'asp.label.Page' webTranslate , ': '.
							"				cellNoWrap;"
							pn = 1 
								ifFalse: 
									[listTable 
										add: ' <a href="' , urlPrefix , '?PN=' , (pn - 1) printString , '">' 
												, 'asp.button.Back' webTranslate , '</a>']
								ifTrue: [listTable add: ' ' , 'asp.button.Back' webTranslate].
							1 to: lastPage
								do: 
									[:i | 
									i = pn 
										ifTrue: [listTable add: ' <font color=#990000><b>' , i printString , '</b></font>']
										ifFalse: 
											[listTable add: ' <a href="' , urlPrefix , '?PN=' , i printString , '">' , i printString , '</a>']].
							pn = lastPage 
								ifFalse: 
									[listTable 
										add: ' <a href="' , urlPrefix , '?PN=' , (pn + 1) printString , '">' 
												, 'asp.button.Forward' webTranslate , '</a>']
								ifTrue: [listTable add: ' ' , 'asp.button.Forward' webTranslate].
							listTable
								nextCell;
								add: ' ';
								spanRow;
								nextCell]]].
	aBlock2 value.
	start to: stop do: [:i | aBlock value: (coll at: i) value: i].
	listTable isVirtualListTable ifTrue: [self styleAdd: listTable generateCssStyles]!

for: coll topSubmitPageIndex: pageNumber table: listTable addHeaderBlock: aBlock2 doWithIndex: aBlock 
	| pn start stop itemsPerPage lastPage |
	itemsPerPage := 20.
	pageNumber = -1 
		ifTrue: [pn := (coll size - 1) // itemsPerPage + 1]
		ifFalse: [pn := pageNumber isNil ifTrue: [1] ifFalse: [pageNumber]].
	start := (pn - 1) * itemsPerPage + 1.
	start > coll size 
		ifTrue: 
			[pn := pn - 1.
			start := (pn - 1) * itemsPerPage + 1.
			(start > coll size or: [start < 1 or: [pn < 1]]) 
				ifTrue: 
					[start := 1.
					pn := 1]].
	stop := coll size min: start + itemsPerPage - 1.
	listTable
		spanRow;
		nextCell;
		skipRowSwitch.
	coll size > itemsPerPage 
		ifTrue: 
			[listTable
				spanRow;
				cellNoWrap;
				addHiddenField: 'CP' value: pn printString;
				addHiddenField: 'PN' value: '';
				labelText: 'Stran: '.
			pn = 1 
				ifFalse: 
					[listTable 
						add: ' <a href="javascript:document.form.PN.value=''' , (pn - 1) printString 
								, ''';document.form.submit();">' , 'asp.button.Back' webTranslate 
								, '</a>']
				ifTrue: [listTable add: ' ' , 'asp.button.Back' webTranslate].
			lastPage := (coll size - 1) // itemsPerPage + 1.
			1 to: lastPage
				do: 
					[:i | 
					i = pn 
						ifTrue: [listTable add: ' <font color=#990000><b>' , i printString , '</b></font>']
						ifFalse: 
							[listTable 
								add: ' <a href="javascript:document.form.PN.value=''' , i printString 
										, ''';document.form.submit();">' , i printString 
										, '</a>']].
			pn = lastPage 
				ifFalse: 
					[listTable 
						add: ' <a href="javascript:document.form.PN.value=''' , (pn + 1) printString 
								, ''';document.form.submit();">' , 'asp.button.Forward' webTranslate 
								, '</a>']
				ifTrue: [listTable add: ' ' , 'asp.button.Forward' webTranslate].
			listTable
				nextCell;
				spanRow;
				nextCell].
	aBlock2 value.
	start to: stop do: [:i | aBlock value: (coll at: i) value: i]!

form2Page: content focusField: focusField defaultAction: defaultAction 
	self htmlPage: 
			[self writeTopNavigationTabs.
			htmlStream write: '<table cellspacing="0" cellpadding="0"><tr><td valign="top" align="left">'.
			htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: [htmlStream code: content].
			htmlStream write: '</td></tr></table>']
		focusField: focusField!

form2Page: content focusField: focusField defaultAction: defaultAction onLoad: onLoad 
	self 
		htmlPage: 
			[htmlStream write: '<table cellspacing="0" cellpadding="0"><tr><td valign="top" align="left">'.
			htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: 
					[self writeTopNavigationTabs.
					htmlStream code: content].
			htmlStream write: '</td></tr></table>']
		focusField: focusField
		onLoad: onLoad!

form2PageWithHeader: content focusField: focusField defaultAction: defaultAction onLoad: onLoad 
	| contentString |
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: onLoad
		body: 
			[htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: 
					[self header.
					htmlStream 
						write: '<table cellspacing="0" cellpadding="5" width="100%"><tr><td valign="top" align="left" width="100%">'.
					htmlWriter code: contentString.
					htmlStream nextPutAll: '</td></tr></table>']]!

formPage: content
	self formPage: content focusField: nil!

formPage: content focusField: focusField 
	self htmlPage: 
			[htmlWriter form: urlPrefix
				content: 
					[self writeTopNavigationTabs.
					htmlStream code: content]]
		focusField: focusField!

formPage: content focusField: focusField defaultAction: defaultAction 
	self 
		htmlPage: (self evaluateBlockAndGetContentsString: 
					[htmlWriter form: (defaultAction isNil 
								ifTrue: [urlPrefix]
								ifFalse: 
									[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
									urlPrefix , '?action=' , defaultAction webAsActionString])
						content: 
							[self writeTopNavigationTabs.
							htmlStream code: content]])
		focusField: focusField!

formPage: content focusField: focusField defaultAction: defaultAction onLoad: onLoad 
	self 
		htmlPage: 
			[htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: 
					[self writeTopNavigationTabs.
					htmlStream code: content]]
		focusField: focusField
		onLoad: onLoad!

formPage: content focusField: focusField defaultAction: defaultAction refresh: refresh 
	self 
		htmlPage: 
			[htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: 
					[self writeTopNavigationTabs.
					htmlStream code: content]]
		focusField: focusField
		refresh: refresh!

formPage: content title: aString focusField: focusField 
	self 
		htmlPage: 
			[htmlWriter form: urlPrefix
				content: 
					[self writeTopNavigationTabs.
					htmlStream code: content]]
		title: aString
		focusField: focusField!

formPageWithHeader: content focusField: focusField 
	^self 
		formPageWithHeader: content
		focusField: focusField
		onLoad: nil!

formPageWithHeader: content focusField: focusField defaultAction: defaultAction onLoad: onLoad 
	| contentString |
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: onLoad
		body: 
			[htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: 
					[self header.
					self writePageContents: contentString]]!

formPageWithHeader: content focusField: focusField onLoad: onLoad 
	self 
		formPageWithHeader: content
		focusField: focusField
		defaultAction: nil
		onLoad: onLoad!

formPageWithHeaderAndMargin: content focusField: focusField
	self htmlPageWithHeaderAndMargin: [htmlWriter form: urlPrefix content: content]
		focusField: focusField!

formPageWithHeaderAndMargin: content focusField: focusField defaultAction: defaultAction 
	self htmlPageWithHeaderAndMargin: 
			[htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: content]
		focusField: focusField!

formPageWithHeaderAndMargin: content focusField: focusField defaultAction: defaultAction onLoad: onLoad 
	self 
		htmlPageWithHeaderAndMargin: 
			[htmlWriter form: (defaultAction isNil 
						ifTrue: [urlPrefix]
						ifFalse: 
							[HtmlPage onKey: #BrowserKeyEnter do: 'document.form.submit();return false;'.
							urlPrefix , '?action=' , defaultAction webAsActionString])
				content: content]
		focusField: focusField
		onLoad: onLoad!

genericScrollableForm: formFragmentBlock bottomContents: bottomContentsFragmentBlock 
	(session notNil and: [(session sessionData at: #programLayout) == #useMobileBrowserSkin]) 
		ifTrue: 
			["if the screen size is too small, then this has no advantage over the usual layout so just generate HTML"
			formFragmentBlock value.
			bottomContentsFragmentBlock value.
			^self].
	self javascriptAddExternalLink: #javascriptItc.
	Processor activeProcess attributes at: #addNoScrollbarsDiv put: true.
	htmlStream 
		nextPutAll: '<div id="frmDiv" style="position:relative;overflow:auto;height:100px;width:100%;border:2px inset #f0f0e0;">'.
	formFragmentBlock value.
	htmlStream nextPutAll: '</div><div id="btCtxDiv">'.
	bottomContentsFragmentBlock value.
	htmlStream nextPutAll: '</div>'.
	self 
		addJavascript: 'function handleWndResize()
{ var newHeight=(window.innerHeight ? window.innerHeight : (document.documentElement && document.documentElement.clientHeight?document.documentElement.clientHeight:document.body.clientHeight))-(ITC.dom.GetElementPositionTop(ITC.dom.GetElement("frmDiv")))-ITC.dom.GetElement("btCtxDiv").offsetHeight-' 
				, (4 + self defaultContentsPageMargin) printString 
					, ';
if(newHeight < 80) newHeight=80;ITC.dom.GetElement("frmDiv").style.height=newHeight+"px";}
previous_onLoad=window.onload;window.onload=new Function("handleWndResize();if(previous_onLoad)previous_onLoad();");previous_onResize=window.onresize;window.onresize=new Function("if(previous_onResize)previous_onResize();handleWndResize()");'!

getFocusFieldFrom: arrayOfFormFields errors: errors 
	^task isNil ifFalse: [task getFocusFieldFrom: arrayOfFormFields errors: errors]!

htmlPage: content
	self htmlPage: content focusField: nil!

htmlPage: content focusField: focusField 
	| contentString |
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: self defaultContentsPageMargin
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: contentString!

htmlPage: content focusField: focusField onLoad: onLoad 
	| contentString |
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: onLoad
		body: contentString!

htmlPage: content focusField: focusField refresh: refresh 
	| contentString |
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: refresh
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: contentString!

htmlPage: content title: aString focusField: focusField 
	| contentString |
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: aString
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: contentString!

htmlPage2: content focusField: focusField 
	self htmlPage: 
			[htmlStream 
				write: '<table cellspacing="0" cellpadding="0"><tr><td valign="top" align="left">'.
			htmlWriter code: content.
			htmlStream nextPutAll: '</td></tr></table>']
		focusField: focusField!

htmlPageWithHeader: content 
	| contentString |
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: nil
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[self header.
			self writePageContents: contentString]!

htmlPageWithHeader: content focusField: focusField 
	| contentString |
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[self header.
			self writePageContents: contentString]!

htmlPageWithHeader: content focusField: focusField onLoad: onLoad 
	| contentString |
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: onLoad
		body: 
			[self header.
			self writePageContents: contentString]!

htmlPageWithHeaderAndMargin: content focusField: focusField 
	| contentString |
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[self header.
			htmlStream 
				nextPutAll: '<table cellpadding="5" cellspacing="5" width="100%"><tr><td valign="top" width="100%">'.
			self writePageContents: contentString.
			htmlStream nextPutAll: '</td></tr></table>']!

htmlPageWithHeaderAndMargin: content focusField: focusField onLoad: onLoad 
	| contentString |
	Processor activeProcess attributes at: #addNoOuterDivForContent put: true.
	contentString := self evaluateBlockAndGetContentsString: content.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: styleLinks
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: nil
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: onLoad
		body: 
			[self header.
			htmlStream 
				nextPutAll: '<table cellpadding="5" cellspacing="5" width="100%"><tr><td valign="top" width="100%">'.
			self writePageContents: contentString.
			htmlStream nextPutAll: '</td></tr></table>']!

htmlStream
	^htmlStream!

htmlStream: aHtmlStream 
	htmlStream := aHtmlStream.
	htmlWriter := HtmlWriter on: htmlStream!

htmlWriter
	^htmlWriter!

inlineEditableActionFor: fieldSelector 
	^self urlPrefixForAction: #ajaxGetInlineEditField id: fieldSelector!

javascriptAdd: anUrlString 
	"Add a reference to external javascript file from the HTML header.
	Do nothing if the reference already exists."

	javascriptLinks isNil 
		ifTrue: [javascriptLinks := OrderedCollection with: anUrlString]
		ifFalse: [(javascriptLinks includes: anUrlString) ifFalse: [javascriptLinks add: anUrlString]]!

javascriptAddExternalLink: aSymbol 
	Processor activeProcess webJavascriptLinksAdd: aSymbol!

javascriptInclude: aSymbol 
	Processor activeProcess attributes at: aSymbol put: true!

labelText: text 
	htmlStream
		nextPutAll: '<span class="dgLb">';
		nextPutAll: text webTranslate webHtmlEncoded;
		nextPutAll: '</span>'!

labelTextRaw: text 
	htmlStream
		nextPutAll: '<font class="dgLb">';
		nextPutAll: text;
		nextPutAll: '</font>'!

linkForHelpPage: pageName with: aString 
	"Answer HTML link for help page at http://help.e-racuni.com"

	^'<a href="' , (self urlForHelpPage: pageName) webXhtmlUrlEncodeForForm 
		, '" target="_blank" title="' , 'asp.label.helpTip.Help' webTranslate 
		, '">' , aString 
		, '</a>'!

messagePage: title message: message backAction: backAction 
	self formPage: 
			[self writeTitleBar: title webTranslate.
			htmlWriter paragraph: message webTranslate.
			self writeActionButtons: (Array with: backAction with: 'asp.button.Back')]
		focusField: 'BUTTON_' , backAction!

messagePage: title message: message backAction: backAction onLoad: onLoad 
	self formPage: 
			[self writeTitleBar: title webTranslate.
			htmlWriter paragraph: message webTranslate.
			self writeActionButtons: (Array with: backAction with: 'asp.button.Back')]
		focusField: 'BUTTON_' , backAction!

newFormTable: nrOfColumns
	^(HtmlTable columns: nrOfColumns)
		cellPadding: 0;
		cellSpacing: 5!

newListTable: nrOfColumns 
	^HtmlListTable columns: nrOfColumns!

overviewBarActions: aCollection 
	htmlStream nextPutAll: '<div class="bar" style="padding:2px;">'.
	self 
		writeActionButtons: aCollection
		tableClass: nil
		tableStyle: nil.
	htmlStream nextPutAll: '</div>'!

overviewBarActions: actions labels: labels 
	"Write bar with buttons and actions on the rights side."

	self 
		writeBar: nil
		cssLabelClass: nil
		alignment: nil
		toolbarButtons: nil
		alignment: #left
		menu: nil
		alignment: nil
		labels: labels
		actions: actions
		alignment: #right
		showFlags: nil
		helpPage: nil!

overviewBarActions: actions labels: labels showFlags: showFlags sideMenu: menu 
	self 
		overviewMenuBar: menu
		align: #right
		actions: actions
		labels: labels
		showFlags: showFlags
		align: #left!

overviewBarRightActions: actions labels: labels showFlags: showFlags 
	self 
		writeBar: nil
		cssLabelClass: nil
		alignment: nil
		toolbarButtons: nil
		alignment: #right
		menu: nil
		alignment: nil
		labels: labels
		actions: actions
		alignment: #right
		showFlags: showFlags
		helpPage: nil!

overviewMenuBar: menu actions: actions labels: labels 
	self 
		overviewMenuBar: menu
		actions: actions
		labels: labels
		showFlags: nil!

overviewMenuBar: menu actions: actions labels: labels showFlags: showFlags 
	self 
		overviewMenuBar: menu
		align: #left
		actions: actions
		labels: labels
		showFlags: showFlags
		align: #right!

overviewMenuBar: menu actions: actions labels: labels showFlags: showFlags align: alignSymbol 
	self 
		overviewMenuBar: menu
		align: #left
		actions: actions
		labels: labels
		showFlags: showFlags
		align: alignSymbol!

overviewMenuBar: menu align: menuAlignSymbol actions: actions labels: labels showFlags: showFlags align: alignSymbol 
	| toolbarButtons realMenu realMenuAlignSymbol |
	toolbarButtons := OrderedCollection new.
	toolbarButtons
		add: (Array 
					with: #overviewPrint
					with: urlPrefix , '?action=izpis'
					with: nil
					with: true);
		add: (Array 
					with: #overviewExportExcel
					with: urlPrefix , '/doc.xls?action=izpis&outputType=Excel'
					with: nil
					with: true);
		add: (Array 
					with: #overviewExportCSV
					with: urlPrefix , '?action=izpisCSV'
					with: nil
					with: true).
	menuAlignSymbol == #right 
		ifTrue: 
			[realMenu := menu.
			realMenuAlignSymbol := menuAlignSymbol]
		ifFalse: 
			[toolbarButtons
				add: nil;
				add: (Array 
							with: #overviewAdditionalOptions
							with: menu
							with: nil
							with: true).
			realMenu := nil.
			realMenuAlignSymbol := nil].
	self 
		writeBar: nil
		cssLabelClass: nil
		alignment: nil
		toolbarButtons: toolbarButtons
		alignment: #left
		menu: realMenu
		alignment: realMenuAlignSymbol
		labels: labels
		actions: actions
		alignment: alignSymbol
		showFlags: showFlags
		helpPage: nil!

pageExpiredMessage
	self errorPage: 'asp.message.PageExpired'!

pageTitle: aString 
	pageTitle := aString!

paragraph: aStringOrBlock 
	htmlStream nextPutAll: '<p>'.
	aStringOrBlock isString 
		ifTrue: [htmlStream nextPutAll: aStringOrBlock]
		ifFalse: [aStringOrBlock isBlockClosure ifTrue: [aStringOrBlock value]].
	htmlStream nextPutAll: '</p>'!

paragraph2: aString 
	htmlStream
		nextPutAll: '<p>';
		nextPutAll: aString webTranslate webHtmlEncoded;
		nextPutAll: '</p>'!

paragraphRight: aStringOrBlock 
	htmlStream nextPutAll: '<p align="right">'.
	aStringOrBlock isString 
		ifTrue: [htmlStream nextPutAll: aStringOrBlock]
		ifFalse: [aStringOrBlock isBlockClosure ifTrue: [aStringOrBlock value]].
	htmlStream nextPutAll: '</p>'!

parentGoToUrl: aString 
	self htmlPage: [self addBodyOnLoadScript: 'parent.location = ' , aString asJavascriptValue , ';']
		focusField: nil!

printableDocument: docName label: label action: action word: word excel: excel 
	| wordLabel excelLabel |
	(session user isNil or: [session user officeAplikacijaMsOffice]) 
		ifTrue: 
			[wordLabel := 'asp.button.OpenInWord'.
			excelLabel := 'asp.button.OpenInExcel']
		ifFalse: 
			[wordLabel := 'asp.button.OpenInOpenOfficeWrite'.
			excelLabel := 'asp.button.OpenInOpenOfficeCalc'].
	htmlWriter
		code: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle">';
		linkInNewWindow: urlPrefix , docName , '.html?action=' , action webAsActionString
			content: '<img src="images/printer.gif" alt="' , 'asp.label.helpTip.Print' webTranslate 
					, '" width="46" height="33" border="0">';
		code: '</td><td valign="middle">';
		linkInNewWindow: urlPrefix , docName , '.html?action=' , action webAsActionString
			content: label webTranslate.
	(word or: [excel]) 
		ifTrue: 
			[htmlWriter code: '&nbsp;&nbsp;<small>['.
			word 
				ifTrue: 
					[HtmlElement openRtfDocumentsInNewWindow 
						ifTrue: 
							[htmlWriter linkInNewWindow: urlPrefix , docName , '.doc?action=' , action webAsActionString 
										, '&outputType=Word'
								content: '<small>' , wordLabel webTranslate , '</small>']
						ifFalse: 
							[htmlWriter 
								link: urlPrefix , docName , '.doc?action=' , action webAsActionString , '&outputType=Word'
								content: '<small>' , wordLabel webTranslate , '</small>'].
					excel ifTrue: [htmlWriter code: ']&nbsp;&nbsp;[']].
			excel 
				ifTrue: 
					[HtmlElement openExcelDocumentsInNewWindow 
						ifTrue: 
							[htmlWriter linkInNewWindow: urlPrefix , docName , '.xls?action=' , action webAsActionString 
										, '&outputType=Excel'
								content: '<small>' , excelLabel webTranslate , '</small>']
						ifFalse: 
							[htmlWriter 
								link: urlPrefix , docName , '.xls?action=' , action webAsActionString , '&outputType=Excel'
								content: '<small>' , excelLabel webTranslate , '</small>']].
			htmlWriter code: ']</small>'].
	htmlWriter code: '</td></tr></table>'!

printableDocumentRealPdf: docName label: label action: action 
	| url |
	url := urlPrefix , '/' , docName , '?action=' , action webAsActionString.
	htmlWriter
		code: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle"></td><td valign="middle">';
		linkInNewWindow: url
			content: '<img src="images/print-adobe.gif" alt="' , 'asp.label.OpenInAdobeAcrobat' webTranslate 
					, '" width="36" height="36" border="0"/>';
		code: '</td><td valign="middle">&nbsp;';
		linkInNewWindow: url content: label webTranslate;
		code: '</td></tr></table>'!

printableDocumentRtf: docNameString label: label action: action 
	| docName |
	docName := docNameString asFilenameString.
	htmlWriter code: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle">'.
	HtmlElement openWordDocumentsInNewWindow 
		ifTrue: 
			[htmlWriter
				linkInNewWindow: urlPrefix , docName , '.rtf?action=' , action webAsActionString 
							, '&outputType=RTF&app=Word'
					content: '<img src="images/print-MsWord.gif" alt="' , 'asp.label.OpenInMsWord' webTranslate 
							, '" width="36" height="36" border="0">';
				code: '</td><td valign="middle">']
		ifFalse: 
			[htmlWriter
				link: urlPrefix , docName , '.rtf?action=' , action webAsActionString , '&outputType=RTF&app=Word'
					content: '<img src="images/print-MsWord.gif" alt="' , 'asp.label.OpenInMsWord' webTranslate 
							, '" width="36" height="36" border="0">';
				code: '</td><td valign="middle">'].
	HtmlElement openOpenOfficeWriteDocumentsInNewWindow 
		ifTrue: 
			[htmlWriter linkInNewWindow: urlPrefix , docName , '.sxw?action=' , action webAsActionString 
						, '&outputType=RTF&app=OpenOfficeWrite'
				content: '<img src="images/print-OpenOffice.gif" alt="' 
						, 'asp.label.OpenInOpenOfficeWrite' webTranslate , '" width="36" height="36" border="0">']
		ifFalse: 
			[htmlWriter link: urlPrefix , docName , '.sxw?action=' , action webAsActionString 
						, '&outputType=RTF&app=OpenOfficeWrite'
				content: '<img src="images/print-OpenOffice.gif" alt="' 
						, 'asp.label.OpenInOpenOfficeWrite' webTranslate , '" width="36" height="36" border="0">'].
	application pdf995ThisServer isNilOrEmpty 
		ifFalse: 
			[HtmlElement openRtfPdfDocumentsInNewWindow 
				ifTrue: 
					[htmlWriter
						code: '</td><td valign="middle">';
						linkInNewWindow: (application 
									rtfToPdfConverterUrlForDocumentAt: urlPrefix , docName , '.rtf?action=' , action webAsActionString 
											, '&outputType=RTF&app=OpenOfficeWrite')
							content: '<img src="images/print-adobe.gif" alt="' , 'asp.label.OpenInAdobeAcrobat' webTranslate 
									, '" width="36" height="36" border="0">']
				ifFalse: 
					[htmlWriter
						code: '</td><td valign="middle">';
						linkInNewWindow: (application 
									rtfToPdfConverterUrlForDocumentAt: urlPrefix , docName , '.rtf?action=' , action webAsActionString 
											, '&outputType=RTF&app=OpenOfficeWrite')
							content: '<img src="images/print-adobe.gif" alt="' , 'asp.label.OpenInAdobeAcrobat' webTranslate 
									, '" width="36" height="36" border="0">']].
	htmlWriter
		code: '</td><td valign="middle">&nbsp;';
		linkInNewWindow: urlPrefix , docName , '.html?action=' , action webAsActionString
			content: label webTranslate;
		code: '</td></tr></table>'!

printableDocumentRtfPdf: docName label: label action: action 
	| url |
	htmlWriter code: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle">'.
	ItcSystemManager isRuntime 
		ifFalse: 
			[htmlWriter
				linkInNewWindow: (url := urlPrefix , docName , '.rtf?action=' , action 
									, '&outputType=RTF&app=Word')
					content: '<img src="images/print-MsWord.gif" alt="' 
							, 'asp.label.OpenInMsWord' webTranslate , '" width="36" height="36" border="0">';
				code: '</td><td valign="middle">'].
	htmlWriter linkInNewWindow: (url := urlPrefix , docName , '.rtf?action=' , action 
						, '&outputType=RTF&app=OpenOfficeWrite')
		content: '<img src="images/print-OpenOffice.gif" alt="' 
				, 'asp.label.OpenInOpenOfficeWrite' webTranslate , '" width="36" height="36" border="0">'.
	application pdf995ThisServer isNilOrEmpty 
		ifFalse: 
			[htmlWriter
				code: '</td><td valign="middle">';
				linkInNewWindow: (url := application 
									rtfToPdfConverterUrlForDocumentAt: urlPrefix , docName , '.rtf?action=' , action 
											, '&outputType=RTF&app=OpenOfficeWrite')
					content: '<img src="images/print-adobe.gif" alt="' 
							, 'asp.label.OpenInAdobeAcrobat' webTranslate , '" width="36" height="36" border="0">'].
	htmlWriter
		code: '</td><td valign="middle">&nbsp;';
		linkInNewWindow: url content: label webTranslate;
		code: '</td></tr></table>'!

printableDocumentWordPdf: docName label: label action: action 
	| url |
	htmlWriter
		code: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle">';
		linkInNewWindow: urlPrefix , '?action=' , action
			content: '<img src="images/print-MsWord.gif" alt="' 
					, 'asp.label.OpenInMsWord' webTranslate , '" width="36" height="36" border="0">'.
	application pdf995ThisServer isNilOrEmpty 
		ifFalse: 
			[htmlWriter
				code: '</td><td valign="middle">';
				linkInNewWindow: (url := application 
									rtfToPdfConverterUrlForDocumentAt: urlPrefix , docName , '.rtf?action=' , action 
											, '&outputType=RTF&app=OpenOfficeWrite')
					content: '<img src="images/print-adobe.gif" alt="' 
							, 'asp.label.OpenInAdobeAcrobat' webTranslate , '" width="36" height="36" border="0">'].
	htmlWriter
		code: '</td><td valign="middle">&nbsp;';
		linkInNewWindow: url content: label webTranslate;
		code: '</td></tr></table>'!

printAction: action label: label 
	htmlWriter
		code: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle">';
		link: urlPrefix , '?action=' , action
			content: '<img src="images/printer.gif" alt="' , 'asp.label.helpTip.Print' webTranslate 
					, '" width="46" height="33" border="0">';
		code: '</td><td valign="middle">';
		link: urlPrefix , '?action=' , action content: label webTranslate.
	htmlWriter code: '</td></tr></table>'!

promptPage: message title: title actions: actions labels: labels 
	self 
		form2Page: 
			[self writeTitleBar: title.
			htmlWriter
				paragraph: message webTranslate webHtmlEncoded;
				bar: nil
					sideActions: actions
					labels: labels]
		focusField: 'BUTTON_' , actions last
		defaultAction: actions last!

promptPage: message title: title actions: actions labels: labels hiddenId: idValue 
	self 
		form2Page: 
			[self 
				writeToolbarTitle: title
				helpPage: nil
				goBackAction: 'default'.
			htmlWriter
				hiddenField: 'id' value: idValue asWebString;
				paragraph: message webTranslate webHtmlEncoded.
			htmlWriter 
				bar: nil
				sideActions: actions
				labels: labels]
		focusField: 'BUTTON_' , actions last
		defaultAction: actions last!

promptPage2: message title: title actions: actions labels: labels hiddenId: idValue 
	self 
		form2Page: 
			[self writeTitleBar: title.
			htmlWriter
				hiddenField: 'id' value: idValue asWebString;
				paragraph: message;
				bar: nil
					sideActions: actions
					labels: labels]
		focusField: 'BUTTON_' , actions last
		defaultAction: actions last!

promptPage2: message title: title actions: actions labels: labels hiddenId: idValue goBackAction: goBackAction helpPage: helpPage 
	self 
		form2Page: 
			[self 
				writeToolbarTitle: title
				helpPage: helpPage
				goBackAction: goBackAction.
			htmlWriter
				hiddenField: 'id' value: idValue asWebString;
				paragraph: message;
				bar: nil
					sideActions: actions
					labels: labels]
		focusField: 'BUTTON_' , actions last
		defaultAction: actions last!

redirectedUrlFor: url 
	"Answer redirected URL to hide possible sensitive information in the referer URL."

	^'/' , application urlPrefix , '/redirect?url=' , url webHttpUrlEncoded!

session: aWebSession 
	session := aWebSession!

sessionURLPrefix: urlPrefixString 
	sessionURLPrefix := urlPrefixString!

singleLineBorderGreyBackground: aBlockOrString 
	htmlStream 
		nextPutAll: '<table cellspacing="1" cellpadding="0" border="0" bgcolor="#808080" width="100%"><tr><td bgcolor="#f0f0f0">'.
	htmlWriter code: aBlockOrString.
	htmlStream 
		nextPutAll: '</td></tr></table><font style="font-size:3px;">&nbsp;<br /></font>'!

singleLineBorderGreyBackground: aBlockOrString height: heightInPixels 
	htmlStream 
		nextPutAll: '<div style="border:1px solid #808080;padding:4px;background:#f0f0f0;overflow:scroll;height:' 
				, heightInPixels printString , 'px;">'.
	htmlWriter code: aBlockOrString.
	htmlStream nextPutAll: '</div>'!

singleLineBorderWhiteBackground: aBlockOrString 
	htmlStream 
		nextPutAll: '<table cellspacing="1" cellpadding="0" border="0" bgcolor="#808080" width="100%"><tr><td bgcolor="#ffffff">'.
	htmlWriter code: aBlockOrString.
	htmlStream 
		nextPutAll: '</td></tr></table><font style="font-size:3px;">&nbsp;<br /></font>'!

singleLineBorderWhiteBackground: aBlockOrString padding: padding 
	htmlStream 
		nextPutAll: '<table cellspacing="1" cellpadding="0" border="0" bgcolor="#808080" width="100%"><tr><td bgcolor="#ffffff"><table cellspacing="0" cellpadding="' 
				, padding printString , '" width="100%"><tr><td>'.
	htmlWriter code: aBlockOrString.
	htmlStream 
		nextPutAll: '</td></tr></table></td></tr></table><font style="font-size:3px;">&nbsp;<br /></font>'!

smallBreak
	htmlStream nextPutAll: '<small><br /></small>'!

smallerBreak
	htmlStream nextPutAll: '<div style="padding-top:5px;"></div>'!

smallLink: text for: action 
	htmlStream 
		nextPutAll: '<a href="' , urlPrefix , '?action=' , action , '"><small>' , text 
				, '</small></a>'!

space
	htmlStream nextPutAll: '&nbsp;'!

style
	^style!

style: aString 
	"Set inline CSS stylesheet string for HTML page being generated."

	style := aString!

styleAdd: aString 
	"Add inline CSS stylesheet string to page which is being generated."

	style := style add: aString withDelimiter: '
'!

styleLinkAdd: aString 
	styleLinks isNil 
		ifTrue: [styleLinks := aString]
		ifFalse: 
			[styleLinks isString 
				ifTrue: [styleLinks := Array with: styleLinks with: aString]
				ifFalse: [styleLinks := styleLinks , (Array with: aString)]]!

styleLinks
	^styleLinks!

styleLinks: aStringOrArrayOfStrings 
	styleLinks := aStringOrArrayOfStrings!

task: aWebTask urlPrefix: urlPrefixString 
	task := aWebTask.
	urlPrefix := urlPrefixString!

text: text
	htmlStream text: text!

toolbarButton: url id: id target: target tooltip: tooltip label: label className: className onClick: onClick enabled: enabled accessKey: accessKey 
	htmlStream nextPutAll: (self 
				toolbarButtonHtmlString: url
				id: id
				target: target
				tooltip: tooltip
				label: label
				className: className
				onClick: onClick
				enabled: enabled
				accessKey: accessKey)!

toolbarButton: buttonType urlOrMenu: urlOrMenu toolTip: tooltip enabled: enabled 
	buttonType = #goBack ifTrue: [^self toolbarButtonGoBack: urlOrMenu enabled: enabled].
	buttonType = #createNew ifTrue: [^self toolbarButtonCreateNew: urlOrMenu enabled: enabled].
	buttonType = #copy ifTrue: [^self toolbarButtonCopy: urlOrMenu enabled: enabled].
	buttonType = #goToSearch ifTrue: [^self toolbarButtonGoToSearch: urlOrMenu enabled: enabled].
	buttonType = #showPrevious 
		ifTrue: 
			[^self 
				toolbarButtonShowPrevious: urlOrMenu
				enabled: enabled
				tooltip: tooltip].
	buttonType = #showNext 
		ifTrue: 
			[^self 
				toolbarButtonShowNext: urlOrMenu
				enabled: enabled
				tooltip: tooltip].
	buttonType = #print ifTrue: [^self toolbarButtonPrint].
	buttonType = #dataExchange ifTrue: [^self toolbarButtonDataExchange].
	buttonType = #save ifTrue: [^self toolbarButtonSave: urlOrMenu enabled: enabled].
	buttonType = #edit ifTrue: [^self toolbarButtonEdit: urlOrMenu enabled: enabled].
	buttonType = #sendEmail ifTrue: [^self toolbarButtonSendEmail].
	buttonType = #additionalOptions ifTrue: [^self toolbarButtonAdditionalOptions].
	buttonType = #businessEvents ifTrue: [^self toolbarButtonBusinessEvents].
	buttonType = #attachImageDocument 
		ifTrue: [^self toolbarButtonAttachImageDocument: urlOrMenu enabled: enabled].
	buttonType = #showChangeLog ifTrue: [^self toolbarButtonShowChangeLog].
	buttonType = #ajaxShowChangeLog ifTrue: [^self toolbarButtonAjaxShowChangeLog].
	buttonType = #ajaxShowConfidentialityLevel ifTrue: [^self toolbarButtonAjaxSetConfidentialityLevel].
	buttonType = #overviewPrint ifTrue: [self toolbarButtonOverviewPrint: urlOrMenu enabled: enabled].
	buttonType = #overviewExportExcel 
		ifTrue: [self toolbarButtonOverviewExportExcel: urlOrMenu enabled: enabled].
	buttonType = #overviewExportCSV 
		ifTrue: [self toolbarButtonOverviewExportCSV: urlOrMenu enabled: enabled].
	buttonType = #overviewAdditionalOptions 
		ifTrue: [self toolbarButtonOverviewAdditionalOptions: urlOrMenu]!

toolbarButtonAdditionalOptions
	| menu |
	((menu := task barButtonAdditionalOptionsMenu) isNil or: [menu isEmpty]) 
		ifFalse: 
			[menu menuLayerName: 'toolbarAdditionalOptionsMenu'.
			self 
				toolbarButtonWithMenu: menu
				id: 'toolbarAdditionalOptionsMenuButton'
				tooltip: 'asp.tooltip.AdditionalOptions' webTranslate
				label: nil
				className: 'itcBgIconAddOptions'
				url: nil
				target: nil
				onMouseDown: 'show_toolbarAdditionalOptionsMenu(event);']!

toolbarButtonAjaxSetConfidentialityLevel
	(session user canDo: #urConfidentialityLevelAdministration) 
		ifTrue: 
			[self javascriptInclude: #javascriptDialogBox.
			self 
				toolbarButton: (self urlPrefixForAction: #ajaxGetSetDocumentConfidentialityLevel)
				id: nil
				target: nil
				tooltip: 'asp.tooltip.SetConfidentialityLevel' webTranslate
				label: nil
				className: 'itcBgIconAdd'
				onClick: nil
				enabled: true
				accessKey: nil]!

toolbarButtonAjaxShowChangeLog
	(session user canDo: #urAdminShowChangeLog) 
		ifTrue: 
			[self javascriptInclude: #javascriptDialogBox.
			self 
				toolbarButton: (self urlPrefixForAction: #ajaxGetShowChangeLog)
				id: nil
				target: nil
				tooltip: 'asp.tooltip.ShowChangeLog' webTranslate
				label: nil
				className: 'itcBgIconChangeLog'
				onClick: nil
				enabled: true
				accessKey: nil]!

toolbarButtonAttachImageDocument: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: 'asp.tooltip.AttachImageDocument' webTranslate
		label: nil
		className: 'itcBgIconAttach'
		onClick: nil
		enabled: enabled
		accessKey: nil!

toolbarButtonBusinessEvents
	| menu |
	((menu := task barButtonBusinessEventsMenu) isNil or: [menu isEmpty]) 
		ifFalse: 
			[menu menuLayerName: 'toolbarBusinessEventsMenu'.
			self 
				toolbarButtonWithMenu: menu
				id: 'toolbarBusinessEventsMenuButton'
				tooltip: 'asp.tooltip.BusinessEvents' webTranslate
				label: nil
				className: 'itcBgIconBusinessEvents'
				url: nil
				target: nil
				onMouseDown: 'show_toolbarBusinessEventsMenu(event);']!

toolbarButtonCopy: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: 'asp.tooltip.CopyDocument' webTranslate
		label: nil
		className: 'itcBgIconCopy'
		onClick: nil
		enabled: enabled
		accessKey: nil!

toolbarButtonCreateNew: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: 'asp.tooltip.NewDocument' webTranslate
		label: nil
		className: 'itcBgIconCreateNew'
		onClick: nil
		enabled: enabled
		accessKey: nil!

toolbarButtonDataExchange
	| menu |
	((menu := task barButtonDataExchangeMenu) isNil or: [menu isEmpty]) 
		ifFalse: 
			[menu menuLayerName: 'toolbarDataExchangeMenu'.
			self 
				toolbarButtonWithMenu: menu
				id: 'toolbarDataExchangeMenuButton'
				tooltip: 'asp.tooltip.DataExchange' webTranslate
				label: nil
				className: 'itcBgIconExportData'
				url: nil
				target: nil
				onMouseDown: 'show_toolbarDataExchangeMenu(event);']!

toolbarButtonEdit: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: 'asp.tooltip.EditDocument' webTranslate , '  [ F8 ]'
		label: 'asp.button.Edit' webTranslate
		className: nil
		onClick: nil
		enabled: enabled
		accessKey: nil.
	enabled == true ifTrue: [HtmlPage onKey: #BrowserKeyF8 gotoUrl: url]!

toolbarButtonGoBack: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: 'asp.tooltip.GoBack' webTranslate , '  [ Esc ]'
		label: nil
		className: 'itcBgIconGoBack'
		onClick: nil
		enabled: enabled
		accessKey: nil.
	enabled == true ifTrue: [HtmlPage onKey: #BrowserKeyEsc gotoUrl: url]!

toolbarButtonGoToSearch: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: 'asp.tooltip.SearchAndOverview' webTranslate , '  [ Shift+Home ]'
		label: nil
		className: 'itcBgIconSearch'
		onClick: nil
		enabled: enabled
		accessKey: nil.
	enabled == true ifTrue: [HtmlPage onKey: #BrowserKeyShiftHome gotoUrl: url]!

toolbarButtonHelp: helpPageId enabled: enabled 
	| helpPage |
	self 
		toolbarButton: (helpPage := (self urlForHelpPage: helpPageId) webXhtmlUrlEncodeForForm)
		id: nil
		target: '_blank'
		tooltip: 'asp.label.helpTip.Help' webTranslate
		label: nil
		className: 'itcBgIconHelp'
		onClick: nil
		enabled: enabled
		accessKey: nil.
	enabled == true 
		ifTrue: 
			["Owerride #onhelp mandatory for IE."
			HtmlPage onKey: #BrowserKeyF1
				do: 'document.onhelp=function(){return false};window.open(' , helpPage asJavascriptValue 
						, ', ''_blank'');']!

toolbarButtonHtmlString: url id: id target: target tooltip: tooltip label: label className: className onClick: onClick enabled: enabled accessKey: accessKey 
	| cn tg ur oc acKey |
	(Processor activeProcess attributes at: #tempToolbarNeedsSeparator ifAbsent: []) = true 
		ifTrue: 
			[self toolbarButtonSeparator.
			Processor activeProcess attributes at: #tempToolbarNeedsSeparator put: false].
	cn := className isNilOrEmpty 
				ifTrue: [enabled = true ifTrue: ['toolBarText'] ifFalse: ['toolBarText disabled']]
				ifFalse: 
					[cn := (label isNilOrEmpty ifTrue: ['toolBarIcon'] ifFalse: ['toolBarIconText']) 
								, (enabled = true ifTrue: [' '] ifFalse: [' disabled ']) , className].
	enabled == true 
		ifTrue: 
			[ur := url.
			tg := target.
			oc := onClick.
			acKey := accessKey]
		ifFalse: 
			[ur := 'javascript:void(0);'.
			tg := nil.
			oc := nil.
			acKey := nil].
	^'<a href="' , ur asWebString , '" class="' , cn , '" title="' , tooltip asWebString , '"' 
		, (tg isNilOrEmpty ifTrue: [''] ifFalse: [' target="' , tg asWebString , '"']) 
			, (oc isNilOrEmpty ifTrue: [''] ifFalse: [' onclick="' , oc , '"']) 
			, (acKey isNilOrEmpty ifTrue: [''] ifFalse: [' accesskey="' , acKey , '"']) 
			, (id isNilOrEmpty ifTrue: [''] ifFalse: [' id="' , id asWebString , '"']) , '>' 
		, label asWebString , '</a>'!

toolbarButtonOverviewAdditionalOptions: aMenu 
	(aMenu isNil or: [aMenu isEmpty]) 
		ifFalse: 
			[aMenu menuLayerName: 'overviewAdditionalOptionsMenu'.
			self 
				toolbarButtonWithMenu: aMenu
				id: 'overviewAdditionalOptionsMenuButton'
				tooltip: 'asp.tooltip.AdditionalOptions' webTranslate
				label: nil
				className: 'itcBgIconAddOptions'
				url: nil
				target: nil
				onMouseDown: 'show_overviewAdditionalOptionsMenu(event);']!

toolbarButtonOverviewExportCSV: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: '_blank'
		tooltip: 'asp.tooltip.OverviewExportCSV' webTranslate
		label: nil
		className: 'itcBgIconCSV'
		onClick: nil
		enabled: enabled
		accessKey: nil!

toolbarButtonOverviewExportExcel: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: '_blank'
		tooltip: 'asp.tooltip.OverviewExportExcel' webTranslate
		label: nil
		className: 'itcBgIconExcel'
		onClick: nil
		enabled: enabled
		accessKey: nil!

toolbarButtonOverviewPrint: url enabled: enabled 
	self 
		toolbarButton: url
		id: nil
		target: '_blank'
		tooltip: 'asp.tooltip.OverviewPrint' webTranslate
		label: nil
		className: 'itcBgIconPrint'
		onClick: nil
		enabled: enabled
		accessKey: nil!

toolbarButtonPrint
	"Generira fragment za toolbar button [Tiskanje] z menijem ali brez"

	| docName url tooltip menu target |
	menu := self toolbarButtonPrintMenu.
	docName := self toolbarButtonPrintDocumentName.

	"preveri ali se pri kliku na [Tiskanje] takoj izpise dokument ali se naj samo pojavi pull-down menu"
	docName isNil 
		ifFalse: 
			[(docName isSymbol and: [docName isAjaxAction]) 
				ifTrue: 
					["ce je simbol, potem se predpostavlja, da gre za AJAX action s pop-up dialogom za tiskanje"
					url := self urlPrefixForAction: docName.
					target := #javaScript]
				ifFalse: 
					["ce je RTF dokument in deluje PDF print server potem bo sprintal via PDF"
					docName := docName asFilenameString.
					(docName endsWithUppercase: '.RTF') 
						ifTrue: 
							[url := task barButtonPrintDefaultPdfOrRtfUrlFor: docName.
							url isNil 
								ifFalse: [target := '_blank']
								ifTrue: 
									["PDF print server ni instaliran, mozen je samo RTF dokument"
									url := task barButtonPrintUrlPrefix , '/' , docName 
												, '?action=print&outputType=RTF&app=OpenOfficeWrite']]
						ifFalse: 
							[url := task barButtonPrintUrlPrefix , '/' , docName , '?action=print'.
							target := '_blank']]].
	"v primeru, ko ni niti direktnega printanja niti menija, potem se gumb [Tiskanje] ne prikaze"
	(url isNil and: [menu isNil or: [menu isEmpty]]) ifTrue: [^self].
	tooltip := 'asp.tooltip.Print' webTranslate.
	url isNil ifFalse: [url := url webHtmlEncodedForForm].
	menu isNil 
		ifTrue: 
			[self 
				toolbarButton: url
				id: nil
				target: target
				tooltip: tooltip
				label: tooltip
				className: 'itcBgIconPrint'
				onClick: nil
				enabled: true
				accessKey: nil]
		ifFalse: 
			[menu menuLayerName: 'toolbarPrintMenu'.
			self 
				toolbarButtonWithMenu: menu
				id: 'toolbarPrintMenuButton'
				tooltip: tooltip
				label: tooltip
				className: 'itcBgIconPrint'
				url: url
				target: target
				onMouseDown: 'show_toolbarPrintMenu(event);']!

toolbarButtonPrintDocumentName
	"Subclass this method if menu is implemented somewhere else."

	^task barButtonPrintDocumentName!

toolbarButtonPrintMenu
	"Subclass this method if menu is implemented somewhere else."

	^task barButtonPrintMenu!

toolbarButtonSave: url enabled: enabled 
	"Maybe not perfect place, but isMozilla is obslolete. getElementById is implemented on IE to for few years at least."

	| isMozilla isJavascript |
	isMozilla := self webRequest isInternetExplorer not.
	isJavascript := url beginsWith: 'javascript:'.
	Processor activeProcess attributes at: #javascriptWaitClock put: true.
	self 
		toolbarButton: (isJavascript ifTrue: ['javascript:void(0);'] ifFalse: [url])
		id: 'tb_save'
		target: nil
		tooltip: 'asp.tooltip.SaveDocument' webTranslate , '  [ F2 ]'
		label: '<strong>' , 'asp.button.Save' webTranslate , '</strong>'
		className: 'itcBgIconSave'
		onClick: ('waitClock_ShowWait(this);' 
				add: (isJavascript ifTrue: [HtmlPage javascriptForUrl: url] ifFalse: [''])
				withDelimiter: '')
		enabled: enabled
		accessKey: nil.
	enabled == true 
		ifTrue: 
			[htmlStream
				nextPutAll: HtmlElement javascriptBeginString;
				nextPutAll: 'var s=0;
function tb_save_blinker()
{
	var el = ' 
							, (isMozilla ifTrue: ['document.getElementById(''tb_save'')'] ifFalse: ['document.all[''tb_save'']']) 
								, ';
	if (el) {
		if (s==0) {
			el.style.backgroundColor="#ffcc00";
			s=1;
			setTimeout("tb_save_blinker()",300);
		} else {
			el.style.backgroundColor="transparent";
			s=0;
			setTimeout("tb_save_blinker()",500);
		}
	}
}
tb_save_blinker();';
				nextPutAll: HtmlElement javascriptEndString.
			HtmlPage 
				onKey: #BrowserKeyF2
				gotoUrl: url
				onClickDo: 'waitClock_ShowWait();']!

toolbarButtonSendEmail
	| menu |
	((menu := task barButtonSendEmailMenu) isNil or: [menu isEmpty]) 
		ifFalse: 
			[menu menuLayerName: 'toolbarSendEmailMenu'.
			self 
				toolbarButtonWithMenu: menu
				id: 'toolbarSendEmailMenuButton'
				tooltip: 'asp.tooltip.SendEmail' webTranslate
				label: nil
				className: 'itcBgIconSendEmail'
				url: nil
				target: nil
				onMouseDown: 'show_toolbarSendEmailMenu(event);']!

toolbarButtonSeparator
	htmlStream nextPutAll: self toolbarButtonSeparatorHtmlString!

toolbarButtonSeparatorHtmlString
	^'<span class="toolBarSeparator"></span>'!

toolbarButtonShowChangeLog
	(session user canDo: #urAdminShowChangeLog) 
		ifTrue: 
			[self 
				toolbarButton: urlPrefix , '?action=showChangeLog'
				id: nil
				target: nil
				tooltip: 'asp.tooltip.ShowChangeLog' webTranslate
				label: nil
				className: 'itcBgIconChangeLog'
				onClick: nil
				enabled: true
				accessKey: nil]!

toolbarButtonShowNext: url enabled: enabled tooltip: tooltipString 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: (tooltipString isNil ifTrue: ['asp.button.Next' webTranslate] ifFalse: [tooltipString]) 
				webHtmlEncodedForForm , '  [ Ctrl+-> ]'
		label: nil
		className: 'itcBgIconNextObject'
		onClick: nil
		enabled: enabled
		accessKey: nil.
	enabled == true ifTrue: [HtmlPage onKey: #BrowserKeyCtrlRight gotoUrl: url]!

toolbarButtonShowPrevious: url enabled: enabled tooltip: tooltipString 
	self 
		toolbarButton: url
		id: nil
		target: nil
		tooltip: (tooltipString isNil ifTrue: ['asp.button.Previous' webTranslate] ifFalse: [tooltipString]) 
				webHtmlEncodedForForm , '  [ Ctrl+<- ]'
		label: nil
		className: 'itcBgIconPreviousObject'
		onClick: nil
		enabled: enabled
		accessKey: nil.
	enabled == true ifTrue: [HtmlPage onKey: #BrowserKeyCtrlLeft gotoUrl: url]!

toolbarButtonWithMenu: menu id: id tooltip: tooltip label: label className: className url: url target: target onMouseDown: onMouseDown 
	(Processor activeProcess attributes at: #tempToolbarNeedsSeparator ifAbsent: []) = true 
		ifTrue: 
			[self toolbarButtonSeparator.
			Processor activeProcess attributes at: #tempToolbarNeedsSeparator put: false].
	url isNilOrEmpty 
		ifTrue: 
			[htmlStream 
				nextPutAll: '
<a href="javascript:void(0);" id="' , id , '" class="toolBarPopUp" onmousedown="' 
						, onMouseDown , '" title="' 
						, tooltip , '"><span class="' 
						, (label isNilOrEmpty ifTrue: ['toolBarIcon'] ifFalse: ['toolBarIconText']) , ' ' 
						, className , '">' 
						, label asWebString , '</span><span class="toolBarPopUpIcon"></span></a>']
		ifFalse: 
			["use link target instead of window.open() due to pop-up blockers"
			| linkScript onMouseDownFromUrlScript htmlLinkTarget |
			linkScript := 'javascript:void(0);'.
			onMouseDownFromUrlScript := nil.
			htmlLinkTarget := nil.
			target == #javaScript 
				ifTrue: [onMouseDownFromUrlScript := url]
				ifFalse: 
					[htmlLinkTarget := target.
					linkScript := url].
			htmlStream 
				nextPutAll: '
<a href="' , linkScript 
						, (htmlLinkTarget isNil ifFalse: ['" target="' , htmlLinkTarget] ifTrue: ['']) , '" id="' 
						, id , '" class="toolBarPopUp"  title="' 
						, tooltip , '"><span' 
						, (onMouseDownFromUrlScript isNil 
								ifFalse: [' onmousedown="' , onMouseDownFromUrlScript , '"']
								ifTrue: ['']) 
							, ' class="' , (label isNilOrEmpty ifTrue: ['toolBarIcon'] ifFalse: ['toolBarIconText']) 
						, ' ' , className 
						, '">' , label asWebString 
						, '</span><span class="toolBarPopUpIcon" onmousedown="' , onMouseDown 
						, '" onclick="return false;"></span></a>'].
	menu generateOn: htmlStream!

topMenuLinks: array 
	| table s label action |
	table := HtmlTable columns: 1.
	table
		cellSpacing: 0;
		cellPadding: 0;
		cellNoWrap.
	table add: '<sup>'.
	s := ReadStream on: array.
	[s atEnd] whileFalse: 
			[label := s next.
			action := s next.
			table
				add: '[';
				add: '<a href="' , urlPrefix , '?action=' , action , '">';
				add: label webTranslate;
				add: '</a>]&nbsp; '].
	table add: '</sup>'.
	table generateOn: htmlStream!

topNavigation
	^topNavigation!

topNavigation: aCollection 
	"Set collection of associations with navigation history links on top of the page.
	e.g.:

		Partner Overview -> Partner No. 3234 -> Edit partner
	"

	topNavigation := aCollection!

topNavigationTabs
	^topNavigationTabs!

topNavigationTabs: aHtmlTabElement 
	"Set tab container element for the selected page."

	topNavigationTabs := aHtmlTabElement!

unsupportedActionPage: actionName

	self errorPage: 'Action *', actionName asWebString, '* is not supported in the current context.'.!

urlForHelpPage: pageName 
	"Answer URL for help page with ID <pageName> which is linked to in the title of the page."

	^self subclassResponsibility!

urlPrefix: urlPrefixString

	urlPrefix := urlPrefixString.!

urlPrefixForAction: aStringOrSymbol 
	"If javascript is sent, don't process it, just leave it the same."

	^(aStringOrSymbol isString and: [aStringOrSymbol beginsWith: 'javascript:']) 
		ifTrue: [aStringOrSymbol]
		ifFalse: 
			[WebTask 
				generateUrlPrefixStringFor: urlPrefix
				action: aStringOrSymbol
				id: nil
				convertAjaxActionToScript: true]!

urlPrefixForAction: aStringOrSymbol id: anObject 
	^WebTask 
		generateUrlPrefixStringFor: urlPrefix
		action: aStringOrSymbol
		id: anObject
		convertAjaxActionToScript: true!

urlPrefixForAction: aStringOrSymbol id: anObject filename: fileName 
	| stream |
	stream := WriteStream on: (String new: 128).
	stream
		nextPutAll: urlPrefix , '/' , fileName;
		nextPutAll: '?action=';
		nextPutAll: aStringOrSymbol webAsActionString.
	anObject isNilOrEmpty 
		ifFalse: 
			[stream
				nextPutAll: '&id=';
				nextPutAll: anObject asWebString].
	^stream contents!

urlPrefixForAction: aStringOrSymbol id: anObject onElement: aElementString 
	"ajaxPostRequestForActionOnElement = ITC.widget.DialogBox.AjaxPostRequestForActionOnElement = function(elForSub, actionForSub, idForSub, urlForSub)"

	| stream |
	stream := WriteStream on: (String new: 128).
	Processor activeProcess attributes at: #javascriptDialogBox put: true.
	stream
		nextPutAll: 'javascript:ajaxPostRequestForActionOnElement(''';
		nextPutAll: aElementString;
		nextPutAll: ''', ''';
		nextPutAll: aStringOrSymbol webAsActionString;
		nextPutAll: ''', ''';
		nextPutAll: anObject asWebString;
		nextPutAll: ''', ''';
		nextPutAll: urlPrefix;
		nextPutAll: ''');void(0);'.
	^stream contents!

warningBox: aString 
	htmlStream 
		nextPutAll: '<table style="width:90%;alignment:center;border:2px solid #a0a0f0;padding:10px;margin-top:10px;margin-bottom:5px;margin-left:20px;margin-right:20px;background:#f0f0f0;"><tr><td><table border="0" cellspacing="5" width="100%" ><tr><td><img src="images/warning2.gif" width="41" height="36" alt=""/></td><td width="100%"><b>' 
				, aString webTranslate asWebString webHtmlEncoded 
					, '</b></td></tr></table></td></tr></table>'!

warningBox2: aString 
	htmlStream 
		nextPutAll: '<table style="width:90%;alignment:center;border:2px solid #a0a0f0;padding:10px;margin-top:10px;margin-bottom:5px;margin-left:20px;margin-right:20px;background:#f0f0f0;"><tr><td><table border="0" cellspacing="5" width="100%" ><tr><td><img src="images/warning2.gif" width="41" height="36" alt=""/></td><td width="100%">' 
				, aString asWebString , '</td></tr></table></td></tr></table>'!

warningText: text 
	htmlStream 
		nextPutAll: '<font class="warning">' , text asWebString webTranslate , '</font>'!

write: aString 
	htmlStream write: aString webTranslate!

writeActionButtons: aCollection 
	^self 
		writeActionButtons: aCollection
		tableClass: nil
		tableStyle: nil!

writeActionButtons: aCollection tableClass: tableClass tableStyle: cssStyle 
	| buttonsTable stream action counter flashingLabel pleaseWaitNotice button label |
	counter := 0.
	stream := ReadStream on: aCollection.
	[stream atEnd] whileFalse: 
			[action := stream next.
			(action = 1 or: [action = 2]) 
				ifFalse: 
					[counter := counter + 1.
					action isString ifTrue: [stream next]]].
	counter > 0 ifFalse: [^self].
	buttonsTable := HtmlTable columns: counter + 1.
	buttonsTable
		cssClass: tableClass;
		cssStyle: cssStyle;
		cellPadding: 0;
		cellSpacing: 1.
	stream := ReadStream on: aCollection.
	[stream atEnd] whileFalse: 
			[(action := stream next) = 1 
				ifTrue: [buttonsTable space]
				ifFalse: 
					[action = 2 
						ifTrue: [buttonsTable space2]
						ifFalse: 
							[action isString 
								ifFalse: 
									[buttonsTable
										add: action;
										nextCell]
								ifTrue: 
									[label := stream next.
									action := action webAsActionString.
									action first = $* 
										ifTrue: 
											[flashingLabel := true.
											action := action copyFrom: 2 to: action size]
										ifFalse: 
											[label first = $* 
												ifTrue: 
													[flashingLabel := true.
													label := label copyFrom: 2 to: label size]
												ifFalse: [flashingLabel := false]].
									action first = $# 
										ifTrue: 
											[pleaseWaitNotice := true.
											action := action copyFrom: 2 to: action size]
										ifFalse: 
											[label first = $# 
												ifTrue: 
													[pleaseWaitNotice := true.
													label := label copyFrom: 2 to: label size]
												ifFalse: [pleaseWaitNotice := false]].
									button := HtmlButton name: 'BUTTON_' , action label: label webTranslate.
									button flashingLabel: flashingLabel.
									(action beginsWith: 'ajaxGet') 
										ifTrue: 
											[self javascriptInclude: #javascriptDialogBox.
											button
												buttonType: 'button';
												onClick: 'ajaxGetRequest(' , (urlPrefix , '?action=' , action) asJavascriptValue , ')']
										ifFalse: 
											[(action beginsWith: 'javascript:') 
												ifTrue: 
													[button
														buttonType: 'button';
														onClick: action]
												ifFalse: 
													[button pleaseWaitNotice: pleaseWaitNotice.
													(action beginsWith: 'ajaxPost') 
														ifTrue: 
															[button
																buttonType: 'button';
																onClick: 'ajaxPostRequestForAction(this,' , action asJavascriptValue , ')']]].
									buttonsTable
										add: button;
										nextCell]]]].
	buttonsTable generateOn: htmlStream!

writeActionButtonsBar: aCollection 
	htmlStream nextPutAll: '<div class="bar" style="padding:2px;"><center>'.
	self 
		writeActionButtons: aCollection
		tableClass: nil
		tableStyle: nil.
	htmlStream nextPutAll: '</center></div>'!

writeActionButtonsBarOk: okAction cancel: cancelAction 
	^self 
		writeActionButtonsBar: (Array with: okAction with: 'asp.button.OK') , (Array 
						with: 2
						with: cancelAction
						with: 'asp.button.Cancel')!

writeActionButtonsCentered: aCollection 
	htmlStream nextPutAll: '<center>'.
	self 
		writeActionButtons: aCollection
		tableClass: nil
		tableStyle: nil.
	htmlStream nextPutAll: '</center>'!

writeActionButtonsLeftBar: aCollection 
	htmlStream nextPutAll: '<div class="bar" style="padding:2px;">'.
	self 
		writeActionButtons: aCollection
		tableClass: nil
		tableStyle: nil.
	htmlStream nextPutAll: '</div>'!

writeBar: aString cssLabelClass: cssLabelClass alignment: labelAlignment toolbarButtons: toolbarButtons alignment: toolbarButtonsAlignment menu: menu alignment: menuAlignment labels: labels actions: actions alignment: buttonAlignment showFlags: showFlags helpPage: helpPageIdOrNil 
	| labelHtml buttonHtml stream helpPageId |
	labelHtml := aString isNilOrEmpty 
				ifTrue: ['']
				ifFalse: 
					['<span class="contentVC ' 
						, (cssLabelClass isNilOrEmpty ifTrue: ['dgTitle'] ifFalse: [cssLabelClass]) , '">' 
						, aString webTranslate , '</span>'].
	stream := WriteStream on: String new.
	actions isNilOrEmpty 
		ifFalse: 
			[actions doWithIndex: 
					[:each :index | 
					| button action label flashingLabel pleaseWaitNotice |
					(showFlags isNil or: [(showFlags at: index) = true]) 
						ifTrue: 
							[stream nextPutAll: '&nbsp;'.
							action := (actions at: index) webAsActionString.
							label := labels at: index.
							action first = $* 
								ifTrue: 
									[flashingLabel := true.
									action := action copyFrom: 2 to: action size]
								ifFalse: 
									[label first = $* 
										ifTrue: 
											[label := label copyFrom: 2.
											flashingLabel := true]
										ifFalse: [flashingLabel := false]].
							action first = $# 
								ifTrue: 
									[pleaseWaitNotice := true.
									action := action copyFrom: 2 to: action size]
								ifFalse: 
									[label first = $# 
										ifTrue: 
											[label := label copyFrom: 2.
											pleaseWaitNotice := true]
										ifFalse: [pleaseWaitNotice := false]].
							(action beginsWith: 'javascript:') 
								ifTrue: 
									[button := HtmlButton name: 'BUTTON_' , ItcSystemManager generateShortRandomString
												label: label webTranslate.
									button flashingLabel: flashingLabel.
									self
										javascriptInclude: #javascriptDataRetriever;
										javascriptInclude: #javascriptDialogBox;
										javascriptInclude: #javascriptCommon.
									button
										buttonType: 'button';
										onClick: action]
								ifFalse: 
									[button := HtmlButton name: 'BUTTON_' , action label: label webTranslate.
									button flashingLabel: flashingLabel.
									(action beginsWith: 'ajaxGet') 
										ifTrue: 
											[self
												javascriptInclude: #javascriptDataRetriever;
												javascriptInclude: #javascriptDialogBox;
												javascriptInclude: #javascriptCommon.
											button
												buttonType: 'button';
												onClick: 'ajaxGetRequest(' , (urlPrefix , '?action=' , action) asJavascriptValue , ')']
										ifFalse: [button pleaseWaitNotice: pleaseWaitNotice]].
							button generateOn: stream]]].
	buttonHtml := '<div class="contentVC">' , stream contents , '</div>'.
	htmlStream nextPutAll: '<div class="bar"><div class="fl">'.
	labelAlignment == #right ifFalse: [htmlStream nextPutAll: labelHtml].
	buttonAlignment == #right ifFalse: [htmlStream nextPutAll: buttonHtml].
	toolbarButtons isNilOrEmpty 
		ifFalse: 
			[toolbarButtonsAlignment == #right 
				ifFalse: 
					[self writeToolbarButtons: toolbarButtons.
					((menuAlignment == #right) not and: [menu notNil and: [menu isEmpty not]]) 
						ifTrue: [self toolbarButtonSeparator]]].
	menuAlignment == #right 
		ifFalse: 
			[(menu isNil or: [menu isEmpty]) 
				ifFalse: 
					[htmlStream nextPutAll: '<span class="contentVC">'.
					menu generateOn: htmlStream.
					htmlStream nextPutAll: '</span>']].
	htmlStream nextPutAll: '</div><div class="fr">'.
	labelAlignment == #right ifTrue: [htmlStream nextPutAll: labelHtml].
	buttonAlignment == #right ifTrue: [htmlStream nextPutAll: buttonHtml].
	toolbarButtons isNilOrEmpty 
		ifFalse: [toolbarButtonsAlignment == #right ifTrue: [self writeToolbarButtons: toolbarButtons]].
	menuAlignment == #right 
		ifTrue: 
			[(menu isNil or: [menu isEmpty]) 
				ifFalse: 
					[htmlStream nextPutAll: '<div class="contentVC">'.
					menu generateOn: htmlStream.
					htmlStream nextPutAll: '</div>']].
	helpPageId := helpPageIdOrNil ifNil: [task isNil ifFalse: [task defaultHelpPageId]].
	helpPageId isNilOrEmpty ifFalse: [self toolbarButtonHelp: helpPageId enabled: true].
	htmlStream nextPutAll: '</div></div>'!

writeBrightBar: aString 
	(self newFormTable: 1)
		background: '#f0f0d0';
		width: '100%';
		cellWidth: '100%';
		addBold: aString webTranslate;
		generateOn: htmlStream!

writePageContents: contents 
	htmlStream write: '<table cellspacing="0" cellpadding="0" width="100%"><tr><td>'.
	htmlWriter pixelWidth: 1 height: 5.
	htmlStream
		write: '</td></tr><tr><td valign="top" align="left"><table><tr><td>';
		writeFragment: contents;
		write: '</td></tr></table></td></tr></table>'!

writeServerMessage
	| attributes |
	application serverMessage isNilOrEmpty ifTrue: [^self].
	attributes := Processor activeProcess attributes.
	(attributes at: #serverMessageDone ifAbsent: []) == true ifTrue: [^self].
	htmlStream 
		write: '<table class="serverMessage"><tr valign="middle"><td align="left" nowrap="nowrap"><font class="serverMessage">[' 
				, Timestamp now asWebString , '] ' 
				, application serverMessage webHtmlEncoded , '</font></td></tr></table>'.
	attributes at: #serverMessageDone put: true!

writeSubtitle: aString 
	htmlStream
		write: '<span class="subTitle">';
		write: aString webTranslate;
		write: '</span><br />'!

writeSubtitle: aString editAction: editAction 
	htmlStream
		write: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle"><font class="subTitle" nowrap="nowrap">';
		write: aString webTranslate;
		write: '&nbsp;</font></td><td valign="middle"><a href="' , (self urlPrefixForAction: editAction) 
					, '"><img src="images/edit.gif" width="23" height="24" border="0" alt=""/></a></td></tr></table>'!

writeSubtitle: aString editAction: editAction showFlag: aBoolean 
	aBoolean = true 
		ifFalse: [self writeSubtitle: aString]
		ifTrue: [self writeSubtitle: aString editAction: editAction]!

writeSubtitle: aString image: image 
	htmlStream
		write: '<table cellpadding="0" cellspacing="0"><tr><td valign="middle"><font class="subTitle">';
		write: aString webTranslate;
		write: '</font></td><td valign="middle"><img src="' , image , '"/></td></tr></table>'!

writeSubtitle: aString withToolbar: fieldPrefix addNewItemAction: addNewItemAction hasCopyAction: hasCopyAction additionalMenu: additionalMenu 
	(fieldPrefix isNil or: [task isBarButtonEditEnabled not and: [additionalMenu isNilOrEmpty]]) 
		ifTrue: [^self writeSubtitle: aString].
	htmlStream
		nextPutAll: '<div style="position:relative;overflow:auto"><div class="fl" style="padding-top:16px"><span class="subTitle">';
		nextPutAll: aString webTranslate;
		nextPutAll: '</span></div>';
		nextPutAll: '<div class="tableBar"><div class="bar">'.
	"Bar is right aligned, so show additional options on left. It is good practice if add. options wanishes after move up/down (transaction isChanged etc.)."
	additionalMenu isNilOrEmpty 
		ifFalse: 
			[additionalMenu menuLayerName: fieldPrefix , '_btnAdditionalOptionsMenu'.
			self 
				toolbarButtonWithMenu: additionalMenu
				id: fieldPrefix , '_btnAdditionalOptionsMenuButton'
				tooltip: 'asp.tooltip.AdditionalOptions' webTranslate
				label: nil
				className: 'itcBgIconAddOptions'
				url: nil
				target: nil
				onMouseDown: 'show_' , fieldPrefix , '_btnAdditionalOptionsMenu(event);'].
	task isBarButtonEditEnabled 
		ifTrue: 
			[additionalMenu isNilOrEmpty ifFalse: [self toolbarButtonSeparator].
			addNewItemAction isNilOrEmpty 
				ifFalse: 
					[self 
						toolbarButton: (self urlPrefixForAction: addNewItemAction)
						id: nil
						target: nil
						tooltip: 'Grid.newRowMessage.short' webTranslate
						label: nil
						className: 'itcBgIconAdd'
						onClick: nil
						enabled: true
						accessKey: nil.
					hasCopyAction = true 
						ifTrue: 
							[self 
								toolbarButton: urlPrefix
								id: fieldPrefix , '_btnCopy'
								target: nil
								tooltip: 'asp.button.Copy' webTranslate
								label: nil
								className: 'itcBgIconCopy'
								onClick: nil
								enabled: false
								accessKey: nil].
					self toolbarButtonSeparator].
			self
				toolbarButton: urlPrefix
					id: fieldPrefix , '_btnRemove'
					target: nil
					tooltip: 'Grid.removeRowMessage.short' webTranslate
					label: nil
					className: 'itcBgIconDelete'
					onClick: nil
					enabled: false
					accessKey: nil;
				toolbarButtonSeparator;
				toolbarButton: urlPrefix
					id: fieldPrefix , '_btnMoveTop'
					target: nil
					tooltip: 'Grid.moveToTopRowMessage.short' webTranslate
					label: nil
					className: 'itcBgIconMoveTop'
					onClick: nil
					enabled: false
					accessKey: nil;
				toolbarButton: urlPrefix
					id: fieldPrefix , '_btnMoveUp'
					target: nil
					tooltip: 'Grid.moveUpRowMessage.short' webTranslate
					label: nil
					className: 'itcBgIconMoveUp'
					onClick: nil
					enabled: false
					accessKey: nil;
				toolbarButton: urlPrefix
					id: fieldPrefix , '_btnMoveDown'
					target: nil
					tooltip: 'Grid.moveDownRowMessage.short' webTranslate
					label: nil
					className: 'itcBgIconMoveDown'
					onClick: nil
					enabled: false
					accessKey: nil;
				toolbarButton: urlPrefix
					id: fieldPrefix , '_btnMoveBottom'
					target: nil
					tooltip: 'Grid.moveToBottomRowMessage.short' webTranslate
					label: nil
					className: 'itcBgIconMoveBottom'
					onClick: nil
					enabled: false
					accessKey: nil].
	htmlStream nextPutAll: '</div></div></div>'!

writeSubtitleBar: aString 
	self 
		writeBar: aString
		cssLabelClass: 'dgSubtitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: nil
		actions: nil
		alignment: nil
		showFlags: nil
		helpPage: nil!

writeSubtitleBar: aString label: label action: action 
	self 
		writeBar: aString
		cssLabelClass: 'dgSubtitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: (Array with: label)
		actions: (Array with: action)
		alignment: #right
		showFlags: #(true)
		helpPage: nil!

writeSubtitleBar: aString label: label action: action label: label2 action: action2 
	self 
		writeBar: aString
		cssLabelClass: 'dgSubtitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: (Array with: label with: label2)
		actions: (Array with: action with: action2)
		alignment: #right
		showFlags: #(true true)
		helpPage: nil!

writeSubtitleBar: aString label: label action: action label: label2 action: action2 label: label3 action: action3 label: label4 action: action4 showFlag: showFlag 
	showFlag = true ifFalse: [^self writeSubtitleBar: aString].
	self 
		writeBar: aString
		cssLabelClass: 'dgSubtitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: (Array 
				with: label
				with: label2
				with: label3
				with: label4)
		actions: (Array 
				with: action
				with: action2
				with: action3
				with: action4)
		alignment: #right
		showFlags: #(true true true true)
		helpPage: nil!

writeSubtitleBar: aString label: label action: action label: label2 action: action2 label: label3 action: action3 showFlag: showFlag 
	showFlag = true ifFalse: [^self writeSubtitleBar: aString].
	self 
		writeBar: aString
		cssLabelClass: 'dgSubtitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: (Array 
				with: label
				with: label2
				with: label3)
		actions: (Array 
				with: action
				with: action2
				with: action3)
		alignment: #right
		showFlags: #(true true true)
		helpPage: nil!

writeSubtitleBar: aString label: label action: action label: label2 action: action2 showFlag: showFlag
	showFlag = true 
		ifFalse: [self writeSubtitleBar: aString]
		ifTrue: 
			[self 
				writeSubtitleBar: aString
				label: label
				action: action
				label: label2
				action: action2]!

writeSubtitleBar: aString label: label action: action label: label2 action: action2 showFlags: showFlags 
	((showFlags at: 1) = true and: [(showFlags at: 2) = true]) 
		ifFalse: 
			[(showFlags at: 1) = true 
				ifTrue: 
					[self 
						writeSubtitleBar: aString
						label: label
						action: action]
				ifFalse: 
					[(showFlags at: 2) = true 
						ifTrue: 
							[self 
								writeSubtitleBar: aString
								label: label2
								action: action2]
						ifFalse: [self writeSubtitleBar: aString]]]
		ifTrue: 
			[self 
				writeSubtitleBar: aString
				label: label
				action: action
				label: label2
				action: action2]!

writeSubtitleBar: aString label: label action: action showFlag: showFlag 
	showFlag = true 
		ifFalse: [self writeSubtitleBar: aString]
		ifTrue: 
			[self 
				writeSubtitleBar: aString
				label: label
				action: action]!

writeSubtitleBar: aString searchField: searchField value: searchFieldValue actions: actions labels: labels showFlags: showFlags 
	| keyPressScript funcName |
	funcName := 'onKeyDown' , ItcSystemManager generateShortRandomString.
	keyPressScript := 'function ' , funcName 
				, '(pEvent) {
		var ev=ITC.event.GetEvent(pEvent);

		if (ITC.event.GetCharCode(ev) == 13) {
			document.form.BUTTON_' 
					, (actions at: 1) 
					, '.click();
			ITC.event.StopEvent(ev);
			return false;
		}
		return true;
	}'.
	htmlStream
		nextPutAll: HtmlElement javascriptBeginString;
		nextPutAll: keyPressScript;
		nextPutAll: HtmlElement javascriptEndString;
		nextPutAll: '<table class="bar" width="100%"><tr valign="middle"><td align="left" width="100%"><font class="dgSubtitle">';
		nextPutAll: aString webTranslate;
		nextPutAll: '</font></td>
<td><input type="text" size="10" name="';
		nextPutAll: searchField;
		nextPutAll: '" value="';
		nextPutAll: searchFieldValue asWebString webHtmlEncodedForForm;
		nextPutAll: '" autocomplete="off" ';
		nextPutAll: (self webRequest isOpera ifTrue: ['onkeypress'] ifFalse: ['onkeydown']);
		nextPutAll: '="';
		nextPutAll: funcName;
		nextPutAll: '(event)"></td>'.
	showFlags doWithIndex: 
			[:each :i | 
			each = true 
				ifTrue: 
					[htmlStream 
						nextPutAll: '<td><input class="button" type="submit" name="BUTTON_' , (actions at: i) , '" value="' 
								, (labels at: i) webTranslate , '"></td>']].
	htmlStream nextPutAll: '</tr></table>'!

writeSubtitleCentered: aString 
	htmlStream
		write: '<p class="subTitle" align="center">';
		write: aString webTranslate webHtmlEncoded;
		write: '</p>'!

writeTaskLink: url label: label 
	htmlStream 
		nextPutAll: '<table cellpadding="2" cellspacing="0"><tr><td><img src="images/task.gif" width="15" height="10"></td><td nowrap="nowrap">'.
	htmlWriter link: url content: label webTranslate.
	htmlStream nextPutAll: '</td></tr></table>'!

writeTaskLink: url label: label inNewWindowWidth: width height: height 
	htmlStream 
		nextPutAll: '<table cellpadding="2" cellspacing="0"><tr><td><img src="images/task.gif" width="15" height="10"></td><td nowrap="nowrap">'.
	htmlWriter 
		linkInNewWindow: url
		content: label webTranslate
		width: 490
		height: 450.
	htmlStream nextPutAll: '</td></tr></table>'!

writeTaskLinkFor: action label: label 
	| url |
	url := action isAjaxAction 
				ifTrue: 
					[Processor activeProcess attributes at: #javascriptDialogBox put: true.
					'javascript:ajaxGetRequest(''' , urlPrefix , '?action=' , action webAsActionString , ''');void(0);']
				ifFalse: [urlPrefix , '?action=' , action webAsActionString].
	self writeTaskLink: url label: label!

writeTaskLinkFor: action label: label inNewWindowWidth: width height: height 
	htmlStream 
		nextPutAll: '<table cellpadding="2" cellspacing="0"><tr><td><img src="images/task.gif" width="15" height="10"></td><td nowrap="nowrap">'.
	htmlWriter 
		linkInNewWindow: urlPrefix , '?action=' , action webAsActionString
		content: label webTranslate
		width: width
		height: height.
	htmlStream nextPutAll: '</td></tr></table>'!

writeTaskLinkFor: action parameters: parameters label: label 
	| url urlParameters |
	urlParameters := WriteStream on: String new.
	parameters isNilOrEmpty 
		ifFalse: 
			[parameters do: 
					[:eachAssociation | 
					urlParameters
						nextPut: $&;
						nextPutAll: eachAssociation key webHttpUrlEncoded;
						nextPut: $=;
						nextPutAll: eachAssociation value webHttpUrlEncoded]].
	url := action isAjaxAction 
				ifTrue: 
					[Processor activeProcess attributes at: #javascriptDialogBox put: true.
					'javascript:ajaxGetRequest(''' , urlPrefix , '?action=' , action webAsActionString 
						, urlParameters contents , ''');void(0);']
				ifFalse: [urlPrefix , '?action=' , action webAsActionString , urlParameters contents].
	self writeTaskLink: url label: label!

writeTaskLinkInNewWindow: url label: label 
	htmlStream 
		nextPutAll: '<table cellpadding="2" cellspacing="0"><tr><td><img src="images/task.gif" width="15" height="10"></td><td nowrap="nowrap">'.
	htmlWriter linkInNewWindow: url content: label webTranslate.
	htmlStream nextPutAll: '</td></tr></table>'!

writeTaskLinkInNewWindowFor: action label: label

	self writeTaskLinkInNewWindow: urlPrefix, '?action=', action label: label!

writeTitle: aString 
	htmlStream write: '<span class="dgTitle">' , aString webTranslate , '</span>'!

writeTitleBar: aString 
	self 
		writeBar: aString
		cssLabelClass: 'dgTitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: nil
		actions: nil
		alignment: nil
		showFlags: nil
		helpPage: nil.
	self writeServerMessage!

writeTitleBar: aString helpPage: pageName 
	self 
		writeBar: aString
		cssLabelClass: 'dgTitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: nil
		actions: nil
		alignment: nil
		showFlags: nil
		helpPage: pageName.
	self writeServerMessage!

writeTitleBar: aString helpPage: pageName goBackAction: goBackAction 
	goBackAction isNil 
		ifTrue: [self writeTitleBar: aString helpPage: pageName]
		ifFalse: 
			[self 
				writeToolbarTitle: aString
				helpPage: pageName
				goBackAction: goBackAction]!

writeTitleBar: aString helpPage: pageName goBackEnabled: aBoolean 
	aBoolean == true 
		ifFalse: [self writeTitleBar: aString helpPage: pageName]
		ifTrue: 
			[self 
				writeToolbarTitle: aString
				helpPage: pageName
				goBackAction: 'goBack']!

writeTitleBar: aString helpUrl: helpUrl 
	"Stara pomoc je onemogocena, ker se ni napisana."

	true ifTrue: [^self writeTitleBar: aString]!

writeTitleBar: aString label: label action: action 
	self 
		writeTitleBar: aString
		label: label
		action: action
		showFlag: true!

writeTitleBar: aString label: label action: action label: label2 action: action2 
	self 
		writeTitleBar: aString
		label: label
		action: action
		label: label2
		action: action2
		showFlag: true!

writeTitleBar: aString label: label action: action label: label2 action: action2 showFlag: showFlag 
	showFlag = true ifFalse: [^self writeTitleBar: aString].
	self 
		writeBar: aString
		cssLabelClass: 'dgTitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: (Array with: label with: label2)
		actions: (Array with: action with: action2)
		alignment: #right
		showFlags: #(true true)
		helpPage: nil.
	self writeServerMessage!

writeTitleBar: aString label: label action: action showFlag: showButton 
	showButton = true ifFalse: [^self writeTitleBar: aString].
	self 
		writeBar: aString
		cssLabelClass: 'dgSubtitle'
		alignment: #left
		toolbarButtons: nil
		alignment: nil
		menu: nil
		alignment: nil
		labels: (Array with: label)
		actions: (Array with: action)
		alignment: #right
		showFlags: #(true)
		helpPage: nil.
	self writeServerMessage!

writeTitleBar: aString searchField: searchField value: searchFieldValue actions: actions labels: labels showFlags: showFlags 
	htmlStream 
		nextPutAll: '<table class="bar" width="100%"><tr valign="middle"><td align="left" width="100%"><font class="dgTitle">' 
				, aString webTranslate , '</font></td>
<td><input type="text" size="10" name="' 
				, searchField , '" value="' 
				, searchFieldValue asWebString webHtmlEncodedForForm , '"></td>'.
	showFlags doWithIndex: 
			[:each :i | 
			each = true 
				ifTrue: 
					[htmlStream 
						nextPutAll: '<td><input class="button" type="submit" name="BUTTON_' 
								, (actions at: i) webAsActionString , '" value="' 
								, (labels at: i) webTranslate , '"></td>']].
	htmlStream nextPutAll: '</tr></table>'.
	self writeServerMessage!

writeTitleBarForForm: aString 
	"Writes title bar for form page where go back action is default."

	^self 
		writeToolbarTitle: aString
		helpPage: nil
		goBackAction: 'default'!

writeTitleBarForForm: aString helpPage: helpPageId 
	"Writes title bar for form page where go back action is default."

	^self 
		writeToolbarTitle: aString
		helpPage: helpPageId
		goBackAction: 'default'!

writeTitleBarWithNavigation: aString 
	^self writeTitleBarWithNavigation: aString helpPage: nil!

writeTitleBarWithNavigation: aString helpPage: helpPageId 
	| buttons |
	buttons := OrderedCollection new.
	buttons
		add: (Array 
					with: #goBack
					with: urlPrefix , '?action=goBack'
					with: nil
					with: task isBarButtonGoBackEnabled);
		add: nil;
		add: (Array 
					with: #createNew
					with: (self urlPrefixForAction: task barButtonCreateNewAction)
					with: nil
					with: task isBarButtonCreateNewEnabled);
		add: (Array 
					with: #copy
					with: (self urlPrefixForAction: task barButtonCopyAction)
					with: nil
					with: task isBarButtonCopyEnabled);
		add: nil;
		add: (Array 
					with: #goToSearch
					with: urlPrefix , '?action=goToSearch'
					with: nil
					with: task isBarButtonSearchEnabled);
		add: (Array 
					with: #showPrevious
					with: urlPrefix , '?action=showPreviousObject'
					with: nil
					with: (task showPreviousLabel isNil or: [task transaction isChanged]) not);
		add: (Array 
					with: #showNext
					with: urlPrefix , '?action=showNextObject'
					with: nil
					with: (task showNextLabel isNil or: [task transaction isChanged]) not);
		add: nil;
		add: (Array 
					with: #edit
					with: (self urlPrefixForAction: task barButtonEditAction)
					with: nil
					with: task isBarButtonEditEnabled);
		add: (Array 
					with: #save
					with: (self urlPrefixForAction: task barButtonSaveAction)
					with: nil
					with: task isBarButtonSaveEnabled);
		add: nil.
	task isBarButtonPrintEnabled 
		ifTrue: [buttons add: (Array 
						with: #print
						with: nil
						with: nil
						with: nil)].
	task isBarButtonDataExchangeEnabled 
		ifTrue: 
			[buttons add: (Array 
						with: #dataExchange
						with: nil
						with: nil
						with: nil)].
	buttons
		add: nil;
		add: (Array 
					with: #sendEmail
					with: nil
					with: nil
					with: nil);
		add: nil;
		add: (Array 
					with: #additionalOptions
					with: nil
					with: nil
					with: nil);
		add: nil;
		add: (Array 
					with: #businessEvents
					with: nil
					with: nil
					with: nil);
		add: nil.
	task isBarButtonAttachImageDocumentEnabled 
		ifTrue: 
			[buttons
				add: (Array 
							with: #attachImageDocument
							with: (self urlPrefixForAction: task barButtonAttachImageDocument)
							with: nil
							with: true);
				add: nil].
	task isBarButtonShowChangeLogEnabled 
		ifTrue: 
			[(self webRequest isAjaxCapableBrowser and: [task respondsTo: #ajaxGetShowChangeLog]) 
				ifTrue: 
					[buttons add: (Array 
								with: #ajaxShowChangeLog
								with: nil
								with: nil
								with: nil)]
				ifFalse: 
					[buttons add: (Array 
								with: #showChangeLog
								with: nil
								with: nil
								with: nil)]].
	task isBarButtonSetConfidentialityLevel 
		ifTrue: 
			[(self webRequest isAjaxCapableBrowser 
				and: [task respondsTo: #ajaxGetSetDocumentConfidentialityLevel]) 
					ifTrue: 
						[buttons add: (Array 
									with: #ajaxShowConfidentialityLevel
									with: nil
									with: nil
									with: nil)]].
	self 
		writeToolbarTitle: aString
		helpPage: helpPageId
		toolbarButtons: buttons!

writeTitleBarWithNavigationNoEdit: aString 
	^self writeTitleBarWithNavigationNoEdit: aString helpPage: nil!

writeTitleBarWithNavigationNoEdit: aString helpPage: helpPageId 
	| buttons |
	buttons := OrderedCollection new.
	buttons
		add: (Array 
					with: #goBack
					with: urlPrefix , '?action=goBack'
					with: nil
					with: task isBarButtonGoBackEnabled);
		add: nil;
		add: (Array 
					with: #createNew
					with: (self urlPrefixForAction: task barButtonCreateNewAction)
					with: nil
					with: task isBarButtonCreateNewEnabled);
		add: (Array 
					with: #copy
					with: (self urlPrefixForAction: task barButtonCopyAction)
					with: nil
					with: task isBarButtonCopyEnabled);
		add: nil;
		add: (Array 
					with: #goToSearch
					with: urlPrefix , '?action=goToSearch'
					with: nil
					with: task isBarButtonSearchEnabled);
		add: (Array 
					with: #showPrevious
					with: urlPrefix , '?action=showPreviousObject'
					with: nil
					with: (task showPreviousLabel isNil or: [task transaction isChanged]) not);
		add: (Array 
					with: #showNext
					with: urlPrefix , '?action=showNextObject'
					with: nil
					with: (task showNextLabel isNil or: [task transaction isChanged]) not);
		add: nil.
	task isBarButtonPrintEnabled 
		ifTrue: [buttons add: (Array 
						with: #print
						with: nil
						with: nil
						with: nil)].
	task isBarButtonDataExchangeEnabled 
		ifTrue: 
			[buttons add: (Array 
						with: #dataExchange
						with: nil
						with: nil
						with: nil)].
	buttons
		add: (Array 
					with: #sendEmail
					with: nil
					with: nil
					with: nil);
		add: (Array 
					with: #additionalOptions
					with: nil
					with: nil
					with: nil);
		add: (Array 
					with: #businessEvents
					with: nil
					with: nil
					with: nil).
	task isBarButtonAttachImageDocumentEnabled 
		ifTrue: 
			[buttons add: (Array 
						with: #attachImageDocument
						with: urlPrefix , '?action=attachImageDocument'
						with: nil
						with: true)].
	self 
		writeToolbarTitle: aString
		helpPage: helpPageId
		toolbarButtons: buttons!

writeToolbarButtons: toolbarButtons 
	| needsSeparator firstButton buttonType urlOrMenu tooltip enabled |
	Processor activeProcess attributes at: #tempToolbarNeedsSeparator put: false.
	firstButton := true.
	toolbarButtons do: 
			[:each | 
			each isNil 
				ifTrue: [needsSeparator := true]
				ifFalse: 
					[needsSeparator = true 
						ifTrue: 
							[needsSeparator := false.
							firstButton = true 
								ifFalse: [Processor activeProcess attributes at: #tempToolbarNeedsSeparator put: true]].
					firstButton := false.
					buttonType := each at: 1.
					urlOrMenu := each at: 2.
					tooltip := each at: 3.
					enabled := each at: 4.
					self 
						toolbarButton: buttonType
						urlOrMenu: urlOrMenu
						toolTip: tooltip
						enabled: enabled]]!

writeToolbarTitle: aString goBackAction: goBackAction 
	^self 
		writeToolbarTitle: aString
		helpPage: nil
		goBackAction: goBackAction!

writeToolbarTitle: aString helpPage: helpPageId 
	self 
		writeToolbarTitle: aString
		helpPage: helpPageId
		toolbarButtons: defaultToolbar!

writeToolbarTitle: aString helpPage: helpPageId goBackAction: goBackAction 
	^self 
		writeToolbarTitle: aString
		helpPage: helpPageId
		toolbarButtons: (Array with: (Array 
						with: #goBack
						with: (goBackAction isNilOrEmpty 
								ifTrue: [urlPrefix]
								ifFalse: 
									[(goBackAction isString and: [goBackAction beginsWith: 'javascript:']) 
										ifTrue: [goBackAction]
										ifFalse: [urlPrefix , '?action=' , goBackAction webAsActionString]])
						with: nil
						with: true))!

writeToolbarTitle: aString helpPage: helpPageIdOrNil toolbarButtons: toolbarButtons 
	| helpPageId |
	helpPageId := helpPageIdOrNil ifNil: [task defaultHelpPageId].
	toolbarButtons isNilOrEmpty ifTrue: [^self writeTitleBar: aString helpPage: helpPageId].
	htmlStream nextPutAll: '<div class="bar">'.
	self writeToolbarButtons: toolbarButtons.
	htmlStream
		nextPutAll: '<div class="fr"><div class="dgTitle">';
		nextPutAll: aString webTranslate;
		nextPutAll: '</div>'.
	helpPageId isNilOrEmpty ifFalse: [self toolbarButtonHelp: helpPageId enabled: true].
	htmlStream nextPutAll: '</div></div>'.
	self writeServerMessage!

writeTopNavigationLinks
	| table fullText |
	(topNavigation isNil or: [topNavigation size < 2]) ifTrue: [^nil].
	table := HtmlTable noSpacing: topNavigation size * 2 - 1.
	self add: '<div style="padding-left:18px;padding-top:5px;padding-bottom:3px;">'.
	1 to: topNavigation size
		do: 
			[:i | 
			i = 1 
				ifFalse: 
					[table
						nextCell;
						cellNoWrap;
						add: '<font class="topnavg">&nbsp;&nbsp;&gt;&nbsp;&nbsp;</font>';
						nextCell].
			fullText := (topNavigation at: i) key.
			table
				cellNoWrap;
				add: '<a href="' , (topNavigation at: i) value , '" title="' , fullText webHtmlEncodedForForm 
							, '"><font class="topnavg">' , (fullText trimToSizeWithDots: 26) webHtmlEncoded 
							, '</font></a>'].
	table generateOn: htmlStream.
	self add: '</div>'.
	(HtmlTable noSpacing: 1)
		addPixel;
		width: '100%';
		cellWidth: '100%';
		cellBackground: '#909090';
		generateOn: htmlStream!

writeTopNavigationTabs
	topNavigationTabs isNil ifFalse: [topNavigationTabs generateOn: htmlStream]!

writeWizardTitle: aString 
	htmlStream
		write: '<font class="wizTitle">';
		write: aString webTranslate;
		write: '</font><br /><br />'! !
!HtmlGenericFormsCoder categoriesFor: #accessDeniedPage!public! !
!HtmlGenericFormsCoder categoriesFor: #add:!public! !
!HtmlGenericFormsCoder categoriesFor: #add:linkTo:!public! !
!HtmlGenericFormsCoder categoriesFor: #addBodyOnLoadScript:!public! !
!HtmlGenericFormsCoder categoriesFor: #addBodyOnUnloadScript:!public! !
!HtmlGenericFormsCoder categoriesFor: #addBold:!public! !
!HtmlGenericFormsCoder categoriesFor: #addHiddenDefaultButton:!public! !
!HtmlGenericFormsCoder categoriesFor: #addHintBoxWithText:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #addJavascript:!public! !
!HtmlGenericFormsCoder categoriesFor: #addLabelText:!public! !
!HtmlGenericFormsCoder categoriesFor: #addSeparator!public! !
!HtmlGenericFormsCoder categoriesFor: #ajaxHtmlFragment!ajax generating!public! !
!HtmlGenericFormsCoder categoriesFor: #application:!public! !
!HtmlGenericFormsCoder categoriesFor: #barCancel:!public! !
!HtmlGenericFormsCoder categoriesFor: #barOk:!public! !
!HtmlGenericFormsCoder categoriesFor: #barOk:cancel:!public! !
!HtmlGenericFormsCoder categoriesFor: #barWaitClockOk:cancel:!public! !
!HtmlGenericFormsCoder categoriesFor: #baseTarget:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #baseUrl:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #bigDiskette:label:action:smallLabel:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #bigDiskette:label:action:target:onClick:!public! !
!HtmlGenericFormsCoder categoriesFor: #break!public! !
!HtmlGenericFormsCoder categoriesFor: #center:!public! !
!HtmlGenericFormsCoder categoriesFor: #charSet:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #code:!public! !
!HtmlGenericFormsCoder categoriesFor: #crashIE6!public! !
!HtmlGenericFormsCoder categoriesFor: #cssStyleGeneratedLinkAdd:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #defaultContentsPageMargin!public! !
!HtmlGenericFormsCoder categoriesFor: #defaultToolbar!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #defaultToolbar:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #emptyPage!public! !
!HtmlGenericFormsCoder categoriesFor: #errorPage:!public! !
!HtmlGenericFormsCoder categoriesFor: #errorPage:backAction:!public! !
!HtmlGenericFormsCoder categoriesFor: #errorPageWithHeader:!public! !
!HtmlGenericFormsCoder categoriesFor: #errorText:!public! !
!HtmlGenericFormsCoder categoriesFor: #evaluateBlockAndGetContentsString:!generating page element!private! !
!HtmlGenericFormsCoder categoriesFor: #favoritesIconUrl!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #favoritesIconUrl:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #fieldGroupNamed:contents:!public! !
!HtmlGenericFormsCoder categoriesFor: #for:bottomSubmitPageIndex:table:doWithIndex:!overview table support!public! !
!HtmlGenericFormsCoder categoriesFor: #for:page:table:doWithIndex:!overview table support!public! !
!HtmlGenericFormsCoder categoriesFor: #for:topPageIndex:smallTable:addHeaderBlock:doWithIndex:!overview table support!public! !
!HtmlGenericFormsCoder categoriesFor: #for:topPageIndex:table:addHeaderBlock:doWithIndex:!overview table support!public! !
!HtmlGenericFormsCoder categoriesFor: #for:topPageIndex:table:addHeaderBlock:itemsPerPage:doWithIndex:!overview table support!public! !
!HtmlGenericFormsCoder categoriesFor: #for:topPageIndex:table:addHeaderBlock:itemsPerPage:emptyLineBefore:doWithIndex:!overview table support!public! !
!HtmlGenericFormsCoder categoriesFor: #for:topSubmitPageIndex:table:addHeaderBlock:doWithIndex:!overview table support!public! !
!HtmlGenericFormsCoder categoriesFor: #form2Page:focusField:defaultAction:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #form2Page:focusField:defaultAction:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #form2PageWithHeader:focusField:defaultAction:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPage:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPage:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPage:focusField:defaultAction:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPage:focusField:defaultAction:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPage:focusField:defaultAction:refresh:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPage:title:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPageWithHeader:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPageWithHeader:focusField:defaultAction:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPageWithHeader:focusField:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPageWithHeaderAndMargin:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPageWithHeaderAndMargin:focusField:defaultAction:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #formPageWithHeaderAndMargin:focusField:defaultAction:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #genericScrollableForm:bottomContents:!generic forms!public! !
!HtmlGenericFormsCoder categoriesFor: #getFocusFieldFrom:errors:!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPage:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPage:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPage:focusField:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPage:focusField:refresh:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPage:title:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPage2:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPageWithHeader:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPageWithHeader:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPageWithHeader:focusField:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPageWithHeaderAndMargin:focusField:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlPageWithHeaderAndMargin:focusField:onLoad:!generating page element!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlStream!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlStream:!public! !
!HtmlGenericFormsCoder categoriesFor: #htmlWriter!public! !
!HtmlGenericFormsCoder categoriesFor: #inlineEditableActionFor:!public!url and action format! !
!HtmlGenericFormsCoder categoriesFor: #javascriptAdd:!accessing!javascript!public! !
!HtmlGenericFormsCoder categoriesFor: #javascriptAddExternalLink:!accessing!javascript!public! !
!HtmlGenericFormsCoder categoriesFor: #javascriptInclude:!accessing!javascript!public! !
!HtmlGenericFormsCoder categoriesFor: #labelText:!public! !
!HtmlGenericFormsCoder categoriesFor: #labelTextRaw:!public! !
!HtmlGenericFormsCoder categoriesFor: #linkForHelpPage:with:!public! !
!HtmlGenericFormsCoder categoriesFor: #messagePage:message:backAction:!public! !
!HtmlGenericFormsCoder categoriesFor: #messagePage:message:backAction:onLoad:!public! !
!HtmlGenericFormsCoder categoriesFor: #newFormTable:!public! !
!HtmlGenericFormsCoder categoriesFor: #newListTable:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewBarActions:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewBarActions:labels:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewBarActions:labels:showFlags:sideMenu:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewBarRightActions:labels:showFlags:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewMenuBar:actions:labels:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewMenuBar:actions:labels:showFlags:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewMenuBar:actions:labels:showFlags:align:!public! !
!HtmlGenericFormsCoder categoriesFor: #overviewMenuBar:align:actions:labels:showFlags:align:!private! !
!HtmlGenericFormsCoder categoriesFor: #pageExpiredMessage!public! !
!HtmlGenericFormsCoder categoriesFor: #pageTitle:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #paragraph:!public! !
!HtmlGenericFormsCoder categoriesFor: #paragraph2:!public! !
!HtmlGenericFormsCoder categoriesFor: #paragraphRight:!public! !
!HtmlGenericFormsCoder categoriesFor: #parentGoToUrl:!public! !
!HtmlGenericFormsCoder categoriesFor: #printableDocument:label:action:word:excel:!public! !
!HtmlGenericFormsCoder categoriesFor: #printableDocumentRealPdf:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #printableDocumentRtf:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #printableDocumentRtfPdf:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #printableDocumentWordPdf:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #printAction:label:!public! !
!HtmlGenericFormsCoder categoriesFor: #promptPage:title:actions:labels:!public! !
!HtmlGenericFormsCoder categoriesFor: #promptPage:title:actions:labels:hiddenId:!public! !
!HtmlGenericFormsCoder categoriesFor: #promptPage2:title:actions:labels:hiddenId:!public! !
!HtmlGenericFormsCoder categoriesFor: #promptPage2:title:actions:labels:hiddenId:goBackAction:helpPage:!public! !
!HtmlGenericFormsCoder categoriesFor: #redirectedUrlFor:!public! !
!HtmlGenericFormsCoder categoriesFor: #session:!public! !
!HtmlGenericFormsCoder categoriesFor: #sessionURLPrefix:!public! !
!HtmlGenericFormsCoder categoriesFor: #singleLineBorderGreyBackground:!public! !
!HtmlGenericFormsCoder categoriesFor: #singleLineBorderGreyBackground:height:!public! !
!HtmlGenericFormsCoder categoriesFor: #singleLineBorderWhiteBackground:!public! !
!HtmlGenericFormsCoder categoriesFor: #singleLineBorderWhiteBackground:padding:!public! !
!HtmlGenericFormsCoder categoriesFor: #smallBreak!public! !
!HtmlGenericFormsCoder categoriesFor: #smallerBreak!public! !
!HtmlGenericFormsCoder categoriesFor: #smallLink:for:!public! !
!HtmlGenericFormsCoder categoriesFor: #space!public! !
!HtmlGenericFormsCoder categoriesFor: #style!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #style:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #styleAdd:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #styleLinkAdd:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #styleLinks!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #styleLinks:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #task:urlPrefix:!public! !
!HtmlGenericFormsCoder categoriesFor: #text:!public! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButton:id:target:tooltip:label:className:onClick:enabled:accessKey:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButton:urlOrMenu:toolTip:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonAdditionalOptions!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonAjaxSetConfidentialityLevel!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonAjaxShowChangeLog!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonAttachImageDocument:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonBusinessEvents!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonCopy:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonCreateNew:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonDataExchange!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonEdit:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonGoBack:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonGoToSearch:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonHelp:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonHtmlString:id:target:tooltip:label:className:onClick:enabled:accessKey:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonOverviewAdditionalOptions:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonOverviewExportCSV:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonOverviewExportExcel:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonOverviewPrint:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonPrint!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonPrintDocumentName!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonPrintMenu!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonSave:enabled:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonSendEmail!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonSeparator!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonSeparatorHtmlString!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonShowChangeLog!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonShowNext:enabled:tooltip:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonShowPrevious:enabled:tooltip:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #toolbarButtonWithMenu:id:tooltip:label:className:url:target:onMouseDown:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #topMenuLinks:!public! !
!HtmlGenericFormsCoder categoriesFor: #topNavigation!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #topNavigation:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #topNavigationTabs!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #topNavigationTabs:!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #unsupportedActionPage:!public! !
!HtmlGenericFormsCoder categoriesFor: #urlForHelpPage:!public! !
!HtmlGenericFormsCoder categoriesFor: #urlPrefix:!public! !
!HtmlGenericFormsCoder categoriesFor: #urlPrefixForAction:!public!url and action format! !
!HtmlGenericFormsCoder categoriesFor: #urlPrefixForAction:id:!public!url and action format! !
!HtmlGenericFormsCoder categoriesFor: #urlPrefixForAction:id:filename:!public!url and action format! !
!HtmlGenericFormsCoder categoriesFor: #urlPrefixForAction:id:onElement:!public!url and action format! !
!HtmlGenericFormsCoder categoriesFor: #warningBox:!public! !
!HtmlGenericFormsCoder categoriesFor: #warningBox2:!public! !
!HtmlGenericFormsCoder categoriesFor: #warningText:!public! !
!HtmlGenericFormsCoder categoriesFor: #write:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeActionButtons:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeActionButtons:tableClass:tableStyle:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeActionButtonsBar:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeActionButtonsBarOk:cancel:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeActionButtonsCentered:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeActionButtonsLeftBar:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeBar:cssLabelClass:alignment:toolbarButtons:alignment:menu:alignment:labels:actions:alignment:showFlags:helpPage:!private! !
!HtmlGenericFormsCoder categoriesFor: #writeBrightBar:!public! !
!HtmlGenericFormsCoder categoriesFor: #writePageContents:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeServerMessage!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitle:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitle:editAction:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitle:editAction:showFlag:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitle:image:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitle:withToolbar:addNewItemAction:hasCopyAction:additionalMenu:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:label:action:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:label:action:label:action:label:action:label:action:showFlag:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:label:action:label:action:label:action:showFlag:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:label:action:label:action:showFlag:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:label:action:label:action:showFlags:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:label:action:showFlag:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleBar:searchField:value:actions:labels:showFlags:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeSubtitleCentered:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTaskLink:label:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTaskLink:label:inNewWindowWidth:height:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTaskLinkFor:label:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTaskLinkFor:label:inNewWindowWidth:height:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTaskLinkFor:parameters:label:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTaskLinkInNewWindow:label:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTaskLinkInNewWindowFor:label:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitle:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:helpPage:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:helpPage:goBackAction:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:helpPage:goBackEnabled:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:helpUrl:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:label:action:label:action:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:label:action:label:action:showFlag:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:label:action:showFlag:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBar:searchField:value:actions:labels:showFlags:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBarForForm:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBarForForm:helpPage:!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBarWithNavigation:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBarWithNavigation:helpPage:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBarWithNavigationNoEdit:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeTitleBarWithNavigationNoEdit:helpPage:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeToolbarButtons:!private!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeToolbarTitle:goBackAction:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeToolbarTitle:helpPage:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeToolbarTitle:helpPage:goBackAction:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeToolbarTitle:helpPage:toolbarButtons:!public!toolbar! !
!HtmlGenericFormsCoder categoriesFor: #writeTopNavigationLinks!accessing!public! !
!HtmlGenericFormsCoder categoriesFor: #writeTopNavigationTabs!public! !
!HtmlGenericFormsCoder categoriesFor: #writeWizardTitle:!public! !

!HtmlGenericFormsCoder class methodsFor!

on: aHtmlStream 
	(Processor activeProcess)
		webJavascriptLinksAdd: #javascriptItc;
		webJavascriptLinksAdd: ('javascriptItcLocalization' , Processor activeProcess language) asSymbol;
		webJavascriptLinksAdd: ('javascriptItcTranslation' , Processor activeProcess language) asSymbol.
	^self new htmlStream: aHtmlStream! !
!HtmlGenericFormsCoder class categoriesFor: #on:!public! !

