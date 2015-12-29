"Filed out from Dolphin Smalltalk X6.1"!

WikiDocObject subclass: #WikiDocPageVersion
	instanceVariableNames: 'page pageTitle contents parentPage editIP editHostname editTS editUserAgent editSession pagePos isLeafPage tocNodeIcon keywords pageFormat dateFrom dateTo'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocPageVersion guid: (GUID fromString: '{E6822655-C4E0-4FAA-9598-24BA7FF277CB}')!
WikiDocPageVersion comment: ''!
!WikiDocPageVersion categoriesForClass!Unclassified! !
!WikiDocPageVersion methodsFor!

contents
	^contents!

contents: anObject
	contents := anObject!

dateFrom
	^dateFrom!

dateFrom: aDateOrNil 
	dateFrom := aDateOrNil!

dateTo
	^dateTo!

dateTo: aDateOrNil 
	dateTo := aDateOrNil!

editIP
	^editIP!

editIP: anObject
	editIP := anObject!

editSession
	^editSession!

editSession: anObject
	editSession := anObject!

editTS
	^editTS!

editTS: anObject
	editTS := anObject!

editUserAgent
	^editUserAgent!

editUserAgent: anObject
	editUserAgent := anObject!

isLeafPage
	^isLeafPage = true!

isLeafPage: anObject
	isLeafPage := anObject!

keywords
	^keywords!

keywords: aCollection 
	keywords := aCollection!

keywordsSeparatedByComma
	| str |
	keywords isNilOrEmpty 
		ifFalse: [keywords do: [:eachKeyword | str := str add: eachKeyword withDelimiter: ', ']].
	^str!

page
	^page!

page: anObject
	page := anObject!

pageFormat
	"Answer either:
		#wikiDocPageFormatWikiMarkup - page contents is written in WikiDoc markup
		#wikiDocPageFormatHTML - page contents is written in HTML using FCKEditor
		#wikiDocPageFormatPlainHTML - page contents is written in HTML using regular text area

	If <nil> or anything else than HTML, answer WikiDoc markup format (previously no page format option was available - FCKEditor option was added later)."

	^(pageFormat == #wikiDocPageFormatHTML or: [pageFormat == #wikiDocPageFormatPlainHTML]) 
		ifTrue: [pageFormat]
		ifFalse: [#wikiDocPageFormatWikiMarkup]!

pageFormat: anObject
	pageFormat := anObject!

pagePosition
	^pagePos!

pagePosition: anObject
	pagePos := anObject!

pageTitle
	^pageTitle!

pageTitle: aStringOrNil 
	pageTitle := aStringOrNil!

parentPage
	^parentPage!

parentPage: anObject 
	parentPage := anObject!

tocNodeIcon
	^(#('page1.gif' 'page2.gif' 'page3.gif') includes: tocNodeIcon) 
		ifTrue: [tocNodeIcon]
		ifFalse: ['page1.gif']!

tocNodeIcon: anObject
	tocNodeIcon := anObject!

versionInfoFor: session 
	| userInfo addressInfo editUser str |
	str := ''.
	self editTS isNil 
		ifFalse: 
			[str := str , 'WikiDoc.SearchResultsLastChanged' webTranslate , ' ' 
						, self editTS asWebString].
	(session user isNil or: [editSession isNil]) ifTrue: [^str].
	editUser := editSession user.
	editUser isNil 
		ifTrue: [userInfo := 'WikiDoc.EditInfoUserUnknown' webTranslate]
		ifFalse: [userInfo := editUser username].
	addressInfo := editSession loginIP = self editIP 
				ifTrue: 
					[editSession loginHostname = 'N/A' 
						ifFalse: [editSession loginHostname asWebString , ' (' , self editIP asWebString , ')']
						ifTrue: [self editIP]]
				ifFalse: [self editIP].
	^'WikiDoc.EditInfoByUser' 
		webTranslateWith: self editTS asWebString
		with: userInfo asWebString
		with: addressInfo asWebString! !
!WikiDocPageVersion categoriesFor: #contents!accessing!public! !
!WikiDocPageVersion categoriesFor: #contents:!accessing!public! !
!WikiDocPageVersion categoriesFor: #dateFrom!accessing!public! !
!WikiDocPageVersion categoriesFor: #dateFrom:!accessing!public! !
!WikiDocPageVersion categoriesFor: #dateTo!accessing!public! !
!WikiDocPageVersion categoriesFor: #dateTo:!accessing!public! !
!WikiDocPageVersion categoriesFor: #editIP!accessing!public! !
!WikiDocPageVersion categoriesFor: #editIP:!accessing!public! !
!WikiDocPageVersion categoriesFor: #editSession!accessing!public! !
!WikiDocPageVersion categoriesFor: #editSession:!accessing!public! !
!WikiDocPageVersion categoriesFor: #editTS!accessing!public! !
!WikiDocPageVersion categoriesFor: #editTS:!accessing!public! !
!WikiDocPageVersion categoriesFor: #editUserAgent!accessing!public! !
!WikiDocPageVersion categoriesFor: #editUserAgent:!accessing!public! !
!WikiDocPageVersion categoriesFor: #isLeafPage!accessing!public! !
!WikiDocPageVersion categoriesFor: #isLeafPage:!accessing!public! !
!WikiDocPageVersion categoriesFor: #keywords!accessing!public! !
!WikiDocPageVersion categoriesFor: #keywords:!accessing!public! !
!WikiDocPageVersion categoriesFor: #keywordsSeparatedByComma!accessing!public! !
!WikiDocPageVersion categoriesFor: #page!accessing!public! !
!WikiDocPageVersion categoriesFor: #page:!accessing!public! !
!WikiDocPageVersion categoriesFor: #pageFormat!accessing!public! !
!WikiDocPageVersion categoriesFor: #pageFormat:!accessing!public! !
!WikiDocPageVersion categoriesFor: #pagePosition!accessing!public! !
!WikiDocPageVersion categoriesFor: #pagePosition:!accessing!public! !
!WikiDocPageVersion categoriesFor: #pageTitle!accessing!public! !
!WikiDocPageVersion categoriesFor: #pageTitle:!accessing!public! !
!WikiDocPageVersion categoriesFor: #parentPage!accessing!public! !
!WikiDocPageVersion categoriesFor: #parentPage:!accessing!public! !
!WikiDocPageVersion categoriesFor: #tocNodeIcon!accessing!public! !
!WikiDocPageVersion categoriesFor: #tocNodeIcon:!accessing!public! !
!WikiDocPageVersion categoriesFor: #versionInfoFor:!accessing!public! !

