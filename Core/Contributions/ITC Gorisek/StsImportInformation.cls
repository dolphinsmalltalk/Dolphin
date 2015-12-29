"Filed out from Dolphin Smalltalk X6.1"!

Dialog subclass: #StsImportInformation
	instanceVariableNames: 'versionPresenter developerPresenter previousVersionsPresenter commentPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsImportInformation guid: (GUID fromString: '{4359DC0C-99A3-40BC-993C-0F8509F75844}')!
StsImportInformation comment: ''!
!StsImportInformation categoriesForClass!Unclassified! !
!StsImportInformation methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	versionPresenter := self add: TextPresenter new name: 'version'.
	developerPresenter := self add: TextPresenter new name: 'developer'.
	previousVersionsPresenter := self add: ListPresenter new name: 'previousVersions'.
	commentPresenter := self add: TextPresenter new name: 'comment'.!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"
	
	super createSchematicWiring.!

model: aStsImportInformationModel
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aStsImportInformationModel.

	aspectBuffer := self model.

	versionPresenter model: (aspectBuffer aspectValue: #version).
	developerPresenter model: (aspectBuffer aspectValue: #developer).
	previousVersionsPresenter model: aStsImportInformationModel previousVersions.
	commentPresenter model: (aspectBuffer aspectValue: #comment).!

ok

	self model version trimBlanks isEmpty
		ifTrue: [ ^MessageBox errorMsg: 'The package version is empty' ].

	(previousVersionsPresenter model findFirst: [ :edition | edition notNil and: [ edition versionDescriptor = self model version]  ]) > 0
		ifTrue: [ ^MessageBox errorMsg: 'The package version exists in the repository'  ].

	self model developer trimBlanks isEmpty
		ifTrue: [ ^MessageBox errorMsg: 'The developer is empty' ].

	self apply.
	self model subject previousEdition: previousVersionsPresenter selectionOrNil.
	^super ok.!

onViewOpened
	| selectionIndex previousEdition |
	super onViewOpened.

	"If a previous edition has been specified then select it and disable the version selector"
	previousEdition := self model previousEdition.
	previousEdition notNil 
		ifTrue: 
			[selectionIndex := previousVersionsPresenter list findFirst: 
							[:packageEdition | 
							packageEdition notNil and: [packageEdition versionDescriptor = previousEdition versionDescriptor]].
			previousVersionsPresenter view disable].
	selectionIndex 
		ifNil: 
			["Otherwise default to the latest version (if any)"
			selectionIndex := previousVersionsPresenter list size min: 2].
	previousVersionsPresenter selectionByIndex: selectionIndex! !
!StsImportInformation categoriesFor: #createComponents!initializing!private! !
!StsImportInformation categoriesFor: #createSchematicWiring!initializing!private! !
!StsImportInformation categoriesFor: #model:!accessing!public! !
!StsImportInformation categoriesFor: #ok!public! !
!StsImportInformation categoriesFor: #onViewOpened!public! !

!StsImportInformation class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^StsImportInformationModel new.!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 0 0 416 0 234 256 98 8 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140916352 1025 560 0 482 512 0 5 0 0 0 560 0 8 4294904001 852486 ##(NullConverter)  0 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  251 21 834 571 51 560 770 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 560 770 8 #isTextModified: 98 1 32 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 125 0 0 0 10 0 0 0 154 1 0 0 35 0 0 0] 98 0 834 193 193 0 27 8 'version' 410 576 98 16 0 416 98 2 8 1140916352 1025 1104 0 482 512 0 5 0 0 0 1104 0 8 4294904001 674 0 0 1 706 202 208 98 3 770 800 98 2 834 251 91 834 571 51 1104 770 896 98 1 930 3 1 3 1104 770 976 98 1 32 1104 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 125 0 0 0 45 0 0 0 154 1 0 0 70 0 0 0] 98 0 1072 0 27 8 'developer' 410 8 ##(ComboBox)  98 17 0 416 98 2 8 1144063491 1025 1472 590662 2 ##(ListModel)  202 208 98 0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 482 512 0 5 0 0 0 1472 0 8 4294904195 8 ##(BasicListAbstract)  1600 401 706 202 208 98 1 770 800 98 2 834 251 161 834 571 43 1472 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 125 0 0 0 80 0 0 0 154 1 0 0 101 0 0 0] 98 0 1072 0 27 8 'previousVersions' 410 8 ##(RichTextEdit)  98 18 0 416 98 2 8 1140920644 1025 1904 0 482 512 0 5 265030 4 ##(Menu)  0 16 98 10 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(DividerMenuItem)  4097 2050 1 2082 8 #bePlain 8 '&Plain' 1 1 0 0 0 2050 1 2082 8 #toggleBold 8 '&Bold' 1 1 0 0 0 2050 1 2082 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 2050 1 2082 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 2146 4097 2002 0 16 98 3 2050 1025 2082 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 2050 1025 2082 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 2050 1025 2082 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 2146 4097 2050 1 2082 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1904 0 8 1961167625 674 0 0 9 0 655622 ##(EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 16 250 149 14] 706 202 208 98 6 770 800 98 2 834 21 281 834 801 231 1904 770 8 #contextMenu: 98 1 2016 1904 770 8 #text: 98 1 524550 ##(RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 1904 770 896 98 1 930 3 1 3 1904 770 976 98 1 32 1904 770 8 #resetCharFormat 1600 1904 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 140 0 0 0 154 1 0 0 255 0 0 0] 98 0 1072 0 27 8 'comment' 0 0 0 0 0 8441 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 3 770 800 98 2 834 1175 875 834 851 651 416 770 3040 98 1 8 'Importing package' 416 770 8 #menuBar: 98 1 0 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 2 0 0 181 1 0 0 244 3 0 0 250 2 0 0] 98 10 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 3600 0 0 0 5 0 0 0 3600 0 8 4294903689 674 0 0 0 706 202 208 98 2 770 800 98 2 834 11 21 834 201 51 3600 770 3040 98 1 8 'Package version:' 3600 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 105 0 0 0 35 0 0 0] 98 0 1072 0 27 560 410 3616 98 16 0 416 98 2 8 1140850944 1 3920 0 0 0 5 0 0 0 3920 0 8 4294903689 674 0 0 0 706 202 208 98 2 770 800 98 2 834 11 91 834 241 51 3920 770 3040 98 1 8 'Package developer:' 3920 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 45 0 0 0 125 0 0 0 70 0 0 0] 98 0 1072 0 27 1104 410 3616 98 16 0 416 98 2 8 1140850944 1 4224 0 0 0 5 0 0 0 4224 0 8 4294903689 674 0 0 0 706 202 208 98 2 770 800 98 2 834 11 161 834 211 51 4224 770 3040 98 1 8 'Previous version:' 4224 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 80 0 0 0 110 0 0 0 105 0 0 0] 98 0 1072 0 27 1472 1904 410 3616 98 16 0 416 98 2 8 1140850944 1 4528 0 0 0 5 0 0 0 4528 0 8 4294903689 674 0 0 0 706 202 208 98 2 770 800 98 2 834 11 231 834 241 61 4528 770 3040 98 1 8 'Version comment:' 4528 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 115 0 0 0 125 0 0 0 145 0 0 0] 98 0 1072 0 27 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 4832 0 482 512 0 5 0 0 0 4832 0 8 4294904349 2082 8 #ok 8 '&OK' 1 1 0 0 16 706 202 208 98 3 770 800 98 2 834 451 531 834 171 55 4832 770 8 #isEnabled: 98 1 32 4832 770 3040 98 1 8 '&OK' 4832 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 225 0 0 0 9 1 0 0 54 1 0 0 36 1 0 0] 98 0 1072 0 27 410 4848 98 17 0 416 98 2 8 1140924416 1 5248 0 482 512 0 5 0 0 0 5248 0 8 4294904349 2082 8 #cancel 8 '&Cancel' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 651 531 834 171 55 5248 770 5120 98 1 32 5248 770 3040 98 1 8 '&Cancel' 5248 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 69 1 0 0 9 1 0 0 154 1 0 0 36 1 0 0] 98 0 1072 0 27 1072 0 27 )!

resource_Version_package
	"Answer the literal data from which the 'Version package' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Version_package)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 0 0 416 0 234 256 98 8 410 8 ##(RichTextEdit)  98 18 0 416 98 2 8 1140920644 1025 560 0 482 512 0 5 265030 4 ##(Menu)  0 16 98 10 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(DividerMenuItem)  4097 706 1 738 8 #bePlain 8 '&Plain' 1 1 0 0 0 706 1 738 8 #toggleBold 8 '&Bold' 1 1 0 0 0 706 1 738 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 706 1 738 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 802 4097 658 0 16 98 3 706 1025 738 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 706 1025 738 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 706 1025 738 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 802 4097 706 1 738 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 560 0 8 1961167625 852486 ##(NullConverter)  0 0 9 0 655622 ##(EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 48 15 154 20] 983302 ##(MessageSequence)  202 208 98 6 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  21 281 1666 801 231 560 1602 8 #contextMenu: 98 1 672 560 1602 8 #text: 98 1 524550 ##(RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 560 1602 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 560 1602 8 #isTextModified: 98 1 32 560 1602 8 #resetCharFormat 98 0 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 140 0 0 0 154 1 0 0 255 0 0 0] 98 0 1666 193 193 0 27 8 'comment' 410 8 ##(ComboBox)  98 17 0 416 98 2 8 1144063491 1025 2128 590662 2 ##(ListModel)  202 208 2016 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 482 512 0 5 0 0 0 2128 0 8 4294904195 8 ##(BasicListAbstract)  2016 401 1538 202 208 98 1 1602 1632 98 2 1666 251 161 1666 571 43 2128 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 125 0 0 0 80 0 0 0 154 1 0 0 101 0 0 0] 98 0 2096 0 27 8 'previousVersions' 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140850816 1025 2544 0 482 512 0 5 0 0 0 2544 0 8 4294904001 1458 0 0 3 1538 202 208 98 3 1602 1632 98 2 1666 251 91 1666 571 51 2544 1602 1872 98 1 1906 3 1 3 2544 1602 1952 98 1 32 2544 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 125 0 0 0 45 0 0 0 154 1 0 0 70 0 0 0] 98 0 2096 0 27 8 'developer' 410 2560 98 16 0 416 98 2 8 1140916352 1025 2928 0 482 512 0 5 0 0 0 2928 0 8 4294904001 1458 0 0 1 1538 202 208 98 3 1602 1632 98 2 1666 251 21 1666 571 51 2928 1602 1872 98 1 1906 3 1 3 2928 1602 1952 98 1 32 2928 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 125 0 0 0 10 0 0 0 154 1 0 0 35 0 0 0] 98 0 2096 0 27 8 'version' 0 0 0 0 0 8459 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 1538 202 208 98 3 1602 1632 98 2 1666 1175 875 1666 851 651 416 1602 1776 98 1 8 'Versioning package' 416 1602 8 #menuBar: 98 1 0 416 2034 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 2 0 0 181 1 0 0 244 3 0 0 250 2 0 0] 98 10 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 3600 0 0 0 5 0 0 0 3600 0 8 4294903689 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 11 21 1666 201 51 3600 1602 1776 98 1 8 'Package version:' 3600 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 105 0 0 0 35 0 0 0] 98 0 2096 0 27 2928 410 3616 98 16 0 416 98 2 8 1140850944 1 3920 0 0 0 5 0 0 0 3920 0 8 4294903689 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 11 91 1666 241 51 3920 1602 1776 98 1 8 'Package developer:' 3920 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 45 0 0 0 125 0 0 0 70 0 0 0] 98 0 2096 0 27 2544 410 3616 98 16 0 416 98 2 8 1140850944 1 4224 0 0 0 5 0 0 0 4224 0 8 4294903689 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 11 161 1666 211 51 4224 1602 1776 98 1 8 'Previous version:' 4224 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 80 0 0 0 110 0 0 0 105 0 0 0] 98 0 2096 0 27 2128 560 410 3616 98 16 0 416 98 2 8 1140850944 1 4528 0 0 0 5 0 0 0 4528 0 8 4294903689 1458 0 0 0 1538 202 208 98 2 1602 1632 98 2 1666 11 231 1666 241 61 4528 1602 1776 98 1 8 'Version comment:' 4528 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 115 0 0 0 125 0 0 0 145 0 0 0] 98 0 2096 0 27 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 4832 0 482 512 0 5 0 0 0 4832 0 8 4294904349 738 8 #ok 8 '&OK' 1 1 0 0 16 1538 202 208 98 3 1602 1632 98 2 1666 451 531 1666 171 55 4832 1602 8 #isEnabled: 98 1 32 4832 1602 1776 98 1 8 '&OK' 4832 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 225 0 0 0 9 1 0 0 54 1 0 0 36 1 0 0] 98 0 2096 0 27 410 4848 98 17 0 416 98 2 8 1140924416 1 5248 0 482 512 0 5 0 0 0 5248 0 8 4294904349 738 8 #cancel 8 '&Cancel' 1 1 0 0 32 1538 202 208 98 3 1602 1632 98 2 1666 651 531 1666 171 55 5248 1602 5120 98 1 32 5248 1602 1776 98 1 8 '&Cancel' 5248 2034 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 69 1 0 0 9 1 0 0 154 1 0 0 36 1 0 0] 98 0 2096 0 27 2096 0 27 )! !
!StsImportInformation class categoriesFor: #defaultModel!public! !
!StsImportInformation class categoriesFor: #resource_Default_view!public!resources-views! !
!StsImportInformation class categoriesFor: #resource_Version_package!public!resources-views! !

