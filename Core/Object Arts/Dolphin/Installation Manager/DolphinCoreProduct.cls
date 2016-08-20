"Filed out from Dolphin Smalltalk 7"!

DolphinProduct subclass: #DolphinCoreProduct
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinCoreProduct guid: (GUID fromString: '{610C5616-617F-4B75-9C31-7589F234A3C2}')!
DolphinCoreProduct comment: ''!
!DolphinCoreProduct categoriesForClass!Development! !
!DolphinCoreProduct methodsFor!

calcSystemFolderExtentFor: aPoint 
	"Answer a system folder extent that will yield the specified extent for the folder list
	view.Just a guess at this level"

	^aPoint + (20 @ 85)!

contents
	"Answer the list of package contents of the receiver"

	| contents |
	contents := super contents.

	"Base"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Views\SysLink\Dolphin SysLink Control.pax' #encrypted #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\Formatters\RBFormatters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Announcements\Dolphin Announcements.pax' #plain #imageBased);
		
		"##(self paxesUnder: 'Core\Object Arts\Dolphin\MVP\Presenters\Prompters' encrypted: false) asArray"
		addAll: #(#('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Choice Prompter.pax' #plain #imageBased) #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin In-place Text Editor.pax' #plain #imageBased) #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Integer Prompter.pax' #plain #imageBased) #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Key-Value Prompter.pax' #plain #imageBased) #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Prompter.pax' #plain #imageBased));

		add: #('Core\Object Arts\Dolphin\ActiveX\COM\OLE COM.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Structured Storage\OLE Structured Storage.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Shell\Windows Shell.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Automation\ActiveX Automation.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\Picture\OLE Picture.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\Font\OLE Font.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\ListTree\Dolphin List Tree Presenter.pax' #plain #imageBased);
		yourself.

	"Active-X control hosting and support packages"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Persist\OLE Persistence Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Connection Points\ActiveX Connection Points.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Categories\ActiveX Categories.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\OCX\ActiveX Control Hosting.pax' #plain #imageBased);
		yourself.

	"GDI+"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus ImageView.pax' #plain #imageBased);
		yourself.

	"Goodies"
	contents
		add: #('Core\Object Arts\Goodies\Internal Bitmaps and Icons\Internal Bitmaps and Icons.pax' #plain #imageBased);
		yourself.

	"Additional development tools"
	contents
		add: #('Core\Object Arts\Dolphin\IDE\Community Edition\ActiveX Automation Development.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Base\Splash\Seeing the Objects Inside.pax' #plain #imageBased);
		yourself.

	"Deprecated pieces"
	contents
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Legacy Resource Framework.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Deprecated\Dolphin MVP (Deprecated).pax' #plain #imageBased);
		yourself.

	"Add-ons"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Integer Prompter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Sockets\Dolphin Sockets.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Sockets\Sockets Connection.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Sockets\WinInet.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\ADO\ADODB.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\CDO\CDO.pax' #plain #imageBased);
		yourself.

	"Burning River"
	contents
		add:  #('Core\Contributions\Burning River\KernelLibraryExtensions\KernelLibraryExtensions.pax' #plain #imageBased);
		add:  #('Core\Contributions\Burning River\InheritableFile/InheritableFile.pax' #plain #imageBased);
		add:  #('Core\Contributions\Burning River\ExternalProcess\ExternalProcess.pax' #plain #imageBased).

	"Udo Schneider"
	contents add:  #('Core\Contributions\Udo Schneider\US ExternalProcess Extensions.pax' #plain #imageBased).

	"Active-X components"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\XML DOM\XML DOM.pax' #plain #diskBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\Scripting\ActiveX Scripting.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\AgentObjects\AgentObjects.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\VBScript\VBScript Regular Expressions.pax' #plain #imageBased).

	^contents!

defaultSystemFolderColor
	^RGB red: 41 green: 124 blue: 182!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Core'!

installSystemFolderOptions
	Smalltalk at: #SmalltalkSystemShell
		ifPresent: 
			[:systemFolder | 
			systemFolder
				defaultExtent: (self calcSystemFolderExtentFor: 860 @ 225);
				backcolor: self defaultSystemFolderColor]! !
!DolphinCoreProduct categoriesFor: #calcSystemFolderExtentFor:!private! !
!DolphinCoreProduct categoriesFor: #contents!accessing!public! !
!DolphinCoreProduct categoriesFor: #defaultSystemFolderColor!public! !
!DolphinCoreProduct categoriesFor: #fullName!accessing!public! !
!DolphinCoreProduct categoriesFor: #installSystemFolderOptions!private! !

!DolphinCoreProduct class methodsFor!

isAbstract
	^false!

productLevel
	"Private - Answer the product ID for the receiver"

	^0!

productName
	"Answer the product name"
	
	^'Core Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DCORE'! !
!DolphinCoreProduct class categoriesFor: #isAbstract!operations!public!testing! !
!DolphinCoreProduct class categoriesFor: #productLevel!constants!private! !
!DolphinCoreProduct class categoriesFor: #productName!accessing!public! !
!DolphinCoreProduct class categoriesFor: #shortProductName!accessing!public! !

