"Filed out from Dolphin Smalltalk"!

SelectableItemsTest subclass: #PackageSelectorTest
	instanceVariableNames: 'packageA'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PackageSelectorTest guid: (GUID fromString: '{eb6a3732-7f1e-4c12-b050-6446fcbde374}')!

PackageSelectorTest comment: ''!

!PackageSelectorTest categoriesForClass!Unclassified! !

!PackageSelectorTest methodsFor!

classToTest
	^PackageSelector!

createPackage: name 
	^Package manager newPackage: name!

removePackage: aPackage 
	Package manager removePackage: aPackage!

tearDown
	packageA notNil ifTrue: [self removePackage: packageA].
	super tearDown!

testFilter
	"Check that with no filter selected, there are no selected packages"

	self assertIsNil: presenter filter.
	self assert: presenter packages isEmpty.
	self assert: presenter selections isEmpty.

	"Now select the root folder, check that we are filled with all packages"
	presenter autoSelect: false.
	presenter selectRootFolder.
	self assert: presenter packagesPresenter list asSet equals: Package manager packages asSet.

	"With auto select off, the selections should be made automatically"
	self deny: presenter autoSelect.
	presenter selectRootFolder.
	self assert: presenter selections isEmpty.

	"With auto select on, the selections should be made automatically"
	presenter autoSelect: true.
	presenter
		selectNoFolder;
		selectRootFolder.
	self assert: presenter autoSelect.
	self assert: presenter selections asSet equals: Package manager packages asSet!

viewClass
	^ContainerView! !

!PackageSelectorTest categoriesForMethods!
classToTest!helpers!private! !
createPackage:!helpers!private! !
removePackage:!helpers!private! !
tearDown!private! !
testFilter!public! !
viewClass!constants!private! !
!

!PackageSelectorTest class methodsFor!

resource_Choice_view_D6
	"Answer the literal data from which the 'Choice view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Choice_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 608 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 9 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 850 1 882 8 #newPackage 8 '&New Package...' 1 1 0 0 0 850 1 882 8 #savePackages 8 '&Save' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FileSave.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 850 1 882 8 #savePackageAs 8 'Save &As...' 1 1 0 0 0 802 0 16 98 10 850 1 882 8 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 0 0 0 850 1 882 8 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 946 4097 850 1 882 8 #checkOut 8 'Check Out &All' 1 1 0 0 0 850 1 882 8 #checkOutChanges 8 'Check &Out Changes' 1 1 0 0 0 850 1 882 8 #checkIn 8 'Check &In' 1 1 0 0 0 946 4097 850 2097153 882 8 #savePackageChanges 8 'Save &Changes' 1 1 0 0 0 946 4097 850 1 882 8 #resetChangeFlags 8 'Clear Change &Markers' 1 1 0 0 0 8 'Sou&rce Control' 8 #sourceControlMenu 1 0 0 0 0 0 946 4097 850 1 882 8 #inspectPackage 8 '&Properties' 1 1 1106 0 16 1152 8 'SMALLTALKOPTIONSFOLDER.ICO' 1200 0 0 850 1 882 8 #aboutPackage 8 'Abou&t this Package...' 1 1 0 0 0 8 '&Package' 0 134217729 0 0 0 0 0 0 0 608 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #name 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 2192 7 257 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 41 8 #left 0 2178 0 0 2210 3 1 2240 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 2464 7 513 0 2066 8 #isChanged 98 0 0 608 2178 0 0 2210 4 1 2240 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 8 #imageIndex 2624 7 257 0 1 0 0 2402 8 'Packages' 689 2448 8 ##(Smalltalk.BasicListAbstract)  2178 0 0 2210 2 1 2240 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 2096 2848 7 513 0 0 0 608 2128 3 0 2178 0 0 2210 5 1 2240 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2304 2320 2336 2352 2928 7 257 0 8 #report 736 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 237 3154 737 229 608 3090 8 #contextMenu: 98 1 816 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 118 0 0 0 112 1 0 0 232 0 0 0] 98 0 3154 193 193 0 27 3 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916259 1025 3328 590918 3 ##(Smalltalk.TreeModel)  0 768 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 736 498 528 0 5 802 0 16 98 1 850 1 882 1008 8 '&New Package...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3328 0 8 4294903619 2832 2128 2160 0 0 0 0 0 234 240 736 17 8 #smallIcons 1 0 3026 202 208 98 2 3090 3120 98 2 3154 1 1 3154 737 227 3328 3090 3216 98 1 3504 3328 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 1 0 0 113 0 0 0] 98 0 3312 0 27 3 16 234 256 98 4 608 8 'packages' 3328 8 'filter' 0 3026 202 208 98 1 3090 3120 98 2 3154 2799 21 3154 737 465 416 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 231 6 0 0 242 0 0 0] 98 3 3328 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 4064 0 498 528 0 517 0 0 0 4064 3026 202 208 98 1 3090 3120 98 2 3154 1 227 3154 737 11 4064 3250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 113 0 0 0 112 1 0 0 118 0 0 0] 98 0 3312 0 27 608 3312 0 27 )!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 21 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920393 1 608 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 29 265030 4 ##(Smalltalk.Menu)  0 16 98 24 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #newPackage 8 '&New Package...' 1 1 0 0 0 850 1 882 8 #openPackage 8 '&Install Package...' 1 1 0 0 0 850 1 882 8 #removePackage 8 '&Uninstall Package' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 802 0 16 98 2 850 2097153 882 8 #addClass 8 '&Class...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'Class.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 850 1 882 8 #addGlobal 8 '&Global...' 1 1 0 0 0 8 'Add Unco&mmitted' 8 #addMenu 134217729 0 0 0 0 0 850 1 882 8 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 0 0 0 850 1 882 8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 1074 4097 850 1 882 8 #savePackages 8 '&Save Package' 1 1 1202 0 16 1248 8 'FileSave.ico' 1296 0 0 850 1 882 8 #savePackageChanges 8 'Save Package C&hanges' 1 1 0 0 0 850 1 882 8 #savePackageAs 8 'Save Package &As...' 1 1 0 0 0 1074 4097 850 1 882 8 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 0 0 0 850 1 882 8 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 1074 4097 850 1 882 8 #loadPackageFromRepository 8 'Load Edition...' 1 1 0 0 0 850 1 882 8 #importPackageFromFile 8 'Import to Repository...' 1 5 0 0 0 850 1 882 8 #versionPackage 8 'Version...' 1 1 0 0 0 850 1 882 8 #browsePackageEditions 8 'Browse Editions' 1 1 0 0 0 850 1 882 8 #compareWithAnotherEdition 8 'Compare with...' 1 1 0 0 0 1074 4097 802 0 16 98 4 850 2097153 882 8 #deploy 8 '&Deploy Executable...' 13445 1 0 0 0 850 1 882 8 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 0 0 0 1074 4097 850 1 882 8 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 0 0 0 8 '&Deployment' 0 134217729 1202 0 16 1248 8 'ApplicationDeploymentWizard.ico' 1296 0 0 0 0 1074 4097 850 1 882 8 #inspectPackage 8 'P&roperties' 1 1 1202 0 16 1248 8 'SMALLTALKOPTIONSFOLDER.ICO' 1296 0 0 8 '&Package' 0 134217729 0 0 0 0 0 0 0 608 0 8 4294902131 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 2800 7 257 0 328198 ##(Smalltalk.Point)  65 65 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Packages' 669 8 #left 2720 2786 0 0 2818 2 1 2848 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 8 #name 3104 7 513 0 0 0 608 2736 3 0 2786 0 0 2818 5 1 2848 8 'doIt' 8 '[:ctx | 
ctx item isDefaultPackage ifTrue: [
	ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2912 2928 2944 2960 3200 7 257 0 3042 8 '' 33 3088 2786 0 0 2818 3 1 2848 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 3312 7 257 0 2786 0 0 2818 3 1 2848 8 'doIt' 8 '[:x : y | x & y not]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 3424 7 513 0 459270 ##(Smalltalk.Message)  8 #isChanged 98 0 0 608 2786 0 0 2818 6 1 2848 8 'doIt' 8 '[:x | (x ifTrue: [Package changedIcon] ifFalse: [Icon blank]) imageIndex]' 8 #[34 105 17 120 45 159 111 47 161 162 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 3682 8 #Icon 1200 8 #blank 8 #imageIndex 3600 7 257 0 1 0 0 8 #report 736 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 4 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 2978 1 221 2978 701 281 608 3906 8 #contextMenu: 98 1 816 608 3906 8 #text: 98 1 8 'Packages' 608 3906 8 #columnOrder: 98 1 98 2 5 3 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 110 0 0 0 94 1 0 0 250 0 0 0] 98 0 2978 193 193 0 27 9 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916259 1 4256 590918 3 ##(Smalltalk.TreeModel)  0 768 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 736 498 528 0 29 802 0 16 98 2 850 1 882 8 #browseFolder 8 '&Browse Folder' 1 1 0 0 0 850 1 882 912 8 '&New Package...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4256 0 8 4294902319 2720 2736 2768 0 0 0 0 0 234 240 736 17 8 #smallIcons 1 0 3842 202 208 98 2 3906 3936 98 2 2978 1 1 2978 701 211 4256 3906 4016 98 1 4432 4256 4178 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 105 0 0 0] 98 0 4240 0 27 7 16 234 256 98 4 608 8 'packages' 4256 8 'filter' 0 3842 202 208 98 1 3906 3936 98 2 2978 3839 21 2978 701 501 416 4178 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 3 4256 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 5056 0 498 528 0 517 0 0 0 5056 3842 202 208 98 1 3906 3936 98 2 2978 1 211 2978 701 11 5056 4178 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 0 0 0 94 1 0 0 110 0 0 0] 98 0 4240 0 27 608 4240 0 27 )!

resource_Single_package_selector_D6
	"Answer the literal data from which the 'Single package selector' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Single_package_selector)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 21 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920397 1025 608 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 528 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 19 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 850 1 882 8 #setAsDefaultPackage 8 'Set as De&fault Package' 1 1 0 0 0 802 0 16 98 2 850 2097153 882 8 #addClass 8 '&Class...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'Class.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 850 1 882 8 #addGlobal 8 '&Global...' 1 1 0 0 0 8 'Add Unco&mmitted' 8 #addMenu 134217729 0 0 0 0 0 946 4097 850 1 882 8 #newPackage 8 '&New Package...' 1 1 0 0 0 850 1 882 8 #openPackage 8 '&Install Package...' 1 1 0 0 0 850 1 882 8 #removePackage 8 '&Uninstall' 1 1 0 0 0 946 4097 850 1 882 8 #savePackages 8 '&Save' 1 1 1138 0 16 1184 8 'FileSave.ico' 1232 0 0 850 1 882 8 #savePackageAs 8 'Save &As...' 1 1 0 0 0 946 4097 802 0 16 98 10 850 1 882 8 #toggleUsingPAX 8 'Use PA&X Source Format' 1 1 0 0 0 850 2097153 882 8 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 946 4097 850 1 882 8 #checkOut 8 'Check Out &All' 1 1 0 0 0 850 1 882 8 #checkOutChanges 8 'Check &Out Changes' 1 1 0 0 0 850 1 882 8 #checkIn 8 'Check &In' 1 1 0 0 0 946 4097 850 1 882 8 #savePackageChanges 8 'Save &Changes' 1 1 0 0 0 946 4097 850 1 882 8 #resetChangeFlags 8 'Clear Change &Markers' 1 1 0 0 0 8 'Sou&rce Control' 8 #sourceControlMenu 1 0 0 0 0 0 946 4097 850 1 882 8 #deploy 8 '&Deploy Executable...' 1 1 0 0 0 850 1 882 8 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 0 0 0 946 4097 850 1 882 8 #inspectPackage 8 '&Properties' 1 1 1138 0 16 1184 8 'SMALLTALKOPTIONSFOLDER.ICO' 1232 0 0 850 1 882 8 #aboutPackage 8 'Abou&t this Package...' 1 1 0 0 0 8 '&Package' 0 134217729 0 0 0 0 0 0 0 608 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #name 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 8 #item 8 #isDefaultPackage 8 #font 8 #beBold 2800 7 257 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 41 8 #left 0 2786 0 0 2818 3 1 2848 8 'doIt' 8 '[:x : y | x & y not ]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 3072 7 513 0 2674 8 #isChanged 98 0 0 608 2786 0 0 2818 4 1 2848 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #changedIcon 8 #imageIndex 3232 7 257 0 1 0 0 3010 8 'Packages' 653 3056 8 ##(Smalltalk.BasicListAbstract)  2786 0 0 2818 2 1 2848 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 2704 3456 7 513 0 0 0 608 2736 3 0 2786 0 0 2818 5 1 2848 8 'doIt' 8 '[:ctx | ctx item isDefaultPackage ifTrue: [ctx font beBold]]' 8 #[33 105 17 158 159 121 17 160 161 106 60 106] 2912 2928 2944 2960 3536 7 257 0 8 #report 736 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 173 3762 701 329 608 3698 8 #contextMenu: 98 1 816 608 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 86 0 0 0 94 1 0 0 250 0 0 0] 98 0 3762 193 193 0 27 5 410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916259 1025 3936 590918 3 ##(Smalltalk.TreeModel)  0 768 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 736 498 528 0 5 802 0 16 98 1 850 1 882 1408 8 '&New Package...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3936 0 8 4294903619 3440 2736 2768 0 0 0 0 0 234 240 736 17 8 #smallIcons 1 0 3634 202 208 98 2 3698 3728 98 2 3762 1 1 3762 701 163 3936 3698 3824 98 1 4112 3936 3858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 81 0 0 0] 98 0 3920 0 27 3 16 234 256 98 4 608 8 'packages' 3936 8 'filter' 0 3634 202 208 98 1 3698 3728 98 2 3762 2799 21 3762 701 501 416 3858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 4 1 0 0] 98 3 3936 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 4672 0 498 528 0 517 0 0 0 4672 3634 202 208 98 1 3698 3728 98 2 3762 1 163 3762 701 11 4672 3858 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 81 0 0 0 94 1 0 0 86 0 0 0] 98 0 3920 0 27 608 3920 0 27 )! !

!PackageSelectorTest class categoriesForMethods!
resource_Choice_view_D6!constants!public! !
resource_Default_view_D6!constants!public! !
resource_Single_package_selector_D6!constants!public! !
!

