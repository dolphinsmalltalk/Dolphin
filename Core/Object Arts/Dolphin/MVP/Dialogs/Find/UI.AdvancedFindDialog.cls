"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #AdvancedFindDialog
	instanceVariableNames: 'patternPresenter wholeWordPresenter matchCasePresenter modePresenter directionPresenter actionButton closeButton flags validationBlock wrapPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'RegExpMask' -> 16r2.
		'WildCardMask' -> 16r1
	}!
AdvancedFindDialog guid: (GUID fromString: '{480e6494-8305-46d4-9ab9-8d3c9dafe358}')!
AdvancedFindDialog comment: 'AdvancedFindDialog is a <valueDialogPresenter> replacement for the standard the Windows FindText common dialog (as wrapped by the FindDialog class). AdvancedFindDialog has additional setttings over and above those in the standard FindDialog. The dialog must be associated with an owner view capable of responding to the <textFinder> protocol. It will then remain on-screen until dismissed and will forward <FindEvent>s to the owner via its #onFind: event handler.

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
!AdvancedFindDialog categoriesForClass!MVP-Presenters! !
!AdvancedFindDialog methodsFor!

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

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the
	<CommandQuery>."

	(#(#ok #findNext) includes: aCommandQuery commandSymbol) 
		ifTrue: 
			[aCommandQuery isEnabled: self isValid.
			^true].
	^super queryCommand: aCommandQuery!

searchMode
	^modePresenter value!

show
	"Shows the view of the receiver"

	actionButton text: '&Find Next'; command: #findNext.
	closeButton text: '&Close'.
	self view show!

showModal
	"Show the receiver's view as a modal dialog.
	Answer the model if the receiver was confirmed (with #apply, #okay) or nil otherwise"

	actionButton text: '&Find'.
	actionButton command: #ok.
	closeButton text: 'Cancel'.
	^super showModal!

validateUserInterface
	"Set the state of the receiver accordingly. This method is sent at judicious times
	in an attempt to ensure that the receivers state is up to date. "

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
!AdvancedFindDialog categoriesFor: #createComponents!initializing!public! !
!AdvancedFindDialog categoriesFor: #findNext!commands!public! !
!AdvancedFindDialog categoriesFor: #initialize!initializing!public! !
!AdvancedFindDialog categoriesFor: #isRegExpEnabled!public!testing! !
!AdvancedFindDialog categoriesFor: #isRegExpEnabled:!accessing!public! !
!AdvancedFindDialog categoriesFor: #isValid!private!testing! !
!AdvancedFindDialog categoriesFor: #isValidRegularExpression:!private!testing! !
!AdvancedFindDialog categoriesFor: #isValidSearch:!private!testing! !
!AdvancedFindDialog categoriesFor: #isWildCardEnabled!public!testing! !
!AdvancedFindDialog categoriesFor: #isWildCardEnabled:!accessing!public! !
!AdvancedFindDialog categoriesFor: #model:!accessing!public! !
!AdvancedFindDialog categoriesFor: #onViewOpened!event handling!public! !
!AdvancedFindDialog categoriesFor: #prompt:!accessing!public! !
!AdvancedFindDialog categoriesFor: #queryCommand:!commands!private! !
!AdvancedFindDialog categoriesFor: #searchMode!accessing!public! !
!AdvancedFindDialog categoriesFor: #show!operations!public! !
!AdvancedFindDialog categoriesFor: #showModal!public!realizing/unrealizing! !
!AdvancedFindDialog categoriesFor: #validateUserInterface!operations!public! !
!AdvancedFindDialog categoriesFor: #validationBlock!accessing!public! !
!AdvancedFindDialog categoriesFor: #validationBlock:!accessing!public! !

!AdvancedFindDialog class methodsFor!

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

	^FindDetails icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 17 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1141055488 1 768 nil nil nil 7 nil nil nil 768 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Find' 1 5 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 21 578 151 47 768 962 #isEnabled: 8 #(false) 768 962 #text: 34 1 8 '&Find' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 578 193 193 nil 29 8 'ok' 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1216 nil nil nil 7 nil nil nil 1216 nil 8 1903885040 850 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 77 578 151 47 1216 962 #text: 34 1 8 'C&lose' 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 1184 nil 29 8 'cancel' 590342 ##(Smalltalk.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 789 1 578 161 319 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 34 2 768 1216 1184 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 1904 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1904 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 25 578 607 45 1904 962 #setMarginWidths: 34 1 8 #(3 3) 1904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 8 #() 1184 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 19 2290 #fixedParentRight -1 2290 #fixedPreviousTop -5 2290 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 2368 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 2368 nil 8 1903849936 2018 nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 41 2368 962 #text: 34 1 8 'Fi&nd what:' 2368 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 8 #() 1184 nil 27 2258 2290 #fixedParentLeft 5 2290 #fixedViewLeft 111 2290 #fixedParentTop 1 2352 41 410 ##(Smalltalk.ContainerView) 34 15 nil 1776 34 2 8 1140850688 131073 2816 nil nil nil 7 nil nil nil 2816 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 79 578 741 221 2816 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 3136 nil nil nil 7 nil nil nil 3136 1842 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 3136 34 2 8 1140850688 131073 3248 nil nil nil 7 nil nil nil 3248 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 3248 34 2 8 1140858889 1 3376 2434 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 3376 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 255 53 3376 962 #text: 34 1 8 '&Wildcard Expression' 3376 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1184 nil 27 8 'wildcardExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3248 34 2 8 1140858889 1 3824 2434 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 3824 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 255 53 3824 962 #text: 34 1 8 '&Regular Expression' 3824 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1184 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3248 34 2 8 1140989961 1 4240 2434 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 4240 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 255 53 4240 962 #text: 34 1 8 '&Text' 4240 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1184 nil 27 8 'text' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 33 578 255 157 3248 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 4240 3376 3824 1184 nil 27 2258 2768 19 2320 -7 2800 33 2290 #fixedParentBottom -11 410 ##(Smalltalk.GroupBox) 34 14 nil 3136 34 2 8 1140850695 65 4848 nil nil nil 7 nil nil nil 4848 nil 8 1903885040 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 4848 962 #text: 34 1 8 'Search Mode' 4848 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2258 2768 1 2320 1 2800 1 4832 1 170 192 34 2 3248 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 3136 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 4848 3248 1184 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 5360 nil nil nil 7 nil nil nil 5360 1842 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 5360 34 2 8 1140850688 131073 5472 nil nil nil 7 nil nil nil 5472 706 1 11 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 5472 34 2 8 1141058819 1 5584 2434 nil nil 2480 false nil nil 7 nil nil nil 5584 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 161 43 5584 962 #text: 34 1 8 '&Whole word' 5584 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'matchWhole' 410 ##(Smalltalk.CheckBox) 34 16 nil 5472 34 2 8 1140924419 1 5920 2434 nil nil 2480 false nil nil 519 nil nil nil 5920 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 165 43 5920 962 #text: 34 1 8 '&Case' 5920 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 82 0 0 0 47 0 0 0] 8 #() 1184 nil 27 8 'matchCase' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 23 35 578 165 151 5472 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 34 2 5584 5920 1184 nil 27 2258 2768 23 2320 -17 2800 35 4832 -15 410 ##(Smalltalk.GroupBox) 34 14 nil 5360 34 2 8 1140850695 65 6432 nil nil nil 7 nil nil nil 6432 nil 8 1903885040 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 205 201 6432 962 #text: 34 1 8 'Match' 6432 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2258 2768 1 2320 1 2800 1 4832 1 170 192 2912 nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 5360 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 6432 5472 1184 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 6912 nil nil nil 7 nil nil nil 6912 1842 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 6912 34 2 8 1140850688 131073 7024 nil nil nil 7 nil nil nil 7024 706 1 11 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 7024 34 2 8 1141055497 1 7136 2434 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 7136 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 81 43 7136 962 #text: 34 1 8 '&Up' 7136 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'up' 410 ##(Smalltalk.CheckBox) 34 16 nil 7024 34 2 8 1140924419 1 7552 2434 nil nil 2480 false nil nil 7 nil nil nil 7552 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 181 43 7552 962 #text: 34 1 8 '&Wrap around' 7552 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 8 #() 1184 nil 27 8 'wrap' 410 ##(Smalltalk.RadioButton) 34 16 nil 7024 34 2 8 1140858889 1 7888 2434 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 7888 nil 8 1903885040 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 81 1 578 97 43 7888 962 #text: 34 1 8 '&Down' 7888 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'down' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 33 578 191 151 7024 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 34 3 7136 7888 7552 1184 nil 27 2258 2768 19 2320 -11 2800 33 4832 -17 410 ##(Smalltalk.GroupBox) 34 14 nil 6912 34 2 8 1140850695 65 8480 nil nil nil 7 nil nil nil 8480 nil 8 1903885040 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 221 201 8480 962 #text: 34 1 8 'Direction' 8480 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2258 2768 1 2320 1 2800 1 4832 1 170 192 34 2 7024 8 'direction' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 517 11 578 221 201 6912 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 34 2 8480 7024 1184 nil 27 1184 nil 27 2258 2768 1 2320 1 2290 #fixedPreviousBottom 11 4832 1 170 192 34 4 1904 8 'pattern' 2368 8 'prompt' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 763 319 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 34 3 2368 1904 2816 1184 nil 27 170 192 2912 1554 578 11 1 578 11 1 nil nil nil nil 50751 nil nil 578 2049 397 578 991 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 898 138 144 34 3 962 #createAt:extent: 34 2 578 3839 21 578 991 397 416 962 #text: 34 1 8 'Find' 416 962 #updateMenuBar 2912 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 110 9 0 0 208 0 0 0] 34 2 1776 640 1184 nil 27 )!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1141055488 1 768 nil nil nil 7 nil nil nil 768 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Find' 1 5 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 21 578 151 47 768 962 #isEnabled: 8 #(false) 768 962 #text: 34 1 8 '&Find' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 578 193 193 nil 29 8 'ok' 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140858880 1 1216 nil nil nil 7 nil nil nil 1216 nil 8 1903885040 850 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 77 578 151 47 1216 962 #text: 34 1 8 'C&lose' 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 1184 nil 29 8 'cancel' 590342 ##(Smalltalk.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 549 1 578 161 319 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 34 2 768 1216 1184 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 1904 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1904 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 31 1904 962 #text: 34 1 8 'Fi&nd what:' 1904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1184 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 5 2338 #fixedViewLeft 111 2338 #fixedParentTop 1 2338 #fixedViewTop 31 410 ##(Smalltalk.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 2416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 2416 nil 8 1903872368 2066 nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 25 578 371 45 2416 962 #setMarginWidths: 34 1 8 #(3 3) 2416 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 8 #() 1184 nil 27 2306 2338 #fixedPreviousRight 19 2338 #fixedParentRight -3 2338 #fixedPreviousTop -5 2400 45 410 ##(Smalltalk.ContainerView) 34 15 nil 1776 34 2 8 1140850688 131073 2816 nil nil nil 7 nil nil nil 2816 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 79 578 507 221 2816 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 3136 nil nil nil 7 nil nil nil 3136 1842 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 3136 34 2 8 1140850695 65 3248 nil nil nil 7 nil nil nil 3248 nil 8 1903885040 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 3248 962 #text: 34 1 8 'Search Mode' 3248 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2306 2352 1 2784 1 2384 1 2338 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3136 34 2 8 1140850688 131073 3568 nil nil nil 7 nil nil nil 3568 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1141055497 1 3696 1970 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 3696 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 253 53 3696 962 #text: 34 1 8 '&Text' 3696 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 8 #() 1184 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1140858889 1 4144 1970 nil nil 3778 3810 #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 4144 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 253 53 4144 962 #text: 34 1 8 '&Regular Expression' 4144 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 8 #() 1184 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1140858889 1 4560 1970 nil nil 3778 3810 #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 4560 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 253 53 4560 962 #text: 34 1 8 '&Wildcard Expression' 4560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 8 #() 1184 nil 27 8 'wildcardExpression' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 21 33 578 253 157 3568 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 3696 4560 4144 1184 nil 27 2306 2352 21 2784 -7 2384 33 3552 -11 170 192 34 2 3568 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 3136 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 3248 3568 1184 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 5360 nil nil nil 7 nil nil nil 5360 1842 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 5360 34 2 8 1140850695 65 5472 nil nil nil 7 nil nil nil 5472 nil 8 1903885040 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 205 201 5472 962 #text: 34 1 8 'Match' 5472 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2306 2352 1 2784 1 2384 1 3552 1 410 ##(Smalltalk.ContainerView) 34 15 nil 5360 34 2 8 1140850688 131073 5776 nil nil nil 7 nil nil nil 5776 3634 7 1 1 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 5776 34 2 8 1141055491 1 5888 1970 nil nil 2016 false nil nil 7 nil nil nil 5888 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 175 51 5888 962 #text: 34 1 8 '&Whole word' 5888 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 8 #() 1184 nil 27 8 'matchWhole' 410 ##(Smalltalk.CheckBox) 34 16 nil 5776 34 2 8 1140858883 1 6224 1970 nil nil 2016 false nil nil 7 nil nil nil 6224 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 51 578 175 53 6224 962 #text: 34 1 8 '&Case' 6224 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 8 #() 1184 nil 27 8 'matchCase' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 35 578 175 153 5776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 34 2 5888 6224 1184 nil 27 2306 2352 19 2784 -11 2384 35 3552 -13 170 192 2912 nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 5360 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 5472 5776 1184 nil 27 1184 nil 27 2306 2352 1 2784 1 2338 #fixedPreviousBottom 11 3552 1 170 192 34 4 1904 8 'prompt' 2416 8 'pattern' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 529 319 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 34 3 1904 2416 2816 1184 nil 27 170 192 2912 1554 578 11 1 578 11 1 nil nil nil nil 51105 nil nil 578 2049 397 578 751 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 898 138 144 34 3 962 #createAt:extent: 34 2 578 3839 21 578 751 397 416 962 #text: 34 1 8 'Find' 416 962 #updateMenuBar 2912 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 246 8 0 0 208 0 0 0] 34 2 1776 640 1184 nil 27 )!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1141055488 1 768 nil nil nil 7 nil nil nil 768 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Find' 1 5 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 21 578 151 47 768 962 #isEnabled: 8 #(false) 768 962 #text: 34 1 8 '&Find' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 578 193 193 nil 29 8 'ok' 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1216 nil nil nil 7 nil nil nil 1216 nil 8 1903885040 850 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 77 578 151 47 1216 962 #text: 34 1 8 'C&lose' 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 1184 nil 29 8 'cancel' 590342 ##(Smalltalk.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 559 1 578 161 319 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 34 2 768 1216 1184 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 1904 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1904 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 31 1904 962 #text: 34 1 8 'Fi&nd what:' 1904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1184 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 5 2338 #fixedViewLeft 111 2338 #fixedParentTop 1 2338 #fixedViewTop 31 410 ##(Smalltalk.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 2416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 2416 nil 8 1903872368 2066 nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 29 578 371 45 2416 962 #setMarginWidths: 34 1 8 #(3 3) 2416 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 8 #() 1184 nil 27 2306 2338 #fixedPreviousRight 19 2338 #fixedParentRight -13 2338 #fixedPreviousTop -1 2400 45 410 ##(Smalltalk.ContainerView) 34 15 nil 1776 34 2 8 1140916224 131073 2816 nil nil nil 7 nil nil nil 2816 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 83 578 517 217 2816 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140916224 131073 3136 nil nil nil 7 nil nil nil 3136 1842 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 3136 34 2 8 1140850695 65 3248 nil nil nil 7 nil nil nil 3248 nil 8 1903885040 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 3248 962 #text: 34 1 8 'Search Mode' 3248 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2306 2352 1 2784 1 2384 1 2338 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3136 34 2 8 1140916224 131073 3568 nil nil nil 7 nil nil nil 3568 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1141055497 1 3696 1970 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 3696 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 255 53 3696 962 #text: 34 1 8 '&Text' 3696 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1184 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1140924425 1 4144 1970 nil nil 3778 3810 #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 4144 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 255 53 4144 962 #text: 34 1 8 '&Wildcard Expression' 4144 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1184 nil 27 8 'wildcardExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1140924425 1 4560 1970 nil nil 3778 3810 #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 4560 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 255 53 4560 962 #text: 34 1 8 '&Regular Expression' 4560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1184 nil 27 8 'regularExpression' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 31 578 255 157 3568 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 34 3 3696 4144 4560 1184 nil 27 2306 2352 19 2784 -7 2384 31 3552 -13 170 192 34 2 3568 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 3136 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 3248 3568 1184 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 5360 nil nil nil 7 nil nil nil 5360 3634 7 1 1 1 170 192 34 2 410 ##(Smalltalk.CheckBox) 34 16 nil 5360 34 2 8 1141055491 1 5472 1970 nil nil 2016 false nil nil 7 nil nil nil 5472 nil 8 1903885040 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 11 11 578 195 65 5472 962 #text: 34 1 8 'Match &case' 5472 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 8 #() 1184 nil 27 8 'matchCase' 1554 578 11 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 5360 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 1 5472 1184 nil 27 1184 nil 27 2306 2352 1 2784 1 2338 #fixedPreviousBottom 11 3552 1 170 192 34 4 1904 8 'prompt' 2416 8 'pattern' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 539 319 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 34 3 1904 2416 2816 1184 nil 27 170 192 2912 1554 578 11 1 578 11 1 nil nil nil nil 50925 nil nil 578 2049 397 578 761 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 898 138 144 34 3 962 #createAt:extent: 34 2 578 3839 21 578 761 397 416 962 #text: 34 1 8 'Find' 416 962 #updateMenuBar 2912 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 208 0 0 0] 34 2 1776 640 1184 nil 27 )!

showModeless: aView on: aFindDetails 
	(self createOn: aFindDetails)
		ownerView: aView;
		show! !
!AdvancedFindDialog class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!AdvancedFindDialog class categoriesFor: #defaultModel!models!public! !
!AdvancedFindDialog class categoriesFor: #icon!constants!public! !
!AdvancedFindDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!AdvancedFindDialog class categoriesFor: #resource_Directionless_view!public!resources-views! !
!AdvancedFindDialog class categoriesFor: #resource_Selector_view!public!resources-views! !
!AdvancedFindDialog class categoriesFor: #showModeless:on:!instance creation!public! !

