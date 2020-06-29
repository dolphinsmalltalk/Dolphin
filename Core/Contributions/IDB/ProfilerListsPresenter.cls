"Filed out from Dolphin Smalltalk 7"!

ProfilerPresenter subclass: #ProfilerListsPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

	^(self presenterNamed: 'items') selectionOrNil!

update
	"Select the items from the model that should be displayed in the list. Only
	display those that answer true to the current filterBlock"

	(self presenterNamed: 'items') list: (self items select: [:each | self filter: each]).
	(self presenterNamed: 'items') view layout! !
!ProfilerListsPresenter categoriesFor: #createComponents!initializing!public! !
!ProfilerListsPresenter categoriesFor: #filterPercentage:!filtering!public! !
!ProfilerListsPresenter categoriesFor: #filterSelector:!filtering!public! !
!ProfilerListsPresenter categoriesFor: #hasSelection!public!testing! !
!ProfilerListsPresenter categoriesFor: #items!accessing!public! !
!ProfilerListsPresenter categoriesFor: #reportIdentityOf:to:!public!reporting! !
!ProfilerListsPresenter categoriesFor: #reportItems!public!reporting! !
!ProfilerListsPresenter categoriesFor: #reportTitleTo:!public!reporting! !
!ProfilerListsPresenter categoriesFor: #reportTo:!public!reporting! !
!ProfilerListsPresenter categoriesFor: #selectionOrNil!accessing!public! !
!ProfilerListsPresenter categoriesFor: #update!public!updating! !

