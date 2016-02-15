"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #Plimbole
	instanceVariableNames: 'midiOutChannel stepProcess recurse tenorVoice altoVoice scaleIndex noteDuration gridExtent tempo palette'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Plimbole guid: (GUID fromString: '{37200744-DD59-4671-9C52-BEC43269016C}')!
Plimbole comment: ''!
!Plimbole categoriesForClass!MVP-Presenters! !
!Plimbole methodsFor!

altoVoice
	^altoVoice ifNil: [altoVoice := self defaultVoice]!

altoVoice: aSymbol 
	altoVoice := aSymbol.
	self setVoices!

altoVoiceIndex
	^self altoVoices indexOf: self altoVoice.
!

altoVoiceIndex: anInteger 
	self altoVoice: (self altoVoices at: anInteger)!

altoVoices
	^#(#AcousticGrand #ElectricPianoI #ElectricPiano2 #Harpsichord #Clav #Celesta #Glockenspiel #MusicBox #Vibraphone #Marimba #Xylophone #Dulcimer #PercussiveOrgan #RockOrgan #ChurchOrgan #AcousticGuitarNylon #AcousticGuitarSteel #ElectricGuitarMuted #AcousticBass #SlapBass1 #SynthBass1 #SynthBass2 #Violin #Viola #Cello #TremoloStrings #PizzicatoStrings #OrchestralStrings #Timpani #StringEnsemble1 #SynthStrings1 #ChoirAahs #VoiceOohs #FrenchHorn #SynthBrass1 #Oboe #PanFlute #BlownBottle #Lead1Square #Lead3Calliope #Lead4Chiff #Lead8BassAndLead #Pad1NewAge #Pad4Choir #Pad5Bowed #Pad8Wweep #FX1Rain #FX3Crystal #FX4Atmosphere #FX6Goblins #FX8SciFi #Sitar #Shamisen #Koto #Kalimba #SteelDrums #Woodblock #MelodicTom #SynthDrum)!

availableGridExtents
	^#(7 8 9 10 11 12)!

beatTime
	^30 * 1000 // self tempo!

beChromaticScale
	self scaleName: #chromaticScale.
	self showHintBubble: 'Playing in Chromatic Scale'!

beHangScale
	self scaleName: #hangScale.
	self showHintBubble: 'Playing in Hang Drum Scale'!

bePentatonicScale
	self scaleName: #pentatonicScale.
	self showHintBubble: 'Playing in Pentatonic Scale'!

cellAtLocation: location 
	^self cells detect: [:each | each location = location] ifNone: []!

cellExtent
	^(self view extent / self gridExtent) rounded!

cells
	^self model!

checkCell: cell 
	| loc |
	loc := cell location.
	(self cells copyWithout: cell) do: [:each | each location = loc ifTrue: [cell rotate]].
	(loc x = 0 and: [cell direction = 180]) ifTrue: [cell reverse].
	(loc x = (self gridExtent x - 1) and: [cell direction = 0]) ifTrue: [cell reverse].
	(loc y = 0 and: [cell direction = 270]) ifTrue: [cell reverse].
	(loc y = (self gridExtent y - 1) and: [cell direction = 90]) ifTrue: [cell reverse]!

checkCellCollisions: cell 
	"Checks a cell for collisions with other cells and the walls."

	| loc |
	loc := cell location.
	(self cells copyWithout: cell) do: [:each | each location = loc ifTrue: [cell rotate]].
	(loc x = 0 and: [cell direction = 180]) ifTrue: [cell reverse].
	(loc x = (self gridExtent x - 1) and: [cell direction = 0]) ifTrue: [cell reverse].
	(loc y = 0 and: [cell direction = 270]) ifTrue: [cell reverse].
	(loc y = (self gridExtent y - 1) and: [cell direction = 90]) ifTrue: [cell reverse]!

chromaticScale
	^#(C4 D4 E4 F4 G4 A5 B5 C5 D5 E5 F5 G5)!

clearAll
	self model: self class defaultModel!

copyToClipboard
	Clipboard current setText: self signature format: #String.
	self showHintBubble: 'Copied this piece ', self signature, ' to the Clipboard'.
!

defaultPalette
	^#('#5D4131' '#7CC1A9' '#ED7829' '#EEA83D' '#FCEBB9' )!

defaultVoice
	^#AcousticGrand!

fasterTempo
	self tempo: (self tempo * 1.05) rounded.
	self showHintBubble: 'Tempo ', self tempo displayString!

gridExtent
	^gridExtent!

gridExtent: aPoint
	gridExtent := aPoint.
!

hangScale
	^#(D3 A3 Bb3 C4 D4 E4 F4 A4 #'F#5')!

initialize	
	super initialize.
	scaleIndex := 1.
	tempo := 150.
	gridExtent := 9@9.
	noteDuration := 1.5.
	palette := self defaultPalette.!

isPlaying
	^stepProcess notNil!

midiOutChannel
	^midiOutChannel!

nextAltoVoice
	| voices n |
	voices := self altoVoices.
	n := (voices indexOf: self altoVoice) +1.
	n>voices size ifTrue: [n := 1].
	self altoVoice: (voices at: n).
	self showHintBubble: 'Alto voice is ' , self altoVoice!

nextGridExtent
	| gridSizes n newSize |
	gridSizes := self availableGridExtents.
	n := gridSizes indexOf: self gridExtent x.
	n := n % gridSizes size + 1.
	newSize := gridSizes at: n.
	self gridExtent: newSize asPoint.
	self view invalidate.
	self showHintBubble: ('Grid is now <1d>x<1d>' expandMacrosWith: newSize).
	!

nextTenorVoice
	| voices n |
	voices := self tenorVoices.
	n := (voices indexOf: self tenorVoice) +1.
	n>voices size ifTrue: [n := 1].
	self tenorVoice: (voices at: n).
	self showHintBubble: 'Tenor voice is ' , self tenorVoice!

nominalCellExtent
	"Private - Answer the approximate cell size. This will be used to compute the Plimbole grid	
	when the window size is changed. This will then yield the real cellExtent."

	^48 @ 48!

noteDuration
	^noteDuration!

noteDuration: aNumber
	noteDuration := aNumber!

onLeftButtonDoubleClicked: aMouseEvent 
	^self onLeftButtonPressed: aMouseEvent!

onLeftButtonPressed: aMouseEvent 
	| loc |
	loc := (aMouseEvent position / self view extent * self gridExtent) truncated.
	(self cellAtLocation: loc) 
		ifNotNil: 
			[:existingCell | 
			existingCell direction = 180 
				ifTrue: [self model remove: existingCell]
				ifFalse: 
					[existingCell rotate.
					self cells refresh: existingCell]]
		ifNil: [self model add: (PlimboleCell 
						location: loc
						direction: 0
						parent: self)]!

onViewClosed
	super onViewClosed.
	self stop.
	self midiOutChannel free!

onViewOpened
	super onViewOpened.
	midiOutChannel := MidiOutChannel new.
	self palette: palette!

otomataSignature
	"Answer a signature string that represents the current piece playable on the Otomata website."

	^'http://www.earslap.com/projectslab/otomata/?q=', self signature!

palette
	^palette!

palette: anArrayOfColors
	palette := anArrayOfColors.
	self view backcolor: (RGB fromHTMLSpec:  palette last)!

pasteClipboard
	[self signature: Clipboard current getText] on: Error do: [:ex | self showHintBubble: 'The Clipboard doesn''t have a piece to Paste.']!

pentatonicScale
	^#(C4 D4 E4 G4 A5 C5 D5 E5 G5 A6 C6 D6 E6 G6 A6 )!

play
	self isPlaying ifTrue: [^self stop].
	recurse := false.
	self setVoices.
	stepProcess := [
			[self step.
			(Delay forMilliseconds: self beatTime) wait] repeat] forkAt: Processor highestPriority!

playCellNote: cell 
	"See's if a cell has collided wth a boundary and play it's note if necessary"

	| loc |
	loc := cell location.
	(loc x = 0 and: [cell direction = 180]) ifTrue: [self playNoteAtY: cell].
	(loc x = (self gridExtent x - 1) and: [cell direction = 0]) ifTrue: [self playNoteAtY: cell].
	(loc y = 0 and: [cell direction = 270]) ifTrue: [self playNoteAtX: cell].
	(loc y = (self gridExtent y - 1) and: [cell direction = 90]) ifTrue: [self playNoteAtX: cell]!

playNoteAtX: cell 
	| note |
	note := self scale at: cell x + 1.
	self midiOutChannel 
		playNote: note
		duration: self noteDuration * self beatTime
		channel: (self voiceChannelForNoteIndex: cell x).
	self 
		trigger: #playNote:forCell:
		with: note
		with: cell!

playNoteAtY: cell 
	| note |
	note := self scale at: cell y + 1.
	self midiOutChannel 
		playNote: note
		duration: self noteDuration * self beatTime
		channel: (self voiceChannelForNoteIndex: cell y).
	self 
		trigger: #playNote:forCell:
		with: note
		with: cell!

previousAltoVoice
	| voices n |
	voices := self altoVoices.
	n := (voices indexOf: self altoVoice) -1.
	n<1 ifTrue: [n := voices size].
	self altoVoice: (voices at: n).
	self showHintBubble: 'Alto voice is ' , self altoVoice!

previousTenorVoice
	| voices n |
	voices := self tenorVoices.
	n := (voices indexOf: self tenorVoice) -1.
	n<1 ifTrue: [n := voices size].
	self tenorVoice: (voices at: n).
	self showHintBubble: 'Tenor voice is ' , self tenorVoice!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the <CommandQuery>
	arugment."

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
				isChecked: self scaleName = #pentatonicScale;
				isEnabled: true.
			^true].
	cmd == #beChromaticScale 
		ifTrue: 
			[aCommandQuery
				isChecked: self scaleName = #chromaticScale;
				isEnabled: true.
			^true].
	cmd == #beHangScale 
		ifTrue: 
			[aCommandQuery
				isChecked: self scaleName = #hangScale;
				isEnabled: true.
			^true].
	^super queryCommand: aCommandQuery!

scale
	^self perform: self scaleName!

scaleIndex
	^scaleIndex

!

scaleIndex: anInteger
	scaleIndex := anInteger

!

scaleName
	^self scaleNames at: self scaleIndex!

scaleName: aSymbol
	^self scaleIndex: (self scaleNames indexOf: aSymbol)!

scaleNames
	^#(#pentatonicScale #chromaticScale #hangScale)!

setVoices
	(self midiOutChannel open)
		voice: self tenorVoice channel: 1;
		voice: self altoVoice channel: 2!

showHintBubble: aString 
	| hintBubble |
	hintBubble := (MessageBubble new)
				maxWidth: 180;
				willFade: true;
				timeout: 2000.
	hintBubble
		caption: 'Plimbole';
		position: Cursor position;
		text: aString;
		open!

signature
	"Answer a signature string that represents the current piece"

	| stream |
	stream := String writeStream.
	stream
		display: self signatureVersion;
		nextPut: $_;
		display: self scaleIndex;
		nextPut: $_;
		display: self tempo;
		nextPut: $_.

	"Cell positions"
	self cells do: 
			[:each | 
			each x 
				printOn: stream
				base: 16
				showRadix: false.
			each y 
				printOn: stream
				base: 16
				showRadix: false.
			stream display: each directionIndex].

	"Grid size"
	stream nextPut: $_.
	self gridExtent x
		printOn: stream
		base: 16
		showRadix: false.

	"Voices"
	stream nextPut: $_.
	self altoVoiceIndex
		printOn: stream
		base: 16
		showRadix: false.
	self tenorVoiceIndex
		printOn: stream
		base: 16
		showRadix: false.
	^stream contents!

signature: aString 
	"Sets the current piece to that held in aString"

	| stream version tempo scaleIndex model gridSize tenorIndex altoIndex |
	stream := aString readStream.
	(aString beginsWith: 'http:') ifTrue: [stream skipToAll: '?q='].
	version := Integer readFrom: stream.
	(#(10 20) includes: version) ifFalse: [self error: 'Wrong version'].
	stream next = $_ ifFalse: [self error: 'Wrong format'].

	scaleIndex := (Integer readFrom: stream)+1.
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	tempo := Integer readFrom: stream.
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	model := ListModel new.
	[stream atEnd or: [stream peek = $_]] whileFalse: 
			[| cell x y direction |
			x := stream next digitValue.
			y := stream next digitValue.
			direction := stream next digitValue.
			cell := PlimboleCell 
						location: x @ y
						direction: direction
						parent: self.
			model add: cell].
	tenorIndex := altoIndex := 1.
	gridSize := 9.
	version = self signatureVersion 
		ifTrue: 
			["Version 20 format includes gris size and voices"
			stream next = $_ ifFalse: [self error: 'Wrong format'].
			gridSize := stream next digitValue.
			stream next = $_ ifFalse: [self error: 'Wrong format'].
			tenorIndex := stream next digitValue.
			altoIndex := stream next digitValue].
	self clearAll.
	self tempo: tempo.
	self scaleIndex: scaleIndex.
	self gridExtent: gridSize asPoint.
	self tenorVoiceIndex: tenorIndex.
	self altoVoiceIndex: altoIndex.
	self model: model!

signatureVersion

	^20!

slowerTempo
	self tempo: self tempo // 1.05.
	self showHintBubble: 'Tempo ' , self tempo displayString!

step
	recurse ifTrue: [^self].
	
	[recurse := true.
	self cells do: [:each | self stepCell: each].
	self cells copy do: [:each | self checkCellCollisions: each].
	self view invalidate] 
			ensure: [recurse := false]!

stepCell: cell 
	"Steps a cell accouring to its velocity"

	cell location: ((cell location + cell velocity max: 0 @ 0) min: self gridExtent - (1 @ 1)).
	self playCellNote: cell!

stop
	stepProcess notNil 
		ifTrue: 
			[stepProcess terminate.
			stepProcess := nil]!

tempo
	^tempo!

tempo: anInteger
	tempo := anInteger!

tenorVoice
	^tenorVoice ifNil: [tenorVoice := self defaultVoice]!

tenorVoice: aSymbol 
	tenorVoice := aSymbol.
	self setVoices!

tenorVoiceIndex
	^self tenorVoices indexOf: self tenorVoice.
!

tenorVoiceIndex: anInteger
	self tenorVoice: (self tenorVoices at: anInteger)
!

tenorVoices
	^#(#AcousticGrand #ElectricPianoI #ElectricPiano2 #Harpsichord #Clav #Celesta #Glockenspiel #MusicBox #Vibraphone #Marimba #Xylophone #Dulcimer #PercussiveOrgan #RockOrgan #ChurchOrgan #AcousticGuitarNylon #AcousticGuitarSteel #ElectricGuitarMuted #AcousticBass #SlapBass1 #SynthBass1 #SynthBass2 #Violin #Viola #Cello #TremoloStrings #PizzicatoStrings #OrchestralStrings #Timpani #StringEnsemble1 #SynthStrings1 #ChoirAahs #VoiceOohs #FrenchHorn #SynthBrass1 #Oboe #PanFlute #BlownBottle #Lead1Square #Lead3Calliope #Lead4Chiff #Lead8BassAndLead #Pad1NewAge #Pad4Choir #Pad5Bowed #Pad8Wweep #FX1Rain #FX3Crystal #FX4Atmosphere #FX6Goblins #FX8SciFi #Sitar #Shamisen #Koto #Kalimba #SteelDrums #Woodblock #MelodicTom #SynthDrum)!

voice: aSymbol 
	self
		tenorVoice: aSymbol;
		altoVoice: aSymbol!

voiceChannelForNoteIndex: n 
	"Private - Decode whether note index n is a tenor or alto voice. Tenor is channel 1 and alto is channel 2"

	^(n+1) < (self gridExtent x / 2) ifTrue: [1] ifFalse: [2]! !
!Plimbole categoriesFor: #altoVoice!accessing!public! !
!Plimbole categoriesFor: #altoVoice:!accessing!public! !
!Plimbole categoriesFor: #altoVoiceIndex!accessing!public! !
!Plimbole categoriesFor: #altoVoiceIndex:!accessing!public! !
!Plimbole categoriesFor: #altoVoices!constants!public!voices! !
!Plimbole categoriesFor: #availableGridExtents!constants!public! !
!Plimbole categoriesFor: #beatTime!accessing!constants!public! !
!Plimbole categoriesFor: #beChromaticScale!accessing!commands!public!scales! !
!Plimbole categoriesFor: #beHangScale!accessing!commands!public!scales! !
!Plimbole categoriesFor: #bePentatonicScale!accessing!commands!public!scales! !
!Plimbole categoriesFor: #cellAtLocation:!helpers!private! !
!Plimbole categoriesFor: #cellExtent!helpers!public! !
!Plimbole categoriesFor: #cells!accessing!public! !
!Plimbole categoriesFor: #checkCell:!private! !
!Plimbole categoriesFor: #checkCellCollisions:!helpers!private! !
!Plimbole categoriesFor: #chromaticScale!constants!public!scales! !
!Plimbole categoriesFor: #clearAll!commands!public! !
!Plimbole categoriesFor: #copyToClipboard!public! !
!Plimbole categoriesFor: #defaultPalette!commands!constants!private! !
!Plimbole categoriesFor: #defaultVoice!constants!private! !
!Plimbole categoriesFor: #fasterTempo!commands!public! !
!Plimbole categoriesFor: #gridExtent!accessing!public! !
!Plimbole categoriesFor: #gridExtent:!public! !
!Plimbole categoriesFor: #hangScale!constants!public!scales! !
!Plimbole categoriesFor: #initialize!accessing!initializing!private! !
!Plimbole categoriesFor: #isPlaying!public!testing! !
!Plimbole categoriesFor: #midiOutChannel!private! !
!Plimbole categoriesFor: #nextAltoVoice!commands!public! !
!Plimbole categoriesFor: #nextGridExtent!commands!public! !
!Plimbole categoriesFor: #nextTenorVoice!commands!public! !
!Plimbole categoriesFor: #nominalCellExtent!constants!private! !
!Plimbole categoriesFor: #noteDuration!accessing!helpers!public! !
!Plimbole categoriesFor: #noteDuration:!public! !
!Plimbole categoriesFor: #onLeftButtonDoubleClicked:!event handling!private! !
!Plimbole categoriesFor: #onLeftButtonPressed:!event handling!private! !
!Plimbole categoriesFor: #onViewClosed!event handling!private! !
!Plimbole categoriesFor: #onViewOpened!event handling!private! !
!Plimbole categoriesFor: #otomataSignature!public! !
!Plimbole categoriesFor: #palette!public! !
!Plimbole categoriesFor: #palette:!public! !
!Plimbole categoriesFor: #pasteClipboard!public! !
!Plimbole categoriesFor: #pentatonicScale!constants!public!scales! !
!Plimbole categoriesFor: #play!commands!public! !
!Plimbole categoriesFor: #playCellNote:!operations!private! !
!Plimbole categoriesFor: #playNoteAtX:!helpers!operations!private! !
!Plimbole categoriesFor: #playNoteAtY:!helpers!operations!private! !
!Plimbole categoriesFor: #previousAltoVoice!commands!public! !
!Plimbole categoriesFor: #previousTenorVoice!commands!public! !
!Plimbole categoriesFor: #queryCommand:!private! !
!Plimbole categoriesFor: #scale!accessing!public!scales! !
!Plimbole categoriesFor: #scaleIndex!accessing!public!scales! !
!Plimbole categoriesFor: #scaleIndex:!accessing!public!scales! !
!Plimbole categoriesFor: #scaleName!accessing!public!scales! !
!Plimbole categoriesFor: #scaleName:!accessing!public!scales! !
!Plimbole categoriesFor: #scaleNames!public!scales! !
!Plimbole categoriesFor: #setVoices!private! !
!Plimbole categoriesFor: #showHintBubble:!public! !
!Plimbole categoriesFor: #signature!accessing!public! !
!Plimbole categoriesFor: #signature:!public! !
!Plimbole categoriesFor: #signatureVersion!public! !
!Plimbole categoriesFor: #slowerTempo!commands!public! !
!Plimbole categoriesFor: #step!operations!private! !
!Plimbole categoriesFor: #stepCell:!operations!private! !
!Plimbole categoriesFor: #stop!commands!public! !
!Plimbole categoriesFor: #tempo!public! !
!Plimbole categoriesFor: #tempo:!public! !
!Plimbole categoriesFor: #tenorVoice!accessing!public! !
!Plimbole categoriesFor: #tenorVoice:!accessing!public! !
!Plimbole categoriesFor: #tenorVoiceIndex!accessing!public! !
!Plimbole categoriesFor: #tenorVoiceIndex:!accessing!public! !
!Plimbole categoriesFor: #tenorVoices!constants!public!voices! !
!Plimbole categoriesFor: #voice:!accessing!public! !
!Plimbole categoriesFor: #voiceChannelForNoteIndex:!accessing!private! !

!Plimbole class methodsFor!

defaultModel
	^ListModel new!

icon
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 1 149 73 68 65 84 104 67 237 151 49 74 3 65 20 134 115 140 156 192 58 226 9 188 136 23 240 2 138 133 149 104 99 99 227 86 98 27 82 40 90 108 33 129 104 145 70 68 20 75 65 193 42 104 97 148 44 75 112 119 204 91 76 120 243 246 151 17 97 103 178 250 6 62 194 252 76 30 255 151 100 201 110 99 101 185 101 92 100 47 113 16 214 207 219 78 84 160 74 80 97 73 73 128 150 204 208 112 31 160 194 27 23 29 107 111 9 228 121 94 8 208 226 57 26 238 3 94 52 186 238 22 140 198 169 37 81 187 111 128 22 223 151 4 186 39 29 107 79 160 225 62 224 69 191 227 239 93 196 8 52 220 7 168 176 164 113 25 239 26 23 104 184 15 238 30 78 157 52 208 27 235 132 10 132 70 5 66 163 2 161 81 129 208 252 31 1 116 31 34 161 115 232 94 74 146 244 87 205 176 221 114 34 59 32 84 128 67 231 80 97 201 92 8 28 220 246 204 86 255 216 202 232 28 47 154 38 73 241 4 197 51 66 10 208 226 251 41 178 3 226 87 2 124 241 156 206 201 178 71 135 81 41 227 2 217 104 240 53 201 152 143 231 27 63 2 196 254 228 1 91 102 116 78 150 117 9 20 69 223 159 172 253 44 23 29 16 122 17 115 232 28 42 44 81 1 198 143 5 230 21 21 8 141 10 132 70 5 66 163 2 161 169 191 0 250 11 151 160 55 250 224 117 173 233 68 5 170 4 21 150 212 74 32 61 219 43 101 150 0 173 244 106 167 128 231 104 184 15 100 217 180 23 149 50 75 96 252 24 79 94 23 103 251 41 104 184 15 120 209 183 237 37 147 13 238 139 15 153 231 181 250 9 13 55 23 74 153 94 196 85 130 10 219 52 205 39 144 66 52 109 220 47 111 112 0 0 0 0 73 69 78 68 174 66 96 130]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.PlimboleView)  98 12 0 0 98 2 8 1140850688 1 416 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  196934 1 ##(Smalltalk.RGB)  8454655 0 7 0 0 0 416 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  4935 21 754 681 681 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 9 0 0 10 0 0 0 247 10 0 0 94 1 0 0] 98 0 754 193 193 0 27 )! !
!Plimbole class categoriesFor: #defaultModel!public! !
!Plimbole class categoriesFor: #icon!constants!public! !
!Plimbole class categoriesFor: #resource_Default_view!public!resources-views! !

