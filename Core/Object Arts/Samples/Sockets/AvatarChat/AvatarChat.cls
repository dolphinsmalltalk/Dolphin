"Filed out from Dolphin Smalltalk 7"!

Chat subclass: #AvatarChat
	instanceVariableNames: 'agent callerAvatar'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AvatarChat guid: (GUID fromString: '{f5308c15-8ee9-11d3-9846-444553540000}')!
AvatarChat comment: 'AvatarChat is a <topPresenter> implementing a "chat" service that uses an avatar to represent the caller at the other end of the connection. An instance can be opened on any machine that is running TCP/IP and has the Microsoft Agent installed by using:

AvatarChat show.

Instance Variables:
	agent		<IAgentCtlEx> interface to the MS Agent component
	callerAvatar	<IAgentCtlCharacterEx> interface for the caller''s avatar.

'!
!AvatarChat categoriesForClass!Samples! !
!AvatarChat methodsFor!

agent
	"Answers the IAgentCtl for the receiver's avatars"

	agent isNull ifTrue: [
		agent := IAgentCtlEx new.
		agent connected: true ].
	^agent!

byeMessage
	"Private - Answer a <readableString> used when an avatar says goodbye"

	^'Goodbye!!'!

callerAvatar
	"Answers the <IAgentCtlCharacterEx> for the caller's avatars"

	callerAvatar isNil ifTrue: [
		callerAvatar := self characters first queryInterface: IAgentCtlCharacterEx ].
	^callerAvatar!

characters
	"Answers the <IAgentCtlCharacters> collection of characters available"

	| characters |
	characters := self agent characters.
	characters contents isEmpty 
		ifTrue: 
			[File 
				for: '*.acs'
				in: (File composePath: SessionManager current windowsDirectory
						subPath: 'msagent\chars\')
				do: [:each | characters load: (File removeExtension: each fileName) loadKey: each fileName]].
	^characters contents 
		collect: [:each | each queryInterface: IAgentCtlCharacterEx]!

chooseAvatar
	"Private - Choose an avatar to use for the conversation"

	^(ChoicePrompter create)
		caption: 'Choose a character';
		choices: self characters;
		getTextBlock: [:character | character name];
		showModal
!

chooseCallerAvatar
	"Prompts the user to select a character for the caller's avatar"

	| avatar |
	avatar := self chooseAvatar.
	avatar isNil ifTrue: [^self].
	callerAvatar notNil 
		ifTrue: 
			[self hideCallerAvatar.
			callerAvatar := avatar.
			self showCallerAvatar].
	callerAvatar := avatar!

helloMessage
	"Private - Answer a <readableString> used when an avatar says hello"

	^'Hello!!'!

hideCallerAvatar
	"Private - Get rid of the avatar"

	callerAvatar isNil ifTrue: [^self].
	self sayByeTo: callerAvatar.
	callerAvatar hide.
	callerAvatar := nil!

messageReceived: anAssociation 
	"Private - Accepts aString as the incoming message"

	| msg |
	super messageReceived: anAssociation.
	msg := anAssociation value.
	msg isEmpty ifTrue: [^self].
	(self callerAvatar)
		play: 'Write' ifAbsent: [];
		speak: msg url: nil!

onViewClosed
	"Private - Sent by the receiver's view when it has been closed"

	self hideCallerAvatar.
	super onViewClosed.!

sayByeTo: anIAgentControlCharacter
	"Private - Say goodbye for anIAgentControlCharacter"

	anIAgentControlCharacter speak: self byeMessage!

sayGreetingTo: anIAgentControlCharacter
	"Private - Say the greeting for anIAgentControlCharacter"

	anIAgentControlCharacter 
		play: 'Greet' ifAbsent: [];
		speak: self helloMessage.!

showCallerAvatar
	"Private - Get the caller's avatar to appear"

	| origin center |
	origin := self view position.
	center := origin + (self view extent //2). 
	self callerAvatar
		moveTo: origin x y: origin y;	
		show: false;
		moveTo: center x y: center y.
	self sayGreetingTo: self callerAvatar.
	!

socketConnected: aSocket2 
	"Private - An event has occurred indicating that an incoming connection for aSocket 
	has been accepted."

	super socketConnected: aSocket2.
	self showCallerAvatar!

socketDisconnected
	"Disconnect from any other chat window and wait for new calls"

	self hideCallerAvatar.
	super socketDisconnected! !
!AvatarChat categoriesFor: #agent!accessing!public! !
!AvatarChat categoriesFor: #byeMessage!accessing!constants!private! !
!AvatarChat categoriesFor: #callerAvatar!accessing!public! !
!AvatarChat categoriesFor: #characters!accessing!public! !
!AvatarChat categoriesFor: #chooseAvatar!commands!private! !
!AvatarChat categoriesFor: #chooseCallerAvatar!accessing!public! !
!AvatarChat categoriesFor: #helloMessage!accessing!constants!private! !
!AvatarChat categoriesFor: #hideCallerAvatar!operations!private! !
!AvatarChat categoriesFor: #messageReceived:!operations!private! !
!AvatarChat categoriesFor: #onViewClosed!event handling!private! !
!AvatarChat categoriesFor: #sayByeTo:!operations!private! !
!AvatarChat categoriesFor: #sayGreetingTo:!operations!private! !
!AvatarChat categoriesFor: #showCallerAvatar!operations!private! !
!AvatarChat categoriesFor: #socketConnected:!event handling!private! !
!AvatarChat categoriesFor: #socketDisconnected!commands!public! !

!AvatarChat class methodsFor!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self sampleDescription
		helpId: 10609!

resource_Minimal_view
	"Answer the literal data from which the 'Minimal view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Minimal_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ContainerView)  98 15 0 0 98 2 8 1140850688 131073 416 0 721158 ##(SystemColor)  31 328198 ##(Point)  1141 341 519 265030 4 ##(Menu)  0 16 98 1 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #chooseCallerAvatar 8 'Choose &Avatar' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 416 852230 ##(FramingLayout)  234 240 98 16 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 784 0 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 784 0 8 4294906781 642 8 #send 8 '&Send' 1 1 0 0 32 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 530 961 85 530 161 51 784 1042 8 #text: 98 1 8 '&Send' 784 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 42 0 0 0 48 2 0 0 67 0 0 0] 98 0 530 193 193 0 27 1181766 2 ##(FramingConstraints)  1114638 ##(STBSingletonProxy)  8 ##(FramingCalculation)  8 #fixedParentRight -179 1322 1344 8 #fixedViewLeft 161 1322 1344 8 #fixedParentTop 85 1322 1344 8 #fixedViewTop 51 410 8 ##(StatusBar)  98 18 0 416 98 2 8 1140850700 1 1472 0 498 31 0 7 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 183 4 128 213 87 1 0 0 204 53 87 1 3 0 34 59 0 0 0 0 15 1 31 86 135 1] 530 193 193 0 1472 0 8 4294904581 234 256 98 2 853766 ##(StatusBarItem)  1 -1 1472 0 8 ##(BasicListAbstract)  0 1322 8 ##(IconImageManager)  8 #current 8 'status' 202 208 98 1 1728 1115142 ##(StatusBarNullItem)  513 1 1472 0 0 978 202 208 98 1 1042 1072 98 2 530 11 283 530 1121 49 1472 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 141 0 0 0 53 2 0 0 165 0 0 0] 98 0 1264 0 27 1282 1322 1344 8 #fixedParentLeft 11 1328 -9 1322 1344 8 #fixedViewBottom -47 1322 1344 8 #fixedParentBottom -9 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140916224 1025 2160 0 866 896 0 7 0 0 0 2160 0 8 4294906635 852486 ##(NullConverter)  0 0 1 978 202 208 98 3 1042 1072 98 2 530 231 11 530 681 51 2160 1042 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 2160 1042 8 #isTextModified: 98 1 32 2160 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 5 0 0 0 199 1 0 0 30 0 0 0] 98 0 1264 0 27 1282 2064 231 1328 -229 1408 11 1440 51 410 800 98 17 0 416 98 2 8 1140924416 1 2608 0 866 896 0 7 0 0 0 2608 0 8 4294906781 642 8 #connect 8 '&Connect' 1 1 0 0 16 978 202 208 98 2 1042 1072 98 2 530 961 15 530 161 51 2608 1042 1152 98 1 8 '&Connect' 2608 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 7 0 0 0 48 2 0 0 32 0 0 0] 98 0 1264 0 27 1282 1328 -179 1376 161 1408 15 1440 51 410 8 ##(MultilineTextEdit)  98 16 0 416 98 2 8 1143017796 1025 2976 0 866 896 0 7 0 0 0 2976 0 8 4294906635 2274 0 0 9 978 202 208 98 3 1042 1072 98 2 530 231 81 530 681 131 2976 1042 2432 98 1 2466 3 1 3 2976 1042 2512 98 1 32 2976 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 40 0 0 0 199 1 0 0 105 0 0 0] 98 0 1264 0 27 1282 2064 231 1328 -229 1408 81 1440 131 410 800 98 17 0 416 98 2 8 1140924416 1 3360 0 866 896 0 7 0 0 0 3360 0 8 4294906781 642 8 #disconnect 8 '&Disconnect' 1 1 0 0 32 978 202 208 98 2 1042 1072 98 2 530 961 165 530 161 51 3360 1042 1152 98 1 8 '&Disconnect' 3360 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 82 0 0 0 48 2 0 0 107 0 0 0] 98 0 1264 0 27 1282 1328 -179 1376 161 1408 165 1440 51 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 3728 0 0 0 7 0 0 0 3728 0 8 4294906439 2274 0 0 0 978 202 208 98 2 1042 1072 98 2 530 11 11 530 221 51 3728 1042 1152 98 1 8 'Chat to &address:' 3728 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 115 0 0 0 30 0 0 0] 98 0 1264 0 27 1282 2064 11 1376 221 1408 11 1440 51 410 3744 98 16 0 416 98 2 8 1140850944 1 4064 0 0 0 7 0 0 0 4064 0 8 4294906439 2274 0 0 0 978 202 208 98 2 1042 1072 98 2 530 11 91 530 211 51 4064 1042 1152 98 1 8 '&Message:' 4064 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 45 0 0 0 110 0 0 0 70 0 0 0] 98 0 1264 0 27 1282 2064 11 1376 211 1408 91 1440 51 234 256 98 4 2160 8 'calleeAddress' 2976 8 'outgoingMessage' 590342 ##(Rectangle)  530 1 1 530 1 1 978 202 208 98 2 1042 1072 98 2 530 11 11 530 1141 341 416 1042 8 #contextMenu: 98 1 576 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 63 2 0 0 175 0 0 0] 98 8 2160 2608 2976 784 3360 3728 4064 1472 1264 0 27 )!

sampleDescription
	"Private - Answer the description of the receiver to be used in the samples folder."

	^'Avatar Chat'!

uninitialize
	"Private - Un-register the system folder icon for the receiver.
		self uninitialize
	"

	Smalltalk developmentSystem 
		removeSystemFolderIconNamed: self sampleDescription! !
!AvatarChat class categoriesFor: #initialize!initializing!private! !
!AvatarChat class categoriesFor: #resource_Minimal_view!public!resources-views! !
!AvatarChat class categoriesFor: #sampleDescription!constants!development!private! !
!AvatarChat class categoriesFor: #uninitialize!initializing!must strip!private! !

