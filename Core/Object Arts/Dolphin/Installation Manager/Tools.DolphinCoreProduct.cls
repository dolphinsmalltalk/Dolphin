"Filed out from Dolphin Smalltalk"!

Tools.DolphinProduct
	subclass: #'Tools.DolphinCoreProduct'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DolphinCoreProduct guid: (Core.GUID fromString: '{610c5616-617f-4b75-9c31-7589f234a3c2}')!

Tools.DolphinCoreProduct comment: ''!

!Tools.DolphinCoreProduct categoriesForClass!System-Support! !

!Tools.DolphinCoreProduct methodsFor!

contents
	"Answer the list of package contents of the receiver"

	| contents |
	contents := super contents.

	"Base"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin Binary Object Clipboard Format.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Text\Dolphin Rich Text Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Static\Path\Dolphin StaticPath Control.pax' #encrypted #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\SysLink\Dolphin SysLink Control.pax' #encrypted #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\Formatters\RBFormatters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Announcements\Dolphin Announcements.pax' #plain #imageBased);
		
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Validation\Dolphin Validation Hint Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Choice Prompter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin In-place Text Editor.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Integer Prompter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Key-Value Prompter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Prompter.pax' #plain #imageBased);

		add: #('Core\Object Arts\Dolphin\ActiveX\COM\OLE COM.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\COM\OLE COM (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Structured Storage\OLE Streams.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Structured Storage\OLE Structured Storage.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Structured Storage\OLE Structured Storage (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Shell\Windows Shell.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Automation\ActiveX Automation.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Automation\ActiveX Automation (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\Font\OLE Font.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\ListTree\Dolphin List Tree Presenter.pax' #plain #imageBased);
		yourself.

	"Active-X control hosting and support packages"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Persist\OLE Persistence Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Persist\OLE Persistence Base (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Persist\OLE Persistence and Data Transfer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Persist\OLE Persistence and Data Transfer (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Connection Points\ActiveX Connection Points.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Connection Points\ActiveX Connection Points (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Categories\ActiveX Categories.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\OCX\ActiveX Control Hosting.pax' #plain #imageBased);
		yourself.

	"The advanced find dialog - depends on the VBScript RegExp package"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\VBScript\VBScript Regular Expressions.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\VBScript\VBScript Regular Expressions (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Find\Dolphin Find Dialog.pax' #plain #imageBased);
		yourself.

	"GDI+"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus ImageView.pax' #plain #imageBased);
		yourself.

	"Base System Icons"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Icons\Dolphin Text Tile Icons.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Icons\Dolphin Base Icons.pax' #plain #imageBased);
		yourself.

	"The base development system"
	contents
		add: #('Core\Object Arts\Dolphin\System\Trace\Debug Trace Stream.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\RBNamespaces.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\Parser\RBParser.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\Environments\RBEnvironments.pax' #plain #imageBased);
		add: #('Core\Contributions\Refactory\Refactoring Browser\Change Objects\RBChangeObjects.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Base\Dolphin Browser Environments.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Base\Development System.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Utilities\HTML Help\HTML Help.pax' #plain #imageBased);
		yourself.

	"Additional development tools"
	contents
		add: #('Core\Object Arts\Dolphin\IDE\Community Edition\ActiveX Automation Development.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus Development.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Base\Splash\Seeing the Objects Inside.pax' #plain #imageBased);
		yourself.

	"Deprecated pieces"
	contents
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Legacy Resource Framework.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Deprecated\Dolphin MVP (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Deprecated\Dolphin MVP (Deprecated).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Scintilla\Dolphin Scintilla View (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Scintilla\Dolphin Scintilla View (Deprecated).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Base\Development System (Deprecated).pax' #plain #imageBased);
		yourself.

	"Add-ons"
	contents
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Prompters\Dolphin Integer Prompter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Sockets\Dolphin Sockets.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Sockets\Dolphin Sockets (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Sockets\WinInet.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\ADO\ADODB.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\ADO\ADODB (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\CDO\CDO.pax' #plain #imageBased);
		yourself.

	"Burning River"
	contents
		add:  #('Core\Contributions\Burning River\KernelLibraryExtensions\KernelLibraryExtensions.pax' #plain #imageBased);
		add:  #('Core\Contributions\Burning River\InheritableFile\InheritableFile.pax' #plain #imageBased);
		add:  #('Core\Contributions\Burning River\ExternalProcess\ExternalProcess.pax' #plain #imageBased).

	"Udo Schneider"
	contents add:  #('Core\Contributions\Udo Schneider\US ExternalProcess Extensions.pax' #plain #imageBased).

	"Active-X components"
	contents
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\XML DOM\XML DOM.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\XML DOM\XML DOM Visitor.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\XML DOM\XML Formatter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\XML DOM\XML DOM (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\ActiveX\Components\Scripting\ActiveX Scripting.pax' #plain #imageBased).

	^contents!

defaultSystemFolderColor
	"Private - Reference Color indirectly to eliminate hard dependency on Dolphin MVP Base.
	This method will only be called if SmalltalkSystemShell is loaded, in which case Color will be as well."

	^#{Graphics.Color} value seaGreen!

defaultSystemFolderExtent
	^860 @ 225!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Core'! !

!Tools.DolphinCoreProduct categoriesForMethods!
contents!accessing!public! !
defaultSystemFolderColor!constants!private! !
defaultSystemFolderExtent!constants!private! !
fullName!accessing!public! !
!

!Tools.DolphinCoreProduct class methodsFor!

productName
	"Answer the product name"
	
	^'Core Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DCORE'! !

!Tools.DolphinCoreProduct class categoriesForMethods!
productName!accessing!public! !
shortProductName!accessing!public! !
!

