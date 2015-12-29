"Filed out from Dolphin Smalltalk X6.2"!

HtmlParserElement subclass: #HtmlParserPage
	instanceVariableNames: 'contents formFields links forms inlineFrames selectFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlParserPage guid: (GUID fromString: '{74F8588E-428B-4D67-9F91-BD3AB6409CC7}')!
HtmlParserPage comment: ''!
!HtmlParserPage categoriesForClass!Unclassified! !
!HtmlParserPage methodsFor!

at: anIndex 
	^contents at: anIndex!

contents
	^contents!

findFirstRowWithCellContainingString: aString 
	| result |
	contents do: 
			[:eachElement | 
			eachElement class == HtmlParserTable 
				ifTrue: 
					[(result := eachElement findFirstRowWithCellContainingString: aString) isNil ifFalse: [^result]]].
	^nil!

findFirstRowWithCellMatchingString: aString 
	| result |
	contents do: 
			[:eachElement | 
			eachElement class == HtmlParserTable 
				ifTrue: [(result := eachElement findFirstRowWithCellMatchingString: aString) isNil ifFalse: [^result]]].
	^nil!

findTableContainingString: aString 
	| result |
	contents do: 
			[:eachElement | 
			eachElement class == HtmlParserTable 
				ifTrue: [(result := eachElement findTableContainingString: aString) isNil ifFalse: [^result]]].
	^nil!

findTableWithHeaderIncludingStrings: aCollectionOfStrings 
	| result |
	contents do: 
			[:eachElement | 
			eachElement class == HtmlParserTable 
				ifTrue: 
					[(result := eachElement findTableWithHeaderIncludingStrings: aCollectionOfStrings) isNil 
						ifFalse: [^result]]].
	^nil!

findTableWithRowIncludingStrings: aCollectionOfStrings 
	| result |
	contents do: 
			[:eachElement | 
			eachElement class == HtmlParserTable 
				ifTrue: 
					[(result := eachElement findTableWithRowIncludingStrings: aCollectionOfStrings) isNil 
						ifFalse: [^result]]].
	^nil!

firstLinkWithUrlStartingWith: prefixString 
	^self links detect: [:each | each url beginsWith: prefixString]
		ifNone: [self error: 'Link with URL prefix ' , prefixString , ' not found']!

firstLinkWithUrlStartingWith: prefixString ifNone: aBlock 
	^self links detect: [:each | each url beginsWith: prefixString] ifNone: aBlock!

formFields
	^formFields!

forms
	^forms!

from: aString 
	self fromStream: (ReadStream on: aString)!

fromStream: aStream 
	self parseFrom: (HtmlParserReadStream new on: aStream)!

inlineFrames
	^inlineFrames!

links
	^links!

parseFormFieldsFrom: htmlParserStream 
	| token |
	formFields := LookupTable new.
	
	[token := htmlParserStream nextToken.
	token isNil] whileFalse: 
				[token isString 
					ifFalse: 
						[(token first = 'INPUT' and: [token last == false]) 
							ifTrue: 
								["parse tag contents for field name and value"
								| stream assoc fieldName fieldValue |
								stream := HtmlParserReadStream new on: (ReadStream on: (token at: 2)).
								fieldName := nil.
								fieldValue := nil.
								[(assoc := stream nextAttributeAndValue) isNil] whileFalse: 
										[assoc key = 'NAME' ifTrue: [fieldName := assoc value].
										assoc key = 'VALUE' ifTrue: [fieldValue := assoc value]].
								fieldName isNil ifFalse: [formFields at: fieldName put: fieldValue]]]]!

parseFormsFrom: htmlParserStream 
	| token form |
	forms := OrderedCollection new.
	
	[token := htmlParserStream nextToken.
	token isNil] whileFalse: 
				[token isString 
					ifFalse: 
						[(token first = 'FORM' and: [token last == false]) 
							ifTrue: 
								["parse tag contents for link attributes"
								form := HtmlParserForm new.
								form parseFrom: htmlParserStream attributes: (token at: 2).
								forms add: form]]]!

parseFrom: htmlParserStream 
	| token collectedString |
	contents := OrderedCollection new.
	self parseFormFieldsFrom: htmlParserStream.
	htmlParserStream reset.
	self parseLinksFrom: htmlParserStream.
	htmlParserStream reset.
	self parseSelectFieldsFrom: htmlParserStream.
	htmlParserStream reset.
	self parseFormsFrom: htmlParserStream.
	htmlParserStream reset.
	self parseInlineFramesFrom: htmlParserStream.
	htmlParserStream reset.
	
	[token := htmlParserStream nextToken.
	token isNil] whileFalse: 
				[token isString 
					ifTrue: [collectedString := collectedString add: token withDelimiter: ' ']
					ifFalse: 
						[| tagName |
						tagName := token first.
						(tagName = 'TABLE' and: [token last = false]) 
							ifTrue: 
								[collectedString isNilOrEmpty ifFalse: [contents add: collectedString].
								collectedString := nil.
								contents add: (HtmlParserTable new parseFrom: htmlParserStream)]
							ifFalse: 
								[tagName = 'IMG' 
									ifTrue: [contents add: (HtmlParserImage new parseFrom: (token at: 2))]
									ifFalse: [tagName = 'BR' ifTrue: [collectedString := collectedString asWebString , '
']]]]].
	collectedString isNilOrEmpty ifFalse: [contents add: collectedString]!

parseInlineFramesFrom: htmlParserStream 
	| token |
	inlineFrames := OrderedCollection new.
	
	[token := htmlParserStream nextToken.
	token isNil] whileFalse: 
				[token isString 
					ifFalse: 
						[(token first = 'IFRAME' and: [token last == false]) 
							ifTrue: 
								["parse tag contents for link attributes"
								| stream src frameContents assoc |
								stream := HtmlParserReadStream new on: (ReadStream on: (token at: 2)).
								src := nil.
								frameContents := OrderedCollection new.
								[(assoc := stream nextAttributeAndValue) isNil] 
									whileFalse: [assoc key = 'SRC' ifTrue: [src := assoc value]].
								inlineFrames add: ((HtmlParserInlineFrame new)
											src: src;
											contents: frameContents;
											yourself).
								
								[token := htmlParserStream nextToken.
								token isNil ifTrue: [^self].
								token isString not and: [token first = 'IFRAME' and: [token last = true]]] 
										whileFalse: [token isString ifTrue: [frameContents add: token]]]]]!

parseLinksFrom: htmlParserStream 
	| token |
	links := OrderedCollection new.
	
	[token := htmlParserStream nextToken.
	token isNil] whileFalse: 
				[token isString 
					ifFalse: 
						[(token first = 'A' and: [token last == false]) 
							ifTrue: 
								["parse tag contents for link attributes"
								| stream url target linkContents assoc |
								stream := HtmlParserReadStream new on: (ReadStream on: (token at: 2)).
								url := nil.
								target := nil.
								linkContents := OrderedCollection new.
								[(assoc := stream nextAttributeAndValue) isNil] whileFalse: 
										[assoc key = 'HREF' 
											ifTrue: 
												[url := assoc value isString 
															ifTrue: [assoc value reject: [:each | each isSeparator]]
															ifFalse: [assoc value]].
										assoc key = 'TARGET' ifTrue: [target := assoc value]].
								links add: ((HtmlParserLink new)
											url: url;
											target: nil;
											contents: linkContents;
											yourself).
								
								[token := htmlParserStream nextToken.
								token isNil ifTrue: [^self].
								token isString not and: [token first = 'A' and: [token last = true]]] 
										whileFalse: [token isString ifTrue: [linkContents add: token]]]]]!

parseSelectFieldsFrom: htmlParserStream 
	| token |
	selectFields := OrderedCollection new.
	
	[token := htmlParserStream nextToken.
	token isNil] whileFalse: 
				[token isString 
					ifFalse: 
						[(token first = 'SELECT' and: [token last == false]) 
							ifTrue: 
								["parse tag contents for link attributes"
								| stream assoc name items selectedItems |
								stream := HtmlParserReadStream new on: (ReadStream on: (token at: 2)).
								name := nil.
								items := OrderedCollection new.
								selectedItems := OrderedCollection new.
								[(assoc := stream nextAttributeAndValue) isNil] 
									whileFalse: [assoc key = 'NAME' ifTrue: [name := assoc value]].
								selectFields add: ((HtmlParserSelectField new)
											name: name;
											allItems: items;
											selectedItems: selectedItems;
											yourself).
								
								[token := htmlParserStream nextToken.
								token isNil ifTrue: [^self].
								token isString not and: [token first = 'SELECT' and: [token last = true]]] 
										whileFalse: 
											[token isString 
												ifFalse: 
													[(token first = 'OPTION' and: [token last == false]) 
														ifTrue: 
															[| item isSelected |
															stream := HtmlParserReadStream new on: (ReadStream on: (token at: 2)).
															isSelected := false.
															item := Association key: '' value: ''.
															[(assoc := stream nextAttributeAndValue) isNil] whileFalse: 
																	[assoc key = 'VALUE' ifTrue: [item key: assoc value].
																	assoc key = 'SELECTED' ifTrue: [isSelected := true]].
															items add: item.
															isSelected ifTrue: [selectedItems add: item].
															
															[token := htmlParserStream nextToken.
															token isNil ifTrue: [^self].
															token isString not and: [token first = 'OPTION' and: [token last = true]]] 
																	whileFalse: [token isString ifTrue: [item value: item value , token]]]]]]]]!

plainTextContents
	| ws |
	ws := WriteStream on: String new.
	self contents 
		do: [:each | each isString ifTrue: [ws nextPutAll: each] ifFalse: [each plainTextContentsOn: ws]].
	^ws contents!

printOn: aStream 
	contents printOn: aStream!

selectFieldNamed: aString 
	^self selectFields detect: [:each | each name = aString] ifNone: []!

selectFields
	^selectFields! !
!HtmlParserPage categoriesFor: #at:!public! !
!HtmlParserPage categoriesFor: #contents!public! !
!HtmlParserPage categoriesFor: #findFirstRowWithCellContainingString:!public! !
!HtmlParserPage categoriesFor: #findFirstRowWithCellMatchingString:!public! !
!HtmlParserPage categoriesFor: #findTableContainingString:!public! !
!HtmlParserPage categoriesFor: #findTableWithHeaderIncludingStrings:!public! !
!HtmlParserPage categoriesFor: #findTableWithRowIncludingStrings:!public! !
!HtmlParserPage categoriesFor: #firstLinkWithUrlStartingWith:!public! !
!HtmlParserPage categoriesFor: #firstLinkWithUrlStartingWith:ifNone:!public! !
!HtmlParserPage categoriesFor: #formFields!public! !
!HtmlParserPage categoriesFor: #forms!public! !
!HtmlParserPage categoriesFor: #from:!public! !
!HtmlParserPage categoriesFor: #fromStream:!public! !
!HtmlParserPage categoriesFor: #inlineFrames!private! !
!HtmlParserPage categoriesFor: #links!private! !
!HtmlParserPage categoriesFor: #parseFormFieldsFrom:!private! !
!HtmlParserPage categoriesFor: #parseFormsFrom:!private! !
!HtmlParserPage categoriesFor: #parseFrom:!private! !
!HtmlParserPage categoriesFor: #parseInlineFramesFrom:!private! !
!HtmlParserPage categoriesFor: #parseLinksFrom:!private! !
!HtmlParserPage categoriesFor: #parseSelectFieldsFrom:!private! !
!HtmlParserPage categoriesFor: #plainTextContents!public! !
!HtmlParserPage categoriesFor: #printOn:!public! !
!HtmlParserPage categoriesFor: #selectFieldNamed:!public! !
!HtmlParserPage categoriesFor: #selectFields!public! !

!HtmlParserPage class methodsFor!

fromString: aString 
	^self new from: aString! !
!HtmlParserPage class categoriesFor: #fromString:!public! !

