"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #StsImportInformationDialog
	instanceVariableNames: 'versionPresenter developerPresenter previousVersionsPresenter commentPresenter versionCommentPresenter blessingLevelsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsImportInformationDialog guid: (GUID fromString: '{5142405C-A6D0-4A2C-8867-466CC5BFD895}')!
StsImportInformationDialog comment: ''!
!StsImportInformationDialog categoriesForClass!Unclassified! !
!StsImportInformationDialog methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	versionPresenter := self add: TextPresenter new name: 'version'.
	developerPresenter := self add: TextPresenter new name: 'developer'.
	previousVersionsPresenter := self add: ListPresenter new name: 'previousVersions'.
	blessingLevelsPresenter := self add: ListPresenter new name: 'blessingLevels'.
	commentPresenter := self add: TextPresenter new name: 'comment'.
	versionCommentPresenter := self add: TextPresenter new name: 'versionComment'!

model: aStsImportInformationModel 
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aStsImportInformationModel.
	aspectBuffer := self model.
	versionPresenter model: (aspectBuffer aspectValue: #version).
	developerPresenter model: (aspectBuffer aspectValue: #developer).
	previousVersionsPresenter model: aStsImportInformationModel previousVersions.
	blessingLevelsPresenter model: aStsImportInformationModel blessingLevels.
	commentPresenter model: (aspectBuffer aspectValue: #comment).
	versionCommentPresenter model: (aspectBuffer aspectValue: #versionComment)!

ok
	| m |
	(m := self model) version trimBlanks isEmpty 
		ifTrue: [^MessageBox errorMsg: 'The package version is empty'].
	previousVersionsPresenter model isNil 
		ifFalse: 
			[(previousVersionsPresenter model 
				findFirst: [:edition | edition notNil and: [edition versionDescriptor = m version]]) > 0 
				ifTrue: [^MessageBox errorMsg: 'The package version exists in the repository']].
	m developer trimBlanks isEmpty ifTrue: [^MessageBox errorMsg: 'The developer is empty'].
	self apply.
	(m subject)
		previousEdition: previousVersionsPresenter selectionOrNil;
		blessing: blessingLevelsPresenter selectionOrNil.
	^super ok!

onViewOpened
	| selectionIndex previousEdition |
	super onViewOpened.
	"If a previous edition has been specified then select it and disable the version selector."
	self model previousVersions isNil 
		ifTrue: [previousVersionsPresenter view disable]
		ifFalse: 
			[(previousEdition := self model previousEdition) isNil 
				ifFalse: 
					[selectionIndex := previousVersionsPresenter list findFirst: 
									[:packageEdition | 
									packageEdition notNil and: [packageEdition versionDescriptor = previousEdition versionDescriptor]].
					previousVersionsPresenter view disable].
			selectionIndex 
				ifNil: 
					["Otherwise default to the latest version (if any)."
					selectionIndex := previousVersionsPresenter list size min: 2].
			previousVersionsPresenter selectionByIndex: selectionIndex].
	blessingLevelsPresenter selection: (self model blessing ifNil: [#development])! !
!StsImportInformationDialog categoriesFor: #createComponents!initializing!private! !
!StsImportInformationDialog categoriesFor: #model:!accessing!public! !
!StsImportInformationDialog categoriesFor: #ok!public! !
!StsImportInformationDialog categoriesFor: #onViewOpened!public! !

!StsImportInformationDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^StsImportInformationModel new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 0 234 256 98 12 410 8 ##(Smalltalk.ComboBox)  98 17 0 416 98 2 8 1144063491 1025 560 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 560 0 8 4294902367 8 ##(Smalltalk.BasicListAbstract)  688 401 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  221 191 914 571 53 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 95 0 0 0 139 1 0 0 121 0 0 0] 98 0 914 193 193 0 27 8 'blessingLevels' 410 8 ##(Smalltalk.RichTextEdit)  98 18 0 416 98 2 8 1140920644 1025 1056 0 482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1202 1 1234 8 #bePlain 8 '&Plain' 1 1 0 0 0 1202 1 1234 8 #toggleBold 8 '&Bold' 1 1 0 0 0 1202 1 1234 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 1202 1 1234 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 1298 4097 1154 0 16 98 3 1202 1025 1234 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 1202 1025 1234 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 1202 1025 1234 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 1298 4097 1202 1 1234 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1056 0 8 1571848960 852486 ##(Smalltalk.NullConverter)  0 0 9 0 655622 ##(Smalltalk.EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 64 0 62 3] 786 202 208 98 6 850 880 98 2 914 25 289 914 771 221 1056 850 8 #contextMenu: 98 1 1168 1056 850 8 #text: 98 1 524550 ##(Smalltalk.RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 1056 850 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1056 850 8 #isTextModified: 98 1 32 1056 850 8 #resetCharFormat 688 1056 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 144 0 0 0 141 1 0 0 254 0 0 0] 98 0 1024 0 27 8 'versionComment' 410 1072 98 18 0 416 98 2 8 1140920644 1025 2512 0 482 512 0 7 1154 0 16 98 10 1202 1 1234 1264 1280 1 1 0 0 0 1298 4097 1202 1 1234 1360 1376 1 1 0 0 0 1202 1 1234 1424 1440 1 1 0 0 0 1202 1 1234 1488 1504 1 1 0 0 0 1202 1 1234 1552 1568 1 1 0 0 0 1298 4097 1154 0 16 98 3 1202 1025 1234 1664 1680 1 1 0 0 0 1202 1025 1234 1728 1744 1 1 0 0 0 1202 1025 1234 1792 1808 1 1 0 0 0 1824 0 1 0 0 0 0 0 1298 4097 1202 1 1234 1888 1904 1 1 0 0 0 1920 0 1 0 0 0 0 0 0 0 2512 0 8 1571848960 1954 0 0 9 0 1986 2016 786 202 208 98 6 850 880 98 2 914 25 559 914 771 221 2512 850 2160 98 1 2592 2512 850 2208 98 1 2242 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 2512 850 2304 98 1 2338 3 1 3 2512 850 2384 98 1 32 2512 850 2432 688 2512 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 23 1 0 0 141 1 0 0 133 1 0 0] 98 0 1024 0 27 8 'comment' 410 8 ##(Smalltalk.TextEdit)  98 16 0 416 98 2 8 1140916352 1025 3408 0 482 512 0 7 0 0 0 3408 0 8 4294903263 1954 0 0 1 786 202 208 98 3 850 880 98 2 914 221 11 914 571 51 3408 850 2304 98 1 2338 3 1 3 3408 850 2384 98 1 32 3408 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 5 0 0 0 139 1 0 0 30 0 0 0] 98 0 1024 0 27 8 'version' 410 3424 98 16 0 416 98 2 8 1140916352 1025 3792 0 482 512 0 7 0 0 0 3792 0 8 4294903263 1954 0 0 1 786 202 208 98 3 850 880 98 2 914 221 71 914 571 51 3792 850 2304 98 1 2338 3 1 3 3792 850 2384 98 1 32 3792 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 35 0 0 0 139 1 0 0 60 0 0 0] 98 0 1024 0 27 8 'developer' 410 576 98 17 0 416 98 2 8 1144063491 1025 4160 642 202 208 688 0 720 482 512 0 7 0 0 0 4160 0 8 4294902367 768 688 401 786 202 208 98 1 850 880 98 2 914 221 131 914 571 53 4160 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 65 0 0 0 139 1 0 0 91 0 0 0] 98 0 1024 0 27 8 'previousVersions' 0 0 0 0 0 8981 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1996696576 786 202 208 98 3 850 880 98 2 914 5119 21 914 851 951 416 850 2208 98 1 8 'Versioning project/package' 416 850 8 #updateMenuBar 688 416 962 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 168 11 0 0 229 1 0 0] 98 14 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850946 1 4752 0 0 0 7 0 0 0 4752 0 8 4294902411 1954 0 0 0 786 202 208 98 2 850 880 98 2 914 71 11 914 131 41 4752 850 2208 98 1 8 'Version:' 4752 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 5 0 0 0 100 0 0 0 25 0 0 0] 98 0 1024 0 27 3408 410 4768 98 16 0 416 98 2 8 1140850946 1 5072 0 0 0 7 0 0 0 5072 0 8 4294902411 1954 0 0 0 786 202 208 98 2 850 880 98 2 914 31 71 914 171 41 5072 850 2208 98 1 8 'Developer:' 5072 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 35 0 0 0 100 0 0 0 55 0 0 0] 98 0 1024 0 27 3792 410 4768 98 16 0 416 98 2 8 1140850946 1 5376 0 0 0 7 0 0 0 5376 0 8 4294902411 1954 0 0 0 786 202 208 98 2 850 880 98 2 914 7 131 914 195 41 5376 850 2208 98 1 8 'Prior version:' 5376 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 65 0 0 0 100 0 0 0 85 0 0 0] 98 0 1024 0 27 4160 410 4768 98 16 0 416 98 2 8 1140850946 1 5680 0 0 0 7 0 0 0 5680 0 8 4294902411 1954 0 0 0 786 202 208 98 2 850 880 98 2 914 51 189 914 151 41 5680 850 2208 98 1 8 'Blessing:' 5680 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 94 0 0 0 100 0 0 0 114 0 0 0] 98 0 1024 0 27 560 410 4768 98 16 0 416 98 2 8 1140850944 1 5984 0 0 0 7 0 0 0 5984 0 8 4294902411 1954 0 0 0 786 202 208 98 2 850 880 98 2 914 41 521 914 241 31 5984 850 2208 98 1 8 'Comment:' 5984 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 4 1 0 0 140 0 0 0 19 1 0 0] 98 0 1024 0 27 2512 410 4768 98 16 0 416 98 2 8 1140850944 1 6288 0 0 0 7 0 0 0 6288 0 8 4294902411 1954 0 0 0 786 202 208 98 2 850 880 98 2 914 31 251 914 301 31 6288 850 2208 98 1 8 'Version comment:' 6288 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 125 0 0 0 165 0 0 0 140 0 0 0] 98 0 1024 0 27 1056 410 8 ##(Smalltalk.PushButton)  98 20 0 416 98 2 8 1140924416 1 6592 0 482 512 0 7 0 0 0 6592 0 8 4294903191 1234 8 #ok 8 '&OK' 1 1 0 0 16 0 0 0 786 202 208 98 3 850 880 98 2 914 421 801 914 171 55 6592 850 8 #isEnabled: 98 1 32 6592 850 2208 98 1 8 '&OK' 6592 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 144 1 0 0 39 1 0 0 171 1 0 0] 98 0 1024 0 29 410 6608 98 20 0 416 98 2 8 1140924416 1 7008 0 482 512 0 7 0 0 0 7008 0 8 4294903191 1234 8 #cancel 8 '&Cancel' 1 1 0 0 32 0 0 0 786 202 208 98 2 850 880 98 2 914 621 801 914 171 55 7008 850 2208 98 1 8 '&Cancel' 7008 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 144 1 0 0 139 1 0 0 171 1 0 0] 98 0 1024 0 29 1024 0 27 )! !
!StsImportInformationDialog class categoriesFor: #defaultModel!public! !
!StsImportInformationDialog class categoriesFor: #resource_Default_view!public!resources-views! !

