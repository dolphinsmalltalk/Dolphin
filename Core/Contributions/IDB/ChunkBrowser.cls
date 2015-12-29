"Filed out from Dolphin Smalltalk X6.1"!

IdbToolShell subclass: #ChunkBrowser
	instanceVariableNames: 'chunkList chunkText pathname filter'
	classVariableNames: 'ChunkTypeSelection CompareMethodsUsingParser'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChunkBrowser guid: (GUID fromString: '{625FA0D2-FFC4-4926-9AE7-06FB0998EC4E}')!
ChunkBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowser categoriesForClass!IDB Goodies! !
!ChunkBrowser methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
Chunk Browser
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

browseChunk
	chunkList singleSelection browse!

canBrowse
	^chunkList hasSingleSelection and: [chunkList singleSelection canBrowse]!

canPrint
	^(super respondsTo: #print:) and: [chunkText view textLength ~= 0]!

canShowDifferences
	^(chunkList hasSingleSelection and: [chunkList singleSelection canShowDifferences]) 
		or: [chunkList selection size = 2]!

chunkSelectAll
	"Leave all other settings alone"

	filter chunkSelectAll.
	self updateChunkList!

chunkSelectDefault
	"Leave all other settings alone"

	filter chunkSelectDefault.
	self updateChunkList!

chunkSelectNone
	"Leave all other settings alone"

	filter chunkSelectNone.
	self updateChunkList!

clearStatusReport
	(self presenterNamed: 'statusReport') value: String new!

clipboardOpen
	| text |
	text := Clipboard current getText.
	Cursor wait showWhile: 
			[model fromStream: text readStream.
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: 'ChunkBrowser - Clipboard'!

copyText
	Clipboard current setText: (chunkText hasSelection 
				ifTrue: [chunkText view selection]
				ifFalse: [chunkText view text])
		format: #RichText!

createComponents
	super createComponents.
	chunkList := self add: MultipleSelectionListPresenter new name: 'chunkList'.
	chunkText := self add: SmalltalkWorkspace new name: 'chunkText'.
	self add: TextPresenter new name: 'statusCount'.
	self add: TextPresenter new name: 'statusRange'.
	self add: TextPresenter new name: 'statusRestrict'.
	self add: TextPresenter new name: 'statusReport'!

createSchematicWiring
	super createSchematicWiring.
	chunkList
		when: #selectionChanged
			send: #onSelectionChanged
			to: self;
		when: #actionPerformed
			send: #onActionPerformed
			to: self!

differences
	| differencesPresenter |
	differencesPresenter := DifferencesPresenter show.
	chunkList hasSingleSelection 
		ifTrue: 
			[differencesPresenter
				beforeText: chunkList singleSelection sourceText;
				beforeTitle: 'Current image';
				afterText: chunkList singleSelection rawText;
				afterTitle: 'Chunk #' , chunkList singleSelection index printString;
				refresh]
		ifFalse: 
			[differencesPresenter
				beforeText: chunkList selection first rawText;
				beforeTitle: 'Chunk #' , chunkList selection first index printString;
				afterText: chunkList selection last rawText;
				afterTitle: 'Chunk #' , chunkList selection last index printString;
				refresh]!

fileOpen
	| dialog filename |
	filename ifNil: [filename := SourceManager default changesFileName].
	dialog := FileOpenDialog on: filename.
	(dialog
		fileTypes: self class fileTypes;
		defaultExtension: (File splitExtensionFrom: filename);
		showModal) ifNil: [^self] ifNotNil: [:arg | filename := arg].
	self openChunkFile: filename!

fileOpenPatch
	| dialog |
	dialog := FileOpenDialog on: '*.st'.
	(dialog
		fileTypes: (OrderedCollection with: #('Smalltalk Files (*.st)' '*.st')
					with: #('All Files (*.*)' '*.*'));
		defaultExtension: 'st';
		showModal) ifNil: [^self] ifNotNil: [:arg | pathname := arg].
	Cursor wait showWhile: 
			[model fileOpenPatch: pathname.
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: 'ChunkBrowser - ' , (File splitFilenameFrom: pathname)!

onActionPerformed
	chunkList selection do: [:each | each picked: each picked not].
	self onRefreshNeeded!

onRefreshNeeded
	chunkList view updateAll.
	chunkList hasSingleSelection ifTrue: [chunkList singleSelection showIn: chunkText]!

onSelectionChanged
	chunkList hasSingleSelection 
		ifTrue: [chunkList singleSelection showIn: chunkText]
		ifFalse: [String new].
	self clearStatusReport!

onViewClosed
	super onViewClosed.
	SmalltalkSystem current removeEventsTriggeredFor: self.
	SessionManager current resourceManager removeEventsTriggeredFor: self!

onViewOpened
	super onViewOpened.
	filter := ChunkBrowserFilter new.
	SmalltalkSystem publishedEventsOfInstances do: 
			[:each | 
			SmalltalkSystem current 
				when: each
				send: #onRefreshNeeded
				to: self].
	self openDefaultChunkFile!

openChunkFile: filename 
	Cursor wait showWhile: 
			[model fileOpen: (pathname := filename).
			chunkList selectionOrNil: nil.
			self updateChunkList].
	self caption: 'ChunkBrowser - ' , (File splitFilenameFrom: pathname)
!

openDefaultChunkFile
	self openChunkFile: SourceManager default changesFileName.
	self restrictionSave.
	self toggleRestrictingMostRecent!

pickSelection
	chunkList selection do: [:each | each picked: true].
	self onRefreshNeeded!

print
	super print: chunkText view!

queryCommand: aCommandQuery 
	aCommandQuery commandSymbol == #toggleChunkType: 
		ifTrue: 
			[| argument |
			aCommandQuery isEnabled: true.
			argument := aCommandQuery commandDescription command arguments first.
			aCommandQuery isChecked: (filter isChunkTypeSelected: argument).
			^true].
	aCommandQuery commandSymbol == #toggleComparisonType: 
		ifTrue: 
			[| argument |
			aCommandQuery isEnabled: true.
			argument := aCommandQuery commandDescription command arguments first.
			aCommandQuery isChecked: (filter isComparisonTypeSelected: argument).
			^true].
	aCommandQuery commandSymbol == #restrictionRange 
		ifTrue: 
			[aCommandQuery isEnabled: chunkList hasSelection.
			^true].
	aCommandQuery commandSymbol == #restrictionSave 
		ifTrue: 
			[aCommandQuery isEnabled: model hasChunks.
			^true].
	aCommandQuery commandSymbol == #restrictionClear 
		ifTrue: 
			[aCommandQuery isEnabled: filter isRestrictingRange.
			^true].
	aCommandQuery commandSymbol == #restrictionClass 
		ifTrue: 
			[aCommandQuery isEnabled: filter isRestrictingClass 
						| (chunkList hasSingleSelection and: [chunkList singleSelection chunkClass notNil]).
			aCommandQuery isChecked: filter isRestrictingClass.
			^true].
	aCommandQuery commandSymbol == #toggleRestrictingMostRecent 
		ifTrue: 
			[aCommandQuery isEnabled: true.
			aCommandQuery isChecked: filter isRestrictingMostRecent.
			^true].
	aCommandQuery commandSymbol == #toggleRestrictingPicked 
		ifTrue: 
			[aCommandQuery isEnabled: true.
			aCommandQuery isChecked: filter isRestrictingPicked.
			^true].
	aCommandQuery commandSymbol == #differences 
		ifTrue: 
			[aCommandQuery isEnabled: self canShowDifferences.
			^true].
	aCommandQuery commandSymbol == #copyText 
		ifTrue: 
			[aCommandQuery isEnabled: chunkList hasSingleSelection.
			^true].
	aCommandQuery commandSymbol == #browseChunk 
		ifTrue: 
			[aCommandQuery isEnabled: self canBrowse.
			^true].
	(#(#print #printPreview) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: self canPrint.
			^true].
	(#(#pickSelection #unpickSelection #restoreSelection) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: chunkList hasSelection.
			^true].
	aCommandQuery commandSymbol == #restorePicked 
		ifTrue: 
			[aCommandQuery isEnabled: model hasAnyChunksPicked.
			^true].
	aCommandQuery commandSymbol == #clipboardOpen 
		ifTrue: 
			[aCommandQuery isEnabled: (Clipboard current isFormatIdAvailable: CF_TEXT).
			^true].
	^super queryCommand: aCommandQuery!

restore: aCollection 
	| failures stream |
	failures := OrderedCollection new.
	aCollection do: [:each | each restore ifNotNil: [:arg | failures add: arg]].
	stream := String writeStream.
	(self presenterNamed: 'statusReport') 
		value: (failures isEmpty ifTrue: ['  Restore suceeded'] ifFalse: ['  Restore may have failed']).
	failures isEmpty 
		ifFalse: 
			[stream
				nextPutAll: 'The following chunks may have failed to restore:';
				cr;
				cr.
			(failures copyFrom: 1 to: (10 min: failures size)) do: 
					[:each | 
					stream
						print: each key;
						space;
						nextPutAll: each value;
						cr].
			failures size > 10 
				ifTrue: 
					[stream
						nextPutAll: '.... and ';
						print: failures size - 10;
						nextPutAll: ' more'].
			MessageBox notify: stream contents caption: 'Restore may have failed']!

restorePicked
	self restore: model pickedChunks!

restoreSelection
	self restore: chunkList selection!

restrictionClass
	filter isRestrictingClass 
		ifTrue: [filter restrictionClass: nil]
		ifFalse: 
			[chunkList hasSingleSelection 
				ifTrue: [filter restrictionClass: chunkList singleSelection chunkClass]].
	self updateChunkList!

restrictionClear
	filter restrictionRange: nil.
	self updateChunkList!

restrictionRange
	chunkList hasSelection 
		ifTrue: 
			[| first last |
			first := 9999999.
			last := 0.
			chunkList selection do: 
					[:each | 
					first := first min: each index.
					last := last max: each index].
			filter restrictionRange: (chunkList hasSingleSelection 
						ifTrue: [first to: model chunkCount]
						ifFalse: [first to: last]).
			self updateChunkList]!

restrictionSave
	filter restrictionRange: (model indexOfLastImageSave to: model chunkCount).
	self updateChunkList!

toggleChunkType: aSymbol 
	filter toggleChunkType: aSymbol.
	self updateChunkList!

toggleComparisonType: aSymbol 
	filter toggleComparisonType: aSymbol.
	self updateChunkList!

toggleRestrictingMostRecent
	filter toggleRestrictingMostRecent.
	self updateChunkList!

toggleRestrictingPicked
	filter toggleRestrictingPicked.
	self updateChunkList!

toggleRestrictionMostPicked
	filter toggleRestrictingPicked.
	self updateChunkList!

unpickAll
	chunkList list do: [:each | each picked: false].
	self onRefreshNeeded!

unpickSelection
	chunkList selection do: [:each | each picked: false].
	self onRefreshNeeded!

updateChunkList
	| currentSelection |
	currentSelection := chunkList selectionOrNil.
	chunkList list: (model filterUsing: filter).
	currentSelection 
		ifNotNil: 
			[:arg | 
			chunkList selectionOrNil: (arg select: [:each | chunkList list identityIncludes: each]).
			chunkList view ensureSelectionVisible].
	self onSelectionChanged.
	self updateStatus!

updateStatus
	(self presenterNamed: 'statusCount') value: ((String writeStream)
				nextPutAll: '  Showing: ';
				print: chunkList list size;
				nextPutAll: ' of ';
				print: (filter isRestrictingRange ifTrue: [filter restrictionRangeSize] ifFalse: [model chunkCount]);
				contents).
	(self presenterNamed: 'statusRange') value: (filter isRestrictingRange 
				ifTrue: 
					[(String writeStream)
						nextPutAll: '  Range: ';
						print: filter restrictionRangeFirst;
						nextPutAll: ' to ';
						print: filter restrictionRangeLast;
						contents]).
	(self presenterNamed: 'statusRestrict') value: ((String writeStream)
				nextPutAll: (filter isRestrictingClass ifTrue: [' Cl'] ifFalse: [String new]);
				nextPutAll: (filter isRestrictingMostRecent ifTrue: [' Re'] ifFalse: [String new]);
				nextPutAll: (filter isRestrictingPicked ifTrue: [' Pi'] ifFalse: [String new]);
				contents).
	self clearStatusReport! !
!ChunkBrowser categoriesFor: #about!commands!enquiries!public! !
!ChunkBrowser categoriesFor: #browseChunk!commands!public!testing! !
!ChunkBrowser categoriesFor: #canBrowse!public!testing! !
!ChunkBrowser categoriesFor: #canPrint!printing!public!testing! !
!ChunkBrowser categoriesFor: #canShowDifferences!public!testing! !
!ChunkBrowser categoriesFor: #chunkSelectAll!commands!public! !
!ChunkBrowser categoriesFor: #chunkSelectDefault!commands!public! !
!ChunkBrowser categoriesFor: #chunkSelectNone!commands!public! !
!ChunkBrowser categoriesFor: #clearStatusReport!helpers!public! !
!ChunkBrowser categoriesFor: #clipboardOpen!commands!public! !
!ChunkBrowser categoriesFor: #copyText!commands!public! !
!ChunkBrowser categoriesFor: #createComponents!initializing!public! !
!ChunkBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!ChunkBrowser categoriesFor: #differences!commands!public! !
!ChunkBrowser categoriesFor: #fileOpen!commands!public! !
!ChunkBrowser categoriesFor: #fileOpenPatch!commands!public! !
!ChunkBrowser categoriesFor: #onActionPerformed!event handling!public! !
!ChunkBrowser categoriesFor: #onRefreshNeeded!event handling!public! !
!ChunkBrowser categoriesFor: #onSelectionChanged!event handling!public! !
!ChunkBrowser categoriesFor: #onViewClosed!event handling!public! !
!ChunkBrowser categoriesFor: #onViewOpened!event handling!public! !
!ChunkBrowser categoriesFor: #openChunkFile:!commands!public! !
!ChunkBrowser categoriesFor: #openDefaultChunkFile!public! !
!ChunkBrowser categoriesFor: #pickSelection!commands!public! !
!ChunkBrowser categoriesFor: #print!accessing!printing!public! !
!ChunkBrowser categoriesFor: #queryCommand:!commands!public! !
!ChunkBrowser categoriesFor: #restore:!commands!public! !
!ChunkBrowser categoriesFor: #restorePicked!commands!public! !
!ChunkBrowser categoriesFor: #restoreSelection!commands!public! !
!ChunkBrowser categoriesFor: #restrictionClass!commands!public! !
!ChunkBrowser categoriesFor: #restrictionClear!commands!public! !
!ChunkBrowser categoriesFor: #restrictionRange!commands!public! !
!ChunkBrowser categoriesFor: #restrictionSave!commands!public! !
!ChunkBrowser categoriesFor: #toggleChunkType:!commands!public! !
!ChunkBrowser categoriesFor: #toggleComparisonType:!commands!public! !
!ChunkBrowser categoriesFor: #toggleRestrictingMostRecent!commands!public! !
!ChunkBrowser categoriesFor: #toggleRestrictingPicked!commands!public! !
!ChunkBrowser categoriesFor: #toggleRestrictionMostPicked!commands!public! !
!ChunkBrowser categoriesFor: #unpickAll!commands!public! !
!ChunkBrowser categoriesFor: #unpickSelection!commands!public! !
!ChunkBrowser categoriesFor: #updateChunkList!operations!public! !
!ChunkBrowser categoriesFor: #updateStatus!helpers!public! !

!ChunkBrowser class methodsFor!

chunkTypeSelection
	ChunkTypeSelection ifNil: [ChunkTypeSelection := self defaultChunkTypeSelection].
	^ChunkTypeSelection!

chunkTypeSelection: aLookupTable 
	ChunkTypeSelection := aLookupTable!

compareMethodsUsingParser
	CompareMethodsUsingParser 
		ifNil: [CompareMethodsUsingParser := self defaultCompareMethodsUsingParser].
	^CompareMethodsUsingParser!

compareMethodsUsingParser: aBoolean 
	CompareMethodsUsingParser := aBoolean!

defaultChunkTypeSelection
	^(LookupTable new)
		at: #'Class Category' put: false;
		at: #'Class Define' put: true;
		at: #'Class Delete' put: true;
		at: #'Class Comment' put: false;
		at: #'Class GUID' put: false;
		at: #'Class Protocol' put: false;
		at: #'Class Resource' put: true;
		at: #'Method Category' put: false;
		at: #'Method Define' put: true;
		at: #'Method Delete' put: true;
		at: #'Resource Define' put: true;
		at: #'Resource Delete' put: true;
		at: #System put: true;
		at: #Other put: false;
		yourself!

defaultCompareMethodsUsingParser
	^true!

defaultModel
	^ChunkBrowserModel new!

displayOn: aStream 
	aStream nextPutAll: 'Chunk Browser'!

fileTypes
	"Answer an Array of file types that can be associated with this
	class of document."

	^(OrderedCollection new)
		add: #('Change Files (*.chg)' '*.chg');
		add: #('Class Files (*.cls)' '*.cls');
		add: #('Smalltalk Files (*.st)' '*.st');
		add: #('Package Files (*.pac)' '*.pac');
		add: #('Multi-File Package Files (*.pax)' '*.pax');
		add: #('Image Source Files (*.sml)' '*.sml');
		add: #('All Files (*.*)' '*.*');
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

publishedAspects
	^(super publishedAspects)
		add: (Aspect dictionary: #chunkTypeSelection);
		add: (Aspect boolean: #compareMethodsUsingParser);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  1361 1001 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140853580 131137 576 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 0 576 658 688 8 4294903819 234 256 98 0 234 256 98 30 17807 853766 ##(Smalltalk.ToolbarButton)  17807 0 576 5 1180998 4 ##(Smalltalk.CommandDescription)  459270 ##(Smalltalk.Message)  8 #toggleChunkType: 98 1 8 #'Class Define' 8 'Class Define' 1 1 0 657990 3 ##(Smalltalk.DIBSection)  0 16 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.ImageRelativeFileLocator)  8 #current 8 'Idb\Resources\ChunkBrowser.bmp' 0 0 7 514 769 33 9 0 3 17809 898 17809 0 576 5 930 962 992 98 1 8 #'Class Delete' 8 'Class Delete' 1 1 0 1072 5 17811 898 17811 0 576 1 930 962 992 98 1 8 #'Class Comment' 8 'Class Comment' 1 1 0 1072 7 17813 898 17813 0 576 5 930 962 992 98 1 8 #'Class GUID' 8 'Class GUID' 1 1 0 1072 9 17815 898 17815 0 576 1 930 962 992 98 1 8 #'Class Protocol' 8 'Class Protocol' 1 1 0 1072 39 17817 898 17817 0 576 5 930 962 992 98 1 8 #'Method Category' 8 'Method Category' 1 1 0 1072 13 17819 898 17819 0 576 5 930 962 992 98 1 8 #'Method Define' 8 'Method Define' 1 1 0 1072 15 17821 898 17821 0 576 5 930 962 992 98 1 8 #'Method Delete' 8 'Method Delete' 1 1 0 1072 17 17823 898 17823 0 576 1 930 962 992 98 1 8 #System 8 'System' 1 1 0 1072 41 17825 898 17825 0 576 5 930 962 992 98 1 8 #Other 8 'Other' 1 1 0 1072 19 17797 1246982 ##(Smalltalk.ToolbarSystemButton)  17797 0 576 1 930 8 #fileOpen 8 'Open Chunk File' 1 1 0 1 15 17799 2050 17799 0 576 1 930 8 #copyText 8 'Copy Text' 1 1 0 1 3 17801 898 17801 0 576 1 930 8 #differences 8 'Open Differences Browser' 1 1 0 1072 47 17803 2050 17803 0 576 1 930 8 #restoreSelection 8 'Restore Selected Chunk' 1 1 0 1 9 17805 898 17805 0 576 5 930 962 992 98 1 8 #'Class Category' 8 'Class Category' 1 1 0 1072 1 98 17 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 576 3 0 1 2064 2128 2192 2256 2434 0 0 576 3 0 1 2320 912 1184 1280 1376 1472 1568 1664 1760 1856 1952 234 240 98 4 1 1 1072 31 0 1 0 514 33 33 514 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 1 1 514 1345 51 576 2642 8 #updateSize 848 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 2 0 0 25 0 0 0] 98 0 514 193 193 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140853004 1 2848 0 482 31 0 7 0 706 0 16 738 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 514 193 193 0 2848 0 8 4294904209 234 256 98 12 853766 ##(Smalltalk.StatusBarItem)  1 321 2848 0 8 ##(Smalltalk.BasicListAbstract)  0 1098 8 ##(Smalltalk.IconImageManager)  1136 8 'statusCount' 3058 1 321 2848 0 3088 0 0 8 'statusRange' 3058 1 161 2848 0 3088 0 0 8 'statusRestrict' 3058 1 181 2848 0 3088 0 0 8 'statusClass' 3058 1 -1 2848 0 3088 0 0 8 'statusReport' 3058 1 221 2848 0 3088 0 0 8 'statusLast' 98 4 3072 3152 3184 3248 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 2848 0 0 2578 202 208 98 1 2642 2672 98 2 514 1 849 514 1345 45 2848 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 1 0 0 160 2 0 0 190 1 0 0] 98 0 2832 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 3520 0 482 31 0 7 0 0 0 3520 1180166 ##(Smalltalk.ProportionalLayout)  234 240 848 16 234 256 848 590342 ##(Smalltalk.Rectangle)  514 1 1 514 1 1 2578 202 208 98 1 2642 2672 98 2 514 1 51 514 1345 799 3520 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 2 0 0 168 1 0 0] 98 3 410 3536 98 15 0 3520 98 2 8 1140850688 131073 3904 0 482 31 0 7 0 0 0 3904 546 1 1 0 0 0 0 410 8 ##(Smalltalk.MultipleSelectionListView)  98 30 0 3904 98 2 8 1140920393 1025 4000 590662 2 ##(Smalltalk.ListModel)  202 208 848 0 1098 8 ##(Smalltalk.SearchPolicy)  8 #identity 658 688 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem)  1 930 8 #pickSelection 8 'Pick selection' 1 1 0 0 0 4242 1 930 8 #unpickSelection 8 'Unpick selection' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 4242 1 930 8 #restorePicked 8 'Restore picked' 1 1 0 0 0 4242 1 930 2288 8 'Restore selection' 1 1 0 0 0 4386 4097 4242 1 930 2160 8 'Copy' 1 1 0 0 0 4242 1 930 8 #browseChunk 8 'Browse' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4000 0 8 4294904165 3088 0 3104 0 0 0 0 0 0 202 208 98 5 920646 5 ##(Smalltalk.ListViewColumn)  8 'Index' 141 8 #left 787814 3 ##(Smalltalk.BlockClosure)  0 459302 ##(Smalltalk.Context)  1 1 0 0 1180966 ##(Smalltalk.CompiledExpression)  2 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:o | o index printString]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  848 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 8 #index 8 #printString 17 257 0 8 ##(Smalltalk.SortedCollection)  0 0 4000 962 8 #chunkIconIndex 98 0 1 0 0 4722 8 'P' 49 4768 4786 0 4818 1 1 0 0 4850 1 9 4880 8 'doIt' 98 2 8 '[:o | String new]' 98 1 202 4976 848 8 #[252 1 0 1 1 6 0 17 230 32 45 146 106 100 105] 721414 ##(Smalltalk.Association)  8 #String 80 17 257 0 4786 0 4818 2 1 0 0 0 4850 2 13 4880 8 'doIt' 98 2 8 '[:a :b | 
	a pickedIconIndex = b pickedIconIndex
		ifTrue: [a index <= b index]
		ifFalse: [a pickedIconIndex > b pickedIconIndex]]' 98 1 202 4976 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 129 106 100 105] 8 #pickedIconIndex 5008 17 513 0 0 0 4000 962 5472 98 0 1 0 0 4722 8 'Type' 301 4768 962 8 #chunkType 98 0 4786 0 4818 2 1 0 0 0 4850 2 13 4880 8 'doIt' 98 2 8 '[:a :b | 
 a chunkType = b chunkType
    ifTrue: [a index <= b index]
    ifFalse: [a chunkType <= b chunkType]]' 98 1 202 4976 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] 5568 5008 17 513 0 0 0 4000 0 1 0 0 4722 8 'Identity1' 301 4768 962 8 #identity1 98 0 4786 0 4818 2 1 0 0 0 4850 2 13 4880 8 'doIt' 98 2 8 '[:a :b | 
 a identity1 = b identity1
	 ifTrue: [a index <= b index]
    	ifFalse: [a identity1 <= b identity1]]' 98 1 202 4976 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] 5792 5008 17 513 0 0 0 4000 0 1 0 0 4722 8 'Identity2' 533 4768 962 8 #identity2 5808 4786 0 4818 2 1 0 0 0 4850 2 13 4880 8 'doIt' 98 2 8 '[:a :b | 
 a identity2 = b identity2
	ifTrue: [a index <= b index]
    	ifFalse: [a identity2 <= b identity2]]' 98 1 202 4976 848 8 #[252 2 0 1 1 31 0 17 18 230 33 230 32 228 32 158 228 33 158 132 221 8 228 32 159 228 33 159 130 106 228 32 158 228 33 158 130 106 100 105] 6016 5008 17 513 0 0 0 4000 0 3 0 0 8 #report 848 0 131173 0 0 2578 202 208 98 3 2642 2672 98 2 514 9 9 514 1329 387 4000 2642 8 #contextMenu: 98 1 4208 4000 2642 8 #text: 98 1 8 'Index' 4000 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 156 2 0 0 197 0 0 0] 98 0 2832 0 27 234 256 98 2 4000 8 'chunkList' 3682 514 9 9 514 9 1 2578 202 208 98 1 2642 2672 98 2 514 1 1 514 1345 395 3904 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 2 0 0 197 0 0 0] 98 1 4000 2832 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 3520 98 2 8 1140850688 1 6720 0 658 688 0 519 0 0 0 6720 2578 202 208 98 1 2642 2672 98 2 514 1 395 514 1345 11 6720 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 197 0 0 0 160 2 0 0 202 0 0 0] 98 0 2832 0 27 410 3536 98 15 0 3520 98 2 8 1140850688 131073 6976 0 482 31 0 7 0 0 0 6976 546 1 1 0 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 6976 98 2 8 1174475012 1025 7072 721990 2 ##(Smalltalk.ValueHolder)  0 32 1098 4144 8 #equality 0 196934 1 ##(Smalltalk.RGB)  30277631 0 7 4194 0 16 98 3 4242 1 930 2160 8 'Copy' 1 1 0 0 0 4242 1 930 4448 8 'Restore picked' 1 1 0 0 0 4242 1 930 2288 8 'Restore selection' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 7072 0 403526399 852486 ##(Smalltalk.NullConverter)  0 0 11 0 234 256 98 6 8 #lineNumber 1182726 ##(Smalltalk.ScintillaTextStyle)  67 0 0 1 0 0 0 0 7504 0 0 0 8 #indentGuide 7522 75 0 0 1 0 0 0 0 7552 0 0 0 8 #normal 7522 1 0 0 1 0 0 0 0 7584 0 0 0 98 40 7600 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7536 0 0 0 7568 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler)  1 0 0 32 202 208 848 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  0 1 786694 ##(Smalltalk.IndexedColor)  33554433 7762 33554471 7072 8 #circle 202 208 848 0 63 0 0 0 0 0 7762 33554447 0 0 0 0 0 234 256 98 6 8 #literalArray 8 '()' 8 #literalBytes 8 '[]' 8 #specialCharacter 8 '()[]<>' 8 '' 1 234 256 848 0 0 0 0 3 0 0 2578 202 208 98 9 2642 2672 98 2 514 9 1 514 1329 395 7072 2642 6320 98 1 7248 7072 2642 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 7072 2642 8 #isTextModified: 98 1 32 7072 2642 8 #modificationEventMask: 98 1 9215 7072 2642 8 #indicatorDefinitions: 98 1 98 2 1836038 ##(Smalltalk.ScintillaIndicatorDefinition)  1 7072 65025 3 8402 3 7072 33423361 5 7072 2642 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 7072 1 3 32 1 8514 3 7072 1 1 32 67108863 8514 5 7072 1 1 32 1 7072 2642 8 #markers: 98 1 7824 7072 2642 8 #tabIndents: 98 1 16 7072 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 156 2 0 0 197 0 0 0] 98 0 2832 0 27 234 256 98 2 7072 8 'chunkText' 3682 514 9 1 514 9 1 2578 202 208 98 1 2642 2672 98 2 514 1 405 514 1345 395 6976 2770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 202 0 0 0 160 2 0 0 143 1 0 0] 98 1 7072 2832 0 27 2832 0 27 234 256 98 2 576 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 7 4194 0 16 98 8 4242 1 930 2096 8 '&Open' 8351 1 0 0 0 4242 1 930 8 #fileOpenPatch 8 'Open Patch File' 1 1 0 0 0 4242 1 930 8 #clipboardOpen 8 'Open On Clipboard' 1 1 0 0 0 4386 4097 4242 1 930 8 #pageSetup 8 'Page se&tup...' 1 1 0 0 0 4242 1 930 8 #print 8 '&Print...' 1 1 0 0 0 4386 4097 4242 1 930 8 #exit 8 '&Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 17687 0 0 4194 0 16 98 7 4242 1 930 2160 8 '&Copy' 8327 1 0 0 0 4242 1 930 4624 8 '&Browse' 1 1 0 0 0 4386 4097 4242 1 930 4448 8 'Restore &picked' 1 1 0 0 0 4242 1 930 2288 8 'Restore &selected' 8357 1 0 0 0 4386 4097 4242 1 930 2224 8 'Show &differences' 8355 1 0 0 0 8 '&Edit' 0 1 0 0 17699 0 0 4194 0 16 98 4 4242 1 930 4288 8 '&Pick selected' 1 1 0 0 0 4242 1 930 4352 8 '&Unpick selected' 1 1 0 0 0 4386 4097 4242 1 930 8 #unpickAll 8 'Unpick &all' 1 1 0 0 0 8 '&Pick' 0 1 0 0 17707 0 0 4194 0 16 98 17 4242 1 930 962 992 98 1 2384 8 'Class Category' 1 1 0 0 0 4242 1 930 962 992 98 1 1344 8 'Class Comment' 1 1 0 0 0 4242 1 930 962 992 98 1 1024 8 'Class Define' 1 1 0 0 0 4242 1 930 962 992 98 1 1248 8 'Class Delete' 1 1 0 0 0 4242 1 930 962 992 98 1 1440 8 'Class GUID' 1 1 0 0 0 4242 1 930 962 992 98 1 1536 8 'Class Protocol' 1 1 0 0 0 4386 4097 4242 1 930 962 992 98 1 1632 8 'Method Category' 1 1 0 0 0 4242 1 930 962 992 98 1 1728 8 'Method Define' 1 1 0 0 0 4242 1 930 962 992 98 1 1824 8 'Method Delete' 1 1 0 0 0 4386 4097 4242 1 930 962 992 98 1 2016 8 'Other' 1 1 0 0 0 4242 1 930 962 992 98 1 1920 8 'System' 1 1 0 0 0 4386 4097 4242 1 930 8 #chunkSelectAll 8 'Select All' 1 1 0 0 0 4242 1 930 8 #chunkSelectNone 8 'Select None' 1 1 0 0 0 4242 1 930 8 #chunkSelectDefault 8 'Select Default' 1 1 0 0 0 8 'Chunks' 0 1 0 0 17737 0 0 4194 0 16 98 11 4242 1 930 962 8 #toggleComparisonType: 98 1 8 #Match 8 'Show Matching' 1 1 0 0 0 4242 1 930 962 11312 98 1 8 #Differ 8 'Show Differing' 1 1 0 0 0 4242 1 930 962 11312 98 1 8 #Missing 8 'Show Missing' 1 1 0 0 0 4386 4097 4242 1 930 8 #toggleRestrictingMostRecent 8 'Restrict To Most Recent Only' 1 1 0 0 0 4242 1 930 8 #restrictionClass 8 'Restrict To Selected Class' 1 1 0 0 0 4242 1 930 8 #toggleRestrictingPicked 8 'Restrict To Picked' 1 1 0 0 0 4386 4097 4242 1 930 8 #restrictionRange 8 'Restrict Range - Selection' 1 1 0 0 0 4242 1 930 8 #restrictionSave 8 'Restrict Range - Since Last Save' 1 1 0 0 0 4242 1 930 8 #restrictionClear 8 'Clear Range Restricition' 1 1 0 0 0 8 'Filter' 0 1 0 0 17757 0 0 4194 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 17759 0 0 4194 0 16 98 19 4242 1 930 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon)  0 16 1104 49 1098 8 ##(Smalltalk.ShellLibrary)  7712 0 0 4242 1 930 8 #help 8 'On this &Tool' 1249 1 0 0 0 4242 1 930 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 4386 4097 4242 1 930 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 4386 4097 4242 1 930 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 4242 1 930 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 4242 1 930 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 4194 0 16 98 4 4242 2097153 930 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 12162 0 16 1104 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 4242 1 930 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 12162 0 16 1104 8 'TipOfTheDay.ico' 12784 0 0 4386 4097 4242 1 930 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 4386 4097 4242 1 930 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 4242 1 930 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 4242 1 930 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 4242 1 930 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 4386 4097 4242 1 930 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 12162 0 16 1104 8 'LiveUpdate.ico' 12784 0 0 4386 4097 4242 1 930 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 12162 0 16 1104 8 '!!APPLICATION' 12784 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 10 5282 8351 9120 5282 16615 9456 5282 8327 9568 5282 8357 9728 5282 8355 9792 5282 1025 930 12128 8 '&Contents' 1025 1 12162 0 16 1104 49 12192 5282 1249 930 12256 8 'On this &Tool' 1249 1 0 5282 5345 930 12320 8 'What''s This?' 5345 1 0 5282 9441 930 12704 8 '&Next Tip of the Day' 9441 1 12162 0 16 1104 8 'TipOfTheDay.ico' 12784 5282 13537 930 12848 8 '&Previous Tip of the Day' 13537 1 12162 0 16 1104 8 'TipOfTheDay.ico' 12784 0 1 0 0 0 0 1 0 0 2578 202 208 98 3 2642 2672 98 2 514 6399 21 514 1361 1001 416 2642 6368 98 1 8 'ChunkBrowser' 416 2642 8 #menuBar: 98 1 9040 416 2770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 39 15 0 0 254 1 0 0] 98 3 576 3520 2848 2832 0 27 )! !
!ChunkBrowser class categoriesFor: #chunkTypeSelection!accessing!public! !
!ChunkBrowser class categoriesFor: #chunkTypeSelection:!accessing!public! !
!ChunkBrowser class categoriesFor: #compareMethodsUsingParser!accessing!public! !
!ChunkBrowser class categoriesFor: #compareMethodsUsingParser:!accessing!public! !
!ChunkBrowser class categoriesFor: #defaultChunkTypeSelection!constants!public! !
!ChunkBrowser class categoriesFor: #defaultCompareMethodsUsingParser!constants!public! !
!ChunkBrowser class categoriesFor: #defaultModel!constants!public! !
!ChunkBrowser class categoriesFor: #displayOn:!operations!public! !
!ChunkBrowser class categoriesFor: #fileTypes!constants!public! !
!ChunkBrowser class categoriesFor: #icon!constants!public! !
!ChunkBrowser class categoriesFor: #publishedAspects!constants!public! !
!ChunkBrowser class categoriesFor: #resource_Default_view!public!resources-views! !

