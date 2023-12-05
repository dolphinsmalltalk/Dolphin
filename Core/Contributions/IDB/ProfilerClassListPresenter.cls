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

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Smalltalk.Color) #default nil 5 461638 4 ##(Smalltalk.Menu) nil true 34 1 1180742 2 ##(Smalltalk.CommandMenuItem) 1 1377606 4 ##(Smalltalk.CommandDescription) #browseIt 8 'Bro&wse <d:It>' 1 17 852806 4 ##(Smalltalk.Icon) nil true 2819078 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'ClassBrowserShell.ico' 2490894 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil nil nil 134217729 nil nil nil nil nil nil nil 416 1376774 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 34 2 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140920397 1025 864 787270 2 ##(Smalltalk.ListModel) 138 144 816 nil 1769478 ##(Smalltalk.IdentitySearchPolicy) 496 nil 5 nil nil nil 864 nil 8 1830168848 ##(Smalltalk.BasicListAbstract) 786950 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1639750 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 6 1117254 5 ##(Smalltalk.ListViewColumn) 8 'Class' 257 #left 1026 #unqualifiedName 8 #() 1026 #<= 8 #() 1026 #object 8 #() nil 864 nil 3 nil nil 1138 8 'Namespace' 257 #left 1026 #displayString 1200 1026 #<= 8 #() 1246566 3 ##(Smalltalk.BlockClosure) 0 nil 1639718 ##(Smalltalk.CompiledExpression) 3 1 1360 8 'doIt' 8 '[:o | o object basicEnvironment] ' 8 #[31 105 226 0 159 106] #object #basicEnvironment 1376 7 257 nil nil 864 nil 3 nil nil 1138 8 'Tally all %' 161 #center ##(Smalltalk.BasicListAbstract) 1026 #<= 8 #() 1026 #tallyAll 8 #() nil 864 1136 1 nil nil 1138 8 'Tally active %' 181 #center ##(Smalltalk.BasicListAbstract) 1026 #<= 8 #() 1026 #tallyActive 8 #() nil 864 1136 1 nil nil 1138 8 'Time all %' 161 #center ##(Smalltalk.BasicListAbstract) 1026 #<= 8 #() 1026 #timeAll 1648 nil 864 1136 1 nil nil 1138 8 'Time active %' 191 #center ##(Smalltalk.BasicListAbstract) 1026 #<= 8 #() 1026 #timeActive 1648 nil 864 1136 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1310982 ##(Smalltalk.MessageSequence) 34 2 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 918022 ##(Smalltalk.Point) 1 1 1938 1211 471 864 1890 #text: 34 1 8 'Class' 864 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 2 0 0 235 0 0 0] 8 #() 1938 193 193 nil 35 8 'items' nil 1842 34 1 1890 #createAt:extent: 34 2 1938 6143 21 1938 1211 471 416 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 92 14 0 0 245 0 0 0] 34 1 864 2096 nil 27 )! !
!ProfilerClassListPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

