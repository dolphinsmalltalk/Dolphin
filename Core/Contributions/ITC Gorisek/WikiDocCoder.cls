"Filed out from Dolphin Smalltalk X6.1"!

HtmlGenericFormsCoder subclass: #WikiDocCoder
	instanceVariableNames: 'wikiPageTitle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocCoder guid: (GUID fromString: '{B35A6CC3-FD22-420A-B341-766AD61D31E8}')!
WikiDocCoder comment: ''!
!WikiDocCoder categoriesForClass!Unclassified! !
!WikiDocCoder methodsFor!

addAdminLinkFor: action label: label image: imageName language: languageName 
	| table |
	table := HtmlTable columns: 2.
	table
		cellSpacing: 0;
		cellPadding: 0;
		border: 0.
	table
		addImage: 'images/' , imageName
			width: 16
			height: 17;
		nextCell;
		cellNoWrap;
		add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"><a href="' 
					, (sessionURLPrefix , '?action=' , action webAsActionString , '&lang=' , languageName) 
							webHtmlEncodedForForm 
						, '" title="' , label webHtmlEncodedForForm 
					, '" class="toc">' , label webHtmlEncoded 
					, '</a></div></td></tr></table>'.
	table generateOn: htmlStream!

addSearchResultsNavigationLinksTo: table nextPage: nextPageFirstIndex previousPage: previousPageFirstIndex resultsPerPage: resultsPerPage 
	previousPageFirstIndex isNil 
		ifFalse: 
			[table
				add: '<font size="-1">&lt;&lt;&nbsp;';
				add: '<b>' 
							, ('WikiDoc.SearchResultsLinkPreviousPage' webTranslateWith: resultsPerPage printString) 
								, '</b>'
					linkTo: urlPrefix , '?startIndex=' , previousPageFirstIndex asWebString].
	nextPageFirstIndex isNil 
		ifFalse: 
			[previousPageFirstIndex isNil 
				ifFalse: 
					[table
						space;
						space;
						space].
			table
				add: '<font size="-1">';
				add: '<b>' 
							, ('WikiDoc.SearchResultsLinkNextPage' webTranslateWith: resultsPerPage printString) 
								, '</b>'
					linkTo: urlPrefix , '?startIndex=' , nextPageFirstIndex asWebString;
				add: '&nbsp;&gt;&gt;</font>']!

advanceSearchPage: searchFields 
	| currentLanguage |
	currentLanguage := Processor activeProcess language.
	self wikiPage: 
			[self
				writeToolbar;
				pageContents: 
						[htmlWriter form: (self urlPrefixForAction: #processSearch:on:)
							content: 
								[| table |
								self writeTitle: 'WikiDoc.AdvanceSearchTitle'.
								self paragraph: 
										[table := self newFormTable: 2.
										table
											addLabel: 'WikiDoc.SearchForWordsOrPhrases'
												textField: 'q'
												value: (searchFields at: 'q')
												size: 45;
											addLabel: 'WikiDoc.SearchChapter'.
										(table 
											addDropDownList: 'searchChapter'
											itemsWithNil: (application allNonLeafPageNamesFor: currentLanguage)
											displaySelector: #value
											valueSelector: #key
											value: (searchFields at: 'searchChapter')) cssStyle: 'width:400px'.
										table
											nextCell;
											addLabel: 'WikiDoc.SearchLanguages'
												dropDownList: 'lang'
												itemsWithNil: (application applicationLanguages 
														collect: [:each | Association key: each value: 'asp.language.' , each])
												displaySelector: #translatedValue
												valueSelector: #key
												value: (searchFields at: 'lang');
											break;
											space;
											nextCell;
											addActionButton: #processSearch:on: label: 'asp.button.Search';
											generateOn: htmlStream]]]]
		focusField: 'q'!

defaultContentsPageMargin
	^0!

editPageVersionFormPage: pageVersion errors: errors isNewPage: isNewPageBool previewContents: previewContents 
	| contents form table currentLanguage t2 pageFormat |
	pageFormat := pageVersion pageFormat.
	currentLanguage := Processor activeProcess language.
	contents := pageVersion contents.
	contents isNilOrEmpty 
		ifTrue: 
			[contents := (pageFormat == #wikiDocPageFormatHTML or: [pageFormat == #wikiDocPageFormatPlainHTML]) 
						ifTrue: ['<h1>' , pageVersion page pageName asWebString webHtmlEncoded , '</h1>']
						ifFalse: ['==' , pageVersion page pageName asWebString , '==']].
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[htmlWriter form: (self urlPrefixForAction: #processSave:on:)
							content: 
								[previewContents isNilOrEmpty 
									ifFalse: 
										[self
											writeTitle: 'WikiDoc.PreviewPage';
											add: '<p></p><div style="border:gray 1px solid;background:#f8fff8;padding:2px;"><div id="wikiPageContentsDiv">';
											writeWikiPageContents: previewContents for: pageVersion;
											add: '</div></div>'].
								isNewPageBool = true 
									ifTrue: 
										[table := HtmlTable noSpacing: application applicationLanguages size.
										table
											add: '<h2>';
											add: 'WikiDoc.CreateNewPage' webTranslate;
											add: '</h2>'.
										application applicationLanguages do: 
												[:eachLanguage | 
												eachLanguage = currentLanguage 
													ifFalse: 
														[table
															nextCell;
															cellNoWrap;
															add: '<small>&nbsp;&nbsp;[&nbsp;<a href="' , sessionURLPrefix , '?action=' 
																		, #processCreateNewPage:on: webAsActionString , '&lang=' 
																		, eachLanguage , '"><small>' 
																		, ('WikiDoc.CreateNewPageInLanguage' webTranslateWith: ('asp.language.' , eachLanguage) webTranslate) 
																			, '</small></a>&nbsp;]']].
										table generateOn: htmlStream]
									ifFalse: [self writeTitle: 'WikiDoc.EditPage'].
								form := self newFormTable: 2.
								form
									addHiddenField: 'hiddenButton' value: 'hiddenButton';
									addLabel: 'WikiDoc.pageName';
									add: (t2 := HtmlNoSpacingTable columns: 9);
									nextCell.
								isNewPageBool = true 
									ifTrue: 
										[t2 
											addMandatoryTextField: 'page'
											value: pageVersion page pageName
											errors: errors]
									ifFalse: [t2 addBoldText: pageVersion page pageName].
								t2
									nextCell;
									space2;
									space;
									nextCell.
								t2
									addLabel: 'WikiDoc.pageFormat';
									cellNoWrap;
									addRadioButton: 'pageFormat'
										value: 'wikiDocPageFormatWikiMarkup'
										checked: pageFormat == #wikiDocPageFormatWikiMarkup
										onClick: (pageFormat == #wikiDocPageFormatWikiMarkup 
												ifFalse: ['document.form.hiddenButton.name = ''BUTTON_setPageFormat'';document.form.submit();']);
									space;
									labelText: 'WikiDoc.pageFormat.wikiMarkup';
									nextCell;
									space;
									nextCell;
									cellNoWrap;
									addRadioButton: 'pageFormat'
										value: 'wikiDocPageFormatHTML'
										checked: pageFormat == #wikiDocPageFormatHTML
										onClick: (pageFormat == #wikiDocPageFormatHTML 
												ifFalse: ['document.form.hiddenButton.name = ''BUTTON_setPageFormat'';document.form.submit();']);
									space;
									labelText: 'WikiDoc.pageFormat.HTML';
									nextCell;
									space;
									nextCell;
									cellNoWrap;
									addRadioButton: 'pageFormat'
										value: 'wikiDocPageFormatPlainHTML'
										checked: pageFormat == #wikiDocPageFormatPlainHTML
										onClick: (pageFormat == #wikiDocPageFormatPlainHTML 
												ifFalse: ['document.form.hiddenButton.name = ''BUTTON_setPageFormat'';document.form.submit();']);
									space;
									labelText: 'WikiDoc.pageFormat.PlainHTML'.
								form
									addLabel: 'WikiDoc.pageTitle'
										textField: #pageTitle
										valueFrom: pageVersion
										size: 65
										errors: errors;
									addLabel: 'WikiDoc.parentPage'.
								(form 
									addDropDownList: 'parentPage'
									itemsWithNil: ((application allNonLeafPageNamesFor: currentLanguage) 
											reject: [:each | each key = pageVersion page pageName])
									displaySelector: #value
									valueSelector: #key
									value: pageVersion parentPage) cssStyle: 'width:400px'.
								form
									nextCell;
									addLabel: 'WikiDoc.pagePosition';
									add: ((HtmlTable noSpacing: 12)
												addTextField: 'pagePosition'
													valueFrom: pageVersion
													size: 4
													errors: errors;
												nextCell;
												cellNoWrap;
												space;
												nextCell;
												addBooleanField: 'isLeafPage' value: pageVersion isLeafPage;
												nextCell;
												space;
												nextCell;
												labelText: 'WikiDoc.isLeafPage';
												nextCell;
												space;
												nextCell;
												addRadioButton: 'nodeIcon'
													value: 'page1.gif'
													checked: pageVersion tocNodeIcon = 'page1.gif';
												nextCell;
												addImage: 'images/page1.gif'
													width: 16
													height: 17;
												nextCell;
												addRadioButton: 'nodeIcon'
													value: 'page2.gif'
													checked: pageVersion tocNodeIcon = 'page2.gif';
												nextCell;
												addImage: 'images/page2.gif'
													width: 16
													height: 17;
												nextCell;
												addRadioButton: 'nodeIcon'
													value: 'page3.gif'
													checked: pageVersion tocNodeIcon = 'page3.gif';
												nextCell;
												addImage: 'images/page3.gif'
													width: 16
													height: 17;
												yourself);
									generateOn: htmlStream.
								form := self newFormTable: 1.
								form
									width: '100%';
									cellWidthPc: 100.
								(pageFormat == #wikiDocPageFormatWikiMarkup or: [pageFormat == #wikiDocPageFormatPlainHTML]) 
									ifTrue: 
										[form 
											addTextArea: 'pageContents'
											value: contents
											columns: 80
											rows: 26
											errors: errors]
									ifFalse: 
										[form 
											addHtmlEditor: 'pageContents'
											value: contents
											columns: nil
											rows: 15
											errors: errors].
								form
									nextCell;
									labelText: 'WikiDoc.keywordsSeparatedByComma' webTranslate , ':';
									nextCell;
									addTextField: 'keywords'
										value: pageVersion keywordsSeparatedByComma
										size: 100
										errors: errors;
									generateOn: htmlStream.
								(self newFormTable: 4)
									addLabel: 'WikiDoc.pageValidFrom'
										dateField: 'dateFrom'
										value: pageVersion dateFrom;
									addLabel: 'WikiDoc.pageValidTo'
										dateField: 'dateTo'
										value: pageVersion dateTo;
									generateOn: htmlStream.
								self 
									writeActionButtons: #(#processSave:on: 'asp.button.Save' 1 #processPreview:on: 'WikiDoc.PreviewPage' 1 #processGoBack:on: 'asp.button.Cancel')]]]
		focusField: ((pageFormat == #wikiDocPageFormatWikiMarkup 
				or: [pageFormat == #wikiDocPageFormatPlainHTML]) 
					ifTrue: 
						["only text-area can get focus, FCKEditor gets it automatically"
						'pageContents'])!

fileUploadFormField: table formName: formName uploadAction: uploadAction removeAction: removeAction removeLabel: removeLabel labelText1: labelText1 labelText2: labelText2 fileDocument: fileDocument hiddenFields: hiddenFields 
	| form |
	table add: ((self newFormTable: 2)
				background: '#f0f0f0';
				addLabel: 'asp.label.UploadFile';
				add: ((form := HtmlFileUploadForm name: formName action: (self urlPrefixForAction: uploadAction))
							add: '<input type="file" name="fileName">';
							break;
							break;
							addActionButton: uploadAction label: 'asp.button.UploadFile';
							yourself)).
	hiddenFields isNil 
		ifFalse: 
			[hiddenFields keysAndValuesDo: [:eachKey :eachValue | form addHiddenField: eachKey value: eachValue]].
	fileDocument isNil 
		ifFalse: 
			[table add: ((self newFormTable: 2)
						labelText: labelText1;
						break;
						break;
						add: '<a href="files-wiki/' 
									, fileDocument fileName webHttpUrlEncodedForPathComponent webHtmlEncodedForForm 
										, '"><img src="images/download.gif" width="36" height="36" border="0"/></a>';
						break;
						addSmall: 'Dokument.imeDatoteke' webTranslate , ': ' , fileDocument fileName , '<br />' 
									, 'Dokument.fileSize' webTranslate , ': ' 
									, (fileDocument fileSize / 1024.0) asWebString , 'kB';
						break;
						break;
						labelText: labelText2;
						break;
						break;
						add: ((form := HtmlForm name: formName , '_d2' action: (self urlPrefixForAction: removeAction)) 
									add: ((self newFormTable: 1)
											addActionButton: removeAction label: removeLabel;
											yourself))).
			hiddenFields isNil 
				ifFalse: 
					[hiddenFields keysAndValuesDo: [:eachKey :eachValue | form addHiddenField: eachKey value: eachValue]]]!

fileUploadPage: wikiFile errors: errors fileName: fileName 
	| table |
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[self
							writeTitle: ('WikiDoc.UploadFileTitleWith' webTranslateWith: fileName);
							break.
						table := self newFormTable: 1.
						table 
							addFormFieldErrorTextFor: 'fileName'
							from: errors
							break: false.
						self 
							fileUploadFormField: table
							formName: 'form'
							uploadAction: #processUploadFile:on:
							removeAction: #processRemoveFile:on:
							removeLabel: 'WikiDoc.RemoveFile'
							labelText1: 'WikiDoc.CurrentFile'
							labelText2: 'WikiDoc.DeleteFileText'
							fileDocument: wikiFile
							hiddenFields: nil.
						table generateOn: htmlStream]]
		focusField: 'fileName'!

getCollapsedContentsForNode: each 
	| table ws |
	table := HtmlTable columns: 2.
	table
		cellSpacing: 0;
		cellPadding: 0;
		border: 0.
	each children isNilOrEmpty 
		ifTrue: 
			[table
				addImage: 'images/' , each nodeIcon
					width: 16
					height: 17;
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"><a href="' 
							, urlPrefix , '?page=' 
							, each pageName webHttpUrlEncoded , '&lang=' 
							, each languageName , '" title="' 
							, each title webHtmlEncodedForForm , '" class="toc">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
								, '</a></div></td></tr></table>';
				nextCell]
		ifFalse: 
			[table
				addImage: 'images/book1.gif'
					width: 16
					height: 17
					onClick: 'expandOrCollapse_' , each nodeIndex printString , '();'
					cssStyle: 'cursor:pointer;cursor:hand;';
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"><a href="' 
							, urlPrefix , '?page=' 
							, each pageName webHttpUrlEncoded , '&lang=' 
							, each languageName , '" title="' 
							, each title webHtmlEncodedForForm , '" class="toc" onclick="javascript:expandOrCollapse_' 
							, each nodeIndex printString , '();" target="' 
							, baseTarget , '">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
								, '</a></div></td></tr></table>'].
	ws := WriteStream on: String new.
	each children isNilOrEmpty 
		ifTrue: [table generateOn: ws]
		ifFalse: 
			[ws nextPutAll: '<div id="tree_node_'.
			each nodeIndex printOn: ws.
			ws nextPutAll: '">'.
			table generateOn: ws.
			ws nextPutAll: '</div>'].
	^ws contents!

getCollapsedContentsForNodeLink: each 
	| table ws |
	table := HtmlTable columns: 2.
	table
		cellSpacing: 0;
		cellPadding: 0;
		border: 0.
	each children isNilOrEmpty 
		ifTrue: 
			[table
				addImage: 'images/' , each nodeIcon
					width: 16
					height: 17;
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div id="' 
							, each pageName 
								, '";class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"ondblclick="onDoubleClick(''' 
								, each pageName , ''');"'.
			table
				add: '><a href="javascript:clickOnKazalo(''' , each pageName , ''')" title="' 
							, each title webHtmlEncodedForForm , '"class="toc" target="' 
							, baseTarget , '">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
								, '</a></div></td></tr></table>';
				nextCell]
		ifFalse: 
			[table
				addImage: 'images/book1.gif'
					width: 16
					height: 17
					onClick: 'expandOrCollapse_' , each nodeIndex printString , '();'
					cssStyle: 'cursor:pointer;cursor:hand;';
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div id="' 
							, each pageName 
								, '";class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"ondblclick="onDoubleClick(''' 
								, each pageName , ''');"'.
			table 
				add: '><a href="javascript:expandOrCollapse_' , each nodeIndex printString , '(''' , each pageName 
						, ''')" title=" ' , each title webHtmlEncodedForForm 
						, '" class="toc"  target="' , baseTarget 
						, '">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
							, '</a></div></td></tr></table>'].
	ws := WriteStream on: String new.
	each children isNilOrEmpty 
		ifTrue: [table generateOn: ws]
		ifFalse: 
			[ws nextPutAll: '<div id="tree_node_'.
			each nodeIndex printOn: ws.
			ws nextPutAll: '">'.
			table generateOn: ws.
			ws nextPutAll: '</div>'].
	^ws contents!

getExpandedContentsForNode: each 
	| table ws |
	table := HtmlTable columns: 2.
	table
		cellSpacing: 0;
		cellPadding: 0;
		border: 0.
	each children isNilOrEmpty 
		ifTrue: 
			[table
				addImage: 'images/' , each nodeIcon
					width: 16
					height: 17;
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"><a href="' 
							, urlPrefix , '?page=' 
							, each pageName webHttpUrlEncoded , '&lang=' 
							, each languageName , '" title="' 
							, each title webHtmlEncodedForForm , '" class="toc">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
								, '</a></div></td></tr></table>';
				nextCell]
		ifFalse: 
			[table
				addImage: 'images/book2.gif'
					width: 16
					height: 17
					onClick: 'expandOrCollapse_' , each nodeIndex printString , '();'
					cssStyle: 'cursor:pointer;cursor:hand;';
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"><a href="' 
							, urlPrefix , '?page=' 
							, each pageName webHttpUrlEncoded , '&lang=' 
							, each languageName , '" title="' 
							, each title webHtmlEncodedForForm , '" class="toc" target="' 
							, baseTarget , '">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
								, '</a></div></td></tr></table>';
				nextCell;
				addPixelWidth: 16;
				nextCell.
			each children do: [:eachChild | table add: (self getCollapsedContentsForNode: eachChild)]].
	ws := WriteStream on: String new.
	table generateOn: ws.
	^ws contents!

getExpandedContentsForNodeLink: each 
	| table ws |
	table := HtmlTable columns: 2.
	table
		cellSpacing: 0;
		cellPadding: 0;
		border: 0.
	each children isNilOrEmpty 
		ifTrue: 
			[table
				addImage: 'images/' , each nodeIcon
					width: 16
					height: 17;
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';" "ondblclick="onDoubleClick(''' 
							, each pageName , ''');"><a href="javascript:clickOnKazalo(''' 
							, each pageName , ''')" title=" ' 
							, each title webHtmlEncodedForForm , '"" class="toc" target="' 
							, baseTarget , '">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
								, ' </a></div></td></tr></table>';
				nextCell]
		ifFalse: 
			[table
				addImage: 'images/book2.gif'
					width: 16
					height: 17
					onClick: 'expandOrCollapse_' , each nodeIndex printString , '();'
					cssStyle: 'cursor:pointer;cursor:hand;';
				nextCell;
				cellNoWrap;
				add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div id="' 
							, each pageName 
								, '";class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';""ondblclick="onDoubleClick(''' 
								, each pageName , ''');"><a href="javascript:expandOrCollapse_' 
							, each nodeIndex printString , '(''' 
							, each pageName , ''')" class="toc" target="' 
							, baseTarget , '">' 
							, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
								, '</a></div></td></tr></table>';
				nextCell;
				addPixelWidth: 16;
				nextCell.
			each children do: [:eachChild | table add: (self getCollapsedContentsForNodeLink: eachChild)]].
	ws := WriteStream on: String new.
	table generateOn: ws.
	^ws contents!

getInnerHtmlForUrl: aStringUrl 
	| url activeProcess newHttpStream oldHttpStream oldHttpRequest oldLanguage oldSession oldWebTask oldWebApplication oldCodePage newHttpRequest |
	url := aStringUrl.
	url isNilOrEmpty ifTrue: [^nil].
	(url beginsWith: 'http://') 
		ifTrue: 
			["not supported yet"
			^nil].
	(url beginsWith: '/') ifFalse: [url := '/' , application urlPrefix , '/' , url].
	oldHttpRequest := self webRequest.
	newHttpRequest := (WebHttpRequest new)
				initializeOnUrl: aStringUrl;
				clientIP: oldHttpRequest clientIP;
				yourself.
	(newHttpRequest header)
		setUserAgent: oldHttpRequest userAgent;
		setCookie: oldHttpRequest header cookie.
	activeProcess := Processor activeProcess.
	oldHttpStream := self webStream.
	oldLanguage := activeProcess language.
	oldSession := activeProcess webSession.
	oldWebTask := activeProcess webTask.
	oldWebApplication := activeProcess webApplication.
	oldCodePage := activeProcess webRequestCodePage.
	newHttpStream := WebHttpStreamForInternalRequests new on: nil.
	
	[(activeProcess
		webStream: newHttpStream;
		webRequest: newHttpRequest;
		attributes) at: #originalHttpRequest put: oldHttpRequest.
	[application servletManager service: newHttpRequest on: newHttpStream] on: Error
		do: 
			[:ex | 
			activeProcess
				webStream: oldHttpStream;
				webRequest: oldHttpRequest.
			ex exitWith: nil]] 
			ensure: 
				[activeProcess
					webApplication: oldWebApplication;
					webStream: oldHttpStream;
					webRequest: oldHttpRequest;
					language: oldLanguage;
					webSession: oldSession;
					webTask: oldWebTask;
					webRequestCodePage: oldCodePage].
	^newHttpStream contents!

getTableOfContentsTableFor: nodes urlPostfix: urlPostfix 
	| table |
	table := HtmlTable columns: 2.
	table
		cellSpacing: 0;
		cellPadding: 0;
		border: 0.
	nodes do: 
			[:each | 
			each children isNilOrEmpty 
				ifTrue: 
					[table
						addImage: 'images/' , each nodeIcon
							width: 16
							height: 17;
						nextCell;
						cellNoWrap;
						add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"><a href="' 
									, urlPrefix , '?page=' 
									, each pageName webHttpUrlEncoded , urlPostfix 
									, '" title="' , each title webHtmlEncodedForForm 
									, '" class="toc">' 
										, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
										, '</a></div></td></tr></table>';
						nextCell]
				ifFalse: 
					[table
						addImage: 'images/book2.gif'
							width: 16
							height: 17;
						nextCell;
						cellNoWrap;
						add: '<table cellpadding="0" cellspacing="0" border="0"><tr><td nowrap="nowrap"><div class="tocNodeText" onmouseover="javascript:this.className=''tocNodeTextHover'';" onmouseout="javascript:this.className=''tocNodeText'';"><a href="' 
									, urlPrefix , '?page=' 
									, each pageName webHttpUrlEncoded , urlPostfix 
									, '" title="' , each title webHtmlEncodedForForm 
									, '" class="toc">' 
										, (each title isNilOrEmpty ifTrue: ['&nbsp;&nbsp;&nbsp;'] ifFalse: [each title webHtmlEncoded]) 
										, '</a></div></td></tr></table>';
						nextCell;
						addPixelWidth: 16;
						nextCell;
						add: (self getTableOfContentsTableFor: each children urlPostfix: urlPostfix);
						nextCell]].
	^table!

highlightedText: aString forIntervals: intervals 
	| str currentIndex startIndex endIndex |
	currentIndex := 1.
	str := ''.
	(intervals asSortedCollection: [:a :b | a first < b first]) do: 
			[:eachInterval | 
			startIndex := eachInterval first.
			endIndex := eachInterval last.
			(startIndex < endIndex and: [startIndex >= currentIndex]) 
				ifTrue: 
					[currentIndex = 1 
						ifTrue: 
							[str := (aString copyFrom: (1 max: startIndex - 250) to: startIndex - 1) webHtmlEncoded]
						ifFalse: 
							[startIndex - currentIndex > 300 
								ifTrue: [^str , (aString copyFrom: currentIndex to: currentIndex + 299) webHtmlEncoded].
							str := str , (aString copyFrom: currentIndex to: startIndex - 1) webHtmlEncoded].
					str := str , '<font style="background:#f0f000">'.
					currentIndex := endIndex min: aString size.
					str size > 500 
						ifTrue: [^str , (aString copyFrom: startIndex to: currentIndex) webHtmlEncoded , '</font>'].
					str := str , (aString copyFrom: startIndex to: currentIndex) webHtmlEncoded.
					str := str , '</font>'.
					currentIndex := currentIndex + 1]].
	currentIndex < aString size 
		ifTrue: 
			[str := str , (aString copyFrom: currentIndex to: (aString size min: currentIndex + 200)) 
								webHtmlEncoded].
	^str!

imageFileUploadFormField: table formName: formName uploadAction: uploadAction removeAction: removeAction removeLabel: removeLabel labelText1: labelText1 labelText2: labelText2 imageDocument: imageDocument hiddenFields: hiddenFields maxWidth: maxWidth maxHeight: maxHeight 
	| form |
	table add: ((self newFormTable: 2)
				background: '#f0f0f0';
				addLabel: 'asp.label.ImageFile';
				add: ((form := HtmlFileUploadForm name: formName action: urlPrefix , '?action=' , uploadAction)
							add: '<input type="file" name="fileName">';
							break;
							break;
							addActionButton: uploadAction label: 'asp.button.UploadFile';
							yourself)).
	hiddenFields isNil 
		ifFalse: 
			[hiddenFields keysAndValuesDo: [:eachKey :eachValue | form addHiddenField: eachKey value: eachValue]].
	imageDocument isNil 
		ifFalse: 
			[table add: ((self newFormTable: 2)
						labelText: labelText1;
						break;
						break;
						add: (imageDocument 
									getImageTagMaxWidth: maxWidth
									maxHeight: maxHeight
									border: 1
									alt: nil);
						break;
						addSmall: 'Dokument.imeDatoteke' webTranslate , ': ' , imageDocument imageName , '<br />' 
									, 'Dokument.imageWidth' webTranslate , ': ' 
									, imageDocument width asWebString , ', ' 
									, 'Dokument.imageHeight' webTranslate , ': ' 
									, imageDocument height asWebString , ', ' 
									, 'Dokument.fileSize' webTranslate , ': ' 
									, (imageDocument fileSize / 1024.0s roundTo: 0.01s) asWebStringWithMinimumDecimals , 'kB';
						break;
						break;
						labelText: labelText2;
						break;
						break;
						add: ((form := HtmlForm name: formName , '_d2' action: urlPrefix , '?action=' , removeAction) 
									add: ((self newFormTable: 1)
											addActionButton: removeAction label: removeLabel;
											yourself))).
			hiddenFields isNil 
				ifFalse: 
					[hiddenFields keysAndValuesDo: [:eachKey :eachValue | form addHiddenField: eachKey value: eachValue]]]!

imageUploadPage: wikiImage errors: errors imageName: imageName 
	| table |
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[self
							writeTitle: ('WikiDoc.UploadImageTitleWith' webTranslateWith: imageName);
							break.
						table := self newFormTable: 1.
						table 
							addFormFieldErrorTextFor: 'imageName'
							from: errors
							break: false.
						self 
							imageFileUploadFormField: table
							formName: 'form'
							uploadAction: #processUploadImage:on:
							removeAction: #processRemoveImage:on:
							removeLabel: 'WikiDoc.RemoveImage'
							labelText1: 'WikiDoc.CurrentImage'
							labelText2: 'WikiDoc.DeleteImageText'
							imageDocument: wikiImage
							hiddenFields: nil
							maxWidth: 600
							maxHeight: 100.
						table generateOn: htmlStream]]
		focusField: 'fileName'!

importInnerHtmlForDivsWithExternalSourceOn: htmlString 
	"Special wiki feature which allows including other wiki or local web pages in the same page without having to use IFRAME tag.

	All strings:  <div src=''localUrl''></div> will be replaced with the HTML fragment answered at that URL."

	| rs ws str url |
	rs := ReadStream on: htmlString.
	ws := WriteStream on: (String new: rs size).
	[rs atEnd] whileFalse: 
			[str := rs itcUpToAll: '<div src="'.
			ws nextPutAll: str.
			rs atEnd 
				ifFalse: 
					[url := rs upTo: $".
					(str := self getInnerHtmlForUrl: url) isNil ifFalse: [ws nextPutAll: str].
					rs atEnd 
						ifFalse: 
							[rs upTo: $>.
							rs atEnd ifFalse: [rs itcUpToAll: '</div>']]]].
	^ws contents!

isOldBrowserCompatibilityMode: webRequest 
	^(webRequest isInternetExplorer not and: [webRequest isMozilla not]) 
		or: [webRequest isIndexingRobotOrWebSpider]!

loginPage: loginMessage 
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[htmlWriter form: urlPrefix
							content: 
								[| table |
								self
									writeTitle: 'WikiDoc.LoginRequired';
									paragraph2: 'WikiDoc.EnterUsernameAndPassword'.
								table := self newFormTable: 2.
								table
									addHiddenField: 'lang' value: Processor activeProcess language;
									addLabel: 'asp.user.Username'
										textField: 'uid'
										value: nil
										errors: (loginMessage isNil 
												ifFalse: 
													[(LookupTable new)
														at: 'uid' put: loginMessage;
														yourself]);
									addLabel: 'asp.user.Password'
										passwordField: 'pwd'
										value: nil
										errors: nil;
									space;
									nextCell;
									addActionButton: 'submit' label: 'asp.button.Login';
									generateOn: htmlStream]]]
		focusField: 'uid'!

pageContents: aBlock 
	^self pageContents: aBlock pageVersion: nil!

pageContents: aBlock pageVersion: pageVersion 
	self add: '<div style="padding-left:15px;">'.
	aBlock value.
	self 
		add: '</div><div style="padding-left:15px;font-size:9pt;font-family:arial,helvetica,sans-serif;">---'.
	pageVersion isNil 
		ifFalse: 
			[self
				add: '<br />';
				add: (pageVersion versionInfoFor: session)].
	self
		add: '<br />';
		showEndOfPageDisclaimerFragment;
		add: '</div>'!

showControlPanelPage
	| table |
	self wikiPage: 
			[self
				writeToolbar;
				pageContents: 
						[htmlStream nextPutAll: '<h2>Server status</h2>
<p>'.
						table := self newFormTable: 2.
						table
							addLabel: 'Wiki database installed at'
								data: (OmniBase currentTransaction root at: 'InstallationInfo' ifAbsent: []);
							addLabel: 'HTTP Server started at' data: WebHttpServer current serverStartedTS;
							addLabel: 'Active sessions' data: application activeSessions size.
						table generateOn: htmlStream.
						htmlStream nextPutAll: '</p>']]
		focusField: nil!

showEndOfPageDisclaimerFragment
	self
		add: 'WikiDoc&nbsp;';
		add: application currentReleaseId;
		add: '&nbsp;&copy;&nbsp;David&nbsp;Gorišek&nbsp;2004-2008'!

showEndOfPageDisclaimerFragmentForPrint
	self
		add: '<small>---<br />WikiDoc&nbsp;';
		add: application currentReleaseId;
		add: '<br />&copy;&nbsp;David&nbsp;Gorišek&nbsp;2004-2008</small>'!

showLastSessionsList: wikiSessions 
	| table currentLanguage transaction |
	currentLanguage := Processor activeProcess language.
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[htmlStream nextPutAll: '<h2>' , 'Recent sessions' webTranslate , '</h2>
<p>'.
						wikiSessions size < 20 
							ifFalse: 
								[self 
									add: '<a href="' , urlPrefix , '?action=' , #processRecentSessions:on: webAsActionString , '&lang=' 
											, currentLanguage , '&last=' 
											, wikiSessions last key asWebString , '" title="' 
											, 'Show older sessions' webTranslate , '"><small>' 
											, 'Older sessions...' webTranslate , '</small></a>'].
						table := self newListTable: 6.
						table
							addHeader: 'Timestamp';
							addHeader: 'IP';
							addHeader: 'Hostname';
							addHeader: 'Username';
							addHeader: 'User agent';
							addHeader: 'Referer'.
						transaction := OmniBase currentTransaction.
						wikiSessions do: 
								[:eachAsoc | 
								| each |
								each := eachAsoc value.
								table
									cellNoWrap;
									addField: each loginTS asShortWebString
										linkTo: (self urlPrefixForAction: #processShowSession:on: id: eachAsoc key asWebString).
								each user isNil 
									ifFalse: 
										["if user has logged in, then display version numbers in the database in case we need to go back to some old version of documentation - mostly due to inexperienced users spoiling TOC"
										table
											break;
											add: (transaction getVersionNumberOfFirstObjectVersionFor: each) asWebString , ' / ' 
														, (transaction getVersionNumberOfCurrentObjectVersionFor: each) asWebString].
								table
									nextCell;
									addData: each loginIP;
									addData: each loginHostname;
									addData: (each user isNil ifFalse: [each user username]);
									addData: each loginUserAgent;
									addData: each referer].
						wikiSessions size < 20 
							ifFalse: 
								[table 
									add: '<br /><a href="' , urlPrefix , '?action=' , #processRecentSessions:on: webAsActionString 
											, '&lang=' , currentLanguage 
											, '&last=' , wikiSessions last key asWebString 
											, '" title="' , 'Show older sessions' webTranslate 
											, '"><small>' , 'Older sessions...' webTranslate 
											, '</small></a>'].
						table generateOn: htmlStream.
						htmlStream nextPutAll: '</p>']]
		focusField: nil!

showPageVersion: pageVersion 
	"Show WikiDoc page version."

	"record that user has requested the page view"

	| contents printUrl node mutex tocNodeIndex str |
	(mutex := session sessionData at: #statMutex ifAbsent: []) isNil 
		ifFalse: 
			[mutex critical: 
					[((session sessionData at: #pageViews) 
						at: Processor activeProcess language , '\\' , pageVersion page pageName
						ifAbsentPut: [OrderedCollection new]) add: Timestamp now]].
	"---"
	printUrl := sessionURLPrefix , '?page=' , pageVersion page pageName webHttpUrlEncoded , '&lang=' 
				, Processor activeProcess language.
	contents := pageVersion contents.
	self wikiPage: 
			["ce je kazalo ze nalozeno potem razsiri kazalo, ce pa frame s kazalom sploh ne obstaja ali pa je v napacnem jeziku potem pa ponovno nalozi stran skupaj s kazalom"
			self webRequest isIndexingRobotOrWebSpider 
				ifFalse: 
					[htmlWriter 
						javascript: 'var p; if(top.mainFrame) p=top.mainFrame; else p=top;if(!!p.tocSearchFormFrame || (p.tocFrame && p.tocFrame.tocLanguage && p.tocFrame.tocLanguage!!="' 
								, Processor activeProcess language , '")) {top.location="/' 
								, (application urlPrefix , '/WikiPage?action=reload&page=' 
										, pageVersion page pageName webHttpUrlEncoded , '&lang=' 
										, Processor activeProcess language) webJavascriptStringEncoded 
									, '";}'].
			"---"
			self writeToolbar.
			"expandira node v kazalu v katerem se nahaja stran - samo, ce node obstaja in ce se izvaja v IE ali Mozilli"
			node := application getTOCNodeForPage: pageVersion page pageName.
			"link za printanje strani ter printanje celotnega poglavja"
			htmlStream 
				nextPutAll: '<div style="float:right;"><table><tr><td><a href="' , printUrl 
						, '&action=print" target="_blank"><img src="images/print-page.gif" width="14" height="12" border="0" alt="' 
							, 'WikiDoc.PrintThisPage' webTranslate webHtmlEncodedForForm 
							, '" /></a></td><td nowrap="nowrap" ><a href="' , printUrl 
						, '&action=print" class="printLink" target="_blank"><small>' , 'WikiDoc.PrintThisPage' webTranslate 
						, '</small></a>'.
			(node isNil or: [node children isNilOrEmpty]) 
				ifFalse: 
					[htmlStream 
						nextPutAll: '<small>&nbsp;/&nbsp;</small><a href="' , printUrl 
								, '&action=printPages" class="printLink" target="_blank"><small>' 
									, 'WikiDoc.PrintThisChapter' webTranslate , '</small>'].
			htmlStream nextPutAll: '</a><small>&nbsp;&nbsp;</small></td></tr></table></div>'.

			"Javascript koda, ki expandira TOC tako, da se prikaze trenutno prikazan node"
			(node isNil or: [self isOldBrowserCompatibilityMode: Processor activeProcess webRequest]) 
				ifFalse: 
					[str := ''.
					"najprej expandira top-level node, potem pa se vse child node pod njim dokler ne pride do selected node-a, zanka kreira klice od spodaj navzgor"
					
					[tocNodeIndex := node children isNilOrEmpty 
								ifFalse: [node nodeIndex]
								ifTrue: [node parentNode isNil ifFalse: [node parentNode nodeIndex]].
					tocNodeIndex isNil 
						ifFalse: 
							[str := 'if(top.tocFrame && top.tocFrame.isExpanded && !!top.tocFrame.isExpanded[' 
										, tocNodeIndex printString , '] && top.tocFrame.expandOrCollapse_' 
										, tocNodeIndex printString , ') {top.tocFrame.expandOrCollapse_' 
										, tocNodeIndex printString , '();}' 
										, str].
					(node := node parentNode) isNil] 
							whileFalse: [].
					htmlWriter javascript: str].


			"izpise navigacijo in vsebino strani"
			self
				writeTopNavigationLinks;
				pageContents: 
						[self add: '<div id="wikiPageContentsDiv">'.
						(session sessionData at: #requestComingFromSearchEngine ifAbsent: []) == true 
							ifTrue: [self writeSearchEngineNotification].
						contents isNilOrEmpty 
							ifTrue: [self writeDefaultWikiPageContentsFor: pageVersion]
							ifFalse: [self writeWikiPageContents: contents for: pageVersion].
						self add: '</div>'.
						self writeReferencesToPage: pageVersion]
					pageVersion: pageVersion]
		focusField: nil!

showPageVersionForPrint: pageVersion printChapterBool: printChapterBool 
	| lastRenderingContext node pageToPageNumberDictionary |
	self wikiPage: 
			[pageToPageNumberDictionary := LookupTable new.
			printChapterBool 
				ifTrue: 
					["two pass processing to get chapter numbers right"
					lastRenderingContext := self 
								writePrintableWikiPageContentsFor: pageVersion
								using: nil
								pageToPageNumberDictionary: pageToPageNumberDictionary
								firstPass: true.
					(node := application getTOCNodeForPage: pageVersion page pageName) isNil 
						ifFalse: 
							[self 
								writePrintableWikiPageContentsForChildrenOf: node
								using: lastRenderingContext
								pageToPageNumberDictionary: pageToPageNumberDictionary
								firstPass: true]].
			self add: '<div class="pageContents">'.
			lastRenderingContext := self 
						writePrintableWikiPageContentsFor: pageVersion
						using: nil
						pageToPageNumberDictionary: pageToPageNumberDictionary
						firstPass: false.
			printChapterBool 
				ifTrue: 
					[(node := application getTOCNodeForPage: pageVersion page pageName) isNil 
						ifFalse: 
							[self 
								writePrintableWikiPageContentsForChildrenOf: node
								using: lastRenderingContext
								pageToPageNumberDictionary: pageToPageNumberDictionary
								firstPass: false]].
			self showEndOfPageDisclaimerFragmentForPrint.
			self add: '</div>']
		focusField: nil!

showPageVersionsList: pageVersions currentVersion: currentVersion 
	| table user userInfo currentLanguage |
	currentLanguage := Processor activeProcess language.
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[htmlStream nextPutAll: '<h2>' , 'WikiDoc.ShowVersions' webTranslate , '</h2>
<p>'.
						table := self newFormTable: 1.
						pageVersions reverseDo: 
								[:each | 
								| pageVersionId |
								pageVersionId := (OmniBase currentTransaction getObjectID: each) index printString.
								(each editSession isNil or: [(user := each editSession user) isNil]) 
									ifFalse: [userInfo := user fullName]
									ifTrue: [userInfo := nil].
								(currentVersion isIdenticalTo: each) ifTrue: [table add: '<font color="red"><b>*&nbsp;</b></font>'].
								table
									add: '<a href="' , (self urlPrefixForAction: #processShowVersion:on: id: pageVersionId) , '&lang=' 
												, currentLanguage , '" class="internal" title="' 
												, each page pageTitle asWebString webHtmlEncodedForForm , '">' 
												, each page pageTitle asWebString webHtmlEncoded , '</a><br />';
									add: '<small><i><font color="#909090">' 
												, (each editTS asWebString add: userInfo withDelimiter: ' -- ') asWebString , '</font></i></small>'.
								table 
									add: '<small>&nbsp;&nbsp;[&nbsp;<a href="' 
											, (self urlPrefixForAction: #processLoadVersion:on: id: pageVersionId) , '&lang=' 
											, currentLanguage , '"><small><font color="#9090ff">' 
											, 'WikiDoc.LoadPageVersion' webTranslate , '</font></small></a>&nbsp;]</small>'.
								table nextCell].
						table generateOn: htmlStream.
						htmlStream nextPutAll: '</p>']]
		focusField: nil!

showRecentChangesList: pageVersions 
	| table currentLanguage |
	currentLanguage := Processor activeProcess language.
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[htmlStream nextPutAll: '<h2>' , 'WikiDoc.RecentChanges' webTranslate , '</h2>
<p>'.
						table := self newFormTable: 1.
						pageVersions do: 
								[:each | 
								table
									add: (WikiDocPageParser 
												pageLinkFor: each page pageName
												pageTitle: each page pageTitle
												pageLanguage: currentLanguage
												defaultLanguage: currentLanguage
												application: application);
									add: each page pageTitle asWebString webHtmlEncoded , '</a><br />';
									add: '<small><i><font color="#909090">' , (each versionInfoFor: session) asWebString 
												, '</font></i></small>';
									nextCell].
						(pageVersions size < 20 or: [pageVersions last editTS isNil]) 
							ifFalse: 
								[table 
									add: '<br /><a href="' , (self urlPrefixForAction: #processRecentChanges:on:) , '&lang=' 
											, currentLanguage , '&lastDate=' 
											, pageVersions last editTS date asWebString , '&lastTime=' 
											, pageVersions last editTS time asWebString , '" title="' 
											, 'WikiDoc.RecentChanges.More' webTranslate , '"><small>' 
											, 'WikiDoc.RecentChanges.More' webTranslate , '</small></a>'].
						table generateOn: htmlStream.
						htmlStream nextPutAll: '</p>']]
		focusField: nil!

showSearchFormForImageOkAndCancel: fields 
	| table |
	htmlWriter 
		javascript: 'function showResultAndCloseWindow() {
		var url ,image;

		image=window.parent.frames[1].lastClick;
		image=image.asUrlEncoded();
		url="wiki-images/" + image;
		top.window.opener.document.' 
				, (self webRequest isInternetExplorer 
						ifTrue: ['all["txtUrl"]']
						ifFalse: ['getElementById(''txtUrl'')']) 
					, '.value=url;
		top.window.opener.document.getElementById(''txtUrl'').focus();
		top.window.opener.UpdatePreview();
		top.window.close();
	}'.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: nil
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: '#6699CC'
		margin: 2
		focusField: nil
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[htmlWriter 
				form: (self urlPrefixForAction: #processSearchImages:on: id: nil)
				name: 'form'
				target: 'thumbnailsFrame'
				content: 
					[table := HtmlTable columns: 1.
					table
						cellPadding: 3;
						cellSpacing: 0;
						width: '100%';
						cellWidth: '100%';
						cellNoWrap.
					(table
						cellAlignmentCenter;
						addField: ((HtmlButton name: 'BUTTON_search' label: 'asp.button.OK' webTranslate)
									cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:22px';
									onClick: 'showResultAndCloseWindow()';
									yourself)) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:26px; width: 100px'.
					table space: 10.
					(table
						cellAlignmentCenter;
						addField: ((HtmlButton 
									label: 'asp.button.RemoveIt' webTranslate
									action: #processDeleteImage:on:
									id: 'window.parent.frames[1].lastClick')
									cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:22px';
									yourself)) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:26px; width: 100px'.
					table space: 10.
					(table
						cellAlignmentCenter;
						addField: ((HtmlButton name: 'BUTTON_cancel' label: 'asp.button.Cancel' webTranslate)
									cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:22px';
									onClick: 'top.window.close();';
									yourself)) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:26px; width: 100px'.
					table
						addHiddenField: 'imageName' value: nil;
						addHiddenField: 'pn' value: nil.
					table generateOn: htmlStream]]!

showSearchFormForLink: fields 
	| table currentLanguage dataRetrieverVar callbackFuncName tmp isOpera |
	isOpera := self webRequest isOpera.
	(Processor activeProcess attributes)
		at: #javascriptDataRetriever put: true;
		at: #javascriptCommon put: true.
	dataRetrieverVar := 'drSearchLink' , self identityHash printString.
	callbackFuncName := 'callbackSearchLink' , self identityHash printString.
	self 
		addBodyOnLoadScript: dataRetrieverVar , ' = new ITC.ajax.DataRetriever(null, ''' , callbackFuncName 
				, ''', true);'.
	htmlWriter 
		javascript: 'var ' , dataRetrieverVar 
				, '=null, kazalaColl,stKazala=0; 
function clickOnSearch () {
	var findString;
	findString=document.form.findString.value;
	' 
					, dataRetrieverVar , '.sendRequest(''' 
				, urlPrefix 
					, '?action=searchStraniKazala&str='' + findString);
}
function clickOnSearchEnter(e) {
	if(e.keyCode==13){
		var findString;
		findString=document.form.findString.value;
		' 
					, dataRetrieverVar , '.sendRequest(''' 
				, urlPrefix , '?action=searchStraniKazala&str='' + findString);
		return false;
	}
}
function ' 
				, callbackFuncName 
					, '(pData) {
	if(pData && pData[0]) {
	var zadetekCelotniNode=pData[0], parenti=null, zadetek=zadetekCelotniNode[0], funkcija='''';
	if(pData[0].length>1){
		for(i=pData[0].length-1; i >0; i--){
			parenti=(zadetekCelotniNode[i]);
			if(parenti !!= null){
				if((parent.frames[1].document.getElementById("tree_node_" + parenti[1]))&&(parent.frames[1].isExpanded[parenti[1]] !!= true)){
					parent.frames[1].isExpanded[parenti[1]]=!!parent.frames[1].isExpanded[parenti[1]];
					str=parent.frames[1].document.getElementById("tree_node_" + parenti[1]).innerHTML;
					parent.frames[1].document.getElementById("tree_node_" + parenti[1]).innerHTML=parent.frames[1].expanded_contents[parenti[1]];
					parent.frames[1].expanded_contents[parenti[1]]=str;
	}}}}
	parent.frames[1].clickOnKazalo(zadetek[0]);
	stKazala=1;
	kazalaColl=pData;
}}
function clickOnSearchNext(){
	if(kazalaColl && kazalaColl[stKazala]){
	var zadetekCelotniNode=kazalaColl[stKazala], parenti=zadetekCelotniNode[1], zadetek=zadetekCelotniNode[0];
	if(kazalaColl[stKazala].length>1){
		for(i=kazalaColl[stKazala].length-1; i >0; i--){
			parenti=zadetekCelotniNode[i];
			if(parenti !!= null){
				if((parent.frames[1].document.getElementById("tree_node_" + parenti[1]))&&(parent.frames[1].isExpanded[parenti[1]] !!= true)){
				parent.frames[1].isExpanded[parenti[1]]=!!parent.frames[1].isExpanded[parenti[1]];
				str=parent.frames[1].document.getElementById("tree_node_" + parenti[1]).innerHTML;
				parent.frames[1].document.getElementById("tree_node_" + parenti[1]).innerHTML=parent.frames[1].expanded_contents[parenti[1]];
				parent.frames[1].expanded_contents[parenti[1]]=str;
	}}}}
	parent.frames[1].clickOnKazalo(zadetek[0]);
	if(stKazala==kazalaColl.length-1)
                stKazala=0
	else
		stKazala++;
}}'.
	currentLanguage := Processor activeProcess language.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: nil
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: '#6699CC'
		margin: 2
		focusField: 'findString'
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[htmlWriter form: 'javascript:void(0)'
				content: 
					[table := HtmlTable columns: 3.
					table
						addHiddenDefaultButton: 'search';
						addHiddenField: 'lang' value: currentLanguage;
						border: 0;
						cellPadding: 3;
						cellSpacing: 0;
						width: '20%';
						cellWidth: '20%';
						cellNoWrap.
					tmp := table addTextField: 'findString' value: ''.
					isOpera 
						ifTrue: [tmp onKeyPress: 'clickOnSearchEnter(event);']
						ifFalse: [tmp onKeyDown: 'clickOnSearchEnter(event);'].
					tmp cssStyle: 'font-family:verdana;font-size:13px;height:24px;width:207;'.
					(table
						nextCell;
						cellNoWrap;
						addField: ((HtmlButton name: 'BUTTON_search' label: 'WikiDoc.SearchButton' webTranslate) 
									onClick: 'clickOnSearch()')) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:22px'.
					(table
						nextCell;
						cellNoWrap;
						addField: ((HtmlButton name: 'BUTTON_searchNextResult' label: 'WikiDoc.SearchNextResult' webTranslate) 
									onClick: 'clickOnSearchNext()')) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:22px'.
					table generateOn: htmlStream]]!

showSearchFormForLinkOkAndCancel: fields 
	| table |
	Processor activeProcess attributes at: #javascriptCommon put: true.
	htmlWriter 
		javascript: 'function showResultAndCloseWindow() {
	var url ,page;
	page=window.parent.frames[1].lastClick;
	page=page.asUrlEncoded();
	url=''' 
				, application defaultUrlPrefixForWikiPageServlet , ''' + page;top.window.opener.document.' 
				, (self webRequest isInternetExplorer 
						ifTrue: ['all["txtUrl"]']
						ifFalse: ['getElementById(''txtUrl'')']) 
					, '.value=url;top.window.opener.document.' , (self webRequest isInternetExplorer 
							ifTrue: ['all["cmbLinkProtocol"]']
							ifFalse: ['getElementById("cmbLinkProtocol")']) 
				, '.value="";top.window.close();}'.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: nil
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: '#6699CC'
		margin: 2
		focusField: 'BUTTON_search'
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[htmlWriter form: ''
				content: 
					[table := HtmlTable columns: 1.
					table
						cellPadding: 3;
						cellSpacing: 0;
						width: '100%';
						cellWidth: '100%';
						cellNoWrap.
					(table
						cellAlignmentCenter;
						addField: ((HtmlButton name: 'BUTTON_search' label: 'asp.button.OK' webTranslate) 
									onClick: 'showResultAndCloseWindow()')) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:26px; width: 100px'.
					table space: 10.
					(table
						cellAlignmentCenter;
						addField: ((HtmlButton name: 'BUTTON_cancel' label: 'asp.button.Cancel' webTranslate) 
									onClick: 'top.window.close();')) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:26px; width: 100px'.
					table generateOn: htmlStream]]!

showTableOfContents: toc indexToNodeDict: indexToNodeDict numberOfNodes: numberOfNodes selectedNode: selectedNode 
	| table webRequest onLoadScript oldBrowserCompatibilityMode node |
	webRequest := Processor activeProcess webRequest.
	oldBrowserCompatibilityMode := self isOldBrowserCompatibilityMode: webRequest.
	(oldBrowserCompatibilityMode or: [selectedNode isNil]) 
		ifFalse: 
			[node := selectedNode.
			[(node := node parentNode) isNil] whileFalse: 
					[onLoadScript := 'expandOrCollapse_' , node nodeIndex printString , '();' , onLoadScript asWebString]].
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
		bgColor: '#f1f1f1'
		margin: 3
		focusField: nil
		favoritesIcon: favoritesIconUrl
		onLoad: onLoadScript
		body: 
			[htmlWriter javascript: 'var tocLanguage="' , Processor activeProcess language , '";'.
			"old browser compatibility mode"
			oldBrowserCompatibilityMode 
				ifTrue: 
					[table := self getTableOfContentsTableFor: toc
								urlPostfix: (self webRequest isIndexingRobotOrWebSpider 
										ifTrue: ['&lang=' , Processor activeProcess language]
										ifFalse: ['']).
					table generateOn: htmlStream.
					^self].
			"generate expandable/collapsable tree nodes"
			toc do: [:eachNode | htmlStream nextPutAll: (self getCollapsedContentsForNode: eachNode)].
			session user isNil 
				ifFalse: 
					[self 
						addAdminLinkFor: #processUploadedFiles:on:
						label: 'Uploaded files'
						image: 'ServMgmt.gif'
						language: Processor activeProcess language.
					(session user canDo: #serverAdmin) 
						ifTrue: 
							[self
								addAdminLinkFor: #processServerManagement:on:
									label: 'Session management'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language;
								addAdminLinkFor: #processTopReferers:on:
									label: 'Top referers'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language;
								addAdminLinkFor: #processApplicationAdministrationStatistics:on:
									label: 'Server load statistics'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language;
								addAdminLinkFor: #processApplicationAdministration:on:
									label: 'Upload new version'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language;
								addAdminLinkFor: #processApplicationAdministrationLiveUpdate:on:
									label: 'Live update'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language;
								addAdminLinkFor: #processApplicationAdministrationErrorLog:on:
									label: 'ERROR.LOG'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language;
								addAdminLinkFor: #processApplicationAdministrationDownloadServerLog:on:
									label: 'SERVER_LOG.TXT'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language;
								addAdminLinkFor: #processApplicationAdministrationCommandPrompt:on:
									label: 'CMD prompt'
									image: 'ServMgmt.gif'
									language: Processor activeProcess language.
							application linksForPlugIns isNilOrEmpty 
								ifFalse: 
									[application linksForPlugIns do: 
											[:each | 
											self 
												addAdminLinkFor: (each at: 1)
												label: (each at: 2)
												image: (each at: 3)
												language: Processor activeProcess language]]].
					(session user canDo: #userAdmin) 
						ifTrue: 
							[self 
								addAdminLinkFor: #processUserManagement:on:
								label: 'User management'
								image: 'UserMgmt.gif'
								language: Processor activeProcess language].
					self
						addAdminLinkFor: #processChangePasswordFor:on:
							label: 'WikiDoc.User.ChangePasswordPage' webTranslate
							image: 'UserMgmt.gif'
							language: Processor activeProcess language;
						addAdminLinkFor: #processLogout:on:
							label: 'Logout'
							image: 'pixel.gif'
							language: Processor activeProcess language].
			htmlStream
				nextPutAll: HtmlElement javascriptBeginString;
				nextPutAll: 'var expanded_contents=['.
			1 to: numberOfNodes
				do: 
					[:i | 
					| eachNode |
					i = 1 ifFalse: [htmlStream nextPut: $,].
					eachNode := indexToNodeDict at: i.
					eachNode children isNilOrEmpty 
						ifFalse: 
							[htmlStream nextPut: $".
							(self getExpandedContentsForNode: eachNode) webJavascriptStringEncodedOn: htmlStream.
							htmlStream nextPut: $"]].
			htmlStream nextPutAll: '];var isExpanded=new Array(' , numberOfNodes printString , ');'.
			1 to: numberOfNodes
				do: 
					[:i | 
					| eachNode layerName |
					eachNode := indexToNodeDict at: i.
					eachNode children isNilOrEmpty 
						ifFalse: 
							[layerName := webRequest isInternetExplorer 
										ifFalse: ['document.getElementById("tree_node_' , eachNode nodeIndex printString , '")']
										ifTrue: ['document.all.tree_node_' , eachNode nodeIndex printString].
							htmlStream 
								nextPutAll: 'function expandOrCollapse_' , eachNode nodeIndex printString , '(){if(' , layerName 
										, '){var str;isExpanded[' , eachNode nodeIndex printString 
										, ']=!!isExpanded[' , eachNode nodeIndex printString 
										, '];str=' , layerName 
										, '.innerHTML;' , layerName 
										, '.innerHTML=expanded_contents[' , eachNode nodeIndex printString 
										, '];expanded_contents[' , eachNode nodeIndex printString 
										, ']=str;}}
']].
			htmlStream nextPutAll: HtmlElement javascriptEndString]!

showTableOfContentsForLink: toc indexToNodeDict: indexToNodeDict numberOfNodes: numberOfNodes selectedNode: selectedNode 
	| table webRequest onLoadScript oldBrowserCompatibilityMode node |
	webRequest := Processor activeProcess webRequest.
	Processor activeProcess attributes at: #javascriptCommon put: true.
	oldBrowserCompatibilityMode := self isOldBrowserCompatibilityMode: webRequest.
	session isNil ifTrue: [session := self webSession].
	(oldBrowserCompatibilityMode or: [selectedNode isNil]) 
		ifFalse: 
			[node := selectedNode.
			[(node := node parentNode) isNil] whileFalse: 
					[onLoadScript := 'expandOrCollapse_' , node nodeIndex printString , '();' , onLoadScript asWebString]].
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: nil
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: '#f1f1f1'
		margin: 3
		focusField: nil
		favoritesIcon: favoritesIconUrl
		onLoad: onLoadScript
		body: 
			[htmlWriter 
				javascript: 'var tocLanguage="' , Processor activeProcess language 
						, '"; lastClick=''''; 
function clickOnKazalo(id) {
	if ((lastClick!!='''')&&(document.getElementById(lastClick)!!=null))
		document.getElementById(lastClick).style.backgroundColor=''#f1f1f1'';
        lastClick=id;
	if(document.getElementById(id)!!=null){
		document.getElementById(id).style.backgroundColor="#ffff00";}
}
function onDoubleClick(id) {
	var url ,page;
	if (lastClick!!=""){
		document.getElementById(lastClick).style.backgroundColor="#f1f1f1";}
	page=id;
	page=page.asUrlEncoded();
	url="' 
							, application defaultUrlPrefixForWikiPageServlet , '" + page;top.window.opener.document.' 
						, (self webRequest isInternetExplorer ifTrue: ['all["txtUrl"]'] ifFalse: ['getElementById("txtUrl")']) 
							, '.value=url;top.window.opener.document.' , (self webRequest isInternetExplorer 
									ifTrue: ['all["cmbLinkProtocol"]']
									ifFalse: ['getElementById("cmbLinkProtocol")']) 
						, '.value="";top.window.close();
}
'.
			"old browser compatibility mode"
			oldBrowserCompatibilityMode 
				ifTrue: 
					[table := self getTableOfContentsTableFor: toc urlPostfix: ''.
					table generateOn: htmlStream.
					^self].
			"generate expandable/collapsable tree nodes"
			toc do: [:eachNode | htmlStream nextPutAll: (self getCollapsedContentsForNodeLink: eachNode)].
			htmlStream
				nextPutAll: HtmlElement javascriptBeginString;
				nextPutAll: 'var expanded_contents=['.
			1 to: numberOfNodes
				do: 
					[:i | 
					| eachNode |
					i = 1 ifFalse: [htmlStream nextPut: $,].
					eachNode := indexToNodeDict at: i.
					eachNode children isNilOrEmpty 
						ifFalse: 
							[htmlStream nextPut: $".
							(self getExpandedContentsForNodeLink: eachNode) webJavascriptStringEncodedOn: htmlStream.
							htmlStream nextPut: $"]].
			htmlStream nextPutAll: '];var isExpanded=new Array(' , numberOfNodes printString , ');'.
			1 to: numberOfNodes
				do: 
					[:i | 
					| eachNode layerName |
					eachNode := indexToNodeDict at: i.
					eachNode children isNilOrEmpty 
						ifFalse: 
							[layerName := webRequest isInternetExplorer 
										ifFalse: ['document.getElementById("tree_node_' , eachNode nodeIndex printString , '")']
										ifTrue: ['document.all.tree_node_' , eachNode nodeIndex printString].
							htmlStream 
								nextPutAll: 'function expandOrCollapse_' , eachNode nodeIndex printString 
										, '(pageName){clickOnKazalo(null); if(' , layerName 
										, '){var str; isExpanded[' , eachNode nodeIndex printString 
										, ']=!!isExpanded[' , eachNode nodeIndex printString 
										, '];str=' , layerName 
										, '.innerHTML;' , layerName 
										, '.innerHTML=expanded_contents[' , eachNode nodeIndex printString 
										, '];expanded_contents[' , eachNode nodeIndex printString 
										, ']=str;clickOnKazalo(pageName);}}
']].
			htmlStream nextPutAll: HtmlElement javascriptEndString]!

showTableOfContentsSearchForm: fields 
	| table currentLanguage |
	currentLanguage := Processor activeProcess language.
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
		bgColor: '#6699CC'
		margin: 2
		focusField: 'q'
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[htmlWriter form: urlPrefix , '?action=search'
				content: 
					[table := HtmlTable columns: 1.
					table
						addHiddenDefaultButton: 'search';
						addHiddenField: 'lang' value: currentLanguage;
						border: 0;
						cellPadding: 3;
						cellSpacing: 0;
						width: '100%';
						cellWidth: '100%';
						cellNoWrap;
						add: '<font style="color:#ffffff;font-family:verdana;font-size:11px;">' 
									, 'WikiDoc.SearchLabel' webTranslate , '</font>';
						break.
					(table addTextField: 'q' value: '') 
						cssStyle: 'font-family:verdana;font-size:13px;height:24px;width:207;'.
					(table
						nextCell;
						cellNoWrap;
						addField: (HtmlButton name: 'BUTTON_search' label: 'WikiDoc.SearchButton' webTranslate)) 
							cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:22px'.
					table
						add: '<font style="color:#ffffff;font-family:verdana;font-size:11px;">&nbsp;</font><a href="' 
									, urlPrefix , '?action=advanceSearch&lang=' 
									, currentLanguage , '" style="color:#ffffff;font-family:verdana;font-size:11px;">';
						add: 'WikiDoc.AdvanceSearchLabel' webTranslate;
						add: '</a>'.
					table generateOn: htmlStream]]!

showTopReferers: statisticsDict 
	| table |
	self wikiPage: 
			[self
				writeToolbar;
				pageContents: 
						[htmlStream nextPutAll: '<h2>Visitor HTTP header referer field statistics</h2>'.
						#('Today' 'Yesterday' 'This week' 'Last 10 days' 'This month' 'Last 31 days') doWithIndex: 
								[:eachTitle :entryIndex | 
								self writeSubtitle: eachTitle.
								table := self newListTable: 3.
								table
									addHeader: '';
									addHeader: 'Domain';
									addHeader: 'Hits count'.
								(self showTopReferersGetTop20EntriesFrom: statisticsDict atIndex: entryIndex) doWithIndex: 
										[:each :index | 
										table
											addData: index printString;
											addData: each key;
											addData: each value].
								table generateOn: htmlStream]]]
		focusField: nil!

showTopReferersGetTop20EntriesFrom: dict atIndex: index 
	| coll |
	coll := SortedCollection sortBlock: (ItcSortBlock with: [:a | a value]).
	dict keys do: 
			[:eachKey | 
			| eachValue |
			eachValue := dict at: eachKey ifAbsent: [].
			eachValue isNil 
				ifFalse: 
					[(eachValue at: index) isNil 
						ifFalse: [coll add: (Association key: eachKey value: (eachValue at: index))]]].
	coll := coll reverse.
	^coll copyFrom: 1 to: (coll size min: 50)!

showUserEditPage: user errors: errors isNewUser: newUserBool 
	| table table2 |
	self wikiPage: 
			[self
				writeToolbar;
				pageContents: 
						[htmlWriter form: (self urlPrefixForAction: #processSave:on:)
							content: 
								[htmlStream 
									nextPutAll: '<h2>' 
											, (newUserBool = true ifTrue: ['Add new WikiDoc user account'] ifFalse: ['Edit WikiDoc user account']) 
												, '</h2>
<p>'.
								table := self newFormTable: 2.
								table
									addLabel: 'Username'
										mandatoryTextField: #username
										valueFrom: user
										errors: errors;
									addLabel: 'Password'
										mandatoryPasswordField: 'password'
										valueFrom: user
										errors: errors;
									addLabel: 'Password confirm'
										mandatoryPasswordField: 'passwordConfirm'
										value: user password
										errors: errors;
									addLabel: 'Full name'
										textField: #fullName
										valueFrom: user
										size: 40
										errors: errors;
									addLabel: 'Status';
									add: ((HtmlTable noSpacing: 3)
												background: '#flflfl';
												addBooleanField: 'inactive' value: user inactive = true;
												nextCell;
												space;
												nextCell;
												add: 'user account is deactivated';
												yourself);
									nextCell;
									addLabel: 'E-mail'
										textField: #eMail
										valueFrom: user
										errors: errors;
									addLabel: 'Homepage'
										textField: #homepage
										valueFrom: user
										size: 40
										errors: errors.
								table2 := HtmlListTable columns: 2.
								(table2 addBooleanField: 'groupEveryone' value: true) disabled: true.
								table2
									nextCell;
									addBoldData: 'Everyone'.
								(table2 addBooleanField: 'groupUsers' value: true) disabled: true.
								table2
									nextCell;
									addBoldData: 'Users';
									addBooleanField: 'groupUserAdmins' value: (user canDo: #userAdmin);
									nextCell;
									addBoldData: 'User administrators'.
								(table2 addBooleanField: 'groupServerAdmins' value: (user canDo: #serverAdmin)) 
									disabled: (session user canDo: #serverAdmin) not.
								table2
									nextCell;
									addBoldData: 'Server administrators'.
								table
									addLabel: 'User groups';
									add: table2.
								table generateOn: htmlStream.
								self writeActionButtons: #(#processSave:on: 'Save' 1 #processGoBack:on: 'Cancel')].
						htmlStream nextPutAll: '</p>']]
		focusField: 'username'!

showUserOverviewPage: pageNumber coll: users searchFields: searchFields 
	| table |
	self wikiPage: 
			[self
				writeToolbar;
				pageContents: 
						[htmlWriter form: (self urlPrefixForAction: #processSave:on:)
							content: 
								[htmlStream nextPutAll: '<h2>User management</h2>
<p>'.
								table := self newFormTable: 1.
								table generateOn: htmlStream.
								users isEmpty 
									ifTrue: 
										[self
											break;
											errorText: 'error.NoMatchFound']
									ifFalse: 
										[table := HtmlListTable columns: 4.
										self 
											for: users
											topPageIndex: pageNumber
											table: table
											addHeaderBlock: 
												[table
													width: '100%';
													addHeader: 'Username';
													addHeader: 'Full name';
													addHeader: 'eMail';
													addHeader: 'Selection']
											doWithIndex: 
												[:each :i | 
												table
													cellWidthPc: 30;
													cellNoWrap;
													addData: each username linkTo: urlPrefix , '?action=show&id=' , each username webHttpUrlEncoded;
													cellWidthPc: 40;
													addData: each fullName;
													cellWidthPc: 30;
													addData: each eMail;
													cellAlignmentCenter;
													addBooleanField: 'selection_' , i printString value: false;
													nextCell].
										table generateOn: htmlStream].
								htmlStream nextPutAll: '</p>']]]
		focusField: nil!

showWikiSessionEvents: wikiSession 
	| table currentLanguage dict previousSession |
	currentLanguage := Processor activeProcess language.
	self wikiPage: 
			[self
				writeToolbar;
				pageContents: 
						[htmlStream nextPutAll: '<h2>' , 'Wiki session information' webTranslate , '</h2>
<p>'.
						table := self newFormTable: 2.
						table
							addLabel: 'IP-address and hostname'
								data: (wikiSession loginIP add: wikiSession loginHostname withDelimiter: ' / ');
							addLabel: 'Login/logout TS'
								data: (wikiSession loginTS asWebString add: wikiSession logoutTS asWebString
										withDelimiter: ' / ');
							addLabel: 'User agent' data: wikiSession loginUserAgent;
							addLabel: 'Referer' data: wikiSession referer;
							addLabel: 'User account'
								data: (wikiSession user isNil ifFalse: [wikiSession user username]);
							addLabel: 'Client cookie' data: wikiSession clientCookie.
						(previousSession := wikiSession previousSession) isNil 
							ifFalse: 
								[table
									addLabel: 'Prev. session of the same client';
									addData: previousSession loginTS
										linkTo: urlPrefix , '?action=showPreviousSession&oid=' 
												, previousSession odbGetOID asWebString].
						table generateOn: htmlStream.
						#(#pageViews #pagePrint #pageEdits #downloads #searches) do: 
								[:eachKey | 
								(dict := wikiSession usageLog at: eachKey ifAbsent: []) isNilOrEmpty 
									ifFalse: 
										[htmlStream nextPutAll: '<h3>' , eachKey asString , '</h3>'.
										table := self newListTable: 2.
										table
											addHeader: 'Resource';
											addHeader: 'Hits count'.
										dict keys asSortedCollection do: 
												[:eachDictKey | 
												table
													addData: eachDictKey;
													cellAlignmentRight;
													addData: (dict at: eachDictKey) size].
										table generateOn: htmlStream]].
						htmlStream nextPutAll: '</p>']]
		focusField: nil!

toolbar: buttons 
	"Generate toolbar with <buttons> definition."

	| table image label enabled url |
	htmlStream nextPutAll: '<div id="wiki-toolbar">'.
	table := HtmlTable columns: buttons size * 2 + 2.
	table
		cellPadding: 0;
		cellSpacing: 0;
		border: 0;
		width: '100%';
		background: '#d0d0d0';
		spanRow;
		addPixelHeight: 3;
		nextCell.
	table
		addPixelWidth: 5;
		nextCell.
	buttons do: 
			[:each | 
			each isNil 
				ifTrue: 
					[table
						add: ((HtmlTable noSpacing: 1)
									addPixelHeight: 14;
									cellBackground: '#ffffff';
									yourself);
						nextCell]
				ifFalse: 
					[label := each at: 1.
					image := each at: 2.
					enabled := each at: 3.
					url := each at: 4.
					table
						cellNoWrap;
						add: '<div style="background:#d0d0d0;border-style:solid;border-width:1px;border-color:#d0d0d0;cursor:pointer;cursor:hand;" onmouseover="javascript:this.style.backgroundColor=''#b0b0c8'';this.style.borderColor=''#101010'';" onmouseout="javascript:this.style.backgroundColor=''#d0d0d0'';this.style.borderColor=''#d0d0d0'';" onclick="javascript:window.location=''' 
									, url webHtmlEncodedForForm , '''">'.
					label isNil 
						ifTrue: [table add: '<img src="images/bt-' , image , '.gif">']
						ifFalse: 
							[image isNil 
								ifTrue: 
									[table add: ((HtmlTable noSpacing: 2)
												addPixelHeight: 22;
												nextCell;
												cellNoWrap;
												add: '<font class="toolbarButton">&nbsp;' , label webHtmlEncoded , '&nbsp;</font>';
												yourself)]
								ifFalse: 
									[table add: ((HtmlTable noSpacing: 2)
												add: '<img src="images/bt-' , image , '.gif">';
												nextCell;
												cellNoWrap;
												add: '<font class="toolbarButton">' , label webHtmlEncoded , '&nbsp;</font>';
												yourself)]].
					table
						add: '</div>';
						nextCell].
			table
				addPixelWidth: 4;
				nextCell].
	table
		cellWidth: '100%';
		space;
		nextCell;
		spanRow;
		addPixelHeight: 4;
		nextCell;
		generateOn: htmlStream.
	htmlStream nextPutAll: '</div>'!

toolTipScript
	^'function ToolTip(pElementId, pText, pShowDelay, pHideDelay) {
		this.m_ActivationElement = document.getElementById(pElementId);
		this.m_TipText = pText;
		this.m_ShowDelay = pShowDelay;
		this.m_HideDelay = pHideDelay;
		this.m_Visible = false;
		this.m_Active = false;
		this.m_Hiding = false;
		this.initialize();
	}
	ToolTip.AddEvent = function(pEventName, pElement, pFunction) {
		if (pElement.attachEvent)
			pElement.attachEvent(''on'' + pEventName, pFunction);
		else
	    		pElement.addEventListener(pEventName, pFunction, true);
	}
	ToolTip.GetCreateEvent = function(pEvent) {
		if (pEvent)
			return pEvent;
		return window.event;
	}
	ToolTip.CheckParent = function(pTargetElement, pElement) {
		var current = pTargetElement;
		
		if (!!current)
			return false;
		do {
			if (current == pElement)
				return true;
			current = current.parentNode;
		} while (current);
		return false;
	}
	ToolTip.IsInternalMouseOut = function(pEvent, pElement) {
		var trg = null;
		
		if (pEvent.relatedTarget) 
			trg = pEvent.relatedTarget;
		else if (pEvent.toElement) 
			trg = pEvent.toElement;
		return ToolTip.CheckParent(trg, pElement);
	}
	ToolTip.prototype.initialize = function() {
		var tt = this;
		
		this.m_ToolTipElement = document.createElement(''div'');
		this.m_ToolTipElement.className = ''toolTip'';
		this.m_ToolTipElement.style.position = ''absolute'';
		this.m_ToolTipElement.style.visibility = ''hidden'';
		this.m_ToolTipElement.style.display = ''none'';
		this.m_ToolTipElement.innerHTML = this.m_TipText;
		document.body.appendChild(this.m_ToolTipElement);
		if (!!this.m_ShowDelay)
			this.m_ShowDelay = 0;
		if (!!this.m_HideDelay)
			this.m_HideDelay = 0;
		ToolTip.AddEvent(''mouseover'', this.m_ActivationElement, function(pEvent) {
			tt.beginShow(pEvent);
		});
		ToolTip.AddEvent(''mousemove'', this.m_ActivationElement, function(pEvent) {
			tt.move(pEvent);
		});
		ToolTip.AddEvent(''mouseout'', this.m_ActivationElement, function(pEvent) {
			tt.beginHide(pEvent);
		});
	}
	ToolTip.prototype.positionBalloon = function(pMouseX, pMouseY) {
		var width = this.m_ToolTipElement.offsetWidth;
		var height = this.m_ToolTipElement.offsetHeight;
		var leftCornerActive = true;
		var bottomCornerActive = false;
		var x = pMouseX + 10;
		var y = pMouseY + 10;
		
		if ((pMouseX + 10 + width) > document.body.clientWidth) {
			x = pMouseX - 10 - width;
			leftCornerActive = false;
		}
		if ((pMouseY + 10 + height) > document.body.clientHeight) {
			y = pMouseY - 10 - height;
			bottomCornerActive = true;
		}
		this.m_ToolTipElement.style.left = x;
		this.m_ToolTipElement.style.top = y;
	}
	ToolTip.prototype.beginShow = function(pEvent) {
		var tt = this;
		var e = ToolTip.GetCreateEvent(pEvent);

		this.positionBalloon(e.clientX + document.body.scrollLeft, e.clientY + document.body.scrollTop);
		this.m_Active = true;
		this.m_Hiding = false;
		if (this.m_ShowDelay > 0)
			setTimeout(function() {
			tt.show()}, this.m_ShowDelay);
		else
			this.show();
	}
	ToolTip.prototype.show = function() {
		if (!!this.m_Active)
			return;
		this.m_ToolTipElement.style.visibility = ''visible'';
		this.m_ToolTipElement.style.display = ''block'';
		this.m_Visible = true;
	}
	ToolTip.prototype.move = function(pEvent) {
		var e;

		if (!!this.m_Active)
			return;
		e = ToolTip.GetCreateEvent(pEvent);
		this.positionBalloon(e.clientX + document.body.scrollLeft, e.clientY + document.body.scrollTop);
	}
	ToolTip.prototype.beginHide = function(pEvent) {
		var tt = this;
		
		if (!!this.m_Visible || ToolTip.IsInternalMouseOut(pEvent, this.m_ActivationElement))
			return;
		this.m_Hiding = true;
		if (this.m_HideDelay > 0)
			setTimeout(function() {
			tt.hide()}, this.m_HideDelay);
		else
			this.hide();
	}
	ToolTip.prototype.hide = function() {
		if (!!this.m_Hiding)
			return;
		this.m_ToolTipElement.style.visibility = ''hidden'';
		this.m_ToolTipElement.style.display = ''none'';
		this.m_Active = false;
	}'!

wikiDocChangePasswordConfirmationPage
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[self
							writeTitle: 'WikiDoc.User.ChangePasswordPage';
							paragraph: 'WikiDoc.User.ChangePasswordConfirmationText']]
		focusField: nil!

wikiDocChangePasswordPage: user errors: errors 
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[htmlWriter form: (self urlPrefixForAction: #processChangePassword:on:)
							content: 
								[self writeTitle: 'WikiDoc.User.ChangePasswordPage'.
								(self newFormTable: 2)
									addLabel: 'asp.user.OldPassword'
										mandatoryPasswordField: 'oldpassword'
										value: nil
										errors: errors;
									addLabel: 'asp.user.NewPassword'
										mandatoryPasswordField: 'newpassword'
										value: nil
										errors: errors;
									addLabel: 'asp.user.PasswordConfirm'
										mandatoryPasswordField: 'passwordConfirm'
										value: nil
										errors: errors;
									generateOn: htmlStream.
								self writeActionButtons: #(#processChangePassword:on: 'asp.button.Submit')]]]
		focusField: 'oldpassword'!

wikiDocImageSelectorSearchFrame
	| currentLanguage table dataRetrieverVar callbackFuncName tmp isOpera |
	isOpera := self webRequest isOpera.
	(Processor activeProcess attributes)
		at: #javascriptDataRetriever put: true;
		at: #javascriptCommon put: true.
	dataRetrieverVar := 'drSearchLink' , self identityHash printString.
	callbackFuncName := 'callbackSearchLink' , self identityHash printString.
	self 
		addBodyOnLoadScript: dataRetrieverVar , ' = new ITC.ajax.DataRetriever(null, ''' , callbackFuncName 
				, ''', true);'.
	htmlWriter javascript: 'var ' , dataRetrieverVar 
				, '=null, kazalaColl,stKazala=0; 
function clickOnSearchEnter(e) {
	if(e.keyCode==13){
		var findString;
		findString=document.form.findString.value;
		 document.form.submit();
	}
}'.
	currentLanguage := Processor activeProcess language.
	htmlWriter 
		page: pageTitle
		keywords: nil
		description: nil
		refresh: nil
		charSet: charSet
		style: style
		styleLinks: nil
		javascriptLinks: javascriptLinks
		baseUrl: baseUrl
		baseTarget: baseTarget
		bgColor: '#6699CC'
		margin: 2
		focusField: 'findString'
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: 
			[htmlWriter 
				form: (self urlPrefixForAction: #processSearchImages:on: id: nil)
				name: 'form'
				target: 'thumbnailsFrame'
				content: 
					[table := HtmlTable columns: 6.
					table
						addHiddenDefaultButton: 'search';
						addHiddenField: 'lang' value: currentLanguage;
						border: 0;
						cellPadding: 3;
						cellSpacing: 0;
						width: '20%';
						cellWidth: '20%';
						cellNoWrap.
					tmp := table addTextField: 'findString' value: ''.
					isOpera 
						ifTrue: [tmp onKeyPress: 'clickOnSearchEnter(event);']
						ifFalse: [tmp onKeyDown: 'clickOnSearchEnter(event);'].
					tmp
						cssStyle: 'font-family:verdana;font-size:13px;height:24px;width:207;';
						elementId: 'findString'.
					table
						nextCell;
						addField: ((HtmlButton name: 'searchImages' label: 'WikiDoc.SearchButton' webTranslate)
									cssStyle: 'font-weight:normal;font-family:tahoma;font-size:12px;height:22px';
									yourself);
						nextCell;
						addImage: 'images/bt-previousObject.gif'
							width: 15
							height: 15
							toolTip: 'asp.label.PreviousPage'
							target: 'thumbnailsFrame'
							linkTo: (self urlPrefixForAction: #processPreviousPage:on: id: nil) , '?lang=' , currentLanguage
							linkId: 'previousPageLink';
						nextCell;
						add: '<div id=''pageNumberLinks''></div>';
						nextCell;
						addImage: 'images/bt-nextObject.gif'
							width: 15
							height: 15
							toolTip: 'asp.label.NextPage'
							target: 'thumbnailsFrame'
							linkTo: (self urlPrefixForAction: #processPreviousPage:on: id: nil) , '?lang=' , currentLanguage
							linkId: 'nextPageLink';
						generateOn: htmlStream]]!

wikiDocImagesSelectorOverviewPage: pageNumber images: images showPrevious: showPrevious showNext: showNext pageNumberLinkArray: pnLinkArray searchString: searchString 
	| links |
	links := ''.
	pnLinkArray do: 
			[:each | 
			| showBig |
			showBig := pageNumber = each.
			links := links , '<a target="thumbnailsFrame" href="' 
						, (self urlPrefixForAction: #processNextPage:on:) , '&pn=' 
						, each printString , '&findString=' 
						, searchString asWebString webHttpUrlEncoded , '&lang=' 
						, Processor activeProcess language , '">' 
						, (showBig 
								ifTrue: 
									['<span style="FONT-FAMILY:Arial,Helvetica,sans-serif;color:#000000;FONT-STYLE:normal;FONT-WEIGHT:bold;FONT-SIZE:9pt;TEXT-DECORATION:none;">']
								ifFalse: 
									['[<span style="FONT-FAMILY:Arial,Helvetica,sans-serif;color:#000000;FONT-STYLE:normal;FONT-WEIGHT:normal;FONT-SIZE:9pt;">']) 
							, each printString , '</span></a>&nbsp;'].
	self htmlPage: 
			[self
				addBodyOnLoadScript: '
parent.frames[2].document.getElementsByName(''pn'')[0].value = ' 
							, pageNumber asJavascriptValue 
								, ';

parent.frames[0].document.getElementById(''pageNumberLinks'').innerHTML=' 
								, links asJavascriptValue 
								, ';
parent.frames[0].document.getElementById(''previousPageLink'').href = ' 
								, ((self urlPrefixForAction: #processPreviousPage:on:) , '&pn=' 
										, (showPrevious ifTrue: [pageNumber - 1] ifFalse: [pageNumber]) asWebString , '&findString=' 
										, searchString asWebString webHttpUrlEncoded , '&lang=' 
										, Processor activeProcess language) asJavascriptValue 
								, ';
parent.frames[0].document.getElementById(''nextPageLink'').href = ' 
								, ((self urlPrefixForAction: #processNextPage:on:) , '&pn=' 
										, (showNext ifTrue: [pageNumber + 1] ifFalse: [pageNumber]) asWebString , '&findString=' 
										, searchString asWebString webHttpUrlEncoded , '&lang=' 
										, Processor activeProcess language) asJavascriptValue 
								, ';
';
				addJavascript: 'var prevCell;
							var lastClick;
							var imageWidth;
							var imageHeight;

	function select(obj, imgSelectedName, imgWidth, imgHeight) {
		if (prevCell !!= null)
			prevCell.style.backgroundColor = ''#ffffff''

		lastClick = imgSelectedName;
		parent.frames[2].document.getElementsByName(''imageName'')[0].value = lastClick;
		imageWidth = imgWidth;
		imageHeight = imgHeight;

		obj.style.backgroundColor  = ''#D9D9D9''
		prevCell = obj;
		}

	function preusmeri(imageName, imgWidth, imgHeight) {
top.window.opener.document.getElementById(''txtUrl'').value="' 
							, 'wiki-images/' 
								, '"+imageName;
top.window.opener.document.getElementById(''txtWidth'').value=imgWidth;
top.window.opener.document.getElementById(''txtHeight'').value=imgHeight;
top.window.opener.document.getElementById(''txtUrl'').focus();
top.window.opener.UpdatePreview();
            top.window.close ();
}'.
			htmlStream nextPutAll: '<div id="slike"><table cellspacing=''15'' width="100%"><tr><td>'.
			images doWithIndex: 
					[:each :i | 
					htmlStream 
						nextPutAll: '<div onClick="select(this,''' , each imageName webHttpUrlEncoded , ''', ' 
								, (each width isNil ifTrue: [''''''] ifFalse: [each width printString]) , ', ' 
								, (each height isNil ifTrue: [''''''] ifFalse: [each height printString]) 
									, ')" onDblClick="preusmeri(''' , each imageName webHttpUrlEncoded 
								, ''', ' , (each width isNil ifTrue: [''''''] ifFalse: [each width printString]) 
								, ', ' , (each height isNil ifTrue: [''''''] ifFalse: [each height printString]) 
								, ')" style="float:left;width:200px;height:150px;"><table width="100%" height="100%" cellpadding="2"><tr><td align="center" valign="middle" width="100%" style="border:1px solid #e0e0e0">'.
					htmlStream 
						nextPutAll: '<div style="overflow:hidden;width:' , WikiDocImage maxThumbnailWidth printString 
								, 'px;height:' , WikiDocImage maxThumbnailHeight printString 
								, 'px;"><img src=''/WikiDoc/thumbnails-small/' , each imageName 
								, '''/></div></td></tr><tr><td align="center"><small>' , each imageName webHtmlEncoded 
								, '</small></td></tr><tr><td align="center" nowrap="nowrap"><small>' 
									, (each width asWebString add: each height asWebString withDelimiter: 'x') , ' ' 
								, 'Dokument.fileSize' webTranslate , ': ' 
								, (each fileSize / 1024.0s roundTo: 0.01s) asWebStringWithMinimumDecimals , 'kB' 
								, '</small></td></tr></table></div>'].
			htmlStream nextPutAll: '</td></tr></table></div>']!

wikiDocNoSearchResultsPage: searchFields 
	| currentLanguage |
	currentLanguage := Processor activeProcess language.
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[self
							add: '<p><font size="+1">';
							add: ('WikiDoc.SearchNoResultsTitle' 
										webTranslateWith: (searchFields at: 'q') asWebString webHtmlEncoded);
							add: '</font></p>';
							add: '<p>';
							add: ('WikiDoc.SearchNoResultsMessage' 
										webTranslateWith: (searchFields at: 'q') asWebString webHtmlEncoded);
							add: '</p>']]
		focusField: nil!

wikiDocUploadedFilesOverviewPage: pageNumber coll: files searchFields: searchFields 
	| table |
	self wikiPage: 
			[self
				writeToolbar;
				pageContents: 
						[htmlWriter form: (self urlPrefixForAction: #processSearch:on:)
							content: 
								[htmlStream nextPutAll: '<h2>' , 'WikiDoc.uploadedFiles' webTranslate , '</h2>
<p>'.
								table := self newFormTable: 8.
								table
									addHiddenDefaultButton: #processSearch:on:;
									addLabel: 'WikiDoc.uploadedFiles.FileName'
										textField: #fileName
										value: (searchFields at: #fileName);
									addLabel: 'WikiDoc.uploadedFiles.search.uploadedDateFrom';
									addDateField: #dateFrom
										value: (searchFields at: #dateFrom)
										baseDate: Date today;
									nextCell;
									space;
									addData: '-';
									space;
									nextCell;
									addDateField: #dateTo
										value: (searchFields at: #dateTo)
										baseDate: Date today;
									nextCell;
									space.
								table generateOn: htmlStream.
								htmlWriter 
									bar: nil
									sideActions: #(#processSearch:on:)
									labels: #('asp.button.Search').
								files isEmpty 
									ifTrue: 
										[self
											break;
											errorText: 'error.NoMatchFound']
									ifFalse: 
										[table := HtmlListTable columns: 4.
										self 
											for: files
											topPageIndex: pageNumber
											table: table
											addHeaderBlock: 
												[table
													width: '100%';
													addHeader: 'WikiDoc.uploadedFiles.FileName';
													addHeader: 'WikiDoc.uploadedFiles.FileSize';
													addHeader: 'WikiDoc.uploadedFiles.FileUploaded';
													addHeader: 'WikiDoc.uploadedFiles.Delete']
											doWithIndex: 
												[:each :i | 
												table
													cellWidthPc: 30;
													cellNoWrap;
													addData: each fileName;
													cellWidthPc: 40;
													addData: each fileSize;
													cellWidthPc: 30;
													addData: each uploadTS;
													cellAlignmentCenter;
													addConfirmDeleteLinkTo: (self urlPrefixForAction: #processConfirmDelete:on: id: each fileName)
														confirmationString: ('asp.label.GenericObjectRemoveConfirmationText' 
																webTranslateWith: each fileName webHtmlEncoded)].
										table generateOn: htmlStream].
								htmlStream nextPutAll: '</p>']]]
		focusField: nil!

wikiPage: body focusField: focusField 
	| contentString |
	contentString := self evaluateBlockAndGetContentsString: body.
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
		bgColor: '#ffffff'
		margin: 0
		focusField: focusField
		favoritesIcon: favoritesIconUrl
		onLoad: nil
		body: contentString!

wikiPageConfirmRemovePage: pageVersion 
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[htmlWriter form: (self urlPrefixForAction: #processRemovePageConfirm:on:)
							content: 
								[self writeTitle: 'WikiDoc.RemovePage'.
								htmlWriter
									hiddenField: 'page' value: pageVersion page pageName;
									hiddenField: 'lang' value: Processor activeProcess language.
								htmlStream 
									nextPutAll: '<p>' , ('WikiDoc.RemovePageConfirmText' 
													webTranslateWith: pageVersion page pageName asWebString webHtmlEncoded) 
											, '</p>'.
								self 
									writeActionButtons: #(#processRemovePageConfirm:on: 'WikiDoc.RemovePage' 1 #processDefault:on: 'asp.button.Cancel')]]]
		focusField: 'BUTTON_default'!

wikiPageTitle: aString 
	"Set wiki page title. This title can be shown in subclasses that render pages as a singled HTML page, without frames."

	wikiPageTitle := aString!

wikiSearchResultPage: results resultsPerPage: resultsPerPage startIndex: startIndex searchFields: searchFields 
	"Najdene besede oznaci s flourescentnimi barvami, kot s flomastrom"

	"
<td bgcolor=#ffff66> rumena
<td bgcolor=#A0FFFF> cyan
<td bgcolor=#99ff99> svetlo zelena
<td bgcolor=#ff9999> rdeca
"

	"<B style="

	"color:black;background-color:#A0FFFF"

	">"

	| table table2 searchString endIndex currentLanguage |
	currentLanguage := Processor activeProcess language.
	endIndex := startIndex + resultsPerPage - 1 min: results size.
	self wikiPage: 
			[self
				writeToolbar;
				writeTopNavigationLinks;
				pageContents: 
						[self
							add: '<p><font size="+1">';
							add: ('WikiDoc.SearchResultsFor' 
										webTranslateWith: (searchFields at: 'q') asWebString webHtmlEncoded);
							add: '</font></p>'.
						table := HtmlTable noSpacing: 2.
						table
							width: '100%';
							add: ('WikiDoc.SearchResultsPage' 
										webTranslateWith: startIndex printString
										with: endIndex printString
										with: results size asWebString);
							break;
							break;
							add: '</font>';
							nextCell;
							cellAlignmentRight.
						self 
							addSearchResultsNavigationLinksTo: table
							nextPage: (endIndex < results size ifTrue: [startIndex + resultsPerPage])
							previousPage: (startIndex > 1 ifTrue: [startIndex - resultsPerPage])
							resultsPerPage: resultsPerPage.
						table generateOn: htmlStream.
						startIndex to: endIndex
							do: 
								[:index | 
								| each eachSearchString eachPage eachLanguage highlightedText |
								each := results at: index.
								eachPage := each at: 3.
								eachLanguage := each at: 1.
								eachSearchString := each at: 2.
								highlightedText := (WikiDocFullTextSearchIndex new)
											application: application;
											findTextMatching: eachSearchString onPage: eachPage.
								table := HtmlTable columns: 1.
								table
									width: '100%';
									cellNoWrap;
									addBold: index printString , '. ';
									add: (WikiDocPageParser 
												pageLinkFor: eachPage pageName
												pageTitle: eachPage getPageTitle
												pageLanguage: eachLanguage
												defaultLanguage: currentLanguage
												application: application);
									addBold: eachPage getPageTitle webHtmlEncoded;
									add: '</a>';
									nextCell.
								table
									cellWidth: '100%';
									cellBackground: '#f0f0f0';
									add: '<font style="color:#000000;font-size:10pt;font-weight:normal">'.
								table 
									add: (self highlightedText: highlightedText key forIntervals: highlightedText value).
								table
									add: '</font>';
									nextCell;
									cellNoWrap;
									add: (WikiDocPageParser 
												pageLinkFor: eachPage pageName
												pageTitle: eachPage pageName
												pageLanguage: eachLanguage
												defaultLanguage: currentLanguage
												application: application);
									add: '<font style="font-size:10pt;font-weight:normal">' , eachPage pageName webHtmlEncoded 
												, '</font></a><font style="font-size:10pt;font-weight:normal"> - ' 
													, (eachPage getCurrentVersion versionInfoFor: session) , '</font>'.
								ItcSystemManager isRuntime 
									ifFalse: 
										[table 
											add: '<font style="color:#d0d0d0;font-size:8pt;font-weight:normal"> &nbsp;/ ' , ' ' 
													, (each at: 4) displayString , '</font>'	"eachPage pageRankingValue displayString "].
								table generateOn: htmlStream.
								self smallBreak]]]
		focusField: nil!

writeDefaultWikiPageContentsFor: pageVersion 
	htmlStream nextPutAll: '<h2>' , pageVersion page pageName webHtmlEncoded , '</h2>' 
				, ('WikiDoc.EmptyPageDefinition' 
						webTranslateWith: (urlPrefix , '?action=edit&lang=' , Processor activeProcess language 
								, '&page=' , pageVersion page pageName webHttpUrlEncoded) 
								webHtmlEncodedForForm
						with: 'WikiDoc.EditPage' webTranslate)!

writePrintableWikiPageContentsFor: pageVersion using: renderingContext pageToPageNumberDictionary: pageToPageNumberDictionary firstPass: aBoolean 
	"Show wiki page in printable form."

	| ws contents parser mutex |
	contents := pageVersion contents.
	ws := WriteStream on: (String new: 10240).
	
	[parser := WikiDocPrintablePageParser new.
	parser
		renderingContext: renderingContext;
		pageToPageNumberDictionary: pageToPageNumberDictionary;
		generateHtmlFrom: contents
			for: pageVersion
			on: ws
			urlPrefix: urlPrefix
			application: application
			session: session] 
			on: Error
			do: 
				[:ex | 
				ws := WriteStream on: (String new: 1024).
				parser := WikiDocPrintablePageParser new.
				parser
					renderingContext: renderingContext;
					pageToPageNumberDictionary: pageToPageNumberDictionary;
					generateHtmlFrom: '==' , pageVersion page pageName , '==

' 
								, 'WikiDoc.PageRenderingError' webTranslate
						for: pageVersion
						on: ws
						urlPrefix: urlPrefix
						application: application
						session: session.
				ex exitWith: nil].
	aBoolean = true 
		ifFalse: 
			[(mutex := session sessionData at: #statMutex ifAbsent: []) isNil 
				ifFalse: 
					["record that user has requested to print the page"
					mutex critical: 
							[((session sessionData at: #pagePrint) 
								at: Processor activeProcess language , '\\' , pageVersion page pageName
								ifAbsentPut: [OrderedCollection new]) add: Timestamp now]].
			"---"
			htmlStream
				nextPutAll: (self importInnerHtmlForDivsWithExternalSourceOn: ws contents);
				nextPutAll: '<p>&nbsp;</p>'].
	^parser renderingContext!

writePrintableWikiPageContentsForChildrenOf: aWikiDocTocNode using: renderingContext pageToPageNumberDictionary: pageToPageNumberDictionary firstPass: aBoolean 
	| children page pageVersion currentRC |
	children := aWikiDocTocNode children.
	children isNil ifTrue: [^self].
	((renderingContext at: 1) = 0 and: [(renderingContext at: 4) isNilOrEmpty]) 
		ifTrue: [currentRC := renderingContext]
		ifFalse: 
			[currentRC := Array 
						with: (renderingContext at: 2)
						with: nil
						with: (renderingContext at: 3)
						with: ((renderingContext at: 4) add: (renderingContext at: 1) asWebString , '.'
								withDelimiter: '')].
	children do: 
			[:eachChildNode | 
			page := application getPage: eachChildNode pageName language: eachChildNode languageName.
			page isNil 
				ifFalse: 
					[currentRC := self 
								writePrintableWikiPageContentsFor: page getCurrentVersion
								using: currentRC
								pageToPageNumberDictionary: pageToPageNumberDictionary
								firstPass: aBoolean.
					self 
						writePrintableWikiPageContentsForChildrenOf: eachChildNode
						using: currentRC
						pageToPageNumberDictionary: pageToPageNumberDictionary
						firstPass: aBoolean]].
	^renderingContext at: 2 put: (currentRC at: 1)!

writeReferencesToPage: pageVersion 
	| refs eachPage eachPageLanguage eachPageName defaultLanguage |
	defaultLanguage := Processor activeProcess language.
	(refs := pageVersion page referencesToPage) isNilOrEmpty ifTrue: [^nil].
	htmlStream 
		nextPutAll: '<br /><div id="wikiReferencesToPage"><h3>' 
				, 'WikiDoc.ReferencesToPage' webTranslate webHtmlEncoded , '</h3><p><ul>'.
	refs do: 
			[:eachRef | 
			eachRef class == Association 
				ifTrue: 
					[eachPage := eachRef value.
					eachPageLanguage := eachRef key]
				ifFalse: 
					[eachPage := eachRef.
					eachPageLanguage := defaultLanguage].
			eachPageName := eachPage pageName.
			htmlStream nextPutAll: '<li>'.
			htmlStream
				nextPutAll: (WikiDocPageParser 
							pageLinkFor: eachPageName
							pageTitle: eachPage getPageTitle
							pageLanguage: eachPageLanguage
							defaultLanguage: defaultLanguage
							application: application);
				nextPutAll: eachPage getPageTitle webHtmlEncoded;
				nextPutAll: '</a></li>'].
	htmlStream nextPutAll: '</ul></p></div>'!

writeSearchEngineNotification
	"This method will write HTML frament for notice for users who came to wiki site via search engine e.g. Google, najdi.si, ..."

	!

writeSubtitle: aString 
	self writeTitle: aString!

writeTitle: aString 
	htmlStream
		nextPutAll: '<h2>';
		nextPutAll: aString webTranslate webHtmlEncoded;
		nextPutAll: '</h2>'!

writeTitleBar: aString 
	self writeTitle: aString!

writeTitleBar: aString helpPage: pageName 
	self writeTitle: aString!

writeToolbar
	defaultToolbar isNil ifFalse: [self toolbar: defaultToolbar]!

writeTopNavigationTabs
	^self writeToolbar!

writeWikiPageContents: contents for: pageVersion 
	| ws |
	ws := WriteStream on: (String new: 10240).
	
	[WikiDocPageParser new 
		generateHtmlFrom: contents
		for: pageVersion
		on: ws
		urlPrefix: urlPrefix
		application: application
		session: session] 
			on: Error
			do: 
				[:ex | 
				ws := WriteStream on: (String new: 1024).
				WikiDocPageParser new 
					generateHtmlFrom: '==' , pageVersion page pageName , '==

' 
							, 'WikiDoc.PageRenderingError' webTranslate
					for: pageVersion
					on: ws
					urlPrefix: urlPrefix
					application: application
					session: session.
				ex exitWith: nil].
	(Processor activeProcess attributes at: #addWikiTooltipScript ifAbsent: []) = true 
		ifTrue: [htmlWriter javascript: self toolTipScript].
	htmlStream nextPutAll: (self importInnerHtmlForDivsWithExternalSourceOn: ws contents)! !
!WikiDocCoder categoriesFor: #addAdminLinkFor:label:image:language:!private! !
!WikiDocCoder categoriesFor: #addSearchResultsNavigationLinksTo:nextPage:previousPage:resultsPerPage:!displaying search results!public! !
!WikiDocCoder categoriesFor: #advanceSearchPage:!displaying search results!public! !
!WikiDocCoder categoriesFor: #defaultContentsPageMargin!public!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #editPageVersionFormPage:errors:isNewPage:previewContents:!editing pages!public! !
!WikiDocCoder categoriesFor: #fileUploadFormField:formName:uploadAction:removeAction:removeLabel:labelText1:labelText2:fileDocument:hiddenFields:!public! !
!WikiDocCoder categoriesFor: #fileUploadPage:errors:fileName:!public! !
!WikiDocCoder categoriesFor: #getCollapsedContentsForNode:!private! !
!WikiDocCoder categoriesFor: #getCollapsedContentsForNodeLink:!private! !
!WikiDocCoder categoriesFor: #getExpandedContentsForNode:!private! !
!WikiDocCoder categoriesFor: #getExpandedContentsForNodeLink:!private! !
!WikiDocCoder categoriesFor: #getInnerHtmlForUrl:!private!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #getTableOfContentsTableFor:urlPostfix:!private! !
!WikiDocCoder categoriesFor: #highlightedText:forIntervals:!displaying search results!private! !
!WikiDocCoder categoriesFor: #imageFileUploadFormField:formName:uploadAction:removeAction:removeLabel:labelText1:labelText2:imageDocument:hiddenFields:maxWidth:maxHeight:!public! !
!WikiDocCoder categoriesFor: #imageUploadPage:errors:imageName:!public! !
!WikiDocCoder categoriesFor: #importInnerHtmlForDivsWithExternalSourceOn:!private!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #isOldBrowserCompatibilityMode:!private! !
!WikiDocCoder categoriesFor: #loginPage:!public! !
!WikiDocCoder categoriesFor: #pageContents:!public! !
!WikiDocCoder categoriesFor: #pageContents:pageVersion:!public! !
!WikiDocCoder categoriesFor: #showControlPanelPage!public!server administration! !
!WikiDocCoder categoriesFor: #showEndOfPageDisclaimerFragment!private! !
!WikiDocCoder categoriesFor: #showEndOfPageDisclaimerFragmentForPrint!private! !
!WikiDocCoder categoriesFor: #showLastSessionsList:!public! !
!WikiDocCoder categoriesFor: #showPageVersion:!public! !
!WikiDocCoder categoriesFor: #showPageVersionForPrint:printChapterBool:!public! !
!WikiDocCoder categoriesFor: #showPageVersionsList:currentVersion:!public! !
!WikiDocCoder categoriesFor: #showRecentChangesList:!public! !
!WikiDocCoder categoriesFor: #showSearchFormForImageOkAndCancel:!displaying search results!images selector!public! !
!WikiDocCoder categoriesFor: #showSearchFormForLink:!displaying search results!link browser selector!public! !
!WikiDocCoder categoriesFor: #showSearchFormForLinkOkAndCancel:!displaying search results!link browser selector!public! !
!WikiDocCoder categoriesFor: #showTableOfContents:indexToNodeDict:numberOfNodes:selectedNode:!public! !
!WikiDocCoder categoriesFor: #showTableOfContentsForLink:indexToNodeDict:numberOfNodes:selectedNode:!link browser selector!public! !
!WikiDocCoder categoriesFor: #showTableOfContentsSearchForm:!public! !
!WikiDocCoder categoriesFor: #showTopReferers:!public!server administration! !
!WikiDocCoder categoriesFor: #showTopReferersGetTop20EntriesFrom:atIndex:!private!server administration! !
!WikiDocCoder categoriesFor: #showUserEditPage:errors:isNewUser:!public!user administration! !
!WikiDocCoder categoriesFor: #showUserOverviewPage:coll:searchFields:!public!user administration! !
!WikiDocCoder categoriesFor: #showWikiSessionEvents:!public!server administration! !
!WikiDocCoder categoriesFor: #toolbar:!general layout!private! !
!WikiDocCoder categoriesFor: #toolTipScript!private!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #wikiDocChangePasswordConfirmationPage!public! !
!WikiDocCoder categoriesFor: #wikiDocChangePasswordPage:errors:!public! !
!WikiDocCoder categoriesFor: #wikiDocImageSelectorSearchFrame!displaying search results!images selector!public! !
!WikiDocCoder categoriesFor: #wikiDocImagesSelectorOverviewPage:images:showPrevious:showNext:pageNumberLinkArray:searchString:!displaying search results!images selector!public! !
!WikiDocCoder categoriesFor: #wikiDocNoSearchResultsPage:!displaying search results!public! !
!WikiDocCoder categoriesFor: #wikiDocUploadedFilesOverviewPage:coll:searchFields:!public!user administration! !
!WikiDocCoder categoriesFor: #wikiPage:focusField:!public! !
!WikiDocCoder categoriesFor: #wikiPageConfirmRemovePage:!editing pages!public! !
!WikiDocCoder categoriesFor: #wikiPageTitle:!private!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #wikiSearchResultPage:resultsPerPage:startIndex:searchFields:!displaying search results!public! !
!WikiDocCoder categoriesFor: #writeDefaultWikiPageContentsFor:!private!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #writePrintableWikiPageContentsFor:using:pageToPageNumberDictionary:firstPass:!private!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #writePrintableWikiPageContentsForChildrenOf:using:pageToPageNumberDictionary:firstPass:!public!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #writeReferencesToPage:!private!wiki page HTML generation! !
!WikiDocCoder categoriesFor: #writeSearchEngineNotification!public! !
!WikiDocCoder categoriesFor: #writeSubtitle:!general layout!public! !
!WikiDocCoder categoriesFor: #writeTitle:!general layout!public! !
!WikiDocCoder categoriesFor: #writeTitleBar:!general layout!public! !
!WikiDocCoder categoriesFor: #writeTitleBar:helpPage:!general layout!public! !
!WikiDocCoder categoriesFor: #writeToolbar!general layout!private! !
!WikiDocCoder categoriesFor: #writeTopNavigationTabs!general layout!public! !
!WikiDocCoder categoriesFor: #writeWikiPageContents:for:!private!wiki page HTML generation! !

