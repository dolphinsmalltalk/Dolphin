"Filed out from Dolphin Smalltalk X6.2"!

DolphinSplash subclass: #CommunityEditionSplash
	instanceVariableNames: 'cursor canExit index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommunityEditionSplash guid: (GUID fromString: '{B01E731C-6994-4402-B17A-C33F8334844F}')!
CommunityEditionSplash comment: ''!
!CommunityEditionSplash categoriesForClass!Development! !
!CommunityEditionSplash methodsFor!

buttonClick
	(Sound fromFile: (RegKey userRoot at: self navigatingClickRegKey ifAbsent: [^self]) value) woof!

continueButtonContains: aPoint 
	^canExit and: [self continueButtonRect containsPoint: aPoint]!

continueButtonRect
	^559 @ 85 extent: 25 @ 25!

cursor
	^cursor!

cursor: aCursorOrNil 
	cursor := aCursorOrNil!

defaultSplashDelay
	"Answer the default delay that a splash should be displayed for"

	^Delay forMilliseconds: 60000!

donateUrl
	^SessionManager current objectArtsUrl , '/content/other/donate.html'!

drawInfoTextOn: canvas 
	| version copyright |
	version := VMLibrary default versionInfo.
	copyright := version legalCopyright copyReplaceAll: '. ' with: String lineDelimiter.
	canvas
		forecolor: Color white;
		setTextAlign: TA_LEFT | TA_BASELINE;
		backgroundMode: TRANSPARENT;
		font: (Font name: 'Arial' pixelSize: 12) beBold;
		text: SessionManager current versionString at: 20 @ 349;
		font: (Font name: 'Arial' pixelSize: 10);
		text: copyright lines first at: 20 @ 361;
		text: copyright lines second at: 20 @ 372!

goProButtonContains: aPoint 
	^index=2 and: [self goProButtonRect containsPoint: aPoint]!

goProButtonRect
	^522 @ 85 extent: 25 @ 25!

heartButtonContains: aPoint 
	^index=1 and: [self heartButtonRect containsPoint: aPoint]!

heartButtonRect
	^522 @ 85 extent: 25 @ 25!

initialize
	| olePictureClass splashName |
	super initialize.
	canExit := false.
	olePictureClass := Smalltalk at: #OLEPicture.
	splashName := self splashName.
	self 
		bitmap: (olePictureClass fromFile: (splashName expandMacrosWith: 'a')
				usingLocator: FileLocator installRelative) asDIBSection
		finalBitmap: (olePictureClass fromFile: (splashName expandMacrosWith: 'b')
				usingLocator: FileLocator installRelative) asDIBSection!

navigatingClickRegKey
	^'AppEvents\Schemes\Apps\Explorer\Navigating\.Current'!

onLeftButtonPressed: aMouseEvent 
	"Private - Splash shells go away when clicked"

	(self continueButtonContains: aMouseEvent position) 
		ifTrue: 
			[self buttonClick.
			self close].
	(self heartButtonContains: aMouseEvent position) 
		ifTrue: 
			[self buttonClick.
			self
				showDonateUrl;
				close].
	(self goProButtonContains: aMouseEvent position) 
		ifTrue: 
			[self buttonClick.
			self
				showMyDolphinUrl;
				close].
	^0!

onMouseMoved: aMouseEvent 
	self 
		cursor: ((self heartButtonContains: aMouseEvent position) 
				| (self continueButtonContains: aMouseEvent position)
					| (self goProButtonContains: aMouseEvent position) ifTrue: [Cursor hand]).
	^super onMouseMoved: aMouseEvent!

renderFade: percent 
	super renderFade: percent.
	canExit := percent >= 99!

showDonateUrl
	Cursor wait showWhile: [SmalltalkSystem current openUrl: self donateUrl]!

showMyDolphinUrl
	Cursor wait showWhile: [SmalltalkSystem current myDolphinAccount]!

splashName
	index := ((Random new next * 100) truncated % 3)+1.
	^'Resources\DCESplash' , index displayString , '<1d>.jpg'! !
!CommunityEditionSplash categoriesFor: #buttonClick!public! !
!CommunityEditionSplash categoriesFor: #continueButtonContains:!helpers!private! !
!CommunityEditionSplash categoriesFor: #continueButtonRect!helpers!private! !
!CommunityEditionSplash categoriesFor: #cursor!public! !
!CommunityEditionSplash categoriesFor: #cursor:!private! !
!CommunityEditionSplash categoriesFor: #defaultSplashDelay!constants!public! !
!CommunityEditionSplash categoriesFor: #donateUrl!private! !
!CommunityEditionSplash categoriesFor: #drawInfoTextOn:!accessing!initializing!public! !
!CommunityEditionSplash categoriesFor: #goProButtonContains:!helpers!private! !
!CommunityEditionSplash categoriesFor: #goProButtonRect!helpers!private! !
!CommunityEditionSplash categoriesFor: #heartButtonContains:!helpers!private! !
!CommunityEditionSplash categoriesFor: #heartButtonRect!helpers!private! !
!CommunityEditionSplash categoriesFor: #initialize!private! !
!CommunityEditionSplash categoriesFor: #navigatingClickRegKey!constants!private! !
!CommunityEditionSplash categoriesFor: #onLeftButtonPressed:!event handling!private! !
!CommunityEditionSplash categoriesFor: #onMouseMoved:!event handling!private! !
!CommunityEditionSplash categoriesFor: #renderFade:!displaying!private! !
!CommunityEditionSplash categoriesFor: #showDonateUrl!private! !
!CommunityEditionSplash categoriesFor: #showMyDolphinUrl!private! !
!CommunityEditionSplash categoriesFor: #splashName!private! !

!CommunityEditionSplash class methodsFor!

new
	"Shows an instance of the receiver which is the dolphin logo

	self new showTimed
	"

	^self basicNew initialize
! !
!CommunityEditionSplash class categoriesFor: #new!instance creation!public! !

