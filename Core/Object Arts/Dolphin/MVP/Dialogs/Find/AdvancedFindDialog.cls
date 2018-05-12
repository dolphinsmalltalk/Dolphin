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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  11 1 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 656198 1 ##(Smalltalk.FlowLayout)  1 11 1 234 256 98 4 410 8 ##(Smalltalk.PushButton)  98 20 0 560 98 2 8 1140924416 1 704 0 0 0 7 0 0 0 704 0 8 4294903999 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 'C&lose' 1 1 0 0 32 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 77 994 151 47 704 930 8 #text: 98 1 8 'C&lose' 704 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 98 0 994 193 193 0 29 8 'cancel' 410 720 98 20 0 560 98 2 8 1141055488 1 1200 0 0 0 7 0 0 0 1200 0 8 4294903999 802 8 #ok 8 '&Find' 1 5 0 0 16 0 0 0 866 202 208 98 3 930 960 98 2 994 1 21 994 151 47 1200 930 8 #isEnabled: 98 1 32 1200 930 1056 98 1 8 '&Find' 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 98 0 1168 0 29 8 'ok' 590342 ##(Smalltalk.Rectangle)  994 1 21 994 1 1 866 202 208 98 1 930 960 98 2 994 769 1 994 161 383 560 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 128 1 0 0 0 0 0 0 208 1 0 0 191 0 0 0] 98 2 1200 704 1168 0 27 0 410 576 98 15 0 416 98 2 8 1140850688 131073 1824 0 0 0 7 0 0 0 1824 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 576 98 15 0 1824 98 2 8 1140850688 131073 1952 0 0 0 7 0 0 0 1952 642 11 1 1 234 256 98 0 1602 994 1 11 994 1 1 866 202 208 98 1 930 960 98 2 994 13 89 994 727 275 1952 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 44 0 0 0 113 1 0 0 181 0 0 0] 98 3 410 576 98 15 0 1952 98 2 8 1140850688 131073 2272 0 0 0 7 0 0 0 2272 1890 234 240 98 4 410 8 ##(Smalltalk.GroupBox)  98 14 0 2272 98 2 8 1140850695 65 2384 0 0 0 7 0 0 0 2384 0 8 4294903999 866 202 208 98 2 930 960 98 2 994 1 1 994 271 271 2384 930 1056 98 1 8 'Search Mode' 2384 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 135 0 0 0 135 0 0 0] 98 0 1168 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 2722 8 #fixedParentRight 1 2722 8 #fixedParentTop 1 2722 8 #fixedParentBottom 1 410 576 98 15 0 2272 98 2 8 1140850688 131073 2864 0 0 0 7 0 0 0 2864 656390 ##(Smalltalk.GridLayout)  7 1 1 1 234 256 98 6 410 8 ##(Smalltalk.RadioButton)  98 16 0 2864 98 2 8 1141055497 1 2992 721990 2 ##(Smalltalk.ValueHolder)  0 0 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 3138 8 #hash 98 0 32 0 0 7 0 0 0 2992 0 8 4294903999 852486 ##(Smalltalk.NullConverter)  0 0 0 866 202 208 98 2 930 960 98 2 994 1 1 994 245 77 2992 930 1056 98 1 8 '&Text' 2992 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 122 0 0 0 38 0 0 0] 98 0 1168 0 27 8 'text' 410 3008 98 16 0 2864 98 2 8 1140858889 1 3520 3074 0 0 3106 3138 3168 98 0 3138 3216 98 0 32 0 0 7 0 0 0 3520 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 77 994 245 75 3520 930 1056 98 1 8 '&Wildcard Expression' 3520 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 122 0 0 0 75 0 0 0] 98 0 1168 0 27 8 'wildcardExpression' 410 3008 98 16 0 2864 98 2 8 1140858889 1 3936 3074 0 0 3106 3138 3168 98 0 3138 3216 98 0 32 0 0 7 0 0 0 3936 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 151 994 245 77 3936 930 1056 98 1 8 '&Regular Expression' 3936 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 75 0 0 0 122 0 0 0 113 0 0 0] 98 0 1168 0 27 8 'regularExpression' 0 866 202 208 98 1 930 960 98 2 994 19 33 994 245 227 2864 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 131 0 0 0 129 0 0 0] 98 3 2992 3520 3936 1168 0 27 2690 2736 19 2768 -7 2800 33 2832 -11 234 256 98 2 2864 8 'mode' 0 866 202 208 98 1 930 960 98 2 994 1 11 994 271 271 2272 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 135 0 0 0 140 0 0 0] 98 2 2384 2864 1168 0 27 410 576 98 15 0 1952 98 2 8 1140850688 131073 4736 0 0 0 7 0 0 0 4736 1890 234 240 98 4 410 2400 98 14 0 4736 98 2 8 1140850695 65 4848 0 0 0 7 0 0 0 4848 0 8 4294903999 866 202 208 98 2 930 960 98 2 994 3 5 994 199 231 4848 930 1056 98 1 8 'Match' 4848 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 2 0 0 0 100 0 0 0 117 0 0 0] 98 0 1168 0 27 2690 2736 3 2768 1 2800 5 2832 -35 410 576 98 15 0 4736 98 2 8 1140850688 131073 5152 0 0 0 7 0 0 0 5152 2930 5 1 1 1 234 256 98 4 410 8 ##(Smalltalk.CheckBox)  98 16 0 5152 98 2 8 1140924419 1 5264 3074 0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 0 0 7 0 0 0 5264 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 71 994 161 71 5264 930 1056 98 1 8 '&Case' 5264 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 35 0 0 0 80 0 0 0 70 0 0 0] 98 0 1168 0 27 8 'matchCase' 410 5280 98 16 0 5152 98 2 8 1141055491 1 5648 3074 0 0 5376 32 0 0 7 0 0 0 5648 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 1 994 161 71 5648 930 1056 98 1 8 '&Whole word' 5648 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 35 0 0 0] 98 0 1168 0 27 8 'matchWhole' 0 866 202 208 98 1 930 960 98 2 994 23 35 994 161 141 5152 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 17 0 0 0 91 0 0 0 87 0 0 0] 98 2 5648 5264 1168 0 27 2690 2736 23 2768 -17 2800 35 2832 -95 234 256 2048 0 866 202 208 98 1 930 960 98 2 994 281 11 994 201 271 4736 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 5 0 0 0 240 0 0 0 140 0 0 0] 98 2 4848 5152 1168 0 27 410 576 98 15 0 1952 98 2 8 1140850688 131073 6336 0 0 0 7 0 0 0 6336 1890 234 240 98 4 410 576 98 15 0 6336 98 2 8 1140850688 131073 6448 0 0 0 7 0 0 0 6448 642 1 45 1 234 256 98 6 410 5280 98 16 0 6448 98 2 8 1140858883 1 6560 3074 0 0 5376 32 0 0 7 0 0 0 6560 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 87 994 181 43 6560 930 1056 98 1 8 '&Wrap around' 6560 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 43 0 0 0 90 0 0 0 64 0 0 0] 98 0 1168 0 27 8 'wrap' 410 3008 98 16 0 6448 98 2 8 1141055497 1 6896 3074 0 0 3106 3138 3168 98 0 3138 3216 98 0 32 0 0 7 0 0 0 6896 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 1 994 89 43 6896 930 1056 98 1 8 '&Up' 6896 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 44 0 0 0 21 0 0 0] 98 0 1168 0 27 8 'up' 410 3008 98 16 0 6448 98 2 8 1140858889 1 7312 3074 0 0 3106 3138 3168 98 0 3138 3216 98 0 32 0 0 7 0 0 0 7312 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 89 1 994 97 43 7312 930 1056 98 1 8 '&Down' 7312 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 44 0 0 0 0 0 0 0 92 0 0 0 21 0 0 0] 98 0 1168 0 27 8 'down' 0 866 202 208 98 1 930 960 98 2 994 19 33 994 191 221 6448 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 16 0 0 0 104 0 0 0 126 0 0 0] 98 3 6896 7312 6560 1168 0 27 2690 2736 19 2768 -11 2800 33 2832 -17 410 2400 98 14 0 6336 98 2 8 1140850695 65 7904 0 0 0 7 0 0 0 7904 0 8 4294903999 866 202 208 98 2 930 960 98 2 994 1 1 994 221 271 7904 930 1056 98 1 8 'Direction' 7904 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 110 0 0 0 135 0 0 0] 98 0 1168 0 27 2690 2736 1 2768 1 2800 1 2832 1 234 256 98 2 6448 8 'direction' 0 866 202 208 98 1 930 960 98 2 994 491 11 994 221 271 6336 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 0 0 0 5 0 0 0 99 1 0 0 140 0 0 0] 98 2 7904 6448 1168 0 27 1168 0 27 2690 2736 1 2768 1 2722 8 #fixedPreviousBottom 11 2832 1 410 8 ##(Smalltalk.StaticText)  98 16 0 1824 98 2 8 1140850944 1 8464 3074 0 0 5376 8 '' 0 0 7 0 0 0 8464 0 8 4294903517 3266 0 0 16 866 202 208 98 2 930 960 98 2 994 17 31 994 111 31 8464 930 1056 98 1 8 'Fi&nd what:' 8464 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 98 0 1168 0 27 2690 2736 5 2722 8 #fixedViewLeft 111 2800 1 2722 8 #fixedViewTop 31 410 8 ##(Smalltalk.TextEdit)  98 16 0 1824 98 2 8 1141047424 1025 8896 0 482 512 0 7 0 0 0 8896 0 8 4294903869 3266 0 0 5 866 202 208 98 3 930 960 98 2 994 145 29 994 581 51 8896 930 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 8896 930 8 #isTextModified: 98 1 32 8896 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 106 1 0 0 39 0 0 0] 98 0 1168 0 27 2690 2722 8 #fixedPreviousRight 19 2768 -13 2722 8 #fixedPreviousTop -1 8864 51 234 256 98 4 8896 8 'pattern' 8464 8 'prompt' 1602 994 13 31 994 11 21 866 202 208 98 1 930 960 98 2 994 11 1 994 749 383 1824 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 123 1 0 0 191 0 0 0] 98 3 8464 8896 1952 1168 0 27 234 256 2048 1602 994 11 1 994 11 1 0 0 0 0 9057 0 0 994 2049 461 994 961 461 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1998891648 866 202 208 98 3 930 960 98 2 994 2795 21 994 971 461 416 930 1056 98 1 8 'Find' 416 930 8 #updateMenuBar 2048 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 5 0 0 10 0 0 0 90 7 0 0 240 0 0 0] 98 2 1824 560 1168 0 27 )!

resource_Directionless_view
	"Answer the literal data from which the 'Directionless view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Directionless_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  11 1 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 656198 1 ##(Smalltalk.FlowLayout)  1 11 1 234 256 98 4 410 8 ##(Smalltalk.PushButton)  98 20 0 560 98 2 8 1140858880 1 704 0 0 0 7 0 0 0 704 0 8 4294903999 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 'C&lose' 1 1 0 0 32 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 77 994 151 47 704 930 8 #text: 98 1 8 'C&lose' 704 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 98 0 994 193 193 0 29 8 'cancel' 410 720 98 20 0 560 98 2 8 1141055488 1 1200 0 0 0 7 0 0 0 1200 0 8 4294903999 802 8 #ok 8 '&Find' 1 5 0 0 16 0 0 0 866 202 208 98 3 930 960 98 2 994 1 21 994 151 47 1200 930 8 #isEnabled: 98 1 32 1200 930 1056 98 1 8 '&Find' 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 98 0 1168 0 29 8 'ok' 590342 ##(Smalltalk.Rectangle)  994 1 21 994 1 1 866 202 208 98 1 930 960 98 2 994 559 1 994 161 383 560 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 191 0 0 0] 98 2 1200 704 1168 0 27 0 410 576 98 15 0 416 98 2 8 1140850688 131073 1824 0 0 0 7 0 0 0 1824 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.TextEdit)  98 16 0 1824 98 2 8 1141047424 1025 1952 0 482 512 0 7 0 0 0 1952 0 8 4294903869 852486 ##(Smalltalk.NullConverter)  0 0 5 866 202 208 98 3 930 960 98 2 994 145 29 994 381 51 1952 930 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1952 930 8 #isTextModified: 98 1 32 1952 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 6 1 0 0 39 0 0 0] 98 0 1168 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 19 2418 8 #fixedParentRight -3 2418 8 #fixedPreviousTop -1 2418 8 #fixedViewTop 51 410 8 ##(Smalltalk.StaticText)  98 16 0 1824 98 2 8 1140850944 1 2560 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  8 '' 0 0 7 0 0 0 2560 0 8 4294903517 2066 0 0 16 866 202 208 98 2 930 960 98 2 994 17 31 994 111 31 2560 930 1056 98 1 8 'Fi&nd what:' 2560 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 98 0 1168 0 27 2386 2418 8 #fixedParentLeft 5 2418 8 #fixedViewLeft 111 2418 8 #fixedParentTop 1 2528 31 410 576 98 15 0 1824 98 2 8 1140850688 131073 3072 0 0 0 7 0 0 0 3072 642 11 1 1 234 256 98 0 1602 994 1 11 994 1 1 866 202 208 98 1 930 960 98 2 994 13 89 994 517 275 3072 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 44 0 0 0 8 1 0 0 181 0 0 0] 98 2 410 576 98 15 0 3072 98 2 8 1140850688 131073 3392 0 0 0 7 0 0 0 3392 1890 234 240 98 4 410 576 98 15 0 3392 98 2 8 1140850688 131073 3504 0 0 0 7 0 0 0 3504 656390 ##(Smalltalk.GridLayout)  7 1 1 1 234 256 98 6 410 8 ##(Smalltalk.RadioButton)  98 16 0 3504 98 2 8 1141055497 1 3632 2642 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 3762 8 #hash 98 0 32 0 0 7 0 0 0 3632 0 8 4294903999 2066 0 0 0 866 202 208 98 2 930 960 98 2 994 1 1 994 243 77 3632 930 1056 98 1 8 '&Text' 3632 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 0 0 0 38 0 0 0] 98 0 1168 0 27 8 'text' 410 3648 98 16 0 3504 98 2 8 1140858889 1 4128 2642 0 0 3730 3762 3792 98 0 3762 3840 98 0 32 0 0 7 0 0 0 4128 0 8 4294903999 2066 0 0 0 866 202 208 98 2 930 960 98 2 994 1 151 994 243 77 4128 930 1056 98 1 8 '&Regular Expression' 4128 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 75 0 0 0 121 0 0 0 113 0 0 0] 98 0 1168 0 27 8 'regularExpression' 410 3648 98 16 0 3504 98 2 8 1140858889 1 4544 2642 0 0 3730 3762 3792 98 0 3762 3840 98 0 32 0 0 7 0 0 0 4544 0 8 4294903999 2066 0 0 0 866 202 208 98 2 930 960 98 2 994 1 77 994 243 75 4544 930 1056 98 1 8 '&Wildcard Expression' 4544 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 121 0 0 0 75 0 0 0] 98 0 1168 0 27 8 'wildcardExpression' 0 866 202 208 98 1 930 960 98 2 994 21 33 994 243 227 3504 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 16 0 0 0 131 0 0 0 129 0 0 0] 98 3 3632 4544 4128 1168 0 27 2386 2976 21 2464 -7 3040 33 2418 8 #fixedParentBottom -11 410 8 ##(Smalltalk.GroupBox)  98 14 0 3392 98 2 8 1140850695 65 5168 0 0 0 7 0 0 0 5168 0 8 4294903999 866 202 208 98 2 930 960 98 2 994 1 1 994 271 271 5168 930 1056 98 1 8 'Search Mode' 5168 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 135 0 0 0 135 0 0 0] 98 0 1168 0 27 2386 2976 1 2464 1 3040 1 5136 1 234 256 98 2 3504 8 'mode' 0 866 202 208 98 1 930 960 98 2 994 1 11 994 271 271 3392 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 135 0 0 0 140 0 0 0] 98 2 5168 3504 1168 0 27 410 576 98 15 0 3072 98 2 8 1140850688 131073 5696 0 0 0 7 0 0 0 5696 1890 234 240 98 4 410 5184 98 14 0 5696 98 2 8 1140850695 65 5808 0 0 0 7 0 0 0 5808 0 8 4294903999 866 202 208 98 2 930 960 98 2 994 1 1 994 231 271 5808 930 1056 98 1 8 'Match' 5808 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 115 0 0 0 135 0 0 0] 98 0 1168 0 27 2386 2976 1 2464 1 3040 1 5136 1 410 576 98 15 0 5696 98 2 8 1140850688 131073 6112 0 0 0 7 0 0 0 6112 3570 7 1 1 1 234 256 98 4 410 8 ##(Smalltalk.CheckBox)  98 16 0 6112 98 2 8 1141055491 1 6224 2642 0 0 2688 32 0 0 7 0 0 0 6224 0 8 4294903999 2066 0 0 0 866 202 208 98 2 930 960 98 2 994 1 1 994 201 75 6224 930 1056 98 1 8 '&Whole word' 6224 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 37 0 0 0] 98 0 1168 0 27 8 'matchWhole' 410 6240 98 16 0 6112 98 2 8 1140858883 1 6576 2642 0 0 2688 32 0 0 7 0 0 0 6576 0 8 4294903999 2066 0 0 0 866 202 208 98 2 930 960 98 2 994 1 75 994 201 75 6576 930 1056 98 1 8 '&Case' 6576 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 37 0 0 0 100 0 0 0 74 0 0 0] 98 0 1168 0 27 8 'matchCase' 0 866 202 208 98 1 930 960 98 2 994 19 35 994 201 223 6112 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 17 0 0 0 109 0 0 0 128 0 0 0] 98 2 6224 6576 1168 0 27 2386 2976 19 2464 -11 3040 35 5136 -13 234 256 3168 0 866 202 208 98 1 930 960 98 2 994 281 11 994 231 271 5696 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 5 0 0 0 255 0 0 0 140 0 0 0] 98 2 5808 6112 1168 0 27 1168 0 27 2386 2976 1 2464 1 2418 8 #fixedPreviousBottom 11 5136 1 234 256 98 4 2560 8 'prompt' 1952 8 'pattern' 1602 994 13 31 994 11 21 866 202 208 98 1 930 960 98 2 994 11 1 994 539 383 1824 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 191 0 0 0] 98 3 2560 1952 3072 1168 0 27 234 256 3168 1602 994 11 1 994 11 1 0 0 0 0 9755 0 0 994 2049 461 994 741 461 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1998891648 866 202 208 98 3 930 960 98 2 994 2795 21 994 761 461 416 930 1056 98 1 8 'Find' 416 930 8 #updateMenuBar 3168 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 5 0 0 10 0 0 0 241 6 0 0 240 0 0 0] 98 2 1824 560 1168 0 27 )!

resource_Selector_view
	"Answer the literal data from which the 'Selector view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Selector_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  11 1 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 656198 1 ##(Smalltalk.FlowLayout)  1 11 1 234 256 98 4 410 8 ##(Smalltalk.PushButton)  98 20 0 560 98 2 8 1140924416 1 704 0 0 0 7 0 0 0 704 0 8 4294903999 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 'C&lose' 1 1 0 0 32 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 77 994 151 47 704 930 8 #text: 98 1 8 'C&lose' 704 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 75 0 0 0 61 0 0 0] 98 0 994 193 193 0 29 8 'cancel' 410 720 98 20 0 560 98 2 8 1141055488 1 1200 0 0 0 7 0 0 0 1200 0 8 4294903999 802 8 #ok 8 '&Find' 1 5 0 0 16 0 0 0 866 202 208 98 3 930 960 98 2 994 1 21 994 151 47 1200 930 8 #isEnabled: 98 1 32 1200 930 1056 98 1 8 '&Find' 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 75 0 0 0 33 0 0 0] 98 0 1168 0 29 8 'ok' 590342 ##(Smalltalk.Rectangle)  994 1 21 994 1 1 866 202 208 98 1 930 960 98 2 994 559 1 994 161 383 560 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 1 0 0 0 0 0 0 103 1 0 0 191 0 0 0] 98 2 1200 704 1168 0 27 0 410 576 98 15 0 416 98 2 8 1140850688 131073 1824 0 0 0 7 0 0 0 1824 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 576 98 15 0 1824 98 2 8 1140850688 131073 1952 0 0 0 7 0 0 0 1952 642 15 1 1 234 256 98 0 1602 994 1 11 994 1 1 866 202 208 98 1 930 960 98 2 994 13 89 994 517 275 1952 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 6 0 0 0 44 0 0 0 8 1 0 0 181 0 0 0] 98 2 410 576 98 15 0 1952 98 2 8 1140850688 131073 2272 0 0 0 7 0 0 0 2272 1890 234 240 98 4 410 8 ##(Smalltalk.GroupBox)  98 14 0 2272 98 2 8 1140850695 65 2384 0 0 0 7 0 0 0 2384 0 8 4294903999 866 202 208 98 2 930 960 98 2 994 1 1 994 271 271 2384 930 1056 98 1 8 'Search Mode' 2384 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 135 0 0 0 135 0 0 0] 98 0 1168 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 2722 8 #fixedParentRight 1 2722 8 #fixedParentTop 1 2722 8 #fixedParentBottom 1 410 576 98 15 0 2272 98 2 8 1140850688 131073 2864 0 0 0 7 0 0 0 2864 656390 ##(Smalltalk.GridLayout)  7 1 1 1 234 256 98 6 410 8 ##(Smalltalk.RadioButton)  98 16 0 2864 98 2 8 1140924425 1 2992 721990 2 ##(Smalltalk.ValueHolder)  0 0 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 3138 8 #hash 98 0 32 0 0 7 0 0 0 2992 0 8 4294903999 852486 ##(Smalltalk.NullConverter)  0 0 0 866 202 208 98 2 930 960 98 2 994 1 77 994 245 75 2992 930 1056 98 1 8 '&Wildcard Expression' 2992 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 122 0 0 0 75 0 0 0] 98 0 1168 0 27 8 'wildcardExpression' 410 3008 98 16 0 2864 98 2 8 1141055497 1 3520 3074 0 0 3106 3138 3168 98 0 3138 3216 98 0 32 0 0 7 0 0 0 3520 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 1 994 245 77 3520 930 1056 98 1 8 '&Text' 3520 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 122 0 0 0 38 0 0 0] 98 0 1168 0 27 8 'text' 410 3008 98 16 0 2864 98 2 8 1140924425 1 3936 3074 0 0 3106 3138 3168 98 0 3138 3216 98 0 32 0 0 7 0 0 0 3936 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 1 151 994 245 77 3936 930 1056 98 1 8 '&Regular Expression' 3936 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 75 0 0 0 122 0 0 0 113 0 0 0] 98 0 1168 0 27 8 'regularExpression' 0 866 202 208 98 1 930 960 98 2 994 19 31 994 245 227 2864 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 15 0 0 0 131 0 0 0 128 0 0 0] 98 3 3520 2992 3936 1168 0 27 2690 2736 19 2768 -7 2800 31 2832 -13 234 256 98 2 2864 8 'mode' 0 866 202 208 98 1 930 960 98 2 994 1 11 994 271 271 2272 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 135 0 0 0 140 0 0 0] 98 2 2384 2864 1168 0 27 410 576 98 15 0 1952 98 2 8 1140850688 131073 4736 0 0 0 7 0 0 0 4736 2930 7 1 1 1 234 256 98 2 410 8 ##(Smalltalk.CheckBox)  98 16 0 4736 98 2 8 1141055491 1 4848 3074 0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 0 0 7 0 0 0 4848 0 8 4294903999 3266 0 0 0 866 202 208 98 2 930 960 98 2 994 11 11 994 217 47 4848 930 1056 98 1 8 'Match &case' 4848 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 113 0 0 0 28 0 0 0] 98 0 1168 0 27 8 'matchCase' 1602 994 11 11 994 1 1 866 202 208 98 1 930 960 98 2 994 285 11 994 227 151 4736 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 142 0 0 0 5 0 0 0 255 0 0 0 80 0 0 0] 98 1 4848 1168 0 27 1168 0 27 2690 2736 1 2768 1 2722 8 #fixedPreviousBottom 11 2832 1 410 8 ##(Smalltalk.StaticText)  98 16 0 1824 98 2 8 1140850944 1 5488 3074 0 0 4960 8 '' 0 0 7 0 0 0 5488 0 8 4294903517 3266 0 0 16 866 202 208 98 2 930 960 98 2 994 17 31 994 111 31 5488 930 1056 98 1 8 'Fi&nd what:' 5488 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 15 0 0 0 63 0 0 0 30 0 0 0] 98 0 1168 0 27 2690 2736 5 2722 8 #fixedViewLeft 111 2800 1 2722 8 #fixedViewTop 31 410 8 ##(Smalltalk.TextEdit)  98 16 0 1824 98 2 8 1141047424 1025 5920 0 482 512 0 7 0 0 0 5920 0 8 4294903869 3266 0 0 5 866 202 208 98 3 930 960 98 2 994 145 29 994 371 51 5920 930 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 5920 930 8 #isTextModified: 98 1 32 5920 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 72 0 0 0 14 0 0 0 1 1 0 0 39 0 0 0] 98 0 1168 0 27 2690 2722 8 #fixedPreviousRight 19 2768 -13 2722 8 #fixedPreviousTop -1 5888 51 234 256 98 4 5920 8 'pattern' 5488 8 'prompt' 1602 994 13 31 994 11 21 866 202 208 98 1 930 960 98 2 994 11 1 994 539 383 1824 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 18 1 0 0 191 0 0 0] 98 3 5488 5920 1952 1168 0 27 234 256 2048 1602 994 11 1 994 11 1 0 0 0 0 9907 0 0 994 2049 461 994 751 461 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1998891648 866 202 208 98 3 930 960 98 2 994 2795 21 994 761 461 416 930 1056 98 1 8 'Find' 416 930 8 #updateMenuBar 2048 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 5 0 0 10 0 0 0 241 6 0 0 240 0 0 0] 98 2 1824 560 1168 0 27 )!

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

