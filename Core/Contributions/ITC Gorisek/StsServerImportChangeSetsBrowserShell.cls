"Filed out from Dolphin Smalltalk X6.2"!

Dialog subclass: #StsServerImportChangeSetsBrowserShell
	instanceVariableNames: 'httpClient urlPrefix textDeveloper textComment textIncludesClass listMinBlessing listChangeSetsOnServer listChangeSetsForImport'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsServerImportChangeSetsBrowserShell guid: (GUID fromString: '{D3F84E7A-F864-4B7C-B196-F74910C56AA3}')!
StsServerImportChangeSetsBrowserShell comment: ''!
!StsServerImportChangeSetsBrowserShell categoriesForClass!Unclassified! !
!StsServerImportChangeSetsBrowserShell methodsFor!

addForImport
	| newList selections |
	(selections := listChangeSetsOnServer selections) isEmpty ifTrue: [^nil].
	newList := ItcOrderedUniqueCollection new.
	newList
		addAll: listChangeSetsForImport list;
		addAll: selections.
	listChangeSetsForImport list: newList asOrderedCollection!

createComponents
	super createComponents.
	textDeveloper := self add: TextPresenter new name: 'textDeveloper'.
	textComment := self add: TextPresenter new name: 'textComment'.
	textIncludesClass := self add: TextPresenter new name: 'textIncludesClass'.
	listMinBlessing := self add: ListPresenter new name: 'listMinBlessing'.
	listChangeSetsOnServer := self add: ListPresenter new name: 'listChangeSetsOnServer'.
	listChangeSetsForImport := self add: ListPresenter new name: 'listChangeSetsForImport'!

createSchematicWiring
	super createSchematicWiring.
	listChangeSetsOnServer 
		when: #actionPerformed
		send: #addForImport
		to: self.
	listChangeSetsForImport 
		when: #actionPerformed
		send: #removeFromImportList
		to: self!

findOnServer
	| changeSets |
	(changeSets := self getChangeSetsFromServer) isNil ifTrue: [^nil].
	listChangeSetsOnServer list: changeSets!

getChangeSetFromServerByDescription: eachChangeSetData 
	| response changeSet request errorDescription |
	request := urlPrefix , #processGetChangeSetByDescription:on: webAsActionString.
	request := request , '&browserTitle=' , (eachChangeSetData first ifNil: ['']) webHttpUrlEncoded.
	request := request , '&comment=' , ((eachChangeSetData at: 2) ifNil: ['']) webHttpUrlEncoded.
	request := request , '&developer=' , ((eachChangeSetData at: 3) ifNil: ['']) webHttpUrlEncoded.
	request := request , '&timestamp=' 
				, ((eachChangeSetData at: 4) ifNil: ['']) asWebString webHttpUrlEncoded.
	Cursor wait showWhile: 
			[[response := httpClient get: request] on: Error
				do: [:ex | errorDescription := 'Error sending request (' , ex itcDescription , ')']].
	(response notNil and: 
			[response statusCode == 200 and: 
					[[changeSet := ODBDeserializer deserializeFromBytes: response contents asByteArray] on: Error
						do: [:ex | ex exitWith: nil].
					changeSet class == StsToBeMergedChangeSet]]) 
		ifFalse: 
			[MessageBox errorMsg: (errorDescription isNil 
						ifTrue: 
							['Invalid response received from the server.

- Check if the STS repository server is running.
- Check STS repository server version.']
						ifFalse: [errorDescription])
				caption: 'Error retrieving change sets from server'.
			^nil].
	^changeSet!

getChangeSetsForImportFromServer
	| coll |
	coll := OrderedCollection new.
	listChangeSetsForImport list 
		do: [:eachChangeSetData | coll add: ((self getChangeSetFromServerByDescription: eachChangeSetData) ifNil: [^nil])].
	^coll!

getChangeSetsFromServer
	| response changeSetsDataArr request errorDescription |
	request := urlPrefix , #processGetAllAvailableChangeSets:on: webAsActionString.
	textDeveloper value isEmpty 
		ifFalse: [request := request , '&textDeveloper=' , textDeveloper value webHttpUrlEncoded].
	textComment value isEmpty 
		ifFalse: [request := request , '&textComment=' , textComment value webHttpUrlEncoded].
	listMinBlessing selection isNil 
		ifFalse: [request := request , '&listMinBlessing=' , listMinBlessing selection webHttpUrlEncoded].
	textIncludesClass value isEmpty 
		ifFalse: [request := request , '&textIncludesClass=' , textIncludesClass value webHttpUrlEncoded].
	Cursor wait showWhile: 
			[[response := httpClient get: request] on: Error
				do: [:ex | errorDescription := 'Error sending request (' , ex itcDescription , ')']].
	(response notNil and: 
			[response statusCode == 200 and: 
					[[changeSetsDataArr := ODBDeserializer deserializeFromBytes: response contents asByteArray] 
						on: Error
						do: [:ex | ex exitWith: nil].
					changeSetsDataArr class == Array]]) 
		ifFalse: 
			[MessageBox errorMsg: (errorDescription isNil 
						ifTrue: 
							['Invalid response received from the server.

- Check if the STS repository server is running.
- Check STS repository server version.']
						ifFalse: [errorDescription])
				caption: 'Error retrieving change sets from server'.
			^nil].
	^changeSetsDataArr!

importAll
	| changeSetsForImport changeSetsLocal transaction existingChangeSet blessingLevels |
	self view disable.
	Cursor wait showWhile: 
			[(changeSetsForImport := self getChangeSetsForImportFromServer) isNil 
				ifTrue: 
					[self view enable.
					^nil].
			transaction := self sourceControl databaseConnection newTransaction.
			changeSetsLocal := transaction root at: self sourceControl changeSetsKey
						ifAbsentPut: [OrderedCollection new].
			
			[changeSetsForImport do: 
					[:eachCsForImport | 
					(existingChangeSet := changeSetsLocal detect: 
									[:eachChangeSet | 
									eachChangeSet developer = eachCsForImport developer and: 
											[eachChangeSet timestamp = eachCsForImport timestamp and: 
													[eachChangeSet comment = eachCsForImport comment 
														and: [eachChangeSet browserTitle = eachCsForImport browserTitle]]]]
								ifNone: []) isNil 
						ifFalse: 
							[existingChangeSet blessing == eachCsForImport blessing 
								ifFalse: 
									[existingChangeSet blessing isNil 
										ifTrue: 
											[existingChangeSet
												blessing: eachCsForImport blessing;
												markDirty]
										ifFalse: 
											[eachCsForImport blessing isNil 
												ifFalse: 
													[blessingLevels := StsEdition possibleBlessingLevels.
													blessingLevels := blessingLevels copyFrom: (blessingLevels indexOf: existingChangeSet blessing)
																to: blessingLevels size.
													(blessingLevels includes: eachCsForImport blessing) 
														ifTrue: 
															[existingChangeSet
																blessing: eachCsForImport blessing;
																markDirty]]]]]
						ifTrue: 
							[eachCsForImport
								makePersistent;
								markDirty.
							changeSetsLocal
								add: eachCsForImport;
								markDirty]]] 
					evaluateAndCommitIn: transaction].
	self ok!

onViewOpened
	| changeSets |
	super onViewOpened.
	self model: true.
	urlPrefix := self sourceControl getCurrentServerUrlPrefix.
	httpClient := self sourceControl getCurrentServerHttpClient.
	listMinBlessing
		list: ((OrderedCollection new)
					add: nil;
					addAll: StsEdition possibleBlessingLevels;
					yourself);
		selection: nil.
	#findOnServer.
	(changeSets := self getChangeSetsFromServer) isNil ifTrue: [self destroy].
	listChangeSetsOnServer list: changeSets!

queryCommand: query 
	| selector |
	selector := query commandSymbol.
	selector == #findOnServer 
		ifTrue: 
			[query isEnabled: true.
			^true].
	selector == #addForImport 
		ifTrue: 
			[query isEnabled: listChangeSetsOnServer selections notEmpty.
			^true].
	selector == #removeFromImportList 
		ifTrue: 
			[query isEnabled: listChangeSetsForImport selections notEmpty.
			^true].
	selector == #importAll 
		ifTrue: 
			[query isEnabled: listChangeSetsForImport list notEmpty.
			^true].
	^super queryCommand: query!

removeFromImportList
	| newList selections |
	(selections := listChangeSetsForImport selections) isEmpty ifTrue: [^nil].
	newList := listChangeSetsForImport list asOrderedCollection.
	newList removeAll: selections.
	listChangeSetsForImport list: newList asArray! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #addForImport!event handling!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #createComponents!initializing!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #createSchematicWiring!initializing!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #findOnServer!event handling!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #getChangeSetFromServerByDescription:!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #getChangeSetsForImportFromServer!event handling!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #getChangeSetsFromServer!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #importAll!event handling!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #onViewOpened!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #queryCommand:!public! !
!StsServerImportChangeSetsBrowserShell categoriesFor: #removeFromImportList!event handling!public! !

!StsServerImportChangeSetsBrowserShell class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 27131905 132097 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 592 0 0 0 519 0 0 0 592 0 234 256 98 8 410 8 ##(Smalltalk.ComboBox)  98 17 0 592 98 2 8 1144063555 1025 704 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 8 4278190080 0 7 0 0 0 704 0 8 4294904225 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 446648675 8 #[30 105 226 0 106] 8 #displayString 944 7 257 0 832 401 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  153 63 1186 241 43 704 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 31 0 0 0 196 0 0 0 52 0 0 0] 98 0 1186 193 193 0 27 8 'listMinBlessing' 410 8 ##(Smalltalk.TextEdit)  98 16 0 592 98 2 8 1140916352 1025 1328 0 482 8 4278190080 0 7 0 0 0 1328 0 8 4294904831 852486 ##(Smalltalk.NullConverter)  0 0 1 1058 202 208 98 3 1122 1152 98 2 1186 563 13 1186 241 39 1328 1122 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1328 1122 8 #isTextModified: 98 1 32 1328 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 1 0 0 6 0 0 0 145 1 0 0 25 0 0 0] 98 0 1296 0 27 8 'textComment' 410 1344 98 16 0 592 98 2 8 1140916352 1025 1792 0 482 1424 0 7 0 0 0 1792 0 8 4294904831 1458 0 0 1 1058 202 208 98 3 1122 1152 98 2 1186 153 13 1186 241 39 1792 1122 1616 98 1 1650 3 1 3 1792 1122 1696 98 1 32 1792 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 0 0 0 6 0 0 0 196 0 0 0 25 0 0 0] 98 0 1296 0 27 8 'textDeveloper' 410 1344 98 16 0 592 98 2 8 1140916352 1025 2160 0 482 1424 0 7 0 0 0 2160 0 8 4294904831 1458 0 0 1 1058 202 208 98 3 1122 1152 98 2 1186 563 63 1186 241 39 2160 1122 1616 98 1 1650 3 1 3 2160 1122 1696 98 1 32 2160 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 1 0 0 31 0 0 0 145 1 0 0 50 0 0 0] 98 0 1296 0 27 8 'textIncludesClass' 0 1058 202 208 98 2 1122 1152 98 2 1186 1 1 1186 1477 121 592 1122 8 #text: 98 1 8 'SearchForm' 592 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 226 2 0 0 60 0 0 0] 98 10 410 8 ##(Smalltalk.StaticText)  98 16 0 592 98 2 8 1140850944 1 2752 0 0 0 7 0 0 0 2752 0 8 4294904281 1458 0 0 0 1058 202 208 98 2 1122 1152 98 2 1186 13 13 1186 111 41 2752 1122 2656 98 1 8 'Developer:' 2752 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 6 0 0 0 61 0 0 0 26 0 0 0] 98 0 1296 0 27 1792 410 2768 98 16 0 592 98 2 8 1140850944 1 3072 0 0 0 7 0 0 0 3072 0 8 4294904281 1458 0 0 0 1058 202 208 98 2 1122 1152 98 2 1186 413 13 1186 101 41 3072 1122 2656 98 1 8 'Comment:' 3072 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 206 0 0 0 6 0 0 0 0 1 0 0 26 0 0 0] 98 0 1296 0 27 1328 410 2768 98 16 0 592 98 2 8 1140850944 1 3376 0 0 0 7 0 0 0 3376 0 8 4294904281 1458 0 0 0 1058 202 208 98 2 1122 1152 98 2 1186 13 63 1186 131 41 3376 1122 2656 98 1 8 'Min. blessing:' 3376 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 31 0 0 0 71 0 0 0 51 0 0 0] 98 0 1296 0 27 704 410 2768 98 16 0 592 98 2 8 1140850944 1 3680 0 0 0 7 0 0 0 3680 0 8 4294904281 1458 0 0 0 1058 202 208 98 2 1122 1152 98 2 1186 413 63 1186 141 41 3680 1122 2656 98 1 8 'Includes class:' 3680 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 206 0 0 0 31 0 0 0 20 1 0 0 51 0 0 0] 98 0 1296 0 27 2160 410 8 ##(Smalltalk.PushButton)  98 20 0 592 98 2 8 1140924416 1 3984 0 0 0 7 0 0 0 3984 0 8 4294904159 1180998 4 ##(Smalltalk.CommandDescription)  8 #findOnServer 8 '&Find on server' 1 1 0 0 32 0 0 0 1058 202 208 98 3 1122 1152 98 2 1186 823 13 1186 171 51 3984 1122 8 #isEnabled: 98 1 32 3984 1122 2656 98 1 8 '&Find on server' 3984 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 155 1 0 0 6 0 0 0 240 1 0 0 31 0 0 0] 98 0 1296 0 29 410 4000 98 20 0 592 98 2 8 1140924416 1 4400 0 0 0 7 0 0 0 4400 0 8 4294904159 4082 8 #addForImport 8 '&Add for import' 1 1 0 0 32 0 0 0 1058 202 208 98 3 1122 1152 98 2 1186 1191 61 1186 161 51 4400 1122 4272 98 1 32 4400 1122 2656 98 1 8 '&Add for import' 4400 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 83 2 0 0 30 0 0 0 163 2 0 0 55 0 0 0] 98 0 1296 0 29 1296 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft -19 4802 8 #fixedParentRight 21 4802 8 #fixedParentTop -19 4802 8 #fixedViewTop 121 410 608 98 15 0 416 98 2 8 1140850688 131073 4944 0 0 0 7 0 0 0 4944 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 2 410 8 ##(Smalltalk.MultipleSelectionListView)  98 30 0 4944 98 2 8 1140920393 1025 5072 786 202 208 832 0 864 482 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 1 984134 2 ##(Smalltalk.CommandMenuItem)  1 4082 4496 8 '&Add for import' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 5072 0 8 4294904481 459270 ##(Smalltalk.Message)  1040 98 0 8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 5 920646 5 ##(Smalltalk.ListViewColumn)  8 'Comparison' 401 8 #left 5362 1040 5392 8 ##(Smalltalk.SortedCollection)  930 0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 928 8 'doIt' 8 '[:each | each first displayString]' 8 #[31 105 226 0 159 106] 8 #first 1040 5584 7 257 0 0 5072 0 1 0 0 5490 8 'Comment/description' 401 5536 5362 1040 98 0 5362 8 #<= 5744 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 2) displayString]' 8 #[30 105 17 64 148 158 106] 1040 5792 7 257 0 0 5072 0 1 0 0 5490 8 'Developer' 201 5536 5362 1040 5744 5362 5776 5744 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 3) displayString]' 8 #[30 105 17 214 3 148 158 106] 1040 5936 7 257 0 0 5072 0 1 0 0 5490 8 'Timestamp' 241 5536 5362 1040 5744 5362 5776 5744 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 4) displayString]' 8 #[30 105 17 214 4 148 158 106] 1040 6080 7 257 0 0 5072 0 1 0 0 5490 8 'Blessing' 191 5536 5362 1040 5744 5362 5776 5744 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 5) displayString]' 8 #[30 105 17 214 5 148 158 106] 1040 6224 7 257 0 0 5072 0 1 0 0 8 #report 832 0 131169 0 0 1058 202 208 98 3 1122 1152 98 2 1186 1 1 1186 1477 479 5072 1122 8 #contextMenu: 98 1 5232 5072 1122 2656 98 1 8 'Comparison' 5072 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 226 2 0 0 239 0 0 0] 98 0 1296 0 27 852486 ##(Smalltalk.ScaledDecimal)  524806 ##(Smalltalk.Fraction)  7 5 3 16 234 256 98 4 410 5088 98 30 0 4944 98 2 8 1140920393 1025 6672 786 202 208 832 0 864 482 5200 0 7 5218 0 16 98 1 5266 1 4082 8 #removeFromImportList 8 '&Remove from list' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 6672 0 8 4294904481 5362 1040 98 0 5408 5440 0 0 0 0 0 0 202 208 98 5 5490 8 'Comparison' 401 5536 5362 1040 6928 5568 930 0 0 5602 3 1 928 8 'doIt' 8 '[:each | each first displayString]' 8 #[31 105 226 0 159 106] 5680 1040 7024 7 257 0 0 6672 0 1 0 0 5490 8 'Comment/description' 401 5536 5362 1040 98 0 5362 5776 7152 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 2) displayString]' 8 #[30 105 17 64 148 158 106] 1040 7184 7 257 0 0 6672 0 1 0 0 5490 8 'Developer' 201 5536 5362 1040 7152 5362 5776 7152 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 3) displayString]' 8 #[30 105 17 214 3 148 158 106] 1040 7328 7 257 0 0 6672 0 1 0 0 5490 8 'Timestamp' 241 5536 5362 1040 7152 5362 5776 7152 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 4) displayString]' 8 #[30 105 17 214 4 148 158 106] 1040 7472 7 257 0 0 6672 0 1 0 0 5490 8 'Blessing' 191 5536 5362 1040 7152 5362 5776 7152 930 0 0 5602 2 1 928 8 'doIt' 8 '[:each | (each at: 5) displayString]' 8 #[30 105 17 214 5 148 158 106] 1040 7616 7 257 0 0 6672 0 1 0 0 6304 832 0 131169 0 0 1058 202 208 98 3 1122 1152 98 2 1186 1 489 1186 1477 321 6672 1122 6448 98 1 6784 6672 1122 2656 98 1 8 'Comparison' 6672 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 244 0 0 0 226 2 0 0 148 1 0 0] 98 0 1296 0 27 8 'listChangeSetsForImport' 5072 8 'listChangeSetsOnServer' 0 1058 202 208 98 2 1122 1152 98 2 1186 1 121 1186 1477 809 4944 1122 2656 98 1 8 'Lists' 4944 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 226 2 0 0 208 1 0 0] 98 3 5072 410 8 ##(Smalltalk.Splitter)  98 12 0 4944 98 2 8 1140850688 1 8176 0 482 8 4278190080 0 519 0 0 0 8176 1058 202 208 98 1 1122 1152 98 2 1186 1 479 1186 1477 11 8176 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 239 0 0 0 226 2 0 0 244 0 0 0] 98 0 1296 0 27 6672 1296 0 27 4770 4816 -19 4848 21 4802 8 #fixedPreviousBottom 1 4802 8 #relativeParentHeight 6610 451 483 410 608 98 15 0 416 98 2 8 1140850688 131073 8544 0 0 0 519 0 0 0 8544 0 234 256 832 0 1058 202 208 98 2 1122 1152 98 2 1186 1 929 1186 1477 67 8544 1122 2656 98 1 8 'ImportButtons' 8544 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 208 1 0 0 226 2 0 0 241 1 0 0] 98 2 410 4000 98 20 0 8544 98 2 8 1140924416 1 8832 0 0 0 7 0 0 0 8832 0 8 4294904159 4082 6848 8 '&Remove from list' 1 1 0 0 32 0 0 0 1058 202 208 98 3 1122 1152 98 2 1186 1169 9 1186 181 51 8832 1122 4272 98 1 32 8832 1122 2656 98 1 8 '&Remove from list' 8832 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 2 0 0 4 0 0 0 162 2 0 0 29 0 0 0] 98 0 1296 0 29 410 4000 98 20 0 8544 98 2 8 1140924416 1 9184 0 0 0 7 0 0 0 9184 0 8 4294904159 4082 8 #importAll 8 '&Import all' 1 1 0 0 16 0 0 0 1058 202 208 98 3 1122 1152 98 2 1186 11 11 1186 161 51 9184 1122 4272 98 1 32 9184 1122 2656 98 1 8 '&Import all' 9184 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 85 0 0 0 30 0 0 0] 98 0 1296 0 29 1296 0 27 4770 4816 -19 4848 21 8464 1 4802 8 #fixedParentBottom 1 234 256 832 590342 ##(Smalltalk.Rectangle)  1186 21 21 1186 21 21 0 0 0 0 42429 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 32 8 2010572119 1058 202 208 98 3 1122 1152 98 2 1186 3359 21 1186 1501 1091 416 1122 2656 98 1 8 'Select Change Sets to import' 416 1122 8 #updateMenuBar 832 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 243 5 0 0 10 0 0 0 225 8 0 0 43 2 0 0] 98 3 592 4944 8544 1296 0 27 )! !
!StsServerImportChangeSetsBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !

