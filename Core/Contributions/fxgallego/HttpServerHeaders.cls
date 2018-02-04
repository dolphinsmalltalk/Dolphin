"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerHeaders
	instanceVariableNames: 'knownHeaders unknownHeaders pHeaders pKnownHeaders pUnknownHeaders'
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''!
HttpServerHeaders guid: (GUID fromString: '{3c247e66-990d-4f32-b404-83fa77221599}')!
HttpServerHeaders comment: ''!
!HttpServerHeaders categoriesForClass!Unclassified! !
!HttpServerHeaders methodsFor!

allHeaders
	^LookupTable withAll: knownHeaders associations , unknownHeaders associations!

headerAt: name
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name].
	^unknownHeaders at: name!

headerAt: name ifAbsent: aBlock
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name ifAbsent: aBlock].
	^unknownHeaders at: name ifAbsent: aBlock!

headerAt: name ifPresent: aBlock
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name ifPresent: aBlock].
	^unknownHeaders at: name ifPresent: aBlock!

headerAt: name put: value
	self headersMap at: name ifPresent: [:idx | ^knownHeaders at: name put: value].
	^unknownHeaders at: name put: value!

headersMap
	^HTTP_HEADERS headerToIndexMap!

initialize
	super initialize.
	knownHeaders := LookupTable new.
	unknownHeaders := LookupTable new!

read: request
	pHeaders := request Headers.
	pHeaders KnownHeaders keysAndValuesDo: 
			[:eachKey :eachValue |
			eachValue pRawValue
				ifNotNil: [knownHeaders at: (pHeaders knownHeaderName: eachKey - 1) put: eachValue pRawValue]].
	pHeaders pUnknownHeaders
		do: [:each | each pRawValue ifNotNil: [unknownHeaders at: each pName put: each pRawValue]].
	pHeaders := nil!

write: response
	pHeaders := response Headers.
	pKnownHeaders := pHeaders KnownHeaders.
	knownHeaders keysAndValuesDo: 
			[:eachKey :eachValue |
			(self headersMap includesKey: eachKey)
				ifTrue: 
					[pKnownHeaders at: (pHeaders knownHeaderIndex: eachKey) + 1
						put: (HTTP_KNOWN_HEADER new
								pRawValue: eachValue;
								yourself)]].
	unknownHeaders notEmpty
		ifTrue: 
			[pUnknownHeaders := StructureArray length: unknownHeaders size elementClass: HTTP_UNKNOWN_HEADER.
			unknownHeaders associations with: pUnknownHeaders
				do: 
					[:header :pHeader |
					pHeader
						pName: header key;
						pRawValue: header value].
			pHeaders pUnknownHeaders: pUnknownHeaders].
	response Headers: pHeaders! !
!HttpServerHeaders categoriesFor: #allHeaders!public! !
!HttpServerHeaders categoriesFor: #headerAt:!public! !
!HttpServerHeaders categoriesFor: #headerAt:ifAbsent:!public! !
!HttpServerHeaders categoriesFor: #headerAt:ifPresent:!public! !
!HttpServerHeaders categoriesFor: #headerAt:put:!public! !
!HttpServerHeaders categoriesFor: #headersMap!accessing!private! !
!HttpServerHeaders categoriesFor: #initialize!private! !
!HttpServerHeaders categoriesFor: #read:!public! !
!HttpServerHeaders categoriesFor: #write:!public! !

