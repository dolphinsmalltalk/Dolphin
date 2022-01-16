"Filed out from Dolphin Smalltalk"!

UI.Shell subclass: #'OS.COM.Examples.WebBrowserShell'
	instanceVariableNames: 'address browser statusModel commandStates'
	classVariableNames: ''
	imports: #(#{SHDocVw private} #{UI})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Examples.WebBrowserShell guid: (Core.GUID fromString: '{840f8a35-998b-4346-ab86-95db62f03a47}')!
OS.COM.Examples.WebBrowserShell comment: 'WebBrowserShell is a simple web browser application built around the Microsoft Web Browser control (the basis of Internet Explorer).

This sample does wire up to a few events from the brower control (mainly for illustrative purposes), but if you want to learn more about what events are fired and when it is recommended that you monitor the behaviour of the control using the ''Active-X Control Browser'' tool.

Try:
	WebBrowserShell show

Instance Variables:
	address		<TextPresenter>. The text URL being browsed/to be browsed.
	browser		<URLPresenter>. Presenter behind the explorer view.
	statusModel	<ValueHolder>. Model to hold status text updated by events from the explorer control.

'!
!OS.COM.Examples.WebBrowserShell categoriesForClass!Samples! !
!OS.COM.Examples.WebBrowserShell methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	statusModel := ValueHolder new.
	browser := self add: URLPresenter new name: 'browser'.
	address := self add: TextPresenter new name: 'address'.
	"Share the model to simplify matters, although independent models would allow more control."
	address model: browser model!

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
	statusItem := self view viewNamed: 'status' ifNone: nil.
	statusItem model: statusModel!

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
!OS.COM.Examples.WebBrowserShell categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
historyBack:!commands!public! !
historyForward:!commands!public! !
home!commands!public! !
homePage!commands!private! !
initialize!initializing!private! !
navigate!commands!public! !
OnBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:!event handling!public! !
OnCommandStateChange:Enable:!event handling!public! !
OnDocumentComplete:URL:!event handling!public! !
OnNavigateComplete2:URL:!event handling!public! !
OnNewWindow2:Cancel:!event handling!public! !
onViewOpened!event handling!public! !
openUrl:!operations!public! !
queryCommand:!commands!public! !
!

!OS.COM.Examples.WebBrowserShell class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Simple Web Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon
		text: $\x1F310
		fontName: 'Segoe UI Emoji'
		color: Color forestGreen)!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853516 131137 528 nil 480 nil 7 nil nil nil 528 480 8 1815075056 170 192 34 4 410 #{UI.PushButton} 34 20 nil 528 34 2 8 1140924416 1 640 nil nil 918022 #{Graphics.Point} 97 41 519 nil nil nil 640 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #navigate 8 '&Go' 1 1 nil nil true nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 706 2237 7 706 121 49 640 850 #isEnabled: 8 #(false) 640 850 #text: 34 1 8 '&Go' 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 94 4 0 0 3 0 0 0 154 4 0 0 27 0 0 0] 8 #() 706 193 193 nil 29 8 'go' 410 #{UI.TextEdit} 34 16 nil 528 34 2 8 1140916352 1025 1104 nil 480 nil 7 461638 4 #{UI.Menu} nil true 34 2 1180742 2 #{UI.CommandMenuItem} 1 754 #navigate 8 '&Go' 1 1 nil nil nil 1218 2097153 754 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1104 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 802 34 2 850 #createAt:extent: 34 2 706 297 11 706 1925 41 1104 850 #contextMenu: 34 1 1184 1104 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 148 0 0 0 5 0 0 0 86 4 0 0 25 0 0 0] 8 #() 1072 nil 27 8 'address' nil nil nil 170 192 8 #() 8 #() nil 1180166 #{Graphics.Rectangle} 706 5 3 706 5 5 1 nil 706 33 31 706 45 45 nil 1048838 #{UI.FramingLayout} 170 176 34 10 640 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedViewRight -119 1826 #fixedParentRight -7 1826 #fixedPreviousTop -3 1826 #fixedViewTop 49 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1140853580 131137 1904 nil 480 nil 519 nil nil nil 1904 480 8 1815075056 170 192 1600 nil nil nil 170 192 34 6 14169 1443398 1 #{UI.ToolbarBitmapButton} 1904 1 754 #home 8 'Home page' 1 1 nil 14169 984646 4 #{Graphics.Bitmap} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'Tools.bmp' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 73733 nil nil 5 706 1857 33 73 14173 1443398 1 #{UI.ToolbarSystemButton} 1904 1 754 786950 #{Core.Message} #historyForward: 8 #(1) 8 'Forward' 1 1 nil 14173 17 3 14171 2242 1904 1 754 2290 #historyBack: 8 #(1) 8 'Back' 1 1 nil 14171 17 1 34 4 2048 2352 2256 1245766 1 #{UI.ToolbarSeparator} 1904 1 nil nil 1 nil 706 33 33 706 45 45 nil nil 802 34 1 850 #createAt:extent: 34 2 706 11 11 706 161 51 1904 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 85 0 0 0 30 0 0 0] 8 #() 1072 nil 29 1794 1826 #fixedParentLeft 7 1826 #fixedViewLeft 161 1826 #fixedParentTop 9 1888 51 410 #{UI.StaticText} 34 16 nil 528 34 2 8 1140850944 1 2720 nil nil nil 7 nil nil nil 2720 nil 8 1815137184 1362 nil nil nil 802 34 2 850 #createAt:extent: 34 2 706 187 15 706 111 41 2720 850 #text: 34 1 8 'Address:' 2720 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 0 0 0 7 0 0 0 148 0 0 0 27 0 0 0] 8 #() 1072 nil 27 1794 1826 #fixedPreviousRight 17 2688 111 1872 5 1888 41 410 #{UI.StaticRectangle} 34 14 nil 528 34 2 8 1140916498 1 3040 nil 480 nil 7 nil nil nil 3040 nil 8 1815137184 802 34 1 850 #createAt:extent: 34 2 706 1 63 706 2365 5 3040 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 31 0 0 0 158 4 0 0 33 0 0 0] 8 #() 1072 nil 27 1794 2672 -3 1856 1 1826 #fixedViewBottom -3 1826 #fixedParentBottom 1 1104 1794 3024 1 1856 -143 1872 -3 1888 41 802 34 1 850 #createAt:extent: 34 2 706 1 1 706 2369 71 528 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 35 0 0 0] 34 5 1904 2720 1104 640 3040 1072 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 3472 nil 480 nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 84 105 109 101 115 32 78 101 119 32 82 111 109 97 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 706 193 193 nil 3472 nil 8 1814628368 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 3472 nil 2290 #displayString 1600 nil nil 8 'status' nil nil nil 34 1 3696 1311814 1 #{UI.StatusBarNullItem} 8705 1 3472 nil nil 802 34 1 850 #createAt:extent: 34 2 706 1 1533 706 2369 43 3472 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 8 #() 1072 nil 29 nil nil 410 #{UI.AXValueConvertingControlSite} 34 26 nil 416 34 2 8 1140850688 1 3936 918598 2 #{UI.ValueHolder} nil false 1835526 #{Kernel.PluggableSearchPolicy} 2290 #= 8 #() 2290 #hash 8 #() nil 480 nil 7 nil nil nil 3936 nil 537202215 8 'Shell.Explorer' 1311750 #{SHDocVw.IWebBrowser2} nil nil 1902918 1 #{OS.COM.TKindInterfaceAnalyzer} 1114886 #{OS.COM.ITypeInfo2} nil nil 983814 #{OS.COM.TYPEATTR} nil 4192 4224 nil nil 1706566 3 #{OS.COM.TypeLibraryAnalyzer} 1049094 #{OS.COM.ITypeLib2} nil nil 257 1442886 2 #{Kernel.VariableBinding} #SHDocVw #{SHDocVw} #{Root} 1 983302 #{OS.COM.TLIBATTR} 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 #{SHDocVw} 8 'Internet Explorer' nil nil 170 176 8 #(#GUID #GUID) nil nil 11 nil nil nil nil 1114630 #{UI.IDolphinAxHost} nil nil 1050118 #{OS.COM.EventSink} 170 176 8 #(268 #ClientToHostWindow:CY: 227 #UpdatePageStatus:nPage:fDone: 106 #DownloadBegin 253 #OnQuit 266 #WindowSetWidth: 225 #PrintTemplateInstantiation: 104 #DownloadComplete 251 #NewWindow2:Cancel: 264 #WindowSetLeft: 290 #BeforeScriptExecute: 102 #StatusTextChange: 262 #WindowSetResizable: 288 #WebWorkerStarted:bstrWorkerLabel: 113 #TitleChange: 260 #OnTheaterMode: 273 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 286 #RedirectXDomainBlocked:StartURL:RedirectURL:Frame:StatusCode: 258 #OnFullScreen: 271 #NavigateError:URL:Frame:StatusCode:Cancel: 284 #NewProcess:pWB2:Cancel: 256 #OnMenuBar: 269 #SetSecureLockIcon: 282 #SetPhishingFilterStatus: 254 #OnVisible: 267 #WindowSetHeight: 226 #PrintTemplateTeardown: 105 #CommandStateChange:Enable: 252 #NavigateComplete2:URL: 265 #WindowSetTop: 250 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 263 #WindowClosing:Cancel: 289 #WebWorkerFinsihed: 112 #PropertyChange: 259 #DocumentComplete:URL: 272 #PrivacyImpactedStateChange: 285 #ThirdPartyUrlBlocked:dwCount: 257 #OnStatusBar: 270 #FileDownload:Cancel: 283 #WindowStateChanged:dwValidFlagsMask: 108 #ProgressChange:ProgressMax: 255 #OnToolBar:) 3936 1507846 #{OS.COM.IConnectionPoint} nil nil 3 1837382 1 #{OS.COM.TKindDispatchAnalyzer} 4210 nil nil 4242 nil 4624 4640 nil nil 4288 589878 #{Core.GUID} 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 25 nil nil nil 1 3787 170 176 1600 1704966 #{UI.IAxWinAmbientDispatchEx} nil nil nil nil 983558 #{OS.COM.IUnknown} nil nil nil nil nil 1362 nil nil 802 34 4 850 #createAt:extent: 34 2 706 1 71 706 2369 1463 3936 850 #restoreAmbientProperties 1600 3936 850 #docHostFlags: 8 #(4) 3936 850 #controlBinaryStoreBytes: 34 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 95 122 0 0 141 75 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 3936 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 35 0 0 0 160 4 0 0 254 2 0 0] 8 #() 1072 nil 27 170 192 34 4 3936 8 'browser' 3472 8 'progress' nil nil nil nil nil 43709 nil nil nil nil 1 nil nil 802 34 1 850 #createAt:extent: 34 2 706 12287 21 706 2401 1653 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 175 28 0 0 68 3 0 0] 34 3 3472 528 3936 1072 nil 27)!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!OS.COM.Examples.WebBrowserShell class categoriesForMethods!
displayOn:!printing!public! !
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

