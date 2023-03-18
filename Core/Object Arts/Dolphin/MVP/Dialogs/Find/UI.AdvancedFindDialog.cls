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
findNext!commands!public! !
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
queryCommand:!commands!private! !
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

	^FindDetails icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 17 1 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852806 1 #{UI.FlowLayout} 1 11 1 170 192 34 4 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 768 nil nil nil 7 nil nil nil 768 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 1 77 578 151 47 768 946 #text: 34 1 8 'C&lose' 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 578 193 193 nil 29 8 'cancel' 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1141055488 1 1168 nil nil nil 7 nil nil nil 1168 nil 8 1815097472 850 #ok 8 '&Find' 1 5 nil nil true nil nil nil 898 34 3 946 #createAt:extent: 34 2 578 1 21 578 151 47 1168 946 #isEnabled: 8 #(false) 1168 946 #text: 34 1 8 '&Find' 1168 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1136 nil 29 8 'ok' 1180166 #{Graphics.Rectangle} 578 1 21 578 1 1 898 34 1 946 #createAt:extent: 34 2 578 789 1 578 161 319 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 34 2 1168 768 1136 nil 27 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 1728 nil nil nil 7 nil nil nil 1728 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.StaticText} 34 16 nil 1728 34 2 8 1140850944 1 1856 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 8 '' nil nil 7 nil nil nil 1856 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil true 898 34 2 946 #createAt:extent: 34 2 578 17 31 578 111 41 1856 946 #text: 34 1 8 'Fi&nd what:' 1856 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 8 #() 1136 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 5 2274 #fixedViewLeft 111 2274 #fixedParentTop 1 2274 #fixedViewTop 41 410 #{UI.ContainerView} 34 15 nil 1728 34 2 8 1140850688 131073 2352 nil nil nil 7 nil nil nil 2352 706 17 1 1 170 192 8 #() 1522 578 1 11 578 1 1 898 34 1 946 #createAt:extent: 34 2 578 13 79 578 741 221 2352 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 34 3 410 #{UI.ContainerView} 34 15 nil 2352 34 2 8 1140850688 131073 2656 nil nil nil 7 nil nil nil 2656 1794 170 176 34 4 410 #{UI.ContainerView} 34 15 nil 2656 34 2 8 1140850688 131073 2768 nil nil nil 7 nil nil nil 2768 852998 #{UI.GridLayout} 7 1 1 1 170 192 34 6 410 #{UI.RadioButton} 34 16 nil 2768 34 2 8 1140858889 1 2896 1922 nil nil 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 3010 #hash 8 #() false nil nil 7 nil nil nil 2896 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 105 578 255 53 2896 946 #text: 34 1 8 '&Regular Expression' 2896 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1136 nil 27 8 'regularExpression' 410 #{UI.RadioButton} 34 16 nil 2768 34 2 8 1140858889 1 3328 1922 nil nil 2978 3010 #= 8 #() 3010 #hash 8 #() false nil nil 7 nil nil nil 3328 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 53 578 255 53 3328 946 #text: 34 1 8 '&Wildcard Expression' 3328 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1136 nil 27 8 'wildcardExpression' 410 #{UI.RadioButton} 34 16 nil 2768 34 2 8 1140989961 1 3728 1922 nil nil 2978 3010 #= 8 #() 3010 #hash 8 #() false nil nil 7 nil nil nil 3728 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 255 53 3728 946 #text: 34 1 8 '&Text' 3728 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1136 nil 27 8 'text' nil 898 34 1 946 #createAt:extent: 34 2 578 19 33 578 255 157 2768 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 3728 3328 2896 1136 nil 27 2242 2288 19 2274 #fixedParentRight -7 2320 33 2274 #fixedParentBottom -11 410 #{UI.GroupBox} 34 14 nil 2656 34 2 8 1140850695 65 4320 nil nil nil 7 nil nil nil 4320 nil 8 1815097472 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 281 201 4320 946 #text: 34 1 8 'Search Mode' 4320 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1136 nil 27 2242 2288 1 4288 1 2320 1 4304 1 170 192 34 2 2768 8 'mode' nil 898 34 1 946 #createAt:extent: 34 2 578 1 11 578 281 201 2656 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 4320 2768 1136 nil 27 410 #{UI.ContainerView} 34 15 nil 2352 34 2 8 1140850688 131073 4800 nil nil nil 7 nil nil nil 4800 1794 170 176 34 4 410 #{UI.GroupBox} 34 14 nil 4800 34 2 8 1140850695 65 4912 nil nil nil 7 nil nil nil 4912 nil 8 1815097472 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 205 201 4912 946 #text: 34 1 8 'Match' 4912 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1136 nil 27 2242 2288 1 4288 1 2320 1 4304 1 410 #{UI.ContainerView} 34 15 nil 4800 34 2 8 1140850688 131073 5200 nil nil nil 7 nil nil nil 5200 706 1 11 1 170 192 34 4 410 #{UI.CheckBox} 34 16 nil 5200 34 2 8 1141058819 1 5312 1922 nil nil 1968 false nil nil 7 nil nil nil 5312 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 161 43 5312 946 #text: 34 1 8 '&Whole word' 5312 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 21 0 0 0] 8 #() 1136 nil 27 8 'matchWhole' 410 #{UI.CheckBox} 34 16 nil 5200 34 2 8 1140924419 1 5632 1922 nil nil 1968 false nil nil 519 nil nil nil 5632 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 53 578 165 43 5632 946 #text: 34 1 8 '&Case' 5632 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 82 0 0 0 47 0 0 0] 8 #() 1136 nil 27 8 'matchCase' nil 898 34 1 946 #createAt:extent: 34 2 578 23 35 578 165 151 5200 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 34 2 5312 5632 1136 nil 27 2242 2288 23 4288 -17 2320 35 4304 -15 170 192 2448 nil 898 34 1 946 #createAt:extent: 34 2 578 297 11 578 205 201 4800 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 4912 5200 1136 nil 27 410 #{UI.ContainerView} 34 15 nil 2352 34 2 8 1140850688 131073 6272 nil nil nil 7 nil nil nil 6272 1794 170 176 34 4 410 #{UI.GroupBox} 34 14 nil 6272 34 2 8 1140850695 65 6384 nil nil nil 7 nil nil nil 6384 nil 8 1815097472 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 221 201 6384 946 #text: 34 1 8 'Direction' 6384 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 8 #() 1136 nil 27 2242 2288 1 4288 1 2320 1 4304 1 410 #{UI.ContainerView} 34 15 nil 6272 34 2 8 1140850688 131073 6672 nil nil nil 7 nil nil nil 6672 706 1 11 1 170 192 34 6 410 #{UI.RadioButton} 34 16 nil 6672 34 2 8 1140858889 1 6784 1922 nil nil 2978 3010 #= 8 #() 3010 #hash 8 #() false nil nil 7 nil nil nil 6784 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 81 1 578 97 43 6784 946 #text: 34 1 8 '&Down' 6784 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 8 #() 1136 nil 27 8 'down' 410 #{UI.RadioButton} 34 16 nil 6672 34 2 8 1141055497 1 7184 1922 nil nil 2978 3010 #= 8 #() 3010 #hash 8 #() false nil nil 7 nil nil nil 7184 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 81 43 7184 946 #text: 34 1 8 '&Up' 7184 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 8 #() 1136 nil 27 8 'up' 410 #{UI.CheckBox} 34 16 nil 6672 34 2 8 1140924419 1 7584 1922 nil nil 1968 false nil nil 7 nil nil nil 7584 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 53 578 181 43 7584 946 #text: 34 1 8 '&Wrap around' 7584 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 8 #() 1136 nil 27 8 'wrap' nil 898 34 1 946 #createAt:extent: 34 2 578 19 33 578 191 151 6672 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 34 3 7184 6784 7584 1136 nil 27 2242 2288 19 4288 -11 2320 33 4304 -17 170 192 34 2 6672 8 'direction' nil 898 34 1 946 #createAt:extent: 34 2 578 517 11 578 221 201 6272 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 34 2 6384 6672 1136 nil 27 1136 nil 27 2242 2288 1 4288 1 2274 #fixedPreviousBottom 11 4304 1 410 #{UI.TextEdit} 34 16 nil 1728 34 2 8 1141047424 1025 8288 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 8288 nil 8 1815092992 2018 nil nil 5 898 34 2 946 #createAt:extent: 34 2 578 145 25 578 607 45 8288 946 #setMarginWidths: 34 1 8 #(3 3) 8288 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 8 #() 1136 nil 27 2242 2274 #fixedPreviousRight 19 4288 -1 2274 #fixedPreviousTop -5 2336 45 170 192 34 4 8288 8 'pattern' 1856 8 'prompt' 1522 578 13 31 578 11 21 898 34 1 946 #createAt:extent: 34 2 578 11 1 578 763 319 1728 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 34 3 1856 8288 2352 1136 nil 27 170 192 2448 1522 578 11 1 578 11 1 nil nil nil nil 64269 nil nil 578 2049 397 578 991 397 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 898 34 2 946 #createAt:extent: 34 2 578 12287 21 578 991 397 416 946 #text: 34 1 8 'Find' 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 238 25 0 0 208 0 0 0] 34 2 1728 640 1136 nil 27)!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 11 1 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852806 1 #{UI.FlowLayout} 1 11 1 170 192 34 4 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140858880 1 768 nil nil nil 7 nil nil nil 768 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 1 77 578 151 47 768 946 #text: 34 1 8 'C&lose' 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 578 193 193 nil 29 8 'cancel' 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1141055488 1 1168 nil nil nil 7 nil nil nil 1168 nil 8 1815097472 850 #ok 8 '&Find' 1 5 nil nil true nil nil nil 898 34 3 946 #createAt:extent: 34 2 578 1 21 578 151 47 1168 946 #isEnabled: 8 #(false) 1168 946 #text: 34 1 8 '&Find' 1168 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 1136 nil 29 8 'ok' 1180166 #{Graphics.Rectangle} 578 1 21 578 1 1 898 34 1 946 #createAt:extent: 34 2 578 549 1 578 161 319 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 34 2 1168 768 1136 nil 27 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 1728 nil nil nil 7 nil nil nil 1728 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.StaticText} 34 16 nil 1728 34 2 8 1140850944 1 1856 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 8 '' nil nil 7 nil nil nil 1856 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil true 898 34 2 946 #createAt:extent: 34 2 578 17 31 578 111 31 1856 946 #text: 34 1 8 'Fi&nd what:' 1856 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1136 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 5 2274 #fixedViewLeft 111 2274 #fixedParentTop 1 2274 #fixedViewTop 31 410 #{UI.ContainerView} 34 15 nil 1728 34 2 8 1140850688 131073 2352 nil nil nil 7 nil nil nil 2352 706 17 1 1 170 192 8 #() 1522 578 1 11 578 1 1 898 34 1 946 #createAt:extent: 34 2 578 13 79 578 507 221 2352 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 34 2 410 #{UI.ContainerView} 34 15 nil 2352 34 2 8 1140850688 131073 2656 nil nil nil 7 nil nil nil 2656 1794 170 176 34 4 410 #{UI.GroupBox} 34 14 nil 2656 34 2 8 1140850695 65 2768 nil nil nil 7 nil nil nil 2768 nil 8 1815097472 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 281 201 2768 946 #text: 34 1 8 'Search Mode' 2768 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1136 nil 27 2242 2288 1 2274 #fixedParentRight 1 2320 1 2274 #fixedParentBottom 1 410 #{UI.ContainerView} 34 15 nil 2656 34 2 8 1140850688 131073 3088 nil nil nil 7 nil nil nil 3088 852998 #{UI.GridLayout} 7 1 1 1 170 192 34 6 410 #{UI.RadioButton} 34 16 nil 3088 34 2 8 1140858889 1 3216 1922 nil nil 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 3330 #hash 8 #() false nil nil 7 nil nil nil 3216 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 53 578 253 53 3216 946 #text: 34 1 8 '&Wildcard Expression' 3216 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 8 #() 1136 nil 27 8 'wildcardExpression' 410 #{UI.RadioButton} 34 16 nil 3088 34 2 8 1141055497 1 3648 1922 nil nil 3298 3330 #= 8 #() 3330 #hash 8 #() false nil nil 7 nil nil nil 3648 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 253 53 3648 946 #text: 34 1 8 '&Text' 3648 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 8 #() 1136 nil 27 8 'text' 410 #{UI.RadioButton} 34 16 nil 3088 34 2 8 1140858889 1 4048 1922 nil nil 3298 3330 #= 8 #() 3330 #hash 8 #() false nil nil 7 nil nil nil 4048 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 105 578 253 53 4048 946 #text: 34 1 8 '&Regular Expression' 4048 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 8 #() 1136 nil 27 8 'regularExpression' nil 898 34 1 946 #createAt:extent: 34 2 578 21 33 578 253 157 3088 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 34 3 3648 3216 4048 1136 nil 27 2242 2288 21 3056 -7 2320 33 3072 -11 170 192 34 2 3088 8 'mode' nil 898 34 1 946 #createAt:extent: 34 2 578 1 11 578 281 201 2656 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 2768 3088 1136 nil 27 410 #{UI.ContainerView} 34 15 nil 2352 34 2 8 1140850688 131073 4800 nil nil nil 7 nil nil nil 4800 1794 170 176 34 4 410 #{UI.GroupBox} 34 14 nil 4800 34 2 8 1140850695 65 4912 nil nil nil 7 nil nil nil 4912 nil 8 1815097472 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 205 201 4912 946 #text: 34 1 8 'Match' 4912 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 1136 nil 27 2242 2288 1 3056 1 2320 1 3072 1 410 #{UI.ContainerView} 34 15 nil 4800 34 2 8 1140850688 131073 5200 nil nil nil 7 nil nil nil 5200 3154 7 1 1 1 170 192 34 4 410 #{UI.CheckBox} 34 16 nil 5200 34 2 8 1140858883 1 5312 1922 nil nil 1968 false nil nil 7 nil nil nil 5312 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 51 578 175 53 5312 946 #text: 34 1 8 '&Case' 5312 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 8 #() 1136 nil 27 8 'matchCase' 410 #{UI.CheckBox} 34 16 nil 5200 34 2 8 1141055491 1 5632 1922 nil nil 1968 false nil nil 7 nil nil nil 5632 nil 8 1815097472 2018 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 175 51 5632 946 #text: 34 1 8 '&Whole word' 5632 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 8 #() 1136 nil 27 8 'matchWhole' nil 898 34 1 946 #createAt:extent: 34 2 578 19 35 578 175 153 5200 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 34 2 5632 5312 1136 nil 27 2242 2288 19 3056 -11 2320 35 3072 -13 170 192 2448 nil 898 34 1 946 #createAt:extent: 34 2 578 297 11 578 205 201 4800 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 2 4912 5200 1136 nil 27 1136 nil 27 2242 2288 1 3056 1 2274 #fixedPreviousBottom 11 3072 1 410 #{UI.TextEdit} 34 16 nil 1728 34 2 8 1141047424 1025 6304 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 6304 nil 8 1815092992 2018 nil nil 5 898 34 2 946 #createAt:extent: 34 2 578 145 25 578 371 45 6304 946 #setMarginWidths: 34 1 8 #(3 3) 6304 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 8 #() 1136 nil 27 2242 2274 #fixedPreviousRight 19 3056 -3 2274 #fixedPreviousTop -5 2336 45 170 192 34 4 6304 8 'pattern' 1856 8 'prompt' 1522 578 13 31 578 11 21 898 34 1 946 #createAt:extent: 34 2 578 11 1 578 529 319 1728 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 34 3 1856 6304 2352 1136 nil 27 170 192 2448 1522 578 11 1 578 11 1 nil nil nil nil 66873 nil nil 578 2049 397 578 751 397 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 898 34 2 946 #createAt:extent: 34 2 578 12287 21 578 751 397 416 946 #text: 34 1 8 'Find' 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 118 25 0 0 208 0 0 0] 34 2 1728 640 1136 nil 27)!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 11 1 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852806 1 #{UI.FlowLayout} 1 11 1 170 192 34 4 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1141055488 1 768 nil nil nil 7 nil nil nil 768 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #ok 8 '&Find' 1 5 nil nil true nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 1 21 578 151 47 768 946 #isEnabled: 8 #(false) 768 946 #text: 34 1 8 '&Find' 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 578 193 193 nil 29 8 'ok' 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 1200 nil nil nil 7 nil nil nil 1200 nil 8 1815097472 850 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 77 578 151 47 1200 946 #text: 34 1 8 'C&lose' 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 1168 nil 29 8 'cancel' 1180166 #{Graphics.Rectangle} 578 1 21 578 1 1 898 34 1 946 #createAt:extent: 34 2 578 559 1 578 161 319 640 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 34 2 768 1200 1168 nil 27 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 1728 nil nil nil 7 nil nil nil 1728 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.ContainerView} 34 15 nil 1728 34 2 8 1140916224 131073 1856 nil nil nil 7 nil nil nil 1856 706 17 1 1 170 192 8 #() 1522 578 1 11 578 1 1 898 34 1 946 #createAt:extent: 34 2 578 13 83 578 517 217 1856 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 34 2 410 #{UI.ContainerView} 34 15 nil 1856 34 2 8 1140916224 131073 2160 nil nil nil 7 nil nil nil 2160 1794 170 176 34 4 410 #{UI.ContainerView} 34 15 nil 2160 34 2 8 1140916224 131073 2272 nil nil nil 7 nil nil nil 2272 852998 #{UI.GridLayout} 7 1 1 1 170 192 34 6 410 #{UI.RadioButton} 34 16 nil 2272 34 2 8 1141055497 1 2400 918598 2 #{UI.ValueHolder} nil nil 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 2530 #hash 8 #() false nil nil 7 nil nil nil 2400 nil 8 1815097472 1049094 #{UI.NullConverter} nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 255 53 2400 946 #text: 34 1 8 '&Text' 2400 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 1168 nil 27 8 'text' 410 #{UI.RadioButton} 34 16 nil 2272 34 2 8 1140924425 1 2864 2466 nil nil 2498 2530 #= 8 #() 2530 #hash 8 #() false nil nil 7 nil nil nil 2864 nil 8 1815097472 2626 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 53 578 255 53 2864 946 #text: 34 1 8 '&Wildcard Expression' 2864 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 1168 nil 27 8 'wildcardExpression' 410 #{UI.RadioButton} 34 16 nil 2272 34 2 8 1140924425 1 3264 2466 nil nil 2498 2530 #= 8 #() 2530 #hash 8 #() false nil nil 7 nil nil nil 3264 nil 8 1815097472 2626 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 1 105 578 255 53 3264 946 #text: 34 1 8 '&Regular Expression' 3264 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 1168 nil 27 8 'regularExpression' nil 898 34 1 946 #createAt:extent: 34 2 578 19 31 578 255 157 2272 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 34 3 2400 2864 3264 1168 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 19 3842 #fixedParentRight -7 3842 #fixedParentTop 31 3842 #fixedParentBottom -13 410 #{UI.GroupBox} 34 14 nil 2160 34 2 8 1140850695 65 3920 nil nil nil 7 nil nil nil 3920 nil 8 1815097472 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 281 201 3920 946 #text: 34 1 8 'Search Mode' 3920 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 1168 nil 27 3810 3856 1 3872 1 3888 1 3904 1 170 192 34 2 2272 8 'mode' nil 898 34 1 946 #createAt:extent: 34 2 578 1 11 578 281 201 2160 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 34 2 3920 2272 1168 nil 27 410 #{UI.ContainerView} 34 15 nil 1856 34 2 8 1140850688 131073 4400 nil nil nil 7 nil nil nil 4400 2338 7 1 1 1 170 192 34 2 410 #{UI.CheckBox} 34 16 nil 4400 34 2 8 1141055491 1 4512 2466 nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 4512 nil 8 1815097472 2626 nil nil nil 898 34 2 946 #createAt:extent: 34 2 578 11 11 578 195 65 4512 946 #text: 34 1 8 'Match &case' 4512 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 8 #() 1168 nil 27 8 'matchCase' 1522 578 11 11 578 1 1 898 34 1 946 #createAt:extent: 34 2 578 297 11 578 205 201 4400 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 34 1 4512 1168 nil 27 1168 nil 27 3810 3856 1 3872 1 3842 #fixedPreviousBottom 11 3904 1 410 #{UI.StaticText} 34 16 nil 1728 34 2 8 1140850944 1 5088 2466 nil nil 4608 8 '' nil nil 7 nil nil nil 5088 nil 8 1815137184 2626 nil nil true 898 34 2 946 #createAt:extent: 34 2 578 17 31 578 111 31 5088 946 #text: 34 1 8 'Fi&nd what:' 5088 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 1168 nil 27 3810 3856 5 3842 #fixedViewLeft 111 3888 1 3842 #fixedViewTop 31 410 #{UI.TextEdit} 34 16 nil 1728 34 2 8 1141047424 1025 5456 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 5456 nil 8 1815092992 2626 nil nil 5 898 34 2 946 #createAt:extent: 34 2 578 145 29 578 371 45 5456 946 #setMarginWidths: 34 1 8 #(3 3) 5456 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 8 #() 1168 nil 27 3810 3842 #fixedPreviousRight 19 3872 -13 3842 #fixedPreviousTop -1 5440 45 170 192 34 4 5456 8 'pattern' 5088 8 'prompt' 1522 578 13 31 578 11 21 898 34 1 946 #createAt:extent: 34 2 578 11 1 578 539 319 1728 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 34 3 5088 5456 1856 1168 nil 27 170 192 1952 1522 578 11 1 578 11 1 nil nil nil nil 75309 nil nil 578 2049 397 578 761 397 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 898 34 2 946 #createAt:extent: 34 2 578 12287 21 578 761 397 416 946 #text: 34 1 8 'Find' 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 123 25 0 0 208 0 0 0] 34 2 1728 640 1168 nil 27)!

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

