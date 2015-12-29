"Filed out from Dolphin Smalltalk X6"!

ContainerView subclass: #NPAppletSite
	instanceVariableNames: 'context backgroundImage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NPAppletSite guid: (GUID fromString: '{CCB87570-6C2E-11D3-BDD5-004005A6900B}')!
NPAppletSite comment: 'An NPAppletSite is a container view which is positioned to completly obscure the parent BrowserView that was supplied by the web browser for a particular NPApplet. All views of an applet are added as subviews of the NPAppletSite. All applets (be they presenters or views) can locate their NPAppletSite using #site.  This, in turn, can be used to gain access to the NPApplet browser context by sending #context:.

Instance Variables:
	context		<NPApplet> which this is a site for.
'!
!NPAppletSite categoriesForClass!Plugin-Support! !
!NPAppletSite methodsFor!

aboutPlugin
	"Displays a splash screen for the receiver"

	self context aboutPlugin!

applet
	"Answers the applet instance owned by the receiver"

	^self context applet
!

backgroundImage
	"Private - Answers a background image to use when painting the receiver"

	backgroundImage isNil ifTrue: [
		backgroundImage :=Bitmap fromId: 'AppletBackgroundSmall.bmp' 
			in: (ExternalResourceLibrary open: 'NPDolphin') ].
	^backgroundImage
!

context
	"Answer the NPApplet context which the reciver is connected to."

	^context!

context: anNPApplet
	"Private - Set the NPApplet context which the receiver is connected to."

	context := anNPApplet!

defaultLayoutManager
	"Private - Answer a default LayoutManager to use."

	^GridLayout new!

getFileLocator
	"Private - Answer the file locator for the receiver. 
	For applet sites this is a URLClassLocator."

	^self context classLocator!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self contextMenu: (Menu fromStrings: #('&Context'
		'&About this Plug-in...//aboutPlugin'))!

onPaintRequired: aPaintEvent 
	"Private - Paint the receiver's view."

	self getFirstChild isNil 
		ifTrue: 
			["Only need to paint if the applet has not yet started"

			| canvas image |
			canvas := aPaintEvent canvas.
			image := self backgroundImage.
			image drawOn: canvas at: self rectangle center - (image extent // 2).
			canvas free]!

onPositionChanged: aPositionEvent
	"Handler for window position change (move or resize)."

	"Implementation Note: The superclass implementation considers that any
	position change invalidates the layout, but moving our parent BrowserView window
	does not, so we override to invalidate only on resize. This is also a suitable
	time to revalidate too."

	aPositionEvent isResize ifTrue: [self invalidateLayout].
	self validateLayout.
	self presenter trigger: #positionChanged: with: aPositionEvent!

preTranslateKeyboardInput: aMSG 
	"Answer whether the receiver would like to consume the argument aMSG,
	which is a keyboard message."

	^(self translateAccelerator: aMSG) or: 
			["... and dialog messages excluding the ESCape key (which cancels dialogs)"
			| vKey |
			vKey := aMSG wParam.
			(vKey ~= VK_ESCAPE and: 
					["Do not pass VK_RETURN if no default button either"
					vKey ~= VK_RETURN or: [self topShell view getDefId ~= 0]]) 
				and: [self isDialogMessage: aMSG]	"Do not pass ESC as don't want shell to close"]!

preTranslateMouseInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG."

	^(self isDialogMessage: aMSG) or: [super preTranslateMouseInput: aMSG]
!

translateAccelerator: aMSG
	"Private - Inform Windows of the accelerator table associated with self. This in turn
	sends a WM_COMMAND if any of our accelerator keys matches."

	^false!

wmPaint: message wParam: wParam lParam: lParam
	"Private - This window requires painting"

	"Unfortuntately, the Netscape Browser API does not reliably inform us of resize changes to
	the applet site (at least not for IE browsers, anyway). Hence we detect a size change in our
	parent BrowserView and force our site to become the same extent."

	(self extent=self parentView extent) ifFalse: [
		self extent: self parentView extent.
		^1] .
	^self basicPaint: message wParam: wParam lParam: lParam

! !
!NPAppletSite categoriesFor: #aboutPlugin!commands!public! !
!NPAppletSite categoriesFor: #applet!accessing!public! !
!NPAppletSite categoriesFor: #backgroundImage!accessing!private! !
!NPAppletSite categoriesFor: #context!accessing!public! !
!NPAppletSite categoriesFor: #context:!accessing!private! !
!NPAppletSite categoriesFor: #defaultLayoutManager!constants!private! !
!NPAppletSite categoriesFor: #getFileLocator!accessing!private! !
!NPAppletSite categoriesFor: #initialize!initializing!private! !
!NPAppletSite categoriesFor: #onPaintRequired:!event handling!private! !
!NPAppletSite categoriesFor: #onPositionChanged:!event handling!public! !
!NPAppletSite categoriesFor: #preTranslateKeyboardInput:!dispatching!public! !
!NPAppletSite categoriesFor: #preTranslateMouseInput:!dispatching!public! !
!NPAppletSite categoriesFor: #translateAccelerator:!accelerator!private! !
!NPAppletSite categoriesFor: #wmPaint:wParam:lParam:!event handling-win32!private! !

!NPAppletSite class methodsFor!

browserView: aBrowserView
	"Answer a new instance of the receiver. This will be a child of the
	browser supplied aBrowserView. Currently a layout manager is set for 
	aBrowserView which will result in the new view completely obscuring it."

	| view |
	view := aBrowserView addSubView: self new.
	aBrowserView layout.
	^view! !
!NPAppletSite class categoriesFor: #browserView:!instance creation!public! !

