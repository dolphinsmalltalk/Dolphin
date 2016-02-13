"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MidiOutChannel
	instanceVariableNames: 'midiout noteProcess octaveShift'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MidiOutChannel guid: (GUID fromString: '{F97D6167-73D1-4A93-8F82-93A9EBC90F5D}')!
MidiOutChannel comment: ''!
!MidiOutChannel categoriesForClass!Kernel-Objects! !
!MidiOutChannel methodsFor!

defaultDeviceId
	^0!

defaultDuration
	^5000!

defaultVelocity
	^127!

defaultVoice
	^#AcousticGrandPiano!

free
	midiout notNil 
		ifTrue: 
			[self midiout close.
			midiout := nil]!

generalMidiMap
	^##((LookupTable new)
		at: #AcousticGrandPiano put: 1;
		at: #Xylophone put: 14;
		at: #TubularBells put: 15;
		at: #NylonGuitar put: 25;
		at: #DistortGuitar put: 31;
		at: #SlapBass1 put: 37;
		at: #SynthStrings1 put: 51;
		at: #ChoirAahs put: 53;
		at: #VoiceOohs put: 54;
		at: #SynthVoice put: 55;
		at: #Flute put: 74;
		at: #PanFlute put: 76;
		at: #Ocarina put: 80;
		at: #Charang put: 85;
		at: #PolySynthPad put: 91;
		at: #HaloPad put: 95;
		at: #TinkleBell put: 113;
		at: #SteelDrums put: 115;
		at: #SynthDrum put: 199;
		at: #BirdTweet put: 124;
		yourself)!

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
	^(self generalMidiMap at: aVoiceSymbol)-1!

midiNoteMap
	^##((LookupTable new)
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

playNote: noteName duration: ms channel: channel
 
	self 
		playNote: noteName
		velocity: self defaultVelocity
		duration: ms
		channel: channel!

playNote: noteName velocity: velocity channel: channel 
	self 
		playNote: noteName
		velocity: velocity
		duration: self defaultDuration
		channel: channel!

playNote: noteName velocity: velocity duration: ms channel: channel 
	"Play a new note for a specified duration"

	| noteVal |
	noteVal := self mapNoteToValue: noteName.
	self midiout 
		keyDown: noteVal
		velocity: velocity
		channel: channel.

	"If the duration is nil the note goes on forever"
	ms ifNil: [^self].
	
	[Processor sleep: ms.
	midiout notNil ifTrue: [self midiout keyUp: noteVal channel: channel]] 
			forkAt: Processor highestPriority!

voice: voice channel: channel
	self midiout voice: (self mapVoiceToValue: voice ) channel: channel! !
!MidiOutChannel categoriesFor: #defaultDeviceId!private! !
!MidiOutChannel categoriesFor: #defaultDuration!private! !
!MidiOutChannel categoriesFor: #defaultVelocity!private! !
!MidiOutChannel categoriesFor: #defaultVoice!private! !
!MidiOutChannel categoriesFor: #free!private! !
!MidiOutChannel categoriesFor: #generalMidiMap!private! !
!MidiOutChannel categoriesFor: #initialize!private! !
!MidiOutChannel categoriesFor: #mapNoteToValue:!helpers!private! !
!MidiOutChannel categoriesFor: #mapVoiceToValue:!private! !
!MidiOutChannel categoriesFor: #midiNoteMap!private! !
!MidiOutChannel categoriesFor: #midiout!accessing!public! !
!MidiOutChannel categoriesFor: #octaveShift!helpers!private! !
!MidiOutChannel categoriesFor: #open!private! !
!MidiOutChannel categoriesFor: #playNote:channel:!public! !
!MidiOutChannel categoriesFor: #playNote:duration:channel:!public! !
!MidiOutChannel categoriesFor: #playNote:velocity:channel:!public! !
!MidiOutChannel categoriesFor: #playNote:velocity:duration:channel:!public! !
!MidiOutChannel categoriesFor: #voice:channel:!public! !

!MidiOutChannel class methodsFor!

new
	^super new initialize! !
!MidiOutChannel class categoriesFor: #new!instance creation!public! !

