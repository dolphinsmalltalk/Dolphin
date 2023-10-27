"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.AdvancedFindDialog'
	instanceVariableNames: 'patternPresenter wholeWordPresenter matchCasePresenter modePresenter directionPresenter actionButton closeButton flags validationBlock wrapPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'RegExpMask' -> 16r2. 'WildCardMask' -> 16r1 }!
UI.AdvancedFindDialog guid: (Core.GUID fromString: '{480e6494-8305-46d4-9ab9-8d3c9dafe358}')!
UI.AdvancedFindDialog comment: 'AdvancedFindDialog is a <valueDialogPresenter> replacement for the standard Windows FindText common dialog (as wrapped by the FindDialog class). AdvancedFindDialog has additional setttings over and above those in the standard FindDialog. The dialog must be associated with an owner view capable of responding to the <textFinder> protocol. It will then remain on-screen until dismissed and will forward <FindEvent>s to the owner via its #onFind: event handler.

Instance Variables:
	patternPresenter		<TextPresenter>. The search presenter
	wholeWordPresenter		<BooleanPresenter> to represent choice between whole-word or part-word search.
	matchCasePresenter		<BooleanPresenter> to represent choice between case-sensitive or case-insensitive search.
	modePresenter			<RadioButtonSetPresenter> to represent the choice of search mode (text, wildcard, or regexp).
	directionPresenter		<RadioButtonSetPresenter> to represent the choice of search direction (forwards from the caret, or backwards)
	actionButton			<PushButton> pressed by the user to perform the search.
	closeButton			<PushButton> pressed by the user to close the dialog
	flags					<Integer>
	validationBlock			<MonadicValuable> evaluated against the search pattern entered by the user to determine if it is considered valid.
	wrapPresenter			<BooleanPresenter> to represent the choice of whether the search wraps around at the end/start of the document or not.

Class Variables:
	WildCardMask			<Integer>
	RegExpMask			<Integer>

'!
!UI.AdvancedFindDialog categoriesForClass!MVP-Presenters! !
!UI.AdvancedFindDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	patternPresenter := self add: TextPresenter new name: 'pattern'.
	wholeWordPresenter := self add: BooleanPresenter new name: 'matchWhole'.
	matchCasePresenter := self add: BooleanPresenter new name: 'matchCase'.
	modePresenter := self add: RadioButtonSetPresenter new name: 'mode'.
	directionPresenter := self add: RadioButtonSetPresenter new name: 'direction'.
	wrapPresenter := self add: BooleanPresenter new name: 'wrap'!

findNext
	<commandQuery: #isValid>
	(self model aspectValue: #action) value: #findNext.
	ownerView onFind: self model value!

initialize
	super initialize.
	flags := RegExpMask.
	validationBlock := [:details | self isValidSearch: details]!

isRegExpEnabled
	^flags allMask: RegExpMask!

isRegExpEnabled: aBoolean 
	self isRegExpEnabled = aBoolean ifTrue: [^self].
	flags := flags mask: RegExpMask set: aBoolean.
	self invalidateUserInterface!

isValid
	| mode |
	mode := modePresenter radioButtonNamed: self searchMode.
	^mode notNil and: [mode isEnabled and: [validationBlock value: self model value]]!

isValidRegularExpression: aFindDetails
	^
	[aFindDetails regularExpression test: ''.
	true] on: HRESULTError do: [:ex | false]!

isValidSearch: aFindDetails 
	| type pattern |
	type := aFindDetails searchMode.
	pattern := aFindDetails pattern.
	^type == #wildcardExpression 
		ifTrue: [pattern trimBlanks notEmpty]
		ifFalse: 
			[type == #regularExpression 
				ifTrue: [self isValidRegularExpression: aFindDetails]
				ifFalse: [aFindDetails pattern notEmpty]]!

isWildCardEnabled
	^flags allMask: WildCardMask!

isWildCardEnabled: aBoolean 
	self isWildCardEnabled = aBoolean ifTrue: [^self].
	flags := flags mask: WildCardMask set: aBoolean.
	self invalidateUserInterface!

model: aFindDetails
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aFindDetails.
	aspectBuffer := self model.
	patternPresenter model: (aspectBuffer aspectValue: #pattern).
	wholeWordPresenter model: (aspectBuffer aspectValue: #isWholeWord).
	matchCasePresenter model: (aspectBuffer aspectValue: #isCaseSensitive).
	modePresenter model: (aspectBuffer aspectValue: #searchMode).
	directionPresenter model: (ValueConverter subject: (aspectBuffer aspectValue: #isForwards)
				typeConverter: (MappingConverter rightToLeft: (LookupTable with: #up -> false with: #down -> true))).
	wrapPresenter model: (aspectBuffer aspectValue: #isWrapAround)!

onViewOpened
	"Received when the receiver's view has been connected."

	actionButton := self view viewNamed: 'ok'.
	closeButton := self view viewNamed: 'cancel'.
	super onViewOpened!

prompt: aString 
	(self view viewNamed: 'prompt') text: aString!

queryOk: aCommandQuery
	aCommandQuery isEnabled: self isValid!

searchMode
	^modePresenter value!

show
	"Shows the view of the receiver"

	actionButton text: '&Find Next'; command: #findNext.
	closeButton text: '&Close'.
	super show!

showModal
	"Show the receiver's view as a modal dialog.
	Answer the model if the receiver was confirmed (with #apply, #okay) or nil otherwise"

	actionButton text: '&Find'.
	actionButton command: #ok.
	closeButton text: 'Cancel'.
	^super showModal!

validateUserInterface
	"Set the state of the receiver accordingly. This method is sent at judicious times
	in an attempt to ensure that the receiver's state is up to date. "

	super validateUserInterface.
	(modePresenter radioButtonNamed: #wildcardExpression) 
		ifNotNil: [:value | value isEnabled: self isWildCardEnabled].
	(modePresenter radioButtonNamed: #regularExpression) 
		ifNotNil: [:value | value isEnabled: self isRegExpEnabled].
	wholeWordPresenter view isEnabled: self searchMode ~~ #regularExpression!

validationBlock
	^validationBlock!

validationBlock: aBlock 
	"Set the <monadicValuable> used to validate the selector pattern entered by the user. The
	valuable is passed the current reply text as its argument, and is expected to answer whether
	it is valid. The OK button is not enabled until the validationBlock answers true."

	validationBlock := aBlock! !
!UI.AdvancedFindDialog categoriesForMethods!
createComponents!initializing!public! !
findNext!commands-actions!public! !
initialize!initializing!public! !
isRegExpEnabled!public!testing! !
isRegExpEnabled:!accessing!public! !
isValid!private!testing! !
isValidRegularExpression:!private!testing! !
isValidSearch:!private!testing! !
isWildCardEnabled!public!testing! !
isWildCardEnabled:!accessing!public! !
model:!accessing!public! !
onViewOpened!event handling!public! !
prompt:!accessing!public! !
queryOk:!commands-actions!private! !
searchMode!accessing!public! !
show!operations!public! !
showModal!public!realizing/unrealizing! !
validateUserInterface!operations!public! !
validationBlock!accessing!public! !
validationBlock:!accessing!public! !
!

!UI.AdvancedFindDialog class methodsFor!

createOn: aFindDetails prompt: promptString caption: captionString 
	| dialog |
	(dialog := self createOn: aFindDetails) prompt: promptString.
	captionString notNil ifTrue: [dialog caption: captionString].
	^dialog!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^AdvancedFindDetails new!

icon
	"Answers an Icon that can be used to represent this class"

	^AdvancedFindDetails icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 17 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 838 1 #{UI.FlowLayout} 1 11 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 416 nil nil nil 5 nil nil nil 416 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 77 210 151 47 416 578 #text: 50 1 8 'C&lose' 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 210 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1141055488 1 800 nil nil nil 5 nil nil nil 800 nil nil 482 #ok 8 '&Find' 1 5 nil nil true nil nil nil 530 50 3 578 #createAt:extent: 50 2 210 1 21 210 151 47 800 578 #isEnabled: 8 #(false) 800 578 #text: 50 1 8 '&Find' 800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 768 nil 29 8 'ok' 518 #{Graphics.Rectangle} 210 1 21 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 789 1 210 161 319 272 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 50 2 800 416 768 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1344 nil nil nil 5 nil nil nil 1344 262 #{UI.FramingLayout} 370 #{Core.LookupTable} 50 6 18 #{UI.TextEdit} 50 20 nil 1344 50 2 8 1141047424 1025 1472 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1472 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 145 25 210 607 45 1472 578 #setMarginWidths: 50 1 8 #(3 3) 1472 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 8 #() 768 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 19 1826 #fixedParentRight -1 1826 #fixedPreviousTop -5 1826 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 1344 50 2 8 1140850944 1 1904 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 1904 nil nil 1570 nil nil true 530 50 2 578 #createAt:extent: 50 2 210 17 31 210 111 41 1904 578 #text: 50 1 8 'Fi&nd what:' 1904 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 8 #() 768 nil 27 1794 1826 #fixedParentLeft 5 1826 #fixedViewLeft 111 1826 #fixedParentTop 1 1888 41 18 #{UI.ContainerView} 50 15 nil 1344 50 2 8 1140850688 131073 2320 nil nil nil 5 nil nil nil 2320 338 17 1 1 550 #{Core.IdentityDictionary} 0 1138 210 1 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 13 79 210 741 221 2320 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 2320 50 2 8 1140850688 131073 2624 nil nil nil 5 nil nil nil 2624 1410 370 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 2624 50 2 8 1140850695 65 2736 nil nil nil 5 nil nil nil 2736 nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 281 201 2736 578 #text: 50 1 8 'Search Mode' 2736 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 768 nil 27 1794 2272 1 1856 1 2304 1 1826 #fixedParentBottom 1 18 #{UI.ContainerView} 50 15 nil 2624 50 2 8 1140850688 131073 3024 nil nil nil 5 nil nil nil 3024 1030 #{UI.GridLayout} 7 1 1 1 370 2400 50 6 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1140858889 1 3152 1970 nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3152 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 105 210 255 53 3152 578 #text: 50 1 8 '&Regular Expression' 3152 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 768 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1140989961 1 3568 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3568 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 255 53 3568 578 #text: 50 1 8 '&Text' 3568 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 768 nil 27 8 'text' 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1140858889 1 3952 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3952 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 255 53 3952 578 #text: 50 1 8 '&Wildcard Expression' 3952 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 768 nil 27 8 'wildcardExpression' nil 530 50 1 578 #createAt:extent: 50 2 210 19 33 210 255 157 3024 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 50 3 3568 3952 3152 768 nil 27 1794 2272 19 1856 -7 2304 33 3008 -11 370 2400 50 2 3024 8 'mode' nil 530 50 1 578 #createAt:extent: 50 2 210 1 11 210 281 201 2624 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 50 2 2736 3024 768 nil 27 18 #{UI.ContainerView} 50 15 nil 2320 50 2 8 1140850688 131073 4688 nil nil nil 5 nil nil nil 4688 1410 370 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 4688 50 2 8 1140850695 65 4800 nil nil nil 5 nil nil nil 4800 nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 205 201 4800 578 #text: 50 1 8 'Match' 4800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 768 nil 27 1794 2272 1 1856 1 2304 1 3008 1 18 #{UI.ContainerView} 50 15 nil 4688 50 2 8 1140850688 131073 5072 nil nil nil 5 nil nil nil 5072 338 1 11 1 370 2400 50 4 18 #{UI.CheckBox} 50 16 nil 5072 50 2 8 1140924419 1 5184 1970 nil nil 2016 false nil nil 517 nil nil nil 5184 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 87 35 5184 578 #text: 50 1 8 '&Case' 5184 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 43 0 0 0 43 0 0 0] 8 #() 768 nil 27 8 'matchCase' 18 #{UI.CheckBox} 50 16 nil 5072 50 2 8 1141058819 1 5488 1970 nil nil 2016 false nil nil 5 nil nil nil 5488 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 161 43 5488 578 #text: 50 1 8 '&Whole word' 5488 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 21 0 0 0] 8 #() 768 nil 27 8 'matchWhole' nil 530 50 1 578 #createAt:extent: 50 2 210 23 35 210 165 151 5072 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 50 2 5488 5184 768 nil 27 1794 2272 23 1856 -17 2304 35 3008 -15 2402 0 nil 530 50 1 578 #createAt:extent: 50 2 210 297 11 210 205 201 4688 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 50 2 4800 5072 768 nil 27 18 #{UI.ContainerView} 50 15 nil 2320 50 2 8 1140850688 131073 6112 nil nil nil 5 nil nil nil 6112 1410 370 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 6112 50 2 8 1140850695 65 6224 nil nil nil 5 nil nil nil 6224 nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 221 201 6224 578 #text: 50 1 8 'Direction' 6224 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 8 #() 768 nil 27 1794 2272 1 1856 1 2304 1 3008 1 18 #{UI.ContainerView} 50 15 nil 6112 50 2 8 1140850688 131073 6496 nil nil nil 5 nil nil nil 6496 338 1 11 1 370 2400 50 6 18 #{UI.RadioButton} 50 16 nil 6496 50 2 8 1140858889 1 6608 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 6608 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 81 1 210 97 43 6608 578 #text: 50 1 8 '&Down' 6608 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 8 #() 768 nil 27 8 'down' 18 #{UI.RadioButton} 50 16 nil 6496 50 2 8 1141055497 1 6992 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 6992 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 81 43 6992 578 #text: 50 1 8 '&Up' 6992 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 8 #() 768 nil 27 8 'up' 18 #{UI.CheckBox} 50 16 nil 6496 50 2 8 1140924419 1 7376 1970 nil nil 2016 false nil nil 5 nil nil nil 7376 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 181 43 7376 578 #text: 50 1 8 '&Wrap around' 7376 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 8 #() 768 nil 27 8 'wrap' nil 530 50 1 578 #createAt:extent: 50 2 210 19 33 210 191 151 6496 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 50 3 6992 6608 7376 768 nil 27 1794 2272 19 1856 -11 2304 33 3008 -17 370 2400 50 2 6496 8 'direction' nil 530 50 1 578 #createAt:extent: 50 2 210 517 11 210 221 201 6112 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 50 2 6224 6496 768 nil 27 768 nil 27 1794 2272 1 1856 1 1826 #fixedPreviousBottom 11 3008 1 370 2400 50 4 1472 8 'pattern' 1904 8 'prompt' 1138 210 13 31 210 11 21 530 50 1 578 #createAt:extent: 50 2 210 11 1 210 763 319 1344 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 50 3 1904 1472 2320 768 nil 27 2402 0 1138 210 11 1 210 11 1 nil nil nil nil 1 nil nil 210 2049 397 210 991 397 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 530 50 2 578 #createAt:extent: 50 2 210 6143 21 210 991 397 32 578 #text: 50 1 8 'Find' 32 706 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 238 13 0 0 208 0 0 0] 50 2 1344 272 768 nil 27)!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 11 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 838 1 #{UI.FlowLayout} 1 11 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140858880 1 416 nil nil nil 5 nil nil nil 416 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 77 210 151 47 416 578 #text: 50 1 8 'C&lose' 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 210 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1141055488 1 800 nil nil nil 5 nil nil nil 800 nil nil 482 #ok 8 '&Find' 1 5 nil nil true nil nil nil 530 50 3 578 #createAt:extent: 50 2 210 1 21 210 151 47 800 578 #isEnabled: 8 #(false) 800 578 #text: 50 1 8 '&Find' 800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 768 nil 29 8 'ok' 518 #{Graphics.Rectangle} 210 1 21 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 549 1 210 161 319 272 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 50 2 800 416 768 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1344 nil nil nil 5 nil nil nil 1344 262 #{UI.FramingLayout} 370 #{Core.LookupTable} 50 6 18 #{UI.TextEdit} 50 20 nil 1344 50 2 8 1141047424 1025 1472 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1472 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 145 25 210 371 45 1472 578 #setMarginWidths: 50 1 8 #(3 3) 1472 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 8 #() 768 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 19 1826 #fixedParentRight -3 1826 #fixedPreviousTop -5 1826 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 1344 50 2 8 1140850944 1 1904 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 1904 nil nil 1570 nil nil true 530 50 2 578 #createAt:extent: 50 2 210 17 31 210 111 31 1904 578 #text: 50 1 8 'Fi&nd what:' 1904 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 768 nil 27 1794 1826 #fixedParentLeft 5 1826 #fixedViewLeft 111 1826 #fixedParentTop 1 1888 31 18 #{UI.ContainerView} 50 15 nil 1344 50 2 8 1140850688 131073 2320 nil nil nil 5 nil nil nil 2320 338 17 1 1 550 #{Core.IdentityDictionary} 0 1138 210 1 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 13 79 210 507 221 2320 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 50 2 18 #{UI.ContainerView} 50 15 nil 2320 50 2 8 1140850688 131073 2624 nil nil nil 5 nil nil nil 2624 1410 370 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 2624 50 2 8 1140850695 65 2736 nil nil nil 5 nil nil nil 2736 nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 281 201 2736 578 #text: 50 1 8 'Search Mode' 2736 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 768 nil 27 1794 2272 1 1856 1 2304 1 1826 #fixedParentBottom 1 18 #{UI.ContainerView} 50 15 nil 2624 50 2 8 1140850688 131073 3024 nil nil nil 5 nil nil nil 3024 1030 #{UI.GridLayout} 7 1 1 1 370 2400 50 6 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1140858889 1 3152 1970 nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3152 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 105 210 253 53 3152 578 #text: 50 1 8 '&Regular Expression' 3152 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 8 #() 768 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1141055497 1 3568 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3568 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 253 53 3568 578 #text: 50 1 8 '&Text' 3568 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 8 #() 768 nil 27 8 'text' 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1140858889 1 3952 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3952 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 253 53 3952 578 #text: 50 1 8 '&Wildcard Expression' 3952 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 8 #() 768 nil 27 8 'wildcardExpression' nil 530 50 1 578 #createAt:extent: 50 2 210 21 33 210 253 157 3024 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 50 3 3568 3952 3152 768 nil 27 1794 2272 21 1856 -7 2304 33 3008 -11 370 2400 50 2 3024 8 'mode' nil 530 50 1 578 #createAt:extent: 50 2 210 1 11 210 281 201 2624 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 50 2 2736 3024 768 nil 27 18 #{UI.ContainerView} 50 15 nil 2320 50 2 8 1140850688 131073 4688 nil nil nil 5 nil nil nil 4688 1410 370 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 4688 50 2 8 1140850695 65 4800 nil nil nil 5 nil nil nil 4800 nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 205 201 4800 578 #text: 50 1 8 'Match' 4800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 768 nil 27 1794 2272 1 1856 1 2304 1 3008 1 18 #{UI.ContainerView} 50 15 nil 4688 50 2 8 1140850688 131073 5072 nil nil nil 5 nil nil nil 5072 3090 7 1 1 1 370 2400 50 4 18 #{UI.CheckBox} 50 16 nil 5072 50 2 8 1140858883 1 5184 1970 nil nil 2016 false nil nil 5 nil nil nil 5184 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 51 210 175 53 5184 578 #text: 50 1 8 '&Case' 5184 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 8 #() 768 nil 27 8 'matchCase' 18 #{UI.CheckBox} 50 16 nil 5072 50 2 8 1141055491 1 5488 1970 nil nil 2016 false nil nil 5 nil nil nil 5488 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 175 51 5488 578 #text: 50 1 8 '&Whole word' 5488 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 8 #() 768 nil 27 8 'matchWhole' nil 530 50 1 578 #createAt:extent: 50 2 210 19 35 210 175 153 5072 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 50 2 5488 5184 768 nil 27 1794 2272 19 1856 -11 2304 35 3008 -13 2402 0 nil 530 50 1 578 #createAt:extent: 50 2 210 297 11 210 205 201 4688 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 50 2 4800 5072 768 nil 27 768 nil 27 1794 2272 1 1856 1 1826 #fixedPreviousBottom 11 3008 1 370 2400 50 4 1472 8 'pattern' 1904 8 'prompt' 1138 210 13 31 210 11 21 530 50 1 578 #createAt:extent: 50 2 210 11 1 210 529 319 1344 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 50 3 1904 1472 2320 768 nil 27 2402 0 1138 210 11 1 210 11 1 nil nil nil nil 1 nil nil 210 2049 397 210 751 397 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 530 50 2 578 #createAt:extent: 50 2 210 6143 21 210 751 397 32 578 #text: 50 1 8 'Find' 32 706 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 118 13 0 0 208 0 0 0] 50 2 1344 272 768 nil 27)!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 11 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 838 1 #{UI.FlowLayout} 1 11 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 416 nil nil nil 5 nil nil nil 416 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 77 210 151 47 416 578 #text: 50 1 8 'C&lose' 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 210 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1141055488 1 800 nil nil nil 5 nil nil nil 800 nil nil 482 #ok 8 '&Find' 1 5 nil nil true nil nil nil 530 50 3 578 #createAt:extent: 50 2 210 1 21 210 151 47 800 578 #isEnabled: 8 #(false) 800 578 #text: 50 1 8 '&Find' 800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 768 nil 29 8 'ok' 518 #{Graphics.Rectangle} 210 1 21 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 559 1 210 161 319 272 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 50 2 800 416 768 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1344 nil nil nil 5 nil nil nil 1344 262 #{UI.FramingLayout} 370 #{Core.LookupTable} 50 6 18 #{UI.TextEdit} 50 20 nil 1344 50 2 8 1141047424 1025 1472 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1472 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 145 29 210 371 45 1472 578 #setMarginWidths: 50 1 8 #(3 3) 1472 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 8 #() 768 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 19 1826 #fixedParentRight -13 1826 #fixedPreviousTop -1 1826 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 1344 50 2 8 1140850944 1 1904 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 1904 nil nil 1570 nil nil true 530 50 2 578 #createAt:extent: 50 2 210 17 31 210 111 31 1904 578 #text: 50 1 8 'Fi&nd what:' 1904 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 768 nil 27 1794 1826 #fixedParentLeft 5 1826 #fixedViewLeft 111 1826 #fixedParentTop 1 1888 31 18 #{UI.ContainerView} 50 15 nil 1344 50 2 8 1140916224 131073 2320 nil nil nil 5 nil nil nil 2320 338 17 1 1 550 #{Core.IdentityDictionary} 0 1138 210 1 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 13 83 210 517 217 2320 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 50 2 18 #{UI.ContainerView} 50 15 nil 2320 50 2 8 1140916224 131073 2624 nil nil nil 5 nil nil nil 2624 1410 370 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 2624 50 2 8 1140850695 65 2736 nil nil nil 5 nil nil nil 2736 nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 281 201 2736 578 #text: 50 1 8 'Search Mode' 2736 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 768 nil 27 1794 2272 1 1856 1 2304 1 1826 #fixedParentBottom 1 18 #{UI.ContainerView} 50 15 nil 2624 50 2 8 1140916224 131073 3024 nil nil nil 5 nil nil nil 3024 1030 #{UI.GridLayout} 7 1 1 1 370 2400 50 6 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1140924425 1 3152 1970 nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3152 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 105 210 255 53 3152 578 #text: 50 1 8 '&Regular Expression' 3152 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 768 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1141055497 1 3568 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3568 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 255 53 3568 578 #text: 50 1 8 '&Text' 3568 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 768 nil 27 8 'text' 18 #{UI.RadioButton} 50 16 nil 3024 50 2 8 1140924425 1 3952 1970 nil nil 3234 3266 #= 8 #() 3266 #hash 8 #() false nil nil 5 nil nil nil 3952 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 255 53 3952 578 #text: 50 1 8 '&Wildcard Expression' 3952 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 768 nil 27 8 'wildcardExpression' nil 530 50 1 578 #createAt:extent: 50 2 210 19 31 210 255 157 3024 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 50 3 3568 3952 3152 768 nil 27 1794 2272 19 1856 -7 2304 31 3008 -13 370 2400 50 2 3024 8 'mode' nil 530 50 1 578 #createAt:extent: 50 2 210 1 11 210 281 201 2624 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 50 2 2736 3024 768 nil 27 18 #{UI.ContainerView} 50 15 nil 2320 50 2 8 1140850688 131073 4688 nil nil nil 5 nil nil nil 4688 3090 7 1 1 1 370 2400 50 2 18 #{UI.CheckBox} 50 16 nil 4688 50 2 8 1141055491 1 4800 1970 nil nil 2016 false nil nil 5 nil nil nil 4800 nil nil 1570 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 11 11 210 195 65 4800 578 #text: 50 1 8 'Match &case' 4800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 8 #() 768 nil 27 8 'matchCase' 1138 210 11 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 297 11 210 205 201 4688 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 50 1 4800 768 nil 27 768 nil 27 1794 2272 1 1856 1 1826 #fixedPreviousBottom 11 3008 1 370 2400 50 4 1472 8 'pattern' 1904 8 'prompt' 1138 210 13 31 210 11 21 530 50 1 578 #createAt:extent: 50 2 210 11 1 210 539 319 1344 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 50 3 1904 1472 2320 768 nil 27 2402 0 1138 210 11 1 210 11 1 nil nil nil nil 1 nil nil 210 2049 397 210 761 397 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 530 50 2 578 #createAt:extent: 50 2 210 6143 21 210 761 397 32 578 #text: 50 1 8 'Find' 32 706 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 208 0 0 0] 50 2 1344 272 768 nil 27)!

showModeless: aView on: aFindDetails 
	(self createOn: aFindDetails)
		ownerView: aView;
		show! !
!UI.AdvancedFindDialog class categoriesForMethods!
createOn:prompt:caption:!instance creation!public! !
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Directionless_view!public!resources-views! !
resource_Selector_view!public!resources-views! !
showModeless:on:!instance creation!public! !
!

