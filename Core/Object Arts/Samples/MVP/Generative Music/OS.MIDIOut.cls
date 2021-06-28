"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'OS.MIDIOut'
	instanceVariableNames: 'handle'
	classVariableNames: ''
	imports: #(#{OS.MidiConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.MIDIOut guid: (Core.GUID fromString: '{feb23957-1be7-48db-9eef-924631f6e9a9}')!
OS.MIDIOut comment: ''!
!OS.MIDIOut categoriesForClass!Kernel-Objects! !
!OS.MIDIOut methodsFor!

channel: ch msg: msg with: p1 with: p2 
	| dword |
	dword := ByteArray 
				with: (msg << 4 bitOr: ch & 16rF)
				with: p1
				with: p2
				with: 0.
	^WinMMLibrary default midiOutShortMsgHmo: handle dwMsg: dword!

close
	^WinMMLibrary default midiOutCloseHmo: handle!

controller: controllerID value: anInteger 
	^self 
		channel: 0
		msg: MidiControlChange
		with: controllerID
		with: anInteger!

keyDown: noteNum velocity: velocity 
	^self 
		keyDown: noteNum
		velocity: velocity
		channel: 0!

keyDown: noteNum velocity: velocity channel: channel 
	^self 
		channel: channel
		msg: MidiChannelNoteOn
		with: noteNum
		with: velocity!

keyUp: noteNum 
	^self keyUp: noteNum channel: 0!

keyUp: noteNum channel: channel 
	^self 
		channel: channel
		msg: MidiChannelNoteOff
		with: noteNum
		with: 0!

openDeviceID: deviceID 
	handle := DWORDBytes new.
	^WinMMLibrary default 
		midiOutOpenLphmo: handle
		uDeviceID: deviceID
		dwCallback: nil
		dwCallbackInstance: nil
		dwFlags: nil!

voice: voiceID channel: channel 
	^self 
		channel: channel
		msg: MidiProgramChange
		with: voiceID
		with: channel! !
!OS.MIDIOut categoriesFor: #channel:msg:with:with:!public! !
!OS.MIDIOut categoriesFor: #close!public! !
!OS.MIDIOut categoriesFor: #controller:value:!public! !
!OS.MIDIOut categoriesFor: #keyDown:velocity:!public! !
!OS.MIDIOut categoriesFor: #keyDown:velocity:channel:!public! !
!OS.MIDIOut categoriesFor: #keyUp:!public! !
!OS.MIDIOut categoriesFor: #keyUp:channel:!public! !
!OS.MIDIOut categoriesFor: #openDeviceID:!public! !
!OS.MIDIOut categoriesFor: #voice:channel:!public! !

