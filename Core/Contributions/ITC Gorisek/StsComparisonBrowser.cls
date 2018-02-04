"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsComparisonBrowser
	instanceVariableNames: 'changesPresenter removeItemOnLoad differencesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsComparisonBrowser guid: (GUID fromString: '{848904c2-2842-11d4-b0cf-000000000000}')!
StsComparisonBrowser comment: ''!
!StsComparisonBrowser categoriesForClass!Unclassified! !
!StsComparisonBrowser methodsFor!

changeNodeDoubleClicked
	self selectedNode ifNotNil: [:value | value browse]!

changeNodeOnKeyPressed: aKeyEvent 
	| str |
	str := Keyboard keyNameFromLParam: aKeyEvent lParam.
	(str = 'Left' and: [Keyboard default isCtrlDown]) ifTrue: [^self menuLoadLeft].
	(str = 'Right' and: [Keyboard default isCtrlDown]) ifTrue: [^self menuLoadRight].
	str = 'Delete' ifTrue: [^self menuRemoveFromList]!

createComponents
	removeItemOnLoad := true.
	super createComponents.
	changesPresenter := self 
				add: ListPresenter new
				name: 'changesList'
				helpId: 10985.
	differencesPresenter := self add: StsDifferencesPresenter new name: 'differencesPresenter'!

createSchematicWiring
	super createSchematicWiring.
	changesPresenter
		when: #selectionChanged
			send: #onChangeNodeSelected
			to: self;
		when: #actionPerformed
			send: #changeNodeDoubleClicked
			to: self;
		when: #keyPressed:
			send: #changeNodeOnKeyPressed:
			to: self!

defaultHelpId
	^10902!

fileOutChangesForSmalltalkX: changes on: stream 
	changes do: 
			[:eachChange | 
			eachChange fileOutChangeForSmalltalkXOn: stream.
			stream cr]!

fileOutChangesForSqueak: changes on: stream 
	changes do: 
			[:eachChange | 
			eachChange fileOutChangeForSqueakOn: stream.
			stream cr]!

fileOutChangesForVAST: changes on: stream 
	| packages |
	packages := Set new.
	changes do: [:eachChange | packages add: eachChange owningPackageName].
	stream 
		nextPutAll: '| controllers defaultApplication |
defaultApplication := System image defaultApplication.
controllers := LookupTable new.
'.
	packages do: 
			[:eachPackageName | 
			stream
				nextPutAll: 'controllers at: ';
				nextPutAll: eachPackageName printString;
				nextPutAll: ' put: ';
				nextPutAll: (eachPackageName reject: [:eachCh | eachCh isSeparator]) , 'App.
'].
	stream cr.
	changes do: 
			[:eachChange | 
			eachChange fileOutChangeForVastOn: stream.
			stream cr].
	stream nextPutAll: '
System image defaultApplication: defaultApplication.
'!

fileOutChangesForVW: changes on: stream 
	| writer owningPackages |
	stream nextPutAll: '<?xml version="1.0"?>

'.
	writer := StsXmlWriter on: stream.

	"first define parcels"
	owningPackages := Set new.
	changes 
		do: [:each | each owningPackageName isEmpty ifFalse: [owningPackages add: each owningPackageName]].
	owningPackages do: 
			[:eachPackageName | 
			writer tag: 'component-created'
				do: 
					[writer
						tag: 'name' value: eachPackageName;
						tag: 'type' value: 'parcel'].
			writer tag: 'do-it'
				do: [stream nextPutAll: 'CodeComponent
	create: #parcel
	named: ''' , eachPackageName , '''
']].
	stream
		cr;
		cr.
	changes do: 
			[:eachChange | 
			eachChange fileOutChangeForVwUsing: writer.
			stream
				cr;
				cr]!

menuBrowseDefinitions
	| selection |
	selection := self selectedNode.
	(((selection isKindOf: StsChangedMethodNode) or: [selection isKindOf: StsChangedLooseMethodNode]) 
		and: [selection anyEdition notNil]) 
			ifTrue: [self systemModel browseDefinitionsOf: selection anyEdition selector]!

menuBrowseEditions
	self selectedNode browseEditions!

menuBrowseReferences
	| selection |
	selection := self selectedNode.
	selection anyEdition isNil ifTrue: [^nil].
	((selection isKindOf: StsChangedMethodNode) or: [selection isKindOf: StsChangedLooseMethodNode]) 
		ifTrue: [^self systemModel browseReferencesTo: selection anyEdition selector].
	((selection isKindOf: StsChangedClassNode) or: 
			[(selection isKindOf: StsChangedClassDefinitionNode) 
				or: [selection isKindOf: StsChangedClassClassDefinitionNode]]) 
		ifTrue: 
			[^self systemModel 
				browseReferencesTo: (selection anyEdition realClass ifNil: [selection anyEdition name])]!

menuCompareLeftWithImage
	| selection |
	((selection := changesPresenter selectionOrNil) isNil or: [selection isEmpty]) ifTrue: [^nil].
	(StsComparisonBrowser create)
		setChanges: (StsChangeNodesComparisonJob compare: selection with: #compareWithImage);
		caption: 'Comparing with image';
		showShell!

menuCompareLeftWithProject
	| selection projectEdition |
	((selection := changesPresenter selectionOrNil) isNil or: [selection isEmpty]) ifTrue: [^nil].
	(projectEdition := StsProjectEditionSelectionDialog showModal) isNil ifTrue: [^nil].
	(StsComparisonBrowser create)
		setChanges: (StsChangeNodesComparisonJob compare: selection with: projectEdition);
		caption: 'Comparing with project ' , projectEdition name;
		showShell!

menuCompareRenamedMethodOrClassEditions
	| selection |
	(selection := self menuCompareRenamedMethodOrClassEditionsGetSelectedEditionsOrNil) isNil 
		ifFalse: 
			[selection first class == StsMethodEdition 
				ifTrue: 
					[(StsMethodComparisonShell create)
						setMethod1: selection first method2: selection last;
						showShell]
				ifFalse: 
					[| changes |
					changes := OrderedCollection new.
					selection first compareWith: selection last on: changes.
					(StsComparisonBrowser create)
						setChanges: changes;
						caption: 'Changes Browser - ' , selection first name , ' ' , selection first displayString , ' vs ' 
									, selection last name , ' ' 
									, selection last displayString;
						showShell]]!

menuCompareRenamedMethodOrClassEditionsGetSelectedEditionsOrNil
	| selection firstEdition secondEdition |
	^((selection := changesPresenter selectionOrNil) notNil 
		and: [selection notEmpty and: [selection size = 2]]) 
			ifTrue: 
				[firstEdition := (selection first leftEdition isNil or: [selection last rightEdition isNil]) 
							ifTrue: 
								["if first one is from the right side, then take last from the left side (if not nil)"
								secondEdition := selection last leftEdition isNil 
											ifFalse: [selection last leftEdition]
											ifTrue: [selection last rightEdition].
								selection first rightEdition]
							ifFalse: 
								["if first one is from the left side, then take last from the right side (if not nil)"
								secondEdition := selection last rightEdition isNil 
											ifFalse: [selection last rightEdition]
											ifTrue: [selection last leftEdition].
								selection first leftEdition].
				firstEdition class == secondEdition class 
					ifTrue: 
						[(firstEdition class == StsMethodEdition or: [firstEdition class == StsClassEdition]) 
							ifTrue: [Array with: firstEdition with: secondEdition]]]!

menuFileOutSmalltalkX
	| filename stream fileStream |
	filename := (FileSaveDialog new)
				caption: 'File Out as Smalltalk/X Changes Set';
				fileTypes: #(#('Smalltalk/X Changes Set (*.st)' '*.st'));
				value: 'FileOutSTXChanges.st';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			self fileOutChangesForSmalltalkX: changesPresenter selectionOrNil on: stream.
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuFileOutSqueak
	| filename stream fileStream applyConversion contents |
	filename := (FileSaveDialog new)
				caption: 'File Out as Squeak Changes Set';
				fileTypes: #(#('Squeak Changes Set (*.st)' '*.st'));
				value: 'FileOutSqueakChanges.st';
				showModal.
	filename isNil ifTrue: [^nil].
	stream := WriteStream on: String new.
	self fileOutChangesForSqueak: changesPresenter selectionOrNil on: stream.
	contents := stream contents.
	(Smalltalk at: #WebTranslationService ifAbsent: []) isNil 
		ifFalse: 
			["check if file out contains extended character set chars"
			(contents detect: [:eachChar | eachChar asInteger > 128] ifNone: []) notNil 
				ifTrue: 
					[applyConversion := ChoicePrompter 
								choices: #('Save CP1250 source text as UTF-8' 'No conversion, save file as it is')
								caption: 'Select extended char set conversion'.
					applyConversion isNil ifTrue: [^nil]]].
	applyConversion = 'Save CP1250 source text as UTF-8' 
		ifTrue: 
			[Processor activeProcess webRequestCodePage: 'windows-1250'.
			contents := contents asUTF8].
	fileStream := FileStream write: filename.
	[fileStream nextPutAll: contents] ensure: [fileStream close]!

menuFileOutVastDoItScript
	| filename stream fileStream |
	filename := (FileSaveDialog new)
				caption: 'File Out as VA Smalltalk Do It Script';
				fileTypes: #(#('VAST Do It Script (*.st)' '*.st'));
				value: 'FileOutVastChanges.st';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			self fileOutChangesForVAST: changesPresenter selectionOrNil on: stream.
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuFileOutVW
	| filename stream fileStream |
	filename := (FileSaveDialog new)
				caption: 'File Out as VW Changes Set';
				fileTypes: #(#('VW Changes Set (*.cha)' '*.cha'));
				value: 'FileOutChanges.cha';
				showModal.
	filename notNil 
		ifTrue: 
			[stream := WriteStream on: String new.
			self fileOutChangesForVW: changesPresenter selectionOrNil on: stream.
			fileStream := FileStream write: filename.
			[fileStream nextPutAll: stream contents] ensure: [fileStream close]]!

menuLoadLeft
	changesPresenter selectionOrNil do: 
			[:eachNode | 
			((eachNode leftEdition notNil or: [eachNode canDoRemove]) and: [eachNode respondsTo: #loadLeft]) 
				ifTrue: 
					[(eachNode loadLeft == true and: [removeItemOnLoad == true]) 
						ifTrue: [changesPresenter model remove: eachNode]]].
	differencesPresenter refresh!

menuLoadRight
	changesPresenter selectionOrNil do: 
			[:eachNode | 
			((eachNode rightEdition notNil or: [eachNode canDoRemove]) and: [eachNode respondsTo: #loadRight]) 
				ifTrue: 
					[(eachNode loadRight == true and: [removeItemOnLoad == true]) 
						ifTrue: [changesPresenter model remove: eachNode]]].
	differencesPresenter refresh!

menuRemoveFromList
	| selection |
	selection := changesPresenter selectionOrNil.
	selection size > 30 
		ifTrue: 
			[changesPresenter 
				model: (ListModel on: ((changesPresenter model asOrderedCollection)
								removeAll: selection;
								yourself))]
		ifFalse: [changesPresenter model removeAll: selection]!

menuRemoveOnLoad
	removeItemOnLoad := removeItemOnLoad not!

menuSaveAsChangeSet
	"Add selected change nodes to the list of changesets that still have to be merged into the main branch."

	| comment coll |
	changesPresenter selectionOrNil isNil 
		ifFalse: 
			[(comment := Prompter prompt: 'Change set comment/description:' caption: 'Saving Change Set') isNil 
				ifFalse: 
					[
					[coll := OmniBase currentTransaction root at: self sourceControl changeSetsKey
								ifAbsentPut: [OrderedCollection new].
					coll
						add: ((StsChangeSet newPersistent)
									timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds));
									developer: self sourceControl getCurrentDeveloper;
									comment: comment;
									browserTitle: self caption;
									blessing: #development;
									changeNodes: ((changesPresenter selectionOrNil asOrderedCollection)
												makePersistent;
												yourself);
									yourself);
						markDirty] 
							evaluateAndCommitIn: self sourceControl databaseConnection newTransaction]]!

menuSelectMethodsCategoryChanges
	changesPresenter selection: (changesPresenter model select: [:each | each isCategoryChangeOnly])!

menuSelectMethodsLoadedLeft
	changesPresenter selection: (changesPresenter model 
				select: [:each | each leftEdition class == StsMethodEdition and: [each leftEdition isLoaded]])!

menuSelectMethodsLoadedRight
	changesPresenter selection: (changesPresenter model 
				select: [:each | each rightEdition class == StsMethodEdition and: [each rightEdition isLoaded]])!

menuSelectMethodsWithWhitespace
	changesPresenter selection: (changesPresenter model select: [:each | each isWhitespaceChangeOnly])!

menuSelectMethodsWithWhitespaceAndCategoryChanges
	changesPresenter 
		selection: (changesPresenter model select: [:each | each isWhitespaceOrCategoryChangeOnly])!

menuShowChangeLog
	| rs shell str |
	rs := FileStream read: SourceManager default changesFileName text: true.
	
	[rs position: (rs size - 2000000 max: 0).
	str := rs upToEnd] ensure: [rs close].
	shell := SmalltalkWorkspaceDocument show.
	shell workspace toggleStyling.
	shell setDocumentData: str!

onChangeNodeSelected
	| node lst rst ls rs |
	ls := rs := ''.
	(node := self selectedNode) isNil 
		ifFalse: 
			[lst := node leftEdition.
			rst := node rightEdition.
			node isComment 
				ifTrue: 
					[ls := node leftComment.
					rs := node rightComment]
				ifFalse: 
					[ls := node leftSource.
					rs := node rightSource]].
	differencesPresenter
		clearDiffs;
		beforeTitle: lst;
		afterTitle: rst;
		compare: ls with: rs!

queryCommand: query 
	| selector node |
	selector := query commandSymbol.
	node := self selectedNode.
	selector == #menuBrowseReferences 
		ifTrue: 
			[query isEnabled: (node notNil and: [node anyEdition notNil and: [node canDoBrowseReferences]]).
			^true].
	selector == #menuBrowseDefinitions 
		ifTrue: 
			[query 
				isEnabled: (((node isKindOf: StsChangedMethodNode) or: [node isKindOf: StsChangedLooseMethodNode]) 
						and: [node anyEdition notNil]).
			^true].
	selector == #menuCompareRenamedMethodOrClassEditions 
		ifTrue: 
			[query isEnabled: self menuCompareRenamedMethodOrClassEditionsGetSelectedEditionsOrNil notNil.
			^true].
	(#(#menuRemoveFromList #menuCompareLeftWithImage #menuCompareLeftWithProject) includes: selector) 
		ifTrue: 
			[query isEnabled: node notNil.
			^true].
	selector == #menuBrowseEditions 
		ifTrue: 
			[query 
				isEnabled: (node notNil and: [node anyEdition notNil and: [node respondsTo: #browseEditions]]).
			^true].
	selector == #menuLoadLeft 
		ifTrue: 
			[query isEnabled: (node notNil 
						and: [node canDoRemove or: [node leftEdition notNil and: [node respondsTo: #loadLeft]]]).
			^true].
	selector == #menuLoadRight 
		ifTrue: 
			[query isEnabled: (node notNil 
						and: [node canDoRemove or: [node rightEdition notNil and: [node respondsTo: #loadRight]]]).
			^true].
	selector == #menuRemoveOnLoad 
		ifTrue: 
			[query
				isEnabled: true;
				isChecked: removeItemOnLoad.
			^true].
	^super queryCommand: query!

selectedNode
	| selection |
	^((selection := changesPresenter selectionOrNil) notNil and: [selection notEmpty]) 
		ifTrue: [selection first]!

setChanges: aCollection 
	changesPresenter model: (ListModel on: aCollection)!

systemModel
	^Smalltalk developmentSystem! !
!StsComparisonBrowser categoriesFor: #changeNodeDoubleClicked!private! !
!StsComparisonBrowser categoriesFor: #changeNodeOnKeyPressed:!private! !
!StsComparisonBrowser categoriesFor: #createComponents!private! !
!StsComparisonBrowser categoriesFor: #createSchematicWiring!private! !
!StsComparisonBrowser categoriesFor: #defaultHelpId!public! !
!StsComparisonBrowser categoriesFor: #fileOutChangesForSmalltalkX:on:!private! !
!StsComparisonBrowser categoriesFor: #fileOutChangesForSqueak:on:!private! !
!StsComparisonBrowser categoriesFor: #fileOutChangesForVAST:on:!private! !
!StsComparisonBrowser categoriesFor: #fileOutChangesForVW:on:!private! !
!StsComparisonBrowser categoriesFor: #menuBrowseDefinitions!private! !
!StsComparisonBrowser categoriesFor: #menuBrowseEditions!private! !
!StsComparisonBrowser categoriesFor: #menuBrowseReferences!private! !
!StsComparisonBrowser categoriesFor: #menuCompareLeftWithImage!private! !
!StsComparisonBrowser categoriesFor: #menuCompareLeftWithProject!private! !
!StsComparisonBrowser categoriesFor: #menuCompareRenamedMethodOrClassEditions!private! !
!StsComparisonBrowser categoriesFor: #menuCompareRenamedMethodOrClassEditionsGetSelectedEditionsOrNil!private! !
!StsComparisonBrowser categoriesFor: #menuFileOutSmalltalkX!private! !
!StsComparisonBrowser categoriesFor: #menuFileOutSqueak!private! !
!StsComparisonBrowser categoriesFor: #menuFileOutVastDoItScript!private! !
!StsComparisonBrowser categoriesFor: #menuFileOutVW!private! !
!StsComparisonBrowser categoriesFor: #menuLoadLeft!private! !
!StsComparisonBrowser categoriesFor: #menuLoadRight!private! !
!StsComparisonBrowser categoriesFor: #menuRemoveFromList!private! !
!StsComparisonBrowser categoriesFor: #menuRemoveOnLoad!private! !
!StsComparisonBrowser categoriesFor: #menuSaveAsChangeSet!private! !
!StsComparisonBrowser categoriesFor: #menuSelectMethodsCategoryChanges!private! !
!StsComparisonBrowser categoriesFor: #menuSelectMethodsLoadedLeft!private! !
!StsComparisonBrowser categoriesFor: #menuSelectMethodsLoadedRight!private! !
!StsComparisonBrowser categoriesFor: #menuSelectMethodsWithWhitespace!private! !
!StsComparisonBrowser categoriesFor: #menuSelectMethodsWithWhitespaceAndCategoryChanges!private! !
!StsComparisonBrowser categoriesFor: #menuShowChangeLog!private! !
!StsComparisonBrowser categoriesFor: #onChangeNodeSelected!private! !
!StsComparisonBrowser categoriesFor: #queryCommand:!private! !
!StsComparisonBrowser categoriesFor: #selectedNode!private! !
!StsComparisonBrowser categoriesFor: #setChanges:!public! !
!StsComparisonBrowser categoriesFor: #systemModel!private! !

!StsComparisonBrowser class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Changes Browser'!

icon
	^Icon fromId: 'SOURCETRACKINGTOOLSHELL.ICO'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140851500 131137 544 nil 466 496 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 544 466 496 8 4294902285 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 1 1 706 63 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 706 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 63 1 706 991 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 170 192 1088 8 #() 170 176 1088 nil 1 nil 706 33 31 706 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 1 706 1139 51 544 962 #updateSizePosted 1088 544 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 57 2 0 0 25 0 0 0] 34 2 800 1136 1104 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1664 nil 466 496 nil 7 nil nil nil 1664 1180166 ##(Smalltalk.ProportionalLayout) 170 176 1088 true 170 192 34 4 410 ##(Smalltalk.MultipleSelectionListView) 34 30 nil 1664 34 2 8 1140920393 1 1824 590662 2 ##(Smalltalk.ListModel) 138 144 1088 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 19 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #menuBrowseEditions 8 '&Browse Editions' 1 1 nil nil nil 2034 1 2066 #menuLoadLeft 8 'Load &Left' 9803 1 nil nil nil 2034 1 2066 #menuLoadRight 8 'Load &Right' 9807 1 nil nil nil 2034 1 2066 #menuRemoveFromList 8 'R&emove from List' 1629 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2034 1025 2066 #menuRemoveOnLoad 8 'Remo&ve on Load' 1 1 nil nil nil 1986 nil true 34 6 2034 1 2066 #menuSelectMethodsWithWhitespace 8 'Methods with Whitespace changes' 1 1 nil nil nil 2034 1 2066 #menuSelectMethodsCategoryChanges 8 'Methods with Category changes' 1 1 nil nil nil 2034 1 2066 #menuSelectMethodsWithWhitespaceAndCategoryChanges 8 'Methods with Whitespace and Category changes' 1 1 nil nil nil 2258 4097 2034 1 2066 #menuSelectMethodsLoadedLeft 8 'Loaded Methods on the Left Side' 1 1 nil nil nil 2034 1 2066 #menuSelectMethodsLoadedRight 8 'Loaded Methods on the Right Side' 1 1 nil nil nil 8 'Select &All/Only ...' nil 1 nil nil nil nil nil 2258 4097 1986 nil true 34 4 2034 1 2066 #menuFileOutVW 8 'VisualWorks Change Set' 1 1 nil nil nil 2034 1 2066 #menuFileOutSqueak 8 'Squeak Change Set' 1 1 nil nil nil 2034 1 2066 #menuFileOutSmalltalkX 8 'Smalltalk/X Change Set' 1 1 nil nil nil 2034 1 2066 #menuFileOutVastDoItScript 8 'VAST/VA Smalltalk Do It Script' 1 1 nil nil nil 8 'File &Out Left As ...' nil 1 nil nil nil nil nil 2034 1 2066 #menuSaveAsChangeSet 8 'Save as Change Set into repository' 1 1 nil nil nil 2258 4097 2034 1 2066 #menuBrowseDefinitions 8 'Browse Definitions' 1 1 nil nil nil 2034 1 2066 #menuBrowseReferences 8 'Browse Re&ferences' 1 1 nil nil nil 2258 4097 2034 1 2066 #menuCompareRenamedMethodOrClassEditions 8 'Compare Editions' 1 1 nil nil nil 2034 1 2066 #menuShowChangeLog 8 'Show Change Log' 1 1 nil nil nil 2258 4097 2034 1 2066 #menuCompareLeftWithImage 8 'Compare left with Image' 1 1 nil nil nil 2034 1 2066 #menuCompareLeftWithProject 8 'Compare left with Project edition...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1824 nil 8 4294902479 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 8 920646 5 ##(Smalltalk.ListViewColumn) 8 'Package' 241 #left 459270 ##(Smalltalk.Message) #owningPackageName 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 3472 8 'doIt' 8 '[:a :b | a owningPackageName < b owningPackageName]' 8 #[30 105 226 0 226 32 128 106] #owningPackageName 3488 7 513 nil nil nil 1824 nil 1 nil nil 3378 8 'Element' 501 #left 3426 #elementDescription 3456 3474 0 nil 3506 2 1 3472 8 'doIt' 8 '[:a :b | a elementDescription < b elementDescription]
' 8 #[30 105 226 0 226 32 128 106] #elementDescription 3632 7 513 nil nil nil 1824 nil 1 nil nil 3378 8 'Change type' 381 #left 3426 #description 3456 3474 0 nil 3506 2 1 3472 8 'doIt' 8 '[:a :b | a description < b description]
' 8 #[30 105 226 0 226 32 128 106] #description 3760 7 513 nil nil nil 1824 nil 1 nil nil 3378 8 'Left author' 201 #left 3426 #leftEditionDeveloper 3456 3474 0 nil 3506 2 1 3472 8 'doIt' 8 '[:a :b | a leftEditionDeveloper < b leftEditionDeveloper]
' 8 #[30 105 226 0 226 32 128 106] #leftEditionDeveloper 3888 7 513 nil nil nil 1824 nil 1 nil nil 3378 8 'Left timestamp' 261 #left 3426 #leftEditionTimestampString 3456 3474 0 nil 3506 2 1 3472 8 'doIt' 8 '[:a :b | 
a leftEditionTimestamp isNil 
	ifTrue: [true]
	ifFalse: 
		[b leftEditionTimestamp isNil 
			ifTrue: [false]
			ifFalse: [a leftEditionTimestamp < b leftEditionTimestamp]]]
' 8 #[30 105 226 0 223 2 58 106 226 32 223 2 59 106 226 0 226 32 128 106] #leftEditionTimestamp 4016 7 513 nil nil nil 1824 nil 1 nil nil 3378 8 'Right author' 221 #left 3426 #rightEditionDeveloper 3456 3474 0 nil 3506 2 1 3472 8 'doIt' 8 '[:a :b | a rightEditionDeveloper < b rightEditionDeveloper]
' 8 #[30 105 226 0 226 32 128 106] #rightEditionDeveloper 4144 7 513 nil nil nil 1824 nil 1 nil nil 3378 8 'Right timestamp' 261 #left 3426 #rightEditionTimestampString 3456 3474 0 nil 3506 2 1 3472 8 'doIt' 8 '[:a :b | 
a rightEditionTimestamp isNil 
	ifTrue: [true]
	ifFalse: 
		[b rightEditionTimestamp isNil 
			ifTrue: [false]
			ifFalse: [a rightEditionTimestamp < b rightEditionTimestamp]]]' 8 #[30 105 226 0 223 2 58 106 226 32 223 2 59 106 226 0 226 32 128 106] #rightEditionTimestamp 4272 7 513 nil nil nil 1824 nil 1 nil nil 3378 8 'Last change' 281 #left 3426 #lastChangeTimestampString 3456 3474 0 nil 3506 2 1 3472 8 'doIt' 8 '[:a :b | 
a lastChangeTimestamp isNil 
	ifTrue: [true]
	ifFalse: 
		[b lastChangeTimestamp isNil ifTrue: [false] ifFalse: [a lastChangeTimestamp < b lastChangeTimestamp]]]


' 8 #[30 105 226 0 223 2 58 106 226 32 223 2 59 106 226 0 226 32 128 106] #lastChangeTimestamp 4400 7 513 nil nil nil 1824 nil 3 nil nil #report 1088 nil 131169 nil 8 #(nil) 898 138 144 34 3 962 #createAt:extent: 34 2 706 1 1 706 1139 341 1824 962 #contextMenu: 34 1 2000 1824 962 #text: 34 1 8 'Package' 1824 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 57 2 0 0 170 0 0 0] 8 #() 1104 nil 27 8 'changesList' 410 ##(Smalltalk.ContainerView) 34 15 nil 1664 34 2 8 1409286144 131073 4752 nil 466 8 4278190080 nil 7 nil nil nil 4752 1746 170 176 1088 false 170 192 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 4752 34 2 8 1140850688 131073 4912 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 4912 514 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 4912 34 2 8 1140850945 1 5024 nil nil nil 7 nil nil nil 5024 nil 8 4294902487 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 5 706 565 31 5024 962 #text: 34 1 8 'Before' 5024 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 26 1 0 0 17 0 0 0] 8 #() 1104 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 4912 34 2 8 1174409476 262145 5344 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 4832 nil 7 nil nil nil 5344 nil 8 4294907129 5106 nil nil 11 nil 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 5586 33554471 1 nil nil nil nil #callTip nil nil nil #lineNumber 5554 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 5554 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 5554 3 196934 1 ##(Smalltalk.RGB) 16842881 nil 1 nil nil nil nil #whitespace nil nil nil #indentGuide 5554 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #diff 5554 5 nil 5682 131071 3 nil nil nil nil #diff nil 1401 nil 34 40 5648 5664 5728 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 5632 nil nil nil 5712 nil nil 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5344 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1088 nil 170 176 1088 9215 nil nil nil nil 5586 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 5520 nil nil nil nil 1 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 5344 33423361 3 false #Warning nil nil nil nil nil nil #Error 6018 17 5344 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 5554 1029 nil 5682 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 5554 1027 5682 60239 5682 31326207 1 nil nil nil nil #Warning nil nil nil #Error 5554 1031 5682 335 5682 31317503 1 nil nil nil nil #Error nil nil nil nil 898 138 144 34 6 962 #createAt:extent: 34 2 706 1 35 706 565 309 5344 962 #modificationEventMask: 8 #(4607) 5344 962 #caretPeriod: 8 #(530) 5344 962 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5344 49 3 nil nil 5 nil 6450 3 5344 1 nil nil 67108863 5 nil 6450 5 5344 1 nil nil nil 5 nil 5344 962 #maxCompletionListHeight: 8 #(9) 5344 962 #sciSetCodePage: 8 #(65001) 5344 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 26 1 0 0 171 0 0 0] 8 #() 1104 nil 29 170 192 34 4 5024 8 'beforeTitle' 5344 8 'before' 590342 ##(Smalltalk.Rectangle) 706 1 5 706 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 1 706 565 343 4912 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 26 1 0 0 171 0 0 0] 34 2 5024 5344 1104 nil 27 8 'Before' nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 351 706 1139 343 4752 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 175 0 0 0 57 2 0 0 90 1 0 0] 34 3 4912 410 ##(Smalltalk.Splitter) 34 12 nil 4752 34 2 8 1140850688 1 7088 nil 466 4832 nil 519 nil nil nil 7088 898 138 144 34 1 962 #createAt:extent: 34 2 706 565 1 706 11 343 7088 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 1 0 0 0 0 0 0 31 1 0 0 171 0 0 0] 8 #() 1104 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 4752 34 2 8 1140850688 131073 7328 nil 4978 31 nil 7 nil nil nil 7328 514 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 7328 34 2 8 1140850945 1 7424 nil nil nil 7 nil nil nil 7424 nil 8 4294902487 5106 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 706 1 5 706 565 31 7424 962 #text: 34 1 8 'After' 7424 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 26 1 0 0 17 0 0 0] 8 #() 1104 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 7328 34 2 8 1174405380 262145 7728 5410 nil false 5456 nil 466 4832 nil 7 nil nil nil 7728 nil 8 4294907129 5106 nil nil 3 nil 170 192 34 12 #callTip 5554 77 5600 5616 1 nil nil nil nil #callTip nil nil nil #lineNumber 5554 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 5554 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 5554 3 5682 16842881 nil 1 nil nil nil nil #whitespace nil nil nil #indentGuide 5554 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #diff 5554 5 nil 5682 131071 3 nil nil nil nil #diff nil 1401 nil 34 40 7920 7936 7984 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 7904 nil nil nil 7968 nil nil 5778 5808 170 192 34 2 #default 5858 1 nil nil nil 7728 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1088 nil 170 176 1088 9215 nil nil nil nil 5920 nil nil 65 nil nil nil 5936 3 170 192 34 2 #container 7856 nil nil nil nil 1 nil 170 192 34 4 #Warning 6018 19 7728 33423361 3 false #Warning nil nil nil nil nil nil #Error 6018 17 7728 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 5554 1029 nil 5682 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 5554 1027 5682 60239 5682 31326207 1 nil nil nil nil #Warning nil nil nil #Error 5554 1031 5682 335 5682 31317503 1 nil nil nil nil #Error nil nil nil nil 898 138 144 34 6 962 #createAt:extent: 34 2 706 1 35 706 565 309 7728 962 #modificationEventMask: 8 #(4607) 7728 962 #caretPeriod: 8 #(530) 7728 962 #margins: 34 1 34 3 6450 1 7728 49 3 nil nil 5 nil 6450 3 7728 1 nil nil 67108863 5 nil 6450 5 7728 1 nil nil nil 5 nil 7728 962 #maxCompletionListHeight: 8 #(9) 7728 962 #sciSetCodePage: 8 #(65001) 7728 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 26 1 0 0 171 0 0 0] 8 #() 1104 nil 29 170 192 34 4 7424 8 'afterTitle' 7728 8 'after' 6690 706 1 5 706 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 706 575 1 706 565 343 7328 962 #text: 34 1 8 'After' 7328 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 1 0 0 0 0 0 0 57 2 0 0 171 0 0 0] 34 2 7424 7728 1104 nil 27 1104 nil 27 8 'differencesPresenter' nil 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 51 706 1139 693 1664 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 57 2 0 0 115 1 0 0] 34 3 1824 410 ##(Smalltalk.Splitter) 34 12 nil 1664 34 2 8 1140850688 1 9264 nil 466 496 nil 519 nil nil nil 9264 898 138 144 34 1 962 #createAt:extent: 34 2 706 1 341 706 1139 11 9264 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 170 0 0 0 57 2 0 0 175 0 0 0] 8 #() 1104 nil 27 4752 1104 nil 27 170 192 34 2 544 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 1986 nil true 34 9 2034 1 2066 #fileNew 8 '&New' 8349 1 nil nil nil 2034 1 2066 #fileOpen 8 '&Open...' 8351 1 nil nil nil 2034 1 2066 #fileFileIn 8 '&File In...' 1 1 nil nil nil 2258 4097 2034 1 2066 #saveImage 8 'Sa&ve Image' 1 1 nil nil nil 2034 1 2066 #saveImageAs 8 'Save Image As...' 1 1 nil nil nil 2034 1 2066 #compressChanges 8 '&Compress Changes' 1 1 nil nil nil 2258 4097 2034 1 2066 #smalltalkExit 8 'E&xit Dolphin' 1 1 nil nil nil 8 '&File' nil 1 nil nil 37827 nil nil 1986 nil true 34 11 2034 1 2066 #undo 8 '&Undo' 8373 1 nil nil nil 2258 4097 2034 1 2066 #cutSelection 8 'Cu&t' 8369 1 nil nil nil 2034 1 2066 #copySelection 8 '&Copy' 8327 1 nil nil nil 2034 1 2066 #pasteClipboard 8 '&Paste' 8365 1 nil nil nil 2034 1 2066 #clearSelection 8 '&Delete' 1 1 nil nil nil 2034 1 2066 #selectAll 8 'Select &All' 1 1 nil nil nil 2258 4097 2034 1 2066 #find 8 '&Find...' 8333 1 nil nil nil 2034 1 2066 #findNext 8 'Find &Next' 229 1 nil nil nil 2034 1 2066 #findReplace 8 '&Replace...' 8337 1 nil nil nil 8 '&Edit' nil 1 nil nil 37847 nil nil 1986 nil true 34 7 2034 1 2066 #browseIt 8 '&Browse It' 8325 1 nil nil nil 2034 1 2066 #displayIt 8 '&Display It' 8329 1 nil nil nil 2034 1 2066 #evaluateIt 8 '&Evaluate It' 8331 1 nil nil nil 2034 1 2066 #inspectIt 8 '&Inspect It' 8339 1 nil nil nil 2034 1 2066 #fileItIn 8 '&File It In' 1 1 nil nil nil 2258 4097 2034 1 2066 #accept 8 '&Accept' 8359 1 nil nil nil 8 '&Workspace' nil 1 nil nil 37861 nil nil 1986 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 37863 nil nil 1986 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 37865 nil nil 1986 nil true 34 15 2034 1 2066 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) nil nil 2034 1 2066 #help 8 'On this &Tool' 1249 1 nil nil nil 2034 1 2066 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2258 4097 2034 1 2066 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 2258 4097 2034 1 2066 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2034 1 2066 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2034 1 2066 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2258 4097 2034 1 2066 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 2034 1 2066 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2034 1 2066 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2258 4097 2034 1 2066 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 11058 nil true 11104 8 '!!APPLICATION' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 8 '&Help' nil 134217729 nil nil 37889 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 706 3839 21 706 1171 861 416 962 #text: 34 1 8 'Changes Browser' 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 200 9 0 0 184 1 0 0] 34 2 544 1664 1104 nil 27 )! !
!StsComparisonBrowser class categoriesFor: #displayOn:!public! !
!StsComparisonBrowser class categoriesFor: #icon!public! !
!StsComparisonBrowser class categoriesFor: #resource_Default_view!public!resources-views! !

