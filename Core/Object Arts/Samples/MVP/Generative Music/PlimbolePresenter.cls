"Filed out from Dolphin Smalltalk"!

Presenter subclass: #PlimbolePresenter
	instanceVariableNames: 'palette'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PlimbolePresenter guid: (GUID fromString: '{37200744-dd59-4671-9c52-bec43269016c}')!
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

	self plimbole clearCells!

copyToClipboard
	"Copy the current piece signature to the clipboard for sharing/later pasting"

	| signature |
	signature := self plimbole signature.
	Clipboard current setText: signature.
	self showHintBubble: 'Copied this piece ' , signature , ' to the Clipboard'!

fasterTempo
	"Speed up the playing tempo"

	self plimbole tempo: (self plimbole tempo * 1.05) rounded.
	self showHintBubble: 'Tempo ' , self plimbole tempo displayString!

favourites
	^#('20_1_142_653643411513833522422360460231241473742140132580750302371051_9_D_1B' '20_1_150_350570331151532312733553622270121663612260763221_9_3A_3A' '20_1_150_030621270423452562860760662170_9_13_11' '20_1_150_462641243830303420581052733570151312322633560251631562253320_9_7_8' '20_1_150_420243641252561462323630461242423640471142110711772173413740763111320631270712562121773253612170_9_2A_33' '20_2_150_153310051302731833572580732742611511411311120130140150273373473573762752_9_19_1E')!

initialize	
	super initialize.
	palette := self class defaultPalette.!

isPlaying
	^self plimbole isPlaying!

model: aModel
	self model ifNotNil: [:m | m unregister].
	super model: aModel.
	aModel register!

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
		ifNil: 
			[| cell |
			cell := PlimboleCell location: loc direction: 0.
			cell palette: self palette.
			self plimbole addCell: cell]!

onPaletteChanged
	| pal |
	pal := self palette.
	self view backcolor: pal first.
	self plimbole cells do: [:each | each palette: pal]!

onPlayStarted
	self plimbole setVoices!

onViewClosed
	"The view has been closed. Stop any playimg and free up the MIDI channel."

	super onViewClosed.
	self plimbole unregister.
!

onViewOpened
	super onViewOpened.
	self palette: palette.
	Plimbole 
		when: #playStarted
		send: #onPlayStarted
		to: self.
	self isPlaying ifTrue: [self onPlayStarted]!

palette
	^palette!

palette: anArrayOfColors 
	palette = anArrayOfColors 
		ifFalse: 
			[palette := anArrayOfColors.
			self onPaletteChanged]!

pasteClipboard
	"Paste the contents of the clipboard (if possible) as new piece"

	
	[self plimbole signature: Clipboard current getText.
	self onPaletteChanged] on: Error
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

randomFavourite
	| random |
	random := (Random new)
				next;
				next.
	self plimbole signature: (self favourites at: (self favourites size * random) truncated + 1)!

showHintBubble: aString 
	"Display a useful hint to the user about any command effect"
	| hintBubble |
	hintBubble := (MessageBubble new)
				maxWidth: 180;
				willFade: true;
				timeout: 1300 milliseconds.
	hintBubble
		caption: 'Plimbole';
		position: Cursor position;
		text: aString;
		open!

slowerTempo
	"Slow down the playing tempo"

	self plimbole tempo: self plimbole tempo // 1.05.
	self showHintBubble: 'Tempo ' , self plimbole tempo displayString! !
!PlimbolePresenter categoriesForMethods!
availableGridExtents!constants!public! !
beChromaticScale!constants!public! !
beHangScale!constants!public! !
bePentatonicScale!constants!public! !
clearAll!constants!public! !
copyToClipboard!public! !
fasterTempo!commands!public! !
favourites!constants!public! !
initialize!accessing!initializing!private! !
isPlaying!public! !
model:!event handling!private! !
nextAltoVoice!commands!public! !
nextGridExtent!commands!public! !
nextTenorVoice!commands!public! !
onLeftButtonDoubleClicked:!event handling!private! !
onLeftButtonPressed:!event handling!private! !
onPaletteChanged!private! !
onPlayStarted!private! !
onViewClosed!event handling!private! !
onViewOpened!event handling!private! !
palette!public! !
palette:!public! !
pasteClipboard!public! !
play!public! !
plimbole!public! !
previousAltoVoice!commands!public! !
previousTenorVoice!commands!public! !
queryCommand:!private! !
randomFavourite!commands!public! !
showHintBubble:!private! !
slowerTempo!commands!public! !
!

!PlimbolePresenter class methodsFor!

defaultModel
	^Plimbole new!

defaultPalette
	^PlimboleShell palettes first!

icon
	^Plimbole icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.PlimboleView) 34 12 nil nil 34 2 8 1140850688 1 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 626 201 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 227 7 0 0 110 0 0 0] 8 #() 626 193 193 nil 27 )! !
!PlimbolePresenter class categoriesForMethods!
defaultModel!public! !
defaultPalette!constants!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

