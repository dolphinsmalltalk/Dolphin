﻿"Filed out from Dolphin Smalltalk"!

Tools.DolphinCoreProduct
	subclass: #'Tools.DolphinBaseProduct'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DolphinBaseProduct guid: (Core.GUID fromString: '{2a3b6d22-63cb-4287-905e-8221eb59e17d}')!

Tools.DolphinBaseProduct comment: ''!

!Tools.DolphinBaseProduct categoriesForClass!System-Support! !

!Tools.DolphinBaseProduct methodsFor!

calcSystemFolderExtentFor: aPoint 
	"Answer a system folder extent that will yield the specified extent for the folder list
	view. Makes a reasonable attempt to be independent of the OS and theme (should work on XP
	and Vista)."

	| toolbarHeight metrics systemMetricsClass |

	systemMetricsClass := #{OS.SystemMetrics} valueOrNil.
	systemMetricsClass isNil ifTrue: [
		^super calcSystemFolderExtentFor: aPoint].

	metrics := systemMetricsClass current.
	toolbarHeight := 26.
	^aPoint + (0 @ (toolbarHeight + metrics menuBarHeight + metrics nonClientMetrics iCaptionHeight)) 
		+ (metrics sizingFrameExtent * 2)!

contents
	"Answer the list of package contents of the receiver"

	| contents |
	contents := super contents.

	"Camp Smalltalk SUnit"
	contents
		add: #('Core\Contributions\Camp Smalltalk\SUnit\SUnitPreload.pax' #plain #imageBased);
		add: #('Core\Contributions\Camp Smalltalk\SUnit\SUnit.pax' #plain #imageBased);
		add: #('Core\Contributions\Camp Smalltalk\SUnit\SUnitUI.pax' #plain #imageBased);
		add: #('Core\Contributions\Camp Smalltalk\SUnit\SUnit (Old Names).pax' #plain #imageBased);
		yourself.

	contents
		add: #('Core\Object Arts\Dolphin\Lagoon\Product Protection Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\Product Protection.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\DolphinSure\DolphinSure.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\DolphinSure\DolphinSure (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\DolphinSure\DolphinSure UI.pax' #plain #imageBased);
		yourself.

	"GDI+"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Samples\Gdiplus ImageView Sample.pax' #plain #imageBased);
		yourself.

	"Add-ons"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Shell\Windows Shell Namespace.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Community Edition\Dolphin Community Edition Tools.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\CNG\Windows Crypto NG.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\WebView2\WebView2.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\WebView2\WebView2 (Old Names).pax' #plain #imageBased);
		yourself.

	"Now the samples"
	contents
		add: #('Core\Object Arts\Samples\MVP\UI Examples.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Utilities\OS Examples.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Animal Game\Animals.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\RegEdit\RegEdit.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Playground\Playground.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Scribble\Scribble.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Etch-a-Sketch\Etch-a-Sketch.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Notepad\Notepad.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Hello World\Hello World.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Better Hello World\Better Hello World.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\ActiveX\EnumRECT\EnumRECT.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\ActiveX\Web Browser\Simple Web Browser.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Calculator\Calculator.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Personal Money\PersonalMoney.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Video Library\Video Library.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Video Library\Video Library (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Bouncing Balls\Bouncing Balls.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Sliding Ball Demo\SlidingBallDemo.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\IDE\Dolphin IDE Extension Example.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Wordpad\Wordpad.pax' #plain #imageBased);
		yourself.

	"Differences Presenter"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Difference\Diff Algorithm.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Difference\Dolphin Differences Presenter.pax' #plain #imageBased);
		yourself.

	"OA SUnit extensions"
	contents add: #('Core\Contributions\Camp Smalltalk\SUnit\OA SUnit Extensions.pax' #plain #imageBased).

	"Metaprog contributions"
	contents add: #('Core\Contributions\MetaProg\Abbreviations\MetaProg Abbreviations.pax' #plain #imageBased).

	"Jeff Odell's SUnit browser"
	contents
		add: #('Core\Contributions\Odellsoft\SUnitBrowser\SUnitBrowserModelApp.pax' #plain #imageBased);
		add: #('Core\Contributions\Odellsoft\SUnitBrowser\SUnitBrowser.pax' #plain #imageBased);
		yourself.

	"Deprecated pieces"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Deprecated\ActiveX (Deprecated).pax' #plain #imageBased);
		yourself.

	"Add-ons"
	contents
		add: #('Core\Object Arts\Dolphin\System\Win32\Windows Service Manager.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Database\Database Connection Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Database\Database Connection.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Database\Database Connection (Deprecated).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Database\Database Connection (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Continuations\Dolphin Continuations.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\Refactorings\RBReferenceFinder.pax' #plain #imageBased);
		yourself.

	"More Samples"
	contents
		add: #('Core\Object Arts\Samples\Sockets\Net Examples.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Sockets\Chat\Chat.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Database\DumpTable\DumpTable.pax' #plain #imageBased).

	"XmlPad Sample"
	contents
		add: #('Core\Object Arts\Dolphin\Registry\Dolphin Registry Serialisation.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\XmlPad\XmlPad.pax' #plain #imageBased);
		yourself.

	"Ian's bits"
	contents
		add: #('Core\Contributions\IDB\IDB Method History.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB Common.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB Chunk Browser.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB Profiler.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB File Browser.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB DeviceIndependentBitmap.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB Image Library.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB MultipleFileOpenDialog.pax' #plain #imageBased);
		add: #('Core\Contributions\IDB\IDB IDE Package Backup.pax' #plain #imageBased);
		yourself.

	"Solutions Software components"
	contents
		add: #('Core\Contributions\Solutions Software\SSW ListView Extensions.pax' #plain #imageBased);
		add: #('Core\Contributions\Solutions Software\SSW Widget Enhancements.pax' #plain #imageBased);
		add: #('Core\Contributions\Solutions Software\SSW EditableListView.pax' #plain #imageBased);
		add: #('Core\Contributions\Solutions Software\SSW Widget Development.pax' #plain #imageBased);
		add: #('Core\Contributions\Solutions Software\SSW EditableListView Demo.pax' #plain #imageBased);
		yourself.
		
	"STON - extras"
	contents
		add: #('Core\Object Arts\Dolphin\System\STON\Dolphin STON-Json.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\STON\Dolphin STON-MVP.pax' #plain #imageBased);
		yourself.

	^contents!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Base'!

warnOfUnlistedContent
	| unpackaged unlistedContent |
	unpackaged := Package manager unpackagedClasses.
	unpackaged isEmpty
		ifFalse: 
			[Notification signal: 'The image contains the following unpackaged classes: '
						, unpackaged asSortedArray fullPrintString].
	unpackaged := Package manager unpackagedVariables.
	unpackaged isEmpty
		ifFalse: 
			[Notification signal: 'The image contains the following unpackaged variables: '
						, unpackaged asSortedArray fullPrintString].
	unlistedContent := self unlistedPrerequisites.
	unlistedContent isEmpty
		ifFalse: 
			[self unlistedContentException
				signal: 'The deployed image will include the following unlisted pre-requisite packages: '
						, unlistedContent displayString]! !

!Tools.DolphinBaseProduct categoriesForMethods!
calcSystemFolderExtentFor:!helpers!private! !
contents!accessing!public! !
fullName!accessing!public! !
warnOfUnlistedContent!operations!private! !
!

!Tools.DolphinBaseProduct class methodsFor!

productName
	"Answer the product name"
	
	^'Base Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DBASE'! !

!Tools.DolphinBaseProduct class categoriesForMethods!
productName!accessing!public! !
shortProductName!accessing!public! !
!

