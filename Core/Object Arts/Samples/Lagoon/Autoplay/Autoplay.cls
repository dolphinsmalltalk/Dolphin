"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #Autoplay
	instanceVariableNames: 'browser navigating pageExtent homePage'
	classVariableNames: ''
	imports: #(#{SHDocVw private})
	classInstanceVariableNames: ''
	classConstants: {}!
Autoplay guid: (Core.GUID fromString: '{6d08642b-1e71-49fe-9c29-c044a21d63d0}')!
Autoplay comment: 'Autoplay is a <topShell> sample application which hosts the Microsoft Web Browser Control in order to implement an HTML based setup menu for CD-ROM auto-play. The sample demonstrates how to intercept clicks on the links and use them to invoke external programs (in this case using ShellExecute()).

One of the trickiest aspects of hosting the Web Browser Control is distinguishing between programmatic navigation and navigation that results from the user clicking a link. This sample demonstrates one simple technique for doing that using a flag.

Evaluate the following to see the Autoplay package for further details.

	(Package manager packageNamed: ''Autoplay'') browse
'!
!Autoplay categoriesForClass!MVP-Presenters!Samples! !
!Autoplay methodsFor!

createComponents
	"Create the presenters contained by the receiver."

	super createComponents.
	browser := self add: URLPresenter new name: 'browser'!

createSchematicWiring
	"Create the trigger wiring for the receiver."
	
	super createSchematicWiring.

	browser
		when: #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:
			send: #OnBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: to: self;
		when: #NavigateComplete2:URL: send: #OnNavigateComplete2:URL: to: self
!

homePage
	"Answer the home page to use for the receiver"

	^homePage!

homePage: aString
	"Set the the home page to use for the receiver - treated as a path relative to the executable.
	Has no effect after the receiver has been shown."

	homePage := FileLocator imageRelative localFileSpecFor: aString!

initialize
	"Private - Initialize the receiver's instance variables."

	super initialize.
	"Browser will initially navigate to about:blank, which we treat as a programmatic navigation"
	navigating := true.
	"Defaults"
	self homePage: 'autorun.htm'.
	self pageExtent: 480@480!

OnBeforeNavigate2: anIDispatch URL: urlVARIANT Flags: flagsVARIANT TargetFrameName: targetVARIANT PostData: postDataVARIANT Headers: headersVARIANT Cancel: aBooleanValue 
	"Can be a URL or a PIDL"

	"Pre-navigation event fired by the control. Can be used to take control of what happens when
	a link is clicked. Be aware that <IDispatch> argument is not necessarily on a WebBrowser
	object, since this event is also fired for frames.
	Implementation Note: We use a 'mode' flag to distinguish between programmatic navigations
	that we want to appear in this browser window, and the those resulting from the user clicking
	on links, for which we want to open further windows."

	| url |
	url := urlVARIANT value.
	navigating 
		ifTrue: [navigating := false]
		ifFalse: 
			["Set the cancel value holder to true in order to suppress navigation in this window"
			aBooleanValue value: true.
			"Defer the navigation to avoid holding up the browser thread unecessarily"
			[ShellLibrary default shellOpen: url] postToMessageQueue]!

OnNavigateComplete2: anIDispatch URL: urlOrPIDL
	"Event fired by the control when the document being navigated to becomes visible and enters the navigation
	stack. At this point we can pull the title from the document to set into the caption bar."

	self caption: anIDispatch document title
!

openUrl: url
	"Browse the specified URL, setting the navigating flag so that we know a programmatic
	navigation is under way."

	navigating := true.
	browser model value: url asString!

pageExtent
	"Answer the desired extent of the setup menu page."

	^pageExtent!

pageExtent: aPoint
	"Set the desired extent the setup menu page.
	Has no effect after the receiver has been shown."

	pageExtent := aPoint max: 100@100!

resizeToFitPage
	"Private - Resize the shell window to fit the requested page extent (allowing for window
	decoration such as the frame and caption bar) and reposition to be centred in the working
	area of the desktop."

	| maxExtent extent |
	maxExtent := View desktop workArea extent.
	extent := self view calcExtentFromClientExtent: self pageExtent.
	extent := extent min: maxExtent.
	self view 
		rectangle: ((maxExtent - extent)//2 extent: extent)
		
!

show
	"Shows the view of the receiver."

	self resizeToFitPage.
	self openUrl: self homePage.
	super show! !
!Autoplay categoriesFor: #createComponents!initializing!public! !
!Autoplay categoriesFor: #createSchematicWiring!initializing!public! !
!Autoplay categoriesFor: #homePage!commands!public! !
!Autoplay categoriesFor: #homePage:!accessing!public! !
!Autoplay categoriesFor: #initialize!initializing!private! !
!Autoplay categoriesFor: #OnBeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel:!initializing!public! !
!Autoplay categoriesFor: #OnNavigateComplete2:URL:!initializing!public! !
!Autoplay categoriesFor: #openUrl:!operations!public! !
!Autoplay categoriesFor: #pageExtent!accessing!public! !
!Autoplay categoriesFor: #pageExtent:!accessing!public! !
!Autoplay categoriesFor: #resizeToFitPage!operations!private! !
!Autoplay categoriesFor: #show!operations!public! !

!Autoplay class methodsFor!

icon
	"Answers an Icon that can be used to represent this class (use the icon from
	the host executable)."

	^Icon fromId: '!!APPLICATION' in: (KernelLibrary default getModuleHandle: nil)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13107200 65536) 416 nil 917510 ##(Graphics.Color) #default 918022 ##(Graphics.Point) 971 1009 551 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.AXValueConvertingControlSite) 34 26 nil 416 34 2 8 1140850688 1 560 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 690 #hash 8 #() nil 480 nil 7 nil nil nil 560 nil 537194055 8 'Shell.Explorer' 1311750 ##(SHDocVw.IWebBrowser2) nil nil nil nil 1114630 ##(UI.IDolphinAxHost) nil nil 1050118 ##(OS.COM.EventSink) 170 176 8 #(268 #ClientToHostWindow:CY: 227 #UpdatePageStatus:nPage:fDone: 106 #DownloadBegin 253 #OnQuit 266 #WindowSetWidth: 225 #PrintTemplateInstantiation: 104 #DownloadComplete 251 #NewWindow2:Cancel: 264 #WindowSetLeft: 290 #BeforeScriptExecute: 102 #StatusTextChange: 262 #WindowSetResizable: 288 #WebWorkerStarted:bstrWorkerLabel: 113 #TitleChange: 260 #OnTheaterMode: 273 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 286 #RedirectXDomainBlocked:StartURL:RedirectURL:Frame:StatusCode: 258 #OnFullScreen: 271 #NavigateError:URL:Frame:StatusCode:Cancel: 284 #NewProcess:pWB2:Cancel: 256 #OnMenuBar: 269 #SetSecureLockIcon: 282 #SetPhishingFilterStatus: 254 #OnVisible: 267 #WindowSetHeight: 226 #PrintTemplateTeardown: 105 #CommandStateChange:Enable: 252 #NavigateComplete2:URL: 265 #WindowSetTop: 250 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 263 #WindowClosing:Cancel: 289 #WebWorkerFinsihed: 112 #PropertyChange: 259 #DocumentComplete:URL: 272 #PrivacyImpactedStateChange: 285 #ThirdPartyUrlBlocked:dwCount: 257 #OnStatusBar: 270 #FileDownload:Cancel: 283 #WindowStateChanged:dwValidFlagsMask: 108 #ProgressChange:ProgressMax: 255 #OnToolBar:) 560 1507846 ##(OS.COM.IConnectionPoint) nil nil 3 1837382 1 ##(OS.COM.TKindDispatchAnalyzer) 1114886 ##(OS.COM.ITypeInfo2) nil nil 983814 ##(OS.COM.TYPEATTR) nil 960 992 nil nil 1706566 3 ##(OS.COM.TypeLibraryAnalyzer) 1049094 ##(OS.COM.ITypeLib2) nil nil 257 1442886 2 ##(Kernel.VariableBinding) #SHDocVw ##(SHDocVw) ##(Root) 1 983302 ##(OS.COM.TLIBATTR) 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 1508870 ##(Kernel.BindingReference) 8 'SHDocVw' 34 1 1216 nil 1 1120 6049 8 'Internet Explorer' nil nil 170 176 8 #(#GUID #GUID) nil 589878 ##(Core.GUID) 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 25 1770502 ##(OS.COM.TypeLibDocumentation) 8 'DWebBrowserEvents2' 8 'Web Browser Control events interface' 1 8 '' nil nil 1 3787 170 176 8 #() 1704966 ##(UI.IAxWinAmbientDispatchEx) nil nil nil nil 983558 ##(OS.COM.IUnknown) nil nil nil nil nil 1049094 ##(UI.NullConverter) nil nil 1310982 ##(Core.MessageSequence) 138 144 34 4 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 498 1 1 498 939 931 560 1602 #restoreAmbientProperties 1424 560 1602 #docHostFlags: 8 #(4) 560 1602 #controlBinaryStoreBytes: 34 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 121 48 0 0 15 48 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 560 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 213 1 0 0 209 1 0 0] 8 #() 498 193 193 nil 27 170 192 34 2 560 8 'browser' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1538 138 144 34 2 1602 #createAt:extent: 34 2 498 6143 21 498 971 1009 416 1602 #text: 34 1 8 'This caption will be set to the title the loaded HTML page' 416 1778 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 228 13 0 0 2 2 0 0] 34 1 560 1840 nil 27 )! !
!Autoplay class categoriesFor: #icon!constants!public! !
!Autoplay class categoriesFor: #resource_Default_view!public!resources-views! !

