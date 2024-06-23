"Filed out from Dolphin Smalltalk"!

Core.Model
	subclass: #'UI.Examples.Plimbole'
	instanceVariableNames: 'cells recurse tenorVoice altoVoice tenorChannel altoChannel scaleIndex noteDuration gridExtent'
	classVariableNames: 'MidiChannel Registry StepProcess Tempo'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.Plimbole guid: (Core.GUID fromString: '{f27f7ff6-a16b-433c-bf1b-d38b3db9ec3c}')!

UI.Examples.Plimbole comment: 'This is the Model class for the Plimbole Generative Music Sequencer. Plimbole has been designed to embrace the MVP design rules such that the main functionality is based in the model and is independent of the UI. To demostrate this you can create a Plimbole instance, load it with a piece and then start it playing:

plimbole := Plimbole new register.
plimbole signature: ''20_0_150_030621270423452562860760662170_9_A_12''.
plimbole play.

Make sure that you stop it and unregister any references to the object or it will hold the midi channel open.
plimbole stop unregister.'!

!UI.Examples.Plimbole categoriesForClass!MVP-Models! !

!UI.Examples.Plimbole methodsFor!

addCell: aPlimboleCell 
	self cells add: aPlimboleCell.
	self update!

altoChannel
	^altoChannel!

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

assignAvailableChannels
	"Private - Look through all the living Plimboles and find two available MIDI channels to use for the receiver"

	| available |
	available := (1 to: 16) asSet.
	self class allInstances do: 
			[:each |
			available
				remove: each tenorChannel ifAbsent: nil;
				remove: each altoChannel ifAbsent: nil].
	available := available asSortedCollection.
	tenorChannel := available first.
	altoChannel := available second!

beatTime
	^self class beatTime!

cellAtLocation: location
	^self cells detect: [:each | each location = location] ifNone: nil!

cellExtent
	^(self view extent / self gridExtent) rounded!

cells
	^cells!

cells: anOrderedCollection 
	cells := anOrderedCollection!

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

clearCells
	self cells: OrderedCollection new.
	self update!

defaultVoice
	^#AcousticGrand!

gridExtent
	^gridExtent!

gridExtent: aPoint
	gridExtent := aPoint.
	self update
!

hangScale
	^#(D3 A3 Bb3 C4 D4 E4 F4 A4 #'F#5' D6 A7 Bb7)!

initialize
	super initialize.
	self reset.
	self assignAvailableChannels.

!

isPlaying
	^self class isPlaying!

midiOutChannel
	^self class midiOutChannel!

noteDuration
	^noteDuration!

noteDuration: aNumber
	noteDuration := aNumber!

otomataSignature
	"Answer a signature string that represents the current piece playable on the Otomata website."

	^'http://www.earslap.com/projectslab/otomata/?q=', self signature!

pentatonicScale
	^#(C4 D4 E4 G4 A5 C5 D5 E5 G5 A6 C6 D6 E6 G6 A6 )!

play
	self class play!

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
		duration: (self noteDuration * self beatTime) milliseconds
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
		duration: (self noteDuration * self beatTime) milliseconds
		channel: (self voiceChannelForNoteIndex: cell y).
	self 
		trigger: #playNote:forCell:
		with: note
		with: cell!

register
	"Register to receive step pulses from our class"

	self class register: self!

removeCell: aPlimboleCell 
	self cells remove: aPlimboleCell.
	self update!

reset
	scaleIndex := 1.
	gridExtent := 9 @ 9.
	noteDuration := 1.5.
	tenorVoice := #Marimba.
	altoVoice := #Vibraphone.
	cells := OrderedCollection new.
	recurse := false.!

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
		voice: self tenorVoice channel: tenorChannel;
		voice: self altoVoice channel: altoChannel!

signature
	"Answer a signature string that represents the current piece"

	| stream |
	stream := String writeStream.
	stream
		display: self signatureVersion;
		nextPut: $_;
		display: self scaleIndex-1;
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
	self tenorVoiceIndex
		printOn: stream
		base: 16
		showRadix: false.
	stream nextPut: $_.
	self altoVoiceIndex
		printOn: stream
		base: 16
		showRadix: false.
	^stream contents!

signature: aString
	"Sets the current piece to that held in aString"

	| stream version tempo scaleIndex cells gridSize tenorIndex altoIndex |
	stream := aString readStream.
	(aString beginsWith: 'http:') ifTrue: [stream skipToAll: '?q='].
	version := Integer readFrom: stream.
	(#(10 20) includes: version) ifFalse: [self error: 'Wrong version'].
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	scaleIndex := (Integer readFrom: stream) + 1.
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	tempo := Integer readFrom: stream.
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	cells := OrderedCollection new.
	[stream atEnd or: [stream peek = $_]] whileFalse: 
			[| cell x y direction |
			x := stream next digitValue.
			y := stream next digitValue.
			direction := stream next digitValue.
			cell := PlimboleCell location: x @ y direction: direction.
			cells add: cell].
	tenorIndex := altoIndex := 1.
	gridSize := 9.
	version = self signatureVersion
		ifTrue: 
			["Version 20 format includes gris size and voices"
			stream next = $_ ifFalse: [self error: 'Wrong format'].
			gridSize := stream next digitValue.
			stream next = $_ ifFalse: [self error: 'Wrong format'].
			tenorIndex := Integer readFrom: stream radix: 16.
			stream next = $_ ifFalse: [self error: 'Wrong format'].
			altoIndex := Integer readFrom: stream radix: 16].
	self reset.
	self cells: cells.
	self tempo: tempo.
	self scaleIndex: scaleIndex.
	self gridExtent: gridSize asPoint.
	self tenorVoiceIndex: tenorIndex.
	self altoVoiceIndex: altoIndex!

signatureVersion

	^20!

step
	recurse ifTrue: [^self].
	
	[recurse := true.
	self cells do: [:each | self stepCell: each].
	self cells copy do: [:each | self checkCellCollisions: each]] 
			ensure: [recurse := false].
	[self update] postToInputQueue!

stepCell: cell 
	"Steps a cell accouring to its velocity"

	cell location: ((cell location + cell velocity max: 0 @ 0) min: self gridExtent - (1 @ 1)).
	self playCellNote: cell!

stop
	self class stop!

tempo
	^self class tempo!

tempo: anInteger
	self class tempo: anInteger!

tenorChannel
	^tenorChannel!

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

unregister
	"Unregister so no further step will be received"

	self class unregister: self!

update
	^self trigger: #updated!

voice: aSymbol 
	self
		tenorVoice: aSymbol;
		altoVoice: aSymbol!

voiceChannelForNoteIndex: n 
	"Private - Decode whether note index n is a tenor or alto voice. Tenor is channel 1 and alto is channel 2"

	^(n+1) < (self gridExtent x / 2) ifTrue: [tenorChannel ] ifFalse: [altoChannel ]! !

!UI.Examples.Plimbole categoriesForMethods!
addCell:!operations!public! !
altoChannel!public! !
altoVoice!accessing!public! !
altoVoice:!accessing!public! !
altoVoiceIndex!accessing!public! !
altoVoiceIndex:!accessing!public! !
altoVoices!constants!public!voices! !
assignAvailableChannels!private! !
beatTime!accessing!constants!public! !
cellAtLocation:!helpers!private! !
cellExtent!helpers!public! !
cells!accessing!public! !
cells:!accessing!private! !
checkCell:!private! !
checkCellCollisions:!helpers!private! !
chromaticScale!constants!public!scales! !
clearCells!public! !
defaultVoice!constants!private! !
gridExtent!accessing!public! !
gridExtent:!public! !
hangScale!constants!public!scales! !
initialize!accessing!initializing!private! !
isPlaying!public!testing! !
midiOutChannel!private! !
noteDuration!accessing!helpers!public! !
noteDuration:!public! !
otomataSignature!public! !
pentatonicScale!constants!public!scales! !
play!commands!public! !
playCellNote:!operations!private! !
playNoteAtX:!helpers!operations!private! !
playNoteAtY:!helpers!operations!private! !
register!public! !
removeCell:!public! !
reset!operations!private! !
scale!accessing!public!scales! !
scaleIndex!accessing!public!scales! !
scaleIndex:!accessing!public!scales! !
scaleName!accessing!public!scales! !
scaleName:!accessing!public!scales! !
scaleNames!public!scales! !
setVoices!private! !
signature!accessing!public! !
signature:!public! !
signatureVersion!private! !
step!operations!public! !
stepCell:!operations!private! !
stop!commands!public! !
tempo!public! !
tempo:!public! !
tenorChannel!public! !
tenorVoice!accessing!public! !
tenorVoice:!accessing!public! !
tenorVoiceIndex!accessing!public! !
tenorVoiceIndex:!accessing!public! !
tenorVoices!constants!public!voices! !
unregister!public! !
update!private! !
voice:!accessing!public! !
voiceChannelForNoteIndex:!accessing!private! !
!

!UI.Examples.Plimbole class methodsFor!

beatTime
	^30 * 1000 // self tempo!

icon
	^InternalIcon 
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 2 138 73 68 65 84 104 67 237 152 207 107 211 96 24 199 251 103 236 228 205 131 39 91 152 187 13 113 8 186 9 30 20 217 69 28 130 122 154 48 240 7 14 25 195 66 65 69 216 97 22 230 109 160 151 46 195 142 181 234 152 14 127 212 233 68 80 148 41 27 76 39 50 180 174 98 151 164 169 77 154 230 49 239 91 139 105 124 146 190 9 196 70 120 159 242 161 129 239 243 190 111 62 73 222 64 27 57 182 39 10 65 241 106 126 12 106 223 239 193 240 227 84 96 112 1 55 184 0 3 92 192 13 46 192 128 39 129 43 103 78 193 137 125 93 104 134 17 42 129 220 220 44 144 42 73 34 156 62 188 23 237 177 227 87 32 179 246 26 70 114 211 104 102 135 65 32 6 47 159 44 208 147 111 148 90 169 192 80 255 126 164 183 25 191 2 21 93 131 114 85 131 248 98 26 205 173 180 20 72 77 140 209 147 30 31 61 75 191 231 132 155 240 179 172 128 166 170 104 191 21 191 2 137 103 51 116 45 69 83 91 222 137 150 2 228 153 31 57 217 79 143 73 165 39 39 96 160 39 6 241 193 129 191 122 237 176 8 204 175 191 165 243 58 213 103 177 128 142 107 224 105 19 147 34 2 88 134 193 34 112 245 69 22 30 124 90 110 98 193 196 48 63 164 110 189 91 68 199 53 104 187 0 198 234 143 175 116 45 97 101 9 205 173 132 82 128 108 224 172 249 38 194 50 59 158 4 10 249 47 144 140 159 71 51 12 191 2 94 240 36 224 21 46 192 0 23 112 131 11 48 192 5 220 248 39 2 100 145 160 40 126 16 168 192 251 245 76 96 68 200 2 255 51 17 49 21 133 160 80 87 234 143 208 214 133 142 192 224 2 110 112 1 6 184 128 27 92 128 129 112 9 92 220 6 149 135 73 16 71 183 227 57 2 155 192 84 12 170 27 143 64 186 221 141 231 14 120 21 144 46 119 210 159 173 242 245 94 52 199 96 18 208 139 171 245 137 179 7 208 220 137 16 8 152 87 62 191 68 39 85 158 15 131 156 233 109 66 74 239 70 198 252 161 237 2 202 211 115 116 66 167 50 148 111 232 184 6 237 191 3 83 157 80 43 111 210 73 203 185 33 40 221 63 218 132 124 231 32 62 238 55 172 2 218 155 140 121 49 138 32 95 235 166 107 201 201 62 208 11 31 161 182 185 134 246 91 105 189 7 132 93 96 168 91 116 98 81 232 194 123 28 96 21 16 47 237 0 208 85 115 133 250 191 113 134 94 165 199 165 201 227 104 191 21 166 77 44 205 244 64 77 201 131 116 247 16 154 59 225 229 17 146 18 81 48 170 68 162 94 165 27 71 208 62 59 76 2 126 241 186 7 196 196 78 208 55 150 65 30 239 67 115 140 80 9 248 129 11 184 193 5 24 224 2 110 112 129 150 116 192 47 104 76 154 128 196 207 142 255 0 0 0 0 73 69 78 68 174 66 96 130]!

initialize
	"Private - Initialize the receiver.
	Register with session events to clean up on startup.
	
	self initialize
	"

	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

isPlaying
	^StepProcess notNil!

midiOutChannel
	^MidiChannel ifNil: [MidiChannel := MidiOutChannel new]!

onStartup
	"Cleanup any left over MIDI channel from last session"

	MidiChannel := nil!

play
	self isPlaying ifTrue: [^self stop].
	StepProcess := [
			[(Delay forDuration: self beatTime milliseconds) wait.
			self step] repeat] 
				forkAt: Processor highestPriority.
	self trigger: #playStarted!

register: aPlimbole 
	self registry add: aPlimbole.
	self when: #step sendTo: aPlimbole!

registry
	^Registry ifNil: [Registry := OrderedCollection new].!

step
	self trigger: #step!

stop
	StepProcess ifNil: [^self].
	StepProcess terminate.
	StepProcess := nil.
	self trigger: #playStopped!

tempo
	^Tempo ifNil: [Tempo := 150]!

tempo: anInteger
	Tempo := anInteger!

unregister: aPlimbole
	self registry remove: aPlimbole.
	self removeEventsTriggeredFor: aPlimbole.
	self registry isEmpty ifTrue: [
		"If we are the last one - stop and close the channel"
		self stop.
		self midiOutChannel free ].
! !

!UI.Examples.Plimbole class categoriesForMethods!
beatTime!accessing!constants!public! !
icon!constants!public! !
initialize!initialization!private! !
isPlaying!public!testing! !
midiOutChannel!private! !
onStartup!initialization!private! !
play!commands!public! !
register:!operations!public! !
registry!accessing!public! !
step!commands!public! !
stop!commands!public! !
tempo!public! !
tempo:!public! !
unregister:!operations!public! !
!

