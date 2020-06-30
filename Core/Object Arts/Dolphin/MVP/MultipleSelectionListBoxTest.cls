"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #MultipleSelectionListBoxTest
	instanceVariableNames: 'box'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MultipleSelectionListBoxTest guid: (GUID fromString: '{29849786-386a-43f0-a24e-f1970727a83b}')!
MultipleSelectionListBoxTest comment: 'Test that the behaviour of the deprecated MultipleSelectionListBox class retains its legacy features in the refactored ListControlView hierarchy.'!
!MultipleSelectionListBoxTest categoriesForClass!Unclassified! !
!MultipleSelectionListBoxTest methodsFor!

assertAllSelectionAre: anArray
	self assert: box selection equals: anArray.
	self assert: box selectionOrNil equals: anArray.
	self assert: box selectionByIndex equals: anArray.
	self assert: (box selectionIfNone: [#()]) equals: anArray!

classToTest
	^MultipleSelectionListBox!

setUp
	super setUp.
	box := self classToTest show!

tearDown
	box topView destroy.
	box := nil!

testSelection
	"Test legacy selection behaviour is maintained (even though it is incorrect)"

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

	| selections |
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
			self assert: box selections equals: (selections select: [:each | each between: 1 and: 6]).
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
				against: box]! !
!MultipleSelectionListBoxTest categoriesFor: #assertAllSelectionAre:!helpers!private! !
!MultipleSelectionListBoxTest categoriesFor: #classToTest!constants!private! !
!MultipleSelectionListBoxTest categoriesFor: #setUp!public!Running! !
!MultipleSelectionListBoxTest categoriesFor: #tearDown!public!Running! !
!MultipleSelectionListBoxTest categoriesFor: #testSelection!public!unit tests! !
!MultipleSelectionListBoxTest categoriesFor: #testSelectionCacheUpdated!public!unit tests! !
!MultipleSelectionListBoxTest categoriesFor: #testSelectionIfAbsent!public!unit tests! !

