"Filed out from Dolphin Smalltalk X6.2"!

Shell subclass: #WebBrowserShell
	instanceVariableNames: 'address browser statusModel commandStates'
	classVariableNames: ''
	poolDictionaries: 'SHDocVwConstants'
	classInstanceVariableNames: ''!
WebBrowserShell guid: (GUID fromString: '{840F8A35-998B-4346-AB86-95DB62F03A47}')!
WebBrowserShell comment: 'WebBrowserShell is a simple web browser application built around the Microsoft Web Browser control (the basis of Internet Explorer).

This sample does wire up to a few events from the brower control (mainly for illustrative purposes), but if you want to learn more about what events are fired and when it is recommended that you monitor the behaviour of the control using the ''Active-X Control Browser'' tool.

Try:
	WebBrowserShell show

Instance Variables:
	address		<TextPresenter>. The text URL being browsed/to be browsed.
	browser		<URLPresenter>. Presenter behind the explorer view.
	statusModel	<ValueHolder>. Model to hold status text updated by events from the explorer control.

'!
!WebBrowserShell categoriesForClass!Samples! !
!WebBrowserShell methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	statusModel := ValueHolder new.
	browser := self add: URLPresenter new name: 'browser'.
	address := self add: TextPresenter new name: 'address'.
	"Share the model to simplify matters, although independent models would allow more control."
	address model: browser model.
!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.

	address
		when: #valueChanged send: #invalidateUserInterface to: self.

	"Automatically update the caption and status bar text on receipt of events from the browser control"
	browser 
		when: #StatusTextChange: send: #value: to: statusModel;
		when: #TitleChange: send: #caption: to: self.

	"Wire up a few of the events for illustrative purposes - we don't do anything with most of them at present"
	browser
		when: #NavigateComplete2:URL: send: #OnNavigateComplete2:URL: to: self;
		when: #DocumentComplete:URL: send: #OnDocumentComplete:URL: to: self;
		when: #CommandStateChange:Enable: send: #OnCommandStateChange:Enable: to: self;
		when: #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:
			send: #OnBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:
			to: self;
		when: #NewWindow2:Cancel: send: #OnNewWindow2:Cancel: to: self
!

historyBack: delta
	"Go back the number of positions in the history specified by the <integer> argument."

	browser view controlDispatch GoBack!

historyForward: delta
	"Go forward the number of positions in the history specified by the <integer> argument."

	browser view controlDispatch GoForward!

home
	"Go to the Home page"

	self openUrl: self homePage!

homePage
	"Private - Answer the home page to use for the receiver"

	^SessionManager current objectArtsUrl!

initialize
	"Private - Initialize the receiver's instance variables."

	NTLibrary isWine ifTrue: [self error: 'Internet Explorer ActiveX component not available in Wine'].
	super initialize.
	commandStates := Array with: false with: false!

navigate
	"Navigate to the address in the address bar.
	We want to by-pass the normal check for the same value here."

	browser model setValue: address value; notifyChanged!

OnBeforeNavigate2: anIDispatch 
		URL: urlVARIANT 		"Can be a URL or a PIDL"
		Flags: flagsVARIANT 
		TargetFrameName: targetVARIANT
		PostData: postDataVARIANT
		Headers: headersVARIANT
		Cancel: aBooleanValue
	"Pre-navigation event fired by the control. Can be used to take control of what happens when
	a link is clicked. Be aware that <IDispatch> argument is not necessarily on a WebBrowser
	object, since this event is also fired for frames. Note also that programmatic navigations
	also fire this event, so if you intercept and redirect, this event will be fired again."

	| url |
	url := urlVARIANT value.
	"Set the cancel value holder to true in order to suppress navigation,
	 can then take some other action. Because we have chose to share
	 the model between address bar and URL presenter, we cancel 
	 all navigation requests to new URLs, and instead initiate them
	 by changing the shared URL value model, thus keeping browser
	 and address bar in sync."
	browser model value = url ifFalse: [
		aBooleanValue value: true.
		browser model value: url]!

OnCommandStateChange: anInteger Enable: aBoolean
	"Event fired by the control when the enablement of a command changes.
	This tells us whether the forward/back buttons need to be enabled, and also
	whether any other toolbar buttons enablement state may have changed."

	(anInteger between: 1 and: commandStates size) ifTrue: [
		commandStates at: anInteger put: aBoolean].
	self invalidateUserInterface.
		!

OnDocumentComplete: anIDispatch URL: urlOrPIDL
	"Event fired by the control when the document download and display has completed."

!

OnNavigateComplete2: anIDispatch URL: urlOrPIDL
	"Event fired by the control when the document being navigated to becomes visible and enters the navigation
	stack. If we wanted to maintain a history list, this would be the place to do so."

	"If we had independent models for the address bar and URLPresenter, this would be the place to update
	 the address bar model."

!

OnNewWindow2: ppDispOut Cancel: aBooleanValue
	"Event fired by the control when about to open a new window.
	N.B. Both parameters are output parameters. See MSDN."

	!

onViewOpened
	"Received when the receiver's view is been connected. "

	| statusItem |
	super onViewOpened.

	statusItem := self view viewNamed: 'status' ifNone: [].
	statusItem model: statusModel.
!

openUrl: url
	"Browse the specified URL."

	browser model value: url asString!

queryCommand: query
	"Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |
	cmd := query commandSymbol.

	cmd == #historyBack: ifTrue: [
		query isEnabled: (commandStates at: CSC_NAVIGATEBACK).
		^true].

	cmd == #historyForward: ifTrue: [
		query isEnabled: (commandStates at: CSC_NAVIGATEFORWARD).
		^true].

	^super queryCommand: query.
! !
!WebBrowserShell categoriesFor: #createComponents!initializing!public! !
!WebBrowserShell categoriesFor: #createSchematicWiring!initializing!public! !
!WebBrowserShell categoriesFor: #historyBack:!commands!public! !
!WebBrowserShell categoriesFor: #historyForward:!commands!public! !
!WebBrowserShell categoriesFor: #home!commands!public! !
!WebBrowserShell categoriesFor: #homePage!commands!private! !
!WebBrowserShell categoriesFor: #initialize!initializing!private! !
!WebBrowserShell categoriesFor: #navigate!commands!public! !
!WebBrowserShell categoriesFor: #OnBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:!event handling!public! !
!WebBrowserShell categoriesFor: #OnCommandStateChange:Enable:!event handling!public! !
!WebBrowserShell categoriesFor: #OnDocumentComplete:URL:!event handling!public! !
!WebBrowserShell categoriesFor: #OnNavigateComplete2:URL:!event handling!public! !
!WebBrowserShell categoriesFor: #OnNewWindow2:Cancel:!event handling!public! !
!WebBrowserShell categoriesFor: #onViewOpened!event handling!public! !
!WebBrowserShell categoriesFor: #openUrl:!operations!public! !
!WebBrowserShell categoriesFor: #queryCommand:!commands!public! !

!WebBrowserShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Simple Web Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 14 in: ShellLibrary default!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10621!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 517 0 0 0 416 788230 ##(BorderLayout)  1 1 410 8 ##(Toolbar)  98 25 0 416 98 2 8 1140851468 131137 560 0 482 512 0 5 0 0 0 560 482 512 8 4294904585 234 256 98 4 410 8 ##(TextEdit)  98 16 0 560 98 2 8 1140916352 1025 720 0 482 512 0 5 265030 4 ##(Menu)  0 16 98 2 984134 2 ##(CommandMenuItem)  1 1180998 4 ##(CommandDescription)  8 #navigate 8 '&Go' 1 1 0 0 0 866 2097153 898 8 #accept 8 '&Accept' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 720 0 8 4294906635 852486 ##(NullConverter)  0 0 1 983302 ##(MessageSequence)  202 208 98 4 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  297 11 1218 743 41 720 1154 8 #contextMenu: 98 1 832 720 1154 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 720 1154 8 #isTextModified: 98 1 32 720 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 7 2 0 0 25 0 0 0] 98 0 1218 193 193 0 27 8 'address' 410 8 ##(PushButton)  98 17 0 560 98 2 8 1140924416 1 1536 0 0 1218 97 41 517 0 0 0 1536 0 8 4294906781 898 928 8 '&Go' 1 1 0 0 16 1090 202 208 98 2 1154 1184 98 2 1218 1055 7 1218 121 49 1536 1154 8 #text: 98 1 8 '&Go' 1536 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 2 0 0 3 0 0 0 75 2 0 0 27 0 0 0] 98 0 1504 0 27 8 'go' 234 256 98 0 98 0 234 240 1936 590342 ##(Rectangle)  1218 5 3 1218 5 5 1 0 1218 33 31 1218 45 45 0 852230 ##(FramingLayout)  234 240 98 10 1536 1181766 2 ##(FramingConstraints)  1114638 ##(STBSingletonProxy)  8 ##(FramingCalculation)  8 #fixedViewRight -119 2186 2208 8 #fixedParentRight -7 2186 2208 8 #fixedPreviousTop -3 2186 2208 8 #fixedViewTop 49 410 8 ##(StaticRectangle)  98 14 0 560 98 2 8 1140916498 1 2336 0 482 512 0 5 0 0 0 2336 0 8 4294906439 1090 202 208 98 1 1154 1184 98 2 1218 1 63 1218 1183 5 2336 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 31 0 0 0 79 2 0 0 33 0 0 0] 98 0 1504 0 27 2146 2186 2208 8 #fixedParentLeft -3 2240 1 2186 2208 8 #fixedViewBottom -3 2186 2208 8 #fixedParentBottom 1 720 2146 2186 2208 8 #fixedPreviousRight 1 2240 -143 2272 -3 2304 41 410 8 ##(StaticText)  98 16 0 560 98 2 8 1140850944 1 2768 0 0 0 5 0 0 0 2768 0 8 4294906439 1058 0 0 0 1090 202 208 98 2 1154 1184 98 2 1218 187 15 1218 111 41 2768 1154 1808 98 1 8 'Address:' 2768 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 0 0 0 7 0 0 0 148 0 0 0 27 0 0 0] 98 0 1504 0 27 2146 2736 17 2186 2208 8 #fixedViewLeft 111 2272 5 2304 41 410 576 98 25 0 560 98 2 8 1140853580 131137 3136 0 482 512 0 517 0 0 0 3136 482 512 8 4294904585 234 256 1936 234 256 98 6 38347 853766 ##(ToolbarButton)  38347 0 3136 1 898 8 #home 8 'Home page' 1 1 0 395334 3 ##(Bitmap)  0 16 2186 8 ##(ImageRelativeFileLocator)  8 #current 8 'Tools.bmp' 2032142 ##(STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 71 1218 1825 33 73 38349 1246982 ##(ToolbarSystemButton)  38349 0 3136 1 898 459270 ##(Message)  8 #historyBack: 98 1 3 8 'Back' 1 1 0 17 1 38351 3538 38351 0 3136 1 898 3586 8 #historyForward: 98 1 3 8 'Forward' 1 1 0 17 3 98 4 3312 3552 3664 1050118 ##(ToolbarSeparator)  0 0 3136 3 0 1 234 240 98 4 3392 1 17 115 0 1 0 1218 33 33 1218 45 45 0 0 1090 202 208 98 2 1154 1184 98 2 1218 11 11 1218 161 51 3136 1154 8 #updateSize 1936 3136 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 85 0 0 0 30 0 0 0] 98 0 1504 0 27 2146 2624 7 3104 161 2186 2208 8 #fixedParentTop 9 2304 51 1090 202 208 98 2 1154 1184 98 2 1218 1 1 1218 1187 71 560 1154 4000 1936 560 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 81 2 0 0 35 0 0 0] 98 5 3136 2768 720 1536 2336 1504 0 27 410 8 ##(StatusBar)  98 18 0 416 98 2 8 1140850956 1 4288 0 482 512 0 5 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 84 105 109 101 115 32 78 101 119 32 82 111 109 97 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1218 193 193 0 4288 0 8 4294904581 234 256 98 2 853766 ##(StatusBarItem)  1 -1 4288 0 8 ##(BasicListAbstract)  0 2186 8 ##(IconImageManager)  3440 8 'status' 98 1 4544 1115142 ##(StatusBarNullItem)  513 1 4288 0 0 1090 202 208 98 1 1154 1184 98 2 1218 1 967 1218 1187 43 4288 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 227 1 0 0 81 2 0 0 248 1 0 0] 98 0 1504 0 27 0 0 410 8 ##(AXValueConvertingControlSite)  98 26 0 416 98 2 8 1140850688 1 4832 721990 2 ##(ValueHolder)  0 32 1376774 ##(PluggableSearchPolicy)  3586 8 #= 98 0 3586 8 #hash 98 0 0 482 512 0 5 0 0 0 4832 0 81920801 8 'Shell.Explorer' 787462 ##(IWebBrowser2)  0 0 1444166 1 ##(TKindInterfaceAnalyzer)  590598 ##(ITypeInfo)  0 0 525062 ##(TYPEATTR)  0 5184 5152 0 1378630 2 ##(AXTypeLibraryAnalyzer)  590342 ##(ITypeLib2)  0 0 257 524550 ##(TLIBATTR)  8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' 8 #SHDocVwLib 8 #SHDocVwConstants 234 240 98 2 8 #GUID 5440 0 0 0 11 0 0 0 0 918022 ##(IDolphinAxHost)  0 0 722438 ##(AXEventSink)  234 240 98 66 205 8 #StatusTextChange: 209 8 #DownloadComplete 211 8 #CommandStateChange:Enable: 213 8 #DownloadBegin 217 8 #ProgressChange:ProgressMax: 501 8 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 503 8 #NewWindow2:Cancel: 505 8 #NavigateComplete2:URL: 225 8 #PropertyChange: 227 8 #TitleChange: 507 8 #OnQuit 509 8 #OnVisible: 511 8 #OnToolBar: 513 8 #OnMenuBar: 519 8 #DocumentComplete:URL: 515 8 #OnStatusBar: 517 8 #OnFullScreen: 521 8 #OnTheaterMode: 525 8 #WindowSetResizable: 529 8 #WindowSetLeft: 531 8 #WindowSetTop: 533 8 #WindowSetWidth: 535 8 #WindowSetHeight: 527 8 #WindowClosing:Cancel: 537 8 #ClientToHostWindow:CY: 539 8 #SetSecureLockIcon: 541 8 #FileDownload: 543 8 #NavigateError:URL:Frame:StatusCode:Cancel: 451 8 #PrintTemplateInstantiation: 453 8 #PrintTemplateTeardown: 455 8 #UpdatePageStatus:nPage:fDone: 545 8 #PrivacyImpactedStateChange: 547 8 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 4832 1049094 ##(IConnectionPoint)  0 0 3 1378630 1 ##(TKindDispatchAnalyzer)  5170 0 0 5202 0 6144 6128 0 5234 5266 0 0 257 5298 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' 5376 5392 234 240 98 2 5440 5440 0 0 262198 ##(GUID)  16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 23 0 0 0 1 3787 234 240 1936 1508358 ##(IAxWinAmbientDispatchEx)  0 0 0 0 524806 ##(IUnknown)  0 0 0 0 0 1058 0 0 1090 202 208 98 4 1154 1184 98 2 1218 1 71 1218 1187 897 4832 1154 8 #restoreAmbientProperties 1936 4832 1154 8 #docHostFlags: 98 1 9 4832 1154 8 #controlBinaryStoreBytes: 98 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 74 61 0 0 77 46 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 4832 1442 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 35 0 0 0 81 2 0 0 227 1 0 0] 98 0 1504 0 27 234 256 98 4 4288 8 'progress' 4832 8 'browser' 0 0 0 0 0 16145 0 0 0 0 1 0 0 1090 202 208 98 2 1154 1184 98 2 1218 353 465 1218 2401 1653 416 1154 8 #menuBar: 98 1 0 416 1442 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 176 0 0 0 232 0 0 0 96 5 0 0 34 4 0 0] 98 3 4288 560 4832 1504 0 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self displayString! !
!WebBrowserShell class categoriesFor: #displayOn:!printing!public! !
!WebBrowserShell class categoriesFor: #icon!constants!public! !
!WebBrowserShell class categoriesFor: #initialize!development!initializing!private! !
!WebBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!WebBrowserShell class categoriesFor: #shutdownOnExit!public!testing! !
!WebBrowserShell class categoriesFor: #uninitialize!development!initializing!private! !

