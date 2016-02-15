"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #PlimbolePresenter
	instanceVariableNames: 'palette'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PlimbolePresenter guid: (GUID fromString: '{37200744-DD59-4671-9C52-BEC43269016C}')!
PlimbolePresenter comment: 'This is the Presenter class for the Plimbole Generative Music Sequencer. It receives user input (mouse clicks and commands) and translates these into effects on the Plimbole model that it holds. Together with the PlimboleView class this forms the user interface part of the MVP triad. Normaly one would create the complete Plimbole user interface usering a PlimboleShell since this adds the UI buttons and provides for a fully functioning application. However, it is possible to instantiate a basic Plimbole-PlimboleView-PlimbolePresenter MVP triad as a demonstration:

presenter := PlimbolePresenter show.
presenter model signature: ''20_0_150_030621270423452562860760662170_9_A_12''.
presenter play.
presenter topShell exit.


'!
!PlimbolePresenter categoriesForClass!MVP-Presenters! !
!PlimbolePresenter methodsFor!

availableGridExtents
	"Answer the chosen grid sizes"

	^#(7 8 9 10 11 12)!

beChromaticScale
	"Set the receiver's model to be playing using a chromatic scale"

	self plimbole scaleName: #chromaticScale.
	self showHintBubble: 'Playing in Chromatic Scale'!

beHangScale
	"Set the receiver's model to be playing using a hangdrum style scale"

	self plimbole scaleName: #hangScale.
	self showHintBubble: 'Playing in Hang Drum Scale'!

bePentatonicScale
	"Set the receiver's model to be playing using a pentatonic scale"

	self plimbole scaleName: #pentatonicScale.
	self showHintBubble: 'Playing in Pentatonic Scale'!

clearAll
	"Clear all the cells but leave everythinng else"

	(self plimbole)
		stop;
		clearCells!

copyToClipboard
	"Copy the current piece signature to the clipboard for sharing/later pasting"

	| signature |
	signature := self plimbole signature.
	Clipboard current setText: signature format: #String.
	self showHintBubble: 'Copied this piece ' , signature , ' to the Clipboard'!

fasterTempo
	"Speed up the playing tempo"

	self plimbole tempo: (self plimbole tempo * 1.05) rounded.
	self showHintBubble: 'Tempo ' , self plimbole tempo displayString!

initialize	
	super initialize.
	palette := self class defaultPalette.!

isPlaying
	^self plimbole isPlaying!

nextAltoVoice
	"Cycles to the next alto voice chosen from the available alto voices"

	| voices n |
	voices := self plimbole altoVoices.
	n := (voices indexOf: self plimbole altoVoice) +1.
	n>voices size ifTrue: [n := 1].
	self plimbole altoVoice: (voices at: n).
	self showHintBubble: 'Alto voice is ' , self plimbole altoVoice!

nextGridExtent
	"Cycles to the next grid size chosen from the available grid sizes"

	| gridSizes n newSize |
	gridSizes := self availableGridExtents.
	n := gridSizes indexOf: self plimbole gridExtent x.
	n := n % gridSizes size + 1.
	newSize := gridSizes at: n.
	self plimbole gridExtent: newSize asPoint.
	self showHintBubble: ('Grid is now <1d>x<1d>' expandMacrosWith: newSize)!

nextTenorVoice
	"Cycles to the next tenor voice chosen from the available tenor voices"

	| voices n |
	voices := self plimbole tenorVoices.
	n := (voices indexOf: self plimbole tenorVoice) + 1.
	n > voices size ifTrue: [n := 1].
	self plimbole tenorVoice: (voices at: n).
	self showHintBubble: 'Tenor voice is ' , self plimbole tenorVoice!

onLeftButtonDoubleClicked: aMouseEvent 
	"A double click is just treated as another single click"

	^self onLeftButtonPressed: aMouseEvent!

onLeftButtonPressed: aMouseEvent 
	"Handles a user click on the receiver. Either add a new cell or cycle an existing cell through the different directions."

	| loc |
	loc := (aMouseEvent position / self view extent * self plimbole gridExtent) truncated.
	(self plimbole cellAtLocation: loc) 
		ifNotNil: 
			[:existingCell | 
			existingCell direction = 180 
				ifTrue: [self plimbole removeCell: existingCell]
				ifFalse: 
					[existingCell rotate.
					self plimbole update]]
		ifNil: [self plimbole addCell: (PlimboleCell location: loc direction: 0)]!

onViewClosed
	"The view has been closed. Stop any playimg and free up the MIDI channel."

	super onViewClosed.
	self plimbole stop.
	self plimbole midiOutChannel free!

onViewOpened
	super onViewOpened.
	self palette: palette!

palette
	^palette!

palette: anArrayOfColors
	palette := anArrayOfColors.
	self view backcolor: (RGB fromHTMLSpec:  palette last)!

pasteClipboard
	"Paste the contents of the clipboard (if possible) as new piece"

	[self plimbole signature: Clipboard current getText] on: Error
		do: [:ex | self showHintBubble: 'The Clipboard doesn''t have a piece to Paste.']!

play
	self plimbole play!

plimbole
	^self model!

previousAltoVoice
	"Cycles to the previous alto voice chosen from the available alto voices"

	| voices n |
	voices := self plimbole altoVoices.
	n := (voices indexOf: self plimbole altoVoice) - 1.
	n < 1 ifTrue: [n := voices size].
	self plimbole altoVoice: (voices at: n).
	self showHintBubble: 'Alto voice is ' , self plimbole altoVoice!

previousTenorVoice
	"Cycles to the previous tenor voice chosen from the available tenor voices"

	| voices n |
	voices := self plimbole tenorVoices.
	n := (voices indexOf: self plimbole tenorVoice) - 1.
	n < 1 ifTrue: [n := voices size].
	self plimbole tenorVoice: (voices at: n).
	self showHintBubble: 'Tenor voice is ' , self plimbole tenorVoice!

queryCommand: aCommandQuery 
	"Fills in details about the current state of the receiver into aCommandQuery"

	| cmd |
	cmd := aCommandQuery commandSymbol.
	cmd == #play 
		ifTrue: 
			[aCommandQuery
				isChecked: self isPlaying;
				isEnabled: true.
			^true].
	cmd == #bePentatonicScale 
		ifTrue: 
			[aCommandQuery
				isChecked: self plimbole scaleName = #pentatonicScale;
				isEnabled: true.
			^true].
	cmd == #beChromaticScale 
		ifTrue: 
			[aCommandQuery
				isChecked: self plimbole scaleName = #chromaticScale;
				isEnabled: true.
			^true].
	cmd == #beHangScale 
		ifTrue: 
			[aCommandQuery
				isChecked: self plimbole scaleName = #hangScale;
				isEnabled: true.
			^true].
	^super queryCommand: aCommandQuery!

showHintBubble: aString 
	"Display a useful hint to the user about any command effect"
	| hintBubble |
	hintBubble := (MessageBubble new)
				maxWidth: 180;
				willFade: true;
				timeout: 1300.
	hintBubble
		caption: 'Plimbole';
		position: Cursor position;
		text: aString;
		open!

slowerTempo
	"Slow down the playing tempo"

	self plimbole tempo: self plimbole tempo // 1.05.
	self showHintBubble: 'Tempo ' , self plimbole tempo displayString! !
!PlimbolePresenter categoriesFor: #availableGridExtents!constants!public! !
!PlimbolePresenter categoriesFor: #beChromaticScale!constants!public! !
!PlimbolePresenter categoriesFor: #beHangScale!constants!public! !
!PlimbolePresenter categoriesFor: #bePentatonicScale!constants!public! !
!PlimbolePresenter categoriesFor: #clearAll!constants!public! !
!PlimbolePresenter categoriesFor: #copyToClipboard!public! !
!PlimbolePresenter categoriesFor: #fasterTempo!commands!public! !
!PlimbolePresenter categoriesFor: #initialize!accessing!initializing!private! !
!PlimbolePresenter categoriesFor: #isPlaying!public! !
!PlimbolePresenter categoriesFor: #nextAltoVoice!commands!public! !
!PlimbolePresenter categoriesFor: #nextGridExtent!commands!public! !
!PlimbolePresenter categoriesFor: #nextTenorVoice!commands!public! !
!PlimbolePresenter categoriesFor: #onLeftButtonDoubleClicked:!event handling!private! !
!PlimbolePresenter categoriesFor: #onLeftButtonPressed:!event handling!private! !
!PlimbolePresenter categoriesFor: #onViewClosed!event handling!private! !
!PlimbolePresenter categoriesFor: #onViewOpened!event handling!private! !
!PlimbolePresenter categoriesFor: #palette!public! !
!PlimbolePresenter categoriesFor: #palette:!public! !
!PlimbolePresenter categoriesFor: #pasteClipboard!public! !
!PlimbolePresenter categoriesFor: #play!public! !
!PlimbolePresenter categoriesFor: #plimbole!public! !
!PlimbolePresenter categoriesFor: #previousAltoVoice!commands!public! !
!PlimbolePresenter categoriesFor: #previousTenorVoice!commands!public! !
!PlimbolePresenter categoriesFor: #queryCommand:!private! !
!PlimbolePresenter categoriesFor: #showHintBubble:!private! !
!PlimbolePresenter categoriesFor: #slowerTempo!commands!public! !

!PlimbolePresenter class methodsFor!

defaultModel
	^Plimbole new!

defaultPalette
	^#('#5D4131' '#7CC1A9' '#ED7829' '#EEA83D' '#FCEBB9' )!

icon
	^Plimbole icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.PlimboleView)  98 12 0 0 98 2 8 1140850688 1 416 527174 1 ##(Smalltalk.Plimbole)  0 202 208 98 0 0 0 0 0 0 3 327734 ##(Smalltalk.Float)  8 0 0 0 0 0 0 248 63 328198 ##(Smalltalk.Point)  19 19 301 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 416 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 594 4935 21 594 201 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 9 0 0 10 0 0 0 7 10 0 0 110 0 0 0] 98 0 594 193 193 0 27 )! !
!PlimbolePresenter class categoriesFor: #defaultModel!public! !
!PlimbolePresenter class categoriesFor: #defaultPalette!constants!private! !
!PlimbolePresenter class categoriesFor: #icon!constants!public! !
!PlimbolePresenter class categoriesFor: #resource_Default_view!public!resources-views! !

