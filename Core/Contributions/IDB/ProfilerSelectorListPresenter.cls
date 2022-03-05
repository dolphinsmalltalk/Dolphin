"Filed out from Dolphin Smalltalk"!

ProfilerListsPresenter subclass: #ProfilerSelectorListPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerSelectorListPresenter guid: (GUID fromString: '{425d0eb8-542e-11d3-998b-d5ca2c3c1d61}')!
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
!ProfilerSelectorListPresenter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filterDolphin:!filtering!public! !
hasEditableMethodSelected!public!testing! !
items!accessing!public! !
onSelectionChanged!event handling!public! !
onViewOpened!event handling!public! !
reportIdentityOf:to:!public!reporting! !
reportItems!public!reporting! !
reportTitleTo:!public!reporting! !
selectedMethod!event handling!public! !
update!public!updating! !
!

!ProfilerSelectorListPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil 496 nil 5 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 674 9 9 nil 688 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 233 674 701 7 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 116 0 0 0 94 1 0 0 119 0 0 0] 8 #() 674 193 193 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140920397 1025 976 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 496 nil 5 nil nil nil 976 nil 8 1891845904 ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Selector' 201 #left ##(Smalltalk.BasicListAbstract) 1154 #<= 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 1152 8 'doIt' 8 '[:o | o object selector]' 8 #[31 105 17 158 159 106] #object #selector 1360 7 257 nil nil 976 1264 3 nil nil 1266 8 'Class' 201 #left ##(Smalltalk.BasicListAbstract) 1154 #<= 8 #() 1346 0 nil 1378 3 1 1152 8 'doIt' 8 '[:o | o object methodClass]' 8 #[31 105 17 158 159 106] #object #methodClass 1520 7 257 nil nil 976 1264 3 nil nil 1266 8 'Tally all %' 201 #center ##(Smalltalk.BasicListAbstract) 1154 #<= 8 #() 1154 #tallyAll 8 #() nil 976 1264 1 nil nil 1266 8 'Tally active %' 201 #center ##(Smalltalk.BasicListAbstract) 1154 #<= 8 #() 1154 #tallyActive 1680 nil 976 1264 1 nil nil 1266 8 'Time all %' 201 #center ##(Smalltalk.BasicListAbstract) 1154 #<= 8 #() 1154 #timeAll 1680 nil 976 1264 1 nil nil 1266 8 'Time active %' 201 #center ##(Smalltalk.BasicListAbstract) 1154 #<= 8 #() 1154 #timeActive 1680 nil 976 1264 1 nil nil #report 1088 nil 131169 nil 34 4 nil nil 674 1 1 nil 722 138 144 34 2 786 #createAt:extent: 34 2 674 1 1 674 701 233 976 786 #text: 34 1 8 'Selector' 976 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 116 0 0 0] 8 #() 928 nil 27 8 'items' 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2192 nil nil nil 5 nil nil nil 2192 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 1 239 674 701 233 2192 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 119 0 0 0 94 1 0 0 235 0 0 0] 1088 928 nil 27 8 'workspace' nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 3839 21 674 701 471 416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 245 0 0 0] 34 3 976 576 2192 928 nil 27 )! !
!ProfilerSelectorListPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

