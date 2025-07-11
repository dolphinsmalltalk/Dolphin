﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.DolphinProduct'
	instanceVariableNames: 'version encryptedClasses'
	classVariableNames: 'Current EditionsMap'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DolphinProduct guid: (Core.GUID fromString: '{0bcc007b-10ed-40ce-940e-83882e2f70d8}')!

Tools.DolphinProduct isNonInstantiable: true!

Tools.DolphinProduct comment: ''!

!Tools.DolphinProduct categoriesForClass!System-Support! !

!Tools.DolphinProduct methodsFor!

allPackages
	"Answer an <OrderedCollection> of Packages associated with the receiver. This includes
	all of the prerequisite packages that are required by the named packages
	of the receiver"

	| set |
	set := IdentitySet new.
	self packages do: [:each | each addAllPrerequisitesTo: set].
	^set asOrderedCollection!

basicLoad
	"Private - Loads the required packages into the image for the receiver. 
	Does not remove any packages that should not be present"

	"Inform the development system of it's new product state"

	| packageManager |
	self installProductDetails.
	packageManager := Package manager.
	self packagePaths do: 
			[:each |
			| name |
			name := File splitStemFrom: each.
			packageManager packageNamed: name
				ifNone: 
					[[packageManager install: each] on: packageManager prerequisiteNotFoundSignal
						do: [:ex | ex resume: ex messageText]]].
	Smalltalk developmentSystem beNotChanged!

beCurrent
	"Sets the singleton instance which represents the current product level of this image
	to the receiver"

	Current := self!

boot
	self loadShrinkAndCompress.
	self installSystemFolderOptions.
	self installSplash.
	self beCurrent

!

calcSystemFolderExtentFor: aPoint
	"Answer a system folder extent that will yield the specified extent for the folder list view. Just a guess at this level."

	^aPoint + (20 @ 85)!

contents
	"Answer the list of package contents associated with the receiver. Each content item is a
	three element array containing the package path, a <Symbol> describing the encryption mode
	and a <Symbol> describing whether the package normally resides in the image or on disk after
	installation."

	| answer |
	answer := OrderedCollection new.
	"Some loaded by boot part 2 script"
	answer
		add: #('Core\Object Arts\Dolphin\Base\Dolphin.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Base (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Legacy FFI Types (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\CommCtrl\Common Controls Library.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Win32\MessageBox\Dolphin Message Box.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Source Fileout.pax' #plain #imageBased).

	answer
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin STx Filer Core.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin STx Filer Core (Old versions).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin STx Out Filer Core.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Binary Filer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Binary Filer (Old versions).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Validating Binary Filer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Literal Filer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Literal Filer (Old versions).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Literal Out Filer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Literal Out Filer (Old versions).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin STL Class Collector.pax' #plain #imageBased).

	answer
		add: #('Core\Object Arts\Dolphin\System\STON\Dolphin STON-Core.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Source Package Fileout.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\SemVer\Dolphin SemVer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Conformant Array Fields.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Legacy Package Support.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Legacy Date & Time.pax' #plain #imageBase);
		add: #('Core\Object Arts\Dolphin\System\STON\Dolphin STON-Legacy Date & Time.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Base (Deprecated).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Anonymous Classes.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Command-line Parser.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Compiler\Smalltalk Parser.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin SizeIs Fields.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Registry\Dolphin Registry Access.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Base64\Dolphin Base64.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Compiler\Smalltalk Parser (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Compiler\Smalltalk Compiler.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Recent\Dolphin Recent Menu.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Models\Value\Dolphin Value Models.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Type Converters\Dolphin Type Converters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Type Converters\Dolphin Evaluating Type Converter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Random\Dolphin Random Stream.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin Basic Geometry.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Graphics\Dolphin GDI Graphics.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin MVP Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin ControlViews Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin Binary Object Clipboard Format' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin Command History.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Static\Text\Dolphin StaticText Control.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Static\Rectangle\Dolphin StaticRectangle Control.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Validation\Dolphin Validation Result Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Dolphin Base Dialogs.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Dialogs.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Print Dialog.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Color Dialog.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Font Dialog.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Find Replace Dialogs.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Text\Dolphin Text Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Additional Sort Algorithms.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\List\Dolphin List Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Models\List\Dolphin List Models.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Choice\Dolphin Choice Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Scrollbars\Dolphin Scrollbars.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Number\Dolphin Number Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Shell\Dolphin Document Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Shell\Dolphin Legacy Document Presenter.pax' #plain #imageBased);
		yourself.
	answer
		add: #('Core\Object Arts\Dolphin\MVP\Models\Tree\Dolphin Tree Models.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Models\Tree\Dolphin Folder Tree Model.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Tree\Dolphin Tree Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Boolean\Dolphin Boolean Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Common Controls\Dolphin Common Controls.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Control Bars\Dolphin Control Bars.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus (Deprecated).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Gdiplus\Gdiplus (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Styled Views\Dolphin Styled Views.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Collection\Dolphin Collection Presenters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Folder\Dolphin Folder Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Tree\Dolphin Tree List Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Accelerator\Dolphin Accelerator Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Font\Dolphin Font Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Image\Dolphin Image Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\MoenTree\Dolphin MoenTree View.pax' #plain #imageBased);
		yourself.
	"These views have to be loaded before the development system because they have #publishedAspects, etc, methods"
	answer
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Date Time\Dolphin Date Time Presenters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Radio\Dolphin Radio Buttons.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Buttons\Dolphin Check Buttons.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Buttons\Dolphin Push Buttons.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Date Time\Dolphin Date Time Controls.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Static\GroupBox\Dolphin GroupBox.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Slider\Dolphin Slider Control.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\SpinButton\Dolphin SpinButton Control.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Splitter\Dolphin Splitter Control.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Tooltips\Dolphin Tooltips.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Cards\Dolphin Card Containers.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Color\Dolphin Color Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Scintilla\Dolphin Scintilla View.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Sliding Tray\Dolphin Slidey-Inney-Outey Thing.pax' #plain #imageBased);
		yourself.

	"Load up the Transcript"
	answer
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Progress\Dolphin Progress Dialog.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Base\Dolphin Transcript.pax' #plain #imageBased);
		yourself.

	answer
		add: #('Core\Object Arts\Dolphin\Installation Manager\Dolphin Products.pax' #plain #imageBased);
		yourself.
	^answer!

defaultSystemFolderColor
	^self subclassResponsibility!

defaultSystemFolderExtent
	^self subclassResponsibility!

diskBasedPackages
	"Private - Answer the list of package names associated with the receiver that are intended to be disk based"

	| paths |
	paths := self contents reject: [:each | (each at: 3) == #imageBased].
	^paths collect: [:each | File splitStemFrom: (each at: 1)]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self fullName;
		space;
		display: self version!

encryptedClasses
	"Answer classes owned by the receiver that will be encrypted in the deployed executable."

	encryptedClasses isNil
		ifTrue: 
			[| packages classes |
			packages := self encryptedPackageNames collect: [:each | Package manager packageNamed: each].
			classes := Set new.
			packages do: [:each | classes addAll: each classes].
			classes := classes asArray select: [:each | self isSafeToEncrypt: each].
			self shouldEncryptMetaclasses
				ifTrue: [classes := classes , (classes collect: [:each | each class])].
			encryptedClasses := classes asSortedCollection: [:a :b | a name <==> b name <= 0]].
	^encryptedClasses!

encryptedClasses: aCollectionOfClasses
	"Private - Record which classes we should encrypt during deployment (this is called
	from #initialise with a list of classes derived from #encryptedPackageNames)."

	encryptedClasses := aCollectionOfClasses.!

encryptedPackageNames
	"Answer a <Set> of Package names associated with the receiver that must be encrypted
	when the receiver is installed"

	| encrypted |
	encrypted := self contents select: [:each | (each at: 2) == #encrypted].
	^encrypted collect: [:each | File splitStemFrom: (each at: 1)]!

foldLiterals
	Class foldLiterals!

fullName
	"Answer the full product name associated with the receiver"

	^self subclassResponsibility!

installProductDetails
	"Private - Informs the development system of the details of the receiver"

	SessionManager current productDetails: self productDetails!

installProductSounds
	"Private - Installs the sounds scheme for the receiver"

	Sound clearRegistry!

installSplash
	"Use the default"!

installSystemFolderOptions
	#{SmalltalkSystemShell} ifDefined: [:systemFolder | self installSystemFolderOptions: systemFolder]!

installSystemFolderOptions: systemFolder
	systemFolder
		defaultExtent: (self calcSystemFolderExtentFor: self defaultSystemFolderExtent);
		backcolor: self defaultSystemFolderColor!

isSafeToEncrypt: aClass
	"Private -- Answer whether it is safe to encrypt the given class.
	Classes that must not be encrypted are this session manager's
	class, our serial number class, and our product protection class.
	This list is not intended to be exhaustive but just to catch the
	cases that occur easily if some attempts to product protect
	the package containing the protected session manager."

	^ (aClass respondsTo: #isSafeToEncryptWithProductProtection)
		ifTrue: [aClass isSafeToEncryptWithProductProtection]
		ifFalse: ["presumably its OK" ^ true].!

load
	"Loads the required packages into the image for the receiver. Does not remove any
	packages that should not be present"

	self basicLoad.
	SessionManager current saveImage!

loadAndShrink
	"Loads the required packages into the image for the receiver. Also shrinks the image
	to remove packages that should not be present but does not compress the sources or save the image."

	self
		basicLoad;
		removeUnlistedPackages!

loadShrinkAndCompress
	"Loads the required packages into the image for the receiver. Also shrinks the image
	to remove packages that should not be present. Finishes up with a compress sources."

	self
		basicLoad;
		shrink.
	SourceManager default compressSources!

majorVersion
	"Answer the receiver's major version <Integer>"

	^version major!

minorVersion
	"Answer the receiver's minor version <Integer>"

	^version minor!

name
	"Answer the product name associated with the receiver"

	^self class productName!

packageNames
	"Answer the list of package names associated with the receiver"

	^self packagePaths collect: [:each | File splitStemFrom: each]!

packagePaths
	"Answer the list of package path names associated with the receiver"

	^self contents collect: [:each | each at: 1 ]!

packages
	"Answer the list of package associated with the receiver"

	^self packageNames collect: [:each | Package manager packageNamed: each]!

preShrink
	"Private - Perform any pre-shrinkage actions"!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: self name;
		nextPutAll: ', ''';
		display: self version;
		nextPutAll: ''')'!

productDetails
	"Answers the product details for the receiver"

	^VM defaultProductDetails
		at: #productName put: self fullName;
		at: #shortProductName put: self name;
		at: #productVersionString put: self version displayString;
		at: #abbreviatedProductName put: self shortProductName;
		yourself!

removeUnlistedPackages
	"Private - Removes the non-required packages from the image for the receiver. "

	| unwanted |
	unwanted := Package manager packages difference: self packages.
	unwanted do: [:each | self uninstallPackage: each]!

resizeSymbolTable
	Symbol resizeTable	"Resize the symbol table to suit the size of the development product."!

shortProductName
	"Answer the abbreviated product name"
	
	^self class shortProductName!

shouldEncryptMetaclasses
	"Answer whether we should encrypt the class-side methods of our protected classes."

	^false!

shrink
	"Removes the non-required packages from the image for the receiver. "

	self preShrink.
	self warnOfUnlistedContent.
	self removeUnlistedPackages.
	self shrinkEventsRegister.
	self shrinkHashedCollections.
	self foldLiterals.
	"Resize the symbol table to suit the size of the development product."
	self resizeSymbolTable!

shrinkEventsRegister
	_EventsRegister keys do: [:each | each setEvents: each getEvents shrink]!

shrinkHashedCollections
	Set primAllSubinstances do: [:each | each shrink]!

uninstallPackage: each 
	^each uninstall!

unlistedContentException
	^Error!

unlistedPrerequisites
	| all listed |
	all := self allPackages.
	listed := self packages.
	^all difference: listed!

unwantedClasses
	"Answer a collection of the names of classes that are (or might) be in the distributed packages, but which we don't
	want included in the actual distributions."

	^#(#BootSessionManager #DolphinOAEdition)!

version
	"Answer a `SemVer` describing the receiver's version."

	^version!

version: aSemVer
	version := aSemVer!

warnOfUnlistedContent
! !

!Tools.DolphinProduct categoriesForMethods!
allPackages!accessing!public! !
basicLoad!operations!private! !
beCurrent!operations!public! !
boot!operations!private! !
calcSystemFolderExtentFor:!helpers!private! !
contents!accessing!public! !
defaultSystemFolderColor!constants!private! !
defaultSystemFolderExtent!constants!private! !
diskBasedPackages!accessing!private! !
displayOn:!printing!public! !
encryptedClasses!accessing!public! !
encryptedClasses:!accessing!private! !
encryptedPackageNames!accessing!public! !
foldLiterals!private! !
fullName!accessing!public! !
installProductDetails!operations!private! !
installProductSounds!operations!private! !
installSplash!private! !
installSystemFolderOptions!operations!private! !
installSystemFolderOptions:!private! !
isSafeToEncrypt:!operations!public! !
load!operations!public! !
loadAndShrink!operations!public! !
loadShrinkAndCompress!operations!public! !
majorVersion!accessing!public! !
minorVersion!accessing!public! !
name!accessing!public! !
packageNames!accessing!public! !
packagePaths!accessing!public! !
packages!accessing!public! !
preShrink!private! !
printOn:!printing!public! !
productDetails!accessing!public! !
removeUnlistedPackages!operations!private! !
resizeSymbolTable!operations!public! !
shortProductName!accessing!public! !
shouldEncryptMetaclasses!constants!public!testing! !
shrink!operations!public! !
shrinkEventsRegister!operations!private! !
shrinkHashedCollections!operations!private! !
uninstallPackage:!operations!private! !
unlistedContentException!operations!public! !
unlistedPrerequisites!public! !
unwantedClasses!constants!public! !
version!accessing!public! !
version:!private! !
warnOfUnlistedContent!operations!private! !
!

!Tools.DolphinProduct class methodsFor!

boot
	"Loads an instance of the receiver"

	self new boot!

current
	"Answer the singleton instance which represents the current product level of this image"

	^Current!

errorInvalidProductDescription: aString
	^self error: 'Invalid product description: ', aString!

fromString: aString
	"Answer an instance of the subclass from the <readableString> description, aString"

	| stm version sub |
	(aString beginsWith: self productPrefix) ifFalse: [self errorInvalidProductDescription: aString].
	stm := aString readStream.
	stm position: self productPrefix size + 1.
	version := SemVer readFrom: stm.
	version ifNil: [self errorInvalidProductDescription: aString].
	stm skipSeparators.
	sub := stm upToEnd.
	^(EditionsMap at: sub) version: version!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk developmentSystem icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	EditionsMap := LookupTable new.
	DolphinBaseProduct allSubclasses do: [:p | EditionsMap at: p productName put: p].
	EditionsMap shrink!

loadAndShrink
	"Makes the image an instance of the receiver"

	self new loadAndShrink!

new
	"Answers an instance of the receiver for this version of Dolphin"

	^self version: SessionManager current productVersion!

packages: wildcard under: directory encrypted: aBoolean
	| base answer |
	answer := OrderedCollection new.
	base := SessionManager current imageBase.
	File
		forAll: wildcard
		in: (File composePath: base subPath: directory)
		do: 
			[:each |
			answer add: {File relativePathOf: each path to: base.
						aBoolean ifTrue: [#encrypted] ifFalse: [#plain].
						#imageBased}].
	^answer!

pacsUnder: directory encrypted: aBoolean 
	"Note that the order won't be right, but this doesn't really matter since the package loaders prerequisites
	mechanism will load things in the right order anyway."

	^self 
		packages: '*.pac'
		under: directory
		encrypted: aBoolean!

paxesUnder: directory encrypted: aBoolean 
	"Note that the order won't be right, but this doesn't really matter since the package loaders prerequisites
	mechanism will load things in the right order anyway."

	^self 
		packages: '*.pax'
		under: directory
		encrypted: aBoolean!

productName
	"Answer the product name"
	
	^self subclassResponsibility!

productPrefix
	"Answer the prefix common to all product names."

	^'Dolphin Smalltalk'!

release
	"Release an instance of the receiver"

	self new release!

shortProductName
	"Answer the abbreviated product name"
	
	^self subclassResponsibility!

version: aSemVer
	"Answers an instance of the receiver with `SemVer` version"

	^self basicNew
		version: aSemVer;
		yourself! !

!Tools.DolphinProduct class categoriesForMethods!
boot!operations!public! !
current!accessing!public! !
errorInvalidProductDescription:!exceptions!public! !
fromString:!instance creation!public! !
icon!constants!public! !
initialize!initializing!private! !
loadAndShrink!operations!public! !
new!instance creation!public! !
packages:under:encrypted:!private! !
pacsUnder:encrypted:!private! !
paxesUnder:encrypted:!private! !
productName!accessing!public! !
productPrefix!instance creation!public! !
release!operations!public! !
shortProductName!accessing!public! !
version:!instance creation!public! !
!

