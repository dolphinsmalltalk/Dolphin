"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #MultipleSelectionListControlTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultipleSelectionListControlTest guid: (GUID fromString: '{bef7231e-b333-4717-a462-cbf88117dba1}')!
MultipleSelectionListControlTest isAbstract: true!
MultipleSelectionListControlTest comment: ''!
!MultipleSelectionListControlTest categoriesForClass!Unclassified! !
!MultipleSelectionListControlTest methodsFor!

assertAllSelectionAre: anArray
	| box |
	box := self view.
	self assert: box selection equals: anArray.
	self assert: box selectionOrNil equals: anArray.
	self assert: box selectionByIndex equals: anArray.
	self assert: (box selectionIfNone: [#()]) equals: anArray!

testSelection
	"Test legacy selection behaviour is maintained (even though it is incorrect)"

	| box |
	box := self view.
	#(#selection: #selectionOrNil: #selectionByIndex: #selections: #selectionsByIndex:) do: 
			[:each | 
			box model list: (1 to: 6) asOrderedCollection.
			self assertAllSelectionAre: #().
			self 
				shouldnt: [box perform: each with: #()]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #().
			"Add some selections"
			self 
				should: [box perform: each with: #(1 3 5)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(1 3 5).
			self 
				shouldnt: [box perform: each with: #(1 3 5)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(1 3 5).
			"Now remove all selections"
			self 
				should: [box perform: each with: #()]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #().
			"Add one selection"
			self 
				should: [box perform: each with: #(3)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(3).
			self 
				shouldnt: [box perform: each with: #(3)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(3).
			"Replace one selection"
			self 
				should: [box perform: each with: #(6)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(6).
			self 
				shouldnt: [box perform: each with: #(6)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(6).
			"Add another selection"
			self 
				should: [box perform: each with: #(1 6)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(1 6).
			self 
				shouldnt: [box perform: each with: #(1 6)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(1 6).
			"Remove one selection"
			self 
				should: [box perform: each with: #(1)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(1).
			self 
				shouldnt: [box perform: each with: #(1)]
				trigger: #selectionChanged
				against: box.
			self assertAllSelectionAre: #(1)]!

testSelectionCacheUpdated
	| box |
	box := self view.
	box model list: (1 to: 6) asOrderedCollection.
	box selections: #(1 3 5).
	box model remove: 2.
	self assert: box lastSelIndices equals: box selectionsByIndex.
	box model addFirst: 0.
	self assert: box lastSelIndices equals: box selectionsByIndex.
	box model add: 4.5 afterIndex: 4.
	self assert: box lastSelIndices equals: box selectionsByIndex.
	box model remove: 1.
	self assert: box lastSelIndices equals: box selectionsByIndex!

testSelectionIfAbsent
	"Test legacy selection behaviour is maintained (even though it is incorrect)"

	| box selections |
	box := self view.
	box model list: (1 to: 6) asOrderedCollection.
	#(#selection:ifAbsent: #selectionByIndex:ifAbsent: #selections:ifAbsent: #selectionsByIndex:ifAbsent:)
		do: 
			[:each |
			| missing answer |
			missing := OrderedCollection new.
			self
				should: 
					[answer := box
								perform: each
								with: (0 to: 7)
								with: [:nope | missing := nope]]
				trigger: #selectionChanged
				against: box.
			"Might answer argument, or actual selections"
			self assert: box selections equals: (1 to: 6) asArray.
			self assert: missing asArray equals: #(0 7).
			self assert: answer identicalTo: missing.
			"Apply the same selection again - no change so no event"
			missing := nil.
			self
				shouldnt: 
					[answer := box
								perform: each
								with: (0 to: 7)
								with: [:nope | missing := nope]]
				trigger: #selectionChanged
				against: box.
			self assert: missing asArray equals: #(0 7).
			self assert: answer identicalTo: missing.
			self assert: box selections equals: (1 to: 6) asArray.
			"Apply the same selection again, but this time with none of the selections being missing - again no change"
			missing := nil.
			self
				shouldnt: 
					[answer := box
								perform: each
								with: (1 to: 6)
								with: [:nope | missing := nope]]
				trigger: #selectionChanged
				against: box.
			self assertIsNil: missing.
			"		self assert: (answer noDifference: (1 to: 6))."
			self assert: box selections equals: (1 to: 6) asArray.
			"Remove a selection or two"
			selections := #(0 2 4 5).
			self
				should: 
					[answer := box
								perform: each
								with: selections
								with: [:nope | missing := nope]]
				trigger: #selectionChanged
				against: box.
			self assert: box selections equals: (selections select: [:eachSel | eachSel between: 1 and: 6]).
			self assert: missing asArray equals: #(0).
			self assert: answer identicalTo: missing.
			"Add a couple back"
			self
				should: 
					[selections := #(2 3 4 5 6 8).
					answer := box
								perform: each
								with: selections
								with: [:nope | missing := nope]]
				trigger: #selectionChanged
				against: box.
			self assert: box selections equals: (selections select: [:eachSel | eachSel between: 1 and: 6]).
			self assert: missing asArray equals: #(8).
			self assert: answer identicalTo: missing.

			"Reset selection"
			self
				should: 
					[box
						perform: each
						with: #()
						with: [self assert: false]]
				trigger: #selectionChanged
				against: box.
			"And again - should be no change"
			self
				shouldnt: 
					[box
						perform: each
						with: #()
						with: [self assert: false]]
				trigger: #selectionChanged
				against: box]!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	"The multi-select view will have been converted to a ListView with the isMultiSelect flag set"
	self assert: view isMultiSelect! !
!MultipleSelectionListControlTest categoriesForMethods!
assertAllSelectionAre:!helpers!private! !
testSelection!public!unit tests! !
testSelectionCacheUpdated!public!unit tests! !
testSelectionIfAbsent!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

