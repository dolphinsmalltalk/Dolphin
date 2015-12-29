"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocSearchResultsTask
	instanceVariableNames: 'searchResults searchFields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocSearchResultsTask guid: (GUID fromString: '{BF3B935B-E16B-4C02-9464-92255A1E6952}')!
WikiDocSearchResultsTask comment: ''!
!WikiDocSearchResultsTask categoriesForClass!Unclassified! !
!WikiDocSearchResultsTask methodsFor!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on:)
		on: stream
		withDefault: #processDefault:on:!

processDefault: request on: stream 
	| startIndex |
	startIndex := request integerAt: 'startIndex'.
	startIndex isNil 
		ifTrue: [startIndex := 1]
		ifFalse: 
			[startIndex := (startIndex max: 1) min: searchResults size.
			startIndex := (startIndex - 1) // 10 * 10 + 1].
	(self newCoder: stream) 
		wikiSearchResultPage: searchResults
		resultsPerPage: 10
		startIndex: startIndex
		searchFields: searchFields!

searchFields: anObject
	searchFields := anObject!

searchResults: anObject 
	searchResults := anObject! !
!WikiDocSearchResultsTask categoriesFor: #process:on:!public! !
!WikiDocSearchResultsTask categoriesFor: #processDefault:on:!accessing!public! !
!WikiDocSearchResultsTask categoriesFor: #searchFields:!accessing!public! !
!WikiDocSearchResultsTask categoriesFor: #searchResults:!accessing!public! !

