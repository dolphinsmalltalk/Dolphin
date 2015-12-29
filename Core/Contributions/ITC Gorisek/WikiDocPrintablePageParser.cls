"Filed out from Dolphin Smalltalk X6.1"!

WikiDocPageParser subclass: #WikiDocPrintablePageParser
	instanceVariableNames: 'h1Index h2Index headingPrefix pageToPageNumberDictionary'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocPrintablePageParser guid: (GUID fromString: '{5F57657E-5E72-4AF9-A633-07515BD1367E}')!
WikiDocPrintablePageParser comment: ''!
!WikiDocPrintablePageParser categoriesForClass!Unclassified! !
!WikiDocPrintablePageParser methodsFor!

h1Index
	^h1Index!

h1Index: anObject
	h1Index := anObject!

h2Index
	^h2Index!

h2Index: anObject
	h2Index := anObject!

headingPrefix
	^headingPrefix!

headingPrefix: anObject 
	headingPrefix := anObject!

pageToPageNumberDictionary: aDictionary 
	pageToPageNumberDictionary := aDictionary!

renderingContext
	^Array 
		with: h1Index
		with: h2Index
		with: figures
		with: headingPrefix!

renderingContext: anArray 
	anArray isNil 
		ifFalse: 
			[h1Index := anArray at: 1.
			h2Index := anArray at: 2.
			figures := anArray at: 3.
			headingPrefix := anArray at: 4]!

writeExternalLinkFrom: rs 
	| content tokens url linkTitle linkText request |
	rs next.
	content := rs upTo: $].
	(content indexOf: $ ) = 0 
		ifTrue: 
			[url := content.
			linkTitle := content]
		ifFalse: 
			[url := content copyFrom: 1 to: (content indexOf: $ ) - 1.
			linkTitle := content copyFrom: url size + 2 to: content size].
	url = linkTitle 
		ifTrue: 
			[writeStream
				nextPutAll: '<a href="' , url webHtmlEncodedForForm , '" title="' 
							, linkTitle webHtmlEncodedForForm , '" class="external" target="_blank">';
				nextPutAll: linkTitle webHtmlEncoded;
				nextPutAll: '</a>']
		ifFalse: 
			[writeStream
				nextPutAll: '<b>' , linkTitle webHtmlEncoded , '</b>';
				nextPutAll: ' [<a href="';
				nextPutAll: url webHtmlEncodedForForm;
				nextPutAll: '" target="_blank">';
				nextPutAll: url webHtmlEncoded;
				nextPutAll: '</a>]']!

writeHeading: line fromStream: readStream 
	| title number |
	title := line copyFrom: 3 to: line size - 2.
	self clearIdentAndParagraph.
	h1Index isNil ifTrue: [h1Index := 0] ifFalse: [h1Index := h1Index + 1].
	h2Index := 0.
	writeStream 
		nextPutAll: '<h1>' , (h1Index = 0 
						ifFalse: 
							[number := headingPrefix asWebString , h1Index printString.
							number , '. ']
						ifTrue: ['']) 
				, title webHtmlEncoded , '</h1>'.
	pageTitle isNil 
		ifTrue: 
			[pageTitle := title.
			(pageToPageNumberDictionary isNil or: [number isNil]) 
				ifFalse: [pageToPageNumberDictionary at: pageVersion page pageName put: number]].
	self clearNextEmptyLineFrom: readStream!

writeHeading2: line fromStream: readStream 
	| title |
	title := line copyFrom: 4 to: line size - 3.
	self clearIdentAndParagraph.
	(h1Index isNil or: [h1Index = 0]) ifTrue: [h1Index := 1].
	h2Index isNil ifTrue: [h2Index := 1] ifFalse: [h2Index := h2Index + 1].
	writeStream 
		nextPutAll: '<h2>' , headingPrefix asWebString , h1Index printString , '.' , h2Index printString 
				, ' ' , title webHtmlEncoded 
				, '</h2>'.
	self clearNextEmptyLineFrom: readStream!

writePageLinkFrom: rs 
	| content tokens url pageId linkText index langName pageNumber |
	rs next: 2.
	content := rs itcUpToAll: ']]'.
	tokens := content itcSubStrings: $|.
	pageId := tokens at: 1.
	tokens size > 1 ifTrue: [linkText := tokens at: 2] ifFalse: [linkText := tokens at: 1].
	writeStream nextPutAll: linkText webHtmlEncoded.
	(index := pageId indexOfSubCollection: '\\') > 0 
		ifTrue: 
			[langName := pageId copyFrom: 1 to: index - 1.
			pageId := pageId copyFrom: index + 2 to: pageId size]
		ifFalse: [langName := defaultLanguage].
	(pageId isNilOrEmpty not and: 
			[langName = defaultLanguage and: 
					[pageToPageNumberDictionary notNil 
						and: [(pageNumber := pageToPageNumberDictionary at: pageId ifAbsent: []) notNil]]]) 
		ifTrue: [writeStream nextPutAll: ' <b>[' , pageNumber , ']</b>']!

writeToolTipReferenceFrom: rs 
	| content partContent count toolTipId newStream |
	content := WriteStream on: String new.
	rs skipTo: $:.
	rs upTo: $:.
	partContent := rs itcUpToAll: ']]'.
	count := 0.
	[rs atEnd not and: [(count := count + (self occurrencesOfAll: '[[' in: partContent)) > 0]] 
		whileTrue: 
			[content
				nextPutAll: partContent;
				nextPutAll: ']]'.
			partContent := rs itcUpToAll: ']]'.
			count := count - 1].
	content nextPutAll: partContent.
	content := content contents.
	toolTipId := content hash printString , '_' , toolTipIds size printString.
	writeStream
		nextPutAll: '<span id="toolTip';
		nextPutAll: toolTipId;
		nextPutAll: '">'.
	newStream := ReadStream on: content.
	self parseParagraphContentsFrom: newStream.
	writeStream nextPutAll: '</span>'! !
!WikiDocPrintablePageParser categoriesFor: #h1Index!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #h1Index:!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #h2Index!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #h2Index:!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #headingPrefix!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #headingPrefix:!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #pageToPageNumberDictionary:!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #renderingContext!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #renderingContext:!accessing!public! !
!WikiDocPrintablePageParser categoriesFor: #writeExternalLinkFrom:!private! !
!WikiDocPrintablePageParser categoriesFor: #writeHeading:fromStream:!private! !
!WikiDocPrintablePageParser categoriesFor: #writeHeading2:fromStream:!private! !
!WikiDocPrintablePageParser categoriesFor: #writePageLinkFrom:!private! !
!WikiDocPrintablePageParser categoriesFor: #writeToolTipReferenceFrom:!private! !

