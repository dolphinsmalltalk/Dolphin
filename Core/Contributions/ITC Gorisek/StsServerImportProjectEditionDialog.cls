"Filed out from Dolphin Smalltalk X6.2"!

Dialog subclass: #StsServerImportProjectEditionDialog
	instanceVariableNames: 'serverUrl httpClient urlPrefix result projects projectEditions selectedProjectEditions projectsAndEditionsCacheDict cachedLocalEditions'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsServerImportProjectEditionDialog guid: (GUID fromString: '{235ED5E1-6789-4721-8BFF-30814C09FA4B}')!
StsServerImportProjectEditionDialog comment: ''!
!StsServerImportProjectEditionDialog categoriesForClass!Unclassified! !
!StsServerImportProjectEditionDialog methodsFor!

buttonClickedAdd
	| selectedEdtions coll |
	selectedEdtions := projectEditions selections.
	coll := selectedProjectEditions list.
	selectedEdtions do: [:eachEdition | (coll includes: eachEdition) ifFalse: [coll add: eachEdition]].
	selectedProjectEditions list: coll copy!

buttonClickedImportAll
	| selection |
	(selection := selectedProjectEditions list) isNilOrEmpty 
		ifTrue: 
			[MessageBox errorMsg: 'Please select project editions to import from the remote server.'
				caption: 'Can not import']
		ifFalse: 
			[result := selection copy.
			self destroy]!

buttonClickedRefreshList
	| selectedProject |
	selectedProject := projectEditions selectionOrNil ifNil: [^nil].
	projectsAndEditionsCacheDict removeKey: selectedProject name ifAbsent: [].
	self onProjectSelected!

buttonClickedRemove
	| selectedEdtions coll |
	selectedEdtions := selectedProjectEditions selections.
	coll := selectedProjectEditions list.
	selectedEdtions do: [:eachEdition | coll remove: eachEdition ifAbsent: []].
	selectedProjectEditions list: coll copy!

buttonShowCommentAndVersionCommentAllEditions
	| selectedEdtion |
	selectedEdtion := projectEditions selectionOrNil ifNil: [^nil].
	selectedEdtion comment isNilOrEmpty 
		ifFalse: [MessageBox notify: selectedEdtion comment caption: 'Project Comment'].
	selectedEdtion versionComment isNilOrEmpty 
		ifFalse: [MessageBox notify: selectedEdtion versionComment caption: 'Project Version Comment']!

buttonShowCommentAndVersionCommentSelectedEditions
	| selectedEdtion |
	selectedEdtion := selectedProjectEditions selectionOrNil ifNil: [^nil].
	selectedEdtion comment isNilOrEmpty 
		ifFalse: [MessageBox notify: selectedEdtion comment caption: 'Project Comment'].
	selectedEdtion versionComment isNilOrEmpty 
		ifFalse: [MessageBox notify: selectedEdtion versionComment caption: 'Project Version Comment']!

createComponents
	super createComponents.
	projects := self add: ListPresenter new name: 'projects'.
	projectEditions := self add: ListPresenter new name: 'allEditions'.
	selectedProjectEditions := self add: ListPresenter new name: 'selectedEditions'!

createSchematicWiring
	super createSchematicWiring.
	projects 
		when: #selectionChanged
		send: #onProjectSelected
		to: self.
	projectEditions 
		when: #actionPerformed
		send: #buttonClickedAdd
		to: self.
	selectedProjectEditions 
		when: #actionPerformed
		send: #buttonClickedRemove
		to: self!

getProjectEditionsDataFromRemoteServerFor: selectedProject 
	| response responseArray |
	Cursor wait showWhile: 
			[response := httpClient 
						get: urlPrefix , #processGetAllProjectEditionsForProjectName:on: webAsActionString , '&projectName=' 
								, selectedProject webHttpUrlEncoded].
	(response statusCode ~= 200 or: 
			[(responseArray := response contents webDeserializeFromString) isNil 
				or: [responseArray class ~= Array]]) 
		ifTrue: [self error: 'Invalid response from the server'].
	^self getShadowsEditionsFromEditionsDataArray: responseArray!

getShadowsEditionsFromEditionsDataArray: anArray 
	^anArray collect: 
			[:each | 
			| shadowEdition |
			shadowEdition := StsShadowProjectEdition new.
			shadowEdition
				name: (each at: 1);
				versionDescriptor: (each at: 2);
				developer: (each at: 3);
				timestamp: (each at: 4);
				blessing: (each at: 5 ifAbsent: []);
				comment: (each at: 6 ifAbsent: []);
				versionComment: (each at: 7 ifAbsent: []);
				isPresentInLocalRepository: (self isPresentInRepository: shadowEdition);
				yourself]!

isPresentInRepository: aStsShadowProjectEdition 
	"Answer <true> if project edition is present in the local repository."

	| projectName c |
	projectName := aStsShadowProjectEdition name.
	c := cachedLocalEditions.
	(c isNil or: [c key ~= projectName]) 
		ifTrue: 
			[Cursor wait showWhile: 
					[cachedLocalEditions := c := Association key: projectName
										value: (self sourceControl getProjectEditionsFor: projectName)]].
	c value do: 
			[:eachProjectEdition | 
			(eachProjectEdition versionDescriptor = aStsShadowProjectEdition versionDescriptor and: 
					[eachProjectEdition developer = aStsShadowProjectEdition developer 
						and: [eachProjectEdition timestamp = aStsShadowProjectEdition timestamp]]) 
				ifTrue: [^true]].
	^false!

onProjectSelected
	| editionsData selectedProject |
	selectedProject := projects selectionOrNil.
	editionsData := selectedProject isNil 
				ifTrue: [#()]
				ifFalse: 
					[projectsAndEditionsCacheDict at: selectedProject
						ifAbsentPut: [self getProjectEditionsDataFromRemoteServerFor: selectedProject]].
	(editionsData isEmpty ifFalse: [editionsData first]) 
		ifNil: [projectEditions clear]
		ifNotNil: 
			[:selection | 
			projectEditions
				list: editionsData;
				selection: selection]!

queryCommand: query 
	| selector tmp |
	selector := query commandSymbol.
	(#(#buttonClickedAdd #buttonClickedRefreshList) includes: selector) 
		ifTrue: 
			[query isEnabled: projectEditions selectionOrNil notNil.
			^true].
	selector == #buttonClickedRemove 
		ifTrue: 
			[query isEnabled: selectedProjectEditions selections notEmpty.
			^true].
	selector == #buttonClickedImportAll 
		ifTrue: 
			[query isEnabled: selectedProjectEditions list notEmpty.
			^true].
	selector == #buttonShowCommentAndVersionCommentAllEditions 
		ifTrue: 
			[query isEnabled: ((tmp := projectEditions selectionOrNil) notNil 
						and: [tmp comment isNilOrEmpty not or: [tmp versionComment isNilOrEmpty not]]).
			^true].
	selector == #buttonShowCommentAndVersionCommentSelectedEditions 
		ifTrue: 
			[query isEnabled: ((tmp := selectedProjectEditions selectionOrNil) notNil 
						and: [tmp comment isNilOrEmpty not or: [tmp versionComment isNilOrEmpty not]]).
			^true].
	^super queryCommand: query!

result
	^result!

setDefaultProjectName: defaultProjectName 
	"When this is sent, the dialog is already created.
	Set caption and get the list of all projects on the server."

	| response responseArray |
	serverUrl := self sourceControl getCurrentServerUrl.
	urlPrefix := self sourceControl getCurrentServerUrlPrefix.
	httpClient := self sourceControl getCurrentServerHttpClient.
	projectsAndEditionsCacheDict := LookupTable new.
	self caption: 'Select project editions to import from ' , serverUrl.
	Cursor wait showWhile: 
			[response := httpClient 
						get: urlPrefix , #processGetAllProjectNamesAndEditionsForDefault:on: webAsActionString 
								, '&defaultProject=' , (defaultProjectName ifNil: ['']) webHttpUrlEncoded].
	(response statusCode ~= 200 or: 
			[(responseArray := response contents webDeserializeFromString) isNil 
				or: [responseArray class ~= Array or: [responseArray size ~= 3]]]) 
		ifTrue: [self error: 'Invalid response from the server']
		ifFalse: 
			[projects list: responseArray first.
			(responseArray at: 2) isNil 
				ifFalse: 
					[projectsAndEditionsCacheDict at: (responseArray at: 2)
						put: (self getShadowsEditionsFromEditionsDataArray: (responseArray at: 3)).
					projects selection: (projects list detect: [:each | each = (responseArray at: 2)] ifNone: [])]]! !
!StsServerImportProjectEditionDialog categoriesFor: #buttonClickedAdd!public! !
!StsServerImportProjectEditionDialog categoriesFor: #buttonClickedImportAll!public! !
!StsServerImportProjectEditionDialog categoriesFor: #buttonClickedRefreshList!public! !
!StsServerImportProjectEditionDialog categoriesFor: #buttonClickedRemove!public! !
!StsServerImportProjectEditionDialog categoriesFor: #buttonShowCommentAndVersionCommentAllEditions!public! !
!StsServerImportProjectEditionDialog categoriesFor: #buttonShowCommentAndVersionCommentSelectedEditions!public! !
!StsServerImportProjectEditionDialog categoriesFor: #createComponents!public! !
!StsServerImportProjectEditionDialog categoriesFor: #createSchematicWiring!public! !
!StsServerImportProjectEditionDialog categoriesFor: #getProjectEditionsDataFromRemoteServerFor:!public! !
!StsServerImportProjectEditionDialog categoriesFor: #getShadowsEditionsFromEditionsDataArray:!public! !
!StsServerImportProjectEditionDialog categoriesFor: #isPresentInRepository:!public! !
!StsServerImportProjectEditionDialog categoriesFor: #onProjectSelected!public! !
!StsServerImportProjectEditionDialog categoriesFor: #queryCommand:!public! !
!StsServerImportProjectEditionDialog categoriesFor: #result!public! !
!StsServerImportProjectEditionDialog categoriesFor: #setDefaultProjectName:!public! !

!StsServerImportProjectEditionDialog class methodsFor!

icon
	^StsProjectEdition icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 27131905 132097 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 592 0 0 0 7 0 0 0 592 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 6 410 8 ##(Smalltalk.Splitter)  98 12 0 592 98 2 8 1140850688 1 736 0 482 8 4278190080 0 519 0 0 0 736 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 589 978 1487 11 736 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 1 0 0 231 2 0 0 43 1 0 0] 98 0 978 193 193 0 27 1 410 608 98 15 0 592 98 2 8 1140850688 131073 1104 0 0 0 7 0 0 0 1104 674 234 240 98 2 410 8 ##(Smalltalk.ListView)  98 30 0 1104 98 2 8 1140920649 1025 1216 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 1 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #buttonShowCommentAndVersionCommentAllEditions 8 'Show Comment And Version Comment' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 1216 0 8 4294902847 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn)  8 'Version descriptor' 281 8 #left 459270 ##(Smalltalk.Message)  8 #displayString 98 0 8 ##(Smalltalk.SortedCollection)  1762 8 #versionDescriptor 98 0 0 1216 0 1 0 0 1698 8 'Timestamp' 241 1744 1762 1792 1808 1824 1762 8 #timestamp 1872 0 1216 0 1 0 0 1698 8 'Developer' 287 1744 1762 1792 1808 1824 1762 8 #developer 1872 0 1216 0 1 0 0 1698 8 'Blessing' 295 1744 1762 1792 98 0 1762 8 #<= 2096 1762 8 #blessingString 2096 0 1216 0 3 0 0 8 #report 1344 0 131169 978 129 129 0 850 202 208 98 3 914 944 98 2 978 379 1 978 1109 589 1216 914 8 #contextMenu: 98 1 1440 1216 914 8 #text: 98 1 8 'Version descriptor' 1216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 189 0 0 0 0 0 0 0 231 2 0 0 38 1 0 0] 98 0 1088 0 27 7 32 234 256 98 4 410 1232 98 30 0 1104 98 2 8 1140953165 1025 2512 1298 202 208 1344 0 1376 482 512 0 7 0 0 0 2512 0 8 4294902847 1600 787814 3 ##(Smalltalk.BlockClosure)  0 459302 ##(Smalltalk.Context)  1 1 0 0 1180966 ##(Smalltalk.CompiledExpression)  3 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:object | Package icon imageIndex]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  1344 8 #[252 1 0 1 1 7 0 17 230 32 45 159 160 106 100 105] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #icon 8 #imageIndex 17 257 0 1648 0 0 0 0 0 0 202 208 98 1 1698 8 'Project' 361 1744 1600 1824 0 0 2512 0 3 0 0 2176 1344 0 131169 0 0 850 202 208 98 2 914 944 98 2 978 1 1 978 369 589 2512 914 2384 98 1 8 'Project' 2512 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 184 0 0 0 38 1 0 0] 98 0 1088 0 27 8 'projects' 1216 8 'allEditions' 0 850 202 208 98 2 914 944 98 2 978 1 1 978 1487 589 1104 914 2384 98 1 8 'ProjectAndEditionsForm' 1104 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 231 2 0 0 38 1 0 0] 98 3 2512 410 752 98 12 0 1104 98 2 8 1140850688 1 3472 0 482 832 0 519 0 0 0 3472 850 202 208 98 1 914 944 98 2 978 369 1 978 11 589 3472 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 0 0 0 0 0 0 0 189 0 0 0 38 1 0 0] 98 0 1088 0 27 1216 1088 0 27 5 410 1232 98 30 0 592 98 2 8 1140920649 1025 3712 1298 202 208 1344 0 1376 482 1408 0 7 1426 0 16 98 1 1474 1 1506 8 #buttonShowCommentAndVersionCommentSelectedEditions 8 'Show Comment And Version Comment' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 3712 0 8 4294902847 1600 1616 1648 0 0 0 0 0 0 202 208 98 5 1698 8 'Project' 201 1744 1762 8 #name 98 0 1824 0 0 3712 0 1 0 0 1698 8 'Version descriptor' 281 1744 1762 1856 4048 1824 0 0 3712 0 1 0 0 1698 1904 241 1744 1762 1952 4048 1824 0 0 3712 0 1 0 0 1698 1984 561 1744 1762 2032 98 0 1824 0 0 3712 0 1 0 0 1698 8 'Blessing' 199 1744 1762 1792 2096 1762 2128 2096 0 0 3712 0 3 0 0 2176 1344 0 131169 978 129 129 0 850 202 208 98 3 914 944 98 2 978 1 599 978 1487 297 3712 914 2336 98 1 3824 3712 914 2384 98 1 8 'Project' 3712 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 43 1 0 0 231 2 0 0 191 1 0 0] 98 0 1088 0 27 3 16 234 256 98 2 3712 8 'selectedEditions' 0 850 202 208 98 2 914 944 98 2 978 1 61 978 1487 895 592 914 2384 98 1 8 'ListsForm' 592 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 30 0 0 0 231 2 0 0 221 1 0 0] 98 3 1104 736 3712 1088 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 4802 8 #fixedParentRight 1 4802 8 #fixedParentTop 61 4802 8 #fixedParentBottom -59 410 608 98 15 0 416 98 2 8 1140850688 131073 4944 0 0 0 7 0 0 0 4944 0 234 256 98 4 410 8 ##(Smalltalk.PushButton)  98 20 0 4944 98 2 8 1140924416 1 5040 0 482 8 4278190080 0 7 0 0 0 5040 0 8 4294903291 1506 8 #buttonClickedRemove 8 '&Remove from list' 1 1 0 0 32 0 0 0 850 202 208 98 3 914 944 98 2 978 271 7 978 181 51 5040 914 8 #isEnabled: 98 1 32 5040 914 2384 98 1 8 '&Remove from list' 5040 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 0 0 0 3 0 0 0 225 0 0 0 28 0 0 0] 98 0 1088 0 29 8 'buttonRemove' 410 5056 98 20 0 4944 98 2 8 1140924416 1 5488 0 482 5136 0 7 0 0 0 5488 0 8 4294903291 1506 8 #buttonClickedImportAll 8 '&Import all' 1 1 0 0 16 0 0 0 850 202 208 98 3 914 944 98 2 978 7 7 978 181 51 5488 914 5344 98 1 32 5488 914 2384 98 1 8 '&Import all' 5488 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 3 0 0 0 93 0 0 0 28 0 0 0] 98 0 1088 0 29 8 'buttonImport' 0 850 202 208 98 2 914 944 98 2 978 1 955 978 1487 61 4944 914 2384 98 1 8 'ButtonsForm' 4944 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 221 1 0 0 231 2 0 0 251 1 0 0] 98 2 5488 5040 1088 0 27 4770 4816 1 4848 1 4802 8 #fixedPreviousBottom 1 4912 1 410 608 98 15 0 416 98 2 8 1140850688 131073 6144 0 0 0 7 0 0 0 6144 0 234 256 98 2 410 5056 98 20 0 6144 98 2 8 1140924416 1 6240 0 482 5136 0 7 0 0 0 6240 0 8 4294903291 1506 8 #buttonClickedAdd 8 '&Add for Import' 1 1 0 0 32 0 0 0 850 202 208 98 3 914 944 98 2 978 7 7 978 181 51 6240 914 5344 98 1 32 6240 914 2384 98 1 8 '&Add for Import' 6240 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 3 0 0 0 93 0 0 0 28 0 0 0] 98 0 1088 0 29 8 'buttonAdd' 0 850 202 208 98 2 914 944 98 2 978 1 1 978 1487 61 6144 914 2384 98 1 8 'SearchForm' 6144 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 231 2 0 0 30 0 0 0] 98 2 6240 410 5056 98 20 0 6144 98 2 8 1140924416 1 6848 0 482 5136 0 7 0 0 0 6848 0 8 4294903291 1506 8 #buttonClickedRefreshList 8 'Re&fresh list' 1 1 0 0 32 0 0 0 850 202 208 98 3 914 944 98 2 978 271 7 978 181 51 6848 914 5344 98 1 32 6848 914 2384 98 1 8 'Re&fresh list' 6848 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 0 0 0 3 0 0 0 225 0 0 0 28 0 0 0] 98 0 1088 0 29 1088 0 27 4770 4816 1 4848 1 4880 1 4802 8 #fixedViewTop 61 234 256 1344 0 0 0 0 0 11097 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 32 8 2010572119 850 202 208 98 3 914 944 98 2 978 3359 21 978 1511 1091 416 914 2384 98 1 8 'Select project editions to import' 416 914 8 #updateMenuBar 1344 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 5 0 0 10 0 0 0 228 8 0 0 43 2 0 0] 98 3 6144 592 4944 1088 0 27 )!

selectProjectEditionsToImportFromCurrentServerWithDefaultProjectName: defaultProjectName 
	^(self create)
		setDefaultProjectName: defaultProjectName;
		showModal;
		result! !
!StsServerImportProjectEditionDialog class categoriesFor: #icon!public! !
!StsServerImportProjectEditionDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!StsServerImportProjectEditionDialog class categoriesFor: #selectProjectEditionsToImportFromCurrentServerWithDefaultProjectName:!public! !

