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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 17 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 838 1 #{UI.FlowLayout} 1 11 1 550 #{Core.IdentityDictionary} 2 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 400 nil nil nil 7 nil nil nil 400 nil 8 1853182784 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 77 210 151 47 400 578 #text: 50 1 8 'C&lose' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 210 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1141055488 1 800 nil nil nil 7 nil nil nil 800 nil 8 1853182784 482 #ok 8 '&Find' 1 5 nil nil true nil nil nil 530 50 3 578 #createAt:extent: 50 2 210 1 21 210 151 47 800 578 #isEnabled: 8 #(false) 800 578 #text: 50 1 8 '&Find' 800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 768 nil 29 8 'ok' 518 #{Graphics.Rectangle} 210 1 21 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 789 1 210 161 319 272 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 50 2 800 400 768 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 3 18 #{UI.ContainerView} 50 15 nil 1360 50 2 8 1140850688 131073 1488 nil nil nil 7 nil nil nil 1488 338 17 1 1 370 0 1154 210 1 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 13 79 210 741 221 1488 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 1488 50 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 1426 1458 2 18 #{UI.ContainerView} 50 15 nil 1776 50 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 1030 #{UI.GridLayout} 7 1 1 1 370 3 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1140858889 1 1984 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 1984 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 105 210 255 53 1984 578 #text: 50 1 8 '&Regular Expression' 1984 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 768 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1140989961 1 2448 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 2448 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 255 53 2448 578 #text: 50 1 8 '&Text' 2448 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 768 nil 27 8 'text' 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1140858889 1 2848 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 2848 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 255 53 2848 578 #text: 50 1 8 '&Wildcard Expression' 2848 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 768 nil 27 8 'wildcardExpression' nil 530 50 1 578 #createAt:extent: 50 2 210 19 33 210 255 157 1872 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 50 3 2448 2848 1984 768 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 19 3426 #fixedParentRight -7 3426 #fixedParentTop 33 3426 #fixedParentBottom -11 18 #{UI.GroupBox} 50 14 nil 1776 50 2 8 1140850695 65 3504 nil nil nil 7 nil nil nil 3504 nil 8 1853182784 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 281 201 3504 578 #text: 50 1 8 'Search Mode' 3504 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 768 nil 27 3394 3440 1 3456 1 3472 1 3488 1 370 1 1872 8 'mode' nil 530 50 1 578 #createAt:extent: 50 2 210 1 11 210 281 201 1776 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 50 2 3504 1872 768 nil 27 18 #{UI.ContainerView} 50 15 nil 1488 50 2 8 1140850688 131073 3968 nil nil nil 7 nil nil nil 3968 1426 1458 2 18 #{UI.ContainerView} 50 15 nil 3968 50 2 8 1140850688 131073 4064 nil nil nil 7 nil nil nil 4064 338 1 11 1 370 2 18 #{UI.CheckBox} 50 16 nil 4064 50 2 8 1141058819 1 4160 2050 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 4160 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 161 43 4160 578 #text: 50 1 8 '&Whole word' 4160 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 21 0 0 0] 8 #() 768 nil 27 8 'matchWhole' 18 #{UI.CheckBox} 50 16 nil 4064 50 2 8 1140924419 1 4512 2050 nil nil 4256 false nil nil 519 nil nil nil 4512 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 87 35 4512 578 #text: 50 1 8 '&Case' 4512 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 43 0 0 0 43 0 0 0] 8 #() 768 nil 27 8 'matchCase' nil 530 50 1 578 #createAt:extent: 50 2 210 23 35 210 165 151 4064 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 50 2 4160 4512 768 nil 27 3394 3440 23 3456 -17 3472 35 3488 -15 18 #{UI.GroupBox} 50 14 nil 3968 50 2 8 1140850695 65 4992 nil nil nil 7 nil nil nil 4992 nil 8 1853182784 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 205 201 4992 578 #text: 50 1 8 'Match' 4992 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 768 nil 27 3394 3440 1 3456 1 3472 1 3488 1 370 0 nil 530 50 1 578 #createAt:extent: 50 2 210 297 11 210 205 201 3968 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 50 2 4992 4064 768 nil 27 18 #{UI.ContainerView} 50 15 nil 1488 50 2 8 1140850688 131073 5440 nil nil nil 7 nil nil nil 5440 1426 1458 2 18 #{UI.ContainerView} 50 15 nil 5440 50 2 8 1140850688 131073 5536 nil nil nil 7 nil nil nil 5536 338 1 11 1 370 3 18 #{UI.CheckBox} 50 16 nil 5536 50 2 8 1140924419 1 5632 2050 nil nil 4256 false nil nil 7 nil nil nil 5632 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 181 43 5632 578 #text: 50 1 8 '&Wrap around' 5632 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 8 #() 768 nil 27 8 'wrap' 18 #{UI.RadioButton} 50 16 nil 5536 50 2 8 1141055497 1 5952 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 5952 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 81 43 5952 578 #text: 50 1 8 '&Up' 5952 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 8 #() 768 nil 27 8 'up' 18 #{UI.RadioButton} 50 16 nil 5536 50 2 8 1140858889 1 6352 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 6352 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 81 1 210 97 43 6352 578 #text: 50 1 8 '&Down' 6352 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 8 #() 768 nil 27 8 'down' nil 530 50 1 578 #createAt:extent: 50 2 210 19 33 210 191 151 5536 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 50 3 5952 6352 5632 768 nil 27 3394 3440 19 3456 -11 3472 33 3488 -17 18 #{UI.GroupBox} 50 14 nil 5440 50 2 8 1140850695 65 6912 nil nil nil 7 nil nil nil 6912 nil 8 1853182784 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 221 201 6912 578 #text: 50 1 8 'Direction' 6912 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 8 #() 768 nil 27 3394 3440 1 3456 1 3472 1 3488 1 370 1 5536 8 'direction' nil 530 50 1 578 #createAt:extent: 50 2 210 517 11 210 221 201 5440 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 50 2 6912 5536 768 nil 27 768 nil 27 3394 3440 1 3456 1 3426 #fixedPreviousBottom 11 3488 1 18 #{UI.StaticText} 50 16 nil 1360 50 2 8 1140850944 1 7408 2050 nil nil 4256 8 '' nil nil 7 nil nil nil 7408 nil 8 1853387904 2210 nil nil true 530 50 2 578 #createAt:extent: 50 2 210 17 31 210 111 41 7408 578 #text: 50 1 8 'Fi&nd what:' 7408 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 8 #() 768 nil 27 3394 3440 5 3426 #fixedViewLeft 111 3472 1 3426 #fixedViewTop 41 18 #{UI.TextEdit} 50 20 nil 1360 50 2 8 1141047424 1025 7776 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 7776 nil 8 1853175488 2210 nil nil 1 #perChar nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 145 25 210 607 45 7776 578 #setMarginWidths: 50 1 8 #(3 3) 7776 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 8 #() 768 nil 45 3394 3426 #fixedPreviousRight 19 3456 -1 3426 #fixedPreviousTop -5 7760 45 370 2 7408 8 'prompt' 7776 8 'pattern' 1154 210 13 31 210 11 21 530 50 1 578 #createAt:extent: 50 2 210 11 1 210 763 319 1360 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 50 3 7408 7776 1488 768 nil 27 370 0 1154 210 11 1 210 11 1 nil nil nil nil 13135 nil nil 210 2049 397 210 991 397 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 530 50 2 578 #createAt:extent: 50 2 210 6143 21 210 991 397 32 578 #text: 50 1 8 'Find' 32 706 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 238 13 0 0 208 0 0 0] 50 2 1360 272 768 nil 27)!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 11 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 838 1 #{UI.FlowLayout} 1 11 1 550 #{Core.IdentityDictionary} 2 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1141055488 1 400 nil nil nil 7 nil nil nil 400 nil 8 1853182784 1350 4 #{UI.CommandDescription} #ok 8 '&Find' 1 5 nil nil true nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 21 210 151 47 400 578 #isEnabled: 8 #(false) 400 578 #text: 50 1 8 '&Find' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 210 193 193 nil 29 8 'ok' 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140858880 1 832 nil nil nil 7 nil nil nil 832 nil 8 1853182784 482 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 77 210 151 47 832 578 #text: 50 1 8 'C&lose' 832 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 800 nil 29 8 'cancel' 518 #{Graphics.Rectangle} 210 1 21 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 549 1 210 161 319 272 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 50 2 400 832 800 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 3 18 #{UI.ContainerView} 50 15 nil 1360 50 2 8 1140850688 131073 1488 nil nil nil 7 nil nil nil 1488 338 17 1 1 370 0 1154 210 1 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 13 79 210 507 221 1488 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 50 2 18 #{UI.ContainerView} 50 15 nil 1488 50 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 1426 1458 2 18 #{UI.ContainerView} 50 15 nil 1776 50 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 1030 #{UI.GridLayout} 7 1 1 1 370 3 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1140858889 1 1984 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 1984 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 105 210 253 53 1984 578 #text: 50 1 8 '&Regular Expression' 1984 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 8 #() 800 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1140858889 1 2448 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 2448 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 253 53 2448 578 #text: 50 1 8 '&Wildcard Expression' 2448 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 8 #() 800 nil 27 8 'wildcardExpression' 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1141055497 1 2848 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 2848 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 253 53 2848 578 #text: 50 1 8 '&Text' 2848 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 8 #() 800 nil 27 8 'text' nil 530 50 1 578 #createAt:extent: 50 2 210 21 33 210 253 157 1872 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 50 3 2848 2448 1984 800 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 21 3426 #fixedParentRight -7 3426 #fixedParentTop 33 3426 #fixedParentBottom -11 18 #{UI.GroupBox} 50 14 nil 1776 50 2 8 1140850695 65 3504 nil nil nil 7 nil nil nil 3504 nil 8 1853182784 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 281 201 3504 578 #text: 50 1 8 'Search Mode' 3504 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 800 nil 27 3394 3440 1 3456 1 3472 1 3488 1 370 1 1872 8 'mode' nil 530 50 1 578 #createAt:extent: 50 2 210 1 11 210 281 201 1776 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 50 2 3504 1872 800 nil 27 18 #{UI.ContainerView} 50 15 nil 1488 50 2 8 1140850688 131073 3968 nil nil nil 7 nil nil nil 3968 1426 1458 2 18 #{UI.ContainerView} 50 15 nil 3968 50 2 8 1140850688 131073 4064 nil nil nil 7 nil nil nil 4064 1938 7 1 1 1 370 2 18 #{UI.CheckBox} 50 16 nil 4064 50 2 8 1140858883 1 4160 2050 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 4160 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 51 210 175 53 4160 578 #text: 50 1 8 '&Case' 4160 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 8 #() 800 nil 27 8 'matchCase' 18 #{UI.CheckBox} 50 16 nil 4064 50 2 8 1141055491 1 4512 2050 nil nil 4256 false nil nil 7 nil nil nil 4512 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 175 51 4512 578 #text: 50 1 8 '&Whole word' 4512 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 8 #() 800 nil 27 8 'matchWhole' nil 530 50 1 578 #createAt:extent: 50 2 210 19 35 210 175 153 4064 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 50 2 4512 4160 800 nil 27 3394 3440 19 3456 -11 3472 35 3488 -13 18 #{UI.GroupBox} 50 14 nil 3968 50 2 8 1140850695 65 4992 nil nil nil 7 nil nil nil 4992 nil 8 1853182784 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 205 201 4992 578 #text: 50 1 8 'Match' 4992 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 8 #() 800 nil 27 3394 3440 1 3456 1 3472 1 3488 1 370 0 nil 530 50 1 578 #createAt:extent: 50 2 210 297 11 210 205 201 3968 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 50 2 4992 4064 800 nil 27 800 nil 27 3394 3440 1 3456 1 3426 #fixedPreviousBottom 11 3488 1 18 #{UI.StaticText} 50 16 nil 1360 50 2 8 1140850944 1 5472 2050 nil nil 4256 8 '' nil nil 7 nil nil nil 5472 nil 8 1853387904 2210 nil nil true 530 50 2 578 #createAt:extent: 50 2 210 17 31 210 111 31 5472 578 #text: 50 1 8 'Fi&nd what:' 5472 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 800 nil 27 3394 3440 5 3426 #fixedViewLeft 111 3472 1 3426 #fixedViewTop 31 18 #{UI.TextEdit} 50 20 nil 1360 50 2 8 1141047424 1025 5840 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 5840 nil 8 1853175488 2210 nil nil 1 #perChar nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 145 25 210 371 45 5840 578 #setMarginWidths: 50 1 8 #(3 3) 5840 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 8 #() 800 nil 45 3394 3426 #fixedPreviousRight 19 3456 -3 3426 #fixedPreviousTop -5 5824 45 370 2 5472 8 'prompt' 5840 8 'pattern' 1154 210 13 31 210 11 21 530 50 1 578 #createAt:extent: 50 2 210 11 1 210 529 319 1360 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 50 3 5472 5840 1488 800 nil 27 370 0 1154 210 11 1 210 11 1 nil nil nil nil 13089 nil nil 210 2049 397 210 751 397 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 530 50 2 578 #createAt:extent: 50 2 210 6143 21 210 751 397 32 578 #text: 50 1 8 'Find' 32 738 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 118 13 0 0 208 0 0 0] 50 2 1360 272 800 nil 27)!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 11 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 838 1 #{UI.FlowLayout} 1 11 1 550 #{Core.IdentityDictionary} 2 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 400 nil nil nil 7 nil nil nil 400 nil 8 1853182784 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 77 210 151 47 400 578 #text: 50 1 8 'C&lose' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 8 #() 210 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1141055488 1 800 nil nil nil 7 nil nil nil 800 nil 8 1853182784 482 #ok 8 '&Find' 1 5 nil nil true nil nil nil 530 50 3 578 #createAt:extent: 50 2 210 1 21 210 151 47 800 578 #isEnabled: 8 #(false) 800 578 #text: 50 1 8 '&Find' 800 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 8 #() 768 nil 29 8 'ok' 518 #{Graphics.Rectangle} 210 1 21 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 559 1 210 161 319 272 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 50 2 800 400 768 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1360 nil nil nil 7 nil nil nil 1360 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 3 18 #{UI.ContainerView} 50 15 nil 1360 50 2 8 1140916224 131073 1488 nil nil nil 7 nil nil nil 1488 338 17 1 1 370 0 1154 210 1 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 13 83 210 517 217 1488 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 50 2 18 #{UI.ContainerView} 50 15 nil 1488 50 2 8 1140916224 131073 1776 nil nil nil 7 nil nil nil 1776 1426 1458 2 18 #{UI.ContainerView} 50 15 nil 1776 50 2 8 1140916224 131073 1872 nil nil nil 7 nil nil nil 1872 1030 #{UI.GridLayout} 7 1 1 1 370 3 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1140924425 1 1984 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 1984 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 105 210 255 53 1984 578 #text: 50 1 8 '&Regular Expression' 1984 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 8 #() 768 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1140924425 1 2448 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 2448 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 53 210 255 53 2448 578 #text: 50 1 8 '&Wildcard Expression' 2448 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 8 #() 768 nil 27 8 'wildcardExpression' 18 #{UI.RadioButton} 50 16 nil 1872 50 2 8 1141055497 1 2848 2050 nil nil 2082 2114 #= 8 #() 2114 #hash 8 #() false nil nil 7 nil nil nil 2848 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 255 53 2848 578 #text: 50 1 8 '&Text' 2848 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 8 #() 768 nil 27 8 'text' nil 530 50 1 578 #createAt:extent: 50 2 210 19 31 210 255 157 1872 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 50 3 2848 2448 1984 768 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 19 3426 #fixedParentRight -7 3426 #fixedParentTop 31 3426 #fixedParentBottom -13 18 #{UI.GroupBox} 50 14 nil 1776 50 2 8 1140850695 65 3504 nil nil nil 7 nil nil nil 3504 nil 8 1853182784 530 50 2 578 #createAt:extent: 50 2 210 1 1 210 281 201 3504 578 #text: 50 1 8 'Search Mode' 3504 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 8 #() 768 nil 27 3394 3440 1 3456 1 3472 1 3488 1 370 1 1872 8 'mode' nil 530 50 1 578 #createAt:extent: 50 2 210 1 11 210 281 201 1776 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 50 2 3504 1872 768 nil 27 18 #{UI.ContainerView} 50 15 nil 1488 50 2 8 1140850688 131073 3968 nil nil nil 7 nil nil nil 3968 1938 7 1 1 1 370 1 18 #{UI.CheckBox} 50 16 nil 3968 50 2 8 1141055491 1 4064 2050 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 4064 nil 8 1853182784 2210 nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 11 11 210 195 65 4064 578 #text: 50 1 8 'Match &case' 4064 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 8 #() 768 nil 27 8 'matchCase' 1154 210 11 11 210 1 1 530 50 1 578 #createAt:extent: 50 2 210 297 11 210 205 201 3968 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 50 1 4064 768 nil 27 768 nil 27 3394 3440 1 3456 1 3426 #fixedPreviousBottom 11 3488 1 18 #{UI.StaticText} 50 16 nil 1360 50 2 8 1140850944 1 4640 2050 nil nil 4160 8 '' nil nil 7 nil nil nil 4640 nil 8 1853387904 2210 nil nil true 530 50 2 578 #createAt:extent: 50 2 210 17 31 210 111 31 4640 578 #text: 50 1 8 'Fi&nd what:' 4640 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 8 #() 768 nil 27 3394 3440 5 3426 #fixedViewLeft 111 3472 1 3426 #fixedViewTop 31 18 #{UI.TextEdit} 50 20 nil 1360 50 2 8 1141047424 1025 5008 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 5008 nil 8 1853175488 2210 nil nil 1 #perChar nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 145 29 210 371 45 5008 578 #setMarginWidths: 50 1 8 #(3 3) 5008 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 8 #() 768 nil 45 3394 3426 #fixedPreviousRight 19 3456 -13 3426 #fixedPreviousTop -1 4992 45 370 2 4640 8 'prompt' 5008 8 'pattern' 1154 210 13 31 210 11 21 530 50 1 578 #createAt:extent: 50 2 210 11 1 210 539 319 1360 706 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 50 3 4640 5008 1488 768 nil 27 370 0 1154 210 11 1 210 11 1 nil nil nil nil 13163 nil nil 210 2049 397 210 761 397 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 530 50 2 578 #createAt:extent: 50 2 210 6143 21 210 761 397 32 578 #text: 50 1 8 'Find' 32 706 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 208 0 0 0] 50 2 1360 272 768 nil 27)!

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

