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

cells
	^cells!

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
	cells := OrderedCollection new.
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

piece
	^PlimbolePiece new
		scaleIndex: scaleIndex;
		tempo: self tempo;
		cells: self cells;
		gridSize: self gridExtent x;
		tenorIndex: self tenorVoiceIndex;
		altoIndex: self altoVoiceIndex;
		yourself!

piece: details
	self reset.
	cells := details cells.
	self tempo: details tempo.
	scaleIndex := details scaleIndex.
	self gridExtent: details gridSize asPoint.
	self tenorVoiceIndex: details tenorIndex.
	self altoVoiceIndex: details altoIndex!

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

scaleName
	^self scaleNames at: scaleIndex!

scaleName: aSymbol
	scaleIndex := self scaleNames indexOf: aSymbol.
	^self!

scaleNames
	^#(#pentatonicScale #chromaticScale #hangScale)!

setVoices
	(self midiOutChannel open)
		voice: self tenorVoice channel: tenorChannel;
		voice: self altoVoice channel: altoChannel!

signature
	"Answer a signature string that represents the current piece"

	^self piece asString!

signature: aString
	"Sets the current piece to that parsed from a String."

	self piece: (PlimbolePiece fromString: aString)!

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
altoChannel!accessing!public! !
altoVoice!accessing!public! !
altoVoice:!accessing!public! !
altoVoiceIndex!accessing!private! !
altoVoiceIndex:!accessing!private! !
altoVoices!constants!public!voices! !
assignAvailableChannels!private! !
beatTime!accessing!constants!public! !
cellAtLocation:!helpers!private! !
cells!accessing!public! !
checkCell:!private! !
checkCellCollisions:!helpers!private! !
chromaticScale!constants!public!scales! !
clearCells!operations!public! !
defaultVoice!constants!private! !
gridExtent!accessing!public! !
gridExtent:!accessing!public! !
hangScale!constants!public!scales! !
initialize!accessing!initializing!private! !
isPlaying!public!testing! !
midiOutChannel!private! !
noteDuration!accessing!helpers!public! !
noteDuration:!accessing!public! !
otomataSignature!accessing!public! !
pentatonicScale!constants!public!scales! !
piece!accessing!public! !
piece:!initializing!public! !
play!operations!public! !
playCellNote:!operations!private! !
playNoteAtX:!helpers!operations!private! !
playNoteAtY:!helpers!operations!private! !
register!public! !
removeCell:!operations!public! !
reset!operations!private! !
scale!accessing!public!scales! !
scaleName!accessing!public!scales! !
scaleName:!accessing!public!scales! !
scaleNames!public!scales! !
setVoices!private! !
signature!accessing!public! !
signature:!initializing!public! !
step!operations!public! !
stepCell:!operations!private! !
stop!operations!public! !
tempo!accessing!public! !
tempo:!accessing!public! !
tenorChannel!accessing!public! !
tenorVoice!accessing!public! !
tenorVoice:!accessing!public! !
tenorVoiceIndex!accessing!private! !
tenorVoiceIndex:!accessing!private! !
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
	^Icon fromFile: 'Plimbole.ico' usingLocator: (PackageRelativeFileLocator packageNamed: 'Plimbole')!

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

