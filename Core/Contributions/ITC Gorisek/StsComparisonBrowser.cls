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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851500 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 482 512 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 1 1 738 63 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 738 193 193 0 27 8 'imageTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Smalltalk_tools 0 962 202 208 98 1 1026 1056 98 2 738 63 1 738 991 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1168 1184 0 27 8 'smalltalkTools' 234 256 1168 98 0 234 240 1168 0 1 0 738 33 31 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1139 51 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 57 2 0 0 25 0 0 0] 98 2 832 1216 1184 0 27 0 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 1776 0 482 512 0 7 0 0 0 1776 1180166 ##(Smalltalk.ProportionalLayout) 234 240 1168 16 234 256 98 4 410 8 ##(Smalltalk.MultipleSelectionListView) 98 30 0 1776 98 2 8 1140920393 1 1952 590662 2 ##(Smalltalk.ListModel) 202 208 1168 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 512 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 19 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #menuBrowseEditions 8 '&Browse Editions' 1 1 0 0 0 2178 1 2210 8 #menuLoadLeft 8 'Load &Left' 9803 1 0 0 0 2178 1 2210 8 #menuLoadRight 8 'Load &Right' 9807 1 0 0 0 2178 1 2210 8 #menuRemoveFromList 8 'R&emove from List' 1629 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2178 1025 2210 8 #menuRemoveOnLoad 8 'Remo&ve on Load' 1 1 0 0 0 2130 0 16 98 6 2178 1 2210 8 #menuSelectMethodsWithWhitespace 8 'Methods with Whitespace changes' 1 1 0 0 0 2178 1 2210 8 #menuSelectMethodsCategoryChanges 8 'Methods with Category changes' 1 1 0 0 0 2178 1 2210 8 #menuSelectMethodsWithWhitespaceAndCategoryChanges 8 'Methods with Whitespace and Category changes' 1 1 0 0 0 2466 4097 2178 1 2210 8 #menuSelectMethodsLoadedLeft 8 'Loaded Methods on the Left Side' 1 1 0 0 0 2178 1 2210 8 #menuSelectMethodsLoadedRight 8 'Loaded Methods on the Right Side' 1 1 0 0 0 8 'Select &All/Only ...' 0 1 0 0 0 0 0 2466 4097 2130 0 16 98 4 2178 1 2210 8 #menuFileOutVW 8 'VisualWorks Change Set' 1 1 0 0 0 2178 1 2210 8 #menuFileOutSqueak 8 'Squeak Change Set' 1 1 0 0 0 2178 1 2210 8 #menuFileOutSmalltalkX 8 'Smalltalk/X Change Set' 1 1 0 0 0 2178 1 2210 8 #menuFileOutVastDoItScript 8 'VAST/VA Smalltalk Do It Script' 1 1 0 0 0 8 'File &Out Left As ...' 0 1 0 0 0 0 0 2178 1 2210 8 #menuSaveAsChangeSet 8 'Save as Change Set into repository' 1 1 0 0 0 2466 4097 2178 1 2210 8 #menuBrowseDefinitions 8 'Browse Definitions' 1 1 0 0 0 2178 1 2210 8 #menuBrowseReferences 8 'Browse Re&ferences' 1 1 0 0 0 2466 4097 2178 1 2210 8 #menuCompareRenamedMethodOrClassEditions 8 'Compare Editions' 1 1 0 0 0 2178 1 2210 8 #menuShowChangeLog 8 'Show Change Log' 1 1 0 0 0 2466 4097 2178 1 2210 8 #menuCompareLeftWithImage 8 'Compare left with Image' 1 1 0 0 0 2178 1 2210 8 #menuCompareLeftWithProject 8 'Compare left with Project edition...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1952 0 8 4294909021 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 0 202 208 98 8 920646 5 ##(Smalltalk.ListViewColumn) 8 'Package' 241 8 #left 459270 ##(Smalltalk.Message) 8 #owningPackageName 98 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 4016 8 'doIt' 8 '[:a :b | a owningPackageName < b owningPackageName]' 8 #[30 105 226 0 226 32 128 106] 3984 4032 7 513 0 0 0 1952 0 1 0 0 3890 8 'Element' 501 3936 3954 8 #elementDescription 4000 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[:a :b | a elementDescription < b elementDescription]
' 8 #[30 105 226 0 226 32 128 106] 4176 4192 7 513 0 0 0 1952 0 1 0 0 3890 8 'Change type' 381 3936 3954 8 #description 4000 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[:a :b | a description < b description]
' 8 #[30 105 226 0 226 32 128 106] 4320 4336 7 513 0 0 0 1952 0 1 0 0 3890 8 'Left author' 201 3936 3954 8 #leftEditionDeveloper 4000 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[:a :b | a leftEditionDeveloper < b leftEditionDeveloper]
' 8 #[30 105 226 0 226 32 128 106] 4464 4480 7 513 0 0 0 1952 0 1 0 0 3890 8 'Left timestamp' 261 3936 3954 8 #leftEditionTimestampString 4000 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[:a :b | 
a leftEditionTimestamp isNil 
	ifTrue: [true]
	ifFalse: 
		[b leftEditionTimestamp isNil 
			ifTrue: [false]
			ifFalse: [a leftEditionTimestamp < b leftEditionTimestamp]]]
' 8 #[30 105 226 0 223 2 58 106 226 32 223 2 59 106 226 0 226 32 128 106] 8 #leftEditionTimestamp 4624 7 513 0 0 0 1952 0 1 0 0 3890 8 'Right author' 221 3936 3954 8 #rightEditionDeveloper 4000 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[:a :b | a rightEditionDeveloper < b rightEditionDeveloper]
' 8 #[30 105 226 0 226 32 128 106] 4768 4784 7 513 0 0 0 1952 0 1 0 0 3890 8 'Right timestamp' 261 3936 3954 8 #rightEditionTimestampString 4000 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[:a :b | 
a rightEditionTimestamp isNil 
	ifTrue: [true]
	ifFalse: 
		[b rightEditionTimestamp isNil 
			ifTrue: [false]
			ifFalse: [a rightEditionTimestamp < b rightEditionTimestamp]]]' 8 #[30 105 226 0 223 2 58 106 226 32 223 2 59 106 226 0 226 32 128 106] 8 #rightEditionTimestamp 4928 7 513 0 0 0 1952 0 1 0 0 3890 8 'Last change' 281 3936 3954 8 #lastChangeTimestampString 4000 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[:a :b | 
a lastChangeTimestamp isNil 
	ifTrue: [true]
	ifFalse: 
		[b lastChangeTimestamp isNil ifTrue: [false] ifFalse: [a lastChangeTimestamp < b lastChangeTimestamp]]]


' 8 #[30 105 226 0 223 2 58 106 226 32 223 2 59 106 226 0 226 32 128 106] 8 #lastChangeTimestamp 5088 7 513 0 0 0 1952 0 3 0 0 8 #report 1168 0 131169 0 98 1 0 962 202 208 98 3 1026 1056 98 2 738 1 1 738 1139 341 1952 1026 8 #contextMenu: 98 1 2144 1952 1026 8 #text: 98 1 8 'Package' 1952 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 57 2 0 0 170 0 0 0] 98 0 1184 0 27 8 'changesList' 410 1792 98 15 0 1776 98 2 8 1409286144 131073 5504 0 482 8 4278190080 0 7 0 0 0 5504 1874 234 240 1168 32 234 256 98 2 410 1792 98 15 0 5504 98 2 8 1140850688 131073 5664 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 5664 530 1 1 410 8 ##(Smalltalk.StaticText) 98 16 0 5664 98 2 8 1140850945 1 5776 0 0 0 7 0 0 0 5776 0 8 4294908187 852486 ##(Smalltalk.NullConverter) 0 0 0 962 202 208 98 2 1026 1056 98 2 738 1 5 738 565 31 5776 1026 5392 98 1 8 'Before' 5776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 26 1 0 0 17 0 0 0] 98 0 1184 0 27 0 0 0 410 8 ##(Smalltalk.ScintillaView) 98 50 0 5664 98 2 8 1174409476 262145 6112 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 482 5584 0 7 0 0 0 6112 0 8 4294905031 5874 0 0 11 0 234 256 98 12 8 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 0 0 1 0 0 0 0 6336 0 0 0 8 #indentGuide 6354 75 0 0 1 0 0 0 0 6384 0 0 0 8 #callTip 6354 77 786694 ##(Smalltalk.IndexedColor) 33554457 6450 33554471 1 0 0 0 0 6416 0 0 0 8 #whitespace 6354 3 196934 1 ##(Smalltalk.RGB) 16842881 0 1 0 0 0 0 6496 0 0 0 8 #diff 6354 5 0 6530 131071 3 0 0 0 0 6560 0 1401 0 8 #normal 6354 1 0 0 1 0 0 0 0 6608 0 0 0 98 40 6624 6512 6576 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6368 0 0 0 6400 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler) 98 0 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 6112 8 #circle 0 0 0 0 0 0 202 208 1168 0 63 9215 0 0 0 0 6450 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 6304 0 0 0 0 1 0 234 256 98 4 8 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 6112 33423361 3 32 6928 0 0 0 0 0 0 8 #Error 6946 17 6112 33554459 3 32 6976 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 6354 1029 0 6530 31185883 1 0 0 0 0 7040 0 0 0 6976 6354 1031 6530 335 6530 31317503 1 0 0 0 0 6976 0 0 0 6928 6354 1027 6530 60239 6530 31326207 1 0 0 0 0 6928 0 0 0 0 962 202 208 98 9 1026 1056 98 2 738 1 35 738 565 309 6112 1026 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 6112 1026 8 #isTextModified: 98 1 32 6112 1026 8 #modificationEventMask: 98 1 9215 6112 1026 8 #secondaryCaretForecolor: 98 1 6530 16711423 6112 1026 8 #caretPeriod: 98 1 1061 6112 1026 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 6112 49 3 32 1 5 7650 3 6112 1 1 32 67108863 5 7650 5 6112 1 1 32 1 5 6112 1026 8 #tabIndents: 98 1 16 6112 1026 8 #areAdditionalCaretsVisible: 98 1 16 6112 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 26 1 0 0 171 0 0 0] 98 0 1184 0 29 234 256 98 4 5776 8 'beforeTitle' 6112 8 'before' 590342 ##(Smalltalk.Rectangle) 738 1 5 738 1 1 962 202 208 98 1 1026 1056 98 2 738 1 1 738 565 343 5664 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 26 1 0 0 171 0 0 0] 98 2 5776 6112 1184 0 27 8 'Before' 0 962 202 208 98 1 1026 1056 98 2 738 1 351 738 1139 343 5504 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 175 0 0 0 57 2 0 0 90 1 0 0] 98 3 5664 410 8 ##(Smalltalk.Splitter) 98 12 0 5504 98 2 8 1140850688 1 8320 0 482 5584 0 519 0 0 0 8320 962 202 208 98 1 1026 1056 98 2 738 565 1 738 11 343 8320 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 1 0 0 0 0 0 0 31 1 0 0 171 0 0 0] 98 0 1184 0 27 410 1792 98 15 0 5504 98 2 8 1140850688 131073 8576 0 5730 31 0 7 0 0 0 8576 530 1 1 410 5792 98 16 0 8576 98 2 8 1140850945 1 8672 0 0 0 7 0 0 0 8672 0 8 4294908187 5874 0 0 0 962 202 208 98 2 1026 1056 98 2 738 1 5 738 565 31 8672 1026 5392 98 1 8 'After' 8672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 26 1 0 0 17 0 0 0] 98 0 1184 0 27 0 0 0 410 6128 98 50 0 8576 98 2 8 1174405380 262145 8976 6194 0 32 6240 0 482 5584 0 7 0 0 0 8976 0 8 4294905031 5874 0 0 3 0 234 256 98 12 6336 6354 67 0 0 1 0 0 0 0 6336 0 0 0 6384 6354 75 0 0 1 0 0 0 0 6384 0 0 0 6416 6354 77 6464 6480 1 0 0 0 0 6416 0 0 0 6496 6354 3 6530 16842881 0 1 0 0 0 0 6496 0 0 0 6560 6354 5 0 6530 131071 3 0 0 0 0 6560 0 1401 0 6608 6354 1 0 0 1 0 0 0 0 6608 0 0 0 98 40 9248 9184 9216 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9136 0 0 0 9152 0 0 6658 6688 234 256 98 2 6736 6754 1 0 0 0 8976 6784 0 0 0 0 0 0 202 208 1168 0 63 9215 0 0 0 0 6816 0 0 65 0 0 0 6832 3 234 256 98 2 6880 9104 0 0 0 0 1 0 234 256 98 4 6928 6946 19 8976 33423361 3 32 6928 0 0 0 0 0 0 6976 6946 17 8976 33554459 3 32 6976 0 0 0 0 0 0 0 0 234 256 98 6 7040 6354 1029 0 6530 31185883 1 0 0 0 0 7040 0 0 0 6976 6354 1031 6530 335 6530 31317503 1 0 0 0 0 6976 0 0 0 6928 6354 1027 6530 60239 6530 31326207 1 0 0 0 0 6928 0 0 0 0 962 202 208 98 9 1026 1056 98 2 738 1 35 738 565 309 8976 1026 7312 98 1 7346 3 1 3 8976 1026 7392 98 1 32 8976 1026 7440 98 1 9215 8976 1026 7488 98 1 6530 16711423 8976 1026 7552 98 1 1061 8976 1026 7600 98 1 98 3 7650 1 8976 49 3 32 1 5 7650 3 8976 1 1 32 67108863 5 7650 5 8976 1 1 32 1 5 8976 1026 7728 98 1 16 8976 1026 7776 98 1 16 8976 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 26 1 0 0 171 0 0 0] 98 0 1184 0 29 234 256 98 4 8976 8 'after' 8672 8 'afterTitle' 7922 738 1 5 738 1 1 962 202 208 98 2 1026 1056 98 2 738 575 1 738 565 343 8576 1026 5392 98 1 8 'After' 8576 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 1 0 0 0 0 0 0 57 2 0 0 171 0 0 0] 98 2 8672 8976 1184 0 27 1184 0 27 8 'differencesPresenter' 0 962 202 208 98 1 1026 1056 98 2 738 1 51 738 1139 693 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 57 2 0 0 115 1 0 0] 98 3 1952 410 8336 98 12 0 1776 98 2 8 1140850688 1 10624 0 482 512 0 519 0 0 0 10624 962 202 208 98 1 1026 1056 98 2 738 1 341 738 1139 11 10624 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 170 0 0 0 57 2 0 0 175 0 0 0] 98 0 1184 0 27 5504 1184 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 2130 0 16 98 9 2178 1 2210 8 #fileNew 8 '&New' 8349 1 0 0 0 2178 1 2210 8 #fileOpen 8 '&Open...' 8351 1 0 0 0 2178 1 2210 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 2466 4097 2178 1 2210 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 2178 1 2210 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 2178 1 2210 8 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 2466 4097 2178 1 2210 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 8 '&File' 0 1 0 0 20093 0 0 2130 0 16 98 11 2178 1 2210 8 #undo 8 '&Undo' 8373 1 0 0 0 2466 4097 2178 1 2210 8 #cutSelection 8 'Cu&t' 8369 1 0 0 0 2178 1 2210 8 #copySelection 8 '&Copy' 8327 1 0 0 0 2178 1 2210 8 #pasteClipboard 8 '&Paste' 8365 1 0 0 0 2178 1 2210 8 #clearSelection 8 '&Delete' 1 1 0 0 0 2178 1 2210 8 #selectAll 8 'Select &All' 1 1 0 0 0 2466 4097 2178 1 2210 8 #find 8 '&Find...' 8333 1 0 0 0 2178 1 2210 8 #findNext 8 'Find &Next' 229 1 0 0 0 2178 1 2210 8 #findReplace 8 '&Replace...' 8337 1 0 0 0 8 '&Edit' 0 1 0 0 20113 0 0 2130 0 16 98 7 2178 1 2210 8 #browseIt 8 '&Browse It' 8325 1 0 0 0 2178 1 2210 8 #displayIt 8 '&Display It' 8329 1 0 0 0 2178 1 2210 8 #evaluateIt 8 '&Evaluate It' 8331 1 0 0 0 2178 1 2210 8 #inspectIt 8 '&Inspect It' 8339 1 0 0 0 2178 1 2210 8 #fileItIn 8 '&File It In' 1 1 0 0 0 2466 4097 2178 1 2210 8 #accept 8 '&Accept' 8359 1 0 0 0 8 '&Workspace' 0 1 0 0 20127 0 0 2130 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 20129 0 0 2130 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 20131 0 0 2130 0 16 98 15 2178 1 2210 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 2178 1 2210 8 #help 8 'On this &Tool' 1249 1 0 0 0 2178 1 2210 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 2466 4097 2178 1 2210 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 2466 4097 2178 1 2210 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2178 1 2210 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2178 1 2210 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2466 4097 2178 1 2210 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2178 1 2210 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2178 1 2210 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2466 4097 2178 1 2210 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 12818 0 16 12864 8 '!!APPLICATION' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 8 '&Help' 0 134217729 0 0 20155 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 738 3839 21 738 1171 861 416 1026 5392 98 1 8 'Changes Browser' 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 200 9 0 0 184 1 0 0] 98 2 560 1776 1184 0 27 )! !
!StsComparisonBrowser class categoriesFor: #displayOn:!public! !
!StsComparisonBrowser class categoriesFor: #icon!public! !
!StsComparisonBrowser class categoriesFor: #resource_Default_view!public!resources-views! !

