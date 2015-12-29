"Filed out from Dolphin Smalltalk X6.1"!

ItcInstaller subclass: #ItcWebAppInstaller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcWebAppInstaller guid: (GUID fromString: '{62B56B86-4578-4EE6-A7D3-F56FD2D95180}')!
ItcWebAppInstaller comment: ''!
!ItcWebAppInstaller categoriesForClass!Unclassified! !
!ItcWebAppInstaller methodsFor!

addAppDirectory: aString 
	^self addDirectory: self applicationPath , '\' , aString!

addAppFile: fileName 
	self addAppFile: fileName from: fileName!

addAppFile: fileName from: fileName2 
	self addFile: self applicationPath , '\' , fileName from: self applicationPath , '\' , fileName2!

addCssAndJavascriptDirectories
	self
		addAppDirectory: 'http-root\css';
		addAppDirectory: 'http-root\scripts';
		addAppDirectory: 'http-root\scripts\YahooUI';
		addAppDirectory: 'http-root\scripts\YahooUI\utilities';
		addAppDirectory: 'http-root\scripts\YahooUI\container';
		addAppDirectory: 'http-root\scripts\YahooUI\menu';
		addAppDirectory: 'http-root\scripts\YahooUI\treeview'!

addCssFiles
	self addHttpRootFile: 'css\ext-all.css'!

addDolphin514Files
	self
		addFile: 'DolphinCR005.dll'
			from: 'distro\DolphinCR005.dll'
			flags: #('ignoreversion');
		addFile: 'DolphinVM005.dll'
			from: 'distro\DolphinVM005.dll'
			flags: #('ignoreversion');
		addFile: 'zlib_dll.dll'
			from: 'distro\zlib_dll.dll'
			flags: #('ignoreversion');
		addFile: 'msvcp60.dll'
			from: 'distro\msvcp60.dll'
			flags: #(#firstInstallOnWin2000only #noDelete 'ignoreversion')!

addDolphinX6Files
	self
		addFile: 'DolphinCR006.dll'
			from: 'distro\DolphinCR006.dll'
			flags: #('ignoreversion');
		addFile: 'DolphinVM006.dll'
			from: 'distro\DolphinVM006.dll'
			flags: #('ignoreversion');
		addFile: 'zlib_dll.dll'
			from: 'distro\zlib_dll.dll'
			flags: #('ignoreversion');
		addFile: 'MSVCP71.dll'
			from: 'distro\MSVCP71.dll'
			flags: #('ignoreversion');
		addFile: 'MSVCR71.dll'
			from: 'distro\MSVCR71.dll'
			flags: #('ignoreversion');
		addFile: 'libeay32.dll'
			from: 'distro\libeay32.dll'
			flags: #('ignoreversion');
		addFile: 'ssleay32.dll'
			from: 'distro\ssleay32.dll'
			flags: #('ignoreversion')!

addHelperFiles
	self
		addFile: 'unzip.exe'
			from: 'distro\unzip.exe'
			flags: #(#noDelete);
		addFile: 'zip.exe'
			from: 'distro\zip.exe'
			flags: #(#noDelete);
		addFile: 'sleep.exe'
			from: 'distro\sleep.exe'
			flags: #(#noDelete);
		addFile: 'kill.exe'
			from: 'distro\kill.exe'
			flags: #(#noDelete)!

addHttpRootFile: fileName 
	self addHttpRootFile: fileName from: fileName!

addHttpRootFile: fileName from: fileName2 
	self addFile: self applicationPath , '\http-root\' , fileName
		from: self applicationPath , '\http-root\' , fileName2!

addImageFile: aString 
	self addImageFile: aString from: aString!

addImageFile: fileName from: fileName2 
	self addHttpRootFile: 'images\' , fileName from: 'images\' , fileName2!

addJavascriptFiles
	"for YUI"

	self
		addHttpRootFile: 'scripts\menu-toolbar.js';
		addHttpRootFile: 'scripts\YahooUI\utilities\utilities.js';
		addHttpRootFile: 'scripts\YahooUI\container\container_core.js';
		addHttpRootFile: 'scripts\YahooUI\menu\menu.js';
		addHttpRootFile: 'scripts\YahooUI\treeview\treeview.js'.
	"for Ext"
	self
		addHttpRootFile: 'scripts\ext-base.js';
		addHttpRootFile: 'scripts\ext-core.js';
		addHttpRootFile: 'scripts\ext-all.js'.
	"for Plotr"
	self
		addHttpRootFile: 'scripts\prototype.js';
		addHttpRootFile: 'scripts\excanvas.js';
		addHttpRootFile: 'scripts\plotr.js'!

addNationalLanguageSupportFiles
	ItcSystemManager isRuntime ifFalse: [self defaultApplication compressMessages].
	self defaultApplication defaultApplicationLanguages do: 
			[:eachLanguage | 
			self 
				addAppFile: 'nls\' , eachLanguage , (noFileCompression = true ifTrue: ['.lng'] ifFalse: ['.nls'])]!

applicationPath
	^self subclassResponsibility!

defaultApplication
	^self subclassResponsibility!

zipArchiveFilename
	^self applicationPath , '-' , self applicationVersion! !
!ItcWebAppInstaller categoriesFor: #addAppDirectory:!public! !
!ItcWebAppInstaller categoriesFor: #addAppFile:!public! !
!ItcWebAppInstaller categoriesFor: #addAppFile:from:!public! !
!ItcWebAppInstaller categoriesFor: #addCssAndJavascriptDirectories!public! !
!ItcWebAppInstaller categoriesFor: #addCssFiles!public! !
!ItcWebAppInstaller categoriesFor: #addDolphin514Files!public! !
!ItcWebAppInstaller categoriesFor: #addDolphinX6Files!public! !
!ItcWebAppInstaller categoriesFor: #addHelperFiles!public! !
!ItcWebAppInstaller categoriesFor: #addHttpRootFile:!public! !
!ItcWebAppInstaller categoriesFor: #addHttpRootFile:from:!public! !
!ItcWebAppInstaller categoriesFor: #addImageFile:!public! !
!ItcWebAppInstaller categoriesFor: #addImageFile:from:!public! !
!ItcWebAppInstaller categoriesFor: #addJavascriptFiles!public! !
!ItcWebAppInstaller categoriesFor: #addNationalLanguageSupportFiles!compile installation!public! !
!ItcWebAppInstaller categoriesFor: #applicationPath!public! !
!ItcWebAppInstaller categoriesFor: #defaultApplication!public! !
!ItcWebAppInstaller categoriesFor: #zipArchiveFilename!public! !

