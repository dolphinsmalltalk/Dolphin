"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.Autoplay'
	instanceVariableNames: 'browser navigating pageExtent homePage'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.Autoplay guid: (Core.GUID fromString: '{6d08642b-1e71-49fe-9c29-c044a21d63d0}')!

UI.Examples.Autoplay comment: '`Autoplay` is a `<topShell>` sample application which hosts the Microsoft Web Browser Control in order to implement an HTML based setup menu for CD-ROM auto-play. The sample demonstrates how to intercept clicks on the links and use them to invoke external programs (in this case using ShellExecute()).

Evaluate the following to try out Autoplay:
```
	Autoplay show
```

Evaluate the following to see the Autoplay package for further details.
```
	(Package manager packageNamed: ''Autoplay'') browse
```'!

!UI.Examples.Autoplay categoriesForClass!MVP-Presenters!Samples! !

!UI.Examples.Autoplay methodsFor!

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

	homePage := (FileLocator imageRelative resolve: aString) path!

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
	maxExtent := self view monitor effectiveWorkArea extent.
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

!UI.Examples.Autoplay categoriesForMethods!
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

!UI.Examples.Autoplay class methodsFor!

icon
	"Answers an Icon that can be used to represent this class (use the icon from
	the host executable)."

	^Icon fromId: '!!APPLICATION' in: (Kernel32 getModuleHandle: nil)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13107200 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 971 1009 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.WebView2View} 50 26 nil 32 50 2 8 1140850688 1 192 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 192 nil nil 518 #{UI.NullConverter} nil nil 1 nil nil nil nil nil 2374 3 #{WebView2.WebView2EnvironmentOptions} nil 7 nil nil nil 1 1 1 8 #() nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 582 1 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 213 1 0 0 209 1 0 0] nil 193 224 8 '' 192 3 384 130 193 193 nil 29 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 192 8 'browser' nil nil nil nil nil 1 nil nil nil nil nil nil 193 402 50 1 450 #createWindow: 50 1 498 518 #{Graphics.Rectangle} 130 1 1 130 971 1009 193 80 8 'This caption will be set to the title the loaded HTML page' 32 1 50 1 192 130 193 193 nil 27)! !

!UI.Examples.Autoplay class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

