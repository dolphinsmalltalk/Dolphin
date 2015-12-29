"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WikiDocImageSelectorServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocImageSelectorServlet guid: (GUID fromString: '{38B57BBD-A737-42C1-9EC0-7FB4F1CE2483}')!
WikiDocImageSelectorServlet comment: ''!
!WikiDocImageSelectorServlet categoriesForClass!Unclassified! !
!WikiDocImageSelectorServlet methodsFor!

createHtmlForImages: images 
	| content |
	content := WriteStream on: (String new: 40000).
	content nextPutAll: '<table cellspacing=''15'' width="100%"><tr><td>'.
	images doWithIndex: 
			[:each :i | 
			content 
				nextPutAll: '<div onClick="select(this,''' , each imageName webHttpUrlEncoded , ''', ' 
						, (each width isNil ifTrue: [''''''] ifFalse: [each width printString]) , ', ' 
						, (each height isNil ifTrue: [''''''] ifFalse: [each height printString]) 
							, ')" onDblClick="preusmeri(''' , each imageName webHttpUrlEncoded 
						, ''', ' , (each width isNil ifTrue: [''''''] ifFalse: [each width printString]) 
						, ', ' , (each height isNil ifTrue: [''''''] ifFalse: [each height printString]) 
						, ')" style="float:left;width:200px;height:150px;"><table width="100%" height="100%" cellpadding="2"><tr><td align="center" valign="middle" height="100%" width="100%" style="border:1px solid #e0e0e0">'.
			content 
				nextPutAll: '<div style="overflow:hidden;width:' , WikiDocImage maxThumbnailWidth printString 
						, 'px;height:' , WikiDocImage maxThumbnailHeight printString 
						, 'px;"><img src=''/WikiDoc/thumbnails-small/' , each imageName 
						, '''/></div></td></tr><tr><td align="center"><small>' , each imageName webHtmlEncoded 
						, '</small></td></tr><tr><td align="center" nowrap="nowrap"><small>' 
							, (each width asWebString add: each height asWebString withDelimiter: 'x') , ' ' 
						, 'Dokument.fileSize' webTranslate , ': ' 
						, (each fileSize / 1024.0s roundTo: 0.01s) asWebStringWithMinimumDecimals , 'kB' 
						, '</small></td></tr></table></div>'].
	content nextPutAll: '</td></tr></table>'.
	^content contents!

firstImageIndexForPage: pn 
	^(pn - 1) * self maxImagesPerPage + 1!

lastImageIndexForPage: pn 
	^pn * self maxImagesPerPage!

maxImagesPerPage
	^25!

process: request on: stream 
	| t session lang user |
	session := self checkOrSetDefaultClientIdCookieAndSessionFor: request on: stream.

	"set default language for processing the request"
	(application applicationLanguages includes: (lang := request stringOrNilAt: 'lang')) 
		ifTrue: [Processor activeProcess language: lang].
	t := application newReadOnlyTransaction.
	
	[
	[session isNil ifFalse: [user := session user].
	((application configurationSettingsAt: 'application.loginForPreviewRequired') = 'true' 
		and: [user isNil]) ifTrue: [^application indexServlet processLogin: request on: stream].
	self 
		dispatch: request
		using: #(#processDefault:on: #processShowThumbnailsFrame:on: #processShowThumbnailsSearchFrame:on: #processThumbnailsSearchFormOKAndCancel:on: #processSearchImages:on: #processPreviousPage:on: #processNextPage:on: #processDeleteImage:on:)
		on: stream
		withDefault: #processDefault:on:] 
			evaluateIn: t] 
			ensure: [t abort]!

processDefault: request on: stream 
	self reloadResponseForImagePageOn: stream request: request!

processDeleteImage: request on: stream 
	| t imageName images num arr pn |
	num := 0.
	arr := Set new.
	t := application db newTransaction.
	imageName := request stringOrNilAt: 'imageName'.
	(pn := (request integerAt: 'pn') - 1) isNilOrZero ifTrue: [pn := 1].
	images := t root at: 'Image.name'.
	images removeKey: imageName.
	t commit.
	images := self searchImages: nil.
	images size isZero 
		ifFalse: 
			[num := images size // self maxImagesPerPage.
			images size \\ self maxImagesPerPage > 0 ifTrue: [num := num + 1]].
	num isZero ifFalse: [1 to: num do: [:each | arr add: each]].
	arr notEmpty 
		ifTrue: [arr := arr select: [:eachIndex | eachIndex < (pn + 5) and: [eachIndex > (pn - 5)]]].
	self processShowThumbnailsFrame: request on: stream!

processNextPage: request on: stream 
	self processShowThumbnailsFrame: request on: stream!

processPreviousPage: request on: stream 
	self processShowThumbnailsFrame: request on: stream!

processSearchImages: request on: stream 
	self processShowThumbnailsFrame: request on: stream!

processShowThumbnailsFrame: request on: stream 
	| pn images lastImageIndex showNext arr num |
	lastImageIndex := 0.
	num := 0.
	arr := Set new.
	showNext := true.
	(pn := request integerAt: 'pn') isNil ifTrue: [pn := 1].
	images := self searchImages: (request stringOrNilAt: 'findString').
	images size isZero 
		ifFalse: 
			[num := images size // self maxImagesPerPage.
			images size \\ self maxImagesPerPage > 0 ifTrue: [num := num + 1]].
	num isZero ifFalse: [1 to: num do: [:each | arr add: each]].
	arr notEmpty 
		ifTrue: [arr := arr select: [:eachIndex | eachIndex < (pn + 5) and: [eachIndex > (pn - 5)]]].
	images isEmpty 
		ifFalse: 
			[(lastImageIndex := self lastImageIndexForPage: pn) > images size 
				ifTrue: 
					[lastImageIndex := images size.
					showNext := false].
			images := images copyFrom: (self firstImageIndexForPage: pn) to: lastImageIndex].
	(self newCoder: stream) 
		wikiDocImagesSelectorOverviewPage: pn
		images: images
		showPrevious: pn > 1
		showNext: (showNext and: [lastImageIndex > 0])
		pageNumberLinkArray: arr
		searchString: (request stringOrNilAt: 'findString')!

processShowThumbnailsSearchFrame: request on: stream 
	(self newCoder: stream)
		style: application cssStyleTableOfContents;
		wikiDocImageSelectorSearchFrame!

processThumbnailsSearchFormOKAndCancel: request on: stream 
	(self newCoder: stream)
		style: application cssStyleTableOfContents;
		showSearchFormForImageOkAndCancel: nil!

reloadResponseForImagePageOn: stream request: request 
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
				, #processShowThumbnailsSearchFrame:on: webAsActionString , '&lang=' 
				, language 
					, '" name="thumbnailSearchForm" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="0" border="0" scrolling="no"></frame>
  		<frame src="' 
					, self urlPrefix , '?action=' 
				, #processShowThumbnailsFrame:on: webAsActionString , '&page=' 
				, language webHttpUrlEncoded , '&lang=' 
				, language 
					, '" name="thumbnailsFrame" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="0" border="0"></frame>
<frame src="' 
					, self urlPrefix , '?action=' 
				, #processThumbnailsSearchFormOKAndCancel:on: webAsActionString , '&lang=' 
				, language 
					, '" name="tocSearchFormOKAndCancelFrame" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" frameborder="0" border="0" scrolling="no"></frame>
	</frameset>
<body>
<h1>WikiDoc - the documentation wiki</h1>
<p>WikiDoc is an on-line collaboration system for writing hierachical documentation (user manuals, intranets, process documentation, references, ...). It comes in a form of a stand-alone wiki system. Download, install and run. And you are ready to write on-line documentation or even host a web page using a wiki.</p>
</body>
</html>'!

searchImages: searchString 
	| all images |
	all := (application db newTransaction root at: 'Image.name') values 
				asSortedCollection: (ItcSortBlock with: #imageName).
	images := searchString isNil 
				ifFalse: [all select: [:eachImage | searchString asUppercase match: eachImage imageName asUppercase]]
				ifTrue: [all].
	^images! !
!WikiDocImageSelectorServlet categoriesFor: #createHtmlForImages:!public! !
!WikiDocImageSelectorServlet categoriesFor: #firstImageIndexForPage:!private! !
!WikiDocImageSelectorServlet categoriesFor: #lastImageIndexForPage:!private! !
!WikiDocImageSelectorServlet categoriesFor: #maxImagesPerPage!private! !
!WikiDocImageSelectorServlet categoriesFor: #process:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processDefault:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processDeleteImage:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processNextPage:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processPreviousPage:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processSearchImages:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processShowThumbnailsFrame:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processShowThumbnailsSearchFrame:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #processThumbnailsSearchFormOKAndCancel:on:!public! !
!WikiDocImageSelectorServlet categoriesFor: #reloadResponseForImagePageOn:request:!public! !
!WikiDocImageSelectorServlet categoriesFor: #searchImages:!public! !

!WikiDocImageSelectorServlet class methodsFor!

servletName
	^'ImageSelector.html'! !
!WikiDocImageSelectorServlet class categoriesFor: #servletName!public! !

