"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsClassEditionsBrowserShell
	instanceVariableNames: 'className editionsPresenter modePresenter sourcePresenter commentPresenter definitionPresenter methodsPresenter versionInfoPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsClassEditionsBrowserShell guid: (GUID fromString: '{7610fbd2-232e-11d4-b0c2-000000000000}')!
StsClassEditionsBrowserShell comment: 'This shell is used to browse class editions in the repository.'!
!StsClassEditionsBrowserShell categoriesForClass!Unclassified! !
!StsClassEditionsBrowserShell methodsFor!

createComponents
	super createComponents.
	editionsPresenter := self 
				add: ListPresenter new
				name: 'classEditions'
				helpId: 10977.
	sourcePresenter := self add: SmalltalkWorkspace new name: 'source'.
	definitionPresenter := self add: SmalltalkWorkspace new name: 'definition'.
	commentPresenter := self add: SmalltalkWorkspace new name: 'comment'.
	modePresenter := self add: RadioButtonSetPresenter new name: 'mode'.
	methodsPresenter := self 
				add: ListPresenter new
				name: 'methods'
				helpId: 10978.
	versionInfoPresenter := self add: TextPresenter new name: 'versionInformation'!

createSchematicWiring
	super createSchematicWiring.
	editionsPresenter 
		when: #selectionChanged
		send: #onEditionOrModeSelected
		to: self.
	modePresenter 
		when: #valueChanged
		send: #onEditionOrModeSelected
		to: self.
	methodsPresenter 
		when: #selectionChanged
		send: #onMethodSelected
		to: self!

defaultHelpId
	^10898!

isInstanceMode
	"Private - Answer true if the receiver is in instance mode"

	^modePresenter value = #instanceMode!

isInstanceMode: aBoolean 
	"Private - Set the receiver into class mode, i.e. displaying the class methods
	on the selected class."

	modePresenter value: (aBoolean ifTrue: [#instanceMode] ifFalse: [#classMode])!

menuBrowseMethodEditions
	| edition |
	edition := methodsPresenter selectionOrNil.
	self sourceControl browseMethodEditions: edition selector class: edition classSymbol!

menuCompareClassEditions
	| changes edition1 edition2 |
	changes := OrderedCollection new.
	edition1 := editionsPresenter selectionOrNil first.
	edition2 := editionsPresenter selectionOrNil last.
	edition1 compareWith: edition2 on: changes.
	(StsComparisonBrowser create)
		setChanges: changes;
		caption: 'Changes Browser - ' , edition1 name , ': Version ' , edition1 displayString 
					, ' vs Version ' , edition2 displayString;
		showShell!

menuLoadClassEdition
	self selectedEdition load!

menuLoadMethodEdition
	methodsPresenter selectionOrNil load!

menuUpdateClassEditionsList
	| edition |
	edition := self selectedEdition.
	self refresh.
	edition notNil ifTrue: [self selectEdition: edition]!

onEditionOrModeSelected
	| edition realClass definition methods comment |
	(edition := self selectedEdition) isNil 
		ifTrue: 
			[comment := ''.
			definition := ''.
			methods := Array new]
		ifFalse: 
			[comment := edition comment.
			realClass := edition realClass.
			self isInstanceMode 
				ifTrue: 
					[definition := edition definition.
					methods := edition methods]
				ifFalse: 
					[definition := edition classDefinition.
					methods := edition classMethods.
					realClass notNil ifTrue: [realClass := realClass class]]].
	methodsPresenter list: methods.
	commentPresenter
		text: comment;
		evaluationContext: realClass.
	definitionPresenter
		text: definition;
		evaluationContext: realClass;
		ensureVisible.
	sourcePresenter
		text: String new;
		evaluationContext: realClass.
	versionInfoPresenter value: nil!

onMethodSelected
	| edition |
	(edition := methodsPresenter selectionOrNil) isNil 
		ifTrue: 
			[sourcePresenter text: String new asRichText.
			versionInfoPresenter value: nil.
			definitionPresenter ensureVisible]
		ifFalse: 
			[sourcePresenter
				text: edition source;
				ensureVisible.
			versionInfoPresenter value: edition]!

onViewOpened
	"Received when the receiver's view is been connected."

	super onViewOpened.
	self isInstanceMode: true.
	sourcePresenter view isReadOnly: true.
	commentPresenter view isReadOnly: true.
	definitionPresenter view isReadOnly: true!

queryCommand: query 
	| selector |
	selector := query commandSymbol.
	selector == #menuLoadMethodEdition 
		ifTrue: 
			[query isEnabled: (methodsPresenter selectionOrNil notNil 
						and: [methodsPresenter selectionOrNil methodClass notNil]).
			^true].
	selector == #menuBrowseMethodEditions 
		ifTrue: 
			[query isEnabled: methodsPresenter selectionOrNil notNil.
			^true].
	selector == #menuCompareClassEditions 
		ifTrue: 
			[query isEnabled: editionsPresenter selectionOrNil size = 2.
			^true].
	^super queryCommand: query!

refresh
	className notNil ifTrue: [editionsPresenter list: (self sourceControl getClassEditions: className)]!

selectedEdition
	^editionsPresenter selectionOrNil isEmpty ifFalse: [editionsPresenter selectionOrNil first]!

selectEdition: aStsClassEdition 
	editionsPresenter selection: (Array 
				with: (editionsPresenter list detect: 
							[:each | 
							each timestamp = aStsClassEdition timestamp and: [each developer = aStsClassEdition developer]]
						ifNone: [^self]))!

setClassName: aSymbol 
	className := aSymbol.
	self caption: 'Class Editions Browser - ' , className asString.
	self refresh! !
!StsClassEditionsBrowserShell categoriesFor: #createComponents!private! !
!StsClassEditionsBrowserShell categoriesFor: #createSchematicWiring!private! !
!StsClassEditionsBrowserShell categoriesFor: #defaultHelpId!public! !
!StsClassEditionsBrowserShell categoriesFor: #isInstanceMode!modes!private! !
!StsClassEditionsBrowserShell categoriesFor: #isInstanceMode:!modes!private! !
!StsClassEditionsBrowserShell categoriesFor: #menuBrowseMethodEditions!private! !
!StsClassEditionsBrowserShell categoriesFor: #menuCompareClassEditions!private! !
!StsClassEditionsBrowserShell categoriesFor: #menuLoadClassEdition!private! !
!StsClassEditionsBrowserShell categoriesFor: #menuLoadMethodEdition!private! !
!StsClassEditionsBrowserShell categoriesFor: #menuUpdateClassEditionsList!private! !
!StsClassEditionsBrowserShell categoriesFor: #onEditionOrModeSelected!private! !
!StsClassEditionsBrowserShell categoriesFor: #onMethodSelected!private! !
!StsClassEditionsBrowserShell categoriesFor: #onViewOpened!private! !
!StsClassEditionsBrowserShell categoriesFor: #queryCommand:!private! !
!StsClassEditionsBrowserShell categoriesFor: #refresh!private! !
!StsClassEditionsBrowserShell categoriesFor: #selectedEdition!private! !
!StsClassEditionsBrowserShell categoriesFor: #selectEdition:!public! !
!StsClassEditionsBrowserShell categoriesFor: #setClassName:!public! !

!StsClassEditionsBrowserShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Class Editions Browser'!

icon
	^StsClassEdition icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851500 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 482 512 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 63 1 738 991 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 738 193 193 0 27 8 'smalltalkTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Image_tools 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 63 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1168 1184 0 27 8 'imageTools' 234 256 1168 98 0 234 240 1168 0 1 0 738 33 31 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1249 51 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 98 2 1216 832 1184 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 1776 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 752 0 1776 0 8 4294905391 234 256 98 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 1776 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'versionInformation' 1986 1 -1 1776 0 2016 2032 2064 8 'errors' 98 1 2000 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1776 0 0 962 202 208 98 1 1026 1056 98 2 738 1 799 738 1249 45 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 98 0 1184 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 2336 0 482 512 0 7 0 0 0 2336 1180166 ##(Smalltalk.ProportionalLayout) 234 240 1168 16 234 256 1168 0 962 202 208 98 1 1026 1056 98 2 738 1 51 738 1249 749 2336 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 98 3 410 2352 98 15 0 2336 98 2 8 1140850688 131073 2656 0 482 512 0 7 0 0 0 2656 2434 202 8 ##(Smalltalk.Dictionary) 98 2 721414 ##(Smalltalk.Association) 410 8 ##(Smalltalk.Splitter) 98 12 0 2656 98 2 8 1140850688 1 2832 0 482 512 0 519 0 0 0 2832 962 202 208 98 1 1026 1056 98 2 738 619 1 738 11 369 2832 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 53 1 0 0 0 0 0 0 58 1 0 0 184 0 0 0] 98 0 1184 0 27 1 2802 410 8 ##(Smalltalk.MultipleSelectionListView) 98 30 0 2656 98 2 8 1140953161 1 3104 590662 2 ##(Smalltalk.ListModel) 202 208 1168 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 512 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #menuUpdateClassEditionsList 8 '&Update list' 1 1 0 0 0 3330 1 3362 8 #menuLoadClassEdition 8 'Load &Edition' 1 1 0 0 0 3330 1 3362 8 #menuCompareClassEditions 8 '&Compare Editions' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3104 0 8 4294909021 2016 2032 2064 0 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Timestamp' 241 8 #left 787814 3 ##(Smalltalk.BlockClosure) 0 459302 ##(Smalltalk.Context) 1 1 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 9 8 ##(Smalltalk.Message) 8 'doIt' 98 2 8 '[:edition | edition timestamp printString]' 98 1 202 8 ##(Smalltalk.PoolDictionary) 1168 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 8 #timestamp 8 #printString 17 257 3778 3904 98 0 0 0 0 3104 0 1 0 0 3618 8 'Developer' 299 3664 3778 8 #developer 3952 0 0 0 3104 0 1 0 0 8 #report 1168 0 131169 0 98 1 0 962 202 208 98 3 1026 1056 98 2 738 1 1 738 619 369 3104 1026 8 #contextMenu: 98 1 3296 3104 1026 8 #text: 98 1 8 'Timestamp' 3104 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 1 0 0 184 0 0 0] 98 0 1184 0 27 3 32 234 256 98 2 3104 8 'classEditions' 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 1249 369 2656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 98 3 3104 2832 410 2352 98 15 0 2656 98 2 8 1140850688 131073 4544 0 0 0 7 0 0 0 4544 530 1 1 0 410 576 98 25 0 4544 98 2 8 1140886340 131137 4624 0 482 8 4278190080 0 535 0 0 0 4624 482 8 4278190080 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.RadioButton) 98 16 0 4624 98 2 8 1141055497 1 4800 721990 2 ##(Smalltalk.ValueHolder) 0 32 1376774 ##(Smalltalk.PluggableSearchPolicy) 3778 8 #= 98 0 3778 8 #hash 98 0 16 0 0 7 0 0 0 4800 0 8 4294907745 852486 ##(Smalltalk.NullConverter) 0 0 0 962 202 208 98 2 1026 1056 98 2 738 21 1 738 131 51 4800 1026 4240 98 1 8 '&Instance' 4800 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 75 0 0 0 25 0 0 0] 98 0 1184 0 27 8 'instanceMode' 410 4816 98 16 0 4624 98 2 8 1141055497 1 5312 4882 0 0 4914 3778 4960 98 0 3778 5008 98 0 32 0 0 7 0 0 0 5312 0 8 4294907745 5058 0 0 0 962 202 208 98 2 1026 1056 98 2 738 161 1 738 111 51 5312 1026 4240 98 1 8 'C&lass' 5312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 135 0 0 0 25 0 0 0] 98 0 1184 0 27 8 'classMode' 234 256 1168 98 0 234 240 1168 590342 ##(Smalltalk.Rectangle) 738 21 1 738 1 1 1 0 738 33 31 738 45 45 0 1554 11 1 1 962 202 208 98 2 1026 1056 98 2 738 1 319 738 621 51 4624 1026 1712 1168 4624 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 159 0 0 0 54 1 0 0 184 0 0 0] 98 2 4800 5312 1184 0 27 0 0 410 8 ##(Smalltalk.ListView) 98 30 0 4544 98 2 8 1140920397 1 6064 3186 202 208 1168 0 3248 482 512 0 31 3282 0 16 98 2 3330 1 3362 8 #menuLoadMethodEdition 8 '&Load Edition' 1 1 0 0 0 3330 1 3362 8 #menuBrowseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 '&Method' 0 1 0 0 0 0 0 0 0 6064 0 8 4294909021 3778 8 #selector 98 0 2032 2064 0 0 0 0 0 0 202 208 98 1 3618 8 '' 613 3664 3778 6400 98 0 3682 0 3714 2 1 0 0 0 3746 1 13 170 8 'Dolphin' 8 'SortedCollection' 8 'doIt' 98 2 8 '[:a :b | a selector < b selector]' 98 1 202 3872 1168 8 #[252 2 0 1 1 14 0 17 18 230 33 230 32 228 32 158 228 33 158 128 106 100 105] 6400 17 513 0 0 0 6064 2032 3 0 0 4032 1168 0 133221 0 98 1 0 962 202 208 98 2 1026 1056 98 2 738 1 1 738 621 319 6064 1026 4192 98 1 6192 6064 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 54 1 0 0 159 0 0 0] 98 0 1184 0 27 234 256 98 4 6064 8 'methods' 4624 8 'mode' 0 962 202 208 98 1 1026 1056 98 2 738 629 1 738 621 369 4544 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 58 1 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 98 2 6064 4624 1184 0 27 1184 0 27 410 2848 98 12 0 2336 98 2 8 1140850688 1 7152 0 482 512 0 519 0 0 0 7152 962 202 208 98 1 1026 1056 98 2 738 1 369 738 1249 11 7152 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 184 0 0 0 112 2 0 0 189 0 0 0] 98 0 1184 0 27 410 8 ##(Smalltalk.CardContainer) 98 16 0 2336 98 2 8 1140850688 393217 7392 0 482 512 0 23 0 0 0 7392 655878 ##(Smalltalk.CardLayout) 202 208 98 3 2802 8 'Class definition' 410 848 98 14 0 7392 98 2 8 1140916224 131073 7584 0 0 0 21 0 0 0 7584 914 8 ##(Smalltalk.SmalltalkWorkspace) 8 #resource_Default_view 0 962 202 208 98 1 1026 1056 98 2 738 9 55 738 1229 305 7584 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 106 2 0 0 179 0 0 0] 1168 1184 0 27 2802 8 'Method source' 410 848 98 14 0 7392 98 2 8 1140916224 131073 7872 0 0 0 23 0 0 0 7872 914 7664 7680 0 962 202 208 98 1 1026 1056 98 2 738 9 55 738 1229 305 7872 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 106 2 0 0 179 0 0 0] 1168 1184 0 27 2802 8 'Class Comment' 410 848 98 14 0 7392 98 2 8 1140850688 131073 8128 0 482 8 4278190080 0 5 0 0 0 8128 914 7664 7680 0 962 202 208 98 1 1026 1056 98 2 738 9 55 738 1229 305 8128 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 106 2 0 0 179 0 0 0] 1168 1184 0 27 7872 234 256 98 6 7872 8 'source' 8128 8 'comment' 7584 8 'definition' 0 410 8 ##(Smalltalk.TabView) 98 23 0 7392 98 2 8 1140916736 1 8464 3186 202 208 98 3 7856 7568 8112 0 3248 1858 31 0 1 0 0 0 8464 0 8 4294903943 2016 2032 2064 0 0 0 0 0 8 #noIcons 962 202 208 98 3 1026 1056 98 2 738 1 1 738 1249 371 8464 1026 8 #basicSelectionsByIndex: 98 1 98 1 3 8464 1026 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 8464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 185 0 0 0] 98 0 1184 0 27 962 202 208 98 1 1026 1056 98 2 738 1 379 738 1249 371 7392 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 189 0 0 0 112 2 0 0 118 1 0 0] 98 4 7872 7584 8128 8464 1184 0 27 1184 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 5 3282 0 16 98 9 3330 1 3362 8 #fileNew 8 '&New' 8349 1 0 0 0 3330 1 3362 8 #fileOpen 8 '&Open...' 8351 1 0 0 0 3330 1 3362 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3330 1 3362 8 #saveImage 8 'Sa&ve Image' 1 1 0 0 0 3330 1 3362 8 #saveImageAs 8 'Save Image As...' 1 1 0 0 0 3330 1 3362 8 #compressChanges 8 '&Compress Changes' 1 1 0 0 0 9394 4097 3330 1 3362 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 0 0 0 8 '&File' 0 1 0 0 19069 0 0 3282 0 16 98 11 3330 1 3362 8 #undo 8 '&Undo' 8373 1 0 0 0 9394 4097 3330 1 3362 8 #cutSelection 8 'Cu&t' 8369 1 0 0 0 3330 1 3362 8 #copySelection 8 '&Copy' 8327 1 0 0 0 3330 1 3362 8 #pasteClipboard 8 '&Paste' 8365 1 0 0 0 3330 1 3362 8 #clearSelection 8 '&Delete' 1 1 0 0 0 3330 1 3362 8 #selectAll 8 'Select &All' 1 1 0 0 0 9394 4097 3330 1 3362 8 #find 8 '&Find...' 8333 1 0 0 0 3330 1 3362 8 #findNext 8 'Find &Next' 229 1 0 0 0 3330 1 3362 8 #findReplace 8 '&Replace...' 8337 1 0 0 0 8 '&Edit' 0 1 0 0 19089 0 0 3282 0 16 98 7 3330 1 3362 8 #browseIt 8 '&Browse It' 8325 1 0 0 0 3330 1 3362 8 #displayIt 8 '&Display It' 8329 1 0 0 0 3330 1 3362 8 #evaluateIt 8 '&Evaluate It' 8331 1 0 0 0 3330 1 3362 8 #inspectIt 8 '&Inspect It' 8339 1 0 0 0 3330 1 3362 8 #fileItIn 8 '&File It In' 1 1 0 0 0 9394 4097 3330 1 3362 8 #accept 8 '&Accept' 8359 1 0 0 0 8 '&Workspace' 0 1 0 0 19103 0 0 3282 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 19105 0 0 3282 0 16 98 15 3330 1 3362 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 3330 1 3362 8 #help 8 'On this &Tool' 1249 1 0 0 0 3330 1 3362 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 9394 4097 3330 1 3362 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 9394 4097 3330 1 3362 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3330 1 3362 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3330 1 3362 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 9394 4097 3330 1 3362 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3330 1 3362 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3330 1 3362 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 9394 4097 3330 1 3362 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 10978 0 16 11024 8 '!!APPLICATION' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 8 '&Help' 0 134217729 0 0 19129 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 738 3839 21 738 1281 961 416 1026 4240 98 1 8 'Class Editions Browser' 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 98 3 560 2336 1776 1184 0 27 )! !
!StsClassEditionsBrowserShell class categoriesFor: #displayOn:!public! !
!StsClassEditionsBrowserShell class categoriesFor: #icon!public! !
!StsClassEditionsBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !

