"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.PlimboleShell'
	instanceVariableNames: 'plimbolePresenter'
	classVariableNames: 'Palettes'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.PlimboleShell guid: (Core.GUID fromString: '{460acfff-a9a4-4a8b-872d-2b0674d4cfd1}')!

UI.Examples.PlimboleShell comment: 'This is the Shell Presenter class for the Plimbole Generative Music Sequencer. It is really only here to supply an associated view that contains UI buttons to send command to the embedded PlimbolePresenter. This is the entry point to the use of Plimbole as a standaline application. Try this:

PlimboleShell show'!

!UI.Examples.PlimboleShell categoriesForClass!MVP-Presenters! !

!UI.Examples.PlimboleShell methodsFor!

addPartner
	<commandQuery: #queryAddPartner:>
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

queryAddPartner: aCommandQuery
	aCommandQuery isEnabled: Plimbole registry size < self class maxPlimboles! !

!UI.Examples.PlimboleShell categoriesForMethods!
addPartner!commands!public! !
addToCommandRoute:!private! !
chooseRandomPalette!private! !
createComponents!initializing!private! !
model:!event handling!private! !
onPlayStarted!private! !
onPlayStopped!private! !
onViewOpened!private! !
queryAddPartner:!private! !
!

!UI.Examples.PlimboleShell class methodsFor!

defaultModel
	^Plimbole new!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Plimbole'!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13238272 65536) 32 nil 326 1 #{Graphics.RGB} 13671417 518 #{Graphics.Point} 973 1029 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 192 nil nil nil 5 nil nil nil 192 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 18 #{UI.Toolbar} 50 28 nil 192 50 2 8 1409286988 131137 304 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 304 nil nil 258 #{Core.IdentityDictionary} 8 #() nil nil 6 #{Graphics.Color} #white nil 50 2 1862 2 #{UI.ToolbarTextButton} 304 161 1350 4 #{UI.CommandDescription} #previousAltoVoice 8 'Previous Alto Voice' 1 1 nil nil nil 370 nil true 402 8 #[235 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil 8 $\xEFA9 530 304 161 562 #nextAltoVoice 8 'Next Alto Voice' 1 1 nil nil nil nil 8 $\xEFA9 nil nil 13 1 #largeIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[162 1 0 0 4 0 0 0 249 1 0 0 44 0 0 0] 193 50 2 8 1409291084 131137 8 '' 304 3 8 #() 130 193 193 nil 31 8 'altoVoices' 18 #{UI.Toolbar} 50 28 nil 192 50 2 8 1409289036 131137 1040 nil nil nil 5 nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1040 nil nil 258 #{Core.IdentityDictionary} 464 nil nil 496 nil 50 2 530 1040 161 562 #slowerTempo 8 'Slower Tempo' 1 1 nil nil nil 370 nil true 402 8 #[235 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil 8 $\xF8AB 530 1040 161 562 #fasterTempo 8 'Faster Tempo' 1 1 nil nil nil nil 8 $\xF8AA nil nil 13 5 #largeIcons nil nil 738 1 1 1 770 50 1 818 #createWindow: 50 1 866 898 8 #[207 0 0 0 4 0 0 0 46 1 0 0 44 0 0 0] 193 50 2 8 1409293132 131137 8 '' 1040 3 8 #() 130 193 193 nil 31 8 'tempo' 18 #{UI.Toolbar} 50 28 nil 192 50 2 8 1409286988 131137 1584 nil nil nil 517 nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1584 nil nil 258 #{Core.IdentityDictionary} 464 nil nil 496 nil 50 2 530 1584 161 562 #previousTenorVoice 8 'Previous Tenor Voice' 1 1 nil nil nil 370 nil true 402 8 #[235 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil 8 $\xF8B2 530 1584 161 562 #nextTenorVoice 8 'Next Tenor Voice' 1 1 nil nil nil nil 8 $\xF8B2 nil nil 13 1 #largeIcons nil nil 738 1 1 1 770 50 1 818 #createWindow: 50 1 866 898 8 #[6 0 0 0 4 0 0 0 98 0 0 0 44 0 0 0] 193 50 2 8 1409291084 131137 8 '' 1584 3 8 #() 130 193 193 nil 31 8 'tenorVoices' nil 770 50 1 818 #createWindow: 50 1 866 898 8 #[0 0 0 0 0 0 0 0 244 1 0 0 50 0 0 0] 193 224 8 '' 192 3 50 3 1584 1040 304 130 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2288 nil nil nil 5 nil nil nil 2288 nil 258 #{Core.IdentityDictionary} 50 6 18 #{UI.Toolbar} 50 28 nil 2288 50 2 8 1409289036 131137 2384 nil nil nil 5 nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2384 nil nil 258 #{Core.IdentityDictionary} 464 nil nil 496 nil 50 2 530 2384 161 562 #play 8 'Play' 1 1 nil nil nil 370 nil true 402 8 #[229 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil 8 $\xF5B0 530 2384 161 562 #addPartner 8 'Add Partner' 1 1 nil nil nil nil 8 $\xE8FA nil nil 13 5 #largeIcons nil nil 738 1 1 1 770 50 1 818 #createWindow: 50 1 866 898 8 #[202 0 0 0 6 0 0 0 42 1 0 0 46 0 0 0] 193 50 2 8 1409293132 131137 8 '' 2384 3 8 #() 130 193 193 nil 31 8 'centreTools' 18 #{UI.Toolbar} 50 28 nil 2288 50 2 8 1409286988 131137 2928 nil nil nil 5 nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2928 nil nil 258 #{Core.IdentityDictionary} 464 nil nil 496 nil 50 1 530 2928 161 562 #clearAll 8 'Clear' 1 1 nil nil nil nil 8 $\xE74D nil nil 13 1 #largeIcons nil nil 738 1 1 1 770 50 1 818 #createWindow: 50 1 866 898 8 #[5 0 0 0 6 0 0 0 45 0 0 0 46 0 0 0] 193 50 2 8 1409291084 131137 8 '' 2928 3 8 #() 130 193 193 nil 31 8 'clearTool' 18 #{UI.Toolbar} 50 28 nil 2288 50 2 8 1409289036 131137 3360 nil nil nil 517 nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 77 0 68 0 76 0 50 0 32 0 65 0 115 0 115 0 101 0 116 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3360 nil nil 258 #{Core.IdentityDictionary} 464 nil nil 496 nil 50 1 530 3360 161 562 #nextGridExtent 8 'Change Grid Size' 1 1 nil nil nil nil 8 $\xF0E2 nil nil 13 5 #largeIcons nil nil 738 1 1 1 770 50 1 818 #createWindow: 50 1 866 898 8 #[203 1 0 0 6 0 0 0 243 1 0 0 46 0 0 0] 193 50 2 8 1409293132 131137 8 '' 3360 3 8 #() 130 193 193 nil 31 8 'gridTool' nil 770 50 1 818 #createWindow: 50 1 866 898 8 #[0 0 0 0 194 1 0 0 244 1 0 0 244 1 0 0] 193 2320 8 '' 2288 3 50 3 2928 2384 3360 130 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3952 nil nil nil 5 nil nil nil 3952 nil 258 #{Core.IdentityDictionary} 50 2 18 #{UI.Toolbar} 50 28 nil 3952 50 2 8 1409287116 131137 4048 nil nil nil 517 nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 70 0 108 0 117 0 101 0 110 0 116 0 32 0 73 0 99 0 111 0 110 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4048 nil nil 258 #{Core.IdentityDictionary} 464 nil nil 496 nil 50 3 530 4048 161 562 #pasteClipboard 8 'Paste from Clipboard' 1 1 nil nil nil nil 8 $\xE77F 530 4048 161 562 #copyToClipboard 8 'Copy to Clipboard' 1 1 nil nil nil nil 8 $\xE8C8 530 4048 161 562 #randomFavourite 8 'Load Random Favourite' 1 1 nil nil nil nil 8 $\xEB52 nil nil 13 9 #largeIcons nil nil 738 1 1 1 770 50 1 818 #createWindow: 50 1 866 898 8 #[7 0 0 0 128 0 0 0 47 0 0 0 7 1 0 0] 193 50 2 8 1409291212 131137 8 '' 4048 3 8 #() 130 193 193 nil 31 8 'sharingTools' nil 770 50 1 818 #createWindow: 50 1 866 898 8 #[194 1 0 0 50 0 0 0 244 1 0 0 194 1 0 0] 193 3984 8 '' 3952 3 50 1 4048 130 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 4768 nil nil nil 5 nil nil nil 4768 nil 258 #{Core.IdentityDictionary} 50 2 18 #{UI.Toolbar} 50 28 nil 4768 50 2 8 1409287116 131137 4864 nil nil nil 517 nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 77 0 68 0 76 0 50 0 32 0 65 0 115 0 115 0 101 0 116 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4864 nil nil 258 #{Core.IdentityDictionary} 464 nil nil 496 nil 50 3 530 4864 161 562 #beChromaticScale 8 'Chromatic Scale' 1 1 nil nil nil nil 8 $\xEC4F 530 4864 161 562 #bePentatonicScale 8 'Pentatonic Scale' 1 1 nil nil nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 255 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 77 0 68 0 76 0 50 0 32 0 65 0 115 0 115 0 101 0 116 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil 8 $\xEC4F 530 4864 161 562 #beHangScale 8 'Hangdrum Scale' 1 1 nil nil nil 370 nil true 402 8 #[227 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 18 83 0 101 0 103 0 111 0 101 0 32 0 77 0 68 0 76 0 50 0 32 0 65 0 115 0 115 0 101 0 116 0 115 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil 8 $\xEC4F nil nil 13 1 #largeIcons nil nil 738 1 1 1 770 50 1 818 #createWindow: 50 1 866 898 8 #[7 0 0 0 128 0 0 0 47 0 0 0 7 1 0 0] 193 50 2 8 1409291212 131137 8 '' 4864 3 8 #() 130 193 193 nil 31 8 'scale' nil 770 50 1 818 #createWindow: 50 1 866 898 8 #[0 0 0 0 50 0 0 0 50 0 0 0 194 1 0 0] 193 4800 8 '' 4768 3 50 1 4864 130 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 5680 nil 482 #silver nil 5 nil nil nil 5680 582 1 #{UI.ResourceIdentifier} #{UI.Examples.PlimbolePresenter} #resource_Default_view nil 770 50 1 818 #createWindow: 50 1 866 898 8 #[50 0 0 0 50 0 0 0 194 1 0 0 194 1 0 0] 193 5712 8 '' 5680 3 464 130 193 193 nil 27 258 #{Core.IdentityDictionary} 50 10 2288 8 'bottom' 4768 8 'left' 5680 8 'plimbole' 3952 8 'right' 192 8 'top' nil nil nil nil nil 1 nil nil 130 1321 1401 130 481 561 nil nil 193 770 50 1 818 #createWindow: 50 1 866 518 #{Graphics.Rectangle} 130 7679 21 130 8711 1099 193 80 8 'Plimbole' 32 1 50 5 5680 2288 192 3952 4768 130 193 193 nil 27)! !

!UI.Examples.PlimboleShell class categoriesForMethods!
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

