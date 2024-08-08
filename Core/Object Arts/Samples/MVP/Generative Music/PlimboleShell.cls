"Filed out from Dolphin Smalltalk"!

Shell subclass: #PlimboleShell
	instanceVariableNames: 'plimbolePresenter'
	classVariableNames: 'Palettes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PlimboleShell guid: (GUID fromString: '{460acfff-a9a4-4a8b-872d-2b0674d4cfd1}')!

PlimboleShell comment: 'This is the Shell Presenter class for the Plimbole Generative Music Sequencer. It is really only here to supply an associated view that contains UI buttons to send command to the embedded PlimbolePresenter. This is the entry point to the use of Plimbole as a standaline application. Try this:

PlimboleShell show'!

!PlimboleShell categoriesForClass!MVP-Presenters! !

!PlimboleShell methodsFor!

addPartner
	self class show!

addToCommandRoute: route 
	"Private - Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer the next <Presenter> to visit. Here we add our
	Plimbole subcomponent so it will receive the UI commands"

	plimbolePresenter addToCommandRoute: route.
	^super addToCommandRoute: route!

chooseRandomPalette
	| palette index |
	index := Plimbole registry size.
	index = 1 ifTrue: [self class resetPalettes].
	index := (index - 1) % self class palettes size + 1.
	plimbolePresenter palette: (palette := self class palettes at: index).
	self view backcolor: palette last!

createComponents
	super createComponents.
	plimbolePresenter := self add: PlimbolePresenter new name: 'plimbole'!

model: aModel
	super model: aModel.
	plimbolePresenter model: aModel!

onPlayStarted
	self validateUserInterface!

onPlayStopped
	self validateUserInterface!

onViewOpened
	super onViewOpened.
	Plimbole
		when: #playStarted
			send: #onPlayStarted
			to: self;
		when: #playStopped
			send: #onPlayStopped
			to: self.
	self chooseRandomPalette!

queryCommand: aCommandQuery 
	"Fills in details about the current state of the receiver into aCommandQuery"

	| cmd |
	cmd := aCommandQuery commandSymbol.
	cmd == #addPartner 
		ifTrue: 
			[aCommandQuery
				isEnabled: Plimbole registry size<self class maxPlimboles.
			^true].
	^super queryCommand: aCommandQuery! !

!PlimboleShell categoriesForMethods!
addPartner!commands!public! !
addToCommandRoute:!private! !
chooseRandomPalette!private! !
createComponents!initializing!private! !
model:!event handling!private! !
onPlayStarted!private! !
onPlayStopped!private! !
onViewOpened!private! !
queryCommand:!private! !
!

!PlimboleShell class methodsFor!

defaultModel
	^Plimbole new!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Plimbole'!

icon
	^PlimbolePresenter icon!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString!

loadPalettes
	| lines palettes |
	lines := self palettesString lines.
	palettes := lines collect: 
					[:each |
					| palette |
					palette := ($# split: each) allButFirst.
					palette := palette collect: [:c | Color fromHTMLSpec: '#' , c]].
	^palettes!

maxPlimboles
	"We don't want to run out of MIDI channels and, anyway, this is quite enough."

	^6!

palettes
	^Palettes ifNil: [Palettes := self loadPalettes randomizeUsing: Random new ]!

palettesString
	^'#FFFCD6#9DC400#8A9E70#40034D#FE3F2D
#D8E1E8#ABABAB#A3B3C0#587DA7#FFA549
#FFE1AE#F9B32A#FD7150#FA4228#336E7B
#F3C9BF#FE8A71#D9BBAE#0C545C#FE6860
#D1D5D8#F1C40F#E74C3C#1ABC9C#3498DB
#FCEBB6#F07818#F0A830#78C0A8#5E412F'!

resetPalettes
	Palettes := nil
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13238272 65536) 416 nil 196934 1 ##(Smalltalk.RGB) 13671417 328198 ##(Smalltalk.Point) 973 1029 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil nil nil 7 nil nil nil 560 nil 170 192 34 6 410 ##(Smalltalk.Toolbar) 34 28 nil 560 34 2 8 1409286988 131137 656 nil nil nil 519 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 656 nil 8 1795812352 170 192 8 #() nil nil 327686 ##(Smalltalk.Color) #white 170 192 34 4 11511 1115974 2 ##(Smalltalk.ToolbarTextButton) 656 161 1180998 4 ##(Smalltalk.CommandDescription) #nextAltoVoice 8 'Next Alto Voice' 1 1 nil 11511 nil nil $\xEFA9 11495 914 656 161 946 #previousAltoVoice 8 'Previous Alto Voice' 1 1 nil 11495 nil 722 nil true 754 8 #[235 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil $\xEFA9 34 2 992 928 nil nil 13 nil #largeIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[162 1 0 0 4 0 0 0 254 1 0 0 44 0 0 0] 193 34 2 8 1409291084 131137 8 '' 656 3 8 #() 498 193 193 nil 31 8 'altoVoices' 410 ##(Smalltalk.Toolbar) 34 28 nil 560 34 2 8 1409286988 131137 1424 nil nil nil 519 nil 722 nil true 754 784 193 nil nil 1424 nil 8 1795812352 170 192 832 nil nil 864 170 192 34 4 11563 914 1424 161 946 #fasterTempo 8 'Faster Tempo' 1 1 nil 11563 nil nil $\xF8AA 11561 914 1424 161 946 #slowerTempo 8 'Slower Tempo' 1 1 nil 11561 nil 722 nil true 754 1072 193 nil $\xF8AB 34 2 1632 1584 nil nil 13 nil #largeIcons nil nil 1106 1 1 1 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[207 0 0 0 4 0 0 0 46 1 0 0 44 0 0 0] 193 34 2 8 1409291084 131137 8 '' 1424 3 8 #() 498 193 193 nil 31 8 'tempo' 410 ##(Smalltalk.Toolbar) 34 28 nil 560 34 2 8 1409286988 131137 1968 nil nil nil 519 nil 722 nil true 754 784 193 nil nil 1968 nil 8 1795812352 170 192 832 nil nil 864 170 192 34 4 11437 914 1968 161 946 #previousTenorVoice 8 'Previous Tenor Voice' 1 1 nil 11437 nil 722 nil true 754 1072 193 nil $\xF8B2 11439 914 1968 161 946 #nextTenorVoice 8 'Next Tenor Voice' 1 1 nil 11439 nil nil $\xF8B2 34 2 2128 2208 nil nil 13 nil #largeIcons nil nil 1106 1 1 1 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[6 0 0 0 4 0 0 0 98 0 0 0 44 0 0 0] 193 34 2 8 1409291084 131137 8 '' 1968 3 8 #() 498 193 193 nil 31 8 'tenorVoices' nil 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[0 0 0 0 0 0 0 0 244 1 0 0 50 0 0 0] 193 592 8 '' 560 3 34 3 1968 656 1424 498 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2688 nil nil nil 7 nil nil nil 2688 nil 170 192 34 6 410 ##(Smalltalk.Toolbar) 34 28 nil 2688 34 2 8 1409286988 131137 2784 nil nil nil 519 nil 722 nil true 754 784 193 nil nil 2784 nil 8 1795812352 170 192 832 nil nil 864 170 192 34 4 11051 914 2784 161 946 #addPartner 8 'Add Partner' 1 1 nil 11051 nil nil $\xE8FA 10997 914 2784 161 946 #play 8 'Play' 1 1 nil 10997 nil 722 nil true 754 8 #[229 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil $\xF5B0 34 2 2992 2944 nil nil 13 nil #largeIcons nil nil 1106 1 1 1 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[202 0 0 0 6 0 0 0 42 1 0 0 46 0 0 0] 193 34 2 8 1409291084 131137 8 '' 2784 3 8 #() 498 193 193 nil 31 8 'centreTools' 410 ##(Smalltalk.Toolbar) 34 28 nil 2688 34 2 8 1409286988 131137 3344 nil nil nil 519 nil 722 nil true 754 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 77 0 68 0 76 0 50 0 32 0 65 0 115 0 115 0 101 0 116 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3344 nil 8 1795812352 170 192 832 nil nil 864 170 192 34 2 10959 914 3344 161 946 #nextGridExtent 8 'Change Grid Size' 1 1 nil 10959 nil nil $\xF0E2 34 1 3520 nil nil 13 nil #largeIcons nil nil 1106 1 1 1 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[203 1 0 0 6 0 0 0 243 1 0 0 46 0 0 0] 193 34 2 8 1409291084 131137 8 '' 3344 3 8 #() 498 193 193 nil 31 8 'gridTool' 410 ##(Smalltalk.Toolbar) 34 28 nil 2688 34 2 8 1409286988 131137 3824 nil nil nil 519 nil 722 nil true 754 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3824 nil 8 1795812352 170 192 832 nil nil 850 #white 170 192 34 2 10901 914 3824 161 946 #clearAll 8 'Clear' 1 1 nil 10901 nil nil $\xE74D 34 1 4016 nil nil 13 nil #largeIcons nil nil 1106 1 1 1 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[5 0 0 0 6 0 0 0 45 0 0 0 46 0 0 0] 193 34 2 8 1409291084 131137 8 '' 3824 3 8 #() 498 193 193 nil 31 8 'clearTool' nil 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[0 0 0 0 194 1 0 0 244 1 0 0 244 1 0 0] 193 2720 8 '' 2688 3 34 3 3824 2784 3344 498 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4496 nil nil nil 7 nil nil nil 4496 nil 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 28 nil 4496 34 2 8 1409287116 131137 4592 nil nil nil 519 nil 722 nil true 754 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4592 nil 8 1795812352 170 192 832 nil nil 850 #white 170 192 34 6 11747 914 4592 161 946 #copyToClipboard 8 'Copy to Clipboard' 1 1 nil 11747 nil nil $\xE8C8 11745 914 4592 161 946 #pasteClipboard 8 'Paste from Clipboard' 1 1 nil 11745 nil nil $\xE77F 11749 914 4592 161 946 #randomFavourite 8 'Load Random Favourite' 1 1 nil 11749 nil nil $\xEB52 34 3 4832 4784 4880 nil nil 13 nil #largeIcons nil nil 1106 1 1 1 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[7 0 0 0 128 0 0 0 47 0 0 0 7 1 0 0] 193 34 2 8 1409291212 131137 8 '' 4592 3 8 #() 498 193 193 nil 31 8 'sharingTools' nil 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[194 1 0 0 50 0 0 0 244 1 0 0 194 1 0 0] 193 4528 8 '' 4496 3 34 1 4592 498 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 5360 nil nil nil 7 nil nil nil 5360 nil 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 28 nil 5360 34 2 8 1409287116 131137 5456 nil nil nil 519 nil 722 nil true 754 4688 193 nil nil 5456 nil 8 1795812352 170 192 832 nil nil 864 170 192 34 6 11789 914 5456 161 946 #bePentatonicScale 8 'Pentatonic Scale' 1 1 nil 11789 nil 722 nil true 754 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 77 0 68 0 76 0 50 0 32 0 65 0 115 0 115 0 101 0 116 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil $\xEC4F 11787 914 5456 161 946 #beChromaticScale 8 'Chromatic Scale' 1 1 nil 11787 nil nil $\xEC4F 11791 914 5456 161 946 #beHangScale 8 'Hangdrum Scale' 1 1 nil 11791 nil 722 nil true 754 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 77 0 68 0 76 0 50 0 32 0 65 0 115 0 115 0 101 0 116 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil $\xEC4F 34 3 5712 5616 5760 nil nil 13 nil #largeIcons nil nil 1106 1 1 1 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[7 0 0 0 128 0 0 0 47 0 0 0 7 1 0 0] 193 34 2 8 1409291212 131137 8 '' 5456 3 8 #() 498 193 193 nil 31 8 'scale' nil 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[0 0 0 0 50 0 0 0 50 0 0 0 194 1 0 0] 193 5392 8 '' 5360 3 34 1 5456 498 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 6288 nil 850 #silver nil 7 nil nil nil 6288 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.PlimbolePresenter) #resource_Default_view nil 1138 138 144 34 1 1202 #createWindow: 34 1 1250 1282 8 #[50 0 0 0 50 0 0 0 194 1 0 0 194 1 0 0] 193 6320 8 '' 6288 3 832 498 193 193 nil 27 170 192 34 10 4496 8 'right' 5360 8 'left' 2688 8 'bottom' 6288 8 'plimbole' 560 8 'top' nil nil nil nil nil 1 nil nil 498 1321 1401 498 481 561 1 nil 193 1138 138 144 34 1 1202 #createWindow: 34 1 1250 590342 ##(Smalltalk.Rectangle) 498 6143 21 498 7175 1099 193 448 8 'Plimbole' 416 1 34 5 6288 2688 560 4496 5360 498 193 193 nil 27 )! !

!PlimboleShell class categoriesForMethods!
defaultModel!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!development!initializing!private! !
loadPalettes!operations!private! !
maxPlimboles!constants!public! !
palettes!operations!private! !
palettesString!constants!private! !
resetPalettes!operations!private! !
resource_Default_view!public!resources-views! !
!

