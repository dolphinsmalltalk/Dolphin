"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #Plimbole
	instanceVariableNames: 'midiOutChannel stepProcess recurse voiceX voiceY scaleIndex noteDuration gridExtent tempo palette'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Plimbole guid: (GUID fromString: '{37200744-DD59-4671-9C52-BEC43269016C}')!
Plimbole comment: ''!
!Plimbole categoriesForClass!MVP-Presenters! !
!Plimbole methodsFor!

beatTime
	^200!

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
	Clipboard current setText: self otomataSignature format: #String!

defaultPalette
	^#('#5D4131' '#7CC1A9' '#ED7829' '#EEA83D' '#FCEBB9' )!

defaultVoice
	^#AcousticGrandPiano!

gridExtent
	^gridExtent!

gridExtent: aPoint
	gridExtent := aPoint.
	self clearAll!

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

pasteFromClipboard
	Clipboard current setText: self otomataSignature format: #String!

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
	(loc x = 0 and: [cell direction = 180]) ifTrue: [self playNoteAtY: cell y].
	(loc x = (self gridExtent x - 1) and: [cell direction = 0]) ifTrue: [self playNoteAtY: cell y].
	(loc y = 0 and: [cell direction = 270]) ifTrue: [self playNoteAtX: cell x].
	(loc y = (self gridExtent y - 1) and: [cell direction = 90]) ifTrue: [self playNoteAtX: cell x]!

playNoteAtX: x
	^self midiOutChannel 
		playNote: (self scale at: x + 1)
		duration: self noteDuration*self beatTime
		channel: 1
!

playNoteAtY: y 
	^self midiOutChannel 
		playNote: (self scale at: y + 1)
		duration: self noteDuration * self beatTime
		channel: 2!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the <CommandQuery>
	arugment."

	| cmd |
	cmd := aCommandQuery commandSymbol.

	"Handle Undo/Redo commands"
	cmd == #play 
		ifTrue: 
			[aCommandQuery
				isChecked: self isPlaying;
				isEnabled: true.
			^true].
	^super queryCommand: aCommandQuery!

scale
	^self pentatonicScale!

scaleIndex
	^scaleIndex

!

scaleIndex: anInteger
	scaleIndex := anInteger

!

scaleName
	^self perform: (self scaleNames at: self scaleIndex)
!

scaleNames
	^#(#pentatonicScale, #chromaticScale, #hangScale)!

setVoices
	(self midiOutChannel open)
		voice: self voiceX channel: 1;
		voice: self voiceY channel: 2!

signature
	"Answer a signature string that represents the current piece"

	| stream |
	stream
		display: self versionString;
		nextPut: $_;
		display: self scaleIndex;
		nextPut: $_;
		display: self tempo.
	^stream contents!

signature: aString 
	"Sets the current piece to that held in aString"

	| stream version tempo scaleIndex model |
	stream := aString readStream.
	(aString beginsWith: 'http:') ifTrue: [stream skipToAll: '?q='].
	version := Integer readFrom: stream.
	version = self signatureVersion ifFalse: [self error: 'Wrong version'].
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	scaleIndex := Integer readFrom: stream.
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	tempo := Integer readFrom: stream.
	stream next = $_ ifFalse: [self error: 'Wrong format'].
	model := ListModel new.
	[stream atEnd] whileFalse: 
			[| cell x y direction |
			x := stream next digitValue.
			y := stream next digitValue.
			direction := stream next digitValue.
			cell := PlimboleCell 
						location: x @ y
						direction: direction
						parent: nil.
			model add: cell].
	self clearAll.
	self tempo: tempo.
	self scaleIndex: scaleIndex.
	self model: model!

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

voice: aSymbol 
	self
		voiceX: aSymbol;
		voiceY: aSymbol!

voiceX
	^voiceX ifNil: [voiceX := self defaultVoice]!

voiceX: aSymbol 
	voiceX := aSymbol.
	self setVoices!

voiceY
	^voiceY ifNil: [voiceY := self defaultVoice]!

voiceY: aSymbol 
	voiceY := aSymbol.
	self setVoices! !
!Plimbole categoriesFor: #beatTime!accessing!constants!public! !
!Plimbole categoriesFor: #cellAtLocation:!helpers!private! !
!Plimbole categoriesFor: #cellExtent!helpers!public! !
!Plimbole categoriesFor: #cells!accessing!public! !
!Plimbole categoriesFor: #checkCell:!private! !
!Plimbole categoriesFor: #checkCellCollisions:!helpers!private! !
!Plimbole categoriesFor: #chromaticScale!constants!public!scales! !
!Plimbole categoriesFor: #clearAll!commands!public! !
!Plimbole categoriesFor: #copyToClipboard!public! !
!Plimbole categoriesFor: #defaultPalette!constants!private! !
!Plimbole categoriesFor: #defaultVoice!constants!private! !
!Plimbole categoriesFor: #gridExtent!accessing!public! !
!Plimbole categoriesFor: #gridExtent:!public! !
!Plimbole categoriesFor: #hangScale!constants!public!scales! !
!Plimbole categoriesFor: #initialize!accessing!initializing!private! !
!Plimbole categoriesFor: #isPlaying!public!testing! !
!Plimbole categoriesFor: #midiOutChannel!private! !
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
!Plimbole categoriesFor: #pasteFromClipboard!public! !
!Plimbole categoriesFor: #pentatonicScale!constants!public!scales! !
!Plimbole categoriesFor: #play!commands!public! !
!Plimbole categoriesFor: #playCellNote:!operations!private! !
!Plimbole categoriesFor: #playNoteAtX:!helpers!operations!private! !
!Plimbole categoriesFor: #playNoteAtY:!helpers!operations!private! !
!Plimbole categoriesFor: #queryCommand:!private! !
!Plimbole categoriesFor: #scale!public!scales! !
!Plimbole categoriesFor: #scaleIndex!accessing!public!scales! !
!Plimbole categoriesFor: #scaleIndex:!accessing!public!scales! !
!Plimbole categoriesFor: #scaleName!accessing!public!scales! !
!Plimbole categoriesFor: #scaleNames!public!scales! !
!Plimbole categoriesFor: #setVoices!private! !
!Plimbole categoriesFor: #signature!accessing!public! !
!Plimbole categoriesFor: #signature:!public! !
!Plimbole categoriesFor: #step!operations!private! !
!Plimbole categoriesFor: #stepCell:!operations!private! !
!Plimbole categoriesFor: #stop!commands!public! !
!Plimbole categoriesFor: #tempo!public! !
!Plimbole categoriesFor: #tempo:!public! !
!Plimbole categoriesFor: #voice:!accessing!public! !
!Plimbole categoriesFor: #voiceX!accessing!public! !
!Plimbole categoriesFor: #voiceX:!accessing!public! !
!Plimbole categoriesFor: #voiceY!accessing!public! !
!Plimbole categoriesFor: #voiceY:!accessing!public! !

!Plimbole class methodsFor!

defaultModel
	^ListModel new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.PlimboleView)  98 12 0 0 98 2 8 1140850688 1 416 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  196934 1 ##(Smalltalk.RGB)  8454655 0 7 0 0 0 416 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  4935 21 754 681 651 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 9 0 0 10 0 0 0 247 10 0 0 79 1 0 0] 98 0 754 193 193 0 27 )! !
!Plimbole class categoriesFor: #defaultModel!public! !
!Plimbole class categoriesFor: #resource_Default_view!public!resources-views! !

