"Filed out from Dolphin Smalltalk X6.2"!

HtmlParserElement subclass: #HtmlParserLink
	instanceVariableNames: 'url target contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlParserLink guid: (GUID fromString: '{C043ED36-7D1A-42F9-976B-12CC8F60CF71}')!
HtmlParserLink comment: ''!
!HtmlParserLink categoriesForClass!Unclassified! !
!HtmlParserLink methodsFor!

contents
	^contents!

contents: anObject
	contents := anObject!

contentsString
	| str |
	str := ''.
	contents do: [:each | str := str , each asWebString].
	^str!

getUrlAttributeNamesAndValues
	| stream key value result |
	result := ItcLookupTable new.
	url isNilOrEmpty 
		ifFalse: 
			[stream := ReadStream on: url.
			stream upTo: $?.
			[stream atEnd or: [(key := stream upTo: $=) isNil or: [key isEmpty]]] whileFalse: 
					[key := key webHttpUrlDecodeQueryComponent.
					value := stream upTo: $&.
					value := value webHttpUrlDecodeQueryComponent.
					result at: key put: value.
					"skip XHTML encoded ampersand"
					(stream peek: 4) = 'amp;' ifTrue: [stream next: 4]]].
	^result!

printOn: aStream 
	url isNil ifFalse: [aStream nextPutAll: 'URL=' , url].
	contents do: 
			[:each | 
			aStream nextPutAll: '  /  '.
			each printOn: aStream]!

target
	^target!

target: anObject
	target := anObject!

url
	^url isNil ifTrue: [''] ifFalse: [url]!

url: anObject
	url := anObject! !
!HtmlParserLink categoriesFor: #contents!accessing!public! !
!HtmlParserLink categoriesFor: #contents:!accessing!private! !
!HtmlParserLink categoriesFor: #contentsString!accessing!public! !
!HtmlParserLink categoriesFor: #getUrlAttributeNamesAndValues!accessing!public! !
!HtmlParserLink categoriesFor: #printOn:!accessing!private! !
!HtmlParserLink categoriesFor: #target!accessing!public! !
!HtmlParserLink categoriesFor: #target:!accessing!private! !
!HtmlParserLink categoriesFor: #url!accessing!public! !
!HtmlParserLink categoriesFor: #url:!accessing!private! !

