"Filed out from Dolphin Smalltalk X6.2"!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 0 234 256 98 12 410 8 ##(Smalltalk.RichTextEdit)  98 18 0 416 98 2 8 1140920644 1025 560 0 482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 706 1 738 8 #bePlain 8 '&Plain' 1 1 0 0 0 706 1 738 8 #toggleBold 8 '&Bold' 1 1 0 0 0 706 1 738 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 706 1 738 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 802 4097 658 0 16 98 3 706 1025 738 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 706 1025 738 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 706 1025 738 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 802 4097 706 1 738 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 560 0 8 1794918949 852486 ##(Smalltalk.NullConverter)  0 0 9 0 655622 ##(Smalltalk.EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 64 0 45 2] 983302 ##(Smalltalk.MessageSequence)  202 208 98 6 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  21 281 1666 771 231 560 1602 8 #contextMenu: 98 1 672 560 1602 8 #text: 98 1 524550 ##(Smalltalk.RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 560 1602 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 560 1602 8 #isTextModified: 98 1 32 560 1602 8 #resetCharFormat 98 0 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 140 0 0 0 139 1 0 0 255 0 0 0] 98 0 1666 193 193 0 27 8 'versionComment' 410 576 98 18 0 416 98 2 8 1140920644 1025 2128 0 482 512 0 7 658 0 16 98 10 706 1 738 768 784 1 1 0 0 0 802 4097 706 1 738 864 880 1 1 0 0 0 706 1 738 928 944 1 1 0 0 0 706 1 738 992 1008 1 1 0 0 0 706 1 738 1056 1072 1 1 0 0 0 802 4097 658 0 16 98 3 706 1025 738 1168 1184 1 1 0 0 0 706 1025 738 1232 1248 1 1 0 0 0 706 1025 738 1296 1312 1 1 0 0 0 1328 0 1 0 0 0 0 0 802 4097 706 1 738 1392 1408 1 1 0 0 0 1424 0 1 0 0 0 0 0 0 0 2128 0 8 1794918949 1458 0 0 9 0 1490 1520 1538 202 208 98 6 1602 1632 98 2 1666 21 551 1666 771 231 2128 1602 1728 98 1 2208 2128 1602 1776 98 1 1810 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 2128 1602 1872 98 1 1906 3 1 3 2128 1602 1952 98 1 32 2128 1602 2000 2016 2128 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 19 1 0 0 139 1 0 0 134 1 0 0] 98 0 2096 0 27 8 'comment' 410 8 ##(Smalltalk.TextEdit)  98 16 0 416 98 2 8 1140916352 1025 3024 0 482 512 0 7 0 0 0 3024 0 8 4294903197 1458 0 0 1 1538 202 208 98 3 1602 1632 98 2 1666 221 71 1666 571 51 3024 1602 1872 98 1 1906 3 1 3 3024 1602 1952 98 1 32 3024 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 35 0 0 0 139 1 0 0 60 0 0 0] 98 0 2096 0 27 8 'developer' 410 3040 98 16 0 416 98 2 8 1140916352 1025 3408 0 482 512 0 7 0 0 0 3408 0 8 4294903197 1458 0 0 1 1538 202 208 98 3 1602 1632 98 2 1666 221 11 1666 571 51 3408 1602 1872 98 1 1906 3 1 3 3408 1602 1952 98 1 32 3408 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 5 0 0 0 139 1 0 0 30 0 0 0] 98 0 2096 0 27 8 'version' 410 8 ##(Smalltalk.ComboBox)  98 17 0 416 98 2 8 1144063491 1025 3776 590662 2 ##(Smalltalk.ListModel)  202 208 2016 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 3776 0 8 4294903589 8 ##(Smalltalk.BasicListAbstract)  2016 401 1538 202 208 98 1 1602 1632 98 2 1666 221 191 1666 571 47 3776 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 95 0 0 0 139 1 0 0 118 0 0 0] 98 0 2096 0 27 8 'blessingLevels' 410 3792 98 17 0 416 98 2 8 1144063491 1025 4160 3858 202 208 2016 0 3920 482 512 0 7 0 0 0 4160 0 8 4294903589 3968 2016 401 1538 202 208 98 1 1602 1632 98 2 1666 221 131 1666 571 47 4160 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 65 0 0 0 139 1 0 0 88 0 0 0] 98 0 2096 0 27 8 'previousVersions' 0 0 0 0 0 11273 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1991911096 1538 202 208 98 3 1602 1632 98 2 1666 2559 21 1666 851 921 416 1602 1776 98 1 8 'Versioning project/package' 416 1602 8 #updateMenuBar 2016 416 2034 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 10 0 0 0 168 6 0 0 214 1 0 0] 98 14 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850946 1 4752 0 0 0 7 0 0 0 4752 0 8 4294903729 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 71 11 1666 131 31 4752 1602 1776 98 1 8 'Version:' 4752 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 5 0 0 0 100 0 0 0 20 0 0 0] 98 0 2096 0 27 3408 410 4768 98 16 0 416 98 2 8 1140850946 1 5072 0 0 0 7 0 0 0 5072 0 8 4294903729 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 31 71 1666 171 31 5072 1602 1776 98 1 8 'Developer:' 5072 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 35 0 0 0 100 0 0 0 50 0 0 0] 98 0 2096 0 27 3024 410 4768 98 16 0 416 98 2 8 1140850946 1 5376 0 0 0 7 0 0 0 5376 0 8 4294903729 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 7 131 1666 195 31 5376 1602 1776 98 1 8 'Previous version:' 5376 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 0 65 0 0 0 100 0 0 0 80 0 0 0] 98 0 2096 0 27 4160 410 4768 98 16 0 416 98 2 8 1140850946 1 5680 0 0 0 7 0 0 0 5680 0 8 4294903729 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 51 191 1666 151 31 5680 1602 1776 98 1 8 'Blessing:' 5680 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 95 0 0 0 100 0 0 0 110 0 0 0] 98 0 2096 0 27 3776 410 4768 98 16 0 416 98 2 8 1140850944 1 5984 0 0 0 7 0 0 0 5984 0 8 4294903729 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 41 521 1666 241 31 5984 1602 1776 98 1 8 'Comment:' 5984 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 4 1 0 0 140 0 0 0 19 1 0 0] 98 0 2096 0 27 2128 410 4768 98 16 0 416 98 2 8 1140850944 1 6288 0 0 0 7 0 0 0 6288 0 8 4294903729 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 31 251 1666 301 31 6288 1602 1776 98 1 8 'Version comment:' 6288 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 125 0 0 0 165 0 0 0 140 0 0 0] 98 0 2096 0 27 560 410 8 ##(Smalltalk.PushButton)  98 20 0 416 98 2 8 1140924416 1 6592 0 482 512 0 7 0 0 0 6592 0 8 4294903141 738 8 #ok 8 '&OK' 1 1 0 0 16 0 0 0 1538 202 208 98 3 1602 1632 98 2 1666 421 801 1666 171 55 6592 1602 8 #isEnabled: 98 1 32 6592 1602 1776 98 1 8 '&OK' 6592 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 144 1 0 0 39 1 0 0 171 1 0 0] 98 0 2096 0 29 410 6608 98 20 0 416 98 2 8 1140924416 1 7008 0 482 512 0 7 0 0 0 7008 0 8 4294903141 738 8 #cancel 8 '&Cancel' 1 1 0 0 32 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 621 801 1666 171 55 7008 1602 1776 98 1 8 '&Cancel' 7008 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 144 1 0 0 139 1 0 0 171 1 0 0] 98 0 2096 0 29 2096 0 27 )! !
!StsImportInformationDialog class categoriesFor: #defaultModel!public! !
!StsImportInformationDialog class categoriesFor: #resource_Default_view!public!resources-views! !

