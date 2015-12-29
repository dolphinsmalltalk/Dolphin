"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocTopReferersStatisticTask
	instanceVariableNames: 'results'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocTopReferersStatisticTask guid: (GUID fromString: '{7A8CA38A-591D-4E22-B106-DE8F70A94FEE}')!
WikiDocTopReferersStatisticTask comment: ''!
!WikiDocTopReferersStatisticTask categoriesForClass!Unclassified! !
!WikiDocTopReferersStatisticTask methodsFor!

getStatisticalResults
	"Private - get top referers for today, last week, last 10 days, this month, last 31 days"

	| dict wikiSessionsDict wikiSession a date today refererDomain array entry diff |
	results isNil ifFalse: [^results].
	results := dict := LookupTable new.
	
	[
	[today := Date today.
	wikiSessionsDict := OmniBase root at: application sessionsDictionaryKey.
	a := wikiSessionsDict getLast.
	[a isNil] whileFalse: 
			[wikiSession := a value.
			refererDomain := 'NONE'.
			wikiSession referer isNilOrEmpty 
				ifFalse: 
					[array := nil.
					[array := HttpClient decomposeUrl: wikiSession referer] on: Error do: [:ex | ].
					array isNil ifFalse: [refererDomain := array at: 2]].
			date := wikiSession loginTS isNil ifFalse: [wikiSession loginTS date].
			date isNil 
				ifFalse: 
					[entry := dict at: refererDomain ifAbsentPut: [Array new: 6].
					diff := today asDays - date asDays.
					diff = 0 ifTrue: [entry at: 1 add: 1].
					diff = 1 ifTrue: [entry at: 2 add: 1].
					diff <= 7 ifTrue: [entry at: 3 add: 1].
					diff <= 10 ifTrue: [entry at: 4 add: 1].
					date monthIndex = today monthIndex ifTrue: [entry at: 5 add: 1].
					diff <= 31 ifTrue: [entry at: 6 add: 1].
					diff > 31 ifTrue: [a := nil]].
			a isNil ifFalse: [a := wikiSessionsDict getPrevious]]] 
			evaluateIn: application newReadOnlyTransaction] 
			forkAt: ItcSystemManager batchJobPriority.
	(Delay forSeconds: 3) wait.
	^results!

initialize
	super initialize.
	self setDefaultToolbar!

process: request on: stream 
	self 
		dispatchWithMutex: request
		using: #(#processDefault:on: #processRefresh:on:)
		on: stream
		withDefault: #processDefault:on:!

processDefault: request on: stream 
	(self newCoder: stream) showTopReferers: self getStatisticalResults!

processRefresh: request on: stream 
	results := nil.
	[self processDefault: request on: stream] evaluateIn: application newReadOnlyTransaction!

setDefaultToolbar
	| coll |
	coll := OrderedCollection new.
	coll
		add: (Array 
					with: 'Refresh list'
					with: nil
					with: true
					with: self taskURLPrefix , '?action=refresh&lang=' , language);
		add: nil.
	self defaultToolbar: coll! !
!WikiDocTopReferersStatisticTask categoriesFor: #getStatisticalResults!private! !
!WikiDocTopReferersStatisticTask categoriesFor: #initialize!public! !
!WikiDocTopReferersStatisticTask categoriesFor: #process:on:!public! !
!WikiDocTopReferersStatisticTask categoriesFor: #processDefault:on:!public! !
!WikiDocTopReferersStatisticTask categoriesFor: #processRefresh:on:!public! !
!WikiDocTopReferersStatisticTask categoriesFor: #setDefaultToolbar!public! !

