"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.FileLocatorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.FileLocatorTest guid: (Core.GUID fromString: '{635f7234-ba5a-4a72-97b1-40d81990cad7}')!

Core.Tests.FileLocatorTest comment: ''!

!Core.Tests.FileLocatorTest methodsFor!

testAbsoluteFileLocator
	| locator workingDir relative absolute dir |
	locator := FileLocator absolute.
	self assert: locator isSelfEvaluating.
	self assert: (Compiler evaluate: locator printString) equals: locator.
	dir := OS.Kernel32 getCurrentDirectory.
	workingDir := Path fromString: (dir lastCodeUnit == $\ ifTrue: [dir] ifFalse: [dir , '\']).
	absolute := SessionManager current imageFileName asPath.
	relative := absolute relativeTo: workingDir.
	self assert: (locator abstract: relative) equals: absolute asString.
	"Doesn't perform any translation to local file spec (which is really the request for the locator to map from a path in its minimal form back to the full path of the file, i.e. translate from locator namespace to global namespace)"
	self assert: (locator resolve: absolute) equals: absolute!

testImageRelativeFileLocator
	| locator relative fullpath |
	locator := FileLocator imageRelative.
	self assert: locator isSelfEvaluating.
	self assert: (Compiler evaluate: locator printString) equals: locator.

	"File in base directory."
	fullpath := SessionManager current imageBase \ 'dolphin.img'.
	relative := locator abstract: fullpath.
	self assert: relative asString equals: 'dolphin.img'.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in sub-directory"
	fullpath := SessionManager current imageBase \ 'backup\dolphin.img'.
	relative := locator abstract: fullpath.
	self assert: relative equals: 'backup\dolphin.img'.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in parent directory"
	fullpath := SessionManager current imageBase asPath combinedWith: '..\dolphin.img'.
	relative := locator abstract: fullpath.
	self assert: relative equals: fullpath asString.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in sibling directory"
	fullpath := (SessionManager current imageBase \ '..\dolphin4\dolphin.img') canonicalized.
	relative := locator abstract: fullpath.
	self assert: relative equals: fullpath asString.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in different hierarchy - should use absolute path"
	fullpath := 'd:\blah\blah.txt'.
	relative := locator abstract: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator resolve: relative) path equals: fullpath.

	"File in different drive - should use absolute path"
	fullpath := 'c:\winnt\system32\user32.dll'.
	relative := locator abstract: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator resolve: relative) path equals: fullpath!

testInstallRelativeFileLocator
	| locator relative fullpath base |
	locator := FileLocator installRelative.
	self assert: locator isSelfEvaluating.
	self assert: (Compiler evaluate: locator printString) equals: locator.

	"File in base directory."
	base := SessionManager current installationDirectory.
	fullpath := base \ 'dolphin.img'.
	relative := locator abstract: fullpath.
	self assert: relative equals: 'dolphin.img'.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in sub-directory"
	fullpath := base \ 'backup\dolphin.img'.
	relative := locator abstract: fullpath.
	self assert: relative equals: 'backup\dolphin.img'.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in parent directory"
	fullpath := (SessionManager current imageBase \ '..\dolphin.img') canonicalized.
	relative := locator abstract: fullpath.
	self assert: relative asPath equals: fullpath.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in sibling directory"
	fullpath := SessionManager current imageBase asPath combinedWith: '..\dolphin4\dolphin.img'.
	relative := locator abstract: fullpath.
	self assert: relative asPath equals: fullpath.
	self assert: (locator resolve: relative) equals: fullpath.

	"File in different hierarchy - should use absolute path"
	fullpath := 'd:\blah\blah.txt'.
	relative := locator abstract: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator resolve: relative) path equals: fullpath.

	"File in different drive - should use absolute path"
	fullpath := 'c:\winnt\system32\user32.dll'.
	relative := locator abstract: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator resolve: relative) path equals: fullpath! !

!Core.Tests.FileLocatorTest categoriesForMethods!
testAbsoluteFileLocator!public!unit tests! !
testImageRelativeFileLocator!public!unit tests! !
testInstallRelativeFileLocator!public!unit tests! !
!

