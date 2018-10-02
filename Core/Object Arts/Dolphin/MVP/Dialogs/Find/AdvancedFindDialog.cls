"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #AdvancedFindDialog
	instanceVariableNames: 'patternPresenter wholeWordPresenter matchCasePresenter modePresenter directionPresenter actionButton closeButton flags validationBlock wrapPresenter'
	classVariableNames: 'RegExpMask WildCardMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
	flags := FindDetails regexpClass isNil ifTrue: [0] ifFalse: [RegExpMask].
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

	^FindDetails new!

icon
	"Answers an Icon that can be used to represent this class"

	^FindDetails icon!

initialize
	WildCardMask := 1.
	RegExpMask := 2.!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 17 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1141055488 1 768 nil nil nil 5 nil nil nil 768 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Find' 1 5 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 21 578 151 47 768 962 #isEnabled: 8 #(false) 768 962 #text: 34 1 8 '&Find' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 578 193 193 nil 29 8 'ok' 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1216 nil nil nil 5 nil nil nil 1216 nil 8 1915188384 850 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 77 578 151 47 1216 962 #text: 34 1 8 'C&lose' 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 1184 nil 29 8 'cancel' 590342 ##(Smalltalk.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 789 1 578 161 319 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 34 2 768 1216 1184 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 5 nil nil nil 1776 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 1904 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1904 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 25 578 607 45 1904 962 #setMarginWidths: 34 1 8 #(3 3) 1904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 8 #() 1184 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 19 2306 #fixedParentRight -1 2306 #fixedPreviousTop -5 2306 #fixedViewTop 45 410 ##(Smalltalk.ContainerView) 34 15 nil 1776 34 2 8 1140850688 131073 2384 nil nil nil 5 nil nil nil 2384 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 79 578 741 221 2384 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2384 34 2 8 1140850688 131073 2704 nil nil nil 5 nil nil nil 2704 1842 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 2704 34 2 8 1140850688 131073 2816 nil nil nil 5 nil nil nil 2816 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 2816 34 2 8 1140858889 1 2944 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3074 #hash 8 #() false nil nil 5 nil nil nil 2944 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 255 53 2944 962 #text: 34 1 8 '&Regular Expression' 2944 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1184 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 2816 34 2 8 1140989961 1 3408 3010 nil nil 3042 3074 #= 8 #() 3074 #hash 8 #() false nil nil 5 nil nil nil 3408 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 255 53 3408 962 #text: 34 1 8 '&Text' 3408 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1184 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 2816 34 2 8 1140858889 1 3824 3010 nil nil 3042 3074 #= 8 #() 3074 #hash 8 #() false nil nil 5 nil nil nil 3824 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 255 53 3824 962 #text: 34 1 8 '&Wildcard Expression' 3824 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1184 nil 27 8 'wildcardExpression' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 33 578 255 157 2816 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 3408 3824 2944 1184 nil 27 2274 2306 #fixedParentLeft 19 2336 -7 2306 #fixedParentTop 33 2306 #fixedParentBottom -11 410 ##(Smalltalk.GroupBox) 34 14 nil 2704 34 2 8 1140850695 65 4464 nil nil nil 5 nil nil nil 4464 nil 8 1915188384 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 4464 962 #text: 34 1 8 'Search Mode' 4464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2274 4416 1 2336 1 4432 1 4448 1 170 192 34 2 2816 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 2704 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 4464 2816 1184 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2384 34 2 8 1140850688 131073 4976 nil nil nil 5 nil nil nil 4976 1842 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 4976 34 2 8 1140850695 65 5088 nil nil nil 5 nil nil nil 5088 nil 8 1915188384 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 205 201 5088 962 #text: 34 1 8 'Match' 5088 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2274 4416 1 2336 1 4432 1 4448 1 410 ##(Smalltalk.ContainerView) 34 15 nil 4976 34 2 8 1140850688 131073 5392 nil nil nil 5 nil nil nil 5392 706 1 11 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 5392 34 2 8 1141058819 1 5504 3010 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 5504 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 161 43 5504 962 #text: 34 1 8 '&Whole word' 5504 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'matchWhole' 410 ##(Smalltalk.CheckBox) 34 16 nil 5392 34 2 8 1140924419 1 5872 3010 nil nil 5600 false nil nil 517 nil nil nil 5872 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 165 43 5872 962 #text: 34 1 8 '&Case' 5872 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 82 0 0 0 47 0 0 0] 8 #() 1184 nil 27 8 'matchCase' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 23 35 578 165 151 5392 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 34 2 5504 5872 1184 nil 27 2274 4416 23 2336 -17 4432 35 4448 -15 170 192 2480 nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 4976 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 5088 5392 1184 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2384 34 2 8 1140850688 131073 6560 nil nil nil 5 nil nil nil 6560 1842 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 6560 34 2 8 1140850695 65 6672 nil nil nil 5 nil nil nil 6672 nil 8 1915188384 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 221 201 6672 962 #text: 34 1 8 'Direction' 6672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2274 4416 1 2336 1 4432 1 4448 1 410 ##(Smalltalk.ContainerView) 34 15 nil 6560 34 2 8 1140850688 131073 6976 nil nil nil 5 nil nil nil 6976 706 1 11 1 170 192 34 6 410 ##(Smalltalk.CheckBox) 34 16 nil 6976 34 2 8 1140924419 1 7088 3010 nil nil 5600 false nil nil 5 nil nil nil 7088 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 181 43 7088 962 #text: 34 1 8 '&Wrap around' 7088 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 8 #() 1184 nil 27 8 'wrap' 410 ##(Smalltalk.RadioButton) 34 16 nil 6976 34 2 8 1140858889 1 7424 3010 nil nil 3042 3074 #= 8 #() 3074 #hash 8 #() false nil nil 5 nil nil nil 7424 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 81 1 578 97 43 7424 962 #text: 34 1 8 '&Down' 7424 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'down' 410 ##(Smalltalk.RadioButton) 34 16 nil 6976 34 2 8 1141055497 1 7840 3010 nil nil 3042 3074 #= 8 #() 3074 #hash 8 #() false nil nil 5 nil nil nil 7840 nil 8 1915188384 2034 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 81 43 7840 962 #text: 34 1 8 '&Up' 7840 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'up' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 33 578 191 151 6976 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 34 3 7840 7424 7088 1184 nil 27 2274 4416 19 2336 -11 4432 33 4448 -17 170 192 34 2 6976 8 'direction' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 517 11 578 221 201 6560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 34 2 6672 6976 1184 nil 27 1184 nil 27 2274 4416 1 2336 1 2306 #fixedPreviousBottom 11 4448 1 410 ##(Smalltalk.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 8672 3010 nil nil 5600 8 '' nil nil 5 nil nil nil 8672 nil 8 1915124368 2034 nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 41 8672 962 #text: 34 1 8 'Fi&nd what:' 8672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 8 #() 1184 nil 27 2274 4416 5 2306 #fixedViewLeft 111 4432 1 2368 41 170 192 34 4 1904 8 'pattern' 8672 8 'prompt' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 763 319 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 34 3 8672 1904 2384 1184 nil 27 170 192 2480 1554 578 11 1 578 11 1 nil nil nil nil 9471 nil nil 578 2049 397 578 991 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 898 138 144 34 3 962 #createAt:extent: 34 2 578 1425 883 578 991 397 416 962 #text: 34 1 8 'Find' 416 962 #updateMenuBar 2480 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 2 0 0 185 1 0 0 183 4 0 0 127 2 0 0] 34 2 1776 640 1184 nil 27 )!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140858880 1 768 nil nil nil 5 nil nil nil 768 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 77 578 151 47 768 962 #text: 34 1 8 'C&lose' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 578 193 193 nil 29 8 'cancel' 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1141055488 1 1184 nil nil nil 5 nil nil nil 1184 nil 8 1915188384 850 #ok 8 '&Find' 1 5 nil nil true nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 578 1 21 578 151 47 1184 962 #isEnabled: 8 #(false) 1184 962 #text: 34 1 8 '&Find' 1184 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1152 nil 29 8 'ok' 590342 ##(Smalltalk.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 549 1 578 161 319 640 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 34 2 1184 768 1152 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 5 nil nil nil 1776 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.ContainerView) 34 15 nil 1776 34 2 8 1140850688 131073 1904 nil nil nil 5 nil nil nil 1904 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 79 578 507 221 1904 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 1904 34 2 8 1140850688 131073 2224 nil nil nil 5 nil nil nil 2224 1842 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 2224 34 2 8 1140850695 65 2336 nil nil nil 5 nil nil nil 2336 nil 8 1915188384 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 2336 962 #text: 34 1 8 'Search Mode' 2336 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1152 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2658 #fixedParentRight 1 2658 #fixedParentTop 1 2658 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2224 34 2 8 1140850688 131073 2736 nil nil nil 5 nil nil nil 2736 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 2736 34 2 8 1140858889 1 2864 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2994 #hash 8 #() false nil nil 5 nil nil nil 2864 nil 8 1915188384 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 253 53 2864 962 #text: 34 1 8 '&Regular Expression' 2864 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 8 #() 1152 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 2736 34 2 8 1141055497 1 3344 2930 nil nil 2962 2994 #= 8 #() 2994 #hash 8 #() false nil nil 5 nil nil nil 3344 nil 8 1915188384 3090 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 253 53 3344 962 #text: 34 1 8 '&Text' 3344 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 8 #() 1152 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 2736 34 2 8 1140858889 1 3760 2930 nil nil 2962 2994 #= 8 #() 2994 #hash 8 #() false nil nil 5 nil nil nil 3760 nil 8 1915188384 3090 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 253 53 3760 962 #text: 34 1 8 '&Wildcard Expression' 3760 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 8 #() 1152 nil 27 8 'wildcardExpression' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 21 33 578 253 157 2736 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 3344 3760 2864 1152 nil 27 2626 2672 21 2688 -7 2704 33 2720 -11 170 192 34 2 2736 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 2224 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 2336 2736 1152 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 1904 34 2 8 1140850688 131073 4560 nil nil nil 5 nil nil nil 4560 1842 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 4560 34 2 8 1140850688 131073 4672 nil nil nil 5 nil nil nil 4672 2802 7 1 1 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 4672 34 2 8 1140858883 1 4784 2930 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 4784 nil 8 1915188384 3090 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 51 578 175 53 4784 962 #text: 34 1 8 '&Case' 4784 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 8 #() 1152 nil 27 8 'matchCase' 410 ##(Smalltalk.CheckBox) 34 16 nil 4672 34 2 8 1141055491 1 5152 2930 nil nil 4880 false nil nil 5 nil nil nil 5152 nil 8 1915188384 3090 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 175 51 5152 962 #text: 34 1 8 '&Whole word' 5152 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 8 #() 1152 nil 27 8 'matchWhole' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 35 578 175 153 4672 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 34 2 5152 4784 1152 nil 27 2626 2672 19 2688 -11 2704 35 2720 -13 410 ##(Smalltalk.GroupBox) 34 14 nil 4560 34 2 8 1140850695 65 5664 nil nil nil 5 nil nil nil 5664 nil 8 1915188384 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 205 201 5664 962 #text: 34 1 8 'Match' 5664 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1152 nil 27 2626 2672 1 2688 1 2704 1 2720 1 170 192 2000 nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 4560 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 5664 4672 1152 nil 27 1152 nil 27 2626 2672 1 2688 1 2658 #fixedPreviousBottom 11 2720 1 410 ##(Smalltalk.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 6176 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 6176 nil 8 1915280032 3090 nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 25 578 371 45 6176 962 #setMarginWidths: 34 1 8 #(3 3) 6176 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 8 #() 1152 nil 27 2626 2658 #fixedPreviousRight 19 2688 -3 2658 #fixedPreviousTop -5 2658 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 6592 2930 nil nil 4880 8 '' nil nil 5 nil nil nil 6592 nil 8 1915124368 3090 nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 31 6592 962 #text: 34 1 8 'Fi&nd what:' 6592 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1152 nil 27 2626 2672 5 2658 #fixedViewLeft 111 2704 1 6576 31 170 192 34 4 6176 8 'pattern' 6592 8 'prompt' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 529 319 1776 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 34 3 6592 6176 1904 1152 nil 27 170 192 2000 1554 578 11 1 578 11 1 nil nil nil nil 9505 nil nil 578 2049 397 578 751 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 898 138 144 34 3 962 #createAt:extent: 34 2 578 1545 883 578 751 397 416 962 #text: 34 1 8 'Find' 416 962 #updateMenuBar 2000 416 1090 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 3 0 0 185 1 0 0 123 4 0 0 127 2 0 0] 34 2 1776 640 1152 nil 27 )!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil nil nil 5 nil nil nil 768 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 1 77 578 151 47 768 962 #text: 34 1 8 'C&lose' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 578 193 193 nil 29 8 'cancel' 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1141055488 1 1184 nil nil nil 5 nil nil nil 1184 nil 8 1915188384 850 #ok 8 '&Find' 1 5 nil nil true nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 578 1 21 578 151 47 1184 962 #isEnabled: 8 #(false) 1184 962 #text: 34 1 8 '&Find' 1184 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1152 nil 29 8 'ok' 590342 ##(Smalltalk.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 559 1 578 161 319 640 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 34 2 1184 768 1152 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 5 nil nil nil 1776 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.ContainerView) 34 15 nil 1776 34 2 8 1140916224 131073 1904 nil nil nil 5 nil nil nil 1904 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 83 578 517 217 1904 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 1904 34 2 8 1140916224 131073 2224 nil nil nil 5 nil nil nil 2224 1842 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 2224 34 2 8 1140916224 131073 2336 nil nil nil 5 nil nil nil 2336 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 2336 34 2 8 1141055497 1 2464 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2594 #hash 8 #() false nil nil 5 nil nil nil 2464 nil 8 1915188384 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 255 53 2464 962 #text: 34 1 8 '&Text' 2464 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1152 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 2336 34 2 8 1140924425 1 2944 2530 nil nil 2562 2594 #= 8 #() 2594 #hash 8 #() false nil nil 5 nil nil nil 2944 nil 8 1915188384 2690 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 255 53 2944 962 #text: 34 1 8 '&Regular Expression' 2944 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1152 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 2336 34 2 8 1140924425 1 3360 2530 nil nil 2562 2594 #= 8 #() 2594 #hash 8 #() false nil nil 5 nil nil nil 3360 nil 8 1915188384 2690 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 255 53 3360 962 #text: 34 1 8 '&Wildcard Expression' 3360 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1152 nil 27 8 'wildcardExpression' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 31 578 255 157 2336 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 34 3 2464 3360 2944 1152 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 19 3970 #fixedParentRight -7 3970 #fixedParentTop 31 3970 #fixedParentBottom -13 410 ##(Smalltalk.GroupBox) 34 14 nil 2224 34 2 8 1140850695 65 4048 nil nil nil 5 nil nil nil 4048 nil 8 1915188384 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 4048 962 #text: 34 1 8 'Search Mode' 4048 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1152 nil 27 3938 3984 1 4000 1 4016 1 4032 1 170 192 34 2 2336 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 2224 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 4048 2336 1152 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 1904 34 2 8 1140850688 131073 4560 nil nil nil 5 nil nil nil 4560 2402 7 1 1 1 170 192 34 2 410 ##(Smalltalk.CheckBox) 34 16 nil 4560 34 2 8 1141055491 1 4672 2530 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 4672 nil 8 1915188384 2690 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 11 11 578 195 65 4672 962 #text: 34 1 8 'Match &case' 4672 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 8 #() 1152 nil 27 8 'matchCase' 1554 578 11 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 4560 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 1 4672 1152 nil 27 1152 nil 27 3938 3984 1 4000 1 3970 #fixedPreviousBottom 11 4032 1 410 ##(Smalltalk.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 5280 2530 nil nil 4768 8 '' nil nil 5 nil nil nil 5280 nil 8 1915124368 2690 nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 31 5280 962 #text: 34 1 8 'Fi&nd what:' 5280 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1152 nil 27 3938 3984 5 3970 #fixedViewLeft 111 4016 1 3970 #fixedViewTop 31 410 ##(Smalltalk.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 5664 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 5664 nil 8 1915280032 2690 nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 29 578 371 45 5664 962 #setMarginWidths: 34 1 8 #(3 3) 5664 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 8 #() 1152 nil 27 3938 3970 #fixedPreviousRight 19 4000 -13 3970 #fixedPreviousTop -1 5648 45 170 192 34 4 5280 8 'prompt' 5664 8 'pattern' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 539 319 1776 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 34 3 5280 5664 1904 1152 nil 27 170 192 2000 1554 578 11 1 578 11 1 nil nil nil nil 9533 nil nil 578 2049 397 578 761 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 898 138 144 34 3 962 #createAt:extent: 34 2 578 1541 883 578 761 397 416 962 #text: 34 1 8 'Find' 416 962 #updateMenuBar 2000 416 1090 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 3 0 0 185 1 0 0 126 4 0 0 127 2 0 0] 34 2 1776 640 1152 nil 27 )!

showModeless: aView on: aFindDetails 
	(self createOn: aFindDetails)
		ownerView: aView;
		show! !
!AdvancedFindDialog class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!AdvancedFindDialog class categoriesFor: #defaultModel!models!public! !
!AdvancedFindDialog class categoriesFor: #icon!constants!public! !
!AdvancedFindDialog class categoriesFor: #initialize!initializing!public! !
!AdvancedFindDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!AdvancedFindDialog class categoriesFor: #resource_Directionless_view!public!resources-views! !
!AdvancedFindDialog class categoriesFor: #resource_Selector_view!public!resources-views! !
!AdvancedFindDialog class categoriesFor: #showModeless:on:!instance creation!public! !

