"Filed out from Dolphin Smalltalk 7"!

DolphinBaseProduct subclass: #DolphinProfessional
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinProfessional guid: (Core.GUID fromString: '{48eec5bd-f329-471a-99d8-41ffd76f7f98}')!
DolphinProfessional comment: ''!
!DolphinProfessional categoriesForClass!System-Support! !
!DolphinProfessional methodsFor!

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
		add: #('Core\Object Arts\Dolphin\Lagoon\ActiveX DLL Server Kit.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\Console Application Kit.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin File System Info.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin File System Watcher.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin Memory-Mapped Files.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Dolphin Overlapped IO.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\WinHttp\WinHttp.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Windows HTTP Server.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Windows Data Protection API.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\Windows Ini Files.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Property Bags\ActiveX Property Bags.pax' #encrypted #imageBased);
		addAll: #(#('Core\Object Arts\Dolphin\MVP\Metafiles\Dolphin Metafile Records.pax' #encrypted #imageBased) #('Core\Object Arts\Dolphin\MVP\Metafiles\Dolphin Metafiles.pax' #encrypted #imageBased));
		add: #('Core\Object Arts\Dolphin\Utilities\Tutorials\Tutorial Player.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Utilities\Tutorials\Learn Smalltalk.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Utilities\IPHelp\IP Help API.pax' #encrypted #imageBased);
		yourself.

	"Samples"
	contents
		add: #('Core\Object Arts\Samples\ActiveX\Random\COM Random Stream.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Console\Hello World\Hello World (Console).pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Console\Catenate\Catenate.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Console\Calculator\Calculator (Console).pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Lagoon\Protected Product\Protected Scribble.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Lagoon\Protected Product\Protected Notepad.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Utilities\File System Monitor.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\Lagoon\Autoplay\Autoplay.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Generative Music\Midi.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\MVP\Generative Music\Plimbole.pax' #plain #imageBased);
		add: #('Core\Object Arts\Samples\DolphinSure Example Authority\DolphinSure Example Authority.pax' #plain #imageBased).
	"add: #('Core\Object Arts\Samples\Code Mentor Partner\Code Mentor Partner.pax' #plain #imageBased);"

	"Refactoring Browser (third party) - First load dummy RBParser package which aliases all the RB parser classes to Smalltalk Parser"
	contents
		add: #('Core\Contributions\Refactory\Refactoring Browser\Refactorings\RBRefactorings.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\SmallLint\RBSmallLint.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\RBOldNames.pax' #plain #imageBased).


	"Camp Smalltalk Custom refactorings"
	contents
		add: #('Core\Contributions\Camp Smalltalk\Refactoring Browser\Refactorings\CSRefactorings.pax' #plain #imageBased).

	"Dolphin native Refactoring Browser integration"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin In-place Text Editor.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Professional\Dolphin Refactoring Browser.pax' #encrypted #imageBased).
	^contents!

defaultSystemFolderExtent
	^865 @ 370!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Professional'! !
!DolphinProfessional categoriesFor: #contents!accessing!public! !
!DolphinProfessional categoriesFor: #defaultSystemFolderExtent!private! !
!DolphinProfessional categoriesFor: #fullName!accessing!public! !

!DolphinProfessional class methodsFor!

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
			package := Package manager packageNamed: p ifNone: [].
			package notNil ifTrue: [package classes do: [:c | classes remove: c ifAbsent: []]]].
	^classes!

productLevel
	"Private - Answer the product ID for the receiver"

	^3!

productName
	"Answer the product name"
	
	^'Professional'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DPRO'! !
!DolphinProfessional class categoriesFor: #developmentClasses!public! !
!DolphinProfessional class categoriesFor: #productLevel!constants!private! !
!DolphinProfessional class categoriesFor: #productName!accessing!public! !
!DolphinProfessional class categoriesFor: #shortProductName!accessing!public! !

