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
	^self validateModel value!

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

validateModel
	| mode |
	mode := modePresenter radioButtonNamed: self searchMode.
	(mode notNil and: [mode isEnabled]) ifFalse: [^ValidationResult errorMessage: 'Invalid mode'].
	^ValidationResult value: (validationBlock value: self model value)!

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
searchMode!accessing!public! !
show!operations!public! !
showModal!public!realizing/unrealizing! !
validateModel!helpers!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 17 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 838 1 #{UI.FlowLayout} 1 11 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 384 nil nil nil 5 nil nil nil 384 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 193 416 8 'C&lose' 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1141055488 1 752 nil nil nil 5 nil nil nil 752 nil nil 450 #ok 8 '&Find' 1 5 nil nil true nil nil nil 498 50 2 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 193 784 8 '&Find' 752 546 #isEnabled: 8 #(false) 752 3 8 #() 706 193 193 nil 29 8 'ok' 518 #{Graphics.Rectangle} 706 1 21 706 1 1 498 50 1 546 #createWindow: 50 1 594 626 8 #[138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 193 272 8 '' 240 3 50 2 752 384 706 193 193 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1280 nil nil nil 5 nil nil nil 1280 262 #{UI.FramingLayout} 338 #{Core.LookupTable} 50 6 18 #{UI.TextEdit} 50 20 nil 1280 50 2 8 1141047424 1025 1408 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1408 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 498 50 2 546 #createWindow: 50 1 594 626 8 #[72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 193 1440 nil 1408 546 #setMarginWidths: 50 1 8 #(3 3) 1408 3 8 #() 706 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 19 1762 #fixedParentRight -1 1762 #fixedPreviousTop -5 1762 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 1280 50 2 8 1140850944 1 1840 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 1840 nil nil 1506 nil nil true 498 50 2 546 #createWindow: 50 1 594 626 8 #[8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 193 1872 nil 1840 546 #text: 50 1 8 'Fi&nd what:' 1840 3 8 #() 706 193 193 nil 27 1730 1762 #fixedParentLeft 5 1762 #fixedViewLeft 111 1762 #fixedParentTop 1 1824 41 18 #{UI.ContainerView} 50 15 nil 1280 50 2 8 1140850688 131073 2256 nil nil nil 5 nil nil nil 2256 306 17 1 1 550 #{Core.IdentityDictionary} 0 1058 706 1 11 706 1 1 498 50 1 546 #createWindow: 50 1 594 626 8 #[6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 193 2288 8 '' 2256 3 50 3 18 #{UI.ContainerView} 50 15 nil 2256 50 2 8 1140850688 131073 2560 nil nil nil 5 nil nil nil 2560 1346 338 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 2560 50 2 8 1140850695 65 2672 nil nil nil 5 nil nil nil 2672 nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 193 2704 8 'Search Mode' 2672 3 8 #() 706 193 193 nil 27 1730 2208 1 1792 1 2240 1 1762 #fixedParentBottom 1 18 #{UI.ContainerView} 50 15 nil 2560 50 2 8 1140850688 131073 2928 nil nil nil 5 nil nil nil 2928 1030 #{UI.GridLayout} 7 1 1 1 338 2336 50 6 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1140858889 1 3056 1906 nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3056 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 193 3088 8 '&Regular Expression' 3056 3 8 #() 706 193 193 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1140989961 1 3440 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3440 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 193 3472 8 '&Text' 3440 3 8 #() 706 193 193 nil 27 8 'text' 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1140858889 1 3792 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3792 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 193 3824 8 '&Wildcard Expression' 3792 3 8 #() 706 193 193 nil 27 8 'wildcardExpression' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 193 2960 8 '' 2928 3 50 3 3440 3792 3056 706 193 193 nil 27 1730 2208 19 1792 -7 2240 33 2912 -11 338 2336 50 2 2928 8 'mode' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 193 2592 8 '' 2560 3 50 2 2672 2928 706 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 2256 50 2 8 1140850688 131073 4528 nil nil nil 5 nil nil nil 4528 1346 338 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 4528 50 2 8 1140850695 65 4640 nil nil nil 5 nil nil nil 4640 nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 193 4672 8 'Match' 4640 3 8 #() 706 193 193 nil 27 1730 2208 1 1792 1 2240 1 2912 1 18 #{UI.ContainerView} 50 15 nil 4528 50 2 8 1140850688 131073 4880 nil nil nil 5 nil nil nil 4880 306 1 11 1 338 2336 50 4 18 #{UI.CheckBox} 50 16 nil 4880 50 2 8 1140924419 1 4992 1906 nil nil 1952 false nil nil 517 nil nil nil 4992 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 22 0 0 0 43 0 0 0 39 0 0 0] 193 5024 8 '&Case' 4992 3 8 #() 706 193 193 nil 27 8 'matchCase' 18 #{UI.CheckBox} 50 16 nil 4880 50 2 8 1141058819 1 5264 1906 nil nil 1952 false nil nil 517 nil nil nil 5264 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 82 0 0 0 17 0 0 0] 193 5296 8 '&Whole word' 5264 3 8 #() 706 193 193 nil 27 8 'matchWhole' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 193 4912 8 '' 4880 3 50 2 5264 4992 706 193 193 nil 27 1730 2208 23 1792 -17 2240 35 2912 -15 2338 0 nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 193 4560 8 '' 4528 3 50 2 4640 4880 706 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 2256 50 2 8 1140850688 131073 5888 nil nil nil 5 nil nil nil 5888 1346 338 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 5888 50 2 8 1140850695 65 6000 nil nil nil 5 nil nil nil 6000 nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 193 6032 8 'Direction' 6000 3 8 #() 706 193 193 nil 27 1730 2208 1 1792 1 2240 1 2912 1 18 #{UI.ContainerView} 50 15 nil 5888 50 2 8 1140850688 131073 6240 nil nil nil 5 nil nil nil 6240 306 11 11 1 338 2336 50 6 18 #{UI.RadioButton} 50 16 nil 6240 50 2 8 1140858889 1 6352 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 6352 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[38 0 0 0 0 0 0 0 87 0 0 0 17 0 0 0] 193 6384 8 '&Down' 6352 3 8 #() 706 193 193 nil 27 8 'down' 18 #{UI.RadioButton} 50 16 nil 6240 50 2 8 1141055497 1 6704 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 6704 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 33 0 0 0 17 0 0 0] 193 6736 8 '&Up' 6704 3 8 #() 706 193 193 nil 27 8 'up' 18 #{UI.CheckBox} 50 16 nil 6240 50 2 8 1140924419 1 7056 1906 nil nil 1952 false nil nil 517 nil nil nil 7056 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 22 0 0 0 87 0 0 0 39 0 0 0] 193 7088 8 '&Wrap around' 7056 3 8 #() 706 193 193 nil 27 8 'wrap' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 193 6272 8 '' 6240 3 50 3 6704 6352 7056 706 193 193 nil 27 1730 2208 19 1792 -11 2240 33 2912 -17 338 2336 50 2 6240 8 'direction' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 193 5920 8 '' 5888 3 50 2 6000 6240 706 193 193 nil 27 706 193 193 nil 27 1730 2208 1 1792 1 1762 #fixedPreviousBottom 11 2912 1 338 2336 50 4 1408 8 'pattern' 1840 8 'prompt' 1058 706 13 31 706 11 21 498 50 1 546 #createWindow: 50 1 594 626 8 #[5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 193 1312 8 '' 1280 3 50 3 1840 1408 2256 706 193 193 nil 27 2338 0 1058 706 11 1 706 11 1 nil nil nil nil 1 nil nil 706 2049 397 706 991 397 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil 498 50 2 546 #createWindow: 50 1 518 #{UI.CreateDialog} 626 8 #[255 14 0 0 10 0 0 0 238 16 0 0 208 0 0 0] 193 32 546 #setWindowText: 50 1 8 'Find' 32 1 50 2 1280 240 706 193 193 nil 27)!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 11 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 838 1 #{UI.FlowLayout} 1 11 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140858880 1 384 nil nil nil 5 nil nil nil 384 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 193 416 8 'C&lose' 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1141055488 1 752 nil nil nil 5 nil nil nil 752 nil nil 450 #ok 8 '&Find' 1 5 nil nil true nil nil nil 498 50 2 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 193 784 8 '&Find' 752 546 #isEnabled: 8 #(false) 752 3 8 #() 706 193 193 nil 29 8 'ok' 518 #{Graphics.Rectangle} 706 1 21 706 1 1 498 50 1 546 #createWindow: 50 1 594 626 8 #[18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 193 272 8 '' 240 3 50 2 752 384 706 193 193 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1280 nil nil nil 5 nil nil nil 1280 262 #{UI.FramingLayout} 338 #{Core.LookupTable} 50 6 18 #{UI.TextEdit} 50 20 nil 1280 50 2 8 1141047424 1025 1408 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1408 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 498 50 2 546 #createWindow: 50 1 594 626 8 #[72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 193 1440 nil 1408 546 #setMarginWidths: 50 1 8 #(3 3) 1408 3 8 #() 706 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 19 1762 #fixedParentRight -3 1762 #fixedPreviousTop -5 1762 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 1280 50 2 8 1140850944 1 1840 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 1840 nil nil 1506 nil nil true 498 50 2 546 #createWindow: 50 1 594 626 8 #[8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 193 1872 nil 1840 546 #text: 50 1 8 'Fi&nd what:' 1840 3 8 #() 706 193 193 nil 27 1730 1762 #fixedParentLeft 5 1762 #fixedViewLeft 111 1762 #fixedParentTop 1 1824 31 18 #{UI.ContainerView} 50 15 nil 1280 50 2 8 1140850688 131073 2256 nil nil nil 5 nil nil nil 2256 306 17 1 1 550 #{Core.IdentityDictionary} 0 1058 706 1 11 706 1 1 498 50 1 546 #createWindow: 50 1 594 626 8 #[6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 193 2288 8 '' 2256 3 50 2 18 #{UI.ContainerView} 50 15 nil 2256 50 2 8 1140850688 131073 2560 nil nil nil 5 nil nil nil 2560 1346 338 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 2560 50 2 8 1140850695 65 2672 nil nil nil 5 nil nil nil 2672 nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 193 2704 8 'Search Mode' 2672 3 8 #() 706 193 193 nil 27 1730 2208 1 1792 1 2240 1 1762 #fixedParentBottom 1 18 #{UI.ContainerView} 50 15 nil 2560 50 2 8 1140850688 131073 2928 nil nil nil 5 nil nil nil 2928 1030 #{UI.GridLayout} 7 1 1 1 338 2336 50 6 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1140858889 1 3056 1906 nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3056 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 193 3088 8 '&Regular Expression' 3056 3 8 #() 706 193 193 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1141055497 1 3440 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3440 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 193 3472 8 '&Text' 3440 3 8 #() 706 193 193 nil 27 8 'text' 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1140858889 1 3792 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3792 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 193 3824 8 '&Wildcard Expression' 3792 3 8 #() 706 193 193 nil 27 8 'wildcardExpression' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 193 2960 8 '' 2928 3 50 3 3440 3792 3056 706 193 193 nil 27 1730 2208 21 1792 -7 2240 33 2912 -11 338 2336 50 2 2928 8 'mode' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 193 2592 8 '' 2560 3 50 2 2672 2928 706 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 2256 50 2 8 1140850688 131073 4528 nil nil nil 5 nil nil nil 4528 1346 338 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 4528 50 2 8 1140850695 65 4640 nil nil nil 5 nil nil nil 4640 nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 193 4672 8 'Match' 4640 3 8 #() 706 193 193 nil 27 1730 2208 1 1792 1 2240 1 2912 1 18 #{UI.ContainerView} 50 15 nil 4528 50 2 8 1140850688 131073 4880 nil nil nil 5 nil nil nil 4880 2994 7 1 1 1 338 2336 50 4 18 #{UI.CheckBox} 50 16 nil 4880 50 2 8 1140858883 1 4992 1906 nil nil 1952 false nil nil 517 nil nil nil 4992 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 193 5024 8 '&Case' 4992 3 8 #() 706 193 193 nil 27 8 'matchCase' 18 #{UI.CheckBox} 50 16 nil 4880 50 2 8 1141055491 1 5264 1906 nil nil 1952 false nil nil 517 nil nil nil 5264 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 193 5296 8 '&Whole word' 5264 3 8 #() 706 193 193 nil 27 8 'matchWhole' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 193 4912 8 '' 4880 3 50 2 5264 4992 706 193 193 nil 27 1730 2208 19 1792 -11 2240 35 2912 -13 2338 0 nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 193 4560 8 '' 4528 3 50 2 4640 4880 706 193 193 nil 27 706 193 193 nil 27 1730 2208 1 1792 1 1762 #fixedPreviousBottom 11 2912 1 338 2336 50 4 1408 8 'pattern' 1840 8 'prompt' 1058 706 13 31 706 11 21 498 50 1 546 #createWindow: 50 1 594 626 8 #[5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 193 1312 8 '' 1280 3 50 3 1840 1408 2256 706 193 193 nil 27 2338 0 1058 706 11 1 706 11 1 nil nil nil nil 1 nil nil 706 2049 397 706 751 397 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil 498 50 2 546 #createWindow: 50 1 518 #{UI.CreateDialog} 626 8 #[255 14 0 0 10 0 0 0 118 16 0 0 208 0 0 0] 193 32 546 #setWindowText: 50 1 8 'Find' 32 1 50 2 1280 240 706 193 193 nil 27)!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 11 1 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 838 1 #{UI.FlowLayout} 1 11 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 384 nil nil nil 5 nil nil nil 384 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 193 416 8 'C&lose' 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 29 8 'cancel' 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1141055488 1 752 nil nil nil 5 nil nil nil 752 nil nil 450 #ok 8 '&Find' 1 5 nil nil true nil nil nil 498 50 2 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 193 784 8 '&Find' 752 546 #isEnabled: 8 #(false) 752 3 8 #() 706 193 193 nil 29 8 'ok' 518 #{Graphics.Rectangle} 706 1 21 706 1 1 498 50 1 546 #createWindow: 50 1 594 626 8 #[23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 193 272 8 '' 240 3 50 2 752 384 706 193 193 nil 27 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1280 nil nil nil 5 nil nil nil 1280 262 #{UI.FramingLayout} 338 #{Core.LookupTable} 50 6 18 #{UI.TextEdit} 50 20 nil 1280 50 2 8 1141047424 1025 1408 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1408 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 498 50 2 546 #createWindow: 50 1 594 626 8 #[72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 193 1440 nil 1408 546 #setMarginWidths: 50 1 8 #(3 3) 1408 3 8 #() 706 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 19 1762 #fixedParentRight -13 1762 #fixedPreviousTop -1 1762 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 1280 50 2 8 1140850944 1 1840 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 1840 nil nil 1506 nil nil true 498 50 2 546 #createWindow: 50 1 594 626 8 #[8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 193 1872 nil 1840 546 #text: 50 1 8 'Fi&nd what:' 1840 3 8 #() 706 193 193 nil 27 1730 1762 #fixedParentLeft 5 1762 #fixedViewLeft 111 1762 #fixedParentTop 1 1824 31 18 #{UI.ContainerView} 50 15 nil 1280 50 2 8 1140916224 131073 2256 nil nil nil 5 nil nil nil 2256 306 17 1 1 550 #{Core.IdentityDictionary} 0 1058 706 1 11 706 1 1 498 50 1 546 #createWindow: 50 1 594 626 8 #[6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 193 2288 8 '' 2256 3 50 2 18 #{UI.ContainerView} 50 15 nil 2256 50 2 8 1140916224 131073 2560 nil nil nil 5 nil nil nil 2560 1346 338 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 2560 50 2 8 1140850695 65 2672 nil nil nil 5 nil nil nil 2672 nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 193 2704 8 'Search Mode' 2672 3 8 #() 706 193 193 nil 27 1730 2208 1 1792 1 2240 1 1762 #fixedParentBottom 1 18 #{UI.ContainerView} 50 15 nil 2560 50 2 8 1140916224 131073 2928 nil nil nil 5 nil nil nil 2928 1030 #{UI.GridLayout} 7 1 1 1 338 2336 50 6 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1140924425 1 3056 1906 nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3056 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 193 3088 8 '&Regular Expression' 3056 3 8 #() 706 193 193 nil 27 8 'regularExpression' 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1141055497 1 3440 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3440 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 193 3472 8 '&Text' 3440 3 8 #() 706 193 193 nil 27 8 'text' 18 #{UI.RadioButton} 50 16 nil 2928 50 2 8 1140924425 1 3792 1906 nil nil 3138 3170 #= 8 #() 3170 #hash 8 #() false nil nil 517 nil nil nil 3792 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 193 3824 8 '&Wildcard Expression' 3792 3 8 #() 706 193 193 nil 27 8 'wildcardExpression' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 193 2960 8 '' 2928 3 50 3 3440 3792 3056 706 193 193 nil 27 1730 2208 19 1792 -7 2240 31 2912 -13 338 2336 50 2 2928 8 'mode' nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 193 2592 8 '' 2560 3 50 2 2672 2928 706 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 2256 50 2 8 1140850688 131073 4528 nil nil nil 5 nil nil nil 4528 2994 7 1 1 1 338 2336 50 2 18 #{UI.CheckBox} 50 16 nil 4528 50 2 8 1141055491 1 4640 1906 nil nil 1952 false nil nil 517 nil nil nil 4640 nil nil 1506 nil nil nil 498 50 1 546 #createWindow: 50 1 594 626 8 #[5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 193 4672 8 'Match &case' 4640 3 8 #() 706 193 193 nil 27 8 'matchCase' 1058 706 11 11 706 1 1 498 50 1 546 #createWindow: 50 1 594 626 8 #[148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 193 4560 8 '' 4528 3 50 1 4640 706 193 193 nil 27 706 193 193 nil 27 1730 2208 1 1792 1 1762 #fixedPreviousBottom 11 2912 1 338 2336 50 4 1408 8 'pattern' 1840 8 'prompt' 1058 706 13 31 706 11 21 498 50 1 546 #createWindow: 50 1 594 626 8 #[5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 193 1312 8 '' 1280 3 50 3 1840 1408 2256 706 193 193 nil 27 2338 0 1058 706 11 1 706 11 1 nil nil nil nil 1 nil nil 706 2049 397 706 761 397 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil 498 50 2 546 #createWindow: 50 1 518 #{UI.CreateDialog} 626 8 #[255 14 0 0 10 0 0 0 123 16 0 0 208 0 0 0] 193 32 546 #setWindowText: 50 1 8 'Find' 32 1 50 2 1280 240 706 193 193 nil 27)!

showModeless: aView on: aFindDetails
	^(self on: aFindDetails)
		ownerView: aView;
		createView: self defaultView;
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

