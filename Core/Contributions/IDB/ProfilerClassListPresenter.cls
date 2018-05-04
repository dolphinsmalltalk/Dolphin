"Filed out from Dolphin Smalltalk 7"!

ProfilerListsPresenter subclass: #ProfilerClassListPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerClassListPresenter guid: (GUID fromString: '{425d0eb7-542e-11d3-998b-d5ca2c3c1d61}')!
ProfilerClassListPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerClassListPresenter categoriesForClass!IDB Goodies! !
!ProfilerClassListPresenter methodsFor!

filterDolphin: aBoolean 
	"Answers true if the item is not in the Dolphin package (so it should be displayed)"

	dolphinFilter := 
			[:o | 
			(aBoolean and: 
					[| item |
					(item := o object instanceClass owningPackage) notNil and: [item isSystemPackage]]) 
				not].
	super filterChanged!

items
	"Answers a collection of the items needed for the list"

	^self model samplesClasses!

reportIdentityOf: aProfilerListItem to: aStream 
	"Add the identity of the receiver to aStream"

	| string |
	string := aProfilerListItem object printString.
	aStream nextPutAll: ('%-32s' sprintfWith: (string copyFrom: 1 to: (32 min: string size)))!

reportItems
	"Answer the items in the correct order for the report"

	^self items asSortedCollection: [:a :b | a object <= b object]!

reportTitleTo: aStream 
	"Put a title and column headings for the report on aStream"

	aStream
		cr;
		cr;
		nextPutAll: 'Classes used';
		cr;
		cr;
		nextPutAll: ('%-32s' sprintfWith: 'Class');
		nextPutAll: ('%-10s' sprintfWith: 'Tally All');
		nextPutAll: ('%-10s' sprintfWith: 'Tally Act');
		nextPutAll: ('%-10s' sprintfWith: 'Time All');
		nextPutAll: ('%-10s' sprintfWith: 'Time Act');
		cr! !
!ProfilerClassListPresenter categoriesFor: #filterDolphin:!filtering!public! !
!ProfilerClassListPresenter categoriesFor: #items!accessing!public! !
!ProfilerClassListPresenter categoriesFor: #reportIdentityOf:to:!public!reporting! !
!ProfilerClassListPresenter categoriesFor: #reportItems!public!reporting! !
!ProfilerClassListPresenter categoriesFor: #reportTitleTo:!public!reporting! !

!ProfilerClassListPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 5 0 0 0 416 1180166 ##(ProportionalLayout) 234 240 98 0 16 234 256 98 2 410 8 ##(ListView) 98 30 0 416 98 2 8 1140920397 1025 640 590662 2 ##(ListModel) 202 208 592 0 1114638 ##(STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 498 528 0 5 0 0 0 640 0 8 4294904214 8 ##(BasicListAbstract) 459270 ##(Message) 8 #profilerIconIndex 98 0 778 8 ##(IconImageManager) 8 #current 0 0 0 0 0 0 202 208 98 5 920646 5 ##(ListViewColumn) 8 'Class' 201 8 #left 864 8 ##(SortedCollection) 882 8 #object 98 0 0 640 0 3 0 0 1026 8 'Tally all %' 201 8 #center 864 1088 882 8 #tallyAll 98 0 0 640 1024 1 0 0 1026 8 'Tally active %' 201 1184 864 1088 882 8 #tallyActive 98 0 0 640 1024 1 0 0 1026 8 'Time all %' 201 1184 864 1088 882 8 #timeAll 1312 0 640 1024 1 0 0 1026 8 'Time active %' 201 1184 864 1088 882 8 #timeActive 1312 0 640 1024 1 0 0 8 #report 592 0 131169 0 0 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 1 1 1602 701 471 640 1538 8 #text: 98 1 8 'Class' 640 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 235 0 0 0] 98 0 1602 193 193 0 27 8 'items' 0 1474 202 208 98 1 1538 1568 98 2 1602 20001 20001 1602 701 471 416 1714 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 110 40 0 0 251 39 0 0] 98 1 640 1776 0 27)! !
!ProfilerClassListPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

