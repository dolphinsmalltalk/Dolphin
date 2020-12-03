"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'UI.AdvancedFindDialog'
	instanceVariableNames: 'patternPresenter wholeWordPresenter matchCasePresenter modePresenter directionPresenter actionButton closeButton flags validationBlock wrapPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'RegExpMask' -> 16r2.
		'WildCardMask' -> 16r1
	}!
UI.AdvancedFindDialog guid: (Core.GUID fromString: '{480e6494-8305-46d4-9ab9-8d3c9dafe358}')!
UI.AdvancedFindDialog comment: 'AdvancedFindDialog is a <valueDialogPresenter> replacement for the standard the Windows FindText common dialog (as wrapped by the FindDialog class). AdvancedFindDialog has additional setttings over and above those in the standard FindDialog. The dialog must be associated with an owner view capable of responding to the <textFinder> protocol. It will then remain on-screen until dismissed and will forward <FindEvent>s to the owner via its #onFind: event handler.

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
!UI.AdvancedFindDialog categoriesFor: #createComponents!initializing!public! !
!UI.AdvancedFindDialog categoriesFor: #findNext!commands!public! !
!UI.AdvancedFindDialog categoriesFor: #initialize!initializing!public! !
!UI.AdvancedFindDialog categoriesFor: #isRegExpEnabled!public!testing! !
!UI.AdvancedFindDialog categoriesFor: #isRegExpEnabled:!accessing!public! !
!UI.AdvancedFindDialog categoriesFor: #isValid!private!testing! !
!UI.AdvancedFindDialog categoriesFor: #isValidRegularExpression:!private!testing! !
!UI.AdvancedFindDialog categoriesFor: #isValidSearch:!private!testing! !
!UI.AdvancedFindDialog categoriesFor: #isWildCardEnabled!public!testing! !
!UI.AdvancedFindDialog categoriesFor: #isWildCardEnabled:!accessing!public! !
!UI.AdvancedFindDialog categoriesFor: #model:!accessing!public! !
!UI.AdvancedFindDialog categoriesFor: #onViewOpened!event handling!public! !
!UI.AdvancedFindDialog categoriesFor: #prompt:!accessing!public! !
!UI.AdvancedFindDialog categoriesFor: #queryCommand:!commands!private! !
!UI.AdvancedFindDialog categoriesFor: #searchMode!accessing!public! !
!UI.AdvancedFindDialog categoriesFor: #show!operations!public! !
!UI.AdvancedFindDialog categoriesFor: #showModal!public!realizing/unrealizing! !
!UI.AdvancedFindDialog categoriesFor: #validateUserInterface!operations!public! !
!UI.AdvancedFindDialog categoriesFor: #validationBlock!accessing!public! !
!UI.AdvancedFindDialog categoriesFor: #validationBlock:!accessing!public! !

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

	^FindDetails icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 17 1 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852806 1 ##(UI.FlowLayout) 1 11 1 170 192 34 4 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1141055488 1 768 nil nil nil 7 nil nil nil 768 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #ok 8 '&Find' 1 5 nil nil true nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 21 578 151 47 768 962 #isEnabled: 8 #(false) 768 962 #text: 34 1 8 '&Find' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 578 193 193 nil 29 8 'ok' 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1216 nil nil nil 7 nil nil nil 1216 nil 8 1920683440 850 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 77 578 151 47 1216 962 #text: 34 1 8 'C&lose' 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 1184 nil 29 8 'cancel' 1180166 ##(Graphics.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 789 1 578 161 319 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 34 2 768 1216 1184 nil 27 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 1048838 ##(UI.FramingLayout) 170 176 34 6 410 ##(UI.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 1904 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1904 nil 8 1920675248 1049094 ##(UI.NullConverter) nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 25 578 607 45 1904 962 #setMarginWidths: 34 1 8 #(3 3) 1904 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 8 #() 1184 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedPreviousRight 19 2290 #fixedParentRight -1 2290 #fixedPreviousTop -5 2290 #fixedViewTop 45 410 ##(UI.ContainerView) 34 15 nil 1776 34 2 8 1140850688 131073 2368 nil nil nil 7 nil nil nil 2368 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 79 578 741 221 2368 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 2368 34 2 8 1140850688 131073 2688 nil nil nil 7 nil nil nil 2688 1842 170 176 34 4 410 ##(UI.GroupBox) 34 14 nil 2688 34 2 8 1140850695 65 2800 nil nil nil 7 nil nil nil 2800 nil 8 1920683440 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 2800 962 #text: 34 1 8 'Search Mode' 2800 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2258 2290 #fixedParentLeft 1 2320 1 2290 #fixedParentTop 1 2290 #fixedParentBottom 1 410 ##(UI.ContainerView) 34 15 nil 2688 34 2 8 1140850688 131073 3152 nil nil nil 7 nil nil nil 3152 852998 ##(UI.GridLayout) 7 1 1 1 170 192 34 6 410 ##(UI.RadioButton) 34 16 nil 3152 34 2 8 1140989961 1 3280 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 3280 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 255 53 3280 962 #text: 34 1 8 '&Text' 3280 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1184 nil 27 8 'text' 410 ##(UI.RadioButton) 34 16 nil 3152 34 2 8 1140858889 1 3744 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 3744 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 255 53 3744 962 #text: 34 1 8 '&Regular Expression' 3744 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1184 nil 27 8 'regularExpression' 410 ##(UI.RadioButton) 34 16 nil 3152 34 2 8 1140858889 1 4160 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 4160 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 255 53 4160 962 #text: 34 1 8 '&Wildcard Expression' 4160 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1184 nil 27 8 'wildcardExpression' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 33 578 255 157 3152 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 3280 4160 3744 1184 nil 27 2258 3104 19 2320 -7 3120 33 3136 -11 170 192 34 2 3152 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 2688 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 2800 3152 1184 nil 27 410 ##(UI.ContainerView) 34 15 nil 2368 34 2 8 1140850688 131073 4960 nil nil nil 7 nil nil nil 4960 1842 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 4960 34 2 8 1140850688 131073 5072 nil nil nil 7 nil nil nil 5072 706 1 11 1 170 192 34 4 410 ##(UI.CheckBox) 34 16 nil 5072 34 2 8 1140924419 1 5184 3346 nil nil 1441798 ##(Kernel.NeverSearchPolicy) false nil nil 519 nil nil nil 5184 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 165 43 5184 962 #text: 34 1 8 '&Case' 5184 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 82 0 0 0 47 0 0 0] 8 #() 1184 nil 27 8 'matchCase' 410 ##(UI.CheckBox) 34 16 nil 5072 34 2 8 1141058819 1 5552 3346 nil nil 5280 false nil nil 7 nil nil nil 5552 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 161 43 5552 962 #text: 34 1 8 '&Whole word' 5552 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'matchWhole' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 23 35 578 165 151 5072 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 34 2 5552 5184 1184 nil 27 2258 3104 23 2320 -17 3120 35 3136 -15 410 ##(UI.GroupBox) 34 14 nil 4960 34 2 8 1140850695 65 6064 nil nil nil 7 nil nil nil 6064 nil 8 1920683440 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 205 201 6064 962 #text: 34 1 8 'Match' 6064 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2258 3104 1 2320 1 3120 1 3136 1 170 192 2464 nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 4960 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 6064 5072 1184 nil 27 410 ##(UI.ContainerView) 34 15 nil 2368 34 2 8 1140850688 131073 6544 nil nil nil 7 nil nil nil 6544 1842 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 6544 34 2 8 1140850688 131073 6656 nil nil nil 7 nil nil nil 6656 706 1 11 1 170 192 34 6 410 ##(UI.RadioButton) 34 16 nil 6656 34 2 8 1141055497 1 6768 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 6768 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 81 43 6768 962 #text: 34 1 8 '&Up' 6768 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'up' 410 ##(UI.CheckBox) 34 16 nil 6656 34 2 8 1140924419 1 7184 3346 nil nil 5280 false nil nil 7 nil nil nil 7184 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 181 43 7184 962 #text: 34 1 8 '&Wrap around' 7184 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 8 #() 1184 nil 27 8 'wrap' 410 ##(UI.RadioButton) 34 16 nil 6656 34 2 8 1140858889 1 7520 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 7520 nil 8 1920683440 2018 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 81 1 578 97 43 7520 962 #text: 34 1 8 '&Down' 7520 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 8 #() 1184 nil 27 8 'down' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 33 578 191 151 6656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 34 3 6768 7520 7184 1184 nil 27 2258 3104 19 2320 -11 3120 33 3136 -17 410 ##(UI.GroupBox) 34 14 nil 6544 34 2 8 1140850695 65 8112 nil nil nil 7 nil nil nil 8112 nil 8 1920683440 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 221 201 8112 962 #text: 34 1 8 'Direction' 8112 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 8 #() 1184 nil 27 2258 3104 1 2320 1 3120 1 3136 1 170 192 34 2 6656 8 'direction' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 517 11 578 221 201 6544 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 34 2 8112 6656 1184 nil 27 1184 nil 27 2258 3104 1 2320 1 2290 #fixedPreviousBottom 11 3136 1 410 ##(UI.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 8656 3346 nil nil 5280 8 '' nil nil 7 nil nil nil 8656 nil 8 1920531648 2018 nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 41 8656 962 #text: 34 1 8 'Fi&nd what:' 8656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 8 #() 1184 nil 27 2258 3104 5 2290 #fixedViewLeft 111 3120 1 2352 41 170 192 34 4 1904 8 'pattern' 8656 8 'prompt' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 763 319 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 34 3 8656 1904 2368 1184 nil 27 170 192 2464 1554 578 11 1 578 11 1 nil nil nil nil 23333 nil nil 578 2049 397 578 991 397 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 898 138 144 34 2 962 #createAt:extent: 34 2 578 6143 21 578 991 397 416 962 #text: 34 1 8 'Find' 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 238 13 0 0 208 0 0 0] 34 2 1776 640 1184 nil 27)!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 11 1 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852806 1 ##(UI.FlowLayout) 1 11 1 170 192 34 4 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140858880 1 768 nil nil nil 7 nil nil nil 768 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 77 578 151 47 768 962 #text: 34 1 8 'C&lose' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 578 193 193 nil 29 8 'cancel' 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1141055488 1 1184 nil nil nil 7 nil nil nil 1184 nil 8 1920683440 850 #ok 8 '&Find' 1 5 nil nil true nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 578 1 21 578 151 47 1184 962 #isEnabled: 8 #(false) 1184 962 #text: 34 1 8 '&Find' 1184 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1152 nil 29 8 'ok' 1180166 ##(Graphics.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 549 1 578 161 319 640 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 34 2 1184 768 1152 nil 27 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 1048838 ##(UI.FramingLayout) 170 176 34 6 410 ##(UI.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 1904 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1904 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 31 1904 962 #text: 34 1 8 'Fi&nd what:' 1904 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1152 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 5 2338 #fixedViewLeft 111 2338 #fixedParentTop 1 2338 #fixedViewTop 31 410 ##(UI.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 2416 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 2416 nil 8 1920675248 2066 nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 25 578 371 45 2416 962 #setMarginWidths: 34 1 8 #(3 3) 2416 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 8 #() 1152 nil 27 2306 2338 #fixedPreviousRight 19 2338 #fixedParentRight -3 2338 #fixedPreviousTop -5 2400 45 410 ##(UI.ContainerView) 34 15 nil 1776 34 2 8 1140850688 131073 2816 nil nil nil 7 nil nil nil 2816 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 79 578 507 221 2816 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 34 2 410 ##(UI.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 3136 nil nil nil 7 nil nil nil 3136 1842 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 3136 34 2 8 1140850688 131073 3248 nil nil nil 7 nil nil nil 3248 852998 ##(UI.GridLayout) 7 1 1 1 170 192 34 6 410 ##(UI.RadioButton) 34 16 nil 3248 34 2 8 1140858889 1 3376 1970 nil nil 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 3376 nil 8 1920683440 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 253 53 3376 962 #text: 34 1 8 '&Wildcard Expression' 3376 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 8 #() 1152 nil 27 8 'wildcardExpression' 410 ##(UI.RadioButton) 34 16 nil 3248 34 2 8 1140858889 1 3824 1970 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 3824 nil 8 1920683440 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 253 53 3824 962 #text: 34 1 8 '&Regular Expression' 3824 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 8 #() 1152 nil 27 8 'regularExpression' 410 ##(UI.RadioButton) 34 16 nil 3248 34 2 8 1141055497 1 4240 1970 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 4240 nil 8 1920683440 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 253 53 4240 962 #text: 34 1 8 '&Text' 4240 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 8 #() 1152 nil 27 8 'text' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 21 33 578 253 157 3248 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 4240 3376 3824 1152 nil 27 2306 2352 21 2784 -7 2384 33 2338 #fixedParentBottom -11 410 ##(UI.GroupBox) 34 14 nil 3136 34 2 8 1140850695 65 4848 nil nil nil 7 nil nil nil 4848 nil 8 1920683440 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 4848 962 #text: 34 1 8 'Search Mode' 4848 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1152 nil 27 2306 2352 1 2784 1 2384 1 4832 1 170 192 34 2 3248 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 3136 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 4848 3248 1152 nil 27 410 ##(UI.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 5360 nil nil nil 7 nil nil nil 5360 1842 170 176 34 4 410 ##(UI.GroupBox) 34 14 nil 5360 34 2 8 1140850695 65 5472 nil nil nil 7 nil nil nil 5472 nil 8 1920683440 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 205 201 5472 962 #text: 34 1 8 'Match' 5472 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1152 nil 27 2306 2352 1 2784 1 2384 1 4832 1 410 ##(UI.ContainerView) 34 15 nil 5360 34 2 8 1140850688 131073 5776 nil nil nil 7 nil nil nil 5776 3314 7 1 1 1 170 192 34 4 410 ##(UI.CheckBox) 34 16 nil 5776 34 2 8 1141055491 1 5888 1970 nil nil 2016 false nil nil 7 nil nil nil 5888 nil 8 1920683440 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 175 51 5888 962 #text: 34 1 8 '&Whole word' 5888 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 8 #() 1152 nil 27 8 'matchWhole' 410 ##(UI.CheckBox) 34 16 nil 5776 34 2 8 1140858883 1 6224 1970 nil nil 2016 false nil nil 7 nil nil nil 6224 nil 8 1920683440 2066 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 51 578 175 53 6224 962 #text: 34 1 8 '&Case' 6224 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 8 #() 1152 nil 27 8 'matchCase' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 35 578 175 153 5776 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 34 2 5888 6224 1152 nil 27 2306 2352 19 2784 -11 2384 35 4832 -13 170 192 2912 nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 5360 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 5472 5776 1152 nil 27 1152 nil 27 2306 2352 1 2784 1 2338 #fixedPreviousBottom 11 4832 1 170 192 34 4 1904 8 'prompt' 2416 8 'pattern' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 529 319 1776 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 34 3 1904 2416 2816 1152 nil 27 170 192 2912 1554 578 11 1 578 11 1 nil nil nil nil 23525 nil nil 578 2049 397 578 751 397 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 898 138 144 34 2 962 #createAt:extent: 34 2 578 6143 21 578 751 397 416 962 #text: 34 1 8 'Find' 416 1090 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 118 13 0 0 208 0 0 0] 34 2 1776 640 1152 nil 27)!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 11 1 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852806 1 ##(UI.FlowLayout) 1 11 1 170 192 34 4 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil nil nil 7 nil nil nil 768 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 77 578 151 47 768 962 #text: 34 1 8 'C&lose' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 578 193 193 nil 29 8 'cancel' 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1141055488 1 1184 nil nil nil 7 nil nil nil 1184 nil 8 1920683440 850 #ok 8 '&Find' 1 5 nil nil true nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 578 1 21 578 151 47 1184 962 #isEnabled: 8 #(false) 1184 962 #text: 34 1 8 '&Find' 1184 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1152 nil 29 8 'ok' 1180166 ##(Graphics.Rectangle) 578 1 21 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 559 1 578 161 319 640 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 34 2 1184 768 1152 nil 27 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 1048838 ##(UI.FramingLayout) 170 176 34 6 410 ##(UI.ContainerView) 34 15 nil 1776 34 2 8 1140916224 131073 1904 nil nil nil 7 nil nil nil 1904 706 17 1 1 170 192 8 #() 1554 578 1 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 13 83 578 517 217 1904 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 34 2 410 ##(UI.ContainerView) 34 15 nil 1904 34 2 8 1140916224 131073 2224 nil nil nil 7 nil nil nil 2224 1842 170 176 34 4 410 ##(UI.GroupBox) 34 14 nil 2224 34 2 8 1140850695 65 2336 nil nil nil 7 nil nil nil 2336 nil 8 1920683440 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 281 201 2336 962 #text: 34 1 8 'Search Mode' 2336 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1152 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 2658 #fixedParentRight 1 2658 #fixedParentTop 1 2658 #fixedParentBottom 1 410 ##(UI.ContainerView) 34 15 nil 2224 34 2 8 1140916224 131073 2736 nil nil nil 7 nil nil nil 2736 852998 ##(UI.GridLayout) 7 1 1 1 170 192 34 6 410 ##(UI.RadioButton) 34 16 nil 2736 34 2 8 1141055497 1 2864 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 2994 #hash 8 #() false nil nil 7 nil nil nil 2864 nil 8 1920683440 1049094 ##(UI.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 255 53 2864 962 #text: 34 1 8 '&Text' 2864 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1152 nil 27 8 'text' 410 ##(UI.RadioButton) 34 16 nil 2736 34 2 8 1140924425 1 3344 2930 nil nil 2962 2994 #= 8 #() 2994 #hash 8 #() false nil nil 7 nil nil nil 3344 nil 8 1920683440 3090 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 53 578 255 53 3344 962 #text: 34 1 8 '&Wildcard Expression' 3344 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1152 nil 27 8 'wildcardExpression' 410 ##(UI.RadioButton) 34 16 nil 2736 34 2 8 1140924425 1 3760 2930 nil nil 2962 2994 #= 8 #() 2994 #hash 8 #() false nil nil 7 nil nil nil 3760 nil 8 1920683440 3090 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 105 578 255 53 3760 962 #text: 34 1 8 '&Regular Expression' 3760 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1152 nil 27 8 'regularExpression' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 19 31 578 255 157 2736 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 34 3 2864 3344 3760 1152 nil 27 2626 2672 19 2688 -7 2704 31 2720 -13 170 192 34 2 2736 8 'mode' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 11 578 281 201 2224 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 2336 2736 1152 nil 27 410 ##(UI.ContainerView) 34 15 nil 1904 34 2 8 1140850688 131073 4560 nil nil nil 7 nil nil nil 4560 2802 7 1 1 1 170 192 34 2 410 ##(UI.CheckBox) 34 16 nil 4560 34 2 8 1141055491 1 4672 2930 nil nil 1441798 ##(Kernel.NeverSearchPolicy) false nil nil 7 nil nil nil 4672 nil 8 1920683440 3090 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 11 11 578 195 65 4672 962 #text: 34 1 8 'Match &case' 4672 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 8 #() 1152 nil 27 8 'matchCase' 1554 578 11 11 578 1 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 297 11 578 205 201 4560 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 1 4672 1152 nil 27 1152 nil 27 2626 2672 1 2688 1 2658 #fixedPreviousBottom 11 2720 1 410 ##(UI.StaticText) 34 16 nil 1776 34 2 8 1140850944 1 5280 2930 nil nil 4768 8 '' nil nil 7 nil nil nil 5280 nil 8 1920531648 3090 nil nil true 898 138 144 34 2 962 #createAt:extent: 34 2 578 17 31 578 111 31 5280 962 #text: 34 1 8 'Fi&nd what:' 5280 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1152 nil 27 2626 2672 5 2658 #fixedViewLeft 111 2704 1 2658 #fixedViewTop 31 410 ##(UI.TextEdit) 34 16 nil 1776 34 2 8 1141047424 1025 5664 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 5664 nil 8 1920675248 3090 nil nil 5 898 138 144 34 2 962 #createAt:extent: 34 2 578 145 29 578 371 45 5664 962 #setMarginWidths: 34 1 8 #(3 3) 5664 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 8 #() 1152 nil 27 2626 2658 #fixedPreviousRight 19 2688 -13 2658 #fixedPreviousTop -1 5648 45 170 192 34 4 5280 8 'prompt' 5664 8 'pattern' 1554 578 13 31 578 11 21 898 138 144 34 1 962 #createAt:extent: 34 2 578 11 1 578 539 319 1776 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 34 3 5280 5664 1904 1152 nil 27 170 192 2000 1554 578 11 1 578 11 1 nil nil nil nil 23705 nil nil 578 2049 397 578 761 397 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 898 138 144 34 2 962 #createAt:extent: 34 2 578 6143 21 578 761 397 416 962 #text: 34 1 8 'Find' 416 1090 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 208 0 0 0] 34 2 1776 640 1152 nil 27)!

showModeless: aView on: aFindDetails 
	(self createOn: aFindDetails)
		ownerView: aView;
		show! !
!UI.AdvancedFindDialog class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!UI.AdvancedFindDialog class categoriesFor: #defaultModel!models!public! !
!UI.AdvancedFindDialog class categoriesFor: #icon!constants!public! !
!UI.AdvancedFindDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.AdvancedFindDialog class categoriesFor: #resource_Directionless_view!public!resources-views! !
!UI.AdvancedFindDialog class categoriesFor: #resource_Selector_view!public!resources-views! !
!UI.AdvancedFindDialog class categoriesFor: #showModeless:on:!instance creation!public! !

