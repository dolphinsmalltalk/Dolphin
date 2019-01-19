"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #WebBrowserShell
	instanceVariableNames: 'address browser statusModel commandStates'
	classVariableNames: ''
	poolDictionaries: 'SHDocVwConstants'
	classInstanceVariableNames: ''!
WebBrowserShell guid: (GUID fromString: '{840f8a35-998b-4346-ab86-95db62f03a47}')!
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

	^'http://www.object-arts.com'!

initialize
	"Private - Initialize the receiver's instance variables."

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

	^##(TextTileIcon
		text: $\x1F310
		fontName: 'Segoe UI Emoji'
		color: (ARGB named: #forestGreen))!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853516 131137 544 nil 480 nil 7 nil nil nil 544 480 8 1915204752 170 192 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 544 34 2 8 1140916352 1025 656 nil 480 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #navigate 8 '&Go' 1 1 nil nil nil 770 2097153 802 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 656 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 297 11 1074 1925 41 656 1026 #contextMenu: 34 1 736 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 86 4 0 0 25 0 0 0] 8 #() 1074 193 193 nil 27 8 'address' 410 ##(Smalltalk.PushButton) 34 20 nil 544 34 2 8 1140924416 1 1248 nil nil 1074 97 41 519 nil nil nil 1248 nil 8 1915188384 802 #navigate 8 '&Go' 1 1 nil nil true nil nil nil 962 138 144 34 3 1026 #createAt:extent: 34 2 1074 2237 7 1074 121 49 1248 1026 #isEnabled: 8 #(false) 1248 1026 #text: 34 1 8 '&Go' 1248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 94 4 0 0 3 0 0 0 154 4 0 0 27 0 0 0] 8 #() 1216 nil 29 8 'go' 170 192 8 #() 8 #() nil 590342 ##(Smalltalk.Rectangle) 1074 5 3 1074 5 5 1 nil 1074 33 31 1074 45 45 nil 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 656 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 1 1874 #fixedParentRight -143 1874 #fixedPreviousTop -3 1874 #fixedViewTop 41 410 ##(Smalltalk.StaticText) 34 16 nil 544 34 2 8 1140850944 1 1952 nil nil nil 7 nil nil nil 1952 nil 8 1915124368 930 nil nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 1074 187 15 1074 111 41 1952 1026 #text: 34 1 8 'Address:' 1952 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 0 0 0 7 0 0 0 148 0 0 0 27 0 0 0] 8 #() 1216 nil 27 1842 1888 17 1874 #fixedViewLeft 111 1920 5 1936 41 1248 1842 1874 #fixedViewRight -119 1904 -7 1920 -3 1936 49 410 ##(Smalltalk.StaticRectangle) 34 14 nil 544 34 2 8 1140916498 1 2320 nil 480 nil 7 nil nil nil 2320 nil 8 1915124368 962 138 144 34 1 1026 #createAt:extent: 34 2 1074 1 63 1074 2365 5 2320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 31 0 0 0 158 4 0 0 33 0 0 0] 8 #() 1216 nil 27 1842 1874 #fixedParentLeft -3 1904 1 1874 #fixedViewBottom -3 1874 #fixedParentBottom 1 410 ##(Smalltalk.Toolbar) 34 25 nil 544 34 2 8 1140853580 131137 2624 nil 480 nil 519 nil nil nil 2624 480 8 1915204752 170 192 1648 170 192 34 6 38641 1246790 1 ##(Smalltalk.ToolbarSystemButton) 2624 1 802 459270 ##(Smalltalk.Message) #historyBack: 8 #(1) 8 'Back' 1 1 nil 38641 17 1 38643 2754 2624 1 802 2802 #historyForward: 8 #(1) 8 'Forward' 1 1 nil 38643 17 3 38639 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 2624 1 802 #home 8 'Home page' 1 1 nil 38639 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 71 1074 1857 33 73 34 4 2960 2768 2864 1049158 1 ##(Smalltalk.ToolbarSeparator) 2624 1 nil nil 1 nil 1074 33 33 1074 45 45 nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 1074 11 11 1074 161 51 2624 1026 #updateSizePosted 1648 2624 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 85 0 0 0 30 0 0 0] 8 #() 1216 nil 27 1842 2576 7 2272 161 1874 #fixedParentTop 9 1936 51 962 138 144 34 2 1026 #createAt:extent: 34 2 1074 1 1 1074 2369 71 544 1026 #updateSizePosted 1648 544 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 35 0 0 0] 34 5 2624 1952 656 1248 2320 1216 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3616 nil 480 nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 84 105 109 101 115 32 78 101 119 32 82 111 109 97 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1074 193 193 nil 3616 nil 8 1914952576 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 3616 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'status' 34 1 3840 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3616 nil nil 962 138 144 34 1 1026 #createAt:extent: 34 2 1074 1 1533 1074 2369 43 3616 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 8 #() 1216 nil 27 nil nil 410 ##(Smalltalk.AXValueConvertingControlSite) 34 26 nil 416 34 2 8 1140850688 1 4080 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 2802 #= 8 #() 2802 #hash 8 #() nil 480 nil 7 nil nil nil 4080 nil 537161267 8 'Shell.Explorer' 787462 ##(Smalltalk.IWebBrowser2) nil nil 1444166 1 ##(Smalltalk.TKindInterfaceAnalyzer) 590598 ##(Smalltalk.ITypeInfo) nil nil 525062 ##(Smalltalk.TYPEATTR) nil 4368 4336 nil 1378630 2 ##(Smalltalk.AXTypeLibraryAnalyzer) 590342 ##(Smalltalk.ITypeLib2) nil nil 257 524550 ##(Smalltalk.TLIBATTR) 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) nil nil nil 11 nil nil nil nil 918022 ##(Smalltalk.IDolphinAxHost) nil nil 722438 ##(Smalltalk.AXEventSink) 170 176 8 #(268 #ClientToHostWindow:CY: 269 #SetSecureLockIcon: 270 #FileDownload:Cancel: 271 #NavigateError:URL:Frame:StatusCode:Cancel: 272 #PrivacyImpactedStateChange: 273 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 282 #SetPhishingFilterStatus: 283 #WindowStateChanged:dwValidFlagsMask: 284 #NewProcess:pWB2:Cancel: 285 #ThirdPartyUrlBlocked:dwCount: 286 #RedirectXDomainBlocked:StartURL:RedirectURL:Frame:StatusCode: 288 #WebWorkerStarted:bstrWorkerLabel: 289 #WebWorkerFinsihed: 290 #BeforeScriptExecute: 225 #PrintTemplateInstantiation: 226 #PrintTemplateTeardown: 227 #UpdatePageStatus:nPage:fDone: 102 #StatusTextChange: 104 #DownloadComplete 105 #CommandStateChange:Enable: 106 #DownloadBegin 108 #ProgressChange:ProgressMax: 112 #PropertyChange: 113 #TitleChange: 250 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 251 #NewWindow2:Cancel: 252 #NavigateComplete2:URL: 253 #OnQuit 254 #OnVisible: 255 #OnToolBar: 256 #OnMenuBar: 257 #OnStatusBar: 258 #OnFullScreen: 259 #DocumentComplete:URL: 260 #OnTheaterMode: 262 #WindowSetResizable: 263 #WindowClosing:Cancel: 264 #WindowSetLeft: 265 #WindowSetTop: 266 #WindowSetWidth: 267 #WindowSetHeight:) 4080 1049094 ##(Smalltalk.IConnectionPoint) nil nil 3 1378630 1 ##(Smalltalk.TKindDispatchAnalyzer) 656134 ##(Smalltalk.ITypeInfo2) nil nil 4386 nil 4736 4768 nil 4418 4450 nil nil 257 4482 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) nil nil 262198 ##(Smalltalk.GUID) 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 25 nil nil nil 1 3787 170 176 1648 1508358 ##(Smalltalk.IAxWinAmbientDispatchEx) nil nil nil nil 524806 ##(Smalltalk.IUnknown) nil nil nil nil nil 930 nil nil 962 138 144 34 4 1026 #createAt:extent: 34 2 1074 1 71 1074 2369 1463 4080 1026 #restoreAmbientProperties 1648 4080 1026 #docHostFlags: 8 #(4) 4080 1026 #controlBinaryStoreBytes: 34 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 95 122 0 0 141 75 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 4080 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 35 0 0 0 160 4 0 0 254 2 0 0] 8 #() 1216 nil 27 170 192 34 4 4080 8 'browser' 3616 8 'progress' nil nil nil nil nil 24589 nil nil nil nil 1 nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 1074 3839 21 1074 2401 1653 416 1026 #updateMenuBar 1648 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 47 12 0 0 68 3 0 0] 34 3 3616 544 4080 1216 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!WebBrowserShell class categoriesFor: #displayOn:!printing!public! !
!WebBrowserShell class categoriesFor: #icon!constants!public! !
!WebBrowserShell class categoriesFor: #initialize!development!initializing!private! !
!WebBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!WebBrowserShell class categoriesFor: #shutdownOnExit!public!testing! !

