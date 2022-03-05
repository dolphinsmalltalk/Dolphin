"Filed out from Dolphin Smalltalk"!

Object subclass: #MidiOutChannel
	instanceVariableNames: 'midiout noteProcess octaveShift'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MidiOutChannel guid: (GUID fromString: '{f97d6167-73d1-4a93-8f82-93a9ebc90f5d}')!
MidiOutChannel comment: ''!
!MidiOutChannel categoriesForClass!Kernel-Objects! !
!MidiOutChannel methodsFor!

defaultDeviceId
	^0!

defaultDuration
	^5 seconds!

defaultVelocity
	^127!

defaultVoice
	^#AcousticGrand!

free
	midiout notNil 
		ifTrue: 
			[self midiout close.
			midiout := nil]!

initialize
	super initialize.
	self beFinalizable.!

mapNoteToValue: aSymbol 
	| octave noteOnly |
	octave := 3.
	noteOnly := aSymbol.
	aSymbol last isDigit 
		ifTrue: 
			[octave := aSymbol last digitValue.
			noteOnly := aSymbol allButLast asSymbol].
	octave := octave + self octaveShift.
	^(self midiNoteMap at: noteOnly) + (octave * 12) !

mapVoiceToValue: aVoiceSymbol 
	^(self class generalMidiMap indexOf: aVoiceSymbol)-1!

midiNoteMap
	^##((IdentityDictionary new)
		at: #C put: 0;
		at: #'C#' put: 1;
		at: #'Db' put: 1;
		at: #D put: 2;
		at: #'D#' put: 3;
		at: #'Eb' put: 3;
		at: #E put: 4;
		at: #F put: 5;
		at: #'F#' put: 6;
		at: #'Gb' put: 6;
		at: #G put: 7;
		at: #'G#' put: 8;
		at: #'Ab' put: 8;
		at: #A put: 9;
		at: #'A#' put: 10;
		at: #'Bb' put: 11;
		at: #B put: 11;
		yourself)!

midiout
	midiout 
		ifNil: 
			[| ret |
			midiout := MIDIOut new.
			ret := midiout openDeviceID: self defaultDeviceId.
			ret = 0 ifFalse: [self error: 'Can''t open MIDI device']].
	^midiout!

octaveShift
	^0!

open
	self midiout
!

playNote: noteName channel: channel 
	self 
		playNote: noteName
		velocity: self defaultVelocity
		duration: self defaultDuration
		channel: channel!

playNote: noteName duration: aDuration channel: channel
	self
		playNote: noteName
		velocity: self defaultVelocity
		duration: aDuration
		channel: channel!

playNote: noteName velocity: velocity channel: channel 
	self 
		playNote: noteName
		velocity: velocity
		duration: self defaultDuration
		channel: channel!

playNote: noteName velocity: velocity duration: aDuration channel: channel
	"Play a new note for a specified duration"

	| noteVal |
	noteVal := self mapNoteToValue: noteName.
	self midiout
		keyDown: noteVal
		velocity: velocity
		channel: channel.

	"If the duration is nil the note goes on forever"
	aDuration ifNil: [^self].
	
	[Processor sleep: aDuration.
	midiout notNil ifTrue: [self midiout keyUp: noteVal channel: channel]]
			forkAt: Processor highestPriority!

voice: voice channel: channel
	self midiout voice: (self mapVoiceToValue: voice ) channel: channel! !
!MidiOutChannel categoriesForMethods!
defaultDeviceId!private! !
defaultDuration!private! !
defaultVelocity!private! !
defaultVoice!private! !
free!private! !
initialize!private! !
mapNoteToValue:!helpers!private! !
mapVoiceToValue:!private! !
midiNoteMap!private! !
midiout!accessing!public! !
octaveShift!helpers!private! !
open!private! !
playNote:channel:!public! !
playNote:duration:channel:!public! !
playNote:velocity:channel:!public! !
playNote:velocity:duration:channel:!public! !
voice:channel:!public! !
!

!MidiOutChannel class methodsFor!

generalMidiMap
	^#(#AcousticGrand #BrightAcoustic #ElectricGrand #'Honky-tonk' #ElectricPianoI #ElectricPiano2 #Harpsichord #Clav #Celesta #Glockenspiel #MusicBox #Vibraphone #Marimba #Xylophone #TubularBells #Dulcimer #DrawbarOrgan #PercussiveOrgan #RockOrgan #ChurchOrgan #ReedOrgan #Accordian #Harmonica #TangoAccordian #AcousticGuitarNylon #AcousticGuitarSteel #ElectricGuitarJazz #ElectricGuitarClean #ElectricGuitarMuted #OverdrivenGuitar #DistortionGuitar #GuitarHarmonics #AcousticBass #ElectricBassFinger #ElectricBassPick #FretlessBass #SlapBass1 #SlapBass2 #SynthBass1 #SynthBass2 #Violin #Viola #Cello #Contrabass #TremoloStrings #PizzicatoStrings #OrchestralStrings #Timpani #StringEnsemble1 #StringEnsemble2 #SynthStrings1 #SynthStrings2 #ChoirAahs #VoiceOohs #SynthVoice #OrchestraHit #Trumpet #Trombone #Tuba #MutedTrumpet #FrenchHorn #BrassSection #SynthBrass1 #SynthBrass2 #SopranoSaxophone #AltoSaxophone #TenorSaxophone #BaritoneSaxophone #Oboe #EnglishHorn #Bassoon #Clarinet #Piccolo #Flute #Recorder #PanFlute #BlownBottle #Shakuhachi #Whistle #Ocarina #Lead1Square #Lead2Sawtooth #Lead3Calliope #Lead4Chiff #Lead5Charang #Lead6Voice #Lead7Fifths #Lead8BassAndLead #Pad1NewAge #Pad2Warm #Pad3Polysynth #Pad4Choir #Pad5Bowed #Pad6Metallic #Pad7Halo #Pad8Wweep #FX1Rain #FX2Soundtrack #FX3Crystal #FX4Atmosphere #FX5Brightness #FX6Goblins #FX7Echoes #FX8SciFi #Sitar #Banjo #Shamisen #Koto #Kalimba #Bagpipe #Fiddle #Shanai #TinkleBell #Agogo #SteelDrums #Woodblock #TaikoDrum #MelodicTom #SynthDrum #ReverseCymbal #GuitarFretNoise #BreathingNoise #Seashore #BirdTweet #TelephoneRing #Helicopter #Applause #Gunshot)!

new
	^super new initialize! !
!MidiOutChannel class categoriesForMethods!
generalMidiMap!public! !
new!instance creation!public! !
!

