"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'UI.Examples.PlimbolePresenter'
	instanceVariableNames: 'palette brushes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.PlimbolePresenter guid: (Core.GUID fromString: '{37200744-dd59-4671-9c52-bec43269016c}')!

UI.Examples.PlimbolePresenter comment: 'This is the Presenter class for the Plimbole Generative Music Sequencer. It receives user input (mouse clicks and commands) and translates these into effects on the Plimbole model that it holds. Together with the PlimboleView class this forms the user interface part of the MVP triad. Normaly one would create the complete Plimbole user interface usering a PlimboleShell since this adds the UI buttons and provides for a fully functioning application. However, it is possible to instantiate a basic Plimbole-PlimboleView-PlimbolePresenter MVP triad as a demonstration:

presenter := PlimbolePresenter show.
presenter model signature: ''20_0_150_030621270423452562860760662170_9_A_12''.
presenter play.
presenter topShell exit.


'!

!UI.Examples.PlimbolePresenter categoriesForClass!MVP-Presenters! !

!UI.Examples.PlimbolePresenter methodsFor!

availableGridExtents
	"Answer the chosen grid sizes"

	^#(7 8 9 10 11 12)!

beChromaticScale
	"Set the receiver's model to be playing using a chromatic scale"

	<commandQuery: #queryBeChromaticScale:>
	self plimbole scaleName: #chromaticScale.
	self showHintBubble: 'Playing in Chromatic Scale'!

beHangScale
	"Set the receiver's model to be playing using a hangdrum style scale"

	<commandQuery: #queryBeHangScale:>
	self plimbole scaleName: #hangScale.
	self showHintBubble: 'Playing in Hang Drum Scale'!

bePentatonicScale
	"Set the receiver's model to be playing using a pentatonic scale"

	<commandQuery: #queryBePentatonicScale:>
	self plimbole scaleName: #pentatonicScale.
	self showHintBubble: 'Playing in Pentatonic Scale'!

brushes
	^brushes!

canPasteClipboard
	^
	[PlimbolePiece fromString: Clipboard current getText.
	true] on: Error do: [:ex | false]!

clearAll
	"Clear all the cells but leave everythinng else"

	<commandQuery: #hasCells>
	self plimbole clearCells!

copyToClipboard
	"Copy the current piece signature to the clipboard for sharing/later pasting"

	<commandQuery: #hasCells>
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

hasCells
	^self plimbole cells notEmpty!

initialize	
	super initialize.
	self palette: self class defaultPalette.!

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
			self plimbole addCell: cell].
	self invalidateUserInterface!

onPaletteChanged
	| pal |
	pal := self palette.
	self view backcolor: pal first!

onPlayStarted
	self plimbole setVoices!

onViewClosed
	"The view has been closed. Stop any playimg and free up the MIDI channel."

	super onViewClosed.
	self plimbole unregister.
!

onViewOpened
	super onViewOpened.
	self onPaletteChanged.
	Plimbole
		when: #playStarted
		send: #onPlayStarted
		to: self.
	self isPlaying ifTrue: [self onPlayStarted]!

palette
	^palette!

palette: anArrayOfColors
	palette = anArrayOfColors ifTrue: [^self].
	palette := anArrayOfColors.
	brushes := palette collect: [:each | Gdiplus.SolidBrush color: each].
	self onPaletteChanged!

pasteClipboard
	"Paste the contents of the clipboard (if possible) as new piece"

	<commandQuery: #canPasteClipboard>
	self plimbole signature: Clipboard current getText.
	self onPaletteChanged!

play
	<commandQuery: #queryPlay:>
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

queryBeChromaticScale: aCommandQuery
	aCommandQuery
		isChecked: self plimbole scaleName = #chromaticScale;
		beEnabled!

queryBeHangScale: aCommandQuery
	aCommandQuery
		isChecked: self plimbole scaleName = #hangScale;
		beEnabled!

queryBePentatonicScale: aCommandQuery
	aCommandQuery
		isChecked: self plimbole scaleName = #pentatonicScale;
		beEnabled!

queryPlay: aCommandQuery
	aCommandQuery
		isEnabled: self hasCells;
		isChecked: self isPlaying!

randomFavourite
	self plimbole signature: self favourites atRandom.
	self invalidateUserInterface!

showHintBubble: aString 
	"Display a useful hint to the user about any command effect"
	| hintBubble |
	hintBubble := (MessageBubble new)
				maxWidth: 180;
				timeout: 1300 milliseconds.
	hintBubble
		caption: 'Plimbole';
		position: Cursor position;
		text: aString;
		open!

slowerTempo
	"Slow down the playing tempo"

	self plimbole tempo: (self plimbole tempo / 1.05) rounded.
	self showHintBubble: 'Tempo ' , self plimbole tempo displayString! !

!UI.Examples.PlimbolePresenter categoriesForMethods!
availableGridExtents!constants!public! !
beChromaticScale!constants!public! !
beHangScale!constants!public! !
bePentatonicScale!constants!public! !
brushes!accessing!private! !
canPasteClipboard!commands-queries!public! !
clearAll!commands-actions!public! !
copyToClipboard!commands-actions!public! !
fasterTempo!commands-actions!public! !
favourites!constants!public! !
hasCells!commands-queries!private! !
initialize!accessing!initializing!private! !
isPlaying!public! !
model:!event handling!private! !
nextAltoVoice!commands-actions!public! !
nextGridExtent!commands-actions!public! !
nextTenorVoice!commands-actions!public! !
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
previousAltoVoice!commands-actions!public! !
previousTenorVoice!commands-actions!public! !
queryBeChromaticScale:!private! !
queryBeHangScale:!private! !
queryBePentatonicScale:!private! !
queryPlay:!private! !
randomFavourite!commands-actions!public! !
showHintBubble:!private! !
slowerTempo!commands-actions!public! !
!

!UI.Examples.PlimbolePresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Examples.PlimboleView} 38 #{Core.Array} 12 nil nil 50 2 8 1140850688 1 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 99 15 0 0 110 0 0 0] 193 80 8 '' 32 3 8 #() 518 #{Graphics.Point} 193 193 nil 27)! !

!UI.Examples.PlimbolePresenter class categoriesForMethods!
defaultModel!public! !
defaultPalette!constants!private! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

