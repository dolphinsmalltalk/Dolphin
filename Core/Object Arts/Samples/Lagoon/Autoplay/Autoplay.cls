"Filed out from Dolphin Smalltalk"!

Shell subclass: #Autoplay
	instanceVariableNames: 'browser navigating pageExtent homePage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Autoplay guid: (GUID fromString: '{6d08642b-1e71-49fe-9c29-c044a21d63d0}')!

Autoplay comment: 'Autoplay is a <topShell> sample application which hosts the Microsoft Web Browser Control in order to implement an HTML based setup menu for CD-ROM auto-play. The sample demonstrates how to intercept clicks on the links and use them to invoke external programs (in this case using ShellExecute()).

One of the trickiest aspects of hosting the Web Browser Control is distinguishing between programmatic navigation and navigation that results from the user clicking a link. This sample demonstrates one simple technique for doing that using a flag.

Evaluate the following to see the Autoplay package for further details.

	(Package manager packageNamed: ''Autoplay'') browse
'!

!Autoplay categoriesForClass!MVP-Presenters!Samples! !

!Autoplay methodsFor!

browser
	^browser!

createComponents
	"Create the presenters contained by the receiver."

	super createComponents.
	browser := self add: URLPresenter new name: 'browser'
!

createSchematicWiring
	"Create the trigger wiring for the receiver."

	super createSchematicWiring.
	browser
		when: #navigationStarting:
			send: #onNavigationStarting:
			to: self;
		when: #documentTitleChanged
			send: #onDocumentTitleChanged
			to: self!

homePage
	"Answer the home page to use for the receiver"

	^homePage!

homePage: aString
	"Set the the home page to use for the receiver - treated as a path relative to the executable.
	Has no effect after the receiver has been shown."

	homePage := FileLocator imageRelative localFileSpecFor: aString!

homePageHtml: aString
	"Set the the home page to use for the receiver"

	browser view canNavigateToStrings: true.
	homePage := aString!

initialize
	"Private - Initialize the receiver's instance variables."

	super initialize.
	navigating := true.
	"Defaults"
	self homePage: 'autorun.htm'.
	self pageExtent: 480@480!

onDocumentTitleChanged
	"Event fired by the control when the document title has changed, so update the browser caption."

	self caption: browser view documentTitle!

onNavigationStarting: anICoreWebView2NavigationStartingEventArgs
	"Pre-navigation event fired by the control when either a link is clicked, or programmatic navigation occurs."

	| url |
	url := anICoreWebView2NavigationStartingEventArgs uri.
	navigating
		ifTrue: [navigating := false]
		ifFalse: 
			["Set the cancel value to true in order to suppress navigation in the hosted browser itself as we want to open all links externally"
			anICoreWebView2NavigationStartingEventArgs cancel: true.
			"Defer the navigation to avoid holding up the browser thread unecessarily"
			[ShellLibrary default shellOpen: url] postToMessageQueue]!

openUrl: url
	"Browse the specified URL, setting the navigating flag so that we know a programmatic navigation is under way."

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
	maxExtent := self view monitor workArea extent.
	extent := self view calcExtentFromClientExtent: self pageExtent * self view scaleFactor.
	extent := extent min: maxExtent.
	self view rectangle: ((maxExtent - extent) // 2 extent: extent)!

show
	"Shows the view of the receiver."

	self resizeToFitPage.
	browser view
		allowContextMenu: false;
		areBrowserAcceleratorKeysEnabled: false.
	self openUrl: self homePage.
	super show! !

!Autoplay categoriesForMethods!
browser!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
homePage!commands!public! !
homePage:!accessing!public! !
homePageHtml:!accessing!public! !
initialize!initializing!private! !
onDocumentTitleChanged!initializing!public! !
onNavigationStarting:!initializing!public! !
openUrl:!operations!public! !
pageExtent!accessing!public! !
pageExtent:!accessing!public! !
resizeToFitPage!operations!private! !
show!operations!public! !
!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13107200 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 971 1009 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.WebView2View) 34 21 nil 416 34 2 8 1140850688 1 560 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 7 nil nil nil 560 nil nil 852486 ##(Smalltalk.NullConverter) nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 1 1 498 939 931 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 213 1 0 0 209 1 0 0] 8 #() 498 193 193 nil 27 170 192 34 2 560 8 'browser' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 722 138 144 34 2 786 #createAt:extent: 34 2 498 12287 21 498 971 1009 416 786 #text: 34 1 8 'This caption will be set to the title the loaded HTML page' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 228 25 0 0 2 2 0 0] 34 1 560 928 nil 27 )! !

!Autoplay class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

