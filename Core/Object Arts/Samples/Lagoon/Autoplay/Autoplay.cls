"Filed out from Dolphin Smalltalk X6.2"!

Shell subclass: #Autoplay
	instanceVariableNames: 'browser navigating pageExtent homePage'
	classVariableNames: ''
	poolDictionaries: 'SHDocVwConstants'
	classInstanceVariableNames: ''!
Autoplay guid: (GUID fromString: '{6D08642B-1E71-49FE-9C29-C044A21D63D0}')!
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
	browser := self add: URLPresenter new name: 'browser'.
!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 328198 ##(Point)  971 1009 517 0 0 0 416 788230 ##(BorderLayout)  1 1 0 0 0 0 410 8 ##(AXValueConvertingControlSite)  98 26 0 416 98 2 8 1140850688 1 592 721990 2 ##(ValueHolder)  0 32 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #= 98 0 738 8 #hash 98 0 0 482 512 0 5 0 0 0 592 0 81920801 8 'Shell.Explorer' 787462 ##(IWebBrowser2)  0 0 0 0 918022 ##(IDolphinAxHost)  0 0 722438 ##(AXEventSink)  234 240 98 66 205 8 #StatusTextChange: 209 8 #DownloadComplete 211 8 #CommandStateChange:Enable: 213 8 #DownloadBegin 217 8 #ProgressChange:ProgressMax: 501 8 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 503 8 #NewWindow2:Cancel: 505 8 #NavigateComplete2:URL: 225 8 #PropertyChange: 227 8 #TitleChange: 507 8 #OnQuit 509 8 #OnVisible: 511 8 #OnToolBar: 513 8 #OnMenuBar: 519 8 #DocumentComplete:URL: 515 8 #OnStatusBar: 517 8 #OnFullScreen: 521 8 #OnTheaterMode: 525 8 #WindowSetResizable: 529 8 #WindowSetLeft: 531 8 #WindowSetTop: 533 8 #WindowSetWidth: 535 8 #WindowSetHeight: 527 8 #WindowClosing:Cancel: 537 8 #ClientToHostWindow:CY: 539 8 #SetSecureLockIcon: 541 8 #FileDownload: 543 8 #NavigateError:URL:Frame:StatusCode:Cancel: 451 8 #PrintTemplateInstantiation: 453 8 #PrintTemplateTeardown: 455 8 #UpdatePageStatus:nPage:fDone: 545 8 #PrivacyImpactedStateChange: 547 8 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 592 1049094 ##(IConnectionPoint)  0 0 3 1378630 1 ##(TKindDispatchAnalyzer)  590598 ##(ITypeInfo)  0 0 525062 ##(TYPEATTR)  0 1616 1584 0 1378630 2 ##(AXTypeLibraryAnalyzer)  590342 ##(ITypeLib2)  0 0 257 524550 ##(TLIBATTR)  8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' 8 #SHDocVwLib 8 #SHDocVwConstants 234 240 98 2 8 #GUID 1872 0 0 262198 ##(GUID)  16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 23 0 0 0 1 3787 234 240 98 0 1508358 ##(IAxWinAmbientDispatchEx)  0 0 0 0 524806 ##(IUnknown)  0 0 0 0 0 852486 ##(NullConverter)  0 0 983302 ##(MessageSequence)  202 208 98 4 721670 ##(MessageSend)  8 #createAt:extent: 98 2 530 1 1 530 959 945 592 2114 8 #restoreAmbientProperties 1936 592 2114 8 #docHostFlags: 98 1 9 592 2114 8 #controlBinaryStoreBytes: 98 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 130 49 0 0 200 48 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 592 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 223 1 0 0 216 1 0 0] 98 0 530 193 193 0 27 234 256 98 2 592 8 'browser' 0 0 0 0 0 1 0 0 0 0 1 0 0 2050 202 208 98 3 2114 2144 98 2 530 353 465 530 971 1009 416 2114 8 #text: 98 1 8 'This caption will be set to the title the loaded HTML page' 416 2114 8 #menuBar: 98 1 0 416 2354 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 176 0 0 0 232 0 0 0 149 2 0 0 224 2 0 0] 98 1 592 2416 0 27 )! !
!Autoplay class categoriesFor: #icon!constants!public! !
!Autoplay class categoriesFor: #resource_Default_view!public!resources-views! !

