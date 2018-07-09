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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 17 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 784 nil nil nil 7 nil nil nil 784 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 1 77 594 151 47 784 978 #text: 34 1 8 'C&lose' 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 594 193 193 nil 29 8 'cancel' 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1141055488 1 1200 nil nil nil 7 nil nil nil 1200 nil 8 1906824432 866 #ok 8 '&Find' 1 5 nil nil true nil nil nil 914 138 144 34 3 978 #createAt:extent: 34 2 594 1 21 594 151 47 1200 978 #isEnabled: 8 #(false) 1200 978 #text: 34 1 8 '&Find' 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1168 nil 29 8 'ok' 590342 ##(Smalltalk.Rectangle) 594 1 21 594 1 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 789 1 594 161 313 656 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 1 0 0 0 0 0 0 218 1 0 0 156 0 0 0] 34 2 1200 784 1168 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1792 nil nil nil 7 nil nil nil 1792 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.TextEdit) 34 16 nil 1792 34 2 8 1141047424 1025 1920 nil 466 496 nil 7 nil nil nil 1920 nil 8 1906818384 852486 ##(Smalltalk.NullConverter) nil nil 5 914 138 144 34 2 978 #createAt:extent: 34 2 594 145 25 594 607 45 1920 978 #setMarginWidths: 34 1 8 #(3 3) 1920 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 8 #() 1168 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 19 2290 #fixedParentRight -1 2290 #fixedPreviousTop -5 2290 #fixedViewTop 45 410 ##(Smalltalk.ContainerView) 34 15 nil 1792 34 2 8 1140850688 131073 2368 nil nil nil 7 nil nil nil 2368 722 17 1 1 170 192 8 #() 1570 594 1 11 594 1 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 13 79 594 741 215 2368 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 120 1 0 0 146 0 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2368 34 2 8 1140850688 131073 2688 nil nil nil 7 nil nil nil 2688 1858 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 2688 34 2 8 1140850695 65 2800 nil nil nil 7 nil nil nil 2800 nil 8 1906824432 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 281 201 2800 978 #text: 34 1 8 'Search Mode' 2800 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1168 nil 27 2258 2290 #fixedParentLeft 1 2320 1 2290 #fixedParentTop 1 2290 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2688 34 2 8 1140850688 131073 3152 nil nil nil 7 nil nil nil 3152 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 3152 34 2 8 1140858889 1 3280 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 3280 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 105 594 255 53 3280 978 #text: 34 1 8 '&Regular Expression' 3280 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1168 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3152 34 2 8 1140989961 1 3744 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 3744 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 255 53 3744 978 #text: 34 1 8 '&Text' 3744 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1168 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 3152 34 2 8 1140858889 1 4160 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 4160 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 53 594 255 53 4160 978 #text: 34 1 8 '&Wildcard Expression' 4160 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1168 nil 27 8 'wildcardExpression' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 19 33 594 255 157 3152 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 3744 4160 3280 1168 nil 27 2258 3104 19 2320 -7 3120 33 3136 -11 170 192 34 2 3152 8 'mode' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 11 594 281 201 2688 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 2800 3152 1168 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2368 34 2 8 1140850688 131073 4960 nil nil nil 7 nil nil nil 4960 1858 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 4960 34 2 8 1140850695 65 5072 nil nil nil 7 nil nil nil 5072 nil 8 1906824432 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 205 201 5072 978 #text: 34 1 8 'Match' 5072 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1168 nil 27 2258 3104 1 2320 1 3120 1 3136 1 410 ##(Smalltalk.ContainerView) 34 15 nil 4960 34 2 8 1140850688 131073 5376 nil nil nil 7 nil nil nil 5376 722 1 11 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 5376 34 2 8 1140924419 1 5488 3346 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 519 nil nil nil 5488 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 53 594 165 43 5488 978 #text: 34 1 8 '&Case' 5488 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 82 0 0 0 47 0 0 0] 8 #() 1168 nil 27 8 'matchCase' 410 ##(Smalltalk.CheckBox) 34 16 nil 5376 34 2 8 1141058819 1 5856 3346 nil nil 5584 false nil nil 7 nil nil nil 5856 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 161 43 5856 978 #text: 34 1 8 '&Whole word' 5856 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 21 0 0 0] 8 #() 1168 nil 27 8 'matchWhole' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 23 35 594 165 151 5376 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 34 2 5856 5488 1168 nil 27 2258 3104 23 2320 -17 3120 35 3136 -15 170 192 2464 nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 297 11 594 205 201 4960 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 5072 5376 1168 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2368 34 2 8 1140850688 131073 6544 nil nil nil 7 nil nil nil 6544 1858 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 6544 34 2 8 1140850688 131073 6656 nil nil nil 7 nil nil nil 6656 722 1 11 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 6656 34 2 8 1140858889 1 6768 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 6768 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 81 1 594 97 43 6768 978 #text: 34 1 8 '&Down' 6768 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 8 #() 1168 nil 27 8 'down' 410 ##(Smalltalk.RadioButton) 34 16 nil 6656 34 2 8 1141055497 1 7184 3346 nil nil 3378 3410 #= 8 #() 3410 #hash 8 #() false nil nil 7 nil nil nil 7184 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 81 43 7184 978 #text: 34 1 8 '&Up' 7184 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 8 #() 1168 nil 27 8 'up' 410 ##(Smalltalk.CheckBox) 34 16 nil 6656 34 2 8 1140924419 1 7600 3346 nil nil 5584 false nil nil 7 nil nil nil 7600 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 53 594 181 43 7600 978 #text: 34 1 8 '&Wrap around' 7600 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 8 #() 1168 nil 27 8 'wrap' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 19 33 594 191 151 6656 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 34 3 7184 6768 7600 1168 nil 27 2258 3104 19 2320 -11 3120 33 3136 -17 410 ##(Smalltalk.GroupBox) 34 14 nil 6544 34 2 8 1140850695 65 8112 nil nil nil 7 nil nil nil 8112 nil 8 1906824432 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 221 201 8112 978 #text: 34 1 8 'Direction' 8112 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 8 #() 1168 nil 27 2258 3104 1 2320 1 3120 1 3136 1 170 192 34 2 6656 8 'direction' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 517 11 594 221 201 6544 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 34 2 8112 6656 1168 nil 27 1168 nil 27 2258 3104 1 2320 1 2290 #fixedPreviousBottom 11 3136 1 410 ##(Smalltalk.StaticText) 34 16 nil 1792 34 2 8 1140850944 1 8656 3346 nil nil 5584 8 '' nil nil 7 nil nil nil 8656 nil 8 1906774720 2018 nil nil true 914 138 144 34 2 978 #createAt:extent: 34 2 594 17 31 594 111 41 8656 978 #text: 34 1 8 'Fi&nd what:' 8656 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 8 #() 1168 nil 27 2258 3104 5 2290 #fixedViewLeft 111 3120 1 2352 41 170 192 34 4 1920 8 'pattern' 8656 8 'prompt' 1570 594 13 31 594 11 21 914 138 144 34 1 978 #createAt:extent: 34 2 594 11 1 594 763 313 1792 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 130 1 0 0 156 0 0 0] 34 3 8656 1920 2368 1168 nil 27 170 192 2464 1570 594 11 1 594 11 1 nil nil nil nil 14401 nil nil 594 2049 397 594 991 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 914 138 144 34 3 978 #createAt:extent: 34 2 594 3839 21 594 991 391 416 978 #text: 34 1 8 'Find' 416 978 #updateMenuBar 2464 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 110 9 0 0 205 0 0 0] 34 2 1792 656 1168 nil 27 )!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140858880 1 784 nil nil nil 7 nil nil nil 784 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 1 77 594 151 47 784 978 #text: 34 1 8 'C&lose' 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 594 193 193 nil 29 8 'cancel' 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1141055488 1 1200 nil nil nil 7 nil nil nil 1200 nil 8 1906824432 866 #ok 8 '&Find' 1 5 nil nil true nil nil nil 914 138 144 34 3 978 #createAt:extent: 34 2 594 1 21 594 151 47 1200 978 #isEnabled: 8 #(false) 1200 978 #text: 34 1 8 '&Find' 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1168 nil 29 8 'ok' 590342 ##(Smalltalk.Rectangle) 594 1 21 594 1 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 549 1 594 161 319 656 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 34 2 1200 784 1168 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1792 nil nil nil 7 nil nil nil 1792 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.StaticText) 34 16 nil 1792 34 2 8 1140850944 1 1920 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1920 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil true 914 138 144 34 2 978 #createAt:extent: 34 2 594 17 31 594 111 31 1920 978 #text: 34 1 8 'Fi&nd what:' 1920 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1168 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 5 2354 #fixedViewLeft 111 2354 #fixedParentTop 1 2354 #fixedViewTop 31 410 ##(Smalltalk.TextEdit) 34 16 nil 1792 34 2 8 1141047424 1025 2432 nil 466 496 nil 7 nil nil nil 2432 nil 8 1906818384 2082 nil nil 5 914 138 144 34 2 978 #createAt:extent: 34 2 594 145 25 594 371 45 2432 978 #setMarginWidths: 34 1 8 #(3 3) 2432 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 8 #() 1168 nil 27 2322 2354 #fixedPreviousRight 19 2354 #fixedParentRight -3 2354 #fixedPreviousTop -5 2416 45 410 ##(Smalltalk.ContainerView) 34 15 nil 1792 34 2 8 1140850688 131073 2816 nil nil nil 7 nil nil nil 2816 722 17 1 1 170 192 8 #() 1570 594 1 11 594 1 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 13 79 594 507 221 2816 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 3136 nil nil nil 7 nil nil nil 3136 1858 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 3136 34 2 8 1140850688 131073 3248 nil nil nil 7 nil nil nil 3248 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 3248 34 2 8 1140858889 1 3376 1986 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 3376 nil 8 1906824432 2082 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 105 594 253 53 3376 978 #text: 34 1 8 '&Regular Expression' 3376 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 8 #() 1168 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3248 34 2 8 1140858889 1 3824 1986 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 3824 nil 8 1906824432 2082 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 53 594 253 53 3824 978 #text: 34 1 8 '&Wildcard Expression' 3824 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 8 #() 1168 nil 27 8 'wildcardExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3248 34 2 8 1141055497 1 4240 1986 nil nil 3458 3490 #= 8 #() 3490 #hash 8 #() false nil nil 7 nil nil nil 4240 nil 8 1906824432 2082 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 253 53 4240 978 #text: 34 1 8 '&Text' 4240 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 8 #() 1168 nil 27 8 'text' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 21 33 594 253 157 3248 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 4240 3824 3376 1168 nil 27 2322 2368 21 2784 -7 2400 33 2354 #fixedParentBottom -11 410 ##(Smalltalk.GroupBox) 34 14 nil 3136 34 2 8 1140850695 65 4848 nil nil nil 7 nil nil nil 4848 nil 8 1906824432 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 281 201 4848 978 #text: 34 1 8 'Search Mode' 4848 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1168 nil 27 2322 2368 1 2784 1 2400 1 4832 1 170 192 34 2 3248 8 'mode' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 11 594 281 201 3136 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 4848 3248 1168 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 5360 nil nil nil 7 nil nil nil 5360 1858 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 5360 34 2 8 1140850695 65 5472 nil nil nil 7 nil nil nil 5472 nil 8 1906824432 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 205 201 5472 978 #text: 34 1 8 'Match' 5472 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1168 nil 27 2322 2368 1 2784 1 2400 1 4832 1 410 ##(Smalltalk.ContainerView) 34 15 nil 5360 34 2 8 1140850688 131073 5776 nil nil nil 7 nil nil nil 5776 3314 7 1 1 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 5776 34 2 8 1140858883 1 5888 1986 nil nil 2032 false nil nil 7 nil nil nil 5888 nil 8 1906824432 2082 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 51 594 175 53 5888 978 #text: 34 1 8 '&Case' 5888 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 8 #() 1168 nil 27 8 'matchCase' 410 ##(Smalltalk.CheckBox) 34 16 nil 5776 34 2 8 1141055491 1 6224 1986 nil nil 2032 false nil nil 7 nil nil nil 6224 nil 8 1906824432 2082 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 175 51 6224 978 #text: 34 1 8 '&Whole word' 6224 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 8 #() 1168 nil 27 8 'matchWhole' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 19 35 594 175 153 5776 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 34 2 6224 5888 1168 nil 27 2322 2368 19 2784 -11 2400 35 4832 -13 170 192 2912 nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 297 11 594 205 201 5360 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 5472 5776 1168 nil 27 1168 nil 27 2322 2368 1 2784 1 2354 #fixedPreviousBottom 11 4832 1 170 192 34 4 1920 8 'prompt' 2432 8 'pattern' 1570 594 13 31 594 11 21 914 138 144 34 1 978 #createAt:extent: 34 2 594 11 1 594 529 319 1792 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 34 3 1920 2432 2816 1168 nil 27 170 192 2912 1570 594 11 1 594 11 1 nil nil nil nil 15135 nil nil 594 2049 397 594 751 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 914 138 144 34 3 978 #createAt:extent: 34 2 594 3839 21 594 751 397 416 978 #text: 34 1 8 'Find' 416 978 #updateMenuBar 2912 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 246 8 0 0 208 0 0 0] 34 2 1792 656 1168 nil 27 )!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1141055488 1 784 nil nil nil 7 nil nil nil 784 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Find' 1 5 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 1 21 594 151 47 784 978 #isEnabled: 8 #(false) 784 978 #text: 34 1 8 '&Find' 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 594 193 193 nil 29 8 'ok' 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 1232 nil nil nil 7 nil nil nil 1232 nil 8 1906824432 866 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 77 594 151 47 1232 978 #text: 34 1 8 'C&lose' 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 1200 nil 29 8 'cancel' 590342 ##(Smalltalk.Rectangle) 594 1 21 594 1 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 559 1 594 161 319 656 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 34 2 784 1232 1200 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1792 nil nil nil 7 nil nil nil 1792 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.TextEdit) 34 16 nil 1792 34 2 8 1141047424 1025 1920 nil 466 496 nil 7 nil nil nil 1920 nil 8 1906818384 852486 ##(Smalltalk.NullConverter) nil nil 5 914 138 144 34 2 978 #createAt:extent: 34 2 594 145 29 594 371 45 1920 978 #setMarginWidths: 34 1 8 #(3 3) 1920 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 8 #() 1200 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 19 2290 #fixedParentRight -13 2290 #fixedPreviousTop -1 2290 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1792 34 2 8 1140850944 1 2368 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 2368 nil 8 1906774720 2018 nil nil true 914 138 144 34 2 978 #createAt:extent: 34 2 594 17 31 594 111 31 2368 978 #text: 34 1 8 'Fi&nd what:' 2368 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1200 nil 27 2258 2290 #fixedParentLeft 5 2290 #fixedViewLeft 111 2290 #fixedParentTop 1 2352 31 410 ##(Smalltalk.ContainerView) 34 15 nil 1792 34 2 8 1140916224 131073 2816 nil nil nil 7 nil nil nil 2816 722 17 1 1 170 192 8 #() 1570 594 1 11 594 1 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 13 83 594 517 217 2816 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140916224 131073 3136 nil nil nil 7 nil nil nil 3136 1858 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 3136 34 2 8 1140850695 65 3248 nil nil nil 7 nil nil nil 3248 nil 8 1906824432 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 281 201 3248 978 #text: 34 1 8 'Search Mode' 3248 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1200 nil 27 2258 2768 1 2320 1 2800 1 2290 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3136 34 2 8 1140916224 131073 3568 nil nil nil 7 nil nil nil 3568 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1140924425 1 3696 2434 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 3696 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 105 594 255 53 3696 978 #text: 34 1 8 '&Regular Expression' 3696 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1200 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1141055497 1 4144 2434 nil nil 3778 3810 #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 4144 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 1 594 255 53 4144 978 #text: 34 1 8 '&Text' 4144 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1200 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 3568 34 2 8 1140924425 1 4560 2434 nil nil 3778 3810 #= 8 #() 3810 #hash 8 #() false nil nil 7 nil nil nil 4560 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 1 53 594 255 53 4560 978 #text: 34 1 8 '&Wildcard Expression' 4560 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1200 nil 27 8 'wildcardExpression' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 19 31 594 255 157 3568 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 34 3 4144 4560 3696 1200 nil 27 2258 2768 19 2320 -7 2800 31 3552 -13 170 192 34 2 3568 8 'mode' nil 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 11 594 281 201 3136 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 3248 3568 1200 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2816 34 2 8 1140850688 131073 5360 nil nil nil 7 nil nil nil 5360 3634 7 1 1 1 170 192 34 2 410 ##(Smalltalk.CheckBox) 34 16 nil 5360 34 2 8 1141055491 1 5472 2434 nil nil 2480 false nil nil 7 nil nil nil 5472 nil 8 1906824432 2018 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 594 11 11 594 195 65 5472 978 #text: 34 1 8 'Match &case' 5472 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 8 #() 1200 nil 27 8 'matchCase' 1570 594 11 11 594 1 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 297 11 594 205 201 5360 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 1 5472 1200 nil 27 1200 nil 27 2258 2768 1 2320 1 2290 #fixedPreviousBottom 11 3552 1 170 192 34 4 2368 8 'prompt' 1920 8 'pattern' 1570 594 13 31 594 11 21 914 138 144 34 1 978 #createAt:extent: 34 2 594 11 1 594 539 319 1792 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 34 3 2368 1920 2816 1200 nil 27 170 192 2912 1570 594 11 1 594 11 1 nil nil nil nil 15541 nil nil 594 2049 397 594 761 397 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 914 138 144 34 3 978 #createAt:extent: 34 2 594 3839 21 594 761 397 416 978 #text: 34 1 8 'Find' 416 978 #updateMenuBar 2912 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 208 0 0 0] 34 2 1792 656 1200 nil 27 )!

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

