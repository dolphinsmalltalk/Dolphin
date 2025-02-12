﻿"Filed out from Dolphin Smalltalk"!

Tools.DolphinBaseProduct
	subclass: #'Tools.DolphinProfessional'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DolphinProfessional guid: (Core.GUID fromString: '{48eec5bd-f329-471a-99d8-41ffd76f7f98}')!

Tools.DolphinProfessional comment: ''!

!Tools.DolphinProfessional categoriesForClass!System-Support! !

!Tools.DolphinProfessional methodsFor!

contents
	"Answer the list of package contents owned by the receiver"

	| contents |
	contents := super contents.

	"ITC Gorisek"
	contents
		add: #('Core\Contributions\ITC Gorisek\Yaxo\YAXO Base.pax' #plain #imageBased);
		add: #('Core\Contributions\ITC Gorisek\Yaxo\YAXO DOM.pax' #plain #imageBased);
		yourself.

	"Add-ons"
	contents
		add: #('Core\Object Arts\Dolphin\IDE\Professional\Dolphin Professional Tools.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\Lagoon Image Stripper.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\Application Deployment Kit.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\ActiveX DLL Server Core.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\ActiveX DLL Server.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\ActiveX DLL Server (GUI).pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\ActiveX DLL Server Kit.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\Console Application Kit.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin File System Info.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin File System Watcher.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin Memory-Mapped Files.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin Overlapped IO.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\WinHttp\WinHttp.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\HttpServer\Windows HTTP Server.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\DPAPI\Windows Data Protection API.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Windows Ini Files.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Property Bags\ActiveX Property Bags.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Property Bags\ActiveX Property Bags (Old Names).pax' #encrypted #imageBased);
		addAll: #(#('Core\Object Arts\Dolphin\MVP\Metafiles\Dolphin Metafile Records.pax' #encrypted #imageBased) #('Core\Object Arts\Dolphin\MVP\Metafiles\Dolphin Metafiles.pax' #encrypted #imageBased));
		add: #('Core\Object Arts\Dolphin\Utilities\Tutorials\Tutorial Player.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Utilities\Tutorials\Learn Smalltalk.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Utilities\Tutorials\Learn Smalltalk (Old Names).pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Utilities\IPHelp\IP Help API.pax' #encrypted #imageBased);
		yourself.

	"Samples"
	contents
		add: #('Core\Object Arts\Samples\ActiveX\COM Examples.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\ActiveX\Random\COM Random Stream.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Console\Hello World\Hello World (Console).pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Console\Catenate\Catenate.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Console\Calculator\Calculator (Console).pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Security Examples.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Lagoon\Protected Product\Protected Scribble.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Lagoon\Protected Product\Protected Notepad.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Utilities\File System Monitor\File System Monitor.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Lagoon\Autoplay\Autoplay.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Generative Music\Midi.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Generative Music\Plimbole.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\DolphinSure Example Authority\DolphinSure Example Authority.pax' #plain #imageBased).
	"add: #('Core\Object Arts\Samples\Code Mentor Partner\Code Mentor Partner.pax' #plain #imageBased);"

	"Refactoring Browser (third party) - First load dummy RBParser package which aliases all the RB parser classes to Smalltalk Parser"
	contents
		add: #('Core\Contributions\Refactory\Refactoring Browser\Refactorings\RBRefactorings.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\SmallLint\RBSmallLint.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\RB (Old Names).pax' #plain #imageBased).


	"Camp Smalltalk Custom refactorings"
	contents
		add: #('Core\Contributions\Camp Smalltalk\Refactoring Browser\Refactorings\CSRefactorings.pax' #plain #imageBased).

	"Dolphin native Refactoring Browser integration"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin In-place Text Editor.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Professional\Dolphin Refactoring Browser.pax' #encrypted #imageBased).

	"Scintilla View generation tool"
	contents
		add: #('Core\Object Arts\Dolphin\IDE\Professional\Scintilla View Generator.pax' #plain #imageBased).

	^contents!

defaultSystemFolderExtent
	^865 @ 370!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Professional'! !

!Tools.DolphinProfessional categoriesForMethods!
contents!accessing!public! !
defaultSystemFolderExtent!private! !
fullName!accessing!public! !
!

!Tools.DolphinProfessional class methodsFor!

developmentClasses
	"Answer a <collection> containing all development classes."

	| classes |
	classes := (ClassCategory name: 'Development') classes asSet.

	"Should already all be there, but just in case"
	#('Development System' 'Dolphin Community Edition Tools' 'Dolphin Professional Tools' 'Dolphin Refactoring Browser')
		do: [:p | classes addAll: (Package manager packageNamed: p) classes].

	"Remove some that shouldn't"
	#('Object Arts Development' 'Installation Manager') do: 
			[:p |
			| package |
			package := Package manager packageNamed: p ifNone: nil.
			package notNil ifTrue: [package classes do: [:c | classes remove: c ifAbsent: nil]]].
	^classes!

productName
	"Answer the product name"
	
	^'Professional'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DPRO'! !

!Tools.DolphinProfessional class categoriesForMethods!
developmentClasses!public! !
productName!accessing!public! !
shortProductName!accessing!public! !
!

