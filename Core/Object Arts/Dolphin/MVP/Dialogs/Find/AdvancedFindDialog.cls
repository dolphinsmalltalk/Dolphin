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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 17 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 7 nil nil nil 608 656198 1 ##(Smalltalk.FlowLayout) 1 11 1 170 192 34 4 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 736 nil nil nil 7 nil nil nil 736 nil 8 1797935936 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'C&lose' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 193 768 8 'C&lose' 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 8 'cancel' 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1141055488 1 1136 nil nil nil 7 nil nil nil 1136 nil 8 1797935936 818 #ok 8 '&Find' 1 5 nil nil true nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 193 1168 8 '&Find' 1136 930 #isEnabled: 8 #(false) 1136 3 8 #() 1090 193 193 nil 29 8 'ok' 590342 ##(Smalltalk.Rectangle) 1090 1 21 1090 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[138 1 0 0 0 0 0 0 218 1 0 0 159 0 0 0] 193 640 8 '' 608 3 34 2 1136 736 1090 193 193 nil 27 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1712 nil nil nil 7 nil nil nil 1712 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.ContainerView) 34 15 nil 1712 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 674 17 1 1 170 192 8 #() 1474 1090 1 11 1090 1 1 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[6 0 0 0 39 0 0 0 120 1 0 0 149 0 0 0] 193 1872 8 '' 1840 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 2160 nil nil nil 7 nil nil nil 2160 1778 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 2160 34 2 8 1140850695 65 2272 nil nil nil 7 nil nil nil 2272 nil 8 1797935936 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 140 0 0 0 100 0 0 0] 193 2304 8 'Search Mode' 2272 3 8 #() 1090 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2562 #fixedParentRight 1 2562 #fixedParentTop 1 2562 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2160 34 2 8 1140850688 131073 2640 nil nil nil 7 nil nil nil 2640 656390 ##(Smalltalk.GridLayout) 7 1 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140989961 1 2768 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2898 #hash 8 #() false nil nil 7 nil nil nil 2768 nil 8 1797935936 852486 ##(Smalltalk.NullConverter) nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 127 0 0 0 26 0 0 0] 193 2800 8 '&Text' 2768 3 8 #() 1090 193 193 nil 27 8 'text' 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140858889 1 3216 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 7 nil nil nil 3216 nil 8 1797935936 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 26 0 0 0 127 0 0 0 52 0 0 0] 193 3248 8 '&Wildcard Expression' 3216 3 8 #() 1090 193 193 nil 27 8 'wildcardExpression' 410 ##(Smalltalk.RadioButton) 34 16 nil 2640 34 2 8 1140858889 1 3600 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 7 nil nil nil 3600 nil 8 1797935936 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 52 0 0 0 127 0 0 0 78 0 0 0] 193 3632 8 '&Regular Expression' 3600 3 8 #() 1090 193 193 nil 27 8 'regularExpression' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[9 0 0 0 16 0 0 0 136 0 0 0 94 0 0 0] 193 2672 8 '' 2640 3 34 3 2768 3216 3600 1090 193 193 nil 27 2530 2576 19 2592 -7 2608 33 2624 -11 170 192 34 2 2640 8 'mode' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 5 0 0 0 140 0 0 0 105 0 0 0] 193 2192 8 '' 2160 3 34 2 2272 2640 1090 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 4400 nil nil nil 7 nil nil nil 4400 1778 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 4400 34 2 8 1140850688 131073 4512 nil nil nil 7 nil nil nil 4512 674 1 11 1 170 192 34 4 410 ##(Smalltalk.CheckBox) 34 16 nil 4512 34 2 8 1141058819 1 4624 2834 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 519 nil nil nil 4624 nil 8 1797935936 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 78 0 0 0 18 0 0 0] 193 4656 8 '&Whole word' 4624 3 8 #() 1090 193 193 nil 27 8 'matchWhole' 410 ##(Smalltalk.CheckBox) 34 16 nil 4512 34 2 8 1140924419 1 4960 2834 nil nil 4720 false nil nil 519 nil nil nil 4960 nil 8 1797935936 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 23 0 0 0 39 0 0 0 41 0 0 0] 193 4992 8 '&Case' 4960 3 8 #() 1090 193 193 nil 27 8 'matchCase' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[11 0 0 0 17 0 0 0 93 0 0 0 92 0 0 0] 193 4544 8 '' 4512 3 34 2 4624 4960 1090 193 193 nil 27 2530 2576 23 2592 -17 2608 35 2624 -15 410 ##(Smalltalk.GroupBox) 34 14 nil 4400 34 2 8 1140850695 65 5456 nil nil nil 7 nil nil nil 5456 nil 8 1797935936 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 102 0 0 0 100 0 0 0] 193 5488 8 'Match' 5456 3 8 #() 1090 193 193 nil 27 2530 2576 1 2592 1 2608 1 2624 1 170 192 1936 nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[148 0 0 0 5 0 0 0 250 0 0 0 105 0 0 0] 193 4432 8 '' 4400 3 34 2 5456 4512 1090 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 1840 34 2 8 1140850688 131073 5920 nil nil nil 7 nil nil nil 5920 1778 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 5920 34 2 8 1140850688 131073 6032 nil nil nil 7 nil nil nil 6032 674 1 11 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 6032 34 2 8 1141055497 1 6144 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 7 nil nil nil 6144 nil 8 1797935936 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 40 0 0 0 21 0 0 0] 193 6176 8 '&Up' 6144 3 8 #() 1090 193 193 nil 27 8 'up' 410 ##(Smalltalk.RadioButton) 34 16 nil 6032 34 2 8 1140858889 1 6528 2834 nil nil 2866 2898 #= 8 #() 2898 #hash 8 #() false nil nil 7 nil nil nil 6528 nil 8 1797935936 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[40 0 0 0 0 0 0 0 88 0 0 0 21 0 0 0] 193 6560 8 '&Down' 6528 3 8 #() 1090 193 193 nil 27 8 'down' 410 ##(Smalltalk.CheckBox) 34 16 nil 6032 34 2 8 1140924419 1 6912 2834 nil nil 4720 false nil nil 7 nil nil nil 6912 nil 8 1797935936 2994 nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 26 0 0 0 90 0 0 0 47 0 0 0] 193 6944 8 '&Wrap around' 6912 3 8 #() 1090 193 193 nil 27 8 'wrap' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[9 0 0 0 16 0 0 0 104 0 0 0 91 0 0 0] 193 6064 8 '' 6032 3 34 3 6144 6528 6912 1090 193 193 nil 27 2530 2576 19 2592 -11 2608 33 2624 -17 410 ##(Smalltalk.GroupBox) 34 14 nil 5920 34 2 8 1140850695 65 7408 nil nil nil 7 nil nil nil 7408 nil 8 1797935936 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 110 0 0 0 100 0 0 0] 193 7440 8 'Direction' 7408 3 8 #() 1090 193 193 nil 27 2530 2576 1 2592 1 2608 1 2624 1 170 192 34 2 6032 8 'direction' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[2 1 0 0 5 0 0 0 112 1 0 0 105 0 0 0] 193 5952 8 '' 5920 3 34 2 7408 6032 1090 193 193 nil 27 1090 193 193 nil 27 2530 2576 1 2592 1 2562 #fixedPreviousBottom 11 2624 1 410 ##(Smalltalk.TextEdit) 34 16 nil 1712 34 2 8 1141047424 1025 7952 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 7952 nil 8 1797928640 2994 nil nil 5 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[72 0 0 0 12 0 0 0 119 1 0 0 34 0 0 0] 193 7984 nil 7952 930 #setMarginWidths: 34 1 8 #(3 3) 7952 3 8 #() 1090 193 193 nil 27 2530 2562 #fixedPreviousRight 19 2592 -1 2562 #fixedPreviousTop -5 2562 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1712 34 2 8 1140850944 1 8352 2834 nil nil 4720 8 '' nil nil 7 nil nil nil 8352 nil 8 1798140960 2994 nil nil true 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[8 0 0 0 15 0 0 0 63 0 0 0 35 0 0 0] 193 8384 nil 8352 930 #text: 34 1 8 'Fi&nd what:' 8352 3 8 #() 1090 193 193 nil 27 2530 2576 5 2562 #fixedViewLeft 111 2608 1 8336 41 170 192 34 4 7952 8 'pattern' 8352 8 'prompt' 1474 1090 13 31 1090 11 21 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[5 0 0 0 0 0 0 0 130 1 0 0 159 0 0 0] 193 1744 8 '' 1712 3 34 3 8352 7952 1840 1090 193 193 nil 27 170 192 1936 1474 1090 11 1 1090 11 1 nil nil nil nil 21965 nil nil 1090 2049 397 1090 991 397 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2005044496 866 138 144 34 2 930 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1010 8 #[255 9 0 0 10 0 0 0 238 11 0 0 208 0 0 0] 193 416 930 #setWindowText: 34 1 8 'Find' 416 1 34 2 1712 608 1090 193 193 nil 27 )!

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

