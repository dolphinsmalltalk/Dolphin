"Filed out from Dolphin Smalltalk"!

DolphinProduct subclass: #DolphinCoreProduct
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinCoreProduct guid: (GUID fromString: '{610c5616-617f-4b75-9c31-7589f234a3c2}')!

DolphinCoreProduct comment: ''!

!DolphinCoreProduct categoriesForClass!System-Support! !

!DolphinCoreProduct methodsFor!

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
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\Font\OLE Font.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\ListTree\Dolphin List Tree Presenter.pax' #plain #imageBased);
		yourself.

	"Active-X control hosting and support packages"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Persist\OLE Persistence Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Persist\OLE Persistence and Data Transfer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Connection Points\ActiveX Connection Points.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Categories\ActiveX Categories.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\OCX\ActiveX Control Hosting.pax' #plain #imageBased);
		yourself.

	"GDI+"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus ImageView.pax' #plain #imageBased);
		yourself.

	"Base System Icons"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Icons\Dolphin Text Tile Icons.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Icons\Dolphin Base Icons.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Icons\Internal Bitmaps and Icons\Internal Bitmaps and Icons.pax' #plain #imageBased);
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
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\XML DOM\XML DOM.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\XML DOM\XML DOM Visitor.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\Scripting\ActiveX Scripting.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\VBScript\VBScript Regular Expressions.pax' #plain #imageBased).

	^contents!

defaultSystemFolderColor
	"Private - Reference Color indirectly to eliminate hard dependency on Dolphin MVP Base.
	This method will only be called if SmalltalkSystemShell is loaded, in which case Color will be as well."

	^(Smalltalk at: #Color)
		r: 41
		g: 124
		b: 182.!

defaultSystemFolderExtent
	^860 @ 225!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Core'! !

!DolphinCoreProduct categoriesForMethods!
contents!accessing!public! !
defaultSystemFolderColor!constants!private! !
defaultSystemFolderExtent!constants!private! !
fullName!accessing!public! !
!

!DolphinCoreProduct class methodsFor!

productLevel
	"Private - Answer the product ID for the receiver"

	^0!

productName
	"Answer the product name"
	
	^'Core Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DCORE'! !

!DolphinCoreProduct class categoriesForMethods!
productLevel!constants!private! !
productName!accessing!public! !
shortProductName!accessing!public! !
!

