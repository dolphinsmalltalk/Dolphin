"Filed out from Dolphin Smalltalk"!

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
!ProfilerClassListPresenter categoriesForMethods!
filterDolphin:!filtering!public! !
items!accessing!public! !
reportIdentityOf:to:!public!reporting! !
reportItems!public!reporting! !
reportTitleTo:!public!reporting! !
!

!ProfilerClassListPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 34 2 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140920397 1025 608 590662 2 ##(Smalltalk.ListModel) 138 144 560 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 496 nil 5 nil nil nil 608 nil 8 1903904528 ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 5 920646 5 ##(Smalltalk.ListViewColumn) 8 'Class' 201 #left ##(Smalltalk.BasicListAbstract) 770 #<= 8 #() 770 #object 8 #() nil 608 nil 3 nil nil 882 8 'Tally all %' 201 #center ##(Smalltalk.BasicListAbstract) 770 #<= 8 #() 770 #tallyAll 8 #() nil 608 880 1 nil nil 882 8 'Tally active %' 201 #center ##(Smalltalk.BasicListAbstract) 770 #<= 8 #() 770 #tallyActive 8 #() nil 608 880 1 nil nil 882 8 'Time all %' 201 #center ##(Smalltalk.BasicListAbstract) 770 #<= 8 #() 770 #timeAll 1168 nil 608 880 1 nil nil 882 8 'Time active %' 201 #center ##(Smalltalk.BasicListAbstract) 770 #<= 8 #() 770 #timeActive 1168 nil 608 880 1 nil nil #report 560 nil 131169 nil 34 4 nil nil 328198 ##(Smalltalk.Point) 1 1 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 1362 1 1 1362 701 471 608 1458 #text: 34 1 8 'Class' 608 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 235 0 0 0] 8 #() 1362 193 193 nil 27 8 'items' nil 1394 138 144 34 1 1458 #createAt:extent: 34 2 1362 3839 21 1362 701 471 416 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 245 0 0 0] 34 1 608 1648 nil 27 )! !
!ProfilerClassListPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

