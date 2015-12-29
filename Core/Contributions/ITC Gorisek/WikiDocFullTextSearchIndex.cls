"Filed out from Dolphin Smalltalk X6.1"!

ItcFullTextSearchIndex subclass: #WikiDocFullTextSearchIndex
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocFullTextSearchIndex guid: (GUID fromString: '{D9CC6846-805A-4E45-8297-5670C273973D}')!
WikiDocFullTextSearchIndex comment: ''!
!WikiDocFullTextSearchIndex categoriesForClass!Unclassified! !
!WikiDocFullTextSearchIndex methodsFor!

findPagesMatching: aString languages: languageNames maxResults: maxResults parentNodes: parentNodes 
	"Vrne rezultat iskanja sporocil po frazi v aString.
	Ce parameter <parentNodes> ni enak <nil>, potem isce samo po straneh v poglavjih, ki so nastete v parentNodes."

	| searchStrings results coll sortBlock |
	searchStrings := self getSearchTokensForSearch: (self convertToSearchKey: aString)
				maxSize: self fullTextSearchKeySize.
	searchStrings isNilOrEmpty ifTrue: [^nil].
	results := OrderedCollection new.
	searchStrings doWithIndex: 
			[:eachSearchStringColl :rankIndex | 
			results size > maxResults 
				ifTrue: 
					[parentNodes isNil 
						ifFalse: 
							["po poglavjih filtrira samo v primeru, ce je prevec rezultatov"
							results := results reject: 
											[:each | 
											(parentNodes detect: 
													[:eachParentNode | 
													(application getTOCNodeForPage: (each at: 3) pageName language: (each at: 1)) 
														isEqualOrUnderNode: eachParentNode]
												ifNone: []) isNil]]].
			results size > maxResults 
				ifFalse: 
					[eachSearchStringColl do: 
							[:eachSearchString | 
							coll := self 
										findPagesMatchingSearchString: eachSearchString
										languages: languageNames
										maxResults: maxResults
										levelRanking: rankIndex * 10
										parentNodes: parentNodes.
							coll do: 
									[:each | 
									results detect: 
											[:eachResult | 
											((eachResult at: 3) isIdenticalTo: (each at: 3)) 
												ifTrue: 
													[((eachResult at: 2) indexOfSubCollection: (each at: 2) startingAt: 1) > 0 
														ifFalse: [eachResult at: 2 put: (eachResult at: 2) , ' ' , (each at: 2)].
													eachResult at: 4 put: (eachResult at: 4) - 2.
													true]
												ifFalse: [false]]
										ifNone: [results add: each]]]]].
	sortBlock := ItcSortBlock with: [:a | a at: 4].
	results := (results asSortedCollection: sortBlock) copyFrom: 1
				to: (maxResults min: results size).
	"ce je relevantno odstrani se tiste, ki niso v pravih poglavjih"
	parentNodes isNil 
		ifFalse: 
			["po poglavjih filtrira samo v primeru, ce je prevec rezultatov"
			results := results reject: 
							[:each | 
							(parentNodes detect: 
									[:eachParentNode | 
									(application getTOCNodeForPage: (each at: 3) pageName language: (each at: 1)) 
										isEqualOrUnderNode: eachParentNode]
								ifNone: []) isNil]].
	sortBlock := ItcSortBlock with: [:a | a at: 4] with: [:a | (a at: 3) pageRankingValue].
	sortBlock invertAscendingDescendingForIndex: 2.
	^results asSortedCollection: sortBlock!

findPagesMatchingSearchString: eachSearchString language: eachLanguage maxResults: maxResults levelRanking: levelRanking parentNodes: parentNodes 
	| results dict asoc toKey ranking |
	results := OrderedCollection new.
	(dict := application fullTextSearchIndexFor: eachLanguage) isNil ifTrue: [^results].
	dict goTo: eachSearchString.
	toKey := self maxKeyFor: eachSearchString.
	(asoc := dict getCurrent) isNil ifTrue: [asoc := dict getNext].
	[asoc notNil and: [(toKey odbIsLessThan: asoc key) not]] whileTrue: 
			[(eachSearchString size = self fullTextSearchKeySize 
				or: [(asoc key at: eachSearchString size + 1) asInteger = 32]) 
					ifTrue: [ranking := levelRanking]
					ifFalse: [ranking := levelRanking + 1].
			results detect: [:each | (each at: 3) isIdenticalTo: asoc value]
				ifNone: 
					[results add: (Array 
								with: eachLanguage
								with: eachSearchString
								with: asoc value
								with: ranking)].
			results size < maxResults 
				ifFalse: 
					[parentNodes isNil ifTrue: [^results].
					"po poglavjih filtrira samo v primeru, ce je prevec rezultatov"
					results := results reject: 
									[:each | 
									(parentNodes detect: 
											[:eachParentNode | 
											(application getTOCNodeForPage: (each at: 3) pageName language: eachLanguage) 
												isEqualOrUnderNode: eachParentNode]
										ifNone: []) isNil].
					results size < maxResults ifFalse: [^results]].
			asoc := dict getNext].
	^results!

findPagesMatchingSearchString: eachSearchString languages: languages maxResults: maxResults levelRanking: levelRanking parentNodes: parentNodes 
	| results dict asoc toKey |
	results := OrderedCollection new.
	languages do: 
			[:eachLanguage | 
			results addAll: (self 
						findPagesMatchingSearchString: eachSearchString
						language: eachLanguage
						maxResults: maxResults
						levelRanking: levelRanking
						parentNodes: parentNodes)].
	^results!

findTextMatching: aString onPage: aWikiDocPage 
	"Vrne collection of: (Array with: startIndex with: endIndex)"

	| searchStrings results plainText indices startIndex asoc coll currentIndex start end messageText |
	results := OrderedCollection new.
	coll := self getSearchTokensForSearch: (self convertToSearchKey: aString)
				maxSize: self fullTextSearchKeySize.
	searchStrings := OrderedCollection new.
	coll do: [:each | each do: [:eachStr | searchStrings add: eachStr]].
	messageText := self getPlainTextFor: aWikiDocPage getCurrentVersion.
	plainText := self convertToSearchKey: messageText.
	searchStrings isEmpty 
		ifFalse: 
			[searchStrings do: 
					[:eachSearchString | 
					currentIndex := 1.
					(startIndex := plainText indexOfSubCollection: eachSearchString startingAt: currentIndex) 
						> 0 
							ifTrue: 
								[indices := self indicesForConvertToSearchKey: messageText.
								
								[start := indices at: startIndex.
								end := indices at: startIndex + eachSearchString size - 1.
								results add: (Array with: start with: end).
								currentIndex := end.
								startIndex := plainText indexOfSubCollection: eachSearchString startingAt: currentIndex.
								startIndex > 0] 
										whileTrue: []]]].
	^Association key: messageText value: results!

getPlainTextFor: aWikiDocPageVersion 
	| plainText ws |
	ws := WriteStream on: String new.
	
	[WikiDocIndexingPageParser new 
		generateHtmlFrom: aWikiDocPageVersion contents
		for: aWikiDocPageVersion
		on: ws
		urlPrefix: ''
		application: application
		session: nil] 
			on: Error
			do: [:ex | ].
	^(HtmlParserPage fromString: ws contents) plainTextContents!

getSearchTokensFor: aWikiDocPageVersion 
	| plainText allTokens uniqueTokens |
	plainText := self getPlainTextFor: aWikiDocPageVersion.
	allTokens := OrderedCollection new.
	(self divideSentences: plainText) do: 
			[:eachSentence | 
			allTokens 
				addAll: (self getSearchTokens: eachSentence maxSize: self fullTextSearchKeySize)].
	uniqueTokens := OrderedCollection new: allTokens size.
	allTokens asSet do: 
			[:eachToken | 
			allTokens 
				detect: [:otherToken | (otherToken beginsWith: eachToken) and: [otherToken ~= eachToken]]
				ifNone: [uniqueTokens add: eachToken]].
	^uniqueTokens!

updateFullTextSearchIndex
	| t oid page |
	application applicationLanguages do: 
			[:eachLanguage | 
			t := application newTransaction.
			application createNewFullTextSearchDictionaryFor: eachLanguage in: t.
			t commit.
			((application getCompleteTableOfContentsFor: eachLanguage) at: 3) keys do: 
					[:eachPageName | 
					
					[page := application getPage: eachPageName language: eachLanguage.
					page isNil 
						ifFalse: 
							[self 
								updateFullTextSearchIndexForPageVersion: page currentVersion
								indexDict: (application fullTextSearchIndexFor: eachLanguage)
								removeFlag: false]] 
							evaluateAndCommitIn: application newTransaction]]!

updateFullTextSearchIndexForPageVersion: aWikiDocPageVersion indexDict: indexDict removeFlag: removeFlag 
	| keySize inverseDate ts key |
	aWikiDocPageVersion isNil ifTrue: [^self].
	keySize := self fullTextSearchKeySize.
	(self getSearchTokensFor: aWikiDocPageVersion) do: 
			[:eachToken | 
			ts := aWikiDocPageVersion editTS.
			ts isNil 
				ifTrue: [inverseDate := (ByteArray new: 8) atAllPut: 255]
				ifFalse: 
					[inverseDate := ts asBtreeKeyOfSize: 8.
					1 to: 8 do: [:k | inverseDate at: k put: 255 - (inverseDate at: k)]].
			key := ByteArray new: keySize + 8 + ODBObjectID sizeInBytes.
			key
				replaceFrom: 1
					to: keySize
					with: (eachToken asBtreeKeyOfSize: keySize)
					startingAt: 1;
				replaceFrom: keySize + 1
					to: keySize + 8
					with: inverseDate
					startingAt: 1.
			aWikiDocPageVersion page odbGetOID putBytesTo: key at: keySize + 9.
			removeFlag = true 
				ifTrue: [indexDict removeKey: key]
				ifFalse: [indexDict at: key put: aWikiDocPageVersion page]]! !
!WikiDocFullTextSearchIndex categoriesFor: #findPagesMatching:languages:maxResults:parentNodes:!public! !
!WikiDocFullTextSearchIndex categoriesFor: #findPagesMatchingSearchString:language:maxResults:levelRanking:parentNodes:!private! !
!WikiDocFullTextSearchIndex categoriesFor: #findPagesMatchingSearchString:languages:maxResults:levelRanking:parentNodes:!private! !
!WikiDocFullTextSearchIndex categoriesFor: #findTextMatching:onPage:!public! !
!WikiDocFullTextSearchIndex categoriesFor: #getPlainTextFor:!private! !
!WikiDocFullTextSearchIndex categoriesFor: #getSearchTokensFor:!private! !
!WikiDocFullTextSearchIndex categoriesFor: #updateFullTextSearchIndex!public! !
!WikiDocFullTextSearchIndex categoriesFor: #updateFullTextSearchIndexForPageVersion:indexDict:removeFlag:!public! !

