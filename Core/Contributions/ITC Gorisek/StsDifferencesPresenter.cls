"Filed out from Dolphin Smalltalk X6.2"!

DifferencesPresenter subclass: #StsDifferencesPresenter
	instanceVariableNames: 'diffResult diffProcess'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsDifferencesPresenter guid: (GUID fromString: '{6274D04D-5753-4A8A-9A8C-2F04AE66898D}')!
StsDifferencesPresenter comment: ''!
!StsDifferencesPresenter categoriesForClass!Unclassified! !
!StsDifferencesPresenter methodsFor!

clearDiffs
	diffProcess isNil ifFalse: [diffProcess terminate].
	diffProcess := nil.
	diffResult := nil.
	super clearDiffs!

diff: before and: after 
	| match |
	(match := self getMatchFor: before and: after) isNil 
		ifFalse: 
			[self
				display: match first
					items: before
					presenter: beforePresenter;
				display: match last
					items: after
					presenter: afterPresenter]!

getMatchFor: before and: after 
	| difBlock |
	diffResult isNil 
		ifTrue: 
			[difBlock := 
					[| beforeSequence afterSequence match |
					beforeSequence := self parse: before.
					afterSequence := self parse: after.
					match := (beforeSequence collect: [:each | each key]) 
								longestCommonSubsequenceInInterval: (1 to: beforeSequence size)
								withCollection: (afterSequence collect: [:each | each key])
								inInterval: (1 to: afterSequence size).
					diffResult := Array with: match with: (afterSequence inverseMatchVector: match).
					self diff: beforeSequence and: afterSequence].
			diffProcess := (difBlock newProcess)
						priority: 1;
						resume;
						yourself].
	^diffResult!

refresh
	| before after |
	before := beforePresenter view plainText.
	after := afterPresenter view plainText.
	(before isEmpty or: [after isEmpty]) 
		ifTrue: [self clearDiffs]
		ifFalse: [self diff: before and: after]! !
!StsDifferencesPresenter categoriesFor: #clearDiffs!operations!public! !
!StsDifferencesPresenter categoriesFor: #diff:and:!private!updating! !
!StsDifferencesPresenter categoriesFor: #getMatchFor:and:!private!updating! !
!StsDifferencesPresenter categoriesFor: #refresh!public!updating! !

