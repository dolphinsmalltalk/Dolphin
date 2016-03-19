"Filed out from Dolphin Smalltalk 7"!

ProfilerListsPresenter subclass: #ProfilerSelectorListPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerSelectorListPresenter guid: (GUID fromString: '{425D0EB8-542E-11D3-998B-D5CA2C3C1D61}')!
ProfilerSelectorListPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerSelectorListPresenter categoriesForClass!IDB Goodies! !
!ProfilerSelectorListPresenter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self add: MethodWorkspace new name: 'workspace'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self presenterNamed: 'items') 
		when: #selectionChanged
		send: #onSelectionChanged
		to: self!

filterDolphin: aBoolean 
	"Answers true if the item is not in the Dolphin package (so it should be displayed)"

	dolphinFilter := 
			[:o | 
			(aBoolean and: 
					[| item |
					((item := o object) isKindOf: CompiledMethod) 
						and: [(item := item owningPackage) notNil and: [item isSystemPackage]]]) 
				not].
	super filterChanged!

hasEditableMethodSelected
	^false!

items
	"Answer a copy of the initial list, leaving the percentage figures alone but replacing the
	Association (class -> methodName) with the appropriate compiledMethod. This makes
	the list etc much easier to handle. Don't copy the UndefinedObjects"

	^(self model samplesSelectors 
		select: [:each | each object key selectors includes: each object value]) collect: 
				[:each | 
				(each copy)
					object: (each object key compiledMethodAt: each object value);
					yourself]!

onSelectionChanged
	"The selector selection has changed so update the source view accordingly"

	| styler text |
	self hasSelection 
		ifTrue: 
			[| method |
			method := self selectedMethod.
			text := method getSource.
			styler := method stylerClass]
		ifFalse: 
			[text := String new.
			styler := NullScintillaStyler].
	(self presenterNamed: 'workspace')
		text: text;
		stylerClass: styler.
	self trigger: #onSelectionChanged!

onViewOpened
	super onViewOpened.
	(self presenterNamed: 'workspace') view isReadOnly: true!

reportIdentityOf: aProfilerListItem to: aStream 
	"Add the identity of the receiver to aStream"

	| string |
	string := aProfilerListItem object selector.
	aStream nextPutAll: ('%-32s' sprintfWith: (string copyFrom: 1 to: (31 min: string size))).
	string := aProfilerListItem object methodClass printString.
	aStream nextPutAll: ('%-32s' sprintfWith: (string copyFrom: 1 to: (31 min: string size)))!

reportItems
	"Answer the items in the correct order for the report"

	^self items asSortedCollection: [:a :b | a object selector <= b object selector]!

reportTitleTo: aStream 
	"Put a title and column headings for the report on aStream"

	aStream
		cr;
		cr;
		nextPutAll: 'Methods used';
		cr;
		cr;
		nextPutAll: ('%-32s' sprintfWith: 'Selector');
		nextPutAll: ('%-32s' sprintfWith: 'Class');
		nextPutAll: ('%-10s' sprintfWith: 'Tally All');
		nextPutAll: ('%-10s' sprintfWith: 'Tally Act');
		nextPutAll: ('%-10s' sprintfWith: 'Time All');
		nextPutAll: ('%-10s' sprintfWith: 'Time Act');
		cr!

selectedMethod
	^self selectionOrNil ifNotNil: [:sel | sel object]!

update
	"Update the list but try to retain the selection if possible"

	| presenter selection |
	selection := (presenter := self presenterNamed: 'items') selectionOrNil.
	super update.
	selection notNil ifTrue: [presenter selection: selection ifAbsent: []].
	self onSelectionChanged! !
!ProfilerSelectorListPresenter categoriesFor: #createComponents!initializing!public! !
!ProfilerSelectorListPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!ProfilerSelectorListPresenter categoriesFor: #filterDolphin:!filtering!public! !
!ProfilerSelectorListPresenter categoriesFor: #hasEditableMethodSelected!public!testing! !
!ProfilerSelectorListPresenter categoriesFor: #items!accessing!public! !
!ProfilerSelectorListPresenter categoriesFor: #onSelectionChanged!event handling!public! !
!ProfilerSelectorListPresenter categoriesFor: #onViewOpened!event handling!public! !
!ProfilerSelectorListPresenter categoriesFor: #reportIdentityOf:to:!public!reporting! !
!ProfilerSelectorListPresenter categoriesFor: #reportItems!public!reporting! !
!ProfilerSelectorListPresenter categoriesFor: #reportTitleTo:!public!reporting! !
!ProfilerSelectorListPresenter categoriesFor: #selectedMethod!event handling!public! !
!ProfilerSelectorListPresenter categoriesFor: #update!public!updating! !

!ProfilerSelectorListPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 5 0 0 0 416 1180166 ##(ProportionalLayout) 234 240 98 2 410 8 ##(Splitter) 98 12 0 416 98 2 8 1140850688 1 608 0 498 528 0 5 0 0 0 608 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 1 233 834 701 7 608 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 116 0 0 0 94 1 0 0 119 0 0 0] 98 0 834 193 193 0 27 1 16 234 256 98 4 410 8 ##(ReferenceView) 98 14 0 416 98 2 8 1140850688 131073 992 0 0 0 5 0 0 0 992 1180166 ##(ResourceIdentifier) 8 ##(SmalltalkWorkspace) 8 #resource_Default_view 0 706 202 208 98 1 770 800 98 2 834 1 239 834 701 233 992 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 119 0 0 0 94 1 0 0 235 0 0 0] 98 0 944 0 27 8 'workspace' 410 8 ##(ListView) 98 30 0 416 98 2 8 1140920397 1025 1312 590662 2 ##(ListModel) 202 208 1280 0 1114638 ##(STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 498 528 0 5 0 0 0 1312 0 8 4294904214 8 ##(BasicListAbstract) 459270 ##(Message) 8 #profilerIconIndex 98 0 1450 8 ##(IconImageManager) 8 #current 0 0 0 0 0 0 202 208 98 6 920646 5 ##(ListViewColumn) 8 'Selector' 201 8 #left 1536 8 ##(SortedCollection) 787814 3 ##(BlockClosure) 0 0 1180966 ##(CompiledExpression) 3 1 1552 8 'doIt' 8 '[:o | o object selector]' 8 #[31 105 17 158 159 106] 8 #object 8 #selector 1792 7 257 0 0 1312 1696 3 0 0 1698 8 'Class' 201 1744 1536 1760 1778 0 0 1810 3 1 1552 8 'doIt' 8 '[:o | o object methodClass]' 8 #[31 105 17 158 159 106] 1888 8 #methodClass 1952 7 257 0 0 1312 1696 3 0 0 1698 8 'Tally all %' 201 8 #center 1536 1760 1554 8 #tallyAll 98 0 0 1312 1696 1 0 0 1698 8 'Tally active %' 201 2080 1536 1760 1554 8 #tallyActive 2128 0 1312 1696 1 0 0 1698 8 'Time all %' 201 2080 1536 1760 1554 8 #timeAll 2128 0 1312 1696 1 0 0 1698 8 'Time active %' 201 2080 1536 1760 1554 8 #timeActive 2128 0 1312 1696 1 0 0 8 #report 1280 0 131169 0 0 706 202 208 98 2 770 800 98 2 834 1 1 834 701 233 1312 770 8 #text: 98 1 8 'Selector' 1312 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 116 0 0 0] 98 0 944 0 27 8 'items' 0 706 202 208 98 1 770 800 98 2 834 20001 20001 834 701 471 416 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 110 40 0 0 251 39 0 0] 98 3 1312 608 992 944 0 27)! !
!ProfilerSelectorListPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

