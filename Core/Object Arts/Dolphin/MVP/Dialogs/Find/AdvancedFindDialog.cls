"Filed out from Dolphin Smalltalk"!

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

!AdvancedFindDialog categoriesForMethods!
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

initialize
	WildCardMask := 1.
	RegExpMask := 2.!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 17 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 736 nil nil nil 5 nil nil nil 736 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 193 768 8 'C&lose' 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 8 'cancel' 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1141055488 1 1136 nil nil nil 5 nil nil nil 1136 nil 8 1759007584 818 #ok 8 '&Find' 1 5 nil nil true nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 193 1168 8 '&Find' 1136 930 #isEnabled: 8 #(false) 1136 3 8 #() 1090 193 193 nil 29 8 'ok' 590342 ##(Smalltalk.Rectangle) 1090 1 21 1090 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 193 640 8 '' 608 3 34 2 1136 736 1090 193 193 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1712 nil nil nil 5 nil nil nil 1712 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.ContainerView) 34 15 nil 1712 34 2 8 1140850688 131073 1840 nil nil nil 5 nil nil nil 1840 674 17 1 1 170 192 8 #() 1474 1090 1 11 1090 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 193 1872 8 '' 1840 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 2160 nil nil nil 5 nil nil nil 2160 1778 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 2160 34 2 8 1140850695 65 2272 nil nil nil 5 nil nil nil 2272 nil 8 1759007584 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 193 2304 8 'Search Mode' 2272 3 8 #() 1090 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2562 #fixedParentRight 1 2562 #fixedParentTop 1 2562 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2160 34 2 8 1140850688 131073 2640 nil nil nil 5 nil nil nil 2640 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140989961 1 2768 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 2768 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 193 2800 8 '&Text' 2768 3 8 #() 1090 193 193 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140858889 1 3216 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 3216 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 193 3248 8 '&Wildcard Expression' 3216 3 8 #() 1090 193 193 nil 27 8 'wildcardExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140858889 1 3600 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 3600 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 193 3632 8 '&Regular Expression' 3600 3 8 #() 1090 193 193 nil 27 8 'regularExpression' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 193 2672 8 '' 2640 3 34 3 2768 3216 3600 1090 193 193 nil 27 2530 2576 19 2592 -7 2608 33 2624 -11 170 192 34 2 2640 8 'mode' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 193 2192 8 '' 2160 3 34 2 2272 2640 1090 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 4400 nil nil nil 5 nil nil nil 4400 1778 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 4400 34 2 8 1140850688 131073 4512 nil nil nil 5 nil nil nil 4512 674 1 11 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 4512 34 2 8 1141058819 1 4624 2834 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 517 nil nil nil 4624 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 78 0 0 0 18 0 0 0] 193 4656 8 '&Whole word' 4624 3 8 #() 1090 193 193 nil 27 8 'matchWhole' 410 ##(Smalltalk.CheckBox) 34 16 nil 4512 34 2 8 1140924419 1 4960 2834 nil nil 4720 false nil nil 517 nil nil nil 4960 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 23 0 0 0 39 0 0 0 41 0 0 0] 193 4992 8 '&Case' 4960 3 8 #() 1090 193 193 nil 27 8 'matchCase' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 193 4544 8 '' 4512 3 34 2 4624 4960 1090 193 193 nil 27 2530 2576 23 2592 -17 2608 35 2624 -15 410 ##(Smalltalk.GroupBox) 34 14 nil 4400 34 2 8 1140850695 65 5456 nil nil nil 5 nil nil nil 5456 nil 8 1759007584 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 193 5488 8 'Match' 5456 3 8 #() 1090 193 193 nil 27 2530 2576 1 2592 1 2608 1 2624 1 170 192 1936 nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 193 4432 8 '' 4400 3 34 2 5456 4512 1090 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 5920 nil nil nil 5 nil nil nil 5920 1778 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 5920 34 2 8 1140850695 65 6032 nil nil nil 5 nil nil nil 6032 nil 8 1759007584 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 193 6064 8 'Direction' 6032 3 8 #() 1090 193 193 nil 27 2530 2576 1 2592 1 2608 1 2624 1 410 ##(Smalltalk.ContainerView) 34 15 nil 5920 34 2 8 1140850688 131073 6304 nil nil nil 5 nil nil nil 6304 674 1 11 1 170 192 34 6 410 ##(Smalltalk.CheckBox) 34 16 nil 6304 34 2 8 1140924419 1 6416 2834 nil nil 4720 false nil nil 5 nil nil nil 6416 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 193 6448 8 '&Wrap around' 6416 3 8 #() 1090 193 193 nil 27 8 'wrap' 410 ##(Smalltalk.RadioButton) 34 16 nil 6304 34 2 8 1140858889 1 6720 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 6720 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 193 6752 8 '&Down' 6720 3 8 #() 1090 193 193 nil 27 8 'down' 410 ##(Smalltalk.RadioButton) 34 16 nil 6304 34 2 8 1141055497 1 7104 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 7104 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 193 7136 8 '&Up' 7104 3 8 #() 1090 193 193 nil 27 8 'up' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 193 6336 8 '' 6304 3 34 3 7104 6720 6416 1090 193 193 nil 27 2530 2576 19 2592 -11 2608 33 2624 -17 170 192 34 2 6304 8 'direction' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 193 5952 8 '' 5920 3 34 2 6032 6304 1090 193 193 nil 27 1090 193 193 nil 27 2530 2576 1 2592 1 2562 #fixedPreviousBottom 11 2624 1 410 ##(Smalltalk.TextEdit) 34 16 nil 1712 34 2 8 1141047424 1025 7952 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 7952 nil 8 1759000288 2994 nil nil 5 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 193 7984 nil 7952 930 #setMarginWidths: 34 1 8 #(3 3) 7952 3 8 #() 1090 193 193 nil 27 2530 2562 #fixedPreviousRight 19 2592 -1 2562 #fixedPreviousTop -5 2562 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1712 34 2 8 1140850944 1 8352 2834 nil nil 4720 8 '' nil nil 5 nil nil nil 8352 nil 8 1759212608 2994 nil nil true 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 193 8384 nil 8352 930 #text: 34 1 8 'Fi&nd what:' 8352 3 8 #() 1090 193 193 nil 27 2530 2576 5 2562 #fixedViewLeft 111 2608 1 8336 41 170 192 34 4 7952 8 'pattern' 8352 8 'prompt' 1474 1090 13 31 1090 11 21 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 193 1744 8 '' 1712 3 34 3 8352 7952 1840 1090 193 193 nil 27 170 192 1936 1474 1090 11 1 1090 11 1 nil nil nil nil 10025 nil nil 1090 2049 397 1090 991 397 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1474 1090 1 1 1090 991 397 193 416 930 #setWindowText: 34 1 8 'Find' 416 1 34 2 1712 608 1090 193 193 nil 29 )!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140858880 1 736 nil nil nil 5 nil nil nil 736 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 193 768 8 'C&lose' 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 8 'cancel' 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1141055488 1 1136 nil nil nil 5 nil nil nil 1136 nil 8 1759007584 818 #ok 8 '&Find' 1 5 nil nil true nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 193 1168 8 '&Find' 1136 930 #isEnabled: 8 #(false) 1136 3 8 #() 1090 193 193 nil 29 8 'ok' 590342 ##(Smalltalk.Rectangle) 1090 1 21 1090 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[18 1 0 0 0 0 0 0 98 1 0 0 159 0 0 0] 193 640 8 '' 608 3 34 2 1136 736 1090 193 193 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1712 nil nil nil 5 nil nil nil 1712 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.ContainerView) 34 15 nil 1712 34 2 8 1140850688 131073 1840 nil nil nil 5 nil nil nil 1840 674 17 1 1 170 192 8 #() 1474 1090 1 11 1090 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[6 0 0 0 39 0 0 0 3 1 0 0 149 0 0 0] 193 1872 8 '' 1840 3 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 2160 nil nil nil 5 nil nil nil 2160 1778 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 2160 34 2 8 1140850695 65 2272 nil nil nil 5 nil nil nil 2272 nil 8 1759007584 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 193 2304 8 'Search Mode' 2272 3 8 #() 1090 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2562 #fixedParentRight 1 2562 #fixedParentTop 1 2562 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2160 34 2 8 1140850688 131073 2640 nil nil nil 5 nil nil nil 2640 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1141055497 1 2768 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 2768 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 126 0 0 0 26 0 0 0] 193 2800 8 '&Text' 2768 3 8 #() 1090 193 193 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140858889 1 3216 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 3216 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 52 0 0 0 126 0 0 0 78 0 0 0] 193 3248 8 '&Regular Expression' 3216 3 8 #() 1090 193 193 nil 27 8 'regularExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140858889 1 3600 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 5 nil nil nil 3600 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 26 0 0 0 126 0 0 0 52 0 0 0] 193 3632 8 '&Wildcard Expression' 3600 3 8 #() 1090 193 193 nil 27 8 'wildcardExpression' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[10 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 193 2672 8 '' 2640 3 34 3 2768 3600 3216 1090 193 193 nil 27 2530 2576 21 2592 -7 2608 33 2624 -11 170 192 34 2 2640 8 'mode' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 193 2192 8 '' 2160 3 34 2 2272 2640 1090 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 4400 nil nil nil 5 nil nil nil 4400 1778 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 4400 34 2 8 1140850688 131073 4512 nil nil nil 5 nil nil nil 4512 2706 7 1 1 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 4512 34 2 8 1141055491 1 4624 2834 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 4624 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 87 0 0 0 25 0 0 0] 193 4656 8 '&Whole word' 4624 3 8 #() 1090 193 193 nil 27 8 'matchWhole' 410 ##(Smalltalk.CheckBox) 34 16 nil 4512 34 2 8 1140858883 1 4960 2834 nil nil 4720 false nil nil 5 nil nil nil 4960 nil 8 1759007584 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 25 0 0 0 87 0 0 0 51 0 0 0] 193 4992 8 '&Case' 4960 3 8 #() 1090 193 193 nil 27 8 'matchCase' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[9 0 0 0 17 0 0 0 96 0 0 0 93 0 0 0] 193 4544 8 '' 4512 3 34 2 4624 4960 1090 193 193 nil 27 2530 2576 19 2592 -11 2608 35 2624 -13 410 ##(Smalltalk.GroupBox) 34 14 nil 4400 34 2 8 1140850695 65 5456 nil nil nil 5 nil nil nil 5456 nil 8 1759007584 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 193 5488 8 'Match' 5456 3 8 #() 1090 193 193 nil 27 2530 2576 1 2592 1 2608 1 2624 1 170 192 1936 nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 193 4432 8 '' 4400 3 34 2 5456 4512 1090 193 193 nil 27 1090 193 193 nil 27 2530 2576 1 2592 1 2562 #fixedPreviousBottom 11 2624 1 410 ##(Smalltalk.StaticText) 34 16 nil 1712 34 2 8 1140850944 1 5968 2834 nil nil 4720 8 '' nil nil 5 nil nil nil 5968 nil 8 1759212608 2994 nil nil true 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 193 6000 nil 5968 930 #text: 34 1 8 'Fi&nd what:' 5968 3 8 #() 1090 193 193 nil 27 2530 2576 5 2562 #fixedViewLeft 111 2608 1 2562 #fixedViewTop 31 410 ##(Smalltalk.TextEdit) 34 16 nil 1712 34 2 8 1141047424 1025 6352 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 6352 nil 8 1759000288 2994 nil nil 5 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[72 0 0 0 12 0 0 0 1 1 0 0 34 0 0 0] 193 6384 nil 6352 930 #setMarginWidths: 34 1 8 #(3 3) 6352 3 8 #() 1090 193 193 nil 27 2530 2562 #fixedPreviousRight 19 2592 -3 2562 #fixedPreviousTop -5 6336 45 170 192 34 4 6352 8 'pattern' 5968 8 'prompt' 1474 1090 13 31 1090 11 21 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[5 0 0 0 0 0 0 0 13 1 0 0 159 0 0 0] 193 1744 8 '' 1712 3 34 3 5968 6352 1840 1090 193 193 nil 27 170 192 1936 1474 1090 11 1 1090 11 1 nil nil nil nil 10059 nil nil 1090 2049 397 1090 751 397 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1474 1090 1 1 1090 751 397 193 416 930 #setWindowText: 34 1 8 'Find' 416 1 34 2 1712 608 1090 193 193 nil 29 )!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 11 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1141055488 1 736 nil nil nil 5 nil nil nil 736 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Find' 1 5 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 193 768 8 '&Find' 736 930 #isEnabled: 8 #(false) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 8 'ok' 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1168 nil nil nil 5 nil nil nil 1168 nil 8 1759007584 818 #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 193 1200 8 'C&lose' 1168 3 8 #() 1122 193 193 nil 29 8 'cancel' 590342 ##(Smalltalk.Rectangle) 1122 1 21 1122 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[23 1 0 0 0 0 0 0 103 1 0 0 159 0 0 0] 193 640 8 '' 608 3 34 2 736 1168 1122 193 193 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1712 nil nil nil 5 nil nil nil 1712 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.StaticText) 34 16 nil 1712 34 2 8 1140850944 1 1840 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 5 nil nil nil 1840 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil true 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 193 1872 nil 1840 930 #text: 34 1 8 'Fi&nd what:' 1840 3 8 #() 1122 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 5 2274 #fixedViewLeft 111 2274 #fixedParentTop 1 2274 #fixedViewTop 31 410 ##(Smalltalk.ContainerView) 34 15 nil 1712 34 2 8 1140916224 131073 2352 nil nil nil 5 nil nil nil 2352 674 17 1 1 170 192 8 #() 1474 1122 1 11 1122 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[6 0 0 0 41 0 0 0 8 1 0 0 149 0 0 0] 193 2384 8 '' 2352 3 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 2352 34 2 8 1140916224 131073 2672 nil nil nil 5 nil nil nil 2672 1778 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 2672 34 2 8 1140916224 131073 2784 nil nil nil 5 nil nil nil 2784 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 2784 34 2 8 1140924425 1 2912 1906 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 3026 #hash 8 #() false nil nil 5 nil nil nil 2912 nil 8 1759007584 2002 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 193 2944 8 '&Wildcard Expression' 2912 3 8 #() 1122 193 193 nil 27 8 'wildcardExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 2784 34 2 8 1141055497 1 3328 1906 nil nil 2994 3026 #= 8 #() 3026 #hash 8 #() false nil nil 5 nil nil nil 3328 nil 8 1759007584 2002 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 193 3360 8 '&Text' 3328 3 8 #() 1122 193 193 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 2784 34 2 8 1140924425 1 3712 1906 nil nil 2994 3026 #= 8 #() 3026 #hash 8 #() false nil nil 5 nil nil nil 3712 nil 8 1759007584 2002 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 193 3744 8 '&Regular Expression' 3712 3 8 #() 1122 193 193 nil 27 8 'regularExpression' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[9 0 0 0 15 0 0 0 136 0 0 0 93 0 0 0] 193 2816 8 '' 2784 3 34 3 3328 2912 3712 1122 193 193 nil 27 2242 2288 19 2274 #fixedParentRight -7 2320 31 2274 #fixedParentBottom -13 410 ##(Smalltalk.GroupBox) 34 14 nil 2672 34 2 8 1140850695 65 4320 nil nil nil 5 nil nil nil 4320 nil 8 1759007584 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 193 4352 8 'Search Mode' 4320 3 8 #() 1122 193 193 nil 27 2242 2288 1 4288 1 2320 1 4304 1 170 192 34 2 2784 8 'mode' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 193 2704 8 '' 2672 3 34 2 4320 2784 1122 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 2352 34 2 8 1140850688 131073 4816 nil nil nil 5 nil nil nil 4816 2850 7 1 1 1 170 192 34 2 410 ##(Smalltalk.CheckBox) 34 16 nil 4816 34 2 8 1141055491 1 4928 1906 nil nil 1952 false nil nil 5 nil nil nil 4928 nil 8 1759007584 2002 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[5 0 0 0 5 0 0 0 102 0 0 0 37 0 0 0] 193 4960 8 'Match &case' 4928 3 8 #() 1122 193 193 nil 27 8 'matchCase' 1474 1122 11 11 1122 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 193 4848 8 '' 4816 3 34 1 4928 1122 193 193 nil 27 1122 193 193 nil 27 2242 2288 1 4288 1 2274 #fixedPreviousBottom 11 4304 1 410 ##(Smalltalk.TextEdit) 34 16 nil 1712 34 2 8 1141047424 1025 5504 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 5504 nil 8 1759000288 2002 nil nil 5 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[72 0 0 0 14 0 0 0 1 1 0 0 36 0 0 0] 193 5536 nil 5504 930 #setMarginWidths: 34 1 8 #(3 3) 5504 3 8 #() 1122 193 193 nil 27 2242 2274 #fixedPreviousRight 19 4288 -13 2274 #fixedPreviousTop -1 2336 45 170 192 34 4 5504 8 'pattern' 1840 8 'prompt' 1474 1122 13 31 1122 11 21 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[5 0 0 0 0 0 0 0 18 1 0 0 159 0 0 0] 193 1744 8 '' 1712 3 34 3 1840 5504 2352 1122 193 193 nil 27 170 192 2448 1474 1122 11 1 1122 11 1 nil nil nil nil 10087 nil nil 1122 2049 397 1122 761 397 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1474 1122 1 1 1122 761 397 193 416 930 #setWindowText: 34 1 8 'Find' 416 1 34 2 1712 608 1122 193 193 nil 29 )!

showModeless: aView on: aFindDetails
	^(self on: aFindDetails)
		ownerView: aView;
		createView: self defaultView;
		show! !

!AdvancedFindDialog class categoriesForMethods!
createOn:prompt:caption:!instance creation!public! !
defaultModel!models!public! !
icon!constants!public! !
initialize!initializing!public! !
resource_Default_view!public!resources-views! !
resource_Directionless_view!public!resources-views! !
resource_Selector_view!public!resources-views! !
showModeless:on:!instance creation!public! !
!

