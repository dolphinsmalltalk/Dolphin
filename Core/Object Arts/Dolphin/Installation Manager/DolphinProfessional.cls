"Filed out from Dolphin Smalltalk 7"!

DolphinBaseProduct subclass: #DolphinProfessional
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinProfessional guid: (GUID fromString: '{48EEC5BD-F329-471A-99D8-41FFD76F7F98}')!
DolphinProfessional comment: ''!
!DolphinProfessional categoriesForClass!Development! !
!DolphinProfessional methodsFor!

contents
	"Answer the list of package contents owned by the receiver"

	| contents |
	contents := super contents.

	"ITC Gorisek & STS"
	contents
		add: #('Core\Contributions\ITC Gorisek\Dialect Abstraction Layer.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\OmniBase.pax' #plain #imageBased);
		add: #('Core\Contributions\ITC Gorisek\Yaxo\YAXO Base.pax' #plain #imageBased);
		add: #('Core\Contributions\ITC Gorisek\Yaxo\YAXO DOM.pax' #plain #imageBased);
		add: #('Core\Contributions\ITC Gorisek\ZLib Interface.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\HTTP Client.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\HTML Parser.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\SMTP Support.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\MD5.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\Source Tracking System.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\Source Tracking System Remote Client.pax' #encrypted #imageBased);
		add: #('Core\Contributions\ITC Gorisek\Source Tracking System Administrator.pax' #encrypted #imageBased);
		yourself.

	"Add-ons"
	contents
		add: #('Core\Object Arts\Dolphin\IDE\Professional\Dolphin Professional Tools.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\Lagoon Image Stripper.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\Application Deployment Kit.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\Lagoon\ActiveX DLL Server Kit.pax' #encrypted #imageBased);
		addAll: #(#('Core\Object Arts\Dolphin\System\Win32\Dolphin File System Watcher.pax' #encrypted #imageBased) #('Core\Object Arts\Dolphin\System\Win32\Dolphin Memory-Mapped Files.pax' #encrypted #imageBased) #('Core\Object Arts\Dolphin\System\Win32\Dolphin MMF Tests.pax' #encrypted #imageBased) #('Core\Object Arts\Dolphin\System\Win32\Dolphin Overlapped IO.pax' #encrypted #imageBased));
		add: #('Core\Object Arts\Dolphin\ActiveX\Property Bags\ActiveX Property Bags.pax' #encrypted #imageBased);
		addAll: #(#('Core\Object Arts\Dolphin\MVP\Metafiles\Dolphin Metafile Records.pax' #encrypted #imageBased) #('Core\Object Arts\Dolphin\MVP\Metafiles\Dolphin Metafiles.pax' #encrypted #imageBased));
		yourself.

	"##(self paxesUnder: 'Core\Object Arts\Dolphin\System\Win32\' encrypted: true) asArray"

	"##(self paxesUnder: 'Core\Object Arts\Dolphin\MVP\Metafiles\' encrypted: true) asArray"

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
		add: #('Core\Object Arts\Samples\DolphinSure Example Authority\DolphinSure Example Authority.pax' #plain #imageBased).
	"add: #('Core\Object Arts\Samples\Code Mentor Partner\Code Mentor Partner.pax' #plain #imageBased);"

	"Refactoring Browser (third party) - First load dummy RBParser package which aliases all the RB parser classes to Smalltalk Parser"
	contents
		add: #('Core\Contributions\Refactory\Refactoring Browser\Refactorings\RBRefactorings.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\SmallLint\RBSmallLint.pax' #plain #imageBased).

	"Camp Smalltalk Custom refactorings"
	contents 
		add: #('Core\Contributions\Camp Smalltalk\Refactoring Browser\Refactorings\CSRefactorings.pax' #plain #imageBased).

	"Dolphin native Refactoring Browser integration"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin In-place Text Editor.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Professional\Dolphin Refactoring Browser.pax' #encrypted #imageBased).

	^contents!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Professional'!

installSystemFolderOptions
	Smalltalk at: #SmalltalkSystemShell
		ifPresent: 
			[:systemFolder | 
			systemFolder
				defaultExtent: (self calcSystemFolderExtentFor: 865@370);
				backcolor: self defaultSystemFolderColor]! !
!DolphinProfessional categoriesFor: #contents!accessing!public! !
!DolphinProfessional categoriesFor: #fullName!accessing!public! !
!DolphinProfessional categoriesFor: #installSystemFolderOptions!private! !

!DolphinProfessional class methodsFor!

developmentClasses
	"Answer a <collection> containing all development classes."

	| classes |
	classes := (ClassCategory name: 'Development') contents asSet.

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

isAbstract
	^false!

productLevel
	"Private - Answer the product ID for the receiver"

	^3!

productName
	"Answer the product name"
	
	^'Professional'!

redistHeaderText
	"Answer the blah which forms the fixed part of REDIST.TXT"

^'This file details the Redistributable Components of DOLPHIN SMALLTALK
PROFESSIONAL EDITION (the SOFTWARE PRODUCT) that you are permitted
to redistribute with your Applications. It also lists the Development System
Components of the SOFTWARE PRODUCT that you must NOT distribute with
your applications without express written permission from Object Arts Ltd.

This file is an addendum to the DOLPHIN SMALLTALK License Agreement, and should be 
read in conjunction with this document in its entirety.  The full text of the License
Agreement is available in the file "License.rtf" in the installation directory.

Redistributable Components
==========================

The following files may be redistributed as an integral part of executable applications
created by you utilising the SOFTWARE PRODUCT:

DOLPHIN.EXE
DOLPHINVM006.DLL
DOLPHINCR006.DLL
DOLPHINDR006.DLL
DOLPHINSURECRYPTO.DLL

Non-redistributable (Development System) Components
===================================================

The following files are solely Development System components of the SOFTWARE 
PRODUCT and you must NOT redistribute them in any form:

GUISTUB.EXE
GUITOGO.EXE
CONSOLESTUB.EXE
CONSOLETOGO.EXE

The following classes are Development System Components of the SOFTWARE
PRODUCT and you must NOT redistribute them in any form, as either source or 
object code, either independently or as part of an Application:'.
!

redistWriteClassesOn: target 
	self developmentClasses asSortedCollection do: 
			[:e | 
			target
				print: e;
				cr]!

shortProductName
	"Answer the abbreviated product name"
	
	^'DPRO'! !
!DolphinProfessional class categoriesFor: #developmentClasses!public! !
!DolphinProfessional class categoriesFor: #isAbstract!operations!public!testing! !
!DolphinProfessional class categoriesFor: #productLevel!constants!private! !
!DolphinProfessional class categoriesFor: #productName!accessing!public! !
!DolphinProfessional class categoriesFor: #redistHeaderText!constants!public! !
!DolphinProfessional class categoriesFor: #redistWriteClassesOn:!public! !
!DolphinProfessional class categoriesFor: #shortProductName!accessing!public! !

