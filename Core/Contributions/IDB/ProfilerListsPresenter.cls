"Filed out from Dolphin Smalltalk"!

ProfilerPresenter subclass: #ProfilerListsPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProfilerListsPresenter guid: (GUID fromString: '{425d0eb5-542e-11d3-998b-d5ca2c3c1d61}')!

ProfilerListsPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ProfilerListsPresenter categoriesForClass!IDB Goodies! !

!ProfilerListsPresenter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self add: ListPresenter new name: 'items'!

createSchematicWiring
	self itemsPresenter
		when: #actionPerformed
		send: #onActionPerformed
		to: self!

filterPercentage: aFloat 
	"Set the filterBlock to answer true if any of the fileds ar > aFloat%"

	percentageFilter := [:o | o isAbove: aFloat].
	super filterChanged!

filterSelector: aCompiledCodeOrNil 
	"Answer true if this node shold be displayed for the selector filter.
	Answers true if
		aCompiledCodeOrNil is nil - the filter is off so show all.
		ACompiledCodeOrNil matches the class/selector for this node"

	self shouldNotImplement!

hasSelection
	"Answers true if the item list has a selection"

	^self selectionOrNil notNil!

items
	"Answers a collection of the items to go in the list"

	self subclassResponsibility!

itemsPresenter
	^self presenterNamed: 'items'!

reportIdentityOf: aProfilerListItem to: aStream 
	"Add the identity of the receiver to aStream"

	self subclassResponsibility!

reportItems
	"Answer the items in the correct order for the report"

	self subclassResponsibility!

reportTitleTo: aStream 
	"Add a title for the receiver to aStream"

	self subclassResponsibility!

reportTo: aStream 
	"Generate a report for the receiver on aStream"

	self reportTitleTo: aStream.
	self reportItems do: 
			[:each | 
			self reportIdentityOf: each to: aStream.
			each reportOn: aStream]!

selectionOrNil
	"Answer the item (an ProfilerListItem) selected in the list or nil if there is no selection"

	^self itemsPresenter selectionOrNil!

update
	"Select the items from the model that should be displayed in the list. Only
	display those that answer true to the current filterBlock"

	self itemsPresenter list: (self items select: [:each | self filter: each]).
	self itemsPresenter view layout! !

!ProfilerListsPresenter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filterPercentage:!filtering!public! !
filterSelector:!filtering!public! !
hasSelection!public!testing! !
items!accessing!public! !
itemsPresenter!accessing!private! !
reportIdentityOf:to:!public!reporting! !
reportItems!public!reporting! !
reportTitleTo:!public!reporting! !
reportTo:!public!reporting! !
selectionOrNil!accessing!public! !
update!public!updating! !
!

